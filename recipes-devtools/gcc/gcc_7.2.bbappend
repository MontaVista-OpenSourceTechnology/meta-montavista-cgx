
updateMips () {
    :
}

updateMips_linux-gnun32 () {
     cd ${B}
     cat > gcc/config/mips/t-linux64 << EOF

MULTILIB_OPTIONS = mabi=64/mabi=n32
MULTILIB_DIRNAMES = . 32
MULTILIB_OSDIRNAMES = ../lib64 ../lib32
EOF
}


EXTRACONFFUNCS += "updateMips"

