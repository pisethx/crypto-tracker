import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('transactions');
final String collectionName = 'transactions';

class Database {
  static String userUid;

  static Future<void> addItem({
    @required String asset,
    @required double amount,
    @required double price,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection(collectionName).doc();

    Map<String, dynamic> data = <String, dynamic>{
      "asset": asset,
      "amount": amount,
      "price": price,
      "created": Timestamp.now()
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Transaction added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    @required String asset,
    @required double amount,
    @required double price,
    @required String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection(collectionName).doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "asset": asset,
      "amount": amount,
      "price": price,
      "created": Timestamp.now()
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Transaction updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    Query itemCollection = _mainCollection.doc(userUid).collection(collectionName).orderBy('created', descending: true);

    return itemCollection.snapshots();
  }

  static Future<void> deleteItem({
    @required String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection(collectionName).doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Transaction deleted from the database'))
        .catchError((e) => print(e));
  }
}
