import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxy_tech/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientHistory extends StatefulWidget {
  const PatientHistory({super.key});

  @override
  State<PatientHistory> createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {
  Future<void> _uploadPDF() async {
    try {
      // Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Log file details
        print('File name: ${file.name}');
        print('File size: ${file.size}');
        print('File path: ${file.path}');
        print('File bytes: ${file.bytes}');

        // Read the file bytes from the path if file.bytes is null
        final fileBytes = file.bytes ?? await File(file.path!).readAsBytes();

        // Check if the file bytes are not null
        if (fileBytes.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Selected file is empty.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14,
          );
          return;
        }

        // Get the authenticated user's ID
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uid = user.uid;

          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref =
              storage.ref().child('prescriptions').child(uid).child(file.name);

          UploadTask uploadTask = ref.putData(fileBytes);
          await uploadTask.whenComplete(() async {
            // Get the download URL
            String downloadURL = await ref.getDownloadURL();

            // Save the download URL and file name to Firestore
            await FirebaseFirestore.instance
                .collection('user_prescriptions')
                .add({
              'uid': uid,
              'filename': file.name,
              'url': downloadURL,
            });

            // Show success message
            Fluttertoast.showToast(
              msg: 'PDF uploaded successfully.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14,
            );
          }).catchError((e) {
            print('UploadTask error: $e');
            Fluttertoast.showToast(
              msg: 'An error occurred while uploading the PDF.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14,
            );
          });
        } else {
          // Handle the case where the user is not authenticated
          Fluttertoast.showToast(
            msg: 'User not authenticated.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14,
          );
        }
      } else {
        // User canceled the picker
        Fluttertoast.showToast(
          msg: 'No file selected.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14,
        );
      }
    } catch (e) {
      // Handle errors
      print('An error occurred while uploading the PDF: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred while uploading the PDF.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPDFs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('user_prescriptions')
            .where('uid', isEqualTo: user.uid)
            .get();

        return snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      print('Failed to fetch PDFs: $e');
      Fluttertoast.showToast(
        msg: 'Failed to fetch PDFs.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Prescription History',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA9C7C3),
              Color.fromRGBO(125, 168, 160, 0.7),
              Color(0xFFEDEDED),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.47, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                height: sizeh(context) * 0.01,
              ),
              Image.asset(
                'assets/prescription.png',
                height: sizew(context) * 1,
              ),
              SizedBox(
                height: sizeh(context) * 0.08,
              ),
              GestureDetector(
                onTap: _uploadPDF,
                child: Container(
                  width: double.infinity,
                  height: sizeh(context) * 0.06,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0438, 1.1228],
                      colors: [
                        Color(0xFF67BFAE),
                        Color(0xFF265850),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Upload PDF',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: sizeh(context) * 0.01,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImageListPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: sizeh(context) * 0.06,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0438, 1.1228],
                      colors: [
                        Color(0xFF67BFAE),
                        Color(0xFF265850),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageListPage extends StatelessWidget {
  const ImageListPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchPDFs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('user_prescriptions')
            .where('uid', isEqualTo: user.uid)
            .get();

        return snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      // Handle errors
      print('Failed to fetch PDFs: $e');
    }
    return []; // Ensure a non-null value is always returned
  }

  void _openURL(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'All Prescriptions',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA9C7C3),
              Color.fromRGBO(125, 168, 160, 0.7),
              Color(0xFFEDEDED),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.47, 1.0],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchPDFs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No PDFs found.'));
            } else {
              List<Map<String, dynamic>> pdfs = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: pdfs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> pdf = pdfs[index];
                  return GestureDetector(
                    onTap: () {
                      String url = pdf['url'];
                      _openURL(context, url); // Pass context here
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          pdf['filename'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
