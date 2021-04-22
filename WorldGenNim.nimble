# Package

version       = "0.1.0"
author        = "AFaurholt"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["WorldGenNim"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.5.1"
requires "nimraylib_now"