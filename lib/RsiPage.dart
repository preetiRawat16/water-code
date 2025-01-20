import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class Rsipage extends StatefulWidget {
  @override
  _RsipageState createState() => _RsipageState();
}

class _RsipageState extends State<Rsipage> {
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
  final _nseCodeController = TextEditingController();
  final _rsiOutputController = TextEditingController();
  late GSheets _gsheets;
  late Spreadsheet _spreadsheet;

  @override
  void initState() {
    super.initState();
    _gsheets = GSheets(_credentials);
    _initializeSpreadsheet();
  }

  Future<void> _initializeSpreadsheet() async {
    try {
      _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    } catch (e) {
      print('Error initializing spreadsheet: $e');
    }
  }

  Future<void> _updateNseCode() async {
    if (_spreadsheet == null) return;

    try {
      final sheet = _spreadsheet.worksheetByTitle('test rsi');
      if (sheet != null) {
        await sheet.values.insertValue(_nseCodeController.text, column: 1, row: 1);
        print('NSE Code updated.');
      }
    } catch (e) {
      print('Error updating NSE Code: $e');
    }
  }


  Future<void> _fetchRsiOutput() async {
    if (_spreadsheet == null) return;

    try {
      final sheet = _spreadsheet.worksheetByTitle('RSI');
      if (sheet != null) {
        final result = await _pollForNumericValue(sheet, column: 9, row: 3, maxAttempts: 10);
        _rsiOutputController.text = result ?? 'Invalid Data';
      }
    } catch (e) {
      print('Error fetching RSI Output: $e');
    }
  }

  Future<String?> _pollForNumericValue(
      Worksheet sheet, {
        required int column,
        required int row,
        int maxAttempts = 10,
        Duration delay = const Duration(seconds: 1),
      }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final value = await sheet.values.value(column: column, row: row);
      if (value != null && double.tryParse(value) != null) {
        return value;
      }
      await Future.delayed(delay);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spreadsheet Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nseCodeController,
              decoration: InputDecoration(labelText: 'Enter NSE Code'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _updateNseCode,
                  child: Text('Update NSE Code'),
                ),
                ElevatedButton(
                  onPressed: _fetchRsiOutput,
                  child: Text('Fetch RSI Output'),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _rsiOutputController,
               readOnly: true,
              decoration: InputDecoration(labelText: 'RSI Output'),
            ),
          ],  
        ),
      ),
    );
  }
}
