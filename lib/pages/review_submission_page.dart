import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewReports extends StatefulWidget {
  @override
  _ReviewReportsState createState() => _ReviewReportsState();
}

class _ReviewReportsState extends State<ReviewReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Reports'),
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
                subtitle: Text(doc['submittedAt'].toDate().toString()),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // Approve the report
                    FirebaseFirestore.instance
                        .collection('reports')
                        .doc(doc.id)
                        .update({
                      'status': 'approved',
                    }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report approved')),
                      );
                    });
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
