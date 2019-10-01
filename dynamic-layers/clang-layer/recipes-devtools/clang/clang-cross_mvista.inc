do_install_append() {

rm -f ${D}${bindir}/${TARGET_PREFIX}llvm-ar
cat > ${D}${bindir}/${TARGET_PREFIX}llvm-ar << 'EOF'
#!/bin/sh
basedir=$(dirname "$0")
"${basedir}/../llvm-ar" "$@"
exit "$?"
EOF
chmod +x ${D}${bindir}/${TARGET_PREFIX}llvm-ar

}
