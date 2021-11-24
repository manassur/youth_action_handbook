import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAnswer {
  final String? chosenOptionId;
  final String? id,questionId;
  final double? score;


  QuizAnswer({
    this.chosenOptionId,
    this.id,
    this.score,
    this.questionId
  });

  factory QuizAnswer.fromDoc(DocumentSnapshot? doc) {
    return QuizAnswer(
      id: doc!.id,
      chosenOptionId: doc['chosenOptionId'],
      score: doc['score'],
      questionId: doc['questionId'],
    );
  }
}
