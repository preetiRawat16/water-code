import 'dart:convert';

import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
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
  final ValueNotifier<String> _buttonTextNotifier = ValueNotifier<String>("Save");
  final _snoController = TextEditingController();
  final _detailsController = TextEditingController();
  final _capController = TextEditingController();
  final _typeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _listController = TextEditingController();

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
  String _filterQuery = '';
  late GSheets _gsheets;
  late Spreadsheet _spreadsheet;
  late Worksheet _worksheet;
  late Worksheet _worksheetdatabase;
  List<String> documentNames = [];
  List<String> documentList = [];

  List<String> documentType = [];
  bool _isLoading = false;
  String? selectedDocument;
  String data = 'Initial Data';
  @override
  void initState() {
    super.initState();
    _loadExistingDocuments();
    _loadExistingType();
    _loadExistingList();
    _marketCapData = _fetchMarketCapData();
    _initializeGSheets();
    _detailsController.addListener(_fetchAndSetCap);
    _listController.addListener(_fetchAndSetCap);

    _profit2021Controller.addListener(_calculateProfit2023);
    _profit2022Controller.addListener(_calculateProfit2023);
    _determineButtonText();
  }
  @override
  void dispose() {
    // Dispose controllers to free resources
    _profit2021Controller.dispose();
    _profit2022Controller.dispose();
    _profit2023Controller.dispose();
    super.dispose();
  }


  void _calculateProfit2023() {
    final profit2021 = double.tryParse(_profit2021Controller.text);
    final profit2022 = double.tryParse(_profit2022Controller.text);

    if (profit2021 != null && profit2022 != null) {
      // Set the value of _profit2023Controller as the product of the other two
      final product = profit2021 * profit2022;
      _profit2023Controller.text = product.toStringAsFixed(2); // Format to 2 decimal places
    } else {
      // Clear _profit2023Controller if inputs are invalid
      _profit2023Controller.clear();
    }
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
  Future<void> _loadExistingList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('watchList').get();
      // setState(() {
      //
      // });
      documentList =  querySnapshot.docs.map((doc) => doc.id).toList();

      // Set the initial value for selectedDocument
      if (documentList.length > 1) {
        selectedDocument = documentList[1]; // Skip the placeholder
        _listController.text = selectedDocument!;
      } else {
        selectedDocument = documentList[0]; // Placeholder option
        _listController.text = selectedDocument!;
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
      final response = await http.get(Uri.parse('https://node-server-hj3k.onrender.com/$symbol'));


      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final price = jsonResponse['price'] ?? 'Price not found';
        if (price != null) {
          return price.toString();
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
      _detailsController.text,  // Column 1
      _typeController.text,     // Column 2
      _categoryController.text, // Column 3
      '',                       // Placeholder for columns 4-7
      '',
      '',
      '',
      _rankController.text,     // Column 8
      _profit2021Controller.text, // Column 9
      _profit2022Controller.text, // Column 10
      _profit2023Controller.text, // Column 11
      _listController.text,     // Column 12
    ];

    // Fetch headers to determine the number of columns
    final headers = await _worksheetdatabase.values.row(1);
    final numColumns = headers.length;

    while (data.length < numColumns -2) {
      data.add(''); // Add empty strings if there are not enough data elements
    }

    data.add(_capController.text); // Add the value for the last column

    // Fetch all rows to find the last serial number in column 13
    final allRows = await _worksheetdatabase.values.allRows();

    // Find the last serial number in column 13 (index 12, 0-indexed)
    String lastSerialNumber = '0'; // Default to '0' if no previous rows
    if (allRows.isNotEmpty) {
      // Ensure the row has enough columns and find the last serial number in column 13
      for (var row in allRows) {
        if (row.length >= 13 && row[12] is String) {
          lastSerialNumber = row[12]; // Get the last serial number as a string
        }
      }
    }

    // Increment the serial number for the new row
    int newSerialNumber = int.tryParse(lastSerialNumber) ?? 0;
    String newSerialNumberString = (newSerialNumber + 1).toString(); // Convert to string

    // Add the serial number to column 13 (index 12)
    data.insert(12, newSerialNumberString); // Insert the serial number as a string at column 13

    // Append the new row to the sheet
    await _worksheetdatabase.values.appendRow(data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }



  Future<void> _fetchAndSetCap() async {
    // Set the button text to "Load" while the operation is in progress
    _buttonTextNotifier.value = "Load";

    String detail = _detailsController.text;
    String listValue = _listController.text;

    try {
      // Fetch the cap based on detail
      String cap = await _fetchCapFromSheet(detail);

      if (cap.isNotEmpty) {
        _capController.text = cap;

        // Fetch all rows from the worksheet
        final allRows = await _worksheetdatabase!.values.allRows();

        // Check if both `detail` and `listValue` exist in the sheet
        bool isEdit = allRows.any((row) =>
        row.length >= 12 && // Ensure the row has enough columns
            row[0] == detail && // Match detail in the first column
            row[11] == listValue); // Match list in the 12th column

        // Set the button text based on the condition
        _buttonTextNotifier.value = isEdit ? "Edit" : "Save";
      } else {
        // Handle case where cap is not found
        _buttonTextNotifier.value = "Save"; // Default to Save if no match is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No matching detail found in Google Sheets'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      _buttonTextNotifier.value = "Save"; // Fallback to Save on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $e'),
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
    String list = _listController.text;
    String rank = _rankController.text;
    String profit2021 = _profit2021Controller.text;
    String profit2022 = _profit2022Controller.text;
    String profit2023 = _profit2023Controller.text;

    // Fetch all rows from the worksheet
    final data = await _worksheetdatabase.values.allRows();

    // Find the row index with matching detail
    int rowIndex = -1;
    List<String> currentRowData = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i][0] == detail) {
        rowIndex = i + 1; // Google Sheets rows are 1-indexed
        currentRowData = data[i]; // Store the current row's data
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

    // Update the row with new values, keeping columns 4-7 unchanged
    final updateData = [
      detail,
      type,
      category,
      currentRowData.length > 3 ? currentRowData[3] : '', // Column 4
      currentRowData.length > 4 ? currentRowData[4] : '', // Column 5
      currentRowData.length > 5 ? currentRowData[5] : '', // Column 6
      currentRowData.length > 6 ? currentRowData[6] : '', // Column 7
      rank,
      profit2021,
      profit2022,
      profit2023,
      list
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
    String sno = _snoController.text; // This will be the value to match against Column M

    // Fetch all rows from the worksheet
    final data = await _worksheetdatabase.values.allRows();

    // Find the row index with matching value in column M (which is index 12, 0-indexed)
    int rowIndex = -1;
    for (int i = 0; i < data.length; i++) {
      // Ensure the row has enough columns and that the value in column M (index 12) matches `detail`
      if (data[i].length >= 13 && data[i][12] == sno) {
        rowIndex = i + 1; // Google Sheets rows are 1-indexed
        break;
      }
    }

    if (rowIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No matching detail found in Spreadsheet Database based on Column M'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Delete the row at the found index
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
    _snoController.text = data['sno'];
    _detailsController.text = data['detail'];
    _capController.text = data['cap'];
    _typeController.text = data['type'];
    _categoryController.text = data['category'];
    _listController.text = data['list'];
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


  Future<void> _determineButtonText() async {
    String nseCode = _detailsController.text; // Input from NSECode field
    String listValue = _listController.text;  // Input from List field

    // Fetch all rows from the worksheet
    final data = await _worksheetdatabase.values.allRows();

    // Check if any row has both matching NSECode (column 0) and List (column 10)
    bool isEdit = data.any((row) =>
    row.length >= 11 && // Ensure the row has enough columns
        row[0] == nseCode &&
        row[10] == listValue);

    // Update button text in the notifier
    _buttonTextNotifier.value = isEdit ? "Edit" : "Add";
  }
  Future<void> _fetchStockCodesAndPrices() async {
    String _price = 'Fetching...';
    int newColumnIndex = 0;
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      final sheet = spreadsheet.worksheetByTitle('Spreadsheet Database');

      if (sheet != null) {
        final stockCodes = await sheet.values.column(1); // Fetch first column

        if (stockCodes.isNotEmpty) {
          // Get current date and time
          final currentDateTime = DateTime.now().toLocal();
          final formattedCurrentDate = currentDateTime.toString().substring(0, 10);
          final formattedCurrentDateTime =
          currentDateTime.toString().substring(0, 19).replaceAll(':', '-');

          // Get the last column index
          final lastRow = await sheet.values.row(1);
          final lastColumnIndex = lastRow.length;

          String latestColumnDate = '';
          if (lastColumnIndex > 1) {
            latestColumnDate = lastRow[lastColumnIndex - 1];
          }

          if (latestColumnDate.startsWith(formattedCurrentDate)) {
            // Remove the last column if date matches
            await sheet.deleteColumn(lastColumnIndex);
            newColumnIndex = lastColumnIndex - 1;
          } else {
            newColumnIndex = lastColumnIndex ;
          }

          // Add new column header
          await sheet.values.insertValue(
            formattedCurrentDateTime,
            row: 1,
            column: newColumnIndex + 1,
          );

          for (var i = 1; i < stockCodes.length; i++) {
            final code = stockCodes[i];
            if (code == null || code.isEmpty) continue; // Skip empty codes

            final extractedCode = code.split(':').last.trim();

            int retries = 3; // Retry up to 3 times
            while (retries > 0) {
              try {
                final response = await http.get(
                  Uri.parse('https://node-server-hj3k.onrender.com/$extractedCode'),
                );

                if (response.statusCode == 200) {
                  final jsonResponse = jsonDecode(response.body);
                  final price = jsonResponse['price'] ?? 'Price not found';

                  // Append stock price data to the corresponding row
                  await sheet.values.insertValue(
                    price,
                    row: i + 1,
                    column: newColumnIndex + 1,
                  );


                } else {
                  throw Exception('Failed to fetch data for $extractedCode');
                }

                break; // Exit retry loop on success
              } catch (e) {
                retries--;
                if (retries == 0) {
                  // Insert placeholder after all retries fail
                  await sheet.values.insertValue(
                    'Failed to fetch',
                    row: i + 1,
                    column: newColumnIndex + 1,
                  );
                }
              }
            }

            // Add a small delay to avoid overwhelming the server
            await Future.delayed(Duration(milliseconds: 500));
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

  double? calculateDifference(String columnIValueStr, String lastColumnValueStr) {
    // Clean up the strings to remove unwanted characters (e.g., commas or symbols)
    final cleanColumnIValueStr = columnIValueStr.replaceAll(RegExp(r'[^\d.-]'), '');
    final cleanLastColumnValueStr = lastColumnValueStr.replaceAll(RegExp(r'[^\d.-]'), '');

    // Try parsing the cleaned values
    final columnIValue = double.tryParse(cleanColumnIValueStr);
    final lastColumnValue = double.tryParse(cleanLastColumnValueStr);

    if (columnIValue == null || lastColumnValue == null) {
      print("Invalid data: Unable to parse numbers from cleaned values.");
      return null;
    }

    // Calculate the difference
    return lastColumnValue - columnIValue;
  }

  Future<void> calculateAndSavePercentageDifference() async {
    final data = await _worksheetdatabase.values.allRows();
    if (data.isEmpty) {
      print("No data found in the spreadsheet.");
      return;
    }

    const columnJIndex = 9; // Column I is the 9th column (0-based index: 8)
    const columnFIndex = 5; // Column F is the 6th column (0-based index: 5)

    // Iterate over rows starting from the second row (data rows)
    for (var rowIndex = 1; rowIndex < data.length; rowIndex++) {
      final row = data[rowIndex];

      // Ensure there are at least 2 columns: column I and some value in the last column
      if (row.length <= columnJIndex) {
        continue;
      }

      // Identify the last column dynamically
      final lastColumnIndex = row.length - 1;

      // Check if the last column has a value
      if (row[lastColumnIndex] == null || row[lastColumnIndex]!.isEmpty) {
        continue;
      }

      // Parse the values from column I and the last column
      final columnJValueStr = row[columnJIndex]?.toString().trim();
      final lastColumnValueStr = row[lastColumnIndex]?.toString().trim();

      if (columnJValueStr == null || lastColumnValueStr == null || columnJValueStr.isEmpty || lastColumnValueStr.isEmpty) {
        continue;
      }

      // Log the raw data for debugging

      // Clean up the strings to remove unwanted characters (e.g., commas or symbols)
      String cleanColumnIValueStr = columnJValueStr.replaceAll(RegExp(r'[^\d.-]'), ''); // Remove non-numeric characters except '.' and '-'
      String cleanLastColumnValueStr = lastColumnValueStr.replaceAll(RegExp(r'[^\d.-]'), ''); // Remove non-numeric characters except '.' and '-'

      // Log the cleaned values

      // Try parsing the cleaned values
      final columnIValue = double.tryParse(cleanColumnIValueStr);
      final lastColumnValue = double.tryParse(cleanLastColumnValueStr);

      if (columnIValue == null || lastColumnValue == null) {
        continue;
      }

      // Calculate the percentage difference
      final percentageDifference = ((lastColumnValue - columnIValue) / lastColumnValue) * 100;

      // Save the result in column F
      try {
        await _worksheetdatabase.values.insertValue(
          percentageDifference.toStringAsFixed(2), // Format to 2 decimal places
          column: columnFIndex + 1, // Convert 0-based index to 1-based index
          row: rowIndex + 1, // Convert 0-based index to 1-based index
        );

        // Add a 1-second delay after every 60 rows to avoid overloading the server
        if (rowIndex % 5 == 0) {
          print("Taking a 1-second break after processing 60 rows...");
          await Future.delayed(Duration(seconds: 3));
        }

      } catch (e) {
      }
    }
  }
  Future<void> calculateProfitINR() async {
    final data = await _worksheetdatabase.values.allRows();
    if (data.isEmpty) {
      print("No data found in the spreadsheet.");
      return;
    }

    const columnJIndex = 9; // Column J is the 9th column (0-based index: 8)
    const columnIIndex = 8; // Column I is the 8th column (0-based index: 7)
    const columnGIndex = 6; // Column G is the 7th column (0-based index: 6)

    // Iterate over rows starting from the second row (data rows)
    for (var rowIndex = 1; rowIndex < data.length; rowIndex++) {
      final row = data[rowIndex];

      // Ensure there are at least required columns: I, J, and some value in the last column
      if (row.length <= columnJIndex) {
        continue;
      }

      // Identify the last column dynamically
      final lastColumnIndex = row.length - 1;

      // Check if the last column has a value
      if (row[lastColumnIndex] == null || row[lastColumnIndex]!.isEmpty) {
        continue;
      }

      // Parse the values from columns I, J, and the last column
      final columnJValueStr = row[columnJIndex]?.toString().trim();
      final columnIValueStr = row[columnIIndex]?.toString().trim();
      final lastColumnValueStr = row[lastColumnIndex]?.toString().trim();

      if (columnJValueStr == null || columnIValueStr == null || lastColumnValueStr == null ||
          columnJValueStr.isEmpty || columnIValueStr.isEmpty || lastColumnValueStr.isEmpty) {
        continue;
      }

      // Log the raw data for debugging

      // Calculate the difference
      final difference = calculateDifference(columnJValueStr, lastColumnValueStr);

      if (difference == null) {
        continue;
      }

      // Clean and parse the value in column I
      final columnIValue = double.tryParse(columnIValueStr.replaceAll(RegExp(r'[^\d.-]'), ''));
      if (columnIValue == null) {
        continue;
      }

      // Perform the new calculation: difference * value in column I
      final result = difference * columnIValue;

      // Save the result in column G
      try {
        await _worksheetdatabase.values.insertValue(
          result.toStringAsFixed(2), // Format to 2 decimal places
          column: columnGIndex + 1, // Convert 0-based index to 1-based index
          row: rowIndex + 1, // Convert 0-based index to 1-based index
        );

        // Add a 1-second delay after every 60 rows to avoid overloading the server
        if (rowIndex % 5 == 0) {
          print("Taking a 1-second break after processing 60 rows...");
          await Future.delayed(Duration(seconds: 3));
        }

      } catch (e) {
      }
    }
  }
  Future<void> updateMaxMinForDecember() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    final sheet = spreadsheet.worksheetByTitle('Spreadsheet Database');

    if (sheet == null) {
      return;
    }

    // Fetch all rows from the sheet
    final values = await sheet.values.allRows();

    if (values.isEmpty) {
      return;
    }

    // Get headers from the first row
    final headers = values.first;

    // Identify December columns
    final decemberColumns = <int>[];
    final dateFormat = DateFormat("yyyy-MM-dd");

    for (var i = 0; i < headers.length; i++) {
      try {
        // Parse the date in the header
        final headerDate = dateFormat.parse(headers[i].split(' ')[0]); // Extract date portion
        if (headerDate.month == 12) {
          decemberColumns.add(i);
        }
      } catch (e) {
        // Ignore invalid date headers
        continue;
      }
    }

    if (decemberColumns.isEmpty) {
      return;
    }

    // Process each row starting from the second row (skipping the header)
    for (var rowIndex = 1; rowIndex < values.length; rowIndex++) {
      final row = values[rowIndex];
      final decemberValues = <double>[];

      // Collect values from December columns
      for (var columnIndex in decemberColumns) {
        if (columnIndex < row.length) {
          final cellValue = row[columnIndex];
          final numericValue = double.tryParse(cellValue?.toString() ?? '');
          if (numericValue != null) {
            decemberValues.add(numericValue);
          }
        }
      }

      // Calculate max and min values
      if (decemberValues.isNotEmpty) {
        final max = decemberValues.reduce((a, b) => a > b ? a : b);
        final min = decemberValues.reduce((a, b) => a < b ? a : b);

        // Format the result
        final result = '${max.toStringAsFixed(2)} – ${min.toStringAsFixed(2)}';

        // Update column E (5th column)
        try {
          await sheet.values.insertValue(result, column: 5, row: rowIndex + 1); // Column E
        } catch (e) {
          print("Error updating row $rowIndex: $e");
        }
      } else {
        // If no valid December values, insert "No Data"
        await sheet.values.insertValue('No Data', column: 5, row: rowIndex + 1);
      }

      // Add a small delay to prevent overwhelming the server
      await Future.delayed(Duration(milliseconds: 500));
      _refreshData();
    }
  }

  Future<void> updateSharePricePercentageChange() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    final sheet = spreadsheet.worksheetByTitle('Spreadsheet Database');

    if (sheet == null) {
      print("The worksheet 'Spreadsheet Database' doesn't exist.");
      return;
    }

    // Fetch all rows from the sheet
    final values = await sheet.values.allRows();

    if (values.isEmpty)
    {
      print("No data found in the sheet.");
      return;
    }

    // Assuming the first row contains headers
    final headers = values.first;

    // Date format for parsing headers (ignoring the time part)
    final dateFormat = DateFormat("yyyy-MM-dd");

    // Get the date for 1st December 2024 and today's date in the required format
    final dateDec1st = dateFormat.parse("2024-12-01");
    final dateToday = DateTime.now();

    // Find the columns corresponding to "Share Price 1st December" and "Share Price Today"
    int? sharePriceDec1stColumnIndex;
    int? sharePriceTodayColumnIndex;

    // Loop through headers and find the matching columns
    for (var i = 0; i < headers.length; i++) {
      try {
        // Parse the date in the header
        final headerDate = dateFormat.parse(headers[i]);
        if (headerDate.isAtSameMomentAs(dateDec1st)) {
          sharePriceDec1stColumnIndex = i;
        } else if (headerDate.year == dateToday.year &&
            headerDate.month == dateToday.month &&
            headerDate.day == dateToday.day) {
          sharePriceTodayColumnIndex = i;
        }
      } catch (e) {
        // Ignore invalid date headers
        continue;
      }
    }

    // Check if the columns were found
    if (sharePriceDec1stColumnIndex == null) {
      print("Share Price 1st December column not found.");
      return;
    }

    if (sharePriceTodayColumnIndex == null) {
      print("Share Price Today column not found.");
      return;
    }

    // Iterate through each row starting from the second row (skipping the header)
    for (var i = 1; i < values.length; i++) {
      final row = values[i];

      // Get the share price today and the share price on Dec 1st
      final sharePriceToday = double.tryParse(row[sharePriceTodayColumnIndex]?.toString() ?? '');
      final sharePriceDec1st = double.tryParse(row[sharePriceDec1stColumnIndex]?.toString() ?? '');

      // If either share price is null, skip this row
      if (sharePriceToday == null || sharePriceDec1st == null) {
        print("Invalid data in row $i: Skipping.");
        continue;
      }

      // Calculate the percentage change
      final percentageChange = ((sharePriceToday - sharePriceDec1st) / sharePriceToday) * 100;
      final formattedPercentageChange = "${percentageChange.toStringAsFixed(2)}";

      // Update column D with the calculated percentage change
      try {
        await sheet.values.insertValue(formattedPercentageChange, column: 4, row: i + 1); // Column D (4th column)

        // Take a break after processing 5 rows
        if (i % 5 == 0) {
          print("Taking a 1-second break after processing 5 rows...");
          await Future.delayed(Duration(seconds: 1));
        }

      } catch (e) {
        print("Error updating row $i: $e");
      }
    }
  }
  void _validateAndUpdate() {
    // Parse inputs or treat empty fields as valid
    final profit2021 = _profit2021Controller.text.isEmpty
        ? null
        : double.tryParse(_profit2021Controller.text);
    final profit2022 = _profit2022Controller.text.isEmpty
        ? null
        : double.tryParse(_profit2022Controller.text);
    final profit2023 = _profit2023Controller.text.isEmpty
        ? null
        : double.tryParse(_profit2023Controller.text);

    if ((profit2021 != null || _profit2021Controller.text.isEmpty) &&
        (profit2022 != null || _profit2022Controller.text.isEmpty) &&
        (profit2023 != null || _profit2023Controller.text.isEmpty)) {
      // If all fields are either valid numbers or empty, proceed with the update
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
    } else {
      // Show an error message if any non-empty input is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid numbers or leave fields empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  void _validateAndAdd() {
    // Parse inputs or treat empty fields as valid
    final profit2021 = _profit2021Controller.text.isEmpty
        ? null
        : double.tryParse(_profit2021Controller.text);
    final profit2022 = _profit2022Controller.text.isEmpty
        ? null
        : double.tryParse(_profit2022Controller.text);
    final profit2023 = _profit2023Controller.text.isEmpty
        ? null
        : double.tryParse(_profit2023Controller.text);

    if ((profit2021 != null || _profit2021Controller.text.isEmpty) &&
        (profit2022 != null || _profit2022Controller.text.isEmpty) &&
        (profit2023 != null || _profit2023Controller.text.isEmpty)) {
      // If all fields are either valid numbers or empty, proceed with the update
      _addDataToSpreadsheet().then((_) {
        _refreshData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Added to Spreadsheet Database'),
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
    } else {
      // Show an error message if any non-empty input is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid numbers or leave fields empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  Future<void> _refreshData() async {
    await _initializeGSheets();
    setState(() {
      _marketCapData = _fetchMarketCapData();
    });
  }
  Future<void> _refreshDataCMP() async {
    setState(() {
      _isLoading = true; // Disable the button
    });

    try {
      await _initializeGSheets();
      await _fetchStockCodesAndPrices();
      await updateSharePricePercentageChange();
      await calculateAndSavePercentageDifference();
      await updateMaxMinForDecember();
      setState(() {
        _marketCapData = _fetchMarketCapData();
      });
    } catch (e) {
      print("Error refreshing data: $e");
    } finally {
      setState(() {
        _isLoading = false; // Re-enable the button
      });
    }
  }

  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    double _columnWidth = 150.0;
    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                            child: CrossScroll(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isFullScreen = !_isFullScreen;
                                      });
                                    },
                                    child: Text(_isFullScreen ? 'Minimize' : 'Fullscreen'),
                                  ),



                                  DataTableWidget(onRowSelected: _updateTextFields, filterQuery: _filterQuery,)

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
                                  _buildTextFieldRow("SNo.", _snoController),
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
                                  _buildTextFieldRow("total share qty", _profit2021Controller),
                                  _buildTextFieldRow("share purchase value – INR", _profit2022Controller),
                                  _buildTextFieldRow("Total share value -INR", _profit2023Controller),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 260,
                                        child: Text(
                                          "Watchlist",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      Expanded(
                                        child: FlutterDropdownSearch(
                                          textController: _listController,
                                          items: documentList,
                                          dropdownHeight: 300,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 35),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
      
                                      ValueListenableBuilder<String>(
                                        valueListenable: _buttonTextNotifier,
                                        builder: (context, buttonText, _) {
                                          return TextButton(
                                            onPressed: () {
                                              if (buttonText == "Edit") {
                                                _validateAndUpdate();
                                              } else {
                                                _addDataToSpreadsheet().then((_) {
                                                  _refreshData();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Data Added to Spreadsheet Database'),
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
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)),
                                              foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFa46e2d)),
      
                                            ),
                                            child: Text(buttonText),
                                          );
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
                                        child: Text(
                                          'update ProfitINR',
                                          style: TextStyle(
                                            color: Color(0xFFa46e2d), // Text color
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)), // Background color
                                        ),  onPressed: () {
                                          // updateMaxMinForDecember();
                                        calculateProfitINR();
                                      },
                                      ),
                                      // ElevatedButton(
                                      //   child: Text(
                                      //     'update Max-Min',
                                      //     style: TextStyle(
                                      //       color: Color(0xFFa46e2d), // Text color
                                      //     ),
                                      //   ),
                                      //   style: ButtonStyle(
                                      //     backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf6ee9c)), // Background color
                                      //   ),  onPressed: () {
                                      //    updateMaxMinForDecember();
                                      //   //calculateAndSavePercentageDifference();
                                      // },
                                      // ),

                                      ElevatedButton(
                                        child: _isLoading
                                            ? Text('Loading..')
                                            : Text(
                                          'refresh',
                                          style: TextStyle(
                                            color: Color(0xFFa46e2d), // Text color
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              _isLoading ? Color(0xFFddd7a3) : Color(0xFFf6ee9c)), // Lighter shade when loading
                                        ),
                                        onPressed: _isLoading
                                            ? null
                                            : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          try {
                                            await _refreshDataCMP();
                                          } catch (e) {
                                            print("Error: $e");
                                          } finally {
                                            setState(() {
                                              _isLoading = false;
                                              var j= "hello";

                                            });
                                          }
                                        },
                                      )



      
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
      ),
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



}

