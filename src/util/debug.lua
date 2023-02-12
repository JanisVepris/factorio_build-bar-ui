bbuLogFormat = { comment = false, numformat = '%1.8g' }

function bbu.debug(input)
    print(serpent.block(input, bbuLogFormat))
end
