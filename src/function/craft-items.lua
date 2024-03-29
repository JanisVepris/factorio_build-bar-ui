-- Amount -1 means craft all available amount
function bbu.f.craft_items(playerIndex, recipe, amount)
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
