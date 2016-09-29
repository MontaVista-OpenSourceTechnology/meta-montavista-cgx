PR .= ".4"

PACKAGECONFIG ??= " libffi "
PACKAGECONFIG[libffi] = "--with-system-ffi,,libffi"
