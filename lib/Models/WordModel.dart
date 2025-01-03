class WordModel{

  final String secretWord,meaning;
  final bool isWin;
  final int level;

  WordModel({required this.secretWord, required this.meaning, required this.isWin,this.level=0});

  Map<String,dynamic> toMap(){
    return {
      "secretWord":secretWord,
      "meaning":meaning,
      "isWin":isWin,
      "level":level,
    };
  }

  factory WordModel.fromMap(Map<String,dynamic>map){
    return WordModel(secretWord: map["secretWord"], meaning: map["meaning"],level: map["level"] as int, isWin: map["isWin"] as bool);
  }
}