-- get UI slot container element
function bbu.util.get_slot_container(player, outer)
    outer = outer or false

    if player.gui.top.bbu_ui_frame_outer == nil then
        return nil
    end

    if outer then
        return player.gui.top.bbu_ui_frame_outer
    end

    if player.gui.top.bbu_ui_frame_outer.bbu_ui_frame_inner == nil then
        return nil
    end

    return player.gui.top.bbu_ui_frame_outer.bbu_ui_frame_inner.bbu_ui_frame_inner_flow.bbu_ui_table_inner or nil
end
