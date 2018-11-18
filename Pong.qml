import QtQuick 2.9


Item {
    id: game

    property var primaryColor: "#3f3f3";
    property var secondaryColor: "#f3f3f3"

    function start() {
        _timer.start();
    }


    Item {
        id: _field
        anchors.fill: parent

        Rectangle {
            id: _fieldLeft
            color: primaryColor
            width: parent.width/2
            height: parent.height
        }
        Rectangle {
            color: secondaryColor
            width: parent.width/2
            height: parent.height
            anchors.left: _fieldLeft.right
        }
    }

    Rectangle {
        id: player
        focus: true
        width: 30
        height: parent.height/5
        x: 0
        y: _field.height/2 - height/2
        color: secondaryColor

        property int points: 0
        property real speed: 20
        Keys.onUpPressed: {
            if(player.y - speed < 0) {
                player.y = 0
            } else {
                player.y -= speed
            }
        }
        Keys.onDownPressed: {
            var limit = _field.height - this.height
            if(player.y + speed > limit) {
                player.y = limit
            } else {
                player.y += speed
            }
        }
        Keys.onSpacePressed: game.start()
    }

    Rectangle {
        id: player2
        focus: true
        width: 30
        height: parent.height/5
        x: _field.width - width
        y: _ball.y - height/2
        color: primaryColor

        property int points: 0
        property var speed: 20

        Keys.onUpPressed: {
            if(player.y - speed < 0) {
                player.y = 0
            } else {
                player.y -= speed
            }
        }
        Keys.onDownPressed: {
            var limit = _field.height - this.height
            if(player.y + speed > limit) {
                player.y = limit
            } else {
                player.y += speed
            }
        }
    }

    Item {
        id: _ball
        width: parent.height/20
        height: width
        y: _field.height/2 - height/2
        x: _field.width/2 - width/2

        Rectangle {
            id: ball_white
            height: parent.height;
            color: secondaryColor

            width: {
                var currentX = _field.width/2 - _ball.x;
                if(currentX > 0) {
                    return (currentX < _ball.width) ? currentX : _ball.width;
                }
                return 0;
            }
        }
        Rectangle {
            id: ball_black
            height: parent.height;
            color: primaryColor
            anchors.left: ball_white.right

            width: {
                var currentX = (_ball.x + _ball.width) - _field.width/2;
                if(currentX > 0) {
                    return (currentX < _ball.width) ? currentX : _ball.width;
                }
                return 0;
            }
        }

        property real speed: 20
        property real angle: 0

        Timer {
            id: _timer
            interval: 50
            repeat: true
            running: true
            onTriggered: {
                _ball.move()
            }
        }

        function hitPlayer(){
            var currentPlayer = (this.speed > 0 ) ? player2 : player;


            if((speed > 0 && (this.x + this.width) < _field.width - currentPlayer.width)
              || (speed < 0 && this.x > currentPlayer.width)) {
                return -99;
            }
            var y0 = this.y
            var y1 = this.y + this.height

            if((y0 > currentPlayer.y && (y0 < currentPlayer.y + currentPlayer.height))
               || (y1 > currentPlayer.y && (y1 < currentPlayer.y + currentPlayer.height))) {
                var ballCenter = y0 + this.height/2
                var playerCenter = currentPlayer.y + currentPlayer.height/2;
                return (ballCenter - playerCenter) / 50;
            }
            return -99;
        }

        function move() {
            if(this.x < 0 || (this.x + this.width) > _field.width) {
                if(speed > 0){
                    player.points++;
                } else {
                    player2.points++;
                }

                speed = -speed
                angle = 0
                _timer.stop();
                this.x = _field.width/2 - this.width/2;
                this.y = _field.height/2 - this.height/2;
                return;

            }
            var hit = hitPlayer();
            if(hit !== -99) {
                speed = - speed;
                angle = hit;
            }

            if(this.y <= 0 || (this.y + this.height) >= _field.height) {
                angle = -angle;
            }

            this.x += speed
            this.y += speed*angle
        }
    }

    Item {
        id: scoreBoard
        width: parent.width/4
        height: parent.height/10
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            font.pixelSize: parent.height
            text: player.points
            color: secondaryColor
            anchors.left: parent.left
        }

        Text {
            font.pixelSize: parent.height
            text:  player2.points
            color: primaryColor
            anchors.right: parent.right
        }
    }

    MouseArea {
        anchors.fill: game
        onPressed: {
            game.start()
        }
        onMouseYChanged: {
            if(mouseY < player.height/2)
                player.y = 0;
            else if(mouseY + player.height/2 > _field.height) {
                player.y = _field.height - player.height;
            } else {
                player.y = mouseY - player.height/2;
            }
        }
    }
}
