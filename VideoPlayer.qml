import QtQuick.Controls 2.5
import QtQuick
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import QtMultimedia


Window {
    visible: true
    title: qsTr("Video Player 1.0")
    id: root
    property string videoSource: ""
    minimumWidth: 1000
    minimumHeight: 600
    color: "transparent"
    opacity: 1.5

    //Create a Video component
    Video {
        id: video
        source: videoSource
        focus: true
        fillMode: VideoOutput.PreserveAspectFit
        width: parent.width
        height: parent.height

        Keys.onSpacePressed: {
            switchState()
        }

        //Registering events
        onPlaying: { hasResumed(); scrubberAnimation.start(); }
        onPaused: { hasPaused() }
        onStopped: { hasPaused() }

        //To allow pause/play when click on video
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                switchState()
            }
        }

        //always helpful to log
        onErrorOccurred: function (message){
            console.log(message)
        }


        //simple scrubber/slider
        Slider {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            id: scrubber
            from: 0
            to: video.duration
            value: video.position
            width: parent.width - 130
            onValueChanged: {
                video.position = value
            }
            onPressedChanged: {
                video.pause()
            }
            // Customize the slider handle
            // Where credit is due
            //https://doc.qt.io/qt-6.2/qtquickcontrols2-customize.html#customizing-slider
            handle: Rectangle {
                x: scrubber.leftPadding + scrubber.visualPosition * (scrubber.availableWidth - width)
                y: scrubber.topPadding + scrubber.availableHeight / 2 - height / 2
                implicitWidth: 30
                implicitHeight: 30
                radius: 13
                color: "#f6f6f6"
                border.color: "#bdbebf"
            }
            // Customize filled and unfilled bar
            background: Rectangle {
                x: scrubber.leftPadding
                y: scrubber.topPadding + scrubber.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: scrubber.availableWidth
                height: implicitHeight
                radius: 3
                color: "#CAD2E4"

                Rectangle {
                    width: scrubber.visualPosition * parent.width
                    height: parent.height
                    color: "#3466DA"
                    radius: 2
                }
            }

            // For text on top of handle
            Rectangle {
                color: "white"
                x: scrubber.handle.x + scrubber.handle.width/2 - width/2
                y: scrubber.handle.y - height - 5
                width: 60
                height: 30
                radius: 5
                Text {
                    text: formatTime(video.position)
                    anchors.centerIn: parent
                    font.pixelSize: 16
                    color: "black"
                }
            }

            // Add the current position text
            Text {
                text: formatTime(video.position) // Assume formatTime is defined elsewhere
                font.pixelSize: 12
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                x: scrubber.x - 105
            }

            // Add the video length text
            Text {
                text: formatTime(video.duration) // Assume formatTime is defined elsewhere
                font.pixelSize: 12
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 40
                x: scrubber.width - 30
            }
        }

        // Animation for when the mouse
        // is not on the scrubber
        NumberAnimation {
            id: scrubberAnimation
            target: scrubber
            properties: "opacity"
            to: 0
            duration:  1500
            onFinished: {
                scrubber.opacity = 1
                scrubber.visible = false
            }
            //if stopped, return to original state
            onStopped: {
                scrubber.opacity = 1
            }
        }

        // To detect onHover for the scrubber
        MouseArea {
            hoverEnabled: true
            propagateComposedEvents: true
            preventStealing: true
            cursorShape: Qt.PointingHandCursor
            onClicked: mouse.accepted = false
            onPressed: mouse.accepted = false
            onPressAndHold: mouse.accepted = false
            anchors.fill: scrubber
            onEntered: {
                scrubberAnimation.stop()
                scrubber.visible = true
            }

            onExited: {
                if (video.playbackState == MediaPlayer.PlayingState)
                    scrubberAnimation.start()
            }
        }
    }

    // Convert seconds to MM:SS
    // or HH:MM:SS if it has hours
    function formatTime(ms) {
        let seconds = Math.floor(ms / 1000);
        let minutes = Math.floor(seconds / 60);
        let hours = Math.floor(minutes / 60);

        // calculate remaining minutes and seconds
        seconds %= 60;
        minutes %= 60;

        // pad single digit values with leading zero
        if (seconds < 10) {
            seconds = "0" + seconds;
        }
        if (minutes < 10) {
            minutes = "0" + minutes;
        }

        // if there are hours, add them to the output
        if (hours > 0) {
            if (hours < 10) {
                hours = "0" + hours;
            }
            return hours + ":" + minutes + ":" + seconds;
        }

        // otherwise, only show minutes and seconds
        return minutes + ":" + seconds;
    }

    // when video is started
    function hasResumed() {
        pausePlayButton.text = "\u23F5"
        animate()
    }

    // when video is stopped
    function hasPaused() {
        pausePlayButton.text = "\u23F8"
        animate()
    }

    // animate the pause/play button
    // or trigger the animation (so to say)
    function animate() {
        pausePlayButton.opacity = 0
        pausePlayButton.scale = 1.5

        //to reset animation
        pausePlayButton.opacity = 1
        pausePlayButton.scale = 1
    }

    // switch video state
    function switchState() {
        video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
    }

    RoundButton {
        id: pausePlayButton
        text: "\u23F5"
        anchors.centerIn: parent
        font.pixelSize: 70
        height: 130
        width: 130
        palette.button: "grey"

        //tried to solve the pause button being
        //converted to emoji by changing the
        //font family. No luck due to Windows
        font.family: "Helvetica, Arial"
        font.hintingPreference: Font.PreferNoHinting
        onClicked: {
            switchState()
        }

        // Animation for disappearing
        Behavior on opacity {
            NumberAnimation {
                duration: 500
                from: 1
                to: 0
            }
        }
        // Animation for scaling
        Behavior on scale {
            NumberAnimation {
                duration: 500
                from: 1
                to: 1.5
            }
        }
    }
}
