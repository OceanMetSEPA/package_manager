function bool = isVersionDir(path)
    bool  = 0;
    paths = strsplit(path, '\');

    if isequal(paths{end-2}, 'versions')
        bool    = 1;
    end
end