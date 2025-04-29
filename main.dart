
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(CatchTheBallApp());

class CatchTheBallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catch The Ball',
      home: CatchGame(),
    );
  }
}

class CatchGame extends StatefulWidget {
  @override
  _CatchGameState createState() => _CatchGameState();
}

class _CatchGameState extends State<CatchGame> {
  double playerX = 0;
  double ballX = 0;
  double ballY = -1;
  int score = 0;
  int lives = 3;
  bool gameStarted = false;
  Timer? timer;
  Random random = Random();

  void startGame() {
    gameStarted = true;
    ballY = -1;
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        ballY += 0.05;
        if (ballY > 1) {
          ballY = -1;
          ballX = random.nextDouble() * 2 - 1;
          lives -= 1;
          if (lives == 0) {
            timer.cancel();
            showGameOverDialog();
          }
        }

        if ((ballY - 0.9).abs() < 0.1 && (ballX - playerX).abs() < 0.2) {
          score += 1;
          ballY = -1;
          ballX = random.nextDouble() * 2 - 1;
        }
      });
    });
  }

  void moveLeft() {
    setState(() {
      playerX -= 0.1;
      if (playerX < -1) playerX = -1;
    });
  }

  void moveRight() {
    setState(() {
      playerX += 0.1;
      if (playerX > 1) playerX = 1;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text("Restart"),
          )
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      playerX = 0;
      ballX = 0;
      ballY = -1;
      score = 0;
      lives = 3;
      gameStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $score   Lives: $lives',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Expanded(
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(playerX, 0.9),
                    duration: Duration(milliseconds: 0),
                    child: Container(width: 50, height: 20, color: Colors.black),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(ballX, ballY),
                    duration: Duration(milliseconds: 0),
                    child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                  ),
                ],
              ),
            ),
            if (!gameStarted)
              ElevatedButton(onPressed: startGame, child: Text('Start Game')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: moveLeft, icon: Icon(Icons.arrow_left)),
                IconButton(onPressed: moveRight, icon: Icon(Icons.arrow_right)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
