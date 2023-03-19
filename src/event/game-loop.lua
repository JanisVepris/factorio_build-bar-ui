bbu.e.loop = {}
bbu.e.loop.handler = {}

function bbu.e.loop.handler.on_init()
    bbu.util.debug("INIT EVENT START")

    for _, player in pairs(game.players) do
        bbu.gui.initialize_player_gui(player)
    end

    bbu.util.debug("INIT EVENT END", true)
end

function bbu.e.loop.handler.on_config_change(event)
    bbu.util.debug("CONFIG CHANGED EVENT START")
    bbu.util.debug(event)

    local setting_prefix = string.sub(event.setting, 1, 4)

    if setting_prefix ~= "bbu-" then
        bbu.util.debug("Irrelevant setting, skipping", true)
        return
    end

    local player = game.get_player(event.player_index)
    local slotContainer = bbu.util.get_slot_container(player, true)

    local isBbuEnabled = bbu.util.pcfg(player, "bbu-enabled")

    if not isBbuEnabled and slotContainer then slotContainer.destroy() end

    bbu.gui.refresh_gui(player)

    bbu.util.debug("CONFIG CHANGED EVENT END", true)
end

function bbu.e.loop.handler.on_player_created(event)
    bbu.util.debug("PLAYER CREATED EVENT START")
    bbu.util.debug(event)

    local player = game.get_player(event.player_index)

    bbu.gui.initialize_player_gui(player)

    player.print({ "print-text.bbu-ui-init" })

    bbu.util.debug("PLAYER CREATED EVENT END", true)
end

function bbu.e.loop.handler.on_tick()
    if bbu.state.dirty == false then return end

    bbu.util.debug("TICK EVENT START")

    for _, player in pairs(game.players) do
        bbu.gui.refresh_gui(player)
    end

    bbu.state.dirty = false

    bbu.util.debug("TICK EVENT END", true)
end

function bbu.e.loop.init()
    bbu.util.debug("Initializing event loop")

    script.on_init(bbu.e.loop.handler.on_init)
    script.on_event(defines.events.on_player_created, bbu.e.loop.handler.on_player_created)
    script.on_event(defines.events.on_runtime_mod_setting_changed, bbu.e.loop.handler.on_config_change)
    script.on_nth_tick(100, bbu.e.loop.handler.on_tick)

    bbu.util.debug("Initializing event loop: DONE", true)
end
-- TODO: Always refresh gui whenever possible instead of falling back to clean state
