function L = code2log(code)
    L = logical(str2num(convertStringsToChars(code).').');
end