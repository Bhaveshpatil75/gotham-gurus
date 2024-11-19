import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignMentor extends StatefulWidget {
  final String internId;
  AssignMentor({required this.internId});

  @override
  _AssignMentorState createState() => _AssignMentorState();
}

class _AssignMentorState extends State<AssignMentor> {
  final _mentorNameController = TextEditingController();

  void _assignMentor() {
    FirebaseFirestore.instance
        .collection('internships')
        .doc(widget.internId)
        .update({
      'internalMentor': _mentorNameController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mentor assigned')),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Mentor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mentorNameController,
              decoration: InputDecoration(labelText: 'Enter Mentor Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _assignMentor,
              child: Text('Assign Mentor'),
            ),
          ],
        ),
      ),
    );
  }
}
