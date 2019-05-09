PREFERRED_PROVIDER_u-boot-mkimage-native = "u-boot-tools-native"
PREFERRED_PROVIDER_nativesdk-u-boot-mkimage = "nativesdk-u-boot-tools"
PREFERRED_PROVIDER_openssl ?= "openssl-qoriq"
PREFERRED_PROVIDER_qemu = "qemu-qoriq"

QEMU_TARGETS_mx8 ?= "arm aarch64 i386 mips mipsel mips64 mips64el ppc sh4 x86_64"
PREFERRED_PROVIDER_virtual/kernel_mx8 ?= 'linux-imx'
DISTRO_FEATURES_append_mx8 += 'wayland'
PREFERRED_PROVIDER_cryptodev-linux_mx8 ?= 'cryptodev-qoriq-linux'

addhandler fsl_eula_check
fsl_eula_check[eventmask] = "bb.event.SanityCheck"
python fsl_eula_check() {
    if e.data.getVar('ACCEPT_FSL_EULA') != "1":
        eula_file = d.getVar('FSL_EULA_FILE', True)
        bb.warn("Not setting ACCEPT_FSL_EULA = '1' could cause some \
build failures in bootloader, graphics related recipes or graphics applications \
may not work well. So it is advised to read Freescale EULA at '%s' and accept \
it by setting ACCEPT_FSL_EULA = '1' in conf/local.conf for Freescale Products." % eula_file)
}
