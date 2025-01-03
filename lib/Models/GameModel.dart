import 'package:game_app/Models/letter_info.dart';

class GameModel {
  final String secretWord, meaning;
  final List<LetterInfo> board;
  final int attempt;
  final int mode;
  int level;
  bool isWin;
  bool isComplete;

  GameModel(
      {required this.secretWord,
      required this.meaning,
      required this.board, this.level=0, this.isWin=false,
      required this.attempt,required this.mode,this.isComplete=false});

  Map<String,dynamic> toMap(){
    return {
      "secretWord":secretWord,
      "meaning":meaning,
      "board":board,
      "level":level,
      "isWin":isWin,
      "attempt":attempt,
      "mode":mode,
      "isComplete":isComplete
    };
  }

  factory GameModel.fromMap(Map<String,dynamic>map){
    var map2 = map["board"] as List<dynamic>;
    var board = map2.map((map){
      return LetterInfo.fromJson(map);
    }).toList();
    return GameModel(secretWord: map["secretWord"], meaning: map["meaning"], board: board, level: map["level"] as int, isWin: map["isWin"] as bool, attempt: map["attempt"] as int, mode: map["mode"] as int,isComplete: map["isComplete"]);
  }
}
