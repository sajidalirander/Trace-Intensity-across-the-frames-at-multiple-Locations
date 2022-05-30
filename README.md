# Trace-Intensity-across-the-frames-at-multiple-Locations
1) The script will read the video file and split each frame. 
2) Multiple ROI can be processed at the same time.
3) The intensity of the molecules will be extracted from each frame and plot intensity vs frame/time graph.


# Steps:
1) Each RGB frame is converted to gray scale --> it is unit8
2) User will be asked for the number of ROI --> Follow the Command Window --> give a integer value
3) The first frame will appear on the screen and being asked to user to draw a shape (region of interest - ROI) for the analysis.
    Follow the instruction on the dialog box how to draw the ROI.
4) After all ROI is marked, user may further adjust the location of each ROI. --> Follow the Command Window --> Once done, press ENTER.
5) A figure will appear, displaying three subplots.
    5.1) Subplot 1 --> Each frame in gray scale
    5.2) Subplot 2 --> Total ROI labelled with a number (the number is in the order it has drawn)
    5.3) Subplot 3 --> Masking Each ROI on the original gray scale frame.
6) The script will run through the number of frames. The figure will update for every loop.
7) At the end, the intersity vs frames for each ROI will be plotted.


# How to Use
- Input
    Give the complete path of the video file at line 46

- Output 
    Mean value in each ROI with respect to each frame.

The file can also be downloaded from MATLAB File exchange 
[![View Trace-Intensity-across-the-frames-at-multiple-Locations on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/112430-trace-intensity-across-the-frames-at-multiple-locations)
