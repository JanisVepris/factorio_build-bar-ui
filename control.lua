bbu = {
    state = { -- mod state
        dirty = true
    },
    conf = { -- mod config
        debug = false,
        log_prefix = "BBU: ",
        log_format = {
            comment = false,
            numformat = '%1.8g'
        }
    },
    e = {}, -- event subscription and handlers
    util = {}, -- utility functions
    f = {}, -- gameplay functions
    gui = {} -- gui element definitions and functions
}

-- utils
require("src/util/debug")
require("src/util/cfg")
require("src/util/slot-container")
require("src/util/gui-base")

-- functions
require("src/function/craft-items")

-- gui
require("src/gui/build-bar-gui")

-- event
require("src/event/game-loop")
require("src/event/gui-event")

bbu.e.loop.init()
bbu.e.gui.init()
