import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyListView extends StatefulWidget {
  String searchQuery;
  MyListView({required this.searchQuery});
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  late Stream<QuerySnapshot> _stream;
  
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('projects');

  @override
  void initState() {
    super.initState();
    _stream = _products
        .where('name', isEqualTo: widget.searchQuery)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (!streamSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final documents = streamSnapshot.data!.docs;
    
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
              return ListTile(
                title: Text(documentSnapshot['name']),
                subtitle: Text(documentSnapshot['description']),
                trailing: Text(documentSnapshot['price']),
              );
            },
          );
        },
      ),
    );
  }
}
