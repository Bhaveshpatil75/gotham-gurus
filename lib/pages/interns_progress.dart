import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'intern_crud.dart';

class CoordinatorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordinator Dashboard'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('internships').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['companyName']),
                subtitle: Text('Mentor: ${doc['mentorName']}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the edit intern screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditIntern(internId: doc.id),
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
