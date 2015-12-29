import QtQuick 2.0

//ChannelList.qml
GridView{
    property variant selectedChannel
    property int cellSize
    property bool tooltipEnabled: false

    id: root
    //focus: true

    cellHeight: cellSize
    maximumFlickVelocity: 800
    cellWidth: cellHeight

    function setFocus(){
        var mX = mArea.mouseX
        var mY = mArea.mouseY
        var index = indexAt(contentX + mX, contentY + mY)

        g_tooltip.hide()

        if (mArea.containsMouse) {
            root.currentIndex = index
            if (tooltipEnabled)
                tooltipTimer.restart()
        }
//        else {
//            if (tooltipEnabled)
//                g_tooltip.hide()
//        }
    }

    onContentYChanged: setFocus()
    onContentXChanged: setFocus()

    MouseArea{
        id: mArea
        anchors.fill: parent
        hoverEnabled: true

        onMouseXChanged: setFocus()
        onMouseYChanged: setFocus()

        Timer {
            id: tooltipTimer
            interval: 800
            running: false
            repeat: false
            onTriggered: {
                if (tooltipEnabled){
                    g_tooltip.hide()

                    var mX = mArea.mouseX
                    var mY = mArea.mouseY
                    var index = indexAt(contentX + mX, contentY + mY)

                    if (mArea.containsMouse && index > -1 && selectedChannel && selectedChannel.online)
                        g_tooltip.displayChannel(g_rootWindow.x + root.parent.parent.x + parent.mouseX,
                                                 g_rootWindow.y + root.parent.parent.y + parent.mouseY,
                                                 selectedChannel)
                }
            }
        }
    }

    onCurrentItemChanged: {
        if (selectedChannel && typeof selectedChannel.setHighlight === 'function')
            selectedChannel.setHighlight(false)

        if (currentItem && typeof currentItem.setHighlight === 'function'){
            selectedChannel = currentItem
            selectedChannel.setHighlight(true)
        }
    }
}
