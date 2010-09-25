require 'mkmf'

`gcc -MM *.c > depend`
$CFLAGS << " -Wall "
create_makefile 'emulation_system_ext'

