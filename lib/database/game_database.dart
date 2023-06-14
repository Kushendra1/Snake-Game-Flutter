import 'dart:async';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class DatabaseManager {
  DatabaseManager._();

  static final DatabaseManager db = DatabaseManager._();
  static PostgreSQLConnection? _connection;

  Future<PostgreSQLConnection> get database async {
    if (_connection != null) _connection;

    _connection = await initDb();
    return _connection!;
  }

  Future<PostgreSQLConnection> initDb() async {
    return PostgreSQLConnection(
      '34.70.56.195',
      5432,
      'postgres',
      username: 'postgres',
      password: 'snakegame02',
      isUnixSocket: false,
      timeoutInSeconds: 60,
      queryTimeoutInSeconds: 60,
    );
  }

  Future _connect() async {
    final db = await database;
    await db.open();
    debugPrint("Connection opened");
  }

  Future addUser(String username, String email) async {
    try {
      final db = await database;
      await db.open();

      await db.query(
        'INSERT INTO users (username, email) VALUES (@username, @email)',
        substitutionValues: {'username': username, 'email': email},
      );

      await db.close();
    } catch (e) {
      print('Error adding user: $e');
      await db.close();
    }
  }

  Future addGame(String email, int score) async {
    try {
      final db = await database;
      await db.open();
      var userResult = await db.query(
        'SELECT user_id FROM users WHERE email = @email',
        substitutionValues: {'email': email},
      );
      if (userResult.isEmpty) {
        throw Exception('User not found');
      }
      var userId = userResult.first.single;

      DateTime now = DateTime.now();

      await db.query(
        'INSERT INTO games (user_id, date_played, score) VALUES (@userId, @now, @score)',
        substitutionValues: {'userId': userId, 'now': now, 'score': score},
      );

      var result = await db.query(
        'SELECT LASTVAL()',
      );
      var gameId = result.first.first;

      await db.query(
        'INSERT INTO high_scores (user_id, score, date_achieved) '
        'VALUES (@userId, @score, @now) '
        'ON CONFLICT (user_id) DO UPDATE SET score = EXCLUDED.score '
        'WHERE high_scores.score < EXCLUDED.score OR high_scores.score IS NULL',
        substitutionValues: {
          'userId': userId,
          'score': score,
          'now': now,
        },
      );

      await db.close();
    } catch (e) {
      print('Error adding game: $e');
      await db.close();
    }
  }

  Future<List<Map<String, dynamic>>> getAllUserGames(String email) async {
    try {
      final db = await database;
      await db.open();
      var result = await db.query(
        'SELECT games.*'
        'FROM games '
        'JOIN users ON users.user_id = games.user_id '
        'WHERE users.email = @email',
        substitutionValues: {'email': email},
      );
      await db.close();
      return result.toList().map((row) => row.toTableColumnMap()).toList();
    } catch (e) {
      print('Error getting all user games: $e');
      await db.close();
      return [];
    }
  }

  Future<int?> getUserHighScore(String email) async {
    try {
      final db = await database;
      await db.open();
      var result = await db.query(
        'SELECT MAX(score) AS high_score FROM high_scores '
        'JOIN users ON users.user_id = high_scores.user_id '
        'WHERE users.email = @email',
        substitutionValues: {'email': email},
      );

      await db.close();
      return result[0][0];
    } catch (e) {
      print('Error getting user high score: $e');
      await db.close();
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTop100Leaderboard() async {
    try {
      final db = await database;
      await db.open();
      var result = await db.query(
        'SELECT users.username, high_scores.score '
        'FROM high_scores '
        'JOIN users ON users.user_id = high_scores.user_id '
        'ORDER BY high_scores.score DESC '
        'LIMIT 100',
      );
      await db.close();
      return result.toList().map((row) => row.toTableColumnMap()).toList();
    } catch (e) {
      print('Error getting top 100 leaderboard: $e');
      await db.close();
      return [];
    }
  }

  Future close() async {
    final db = await database;
    await db.close();
    debugPrint("Connection closed");
  }
}

// void main() async {
//   print("starting test");
//   final db = DatabaseManager();
//   final db1 = DatabaseManager();
//   print(identical(db, db1));
//   await db.connect();
//   //await db.addUser("hello","hello@gmail.com");
//   //await db.addUser("testd","testd@gmail.com");
//   // await db.addGame("testc@gmail.com", 100);
//   // await db.addGame("testc@gmail.com", 100);
//   // await db.addGame("testd@gmail.com", 200);
//   // await db.addGame("testd@gmail.com", 300);
//   var res = await db.getAllUserGames("testd@gmail.com");
//   // var res = await db.getUserHighScore("testc@gmail.com");
//   print(res);
//   print("IN");
//   await db.close();
// }