import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'assign_mentor_page.dart';

class InternList extends StatefulWidget {
  @override
  _InternListState createState() => _InternListState();
}

class _InternListState extends State<InternList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interns List'),
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
                subtitle: Text(doc['mentorName']),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the assign mentor screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignMentor(internId: doc.id),
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
