KBRANCH ?= "master"

require linux-mvista.inc

SRCREV_machine ?= "c7b3bd536e6830e87f56d389925ea448c8170e54"
SRCREV_meta ?= "9bb84fdf27360e370520bfa4b0f8ab94f80af526"

# uncomment if wanting to use a from a local location
#SRC_URI = "git:///{path to kernel};protocol=file;bareclone=1;branch=${KBRANCH},${KMETA};name=machine,meta"

LINUX_VERSION ?= "3.18"
