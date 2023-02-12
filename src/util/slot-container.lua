function bbu.get_slot_container(player, outer)
    outer = outer or false

    if outer then
        return player.gui.top.bbu_ui_frame_outer
    end

    return player.gui.top.bbu_ui_frame_outer.bbu_ui_frame_inner.bbu_ui_frame_inner_flow.bbu_ui_table_inner
end