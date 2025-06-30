// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExamModel {
  String examName;
  String authorID;
  List<String> memberID;
  List<Question> questions;
  int createAt;
  ExamModel({
    required this.examName,
    required this.authorID,
    required this.memberID,
    required this.questions,
    required this.createAt,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'examName': examName});
    result.addAll({'authorID': authorID});
    result.addAll({'memberID': memberID});
    result.addAll({'createAt': createAt});
    if (questions.isNotEmpty) {
      result['questions'] = questions.map((ques) => ques.toMap()).toList();
    }
    return result;
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    List<Question> tempQuestion = [];
    if (map['questions'] != null) {
      map['questions'].forEach((v) {
        tempQuestion.add(Question.fromMap(v));
      });
    }
    return ExamModel(
      examName: map['examName'] ?? '',
      authorID: map['authorID'] ?? '',
      memberID: List<String>.from(map['memberID'] ?? {}),
      createAt: map['createAt'],
      questions: tempQuestion,
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
