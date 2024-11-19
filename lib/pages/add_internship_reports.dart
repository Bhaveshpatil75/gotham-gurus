import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  File? _pdfFile;
  String? _fileName;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<String?> _uploadFile() async {
    if (_pdfFile != null) {
      final storageRef = FirebaseStorage.instance.ref().child('reports/$_fileName');
      await storageRef.putFile(_pdfFile!);
      final fileUrl = await storageRef.getDownloadURL();
      return fileUrl;
    }
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate() && _pdfFile != null) {
      final fileUrl = await _uploadFile();
      FirebaseFirestore.instance.collection('reports').add({
        'fileName': _fileName,
        'fileUrl': fileUrl,
        'submittedAt': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report submitted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Pick PDF Report'),
              ),
              if (_fileName != null) Text('Selected File: $_fileName'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
