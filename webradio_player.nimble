# Package
version = "0.0.1"
author = "Nikita <nikita@n0.is>"
description = "A simple webradio player"
license = "BSD-2"

bin = @["src/radio"]
skipExt = @["nim"]

# Dependencies
requires "nim >= 0.13.1"
