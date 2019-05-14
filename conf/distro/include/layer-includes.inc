#Fix ups for including freescale, riscv, altera.
include ${@bb.utils.contains("BBFILE_COLLECTIONS", "freescale-layer", "conf/distro/extra-features/freescale.inc", "", d)}
include ${@bb.utils.contains("BBFILE_COLLECTIONS", "riscv-layer", "conf/distro/extra-features/riscv.inc", "", d)}
include ${@bb.utils.contains("BBFILE_COLLECTIONS", "meta-altera", "conf/distro/extra-features/altera.inc", "", d)}
