import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/apis/fire_store_instance.dart';
import 'package:social_app/models/exam_model.dart';

class ExamApi {
  Future<void> addNewExam({required ExamModel exam}) async {
    await FireStoreInstance.db
        .collection("exam")
        .add(exam.toMap())
        .then((DocumentReference doc) => print('qqq DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<List<ExamModel>> getExam() async {
    List<ExamModel> result = [];
    await FireStoreInstance.db.collection("exam").orderBy('createAt').get().then((event) {
      for (var doc in event.docs) {
        result.add(ExamModel.fromMap(doc.data()));
      }
    });
    return result;
  }
}
