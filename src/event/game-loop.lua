function bbu.e.loop.handler.on_init()
    for _, player in pairs(game.players) do
        bbu.gui.initialize_player_gui(player)
    end
end

function bbu.e.loop.handler.on_config_change(event)
    local player = game.get_player(event.player_index)
    local slotContainer = bbu.util.get_slot_container(player, true)

    if slotContainer then slotContainer.destroy() end

    bbu.gui.initialize_player_gui(player)
end

function bbu.e.loop.handler.on_player_created(event)
    local player = game.get_player(event.player_index)

    bbu.gui.initialize_player_gui(player)

    player.print({ "print-text.bbu-ui-init" })
end

function bbu.e.loop.handler.on_tick()
    if bbu.state.dirty == false then return end

    for _, player in pairs(game.players) do
        bbu.gui.refresh_gui(player)
    end

    bbu.state.dirty = false
end

function bbu.e.loop.init()
    script.on_init(bbu.e.loop.handler.on_init)
    script.on_event(defines.events.on_player_created, bbu.e.loop.handler.on_player_created)
    script.on_event(defines.events.on_runtime_mod_setting_changed, bbu.e.loop.handler.on_config_change)
    script.on_nth_tick(100, bbu.e.loop.handler.on_tick)
end
-- TODO: Always refresh gui whenever possible instead of falling back to clean state
