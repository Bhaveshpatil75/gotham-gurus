import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditIntern extends StatefulWidget {
  final String internId;
  EditIntern({required this.internId});

  @override
  _EditInternState createState() => _EditInternState();
}

class _EditInternState extends State<EditIntern> {
  final _progressController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInternData();
  }

  void _loadInternData() async {
    final doc = await FirebaseFirestore.instance.collection('internships').doc(widget.internId).get();
    setState(() {
      _progressController.text = doc['progress'];
      _statusController.text = doc['status'];
    });
  }

  void _updateIntern() {
    FirebaseFirestore.instance.collection('internships').doc(widget.internId).update({
      'progress': _progressController.text,
      'status': _statusController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intern details updated')),
      );
      Navigator.pop(context);
    });
  }

  void _deleteIntern() {
    FirebaseFirestore.instance.collection('internships').doc(widget.internId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intern deleted')),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Intern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _progressController,
              decoration: InputDecoration(labelText: 'Progress'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateIntern,
              child: Text('Update Intern'),
            ),
            ElevatedButton(
              onPressed: _deleteIntern,
              child: Text('Delete Intern'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
