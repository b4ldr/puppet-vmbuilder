#
#
class vmbuilder::hypervisor::kvm (
  String           $libvirt_uri,
  Boolean          $virtio_net,
  Integer[32]      $default_mem,
  Integer[1]       $default_cpus,
  Optional[String] $default_bridge,
  Optional[String] $default_network,
) {
  include vmbuilder
  $conf_file = $vmbuilder::conf_file
  $ini_defaults = { 'path' => $conf_file, }
  $_default_bridge = $default_bridge ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_bridge,
  }
  $_default_network = $default_network ? {
    undef   => { 'ensure' => 'absent' },
    default => $default_network,
  }
  $ini_settings = {
    'kvm' => {
      'libvirt'    => $libvirt_uri,
      'virtio_net' => $virtio_net,
      'mem'        => $default_mem,
      'cpus'       => $default_cpus,
      'bridge'     => $_default_bridge,
      'network'    => $_default_network,
    },
  }
  create_ini_settings($ini_settings, $ini_defaults)
}
