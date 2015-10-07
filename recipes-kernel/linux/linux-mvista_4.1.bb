KBRANCH ?= "master"

require linux-mvista.inc

SRCREV_machine ?= "${AUTOREV}"

# uncomment if wanting to use a from a local location
#SRC_URI = "git:///{path to kernel};protocol=file;bareclone=1;branch=${KBRANCH},${KMETA};name=machine,meta"

LINUX_VERSION ?= "4.1"
