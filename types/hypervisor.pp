# theses are the possible hypervisors however we ohnly implment kvm at the moment
# type Vmbuilder::Hypervisor = Enum['vmserver', 'esxi', 'xen', 'kvm', 'vbox', 'qemu', 'vmw6']
type Vmbuilder::Hypervisor = Enum['kvm']
