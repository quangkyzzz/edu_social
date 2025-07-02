// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExamModel {
  String examName;
  String authorID;
  List<String> memberID;
  List<Question> questions;
  int createAt;
  Duration duration;
  List<History> historys;
  ExamModel({
    required this.examName,
    required this.authorID,
    required this.memberID,
    required this.questions,
    required this.createAt,
    required this.duration,
    required this.historys,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'examName': examName});
    result.addAll({'authorID': authorID});
    result.addAll({'memberID': memberID});
    result.addAll({'createAt': createAt});
    result.addAll({'duration': duration.inMilliseconds});
    if (questions.isNotEmpty) {
      result['questions'] = questions.map((ques) => ques.toMap()).toList();
    }
    if (historys.isNotEmpty) {
      result['historys'] = historys.map((his) => his.toMap()).toList();
    }
    return result;
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    List<Question> tempQuestion = [];
    List<History> tempHistory = [];
    if (map['questions'] != null) {
      map['questions'].forEach((v) {
        tempQuestion.add(Question.fromMap(v));
      });
    }
    if ((map['historys'] != null) && map['historys'].isNotEmpty) {
      map['historys'].forEach((v) {
        tempHistory.add(History.fromMap(v));
      });
    }
    return ExamModel(
      examName: map['examName'] ?? '',
      authorID: map['authorID'] ?? '',
      memberID: List<String>.from(map['memberID'] ?? {}),
      duration: Duration(milliseconds: map['duration'] ?? 300000),
      createAt: map['createAt'],
      questions: tempQuestion,
      historys: tempHistory,
    );
  }
}

class Question {
  String content = '';
  List<String> options = ['', '', '', ''];
  int correctAnswerIndex = 0;

  Question({this.content = '', required this.options, this.correctAnswerIndex = 0});

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    List<String> tempOption = [];
    if (map['options'] != null) {
      map['options'].forEach((v) {
        tempOption.add(v);
      });
    }
    return Question(
      content: map['content'] ?? '',
      options: tempOption,
      correctAnswerIndex: map['correctAnswerIndex'],
    );
  }
}

class History {
  String memberID;
  Duration durationTake;
  List<int> listAnswer;
  History({
    required this.memberID,
    required this.durationTake,
    required this.listAnswer,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'memberID': memberID});
    result.addAll({'durationTake': durationTake.inMilliseconds});
    result.addAll({'listAnswer': listAnswer});
    return result;
  }

  factory History.fromMap(Map<String, dynamic> map) {
    List<Question> tempQuestion = [];
    if (map['questions'] != null) {
      map['questions'].forEach((v) {
        tempQuestion.add(Question.fromMap(v));
      });
    }
    return History(
      memberID: map['memberID'] ?? '',
      durationTake: Duration(milliseconds: map['durationTake'] ?? 0),
      listAnswer: List<int>.from(map['listAnswer'] ?? {}),
    );
  }
}
