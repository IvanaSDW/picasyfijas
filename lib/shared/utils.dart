import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

Rect getRect(GlobalKey key) {
  final box = key.currentContext!.findRenderObject() as RenderBox;
  return box.paintBounds;
}

Timestamp dateTimeToTimeStamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

DateTime timestampToDate(Timestamp timestamp) {
  return timestamp.toDate();
}