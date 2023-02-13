bbuLogFormat = { comment = false, numformat = '%1.8g' }

function bbu.debug(input)
    if bbu.debug == false then return end

    print("BBU: " .. serpent.block(input, bbuLogFormat))
end
