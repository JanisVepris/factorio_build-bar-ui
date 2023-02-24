function bbu.gui.add_gui_layout(player)
    bbu.util.debug("Adding GUI layout")

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

    bbu.util.debug("Adding GUI layout: DONE")
end

function bbu.gui.add_slots(player)
    bbu.util.debug("Adding slots")

    local slotCount = bbu.util.pcfg(player, "bbu-slot-count")
    local container = bbu.util.get_slot_container(player)

    local elemFilters = {}

    if bbu.util.pcfg(player, "bbu-show-enabled-recipes") == true
    then
        table.insert(elemFilters, { filter = "enabled", mode = "and" })
    end

    table.insert(elemFilters, {filter = "category", category="crafting", mode = "and"})

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

    bbu.util.debug("Adding slots: DONE")
end

function bbu.gui.initialize_player_gui(player)
    local isBbuEnabled = bbu.util.pcfg(player, "bbu-enabled")

    if not isBbuEnabled then return end

    bbu.util.debug("Initializing GUI")

    bbu.gui.add_gui_layout(player)
    bbu.gui.add_slots(player)
end

function bbu.gui.get_selected_recipes(player, slot_container)
    local slot_count = bbu.util.pcfg(player, "bbu-slot-count")

    local selected_recipes = {}

    for i = 1, slot_count, 1
    do
        local value = nil
        
        if slot_container["bbu_slot_" .. i] ~= nil then
            value = slot_container["bbu_slot_" .. i].elem_value
        end

        table.insert(selected_recipes, value)
    end

    return selected_recipes
end

function bbu.gui.set_selected_recipes(player, selected_recipes, slot_container)
    local slot_count = bbu.util.pcfg(player, "bbu-slot-count")

    for i = 1, slot_count, 1
    do
        local recipe = selected_recipes[i]

        if recipe ~= nil then
            slot_container["bbu_slot_" .. i].elem_value = recipe
        end
    end
end

function bbu.gui.refresh_gui(player)
    local isBbuEnabled = bbu.util.pcfg(player, "bbu-enabled")

    if not isBbuEnabled then return end

    local slot_container = bbu.util.get_slot_container(player)

    bbu.util.debug("Refreshing GUI")

    local selected_recipes = {}

    if slot_container then
        selected_recipes = bbu.gui.get_selected_recipes(player, slot_container)
        local slot_container_outer = bbu.util.get_slot_container(player, true)

        if slot_container_outer then slot_container_outer.destroy() end
    end

    bbu.gui.initialize_player_gui(player)

    slot_container = bbu.util.get_slot_container(player)

    bbu.gui.set_selected_recipes(player, selected_recipes, slot_container)

    bbu.util.debug("Refreshing GUI: DONE")
end
