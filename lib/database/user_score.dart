class UserScore {
  final String username;
  final int score;

  UserScore({required this.username, required this.score});

  factory UserScore.fromJson(Map<String, dynamic> json) {
    final username = json['users']['username'];
    final score = (json['high_scores']['score']);
    return UserScore(username: username, score: score);
  }
}
