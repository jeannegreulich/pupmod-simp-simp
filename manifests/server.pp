# @summary Set up a SIMP server in such a way that it will be ready to serve
# configuration data appropriately to your clients.
#
# @param allow_simp_user
#   Ensure that the ``simp`` user can login to the system
#
# @param pam
#   Enable SIMP management of the PAM stack
#
# @param clamav
#   The simp_options::clamav catalyst has been deprecated and will be removed
#   from future releases of simp.  To manage ClamAV use the pupmod-simp-clamav
#   module.  It has been left here for backwards compatibility.
#
#   Enable SIMP management of Antivirus
#
# @param auditd
#   Enable SIMP management of auditing
#
# @param scenario
#   The SIMP scenario to apply to the server
#
#   * It is **not advised** to change this from ``simp``
#
# @param classes
#   Additional classes to include on the server in addition to those included
#   in the ``scenario``
#
# @param scenario_map
#   An **internal** parameter used for determining the correct classes to apply
#   for the ``scenario``
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class simp::server (
  Hash[String, Array] $scenario_map,
  Boolean             $allow_simp_user = false,
  Boolean             $pam             = simplib::lookup('simp_options::pam', { 'default_value' => false }),
  Boolean             $clamav          = simplib::lookup('simp_options::clamav', { 'default_value' => false }),
  Boolean             $auditd          = simplib::lookup('simp_options::auditd', { 'default_value' => false }),
  String              $scenario        = simplib::lookup('simp::scenario', { 'default_value' => 'simp' }),
  Array[String]       $classes         = []
) {

  simplib::module_metadata::assert($module_name, { 'blacklist' => ['Windows'] })

  if $scenario_map.has_key($scenario) {
    include simp::knockout(
      union(
        $scenario_map[$scenario],
        $classes,
      )
    )
  } else {
    fail("ERROR - Invalid scenario '${scenario}' for the given scenario map.")
  }

  # This setting will be removed from future releases of simp.
  # See the  pupmod-simp-clamav module for information on how manage ClamAV
  if $clamav  { include 'clamav' }

  if $auditd  { include 'auditd' }

  if $allow_simp_user {
    if $pam {
      include 'pam'

      pam::access::rule { 'allow_simp':
        users   => ['simp'],
        origins => ['ALL'],
        comment => 'The SIMP user, used to remotely login to the system in the case of a lockout.'
      }
    }

    sudo::user_specification { 'default_simp':
      user_list => ['simp'],
      runas     => 'root',
      cmnd      => ['/bin/su root', '/bin/su - root']
    }
  }
}
