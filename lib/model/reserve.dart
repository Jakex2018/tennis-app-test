import 'package:cloud_firestore/cloud_firestore.dart';

class Reserve {
  final String reserveId;
  final String userId;
  final String courtId;
  final String instructorId;
  final String comment;
  final DateTime dateReserve;
  final DateTime hourStart;
  final DateTime hourEnd;
  final DateTime dateCreate;

  Reserve({
    required this.instructorId,
    required this.comment,
    required this.reserveId,
    required this.dateReserve,
    required this.hourEnd,
    required this.dateCreate,
    required this.userId,
    required this.courtId,
    required this.hourStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'instructorId': instructorId,
      'reserveId': reserveId,
      'userId': userId,
      'courtId': courtId,
      'dateReserve': Timestamp.fromDate(dateReserve),
      'hourStart': Timestamp.fromDate(hourStart),
      'hourEnd': Timestamp.fromDate(hourEnd),
      'dateCreate': Timestamp.fromDate(dateCreate),
      'comment': comment,
    };
  }

  static Reserve fromMap(Map<String, dynamic> map) {
    return Reserve(
      comment: map['comment'] ,
      reserveId: map['reserveId'],
      dateCreate: DateTime.parse(map['dateCreate']),
      dateReserve: DateTime.parse(map['dateReserve']),
      courtId: map['courtId'],
      hourStart: DateTime.parse(map['startTime']),
      hourEnd: DateTime.parse(map['endTime']),
      userId: map['userId'],
      instructorId: map['instructorId'],
    );
  }

  factory Reserve.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reserve(
      instructorId: data['instructorId'],
      reserveId: doc.id,
      userId: data['userId'],
      courtId: data['courtId'],
      comment: data['comment'],
      dateReserve: (data['dateReserve'] as Timestamp).toDate(),
      hourStart: (data['hourStart'] as Timestamp).toDate(),
      hourEnd: (data['hourEnd'] as Timestamp).toDate(),
      dateCreate: (data['dateCreate'] as Timestamp).toDate(),
    );
  }
}


