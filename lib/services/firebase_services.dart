import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:roomify/models/Property.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> saveProperty(Property property, User user) async {
  final id = firestore.collection('properties').doc().id;

  List<String> imagesUrls = [];
  for (var image in property.images) {
    final url = await uploadImages(image, id);
    imagesUrls.add(url);
  }

  try {
    final data = property.toMap();
    data.remove('images');
    data['imagesUrls'] = imagesUrls;
    data['userId'] = user.uid;
    data['createdAt'] = FieldValue.serverTimestamp();

    await firestore.collection('properties').doc(id).set(data);
  } catch (e) {
    print('Error: $e');
  }
}

Future<String> uploadImages(XFile image, String id) async {
  final compressedFile = await FlutterImageCompress.compressWithFile(
    image.path,
    quality: 70,
  );

  final ref = FirebaseStorage.instance.ref().child(
    'property/$id/${DateTime.now().microsecondsSinceEpoch}.jpg',
  );

  UploadTask uploadTask = ref.putData(compressedFile!);
  TaskSnapshot snapshot = await uploadTask;
  return await snapshot.ref.getDownloadURL();
}

Future<List<String>> getServices() async {
  final querySnapshot = await firestore.collection('services').get();
  List<String> services =
      querySnapshot.docs.map((doc) => doc['name'] as String).toList();

  return services;
}

Future<List<String>> getPets() async {
  final querySnapshot = await firestore.collection('pets').get();
  List<String> pets =
      querySnapshot.docs.map((doc) => doc['name'] as String).toList();

  return pets;
}

Future<Property?> getProperty(String uid) async {
  try {
    final doc = await firestore.collection('properties').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      data!['id'] = doc.id;
      return Property.fromMap(data);
    } else {
      return null;
    }
  } catch (e) {
    print('Error al obtener la propiedad: $e');
    return null;
  }
}

Future<List<Property>>? getProperties() async {
  final querySnapshot = await firestore.collection('properties').get();
  List<Property> properties = [];

  for (var doc in querySnapshot.docs) {
    final data = doc.data();
    data['uid'] = doc.id;
    properties.add(Property.fromMap(data));
  }
  return properties;
}

Future<List<Image>> getImages(List<String>? imagesUrls) async {
  final List<Image> images = [];
  if (imagesUrls != null && imagesUrls.isNotEmpty) {
    for (var url in imagesUrls) {
      images.add(Image.network(url, fit: BoxFit.cover));
    }
  }
  return images;
}
