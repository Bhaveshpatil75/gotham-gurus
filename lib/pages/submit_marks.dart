import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitMarks extends StatefulWidget {
  final String reportId;
  SubmitMarks({required this.reportId});

  @override
  _SubmitMarksState createState() => _SubmitMarksState();
}

class _SubmitMarksState extends State<SubmitMarks> {
  final _formKey = GlobalKey<FormState>();
  final _marksController = TextEditingController();

  void _submitMarks() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.reportId)
          .update({
        'marks': int.parse(_marksController.text),
        'status': 'graded',
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marks submitted')),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Marks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _marksController,
                decoration: InputDecoration(labelText: 'Enter Marks'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitMarks,
                child: Text('Submit Marks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
