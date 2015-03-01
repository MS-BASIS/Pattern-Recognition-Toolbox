function uiMSImageProcessing(opimage,Xms,mz,fileName,ticRegions,varargin)
% Mass Spectrometry Image Processing Toolbox: the toolbox contains a set of
% methods and visualization toolkits for interactive interrogation of 
% individual MSI samples including pre-processing, molecular ion annotion, 
% supervised and unsupervised statistical analyses

% demo: type uiMSImageProcessing() to get started;

% Author: Kirill Veselkov, Imperial College 2012

%close all;
warning('off', 'all');

% check if any hidden objects persist in the memory
hHiddenObjects = findall(0,'Visible','off');
delete(hHiddenObjects);
% Here is a rather nebulous function to catch errors and report them.  It
% will pick them up, but may cause the toolbox to pause rather than allow
% the errors.  Would be sensible though to identify such common errors and
% write a catch function for them.

try
    % Change paths to the current toolbox folder
    % If there is a single argin, then this is to be treated as a guidata
    if nargin == 1
        msimage = opimage;
        msiCopy = opimage;
    end
    
    toolboxFolder = fileparts(mfilename('fullpath')); cd(toolboxFolder);
    addpath(genpath(toolboxFolder)); msimage.currentFolder = toolboxFolder;
    
    % Let's get the default path from the defaults, and check that it exists.
    % If it doesn't then find the 'base' folder in which the toolbox is stored
    % locally and use that.
    tmp = open('msidefaults.mat');
    if isfield(tmp.defaults,'dbPath')
        msimage.dbPath = tmp.defaults.dbPath;
        if ~exist(msimage.dbPath,'dir')
            msimage.dbPath = toolboxFolder;
        end
    else
        msimage.dbPath = toolboxFolder;
    end
    
    
    
    % Figure defaults
    set(0,'Units','normalized');
    msimage.mainfig.backgroundcolor = [1 1 1];
    
    % Get the screensize, resize parameter and defaults structure
    %[msimage.mainfig.fullscreen,doResize,def] = getDefaultScreenSize();
    msimage.mainfig.fullscreen = get(0,'screensize');
    
    % Actually draw the useful figure
    msimage.mainfig.h = figure('Units','normalized',...
        'OuterPosition',msimage.mainfig.fullscreen,...
        'Color',msimage.mainfig.backgroundcolor);
    msimage.figpos = msimage.mainfig.fullscreen;
    
    
    
    % Get input arguments...
    msimage.userinput = getVarArgin(varargin);
    
    % Draw toolbars
    msimage = setupDef2Dms(msimage);
    msimage = setupTB2Dms(msimage);
    
    % Change figure title information
    updateFigTitleAndIconMS(msimage.mainfig.h,...
        'MSI Navigator','MSINavigatorLogo.png');
    
    refreshFigure(msimage.mainfig.h);  
    % If there is a single argin, then this is to be treated as a guidata. This
    % version may or may not have the alignment or any other information, so
    % need to differentiate between the fiels with alignment and without...
    if nargin == 1
        
        % Update the guidata...
        guidata(msimage.mainfig.h,msimage);
        
        % First mandatory step is the alignment... (push through using existing
        % settings... can we just accept alignment?
        
        % If there is no alignment info, e.g. in a temporary file, then it
        % won't go that far...
        if ~isfield(msimage.op2msalign,'FullRes')
            msimage = viewMSimages(msimage,1);
            % msimage = setupDef2Dms(opimage,Xms,mz,msimage);
            % msimage = viewMSimages(msimage); % Visualize data
            msimage = setupTObjDetms(msimage);
            guidata(msimage.mainfig.h,msimage);
            return
        end
        
        force = 1;
        
        uiAcceptOP2MSalignment(msimage.mainfig.h,[],force);
        
        % Get the guidata back from the previous function
        msimage = guidata(msimage.mainfig.h);
        
        % Force a redraw of the images - seemingly required for the rectangles
        % to be redrawn
        msimage = viewMSimages(msimage,force);
        
        % Look to redraw the rectangles and their handles...
        numR = size(msiCopy.opobject.xrect,1);
        set(msimage.mainfig.h, 'CurrentAxes',msimage.opobject.h);
        
        hold on;
        for n = 1:numR
            x = msiCopy.opobject.xrect(n,:);
            y = msiCopy.opobject.yrect(n,:);
            if numel(unique(x))==1 && numel(unique(y))==1
                hold on; msimage.opobject.hrect(n) = plot(x,y,...
                    'Marker','o','Color',msimage.msobject.recColors(n,:),'MarkerFaceColor',...
                    msimage.msobject.recColors(n,:),'MarkerSize',msimage.plotparam.linewidth); hold off;
            else
                hold on; msimage.opobject.hrect(n) = plot(x,...
                    y,'LineWidth',msimage.plotparam.linewidth,...
                    'Color',msimage.msobject.recColors(n,:)); hold off;
            end
        end
        hold off;
        msimage.opobject.xrect = msiCopy.opobject.xrect;
        msimage.opobject.yrect = msiCopy.opobject.yrect;
        
        % And on the msobject
        set(gcf, 'CurrentAxes',msimage.msobject.h);
        hold on;
        for n = 1:numR
            x = msiCopy.msobject.xrect(n,:);
            y = msiCopy.msobject.yrect(n,:);
            if numel(unique(x))==1 && numel(unique(y))==1
                hold on; msimage.msobject.hrect(n) = plot(x,y,...
                    'Marker','o','Color',msimage.msobject.recColors(n,:),'MarkerFaceColor',...
                    msimage.msobject.recColors(n,:),'MarkerSize',msimage.plotparam.linewidth); hold off;
            else
                hold on; msimage.msobject.hrect(n) = plot(x,...
                    y,'LineWidth',msimage.plotparam.linewidth,...
                    'Color',msimage.msobject.recColors(n,:)); hold off;
            end
        end
        hold off;
        msimage.msobject.xrect = msiCopy.msobject.xrect;
        msimage.msobject.yrect = msiCopy.msobject.yrect;
        
        % Update the guidata...
        disp('%%%% user data gui data updated');
        guidata(msimage.mainfig.h,msimage);
        
        
    elseif nargin >= 5
        
        msimage.userinput.ticregions = ticRegions;
        msimage = setupDef2Dms(opimage,Xms,mz,msimage);
        msimage = viewMSimages(msimage); % Visualize data
        msimage = setupTObjDetms(msimage);
        
        % Update the path/file names
        slash = strfind(fileName,filesep);
        msimage.imzMLpN = fileName(1:slash(numel(slash)));
        msimage.imzMLfN = fileName(slash(numel(slash))+1:end);
        %msimage.dbFileName = fileName;
        
        % Finally grab the metadata and proc (if they exist)
        if isfield(msimage.userinput,'meta')
            msimage.meta = msimage.userinput.meta;
        end
        if isfield(msimage.userinput,'proc_param')
            msimage.proc_param = msimage.userinput.proc_param;
        end
        
        % Update the guidata...
        guidata(msimage.mainfig.h,msimage);
        
    else
        % Update the guidata...
        guidata(msimage.mainfig.h,msimage);
    end
    
    
    % Here is the other half of the try/catch block
catch err
    errReport(err);
    
    % Try to do something positive persistent error messages
    switch err.identifier
        case 'MATLAB:uij:method_j:OutOfMemory'
            jheapcl;
        otherwise
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function userinput = getVarArgin(argsin)
% get default arguments (colors and types of sample markers)
nArgs = length(argsin);
userinput.logit  = 1;
userinput.offset = 50;
userinput.ticregions = [];
userinput.meta = [];
for i = 1:2:nArgs
    if strcmp('logit',argsin{i})
        userinput.logit = argsin{i+1};
    elseif  strcmp('offset',argsin{i})
        userinput.offset = argsin{i+1};
    elseif  strcmp('meta',argsin{i})
        userinput.meta = argsin{i+1};
    elseif  strcmp('proc',argsin{i})
        userinput.proc_param = argsin{i+1};
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%