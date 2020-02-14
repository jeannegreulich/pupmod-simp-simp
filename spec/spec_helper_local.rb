def normalize_compliance_results(compliance_profile_data, section, exceptions)
  normalized = Marshal.load(Marshal.dump(compliance_profile_data))
  if section == 'non_compliant'
    exceptions['non_compliant'].each do |resource,params|
      params.each do |param|
        if normalized['non_compliant'].key?(resource) &&
            normalized['non_compliant'][resource]['parameters'].key?(param)
          normalized['non_compliant'][resource]['parameters'].delete(param)
          if normalized['non_compliant'][resource]['parameters'].empty?
            normalized['non_compliant'].delete(resource)
          end
        end
      end
    end
  else
    normalized[section].delete_if do |item|
      rm = false
      Array(exceptions[section]).each do |allowed|
        if allowed.is_a?(Regexp)
          if allowed.match?(item)
            rm = true
            break
          end
        else
          rm = (allowed == item)
        end
      end
      rm
    end
  end

  normalized
end
