import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/product_dao.dart';
import 'package:flutter/material.dart';

class FirebaseProvider
{
  late FirebaseFirestore _firestore;
  late CollectionReference _productsCollection;
  
  FirebaseProvider()
  {
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection('products');
  }

  Future<void> saveProduct(ProductDAO objDAO) => _productsCollection.add(objDAO.toMap());
  
  Future<void> updateProduct(ProductDAO objPDAO, String DocumentID)
  {
    return _productsCollection.doc(DocumentID).update(objPDAO.toMap());
  }

  Future<void> deleteProduct(String DocumentID)
  {
    return _productsCollection.doc(DocumentID).delete();
  }

  Stream<QuerySnapshot> getAllProducts()
  {
    return _productsCollection.snapshots();
  }
}