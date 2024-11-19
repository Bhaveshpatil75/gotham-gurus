import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gotham_gurus/pages/submit_marks.dart';

class MentorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Dashboard'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['fileName']),
                subtitle: Text('Submitted at: ${doc['submittedAt'].toDate()}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the marks submission screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitMarks(reportId: doc.id),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
