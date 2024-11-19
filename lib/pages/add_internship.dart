import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class InternshipForm extends StatefulWidget {
  @override
  _InternshipFormState createState() => _InternshipFormState();
}

class _InternshipFormState extends State<InternshipForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _mentorNameController = TextEditingController();
  final _mentorContactController = TextEditingController();
  final _mentorEmailController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stipendController = TextEditingController();

  File? _offerLetterFile;
  String? _offerLetterFileName;

  Future<void> _pickOfferLetter() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _offerLetterFile = File(result.files.single.path!);
        _offerLetterFileName = result.files.single.name;
      });
    }
  }

  Future<String?> _uploadOfferLetter() async {
    if (_offerLetterFile != null) {
      final storageRef = FirebaseStorage.instance.ref().child('offer_letters/$_offerLetterFileName');
      await storageRef.putFile(_offerLetterFile!);
      final fileUrl = await storageRef.getDownloadURL();
      return fileUrl;
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final offerLetterUrl = await _uploadOfferLetter();
      FirebaseFirestore.instance.collection('internships').add({
        'companyName': _companyNameController.text,
        'companyAddress': _companyAddressController.text,
        'mentorName': _mentorNameController.text,
        'mentorContact': _mentorContactController.text,
        'mentorEmail': _mentorEmailController.text,
        'registrationNumber': _registrationNumberController.text,
        'city': _cityController.text,
        'stipend': _stipendController.text,
        'offerLetterUrl': offerLetterUrl,
        'startDate': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Internship details submitted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Internship Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _companyAddressController,
                decoration: InputDecoration(labelText: 'Company Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _mentorNameController,
                decoration: InputDecoration(labelText: 'External Mentor Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _mentorContactController,
                decoration: InputDecoration(labelText: 'External Mentor Contact'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _mentorEmailController,
                decoration: InputDecoration(labelText: 'External Mentor Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _registrationNumberController,
                decoration: InputDecoration(labelText: 'Company Registration Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _stipendController,
                decoration: InputDecoration(labelText: 'Stipend Amount'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              ElevatedButton(
                onPressed: _pickOfferLetter,
                child: Text('Pick Offer Letter (PDF)'),
              ),
              if (_offerLetterFileName != null) Text('Selected File: $_offerLetterFileName'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
