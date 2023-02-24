-- get player config value
function bbu.util.pcfg(player, path)
    return settings.get_player_settings(player)[path].value
end
