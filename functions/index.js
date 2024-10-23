const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {GoogleSpreadsheet} = require("google-spreadsheet");
const fetch = require("node-fetch"); // for HTTP requests

admin.initializeApp();

// Set up your credentials here
const credentials = {
  type: "service_account",
  project_id: "market-402714",
  private_key_id: "0336aa44822227801f2552cb556bf6e7dc7d1cc7",
  private_key:
    "-----BEGIN PRIVATE KEY-----\n" +
    "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCkK6e/ZeapLj31\n" +
    "LTyMISmjq5vwRGP7FT4Mlrg/dfflZ3ZmqwW24L1NDyZD/JsBZ7u54HnSvWElkxaX\n" +
    "+VbFWxrJeS3U2mOWUGmLL0ssauMBxeEeqKOUw0rorZ5MzohyvEyNnnXyyAIIrEbK\n" +
    "lHYlq8yH6t++4psqSVMvuspKw8tXrcGc3z/a/GTvNoxbGO7DzL9SusYUNmHZfn4v\n" +
    "V5BiD9nFNu269panSquGto+61RKg8UM5VaW39YZl03dmCyN4RGTck1sQ0lRxs0bq\n" +
    "Z4OgNvu9I/hUF+Q9GSUHDYaOAvEwO1fZ6vofI0t/gNEz8bpeznKu5vTNvedRNhvA\n" +
    "tGSFx13RAgMBAAECggEABaTA4ECY8JLCoKmfWyODtS4/ztS8Xs6w4p68HZBeXHrq\n" +
    "ntESbKI8Al4QNHDxWi0Y+WTpAzCCmlenWe5BcvOKD51/EMIOKjDATr9/inrFLCku\n" +
    "LzngX7Y5SReOKXlFxwidQBa6WsV7ORWaXGSZ+CW4WFQfwMXfoXvs+bx72kdHTPpX\n" +
    "IzbrHLxuTT8wnCpDO7W1L9IXbbcZQdpcegoMoYXglY83lPbBI7Y1AvpRCrEn/Tzn\n" +
    "LYLitw/007E8MNojwKaxTg+XlvOJIUEFC/CWlD8YNxq9ZTom6H1YAx3fOvUlas80\n" +
    "RARp+5MvEV/TTrCQoLBfa4KDMMv1Ti2G9Z8OoYzYnQKBgQDT19JBJDJAJ8P1J/Em\n" +
    "B4HZ90CrJaR3e+73hjFRImA4QwuZezFbi87QbzdDwBjiLOSq9OEG13ofYEYj+8tB\n" +
    "jDRop3OwEIaI53/7IPMtR3xrKafgC8DjohisrJd3Zlp77YawtOli2vBVJSbmfHKZ\n" +
    "OwyzZczVV4qUVlErf3THmYL7NQKBgQDGY/m+rNeRE8BeNjDILhJgYzNcYGpH0Ccq\n" +
    "kxVL+gUp3N5zlMGXqckZYzuIbgwsi4uKAc3XmAhYX/dpxXnoSk5kam2XhwwuYmc6\n" +
    "mG+cKbQyQla4TAcHbRhLYQ4wnpiJHPKXiHgiyXWP3HEdXahl55R41qo2RC07uidG\n" +
    "DEaes02PrQKBgG+yPPcB2cj/7o+Ftt2hWbMObjePSm+BlhdG1xv7bxZbK3OKhBTL\n" +
    "24kFCvObBsPCffMx2LBdztNaVMFGUv5FqaCAojv0CquGvHEyB2YZah2qwgwcxmB/\n" +
    "qFjrS5W2DwGG1Ny5FtF7tPp/80nV1iq6+tBgXacjWDssY/H2ayGO7IP9AoGARXeU\n" +
    "Z7PV97LW1SZchnu7a4zQ2zPXgzXbwQinmGb/j90K96XK8/Q7umwI2IjQMnjab4Sa\n" +
    "MzfFFEzmMV84hKIgOQEbRse++C70vovJ6QChXEfmXboha/RDYYGmmleuSbSdLXpX\n" +
    "tracN7eU1BeLc8NXNcjU6ROOUy+nuNtrjv5x1jECgYAgnimbR+Qml2JY9s8DHFmd\n" +
    "Ac+eqPN5os4RYofd1kQaamu+irw3di7hnFF/s9ek7onHP6/djIPuTLnv2alFniez\n" +
    "JpFqWfRusKsYvMFgrpIGmt6FLTinvY0voQkr00tsgmbKF/jKQ9c9owc/MyZPc79N\n" +
    "6PE8g0CzQ3NFku4QaN0wHg==\n" +
    "-----END PRIVATE KEY-----\n",
  client_email: "market@market-402714.iam.gserviceaccount.com",
  client_id: "109937386293673290483",
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
  client_x509_cert_url: "",
};

// Spreadsheet ID
const SPREADSHEET_ID = "1nNF82yIrisGX_UExSQs5IjiuSa9q1_5Xrm5iCn-CTj8";

// Cloud Function triggered at 5 PM Dubai time (1:00 PM UTC)
exports.scheduledStockUpdate = functions.pubsub
    .schedule("0 13 * * *")
    .timeZone("Asia/Dubai")
    .onRun(async (context) => {
      try {
      // Initialize Google Spreadsheet
        const doc = new GoogleSpreadsheet(SPREADSHEET_ID);
        await doc.useServiceAccountAuth(credentials);
        await doc.loadInfo(); // loads document properties and worksheets

        const sheet = doc.sheetsByTitle["Spreadsheet Database"];
        const rows = await sheet.getRows(); // Fetch all rows

        const currentDateTime = new Date()
            .toISOString()
            .slice(0, 19)
            .replace("T", " ");
        const newColumnIndex = sheet.columnCount; // Use const here

        for (let i = 1; i < rows.length; i++) { // Start at 1 to skip the header
          const stockCode = rows[i]["Stock Code"];
          const response = await fetch(`https://node-server-hj3k.onrender.com/${stockCode}`);
          const data = await response.json();

          if (response.ok && data.price) {
            rows[i][newColumnIndex] = data.price;
          } else {
            rows[i][newColumnIndex] = "Failed to fetch";
          }

          await rows[i].save(); // Save updated row
        }

        console.log(`Stock prices updated at ${currentDateTime}`);
      } catch (error) {
        console.error("Error fetching stock prices: ", error);
      }
    });
