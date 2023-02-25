import QtQuick.Controls 2.5
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

Window {
    width: 400
    height: 300
    visible: true
    title: qsTr("Video Player 1.0")

    //dont allow maximize or resize
    flags: Qt.Window | Qt.MSWindowsFixedSizeDialogHint | Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint
    id: root


    //open window in middle of screen
    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }


    //Give it a gradiant kind-of background
    Rectangle {
        width: parent.height
        height: parent.width
        anchors.centerIn: parent
        rotation: 90
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3a0872" }
            GradientStop { position: 1.0; color: "#3b205a" }
        }
    }

    //FileDialog for the file
    FileDialog {
        id: fileDialog
        title: "Choose a Video File"
        nameFilters: ["Video Files (*.mp4 *.avi *.mkv)"]
        onAccepted: {
            openPlayer(fileDialog.currentFile)
        }
    }

    function openPlayer(url) {
        //Went with the approach of hiding the
        //"choose video" window instead of closing
        //it so in future i might make it visible again
        var component = Qt.createComponent("VideoPlayer.qml")
        var window    = component.createObject(root)

        //Pass the video's location to the 2nd form
        window.videoSource = url

        //Handle the closing signal of the window
        window.closing.connect(function() {
            Qt.quit()
        })

        //Hide the current window
        root.visible = false
        window.show()
    }

    // For the DropArea (Unfortunately
    // re-write validExtensions)
    function isValidVideoFile(fileLocation) {
        // Get the file extension
        const extension = fileLocation.split('.').pop().toLowerCase();

        // Define the valid extensions
        const validExtensions = ['mp4', 'avi', 'mkv'];

        // Check if the extension is valid
        return validExtensions.includes(extension);
    }

    //Drag-drop area as well
    DropArea {
        id: drop
        anchors.fill: parent
        onDropped: {
            if (isValidVideoFile(drop.text)) {
                openPlayer(drop.text)
            } else {
                //To-do: show dialog or some error message
            }
        }
    }



    Button {
        id: fileButton
        text: qsTr("Drop File or Choose file")
        font.pointSize: 15
        anchors.centerIn: parent
        display: AbstractButton.TextUnderIcon
        flat: true

        // Set background color when hovered
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor
            hoverEnabled: true
            onClicked: {
                fileDialog.open()
            }
        }

        background: Rectangle {
            color: mouseArea.containsMouse ? "white" : "transparent"
            Behavior on color {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        //Icon to make it nice
        icon {
            source: "/images/drag_icon.png"
            height: 100
            width: 100
            color: "grey"
        }

        scale: hovered ? 1.2 : 1

        // Add a smooth transition effect
        Behavior on scale {
            NumberAnimation { duration: 400 }
        }

    }
}
