function realVideo()
 
% Define frame rate
NumberFrameDisplayPerSecond=10;
 
% Open figure
hFigure=figure(1);

% Set-up webcam video input
vid = videoinput('winvideo', 1, 'MJPG_1280x720');

% Set parameters for video

% Acquire only one frame each time
set(vid,'FramesPerTrigger',5);
set(vid,'FrameGrabInterval',10); 

% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);

% Get a grayscale image
set(vid,'ReturnedColorSpace','grayscale');
triggerconfig(vid, 'Manual');
 
% set up timer object
TimerData=timer('TimerFcn', {@FrameRateDisplay,vid},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
 
% Start video and timer object
start(vid);
start(TimerData);
 
% We go on until the figure is closed
%uiwait(hFigure);

if ~ishandle(figNum)
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
clear functions;
end
 
% This function is called by the timer to display one frame of the figure
 
function FrameRateDisplay(obj, event,vid)
persistent IM;
persistent handlesRaw;
persistent handlesPlot;
persistent handlesMOD;
trigger(vid);
IM=getdata(vid,1,'uint8');
MOD = edge(IM);
 
if isempty(handlesRaw)
   % if first execution, we create the figure objects
   subplot(2,1,1);
   handlesRaw=imagesc(IM);
   title('CurrentImage');
 
% Plot first value
   Values=mean(IM(1:10));
   subplot(2,1,2);
   handlesPlot=plot(Values);
   handlesMOD=imagesc(MOD);
   title('Edge Detection');
else
   % We only update what is needed
   set(handlesRaw,'CData',IM);
   Value=mean(IM(1:10));
   OldValues=get(handlesPlot,'YData');
   set(handlesPlot,'YData',[OldValues Value]);
end
