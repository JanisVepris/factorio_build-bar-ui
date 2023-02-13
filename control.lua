--control.lua
bbu = {}

bbu.debug = false
bbu.version = 0
bbu.expected_version = 101

--utils
require("src/util/debug")
require("src/util/cfg")
require("src/util/slot-container")

--functions
require("src/function/craft-items")

--gui
require("src/gui/build-bar-gui")
require("src/gui/gui-event")
