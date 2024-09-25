import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
class DataTableWidget extends StatefulWidget {

  final Function(Map<String, dynamic>) onRowSelected;

  DataTableWidget({required this.onRowSelected});

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  late GSheets _gsheets;
  late Spreadsheet _spreadsheet;
  late Worksheet _worksheet;

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
  static const _spreadsheetName = 'Spreadsheet Database';

  @override
  void initState() {
    super.initState();
    _initializeGSheets();
  }

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  List<DataRow> _rows = [];
  final Map<String, String> _cachedPrices = {};

  Future<List<DataRow>> _fetchTableRows() async {
    final data = await _worksheet.values.allRows();
    final rows = <DataRow>[];

    if (data.isNotEmpty) {
      // Process the header row
      final headerRow = data[0];
      final updatedHeaderRow = [
        headerRow[0],          // first column (unchanged)
        headerRow.last,        // move last column to second position
        ...headerRow.skip(1).take(headerRow.length - 2), // remaining columns, except last
      ];

      final headerCells = List.generate(
        updatedHeaderRow.length,
            (index) => DataCell(Text(updatedHeaderRow[index] ?? '')),
      );
      rows.add(DataRow(cells: headerCells));

      // Process the remaining rows
      final rowFutures = <Future<DataRow>>[];
      for (var i = 1; i < data.length; i++) {
        final row = data[i];
        rowFutures.add(Future(() async {
          // Move the last column to the second position
          final updatedRow = [
            row[0],             // first column (unchanged)
            row.last,           // move last column to second position
            ...row.skip(1).take(row.length - 2), // remaining columns, except last
          ];

          final cells = List.generate(
            updatedRow.length,
                (index) => DataCell(
              Text(updatedRow[index] ?? ''),
              onTap: () {
                final rowData = {
                  'detail': row.length > 0 ? row[0] : '',
                  'cap': row.length > 1 ? row[1] : '',
                  'type': row.length > 1 ? row[1] : '',
                  'category': row.length > 2 ? row[2] : '',
                  'rank': row.length > 3 ? row[3] : '',
                  '2021': row.length > 4 ? row[4] : '',
                  '2022': row.length > 5 ? row[5] : '',
                  '2023': row.length > 6 ? row[6] : '',
                };
                widget.onRowSelected(rowData);
              },
            ),
          );
          return DataRow(cells: cells);
        }));
      }

      rows.addAll(await Future.wait(rowFutures));
    }

    return rows;
  }










  Future<void> _initializeGSheets() async {
    _gsheets = GSheets(_credentials);
    _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = _spreadsheet.worksheetByTitle(_spreadsheetName)!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataRow>>(
      future: _fetchTableRows(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found.'));
        }

        // Set rows only once the data is available
        if (_rows.isEmpty) {
          _rows = snapshot.data!;
        }

        return DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: _rows.first.cells.asMap().entries.map((entry) {
            final index = entry.key;
            final text = (entry.value.child as Text).data!;
            return DataColumn(
              label: Text(text),
              onSort: (int columnIndex, bool ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  _sortRows();
                });
              },
            );
          }).toList(),
          rows: _rows.sublist(1), // Exclude the header row from sorting
        );
      },
    );
  }


  void _sortRows() {
    setState(() {
      _rows = [
        _rows.first, // Keep header row unchanged
        ..._rows.sublist(1)
          ..sort((a, b) {
            final cellA = (a.cells[_sortColumnIndex].child as Text).data!;
            final cellB = (b.cells[_sortColumnIndex].child as Text).data!;
            return _sortAscending
                ? cellA.compareTo(cellB)
                : cellB.compareTo(cellA);
          }),
      ];
    });
  }
}








