classdef LibraryCompiled < ModuleConnector.Library
    
    % Compiled MATLAB executables requires generation of a loader mfile to
    % load libraries. This in turn requires a different syntax when using
    % loadlib(). This class is created to handle the syntax differences
    % when using libraries in a compiled executable.
        
    methods
    
        function obj = loadlib(obj)
            %% Load library
            if not(libisloaded(obj.library_name))
                if ~isdeployed
                    obj.generateLoaderMfileAndThunk();
                end
                [notfound,warnings] = loadlibrary(obj.library_name, @matlab_wrapper, 'alias', obj.library_name);
                if ~isempty(notfound)
                    error(notfound)
                end
                warning(warnings)
            else
                disp('Library is already loaded.');
            end
        end
        
        function obj = generateLoaderMfileAndThunk(obj)
            %% Generate loader mfile and thunk dll
            % This is done by loading library with 'mfilename' input.
            [~, mfile_name] = fileparts(obj.library_includes);
            [notfound,warnings] = loadlibrary(obj.library_name,obj.library_includes,'addheader','matlab_recording_api.h',...
                'addheader','datatypes.h','mfilename',[mfile_name, '.m']);
            if ~isempty(notfound)
                error(notfound)
            end
            warning(warnings)
            % The mfile and thunk dll is now created. Unload library to
            % avoid conflict.
            obj.unloadlib();
        end
    
    end
    
end