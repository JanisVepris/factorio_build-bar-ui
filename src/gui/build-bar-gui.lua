local function add_gui_layout(player)
    local gui = player.gui.top

    local frame = gui.add {
        type = "frame",
        name = "bbu_ui_frame_outer",
        style = "quick_bar_window_frame"
    }

    local frameInner = frame.add {
        type = "frame",
        name = "bbu_ui_frame_inner",
        style = "quick_bar_inner_panel"
    }

    local flow = frameInner.add {
        type = "flow",
        name = "bbu_ui_frame_inner_flow",
        direction = "vertical",
    }

    flow.add {
        type = "switch",
        name = "bbu_ui_slot_table_switch",
        allow_none_state = false,
        switch_state = "left",
        left_label_caption = "On",
        right_label_caption = "Off",
    }

    flow.add {
        type = "table",
        name = "bbu_ui_table_inner",
        column_count = 2,
        draw_vertical_lines = false,
        draw_horizontal_lines = false,
        draw_horizontal_line_after_headers = false,
        style = "slot_table"
    }
end

local function add_slots(player)
    local slotCount = bbu.pcfg(player, "bbu-slot-count")
    local container = bbu.get_slot_container(player)
    local elemFilters = {
        {filter = "category", category="crafting"},
        {filter = "category", category="advanced-crafting"},
    }

    if bbu.pcfg(player, "bbu-show-enabled-recipes") == true
    then
        table.insert(elemFilters, { filter = "enabled", mode = "and" })
    end

    for i = 1, slotCount, 1
    do
        container.add {
            name = "bbu_slot_" .. i,
            type = "choose-elem-button",
            elem_type = "recipe",
            style = "quick_bar_slot_button",
            elem_filters = elemFilters,
        }
        container.add {
            name = "bbu_slot_craft_" .. i,
            type = "sprite-button",
            style = "quick_bar_slot_button",
            sprite = "bbu-build-icon"
        }
    end
end

local function initialize_player_gui(player)
    local isBbuEnabled = bbu.pcfg(player, "bbu-enabled")

    if not isBbuEnabled then return end

    add_gui_layout(player)
    add_slots(player)
end

local function on_config_change(event)
    local player = game.get_player(event.player_index)
    local slotContainer = bbu.get_slot_container(player, true)

    if slotContainer then slotContainer.destroy() end

    initialize_player_gui(player)
end

local function on_player_created(event)
    bbu.debug("On Player Created!")

    local player = game.get_player(event.player_index)

    initialize_player_gui(player)

    player.print({ "print-text.bbu-ui-init" })
end

local function initialize()
    for _, player in pairs(game.players) do
        initialize_player_gui(player)
    end
end

local function refresh_gui(player)
    local slotContainer = bbu.get_slot_container(player)
    local slotContainerOuter = bbu.get_slot_container(player, true)
    local slotCount = bbu.pcfg(player, "bbu-slot-count")

    if not slotContainer then return end

    selectedRecipes = {}

    for i = 1, slotCount, 1
    do
        table.insert(
            selectedRecipes,
            slotContainer["bbu_slot_" .. i].elem_value
        )
    end

    slotContainerOuter.destroy()
    initialize_player_gui(player)
    slotContainer = bbu.get_slot_container(player)

    for i = 1, slotCount, 1
    do
        local recipe = selectedRecipes[i]

        if recipe ~= nil then
            slotContainer["bbu_slot_" .. i].elem_value = recipe
        end
    end
end

local function on_tick()
    if bbu.version == bbu.expected_version then return end

    bbu.debug("On Tick!")

    for _, player in pairs(game.players) do
        refresh_gui(player)
    end

    bbu.version = bbu.expected_version
end

script.on_init(initialize)
script.on_event(defines.events.on_player_created, on_player_created)
script.on_event(defines.events.on_runtime_mod_setting_changed, on_config_change)
script.on_nth_tick(100, on_tick)
