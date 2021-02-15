{ cpus, bridge, libvirt, mac, memory, name, passthrough, volume, writeText }:

let xml = writeText "libvirt-guest-${name}.xml" ''
  <domain type="kvm">
    <name>${name}</name>
    <uuid>UUID</uuid>
    <memory unit="MiB">${memory}</memory>
    <currentMemory unit="MiB">${memory}</currentMemory>
    <vcpu placement="static">${cpus}</vcpu>
    <os>
      <type arch="x86_64" machine="pc-q35-5.1">hvm</type>
      <boot dev="hd"/>
    </os>
    <features>
      <acpi/>
      <apic/>
      <vmport state="off"/>
    </features>
    <cpu mode="host-passthrough"/>
    <clock offset="utc">
      <timer name="rtc" tickpolicy="catchup"/>
      <timer name="pit" tickpolicy="delay"/>
      <timer name="hpet" present="no"/>
    </clock>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>destroy</on_crash>
    <pm>
      <suspend-to-mem enabled="no"/>
      <suspend-to-disk enabled="no"/>
    </pm>
    <devices>
      <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
      <disk type="file" device="disk">
        <driver name="qemu" type="raw"/>
        <source file="${volume}"/>
        <target dev="vda" bus="virtio"/>
        <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
      </disk>
      <controller type="usb" index="0" model="qemu-xhci" ports="15">
        <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
      </controller>
      <controller type="sata" index="0">
        <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
      </controller>
      <controller type="pci" index="0" model="pcie-root"/>
      <controller type="pci" index="1" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="1" port="0x10"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
      </controller>
      <controller type="pci" index="2" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="2" port="0x11"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
      </controller>
      <controller type="pci" index="3" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="3" port="0x12"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
      </controller>
      <controller type="pci" index="4" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="4" port="0x13"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
      </controller>
      <controller type="pci" index="5" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="5" port="0x14"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
      </controller>
      <controller type="pci" index="6" model="pcie-root-port">
        <model name="pcie-root-port"/>
        <target chassis="6" port="0x15"/>
        <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x5"/>
      </controller>
      <controller type="virtio-serial" index="0">
        <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
      </controller>
      <interface type="bridge">
        <mac address="${mac}"/>
        <source bridge="${bridge}"/>
        <model type="virtio"/>
        <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
      </interface>
      <serial type="pty">
        <target type="isa-serial" port="0">
          <model name="isa-serial"/>
        </target>
      </serial>
      <console type="pty">
        <target type="serial" port="0"/>
      </console>
      <channel type="unix">
        <target type="virtio" name="org.qemu.guest_agent.0"/>
        <address type="virtio-serial" controller="0" bus="0" port="1"/>
      </channel>
      <input type="mouse" bus="ps2"/>
      <input type="keyboard" bus="ps2"/>
      <hostdev mode="subsystem" type="usb" managed="yes">
        <source>
          <vendor id="${passthrough.vendor}"/>
          <product id="${passthrough.product}"/>
        </source>
        <address type="usb" bus="0" port="1"/>
      </hostdev>
      <memballoon model="virtio">
        <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
      </memballoon>
      <rng model="virtio">
        <backend model="random">/dev/urandom</backend>
        <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
      </rng>
    </devices>
  </domain>
'';
in ''
  uuid="$(${libvirt}/bin/virsh domuuid '${name}' || true)"
  ${libvirt}/bin/virsh define <(sed "s/UUID/$uuid/" '${xml}')
  ${libvirt}/bin/virsh start '${name}'
''
