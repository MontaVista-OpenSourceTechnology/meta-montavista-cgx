#Fix ups for including freescale.
include ${@bb.utils.contains("BBFILE_COLLECTIONS", "freescale-layer", "conf/distro/extra-features/freescale.inc", "", d)}
include ${@bb.utils.contains("BBFILE_COLLECTIONS", "riscv-layer", "conf/distro/extra-features/riscv.inc", "", d)}
