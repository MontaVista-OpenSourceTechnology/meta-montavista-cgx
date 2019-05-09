#FIXME: the ptest content does not build.

do_compile_ptest() {
   continue
}
do_compile_install() {
   continue
}

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_mx8 += "file://0001-Replace-struct-ucontext-with-ucontext_t-type.patch \
                file://fix-conflicting-kvm_irqchip_add_msi_route.patch"
