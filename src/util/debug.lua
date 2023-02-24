function bbu.util.debug(input)
    if bbu.conf.debug == false then return end

    print("BBU: " .. serpent.block(input, bbu.conf.log_format))
end
