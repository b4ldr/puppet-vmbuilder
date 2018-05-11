#
#
class vmbuilder (
  String                         $package,
  Stdlib::Absolutepath           $conf_file,
  String                         $command,
  Stdlib::Absolutepath           $destination_base,
  String                         $default_arch,
  Stdlib::Host                   $default_domain,
  Stdlib::Ipv4                   $default_network,
  Stdlib::Ipv4                   $default_netmask,
  String                         $default_name,
  String                         $default_username,
  String                         $default_password,
  Array[Vmbuilder::Hypervisor]   $hypervisors,
  Array[Vmbuilder::Distro]       $distros,
  Optional[Stdlib::Ipv4]         $default_broadcast,
  Optional[Stdlib::Ipv4]         $default_gateway,
  Optional[Stdlib::Ipv4]         $default_dns,
  Optional[Stdlib::Absolutepath] $default_firstboot,
  Optional[Stdlib::Absolutepath] $default_firstlogin,
  Optional[Stdlib::Absolutepath] $default_execscript,
  Optional[Hash]                 $hosts,
) {
  ensure_packages([$package])
  file {$conf_file:
    ensure => file,
  }
  $_default_broadcast = $default_broadcast ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_broadcast,
  }
  $_default_gateway = $default_gateway ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_gateway,
  }
  $_default_dns = $default_dns ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_dns,
  }
  $_default_fisrtboot = $default_firstboot ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_firstboot,
  }
  $_default_fisrtlogin = $default_firstlogin ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_firstlogin,
  }
  $_default_execscript = $default_execscript ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_execscript,
  }
  $ini_defaults = { 'path' => $conf_file, }
  $ini_settings = {
    'DEFAULT' => {
      'arch'       => $default_arch,
      'domain'     => $default_domain,
      'mask'       => $default_netmask,
      'net'        => $default_network,
      'name'       => $default_name,
      'username'   => $default_username,
      'pass'       => $default_password,
      'bcast'      => $_default_broadcast,
      'gw'         => $_default_gateway,
      'dns'        => $_default_dns,
      'firstboot'  => $_default_fisrtboot,
      'firstlogin' => $_default_fisrtlogin,
      'execscript' => $_default_execscript,
    },
  }
  create_ini_settings($ini_settings, $ini_defaults)
  $hypervisors.each |String $hypervisor| {
    include "vmbuilder::hypervisor::${hypervisor}"
  }
  $distros.each |String $distro| {
    include "vmbuilder::distro::${distro}"
  }
  if $hosts {
    create_resources(vmbuilder::host, $hosts)
  }
}
