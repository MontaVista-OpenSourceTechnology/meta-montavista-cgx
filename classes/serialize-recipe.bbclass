# Some recipes require significant memory to build properly, when built
# with other recipes taht require significant memory can cause out of
# memory conditions and cause build failures.


SERIALIZE_RECIPE ?= "0"
SERIALIZE_TASK ?= "do_compile"
SERIALIZE_LOCK ?= "${TMPDIR}/serial.lock"
def serializeRecipe(d):
    task = d.getVar("SERIALIZE_TASK", True)
    lockfile = d.getVar("SERIALIZE_LOCK", True)
    task_flags = d.getVarFlag(task,"lockfiles", True) or ""
    task_flags = " ".join([task_flags, lockfile])
    d.setVarFlag(task, "lockfiles", task_flags)
    d.setVar("PARALLEL_MAKE", "")

python () {
    if d.getVar("SERIALIZE_RECIPE", True) == "1":
       serializeRecipe(d)
}
