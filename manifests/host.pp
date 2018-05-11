#
#
define vmbuilder::host (
  Stdlib::Ipv4                    $ip,
  Vmbuilder::Hypervisor           $hypervisor   = kvm,
  Vmbuilder::Distro               $distro       = 'ubuntu',
  Interger[0]                     $timeout      = 0,
  Optional[Stdlib::Host]          $hostname     = undef,
  Optional[Stdlib::Absolutepath]  $destination  = undef,
  Optional[String]                $arch         = undef,
  Optional[Stdlib::Host]          $domain       = undef,
  Optional[Stdlib::Ipv4]          $network      = undef,
  Optional[Stdlib::Ipv4]          $netmask      = undef,
  Optional[Stdlib::Ipv4]          $broadcast    = undef,
  Optional[Stdlib::Ipv4]          $gateway      = undef,
  Optional[String]                $realname     = undef,
  Optional[String]                $username     = undef,
  Optional[String]                $password     = undef,
  Optional[Stdlib::Ipv4]          $dns          = undef,
  Optional[Stdlib::Absolutepath]  $firstboot    = undef,
  Optional[Stdlib::Absolutepath]  $firstlogin   = undef,
  Optional[Stdlib::Absolutepath]  $execscript   = undef,
) {
  $command = $vmbuilder::command
  $_ip    = "--ip=${ip}"

  $_hostname = $hostname ? {
    undef   => "--hostname=${name}",
    default => "--hostname=${hostname}",
  }
  $_destination = $destination ? {
    undef   => "-d ${vmbuilder::destination_base}/${distro}-${hypervisor}",
    default => "-d ${destination}",
  }
  $_arch = $arch ? {
    undef => '',
    default => "--arch=${arch}",
  }
  $_domain = $domain ? {
    undef => '',
    default => "--domain=${domain}",
  }
  $_network = $network ? {
    undef => '',
    default => "--net=${network}",
  }
  $_netmask = $netmask ? {
    undef => '',
    default => "--mask=${netmask}",
  }
  $_broadcast = $broadcast ? {
    undef => '',
    default => "--bcast=${broadcast}",
  }
  $_gateway = $gateway ? {
    undef => '',
    default => "--gw=${gateway}",
  }
  $_realname = $realname ? {
    undef => '',
    default => "--name=${realname}",
  }
  $_username = $username ? {
    undef => '',
    default => "--user=${username}",
  }
  $_password = $password ? {
    undef => '',
    default => "--pass=${password}",
  }
  $_dns = $dns ? {
    undef => '',
    default => "--dns=${dns}",
  }
  $_firstboot = $firstboot ? {
    undef => '',
    default => "--firstboot=${firstboot}",
  }
  $_firstlogin = $firstlogin ? {
    undef => '',
    default => "--firstlogin=${firstlogin}",
  }
  $_execscript = $execscript ? {
    undef => '',
    default => "--execscript=${execscript}",
  }
  $command_str = [
    $command, $hypervisor, $distro, $_ip, $_hostname, $_destination, $_arch,
    $_domain, $_network, $_netmask, $_broadcast, $_gateway, $_realname,
    $_username, $_password, $_dns, $_firstboot, $_firstlogin, $_execscript,
  ].join(' ')
  exec {"vmbuilder::host create ${name}":
    command => $command_str,
    creates => $_destination.split(' ')[1],
    timeout => $timeout,
  }
}
