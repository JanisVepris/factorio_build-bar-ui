local function is_supported_element(element)
    local prefix = string.sub(element.name, 1, 3)

    if (element.mod == MODNAME) then return true end
    if (prefix == "bbu") then return true end

    return false
end

local function is_slot_craft_button(element)
    local prefix = string.sub(element.name, 1, 15)

    if (prefix == "bbu_slot_craft_") then return true end

    return false
end

local function is_slot_table_switch(element)
    if element.name == "bbu_ui_slot_table_switch" then return true end

    return false
end

local function get_craft_amount(event)
    if event.button == 2 and event.shift == false then return 1 end
    if event.button == 2 and event.shift == true then return -1 end
    if event.button == 4 then return 5 end

    return 0
end

local function resolve_craft_recipe(playerIndex, slotId)
    local player = game.get_player(playerIndex)
    local slotContainer = bbu.get_slot_container(player)
    return slotContainer["bbu_slot_" .. slotId].elem_value
end

local function on_slot_craft_button_clicked(event)
    local slotId = string.sub(event.element.name, 16, -1)
    local playerIndex = event.player_index
    local recipe = resolve_craft_recipe(event.player_index, slotId)

    if not recipe then
        local player = game.get_player(playerIndex)
        player.print({"print-text.bbu-no-recipe", slotId})

        return
    end

    local amount = get_craft_amount(event)

    bbu.craft_items(playerIndex, recipe, amount)
end

local function on_slot_table_switch_clicked(event)
    local switch = event.element
    local player = game.get_player(event.player_index)
    local slotContainer = bbu.get_slot_container(player)

    if switch.switch_state == "left"
    then
        slotContainer.visible = true
    else 
        slotContainer.visible = false
    end
end

local function on_gui_click(event)
    local element = event.element

    if not is_supported_element(element) then return end

    bbu.debug("-=-=-=-=-=")
    bbu.debug("CLICK")
    bbu.debug(event)
    bbu.debug(event.element.name)
    bbu.debug("-=-=-=-=-=")


    if is_slot_craft_button(element) then on_slot_craft_button_clicked(event) end
    if is_slot_table_switch(element) then on_slot_table_switch_clicked(event) end
end

script.on_event(defines.events.on_gui_click, on_gui_click)
