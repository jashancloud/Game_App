class StatisticModel{

  final int wins;
  final int loses;
  final int streak;
  final List<int> attempts;

  const StatisticModel({
    required this.wins,
    required this.loses,
    required this.streak,
    required this.attempts,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) => StatisticModel(
    wins: json['wins'] as int,
    loses: json['loses'] as int,
    streak: json['streak'] as int,
    attempts: (json['attempts'] as List<dynamic>).map((e) => e as int).toList(),
  );

  static const zeroAttempts = <int>[0, 0, 0, 0, 0, 0];

  Map<String, Object?> toJson() => <String, Object?>{
    'wins': wins,
    'loses': loses,
    'streak': streak,
    'attempts': attempts,
  };

}