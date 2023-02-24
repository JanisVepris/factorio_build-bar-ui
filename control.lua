--control.lua
bbu = {
    state = {
        dirty = true,
    },
    conf = {
        debug = false,
        log_prefix = "BBU: ",
        log_format = { comment = false, numformat = '%1.8g' },
    },
    util = {},
    f = {},
    gui = {},
}

--utils
require("src/util/debug")
require("src/util/cfg")
require("src/util/slot-container")

--functions
require("src/function/craft-items")

--gui
require("src/gui/build-bar-gui")
require("src/gui/gui-event")