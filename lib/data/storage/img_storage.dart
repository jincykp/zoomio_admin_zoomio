import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  //upload the image to firebase storage
  Future<String?> uploadImage(String path, BuildContext context) async {
    print("image uploading");
    File file = File(path);
    try {
      String fileName = DateTime.now().toString();
      Reference ref = storage.ref().child('vehicle_images/$fileName');
//upload the file
      UploadTask uploadtask = ref.putFile(file);
//wait the upload complete
      await uploadtask;
      //get the download url
      String downloadURL = await ref.getDownloadURL();
      print("download url : $downloadURL");
      return downloadURL;
    } catch (e) {
      print("there is an error");
      print(e);
      return null;
    }
  }
}

class VehicleDocumentStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Upload a single vehicle document to Firebase Storage
  Future<String?> uploadVehicleDocument(
      String path, BuildContext context) async {
    print("Uploading vehicle document...");
    File file = File(path);
    try {
      String fileName = DateTime.now().toString();
      Reference ref = storage.ref().child('vehicle_documents/$fileName');

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      print("Vehicle document download URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Error uploading vehicle document: $e");
      return null;
    }
  }

  // Upload multiple vehicle documents to Firebase Storage
  Future<List<String?>> uploadMultipleVehicleDocuments(
      List<String> paths, BuildContext context) async {
    List<String?> downloadURLs = [];
    for (String path in paths) {
      String? downloadURL = await uploadVehicleDocument(path, context);
      downloadURLs.add(downloadURL);
    }
    return downloadURLs;
  }
}
