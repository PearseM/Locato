import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrated_project/resources/pin.dart';

class Database {
  
  static Stream<QuerySnapshot> getPins() {
    return Firestore.instance.collection("pins").snapshots();
  }
  
  static void addPin(Pin pin) {
    Firestore.instance.collection("pins").add(pin.asMap());
  }
}