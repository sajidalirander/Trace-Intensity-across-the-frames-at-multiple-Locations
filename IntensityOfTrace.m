%% Trace Intensity across the frames at multiple Locations

% The script will read the video file and split each frame.
% Multiple ROI can be processed at the same time.
% The intensity of the molecules will be extracted from each frame and plot intensity vs frame/time graph.
%
% Steps:
% 1) Each RGB frame is converted to gray scale --> it is unit8
% 2) User will be asked for the number of ROI --> Follow the Command Window --> give a integer value
% 3) The first frame will appear on the screen and being asked to user to draw a shape (region of interest - ROI) for the analysis.
%    Follow the instruction on the dialog box how to draw the ROI.
% 4) After all ROI is marked, user may further adjust the location of each ROI. --> Follow the Command Window --> Once done, press ENTER.
% 5) A figure will appear, displaying three subplots.
%    5.1) Subplot 1 --> Each frame in gray scale
%    5.2) Subplot 2 --> Total ROI labelled with a number (the number is in the order it has drawn)
%    5.3) Subplot 3 --> Masking Each ROI on the original gray scale frame.
% 6) The script will run through the number of frames. The figure will update for every loop.
% 7) At the end, the intersity vs frames for each ROI will be plotted.

%% How to Use
% Input
%   -- Give the complete path of the video file at line 46
% Output 
%   -- Mean value in each ROI with respect to each frame.

%% Acknowledge
% CREATED: Sajid Ali, Sungkyunkwan University, Suwon, South Korea
% Data: |May 30, 2022|
% Contact: sajidali@skku.edu

%% Initialization
clc;    % Clear command window.
clear;    % Delete all variables.
close all;    % Close all figure windows except those created by imtool.
imtool close all;    % Close all figure windows created by imtool.
workspace;    % Make sure the workspace panel is showing.
fontSize = 16; % Font size of any text used in the figure

% Number of ROI
dlgtitle = 'Input';
dims = [1 40];
numROI = str2double(inputdlg('Enter the Number of ROI = ', dlgtitle, dims));

%% Load the video and read it frame by frame
% Provide the full file path to videoFileName
videoFileName = 'E:\DrVadhin\Recent_May27,2022_E_FRET\Merged-aligned-001-label.avi'; % change this

% Read the movie file from the given path
video = VideoReader(videoFileName);

% Read the total number of frames
num_frames = video.NumFrames;
meanROI = zeros(num_frames,numROI);
for i = 1:num_frames
    % Convert to the gray image
    grayImage = rgb2gray((read(video,i)));
    
    if i == 1
        % Display the image and ask user to draw a shape
        imshow(grayImage, []);
        axis on;
        title('First Frame in Grayscale', 'FontSize', fontSize);
        set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
        
        % Instruction to draw the ROI shape
        message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
        uiwait(msgbox(message));
        
        % The ROI parameters object will be stored in here
        % hFH = drawfreehand();
        % hFH = zeros(1,numROI);
        for k = 1:numROI
            hFH(k) = drawcircle;
        end
        % wait until the user is done
        message = sprintf('Press enter when done adjusting ROI objects');
        uiwait(msgbox(message));
        
        % Create a binary image ("mask") from the ROI object.
        binaryImage = false(size(grayImage,1),size(grayImage,2));
        for k = 1:numROI
            binaryImage = binaryImage | createMask(hFH(k));
        end
        
        % Computer the centroid of each ROI to display the label on it
        measurements = regionprops(binaryImage, grayImage, 'Centroid');
        
        % label each ROI with a number --> First ROI will be assigned 1 so on.
        binaryImage = bwlabel(binaryImage);
    end
    
    % Get the coordinates of the ROI
    % xy = hFH.getPosition;
    
    % Now make the figure smaller so we can show more images.
    subplot(1, 3, 1);
    imshow(grayImage);
    axis on;
    title('Frames in Grayscale', 'FontSize', fontSize);
    drawnow; % Force it to draw immediately.
    
    % Display the freehand mask.
    subplot(1, 3, 2);
    imshow(binaryImage);
    axis on;
    title('Binary mask of the ROI', 'FontSize', fontSize);
    hold on
    for j = 1:numROI
        text(measurements(j).Centroid(1), measurements(j).Centroid(2), string(j), 'FontSize', 20);
    end
    
    
    % Calculate the area or size of ROI, in pixels, that they drew.
    numberOfPixels1 = sum(binaryImage(:));
    % Another way to calculate it that takes fractional pixels into account.
    numberOfPixels2 = bwarea(binaryImage);
    
    % Get coordinates of the boundary of the freehand drawn region.
    structBoundaries = bwboundaries(binaryImage);
    xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
    % x = xy(:, 2); % Columns.
    % y = xy(:, 1); % Rows.
    % subplot(1, 3, 1); % Plot over original image.
    % hold on; % Don't blow away the image.
    % plot(x, y, 'LineWidth', 2);
    % drawnow;
    
    % Mask the image and display it.
    % Will keep only the part of the image that's inside the mask, zero outside mask.
    blackMaskedImage = grayImage;
    blackMaskedImage(~binaryImage) = 0;
    subplot(1, 3, 3);
    imshow(blackMaskedImage);
    axis on;
    title('Masked On Original Gray Image', 'FontSize', fontSize);
    
    % Calculate the mean of specific ROI based on the label
    for p = 1:numROI
        % To get the specific ROI based on the label
        [c, r]=find(binaryImage == p); % get the ROI that has label j
        binaryImageSpecificLabel = bwselect(binaryImage, r, c);
        meanROI(i, p) = mean(blackMaskedImage(binaryImageSpecificLabel),'all');
    end
end
writetable(meanROI,'meanROI.csv')
% Plot the intensity graph
figure;
for q = 1:numROI
    subplot(numROI, 1, q)
    plot(meanROI(:,q))
end