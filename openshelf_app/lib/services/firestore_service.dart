import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  Future<void> addBook(String title, String author) async {
    await books.add({
      'title': title,
      'author': author,
      'available': true,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getBooks() {
    return books.snapshots();
  }

  Future<void> deleteBook(String docId) async {
    await books.doc(docId).delete();
  }
}
