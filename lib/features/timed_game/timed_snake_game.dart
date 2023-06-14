// Snake Game Mechanics
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/HeaderText.dart';
import 'package:frontend/main.dart';

import '../../database/game_database.dart';

enum Direction { left, right, up, down }

enum SwipeDirection {
  left,
  right,
  up,
  down,
}

SwipeDirection getSwipeDirection(Offset swipe) {
  final angle = swipe.direction;
  if (angle > -pi / 4 && angle < pi / 4) {
    return SwipeDirection.right;
  } else if (angle > pi / 4 && angle < 3 * pi / 4) {
    return SwipeDirection.down;
  } else if (angle > -3 * pi / 4 && angle < -pi / 4) {
    return SwipeDirection.up;
  } else {
    return SwipeDirection.left;
  }
}

class TimedSnakeGame extends StatefulWidget {
  @override
  _TimedSnakeGameState createState() => _TimedSnakeGameState();
}

class _TimedSnakeGameState extends State<TimedSnakeGame> {
  final int numTiles = 20;
  final double tileSize = 20.0;

  List<Point<int>> snake = [Point(10, 10), Point(10, 11)];
  Point<int> food = Point(5, 5);
  Point<int> direction = Point(1, 0);

  Size screenSize = window.physicalSize / window.devicePixelRatio;

  int score = 0;
  double speed = 1.5;
  late Timer timer;
  double timeLeft = 20;
  bool gameOver = false;

  late Timer snakeTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
    setState(() {
      moveSnake();
    });
  });

  late Timer scoreTimer = Timer.periodic(Duration(minutes: 1), (timer) {
    setState(() {
      score += 5;
    });
  });

  @override
  void initState() {
    super.initState();
    initializeSnakeTimer();
    initializeTimer();
  }

  void initializeSnakeTimer() {
    snakeTimer =
        Timer.periodic(Duration(milliseconds: (500 ~/ speed).toInt()), (timer) {
      setState(() {
        moveSnake();
      });
    });
  }

  void initializeTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        timeLeft -= 0.1;
        if (timeLeft <= 0) {
          gameOver = true;
          snakeTimer.cancel();
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    snakeTimer.cancel();
    scoreTimer.cancel();
    timer.cancel();
    super.dispose();
  }

  void moveSnake() {
    Point<int> head = snake.last + direction;
    if (head.x < 0 ||
        head.x >= screenSize.width / tileSize ||
        head.y < 0 ||
        head.y >= (screenSize.height / tileSize) - 9) {
      gameOver = true;
      snakeTimer.cancel();
      timer.cancel();
      return;
    }
    for (int i = 0; i < snake.length - 1; i++) {
      if (head == snake[i]) {
        gameOver = true;
        snakeTimer.cancel();
        timer.cancel();
        return;
      }
    }
    snake.add(head);
    if (head == food) {
      score++;
      speed *= 1.25;
      timeLeft += 2.0;
      generateFood();
      snakeTimer.cancel();
      initializeSnakeTimer();
    } else {
      snake.removeAt(0);
    }
  }

  void generateFood() {
    food = Point(Random().nextInt(numTiles), Random().nextInt(numTiles));
  }

  void handleTapDown(TapDownDetails details) {
    if (gameOver) {
      snakeTimer.cancel();
      timer.cancel();
      _createAGame();
      return;
    }
    setState(() {
      direction = calculateDirection(details.localPosition, tileSize);
    });
  }

  Point<int> calculateDirection(Offset localPosition, double tileSize) {
    Offset center = Offset(numTiles * tileSize / 2, numTiles * tileSize / 2);
    Offset delta = localPosition - center;
    if (delta.dx.abs() > delta.dy.abs()) {
      return Point(delta.dx.sign.toInt(), 0);
    } else {
      return Point(0, delta.dy.sign.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    stackChildren.add(buildSnake());
    stackChildren.add(buildFood());
    if (gameOver) {
      _createAGame();
      stackChildren.add(buildGameOver());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Snake Game"),
        ),
        body: SafeArea(
        child: Stack(
          children: [
            // background widget
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Image(
                image: AssetImage("assets/bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: HeaderText(
                    text: "Time Left: ${timeLeft.toStringAsFixed(1)}",
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanUpdate: (details) {
                        if (gameOver) {
                          _createAGame();
                          return;
                        }
                        Offset swipe = details.delta;
                        SwipeDirection direction = getSwipeDirection(swipe);
                        switch (direction) {
                          case SwipeDirection.up:
                            if (this.direction.y != 1) {
                              this.direction = Point(0, -1);
                            }
                            break;
                          case SwipeDirection.down:
                            if (this.direction.y != -1) {
                              this.direction = Point(0, 1);
                            }
                            break;
                          case SwipeDirection.left:
                            if (this.direction.x != 1) {
                              this.direction = Point(-1, 0);
                            }
                            break;
                          case SwipeDirection.right:
                            if (this.direction.x != -1) {
                              this.direction = Point(1, 0);
                            }
                            break;
                        }
                      },
                      child: Stack(children: stackChildren),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSnake() {
    List<Widget> snakeTiles = [];
    for (int i = 0; i < snake.length; i++) {
      Point<int> point = snake[i];
      Widget tile;
      if (i == snake.length - 1) {
        // If this is the head of the snake, use an image of a cat
        tile = Positioned(
          left: point.x * tileSize,
          top: point.y * tileSize,
          child: Image.asset(
            'assets/cat.png',
            width: tileSize,
            height: tileSize,
          ),
        );
      } else {
        // Otherwise, use a green container
        tile = Positioned(
          left: point.x * tileSize,
          top: point.y * tileSize,
          child: Container(
            width: tileSize,
            height: tileSize,
            color: Colors.grey,
          ),
        );
      }
      snakeTiles.add(tile);
    }
    return Stack(children: snakeTiles);
  }


  Widget buildFood() {
    return Positioned(
      left: food.x * tileSize,
      top: food.y * tileSize,
      child: Icon(
        Icons.star,
        size: tileSize,
        color: Colors.yellow,
      ),
    );
  }

  Widget buildGameOver() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Game Over!",
            style: TextStyle(fontSize: 32.0),
          ),
          Text(
            "Score: $score",
            style: TextStyle(fontSize: 24.0),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                snake = [Point(10, 10), Point(10, 11)];
                food = Point(5, 5);
                direction = Point(1, 0);
                score = 0;
                speed = 1;
                gameOver = false;
                timeLeft = 20;
                snakeTimer.cancel();
                timer.cancel();
                initializeSnakeTimer();
                initializeTimer();
              });
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  Direction _snakeDirection = Direction.right;

  void updateDirection(Direction newDirection) {
    if (_snakeDirection == Direction.left && newDirection == Direction.right ||
        _snakeDirection == Direction.right && newDirection == Direction.left ||
        _snakeDirection == Direction.up && newDirection == Direction.down ||
        _snakeDirection == Direction.down && newDirection == Direction.up) {
      // The new direction is opposite to the current direction, so ignore it.
      return;
    }
    _snakeDirection = newDirection;
  }

  void handleSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.left &&
        _snakeDirection != Direction.right) {
      _snakeDirection = Direction.left;
    } else if (direction == SwipeDirection.right &&
        _snakeDirection != Direction.left) {
      _snakeDirection = Direction.right;
    } else if (direction == SwipeDirection.up &&
        _snakeDirection != Direction.down) {
      _snakeDirection = Direction.up;
    } else if (direction == SwipeDirection.down &&
        _snakeDirection != Direction.up) {
      _snakeDirection = Direction.down;
    }
  }

  // To be Check
  void _createAGame() async {
    final db = DatabaseManager.db;
    if (auth.currentUser != null) {
      final email = auth.currentUser?.email;
      if (email != null) {
        var res = db.addGame(email, score);
        debugPrint(res.toString());
      }
    }
  }
}
