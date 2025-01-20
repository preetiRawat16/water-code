import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketCap extends StatefulWidget {
  @override
  _MarketCapState createState() => _MarketCapState();
}

class _MarketCapState extends State<MarketCap> {
  late Future<DocumentSnapshot> _marketCapData;
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _marketCapData = _fetchMarketCapData();
  }

  Future<DocumentSnapshot> _fetchMarketCapData() async {
    return FirebaseFirestore.instance
        .collection('marketcap')
        .doc('O3hYVuRbYpe8VaWPiQ7s')
        .get();
  }

void _saveData(BuildContext context) {
  FirebaseFirestore.instance
      .collection('marketcap')
      .doc('O3hYVuRbYpe8VaWPiQ7s')
      .update(_data)
      .then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to update data: $error'),
        duration: Duration(seconds: 2),
      ),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _marketCapData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('No data found'),
          );
        }

        _data = snapshot.data!.data() as Map<String, dynamic>;

        return Container(
          child: Row(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
                Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children:[
                        Text("IPO"),
                        Container(
                            width:100,
                              child: TextField(
                                decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFa46e2d), // Underline color when focused
      ),),
                                ),
                                textAlign: TextAlign.center, // Center align text
  cursorColor: Color(0xFFa46e2d),
                                controller: TextEditingController(text: _data['IPO'].toString()),
                                onChanged: (value) {
                                  _data['IPO'] = double.parse(value);
                                },
                              ),
                            ),

                    ]
                ),
                        
                        
                        SizedBox(height: 25),
                        Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children:[
                        Text("Mid Cap"),
                        Container(
                            width:100,
                              child: TextField(
                                decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFa46e2d), // Underline color when focused
      ),),
                                ),
                                textAlign: TextAlign.center, // Center align text
  cursorColor: Color(0xFFa46e2d),
                                controller: TextEditingController(text: _data['mid'].toString()),
                                onChanged: (value) {
                                  _data['mid'] = double.parse(value);
                                },
                              ),
                            ),

                    ]
                ),

                SizedBox(height: 25),
                        Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children:[
                        Text("Large Cap"),
                        Container(
                            width:100,
                              child: TextField(
                                decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFa46e2d), // Underline color when focused
      ),),
                                ),
                                textAlign: TextAlign.center, // Center align text
  cursorColor: Color(0xFFa46e2d),
                                controller: TextEditingController(text: _data['large'].toString()),
                                onChanged: (value) {
                                  _data['large'] = double.parse(value);
                                },
                              ),
                            ),

                    ]
                ),

                SizedBox(height: 25),
                        Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children:[
                        Text("Small Cap"),
                        Container(
                            width:100,
                              child: TextField(
                                decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFa46e2d), // Underline color when focused
      ),),
                                ),
                                textAlign: TextAlign.center, // Center align text
  cursorColor: Color(0xFFa46e2d),
                                controller: TextEditingController(text: _data['small'].toString()),
                                onChanged: (value) {
                                  _data['small'] = double.parse(value);
                                },
                              ),
                            ),

                    ]
                ),
                
                        SizedBox(height: 35),
                        ElevatedButton(
                           onPressed: () => _saveData(context),
                          child: Text(
    'Save',
    style: TextStyle(
      color: Color(0xFFa46e2d), // Text color
    ),
  ),
                          style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)), ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
            ],
          ),
          SizedBox(width:MediaQuery.of(context).size.width * 0.04),
          Padding(
            padding: EdgeInsets.only( top: (MediaQuery.of(context).size.height * 0.1)),

            child:Container(
            width:MediaQuery.of(context).size.width * 0.3,
  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        "web/assets/marketcapimg.jpg",
                        fit: BoxFit.cover,
                      ),
                    ), // Your content widget
)
          )
            ]
          )
        );
      },
    );
  }
}
