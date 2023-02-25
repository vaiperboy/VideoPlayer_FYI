# Video Player
This project is a simple video player application built using the Qt framework and QML (Qt Modeling Language). It allows users to select a video file, drag and drop video files, and play them in a separate window. The player includes standard video player controls such as play, pause, and a scrubber.

### Usage 
When the application is launched, the user will be presented with a window containing a button that says "Drop File or Choose file". The user can either click on this button to open a file dialog and select a video file or drag and drop a video file onto the window.

Once you have selected a video file, it will open in the custom video player window. The video player window has the following controls:

- **Play/Pause button:** Clicking this button will toggle between playing and pausing the video.
- **Scrubber/slider:** This allows you to scrub through the video by dragging the handle to different positions.
- **Space bar:** Pressing the space bar will also toggle between playing and pausing the video.
- **Click on video:** Clicking on the video itself will also toggle between playing and pausing the video.

### Code Structure
The Video Player application is split into two QML files: `VideoDragger.qml` and `VideoPlayer.qml`. The `VideoDragger.qml` file contains the main window for the application, which allows the user to select or drag and drop a video file. Once a valid file is selected, the openPlayer function in this file creates a new window using the `VideoPlayer.qml` file.

The `VideoPlayer.qml` file contains the video player controls and the video itself. It uses the Video component from the QtMultimedia module to display the video. The Slider component is used to create the scrubber control, which allows the user to navigate the video. The Keys and MouseArea components are used to add keyboard and mouse control to the video player.

### Conclusion
The Video Player application is a simple example of how to create a video player using the Qt framework and QML. It demonstrates how to use the QtMultimedia module to display videos and how to create video player controls using QML components such as `Slider`, `Keys`, and `MouseArea`. This application can be used as a starting point for more complex video player projects or as a learning resource for those interested in developing applications using the Qt framework.