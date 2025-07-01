import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/apis/fire_store_instance.dart';
import 'package:social_app/models/exam_model.dart';

class ExamApi {
  Future<String> addNewExam({required ExamModel exam}) async {
    DocumentReference doc = await FireStoreInstance.db.collection("exam").add(exam.toMap());
    return doc.id;
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

  Future<void> updateExam({required String examId, required ExamModel newData}) async {
    await FireStoreInstance.db.collection("exam").doc(examId).set(newData.toMap());
  }
}
