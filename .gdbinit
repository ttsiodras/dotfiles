#py sys.path.append('/usr/share/doc/python3.8/examples/gdb')
#py import libpython
#layout src
set print pretty on
set history save on
set debuginfod enabled off
# set scheduler-locking on
define xxd
    dump binary memory dump.bin $arg0 $arg0+$arg1
    shell xxd dump.bin
    shell rm dump.bin
end

python
import gdb, re

class BtIf(gdb.Command):
    """btif REGEX  — backtrace threads whose stack has a frame matching REGEX."""
    def __init__(self):
        super(BtIf, self).__init__("btif", gdb.COMMAND_STACK)

    def invoke(self, arg, from_tty):
        arg = arg.strip()
        if not arg:
            print("Usage: btif REGEX   (example: btif ^foo$)")
            return
        rx = re.compile(arg)

        inf = gdb.selected_inferior()
        for th in inf.threads():
            th.switch()
            f = gdb.newest_frame()
            match = False
            while f:
                name = None
                try:
                    sym = f.function()
                    if sym:
                        name = sym.print_name
                except Exception:
                    pass
                if not name:
                    name = f.name()

                if name and rx.search(name):
                    match = True
                    break
                f = f.older()

            if match:
                ptid = getattr(th, "ptid", None)
                print("\n=== Thread %d%s matches '%s' ===" %
                      (th.num, f" ({ptid})" if ptid else "", arg))
                gdb.execute("bt")
BtIf()
end
