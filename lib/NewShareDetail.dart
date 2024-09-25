import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:gsheets/gsheets.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:stock_market/test.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
class NewShareDetail extends StatefulWidget {
  @override
  _NewShareDetailState createState() => _NewShareDetailState();
  final List<String> sList;


  NewShareDetail({Key? key, required this.sList}) : super(key: key);

}

class _NewShareDetailState extends State<NewShareDetail> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _marketCapData;
  late Map<String, dynamic> _data;

  final _snoController = TextEditingController();
  final _detailsController = TextEditingController();
  final _capController = TextEditingController();
  final _typeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _rankController = TextEditingController();
  final _profit2021Controller = TextEditingController();
  final _profit2022Controller = TextEditingController();
  final _profit2023Controller = TextEditingController();

  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "market-402714",
  "private_key_id": "0336aa44822227801f2552cb556bf6e7dc7d1cc7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCkK6e/ZeapLj31\nLTyMISmjq5vwRGP7FT4Mlrg/dfflZ3ZmqwW24L1NDyZD/JsBZ7u54HnSvWElkxaX\n+VbFWxrJeS3U2mOWUGmLL0ssauMBxeEeqKOUw0rorZ5MzohyvEyNnnXyyAIIrEbK\nlHYlq8yH6t++4psqSVMvuspKw8tXrcGc3z/a/GTvNoxbGO7DzL9SusYUNmHZfn4v\nV5BiD9nFNu269panSquGto+61RKg8UM5VaW39YZl03dmCyN4RGTck1sQ0lRxs0bq\nZ4OgNvu9I/hUF+Q9GSUHDYaOAvEwO1fZ6vofI0t/gNEz8bpeznKu5vTNvedRNhvA\ntGSFx13RAgMBAAECggEABaTA4ECY8JLCoKmfWyODtS4/ztS8Xs6w4p68HZBeXHrq\nntESbKI8Al4QNHDxWi0Y+WTpAzCCmlenWe5BcvOKD51/EMIOKjDATr9/inrFLCku\nLzngX7Y5SReOKXlFxwidQBa6WsV7ORWaXGSZ+CW4WFQfwMXfoXvs+bx72kdHTPpX\nIzbrHLxuTT8wnCpDO7W1L9IXbbcZQdpcegoMoYXglY83lPbBI7Y1AvpRCrEn/Tzn\nLYLitw/007E8MNojwKaxTg+XlvOJIUEFC/CWlD8YNxq9ZTom6H1YAx3fOvUlas80\nRARp+5MvEV/TTrCQoLBfa4KDMMv1Ti2G9Z8OoYzYnQKBgQDT19JBJDJAJ8P1J/Em\nB4HZ90CrJaR3e+73hjFRImA4QwuZezFbi87QbzdDwBjiLOSq9OEG13ofYEYj+8tB\njDRop3OwEIaI53/7IPMtR3xrKafgC8DjohisrJd3Zlp77YawtOli2vBVJSbmfHKZ\nOwyzZczVV4qUVlErf3THmYL7NQKBgQDGY/m+rNeRE8BeNjDILhJgYzNcYGpH0Ccq\nkxVL+gUp3N5zlMGXqckZYzuIbgwsi4uKAc3XmAhYX/dpxXnoSk5kam2XhwwuYmc6\nmG+cKbQyQla4TAcHbRhLYQ4wnpiJHPKXiHgiyXWP3HEdXahl55R41qo2RC07uidG\nDEaes02PrQKBgG+yPPcB2cj/7o+Ftt2hWbMObjePSm+BlhdG1xv7bxZbK3OKhBTL\n24kFCvObBsPCffMx2LBdztNaVMFGUv5FqaCAojv0CquGvHEyB2YZah2qwgwcxmB/\nqFjrS5W2DwGG1Ny5FtF7tPp/80nV1iq6+tBgXacjWDssY/H2ayGO7IP9AoGARXeU\nZ7PV97LW1SZchnu7a4zQ2zPXgzXbwQinmGb/j90K96XK8/Q7umwI2IjQMnjab4Sa\nMzfFFEzmMV84hKIgOQEbRse++C70vovJ6QChXEfmXboha/RDYYGmmleuSbSdLXpX\ntracN7eU1BeLc8NXNcjU6ROOUy+nuNtrjv5x1jECgYAgnimbR+Qml2JY9s8DHFmd\nAc+eqPN5os4RYofd1kQaamu+irw3di7hnFF/s9ek7onHP6/djIPuTLnv2alFniez\nJpFqWfRusKsYvMFgrpIGmt6FLTinvY0voQkr00tsgmbKF/jKQ9c9owc/MyZPc79N\n6PE8g0CzQ3NFku4QaN0wHg==\n-----END PRIVATE KEY-----\n",
  "client_email": "market@market-402714.iam.gserviceaccount.com",
  "client_id": "109937386293673290483",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": ""
}
''';
  static const _spreadsheetId = '1nNF82yIrisGX_UExSQs5IjiuSa9q1_5Xrm5iCn-CTj8';
  static const _spreadsheetName = 'Top 109 Stocks';

  late GSheets _gsheets;
  late Spreadsheet _spreadsheet;
  late Worksheet _worksheet;
  late Worksheet _worksheetdatabase;
  List<String> documentNames = [];
  List<String> documentType = [];


  String? selectedDocument;
  String data = 'Initial Data';
  @override
  void initState() {
    super.initState();
    _loadExistingDocuments();
    _loadExistingType();
    _marketCapData = _fetchMarketCapData();
    _initializeGSheets();
    _detailsController.addListener(_fetchAndSetCap);

  }
  Future<void> _loadExistingDocuments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('shareCategory').get();
      // setState(() {
      //
      // });
      documentNames =  querySnapshot.docs.map((doc) => doc.id).toList();

      // Set the initial value for selectedDocument
      if (documentNames.length > 1) {
        selectedDocument = documentNames[1]; // Skip the placeholder
        _categoryController.text = selectedDocument!;
      } else {
        selectedDocument = documentNames[0]; // Placeholder option
        _categoryController.text = selectedDocument!;
      }
    } catch (e) {
      print('Error loading documents: $e');
      // Handle error loading documents
    }
  }

  Future<void> _loadExistingType() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('shareType').get();
      // setState(() {
      //
      // });
      documentType =  querySnapshot.docs.map((doc) => doc.id).toList();

      // Set the initial value for selectedDocument
      if (documentType.length > 1) {
        selectedDocument = documentType[1]; // Skip the placeholder
        _typeController.text = selectedDocument!;
      } else {
        selectedDocument = documentType[0]; // Placeholder option
        _typeController.text = selectedDocument!;
      }
    } catch (e) {
      print('Error loading documents: $e');
      // Handle error loading documents
    }
  }

  Future<void> _initializeGSheets() async {
    _gsheets = GSheets(_credentials);
    _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = _spreadsheet.worksheetByTitle(_spreadsheetName)!;
    _worksheetdatabase = _spreadsheet.worksheetByTitle('Spreadsheet Database')!;
  }


  Future<String> _fetchCapFromSheet(String stockCode) async {
    try {
      final symbol = stockCode.split(':').last;

      //  host URL pointing to your local server scraping endpoint
      final response = await http.get(Uri.parse('http://localhost:3000/$symbol'));


      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final price = jsonResponse['price'] ?? 'Price not found';
        if (price != null) {
          return price;
        } else {
          return 'Please wait or try again';
        }
      } else {
        return 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }


  Future<void> _addDataToSpreadsheet() async {
    // Collect data from text fields
    final data = [
      _detailsController.text,
      _typeController.text,
      _categoryController.text,
      _rankController.text,
      _profit2021Controller.text,
      _profit2022Controller.text,
      _profit2023Controller.text,
    ];

    // Add the data to the sheet

    final headers = await _worksheetdatabase.values.row(1);
    final numColumns = headers.length;

    while (data.length < numColumns - 1) {
      data.add(''); // Add empty strings if there are not enough data elements
    }
    data.add(_capController.text); // Add 0 to the last column

    await _worksheetdatabase.values.appendRow(data);

    
  }

  Future<List<List<dynamic>>> _fetchWorksheetData() async {
    final data = await _worksheetdatabase.values.allRows();

    // Determine the maximum number of columns
    int maxColumns = data.fold<int>(0, (prev, row) => row.length > prev ? row.length : prev);

    // Ensure all rows have the same number of columns
    final updatedData = data.map((row) {
      while (row.length < maxColumns) {
        row.add('N/D');
      }
      return row;
    }).toList();

    return updatedData;
  }

  Future<void> _fetchAndSetCap() async {
    String detail = _detailsController.text;
    String cap = await _fetchCapFromSheet(detail);
    if (cap.isNotEmpty) {
      // setState(() {
      // });
      _capController.text = cap;

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No matching detail found in Google Sheets'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateSpreadsheetRow() async {
    String detail = _detailsController.text;
    String cap = _capController.text;
    String type = _typeController.text;
    String category = _categoryController.text;
    String rank = _rankController.text;
    String profit2021 = _profit2021Controller.text;
    String profit2022 = _profit2022Controller.text;
    String profit2023 = _profit2023Controller.text;

    // Fetch all rows from the worksheet
    final data = await _worksheetdatabase.values.allRows();

    // Find the row index with matching detail
    int rowIndex = -1;
    for (int i = 0; i < data.length; i++) {
      if (data[i][0] == detail) {
        rowIndex = i + 1; // Google Sheets rows are 1-indexed
        break;
      }
    }

    if (rowIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No matching detail found in Spreadsheet Database'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Update the row with new values
    final updateData = [
      detail,
      type,
      category,
      rank,
      profit2021,
      profit2022,
      profit2023,
    ];

    try {
      await _worksheetdatabase.values.insertRow(rowIndex, updateData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update data: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteSpreadsheetRow() async {
    String detail = _detailsController.text;

    // Fetch all rows from the worksheet
    final data = await _worksheetdatabase.values.allRows();

    // Find the row index with matching detail
    int rowIndex = -1;
    for (int i = 0; i < data.length; i++) {
      if (data[i][0] == detail) {
        rowIndex = i + 1; // Google Sheets rows are 1-indexed
        break;
      }
    }

    if (rowIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No matching detail found in Spreadsheet Database'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await _worksheetdatabase.deleteRow(rowIndex);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete data: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _updateTextFields(Map<String, dynamic> data) {
    _detailsController.text = data['detail'];
    _capController.text = data['cap'];
    _typeController.text = data['type'];
    _categoryController.text = data['category'];
    _rankController.text = data['rank'];
    _profit2021Controller.text = data['2021'];
    _profit2022Controller.text = data['2022'];
    _profit2023Controller.text = data['2023'];
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchMarketCapData() async {
    return FirebaseFirestore.instance
        .collection('marketcap')
        .doc('O3hYVuRbYpe8VaWPiQ7s')
        .get();
  }
  Future<void> _fetchStockCodesAndPrices() async {
    String _stockCode = 'DABUR'; // Default stock code
    String _price = 'Fetching...';
    int newColumnIndex = 0;
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      final sheet = spreadsheet.worksheetByTitle('Spreadsheet Database'); // Fetch sheet by name

      if (sheet != null) {
        final stockCodes = await sheet.values.column(1); // Fetching the first column

        if (stockCodes.isNotEmpty) {
          // Get current date and time
          final currentDateTime = DateTime.now().toLocal();
          final formattedCurrentDate = currentDateTime.toString().substring(0, 10); // Date part only
          final formattedCurrentDateTime = currentDateTime.toString().substring(0, 19).replaceAll(':', '-'); // Date and Time part

          // Get the last column index
          final lastRow = await sheet.values.row(1);
          final lastColumnIndex = lastRow.length;

          String latestColumnDate = '';
          if (lastColumnIndex > 1) {
            // Check the latest column date
            latestColumnDate = lastRow[lastColumnIndex - 1];
          }

          if (latestColumnDate.startsWith(formattedCurrentDate)) {
            // Remove the last column if the date matches
            await sheet.deleteColumn(lastColumnIndex);
            newColumnIndex = lastColumnIndex-1;
          }
          else
          {
            newColumnIndex = lastColumnIndex;
          }

          // Add new column header
          // Index of the new column
          await sheet.values.insertValue(formattedCurrentDateTime, row: 1, column: newColumnIndex + 1);

          for (var i = 1; i < stockCodes.length; i++) { // Start from 1 to skip the header
            final code = stockCodes[i];
            final extractedCode = code.split(':').last.trim();

            final response = await http.get(Uri.parse('http://localhost:3000/$extractedCode'));

            if (response.statusCode == 200) {
              final jsonResponse = jsonDecode(response.body);
              final price = jsonResponse['price'] ?? 'Price not found';

              // Append stock price data to the corresponding row
              await sheet.values.insertValue(price, row: i + 1, column: newColumnIndex + 1);
            } else {
              // Insert placeholder in sheet for failed fetch
              await sheet.values.insertValue('Failed to fetch', row: i + 1, column: newColumnIndex + 1);
            }
          }
        } else {
          setState(() {
            _price = 'No stock codes found';
          });
        }
      } else {
        setState(() {
          _price = 'Failed to load sheet';
        });
      }
    } catch (e) {
      setState(() {
        _price = 'Error: $e';
      });
    }
  }
  Future<void> _refreshData() async {
    await _initializeGSheets();
    setState(() {
      _marketCapData = _fetchMarketCapData();
    });
  }
  Future<void> _refreshDataCMP() async {
    await _initializeGSheets();
    await _fetchStockCodesAndPrices();
    setState(() {
      _marketCapData = _fetchMarketCapData();
    });
  }
  bool _isFullScreen = false;
  @override
  Widget build(BuildContext context) {
    double _columnWidth = 150.0;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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

        _data = snapshot.data!.data()!;

        return SizedBox(
          height: 730, // Set the height or width as needed
          child: Row(
            children: [

              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 15.0, bottom: 15.0),
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.54,
                        height: 700,
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
                          child: SingleChildScrollView(


                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                                  onPressed: () {
                                    setState(() {
                                      _isFullScreen = !_isFullScreen;
                                    });
                                  },
                                ),
                                DataTableWidget(onRowSelected: _updateTextFields)

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        Visibility (
                  visible: !_isFullScreen,
                child: Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 15.0, bottom: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 700,
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
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // _buildTextFieldRow("SNo.", _snoController),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 260,
                                          child: Text(
                                            "Share Details",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: FlutterDropdownSearch(
                                            textController: _detailsController,
                                            items: widget.sList,
                                            dropdownHeight: 300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // _buildTextFieldRow("Share Details", _detailsController),
                                _buildTextFieldRow("CMP", _capController),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 260,
                                      child: Text(
                                        "Share Type",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    Expanded(
                                      child: FlutterDropdownSearch(
                                        textController: _typeController,
                                        items: documentType,
                                        dropdownHeight: 300,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 260,
                                      child: Text(
                                        "Share Category",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    Expanded(
                                      child: FlutterDropdownSearch(
                                        textController: _categoryController,
                                        items: documentNames,
                                        dropdownHeight: 300,
                                      ),
                                    ),
                                  ],
                                ),


                                // _buildTextFieldRow("Share Category", _categoryController),
                                _buildTextFieldRow("Company Rank", _rankController),
                                _buildTextFieldRow("Profit 2021", _profit2021Controller),
                                _buildTextFieldRow("Profit 2022", _profit2022Controller),
                                _buildTextFieldRow("Profit 2023", _profit2023Controller),
                                SizedBox(height: 35),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _addDataToSpreadsheet().then((_) {
                                          _refreshData();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Data added to Spreadsheet Database'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Failed to add data: $error'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        });

                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Color(0xFFa46e2d), // Text color
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)), // Background color
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xFFa46e2d), // Text color
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)), // Background color
                                      ),  onPressed: () {
                                      _updateSpreadsheetRow().then((_) {
                                        _refreshData();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Data updated to Spreadsheet Database'),
                                            duration: Duration(seconds: 2),
                                          ),

                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to add data: $error'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      });

                                    },
                                    ),

                                    ElevatedButton(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Color(0xFFa46e2d), // Text color
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)), // Background color
                                      ),  onPressed: () {
                                      _deleteSpreadsheetRow().then((_) {
                                        _refreshData();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Data updated to Spreadsheet Database'),
                                            duration: Duration(seconds: 2),
                                          ),

                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to add data: $error'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      });

                                    },
                                    ),

                                    ElevatedButton(
                                      onPressed: (){
                                        _refreshDataCMP();
                                      },
                                      child: Text('Refresh'),
                                    ),



                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),),
              )
            ],
          )
        );
      },
    );
  }

  Widget _buildTextFieldRow(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 260,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _printResizeInfo(List<WidgetSizeInfo> widgetInfo) {
    // for (WidgetSizeInfo info in widgetInfo) {
    //   print("Widget ${info.widgetID} resized to ${info.size}");
    // }
  }
}