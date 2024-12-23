

import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:gsheets/gsheets.dart';

import 'LineChartScreen.dart';


class shareList extends StatefulWidget {
  @override
  _shareListState createState() => _shareListState();
}

class _shareListState extends State<shareList> {
  List<String> documentNames = [];
  List<Map<String, String>> _rows = [];
  List<Map<String, String>> _top109Stocks = []; // To hold data from 'Top 109 Stocks' sheet
  String _selectedFilter = '';

  // Google Sheets credentials
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
  static const _spreadsheetNameDatabase = 'Spreadsheet Database';
  static const _spreadsheetNameTop109Stocks = 'Top 109 Stocks';

  final GSheets _gsheets = GSheets(_credentials);

  @override
  void initState() {
    super.initState();
    _loadExistingDocuments();
    _loadTableDataFromSpreadsheet();
  }

  // Load filter button names
  void _loadExistingDocuments() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('watchList').get();
      setState(() {
        documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error loading documents: $e');
    }
  }

  // Load table data from Google Sheets
  Future<void> _loadTableDataFromSpreadsheet() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);

      // Load data from 'Spreadsheet Database'
      final sheetDatabase = spreadsheet.worksheetByTitle(_spreadsheetNameDatabase);
      if (sheetDatabase != null) {
        final data = await sheetDatabase.values.map.allRows();
        if (data != null) {
          setState(() {
            _rows = data;
          });
        }
      }

      // Load data from 'Top 109 Stocks'
      final sheetTop109Stocks = spreadsheet.worksheetByTitle(_spreadsheetNameTop109Stocks);
      if (sheetTop109Stocks != null) {
        final dataTop109Stocks = await sheetTop109Stocks.values.map.allRows();
        if (dataTop109Stocks != null) {
          setState(() {
            _top109Stocks = dataTop109Stocks;
          });
        }
      }
    } catch (e) {
      print('Error loading spreadsheet data: $e');
    }
  }

  List<Map<String, String>> _getFilteredRows() {
    if (_selectedFilter.isEmpty) {
      return _rows;
    }
    return _rows.where((row) => row['List'] == _selectedFilter).toList();
  }

  // Function to find corresponding row from 'Top 109 Stocks' by NSECode
  Map<String, String>? _findStockData(String nseCode) {
    return _top109Stocks.firstWhere(
          (row) => row['NSECode'] == nseCode,
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRows = _getFilteredRows();

    return Scaffold(
      appBar: AppBar(
        title: Text('Filterable DataTable'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: Row(
              children: documentNames.map((docName) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = _selectedFilter == docName ? '' : docName;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: _selectedFilter == docName
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      foregroundColor: _selectedFilter == docName
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Text(docName),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: CrossScroll(
              child: Column(
                children: [
                  _rows.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : DataTable(
                    columnSpacing: 7.0,
                    columns: _rows.isNotEmpty
                        ? _rows.first.keys
                        .map((key) => DataColumn(
                      label: Container(
                        width: 80,
                        child: Text(
                          key,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    rows: filteredRows.map((row) {
                      return DataRow(
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            String nseCode = row['NSECode'] ?? '';
                            Map<String, String>? stockData = _findStockData(nseCode);

                            if (stockData != null && stockData.isNotEmpty) {
                              print('Stock Data: $stockData');

                              // Extract the DMA values and parse them to double
                              double dma5 = double.tryParse(stockData['5 DMA'] ?? '') ?? 0.0;
                              double dma20 = double.tryParse(stockData['20 DMA'] ?? '') ?? 0.0;
                              double dma50 = double.tryParse(stockData['50 DMA'] ?? '') ?? 0.0;
                              double dma100 = double.tryParse(stockData['100 DMA'] ?? '') ?? 0.0;
                              double dma200 = double.tryParse(stockData['200 DMA'] ?? '') ?? 0.0;

                              // Navigate to LineChartScreen with the required parameters
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LineChartScreen(
                                    nseCode: nseCode,
                                    dateValues: row.entries
                                        .where((entry) => entry.key.contains('2024'))
                                        .toList(),
                                    dma5: dma5,
                                    dma20: dma20,
                                    dma50: dma50,
                                    dma100: dma100,
                                    dma200: dma200,
                                  ),
                                ),
                              );
                            } else {
                              print('No data found for $nseCode');
                            }
                          }
                        },
                        cells: row.values.map((value) => DataCell(Text(value))).toList(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.0), // Adding some space between sections
        ],
      ),
    );
  }
}

