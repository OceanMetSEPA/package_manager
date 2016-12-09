function [ output_args ] = installDependencies()

    thisFile = mfilename('fullpath');
    [thisPath, thisFilename, thisExtension]= fileparts(thisFile);

    pathParts        = strsplit(thisPath,'\');
    dependenciesFile = [strjoin(pathParts(1:end-3), '\'), '\dependencies'];
    
    PackageManager.installFromFile(dependenciesFile, 'checkCheckSum',0);
end

