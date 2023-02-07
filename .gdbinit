#py sys.path.append('/usr/share/doc/python3.8/examples/gdb')
#py import libpython
#layout src
set print pretty on
set history save on
set debuginfod enabled off
set scheduler-locking on
define xxd
    dump binary memory dump.bin $arg0 $arg0+$arg1
    shell xxd dump.bin
end
