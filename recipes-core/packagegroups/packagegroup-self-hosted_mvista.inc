ERROR_QA = "dev-so debug-deps debug-files arch la2 pkgconfig la perms"
RDEPENDS_packagegroup-self-hosted-sdk += "packagegroup-core-standalone-sdk-target"

GDBSERVER = ""
GDBSERVER_riscv64 = "gdbserver"
RDEPENDS_packagegroup-self-hosted-debug_remove = "${GDBSERVER}"
RDEPENDS_packagegroup-self-hosted-graphics_remove = "epiphany"

RDEPENDS_packagegroup-self-hosted += "packagegroup-selfhost-installer-defaultimage"
