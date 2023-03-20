function bbu.gui.add_gui_layout(player)
    bbu.util.debug("Adding GUI layout")

    local gui = bbu.util.get_gui_base(player)

    local frame = gui.add {
        type = "frame",
        name = "bbu_ui_frame_outer",
        direction = "vertical",
        style = "quick_bar_window_frame"
    }

    local titlebar = frame.add{type = "flow"}

    titlebar.drag_target = frame
    titlebar.add{
      type = "label",
      style = "caption_label",
      caption = "Build Bar   ",
      ignored_by_interaction = true,
    }

    local switch = titlebar.add {
        type = "checkbox",
        name = "bbu_ui_slot_table_switch",
        state = true,
    }

    switch.style.top_margin = 3

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

    local column_count = 2

    if bbu.util.pcfg(player, "bbu-orientation-horizontal") == true then
        column_count = bbu.util.pcfg(player, "bbu-slot-count")
    end

    flow.add {
        type = "table",
        name = "bbu_ui_table_inner",
        column_count = column_count,
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

    if bbu.util.pcfg(player, "bbu-orientation-horizontal") == false
    then
        bbu.gui.add_slots_vertical(container, slotCount, elemFilters)
    else
        bbu.gui.add_slots_horizontal(container, slotCount, elemFilters)
    end

    bbu.util.debug("Adding slots: DONE")
end

function bbu.gui.add_slots_horizontal(container, slotCount, elemFilters)
    for i = 1, slotCount, 1
    do
        container.add {
            name = "bbu_slot_" .. i,
            type = "choose-elem-button",
            elem_type = "recipe",
            style = "quick_bar_slot_button",
            elem_filters = elemFilters,
        }
    end

    for i = 1, slotCount, 1
    do
        container.add {
            name = "bbu_slot_craft_" .. i,
            type = "sprite-button",
            style = "quick_bar_slot_button",
            sprite = "bbu-build-icon"
        }
    end
end

function bbu.gui.add_slots_vertical(container, slotCount, elemFilters)
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

function bbu.gui.destroy_gui(player)
    bbu.util.debug("Destroying player GUI")

    if player.gui.top.bbu_ui_frame_outer ~= nil then
        player.gui.top.bbu_ui_frame_outer.destroy()
    end

    if player.gui.left.bbu_ui_frame_outer ~= nil then
        player.gui.left.bbu_ui_frame_outer.destroy()
    end

    if player.gui.screen.bbu_ui_frame_outer ~= nil then
        player.gui.screen.bbu_ui_frame_outer.destroy()
    end

    if player.gui.center.bbu_ui_frame_outer ~= nil then
        player.gui.center.bbu_ui_frame_outer.destroy()
    end

    if player.gui.goal.bbu_ui_frame_outer ~= nil then
        player.gui.goal.bbu_ui_frame_outer.destroy()
    end

    bbu.util.debug("Destroying player GUI: DONE")
end

function bbu.gui.refresh_gui(player)
    local isBbuEnabled = bbu.util.pcfg(player, "bbu-enabled")

    if not isBbuEnabled then return end

    local slot_container = bbu.util.get_slot_container(player)

    bbu.util.debug("Refreshing GUI")

    local selected_recipes = {}

    if slot_container then
        selected_recipes = bbu.gui.get_selected_recipes(player, slot_container)
    end

    local container_location = {
        x = 50,
        y = 50,
    }

    local slot_container_outer = bbu.util.get_slot_container(player, true)

    if slot_container_outer then
        container_location = slot_container_outer.location
    end

    bbu.gui.destroy_gui(player)

    bbu.gui.initialize_player_gui(player)

    slot_container_outer = bbu.util.get_slot_container(player, true)
    slot_container_outer.location = container_location

    slot_container = bbu.util.get_slot_container(player)

    bbu.gui.set_selected_recipes(player, selected_recipes, slot_container)

    bbu.util.debug("Refreshing GUI: DONE")
end
