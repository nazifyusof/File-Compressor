function huffmanCode(filename, mode)
    if mode == 1
        huffmanCompress(filename);
    elseif mode == 2
        huffmanDecompress(filename);
    else
        error('Mode should be either \n 1 for Compression or \n 2 for Decompression');
    end
end

