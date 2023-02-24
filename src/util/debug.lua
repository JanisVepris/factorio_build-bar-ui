function bbu.util.debug(input, separator)
    if bbu.conf.debug == false then return end

    separator = separator or false

    print(bbu.conf.log_prefix .. serpent.block(input, bbu.conf.log_format))

    if separator == true then
        print(bbu.conf.log_prefix .. "----------------------")
    end
end