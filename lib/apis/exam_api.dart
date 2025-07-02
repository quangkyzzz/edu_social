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

  Future<void> updateExam({required String examId, required Map<String, dynamic> newData}) async {
    await FireStoreInstance.db.collection("exam").doc(examId).update(newData); //.set(newData.toMap());
  }

  Future<void> updateExamHistory({
    required int createAt,
    required List<int> listAns,
    required int durationTake,
    required String userID,
    required List<History> oldHistory,
  }) async {
    var snapShot = await FireStoreInstance.db
        .collection("exam")
        .where('createAt', isEqualTo: createAt)
        .get(); //.doc(examId).set(newData.toMap());
    var firstDoc = snapShot.docs.firstOrNull;
    var docId = firstDoc?.id;
    List<Map<String, dynamic>> newData = [];
    for (var history in oldHistory) {
      newData.add(history.toMap());
    }
    Map<String, dynamic> newHis =
        History(memberID: userID, durationTake: Duration(seconds: durationTake), listAnswer: listAns).toMap();
    newData.add(newHis);
    await FireStoreInstance.db.collection('exam').doc(docId).update({'historys': newData});
  }
}
