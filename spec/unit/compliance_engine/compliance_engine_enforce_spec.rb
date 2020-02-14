require 'spec_helper'

# Remove v1 data. Can be removed once compliance_markup::debug::enabled_sce_versions is implemented
v1_profiles = './spec/fixtures/modules/compliance_markup/data/compliance_profiles'
FileUtils.rm_rf(v1_profiles) if File.directory?(v1_profiles)

# This is the class that needs to be added to the catalog last to make the
# reporting work.
describe 'compliance_markup', type: :class do

  compliance_profiles = [
    'disa_stig',
    'nist_800_53:rev4'
  ]

  # A list of classes that we expect to be included for compliance
  #
  # This needs to be well defined since we can also manipulate defined type
  # defaults
  expected_classes = [
    'simp',
    'simp::server',
    'simp::pam_limits::max_logins'
  ]

  # regex to match any resource or resource parameter NOT under test
  not_expected_classes_regex = Regexp.new(
    "^((?!(#{expected_classes.join("|")})(::.*)?)|(#{expected_classes.join("|")})(?!::).+)"
  )

  compliance_profiles = {
    'disa_stig'        => {
      :percent_compliant   => 100,
      :exceptions => {
        'documented_missing_parameters' => [ not_expected_classes_regex ],
        'documented_missing_resources'  => [ not_expected_classes_regex ],
        'non_compliant'                 => {}
      }
    },
    'nist_800_53:rev4' => {
      :percent_compliant   => 100,
      :exceptions => {
        'documented_missing_parameters' => [ not_expected_classes_regex ],
        'documented_missing_resources'  => [ not_expected_classes_regex ],
        'non_compliant'                 => {
          # compliance_engine is not smart enough, yet, to allow compliance to
          # be determined by anything other than an exact match to parameter
          # content. In this case, all we want to ensure is that 'EC2' appears
          # in facts.blocklist element of pupmod::facter_options. We don't
          # actually care what else is in that configuration Hash.  So, the
          # 'non_compliant' report is a false alarm for pupmod::facter_options.
          'Class[Pupmod]' => [ 'facter_options' ]
        }
      }
    }
  }

  on_supported_os.each do |os, os_facts|
    next if os_facts[:kernel] == 'windows'

    if ENV['RSPEC_COMPLIANCE_ENGINE_OS']
      next unless os.match?(Regexp.new(ENV['RSPEC_COMPLIANCE_ENGINE_OS']))
    end

    context "on #{os}" do
      compliance_profiles.each do |target_profile, info|
        context "with compliance profile '#{target_profile}'" do
          let(:facts){
            os_facts.merge({
              :target_compliance_profile => target_profile
            })
          }

          let(:pre_condition) {%(
            #{expected_classes.map{|c| %{include #{c}}}.join("\n")}
          )}

          let(:hieradata){ 'compliance-engine' }

          it { is_expected.to compile }

          let(:compliance_report) {
            @compliance_report ||= JSON.load(
                catalogue.resource("File[#{facts[:puppet_vardir]}/compliance_report.json]")[:content]
              )

            @compliance_report
          }

          let(:compliance_profile_data) {
            @compliance_profile_data ||= compliance_report['compliance_profiles'][target_profile]

            @compliance_profile_data
          }

          it 'should have a compliance profile report' do
            expect(compliance_profile_data).to_not be_nil
          end

          it "should have a #{info[:percent_compliant]}% compliant report" do
            expect(compliance_profile_data['summary']['percent_compliant'])
              .to eq(info[:percent_compliant])
          end

          # The list of report sections that should not exist and if they do
          # exist, we need to know what is wrong so that we can fix them
          report_validators = [
            # This should *always* be empty on enforcement
            'non_compliant',
            # If something is set here, either the upstream API changed or you
            # have a typo in your data
            'documented_missing_parameters',
            # If something is set here, you have included enforcement data that
            # you are not testing so you either need to remove it from your
            # profile or you need to add the class/defined type for validation
            #
            # Unless this is a completely comprehensive data profile, with all
            # classes included, this report may be useless and is disabled by
            # default.
            #
            'documented_missing_resources'
          ]

          report_validators.each do |report_section|
            it "should have no issues with the '#{report_section}' report" do

              if compliance_profile_data[report_section]
                # remove any false alarms from compliance results
                normalized = normalize_compliance_results(
                  compliance_profile_data,
                  report_section,
                  info[:exceptions])

                expect(normalized[report_section]).to be_empty
              end
            end

          end
        end
      end
    end
  end
end
