function bbu.util.debug(input)
    if bbu.conf.debug == false then return end

    print(bbu.conf.log_prefix .. serpent.block(input, bbu.conf.log_format))
end
