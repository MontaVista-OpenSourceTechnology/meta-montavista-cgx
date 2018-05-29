# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".2"

# set maximum length of group name to 32 
EXTRA_OECONF +=" --with-group-name-max-length=32 "
