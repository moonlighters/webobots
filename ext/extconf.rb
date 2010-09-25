require 'mkmf'

$CFLAGS << " -Wall "
dir_config 'emulation_system_ext'
create_makefile 'emulation_system_ext'

