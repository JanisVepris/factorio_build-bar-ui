-- Amount -1 means craft all available amount
function bbu.craft_items(playerIndex, recipe, amount)
    bbu.debug("-------")
    bbu.debug("Crafting recipe #" .. recipe)
    bbu.debug("for player #" .. playerIndex)
    bbu.debug("amount: " .. amount)
    bbu.debug("-------")

    if not amount then return end
    if amount == 0 then return end

    local player = game.get_player(playerIndex)

    if amount == -1 then
        amount = player.get_craftable_count(recipe)
    end

    player.begin_crafting {
        count = amount,
        recipe = recipe,
        silent = false
    }
end
