import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class watchList extends StatefulWidget {
  @override
  _watchListState createState() => _watchListState();
}

class _watchListState extends State<watchList> {
  final TextEditingController _documentNameController = TextEditingController();
  List<String> documentNames = [];

  @override
  void initState() {
    super.initState();
    _loadExistingDocuments();
  }

  void _loadExistingDocuments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('watchList').get();
      setState(() {
        documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error loading documents: $e');
      // Handle error loading documents
    }
  }

  void _addDocument() {
    String documentName = _documentNameController.text.trim().toLowerCase(); // Convert to lowercase
    if (documentName.isNotEmpty) {
      if (documentNames.any((name) => name.toLowerCase() == documentName)) {
        // Show popup/snackbar for duplicate document name
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Watch list name "$documentName" already exists.'),
        ));
      } else {
        FirebaseFirestore.instance.collection('watchList').doc(documentName).set({
          'field': 'value', // Example field and value
        }).then((_) {
          // Document successfully added
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document added successfully')));
          setState(() {
            documentNames.add(documentName);
          });
          _documentNameController.clear();
        }).catchError((error) {
          // Error adding document
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add document: $error')));
        });
      }
    }
  }

  void _deleteDocument(String documentName) {
    FirebaseFirestore.instance.collection('watchList').doc(documentName).delete().then((_) {
      // Document successfully deleted
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document "$documentName" deleted successfully')));
      setState(() {
        documentNames.remove(documentName.toLowerCase());
      });
    }).catchError((error) {
      // Error deleting document
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete document: $error')));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Watch List Name',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _documentNameController,
                    decoration: InputDecoration(
                      labelText: 'Watchlist Name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addDocument,
                    child: Text('Add Watchlist'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0), // Adding some space between sections
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: documentNames.length,
                      itemBuilder: (context, index) {
                        String documentName = documentNames[index];
                        return ListTile(
                          title: Text(documentName),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteDocument(documentName),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
