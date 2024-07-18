import 'dart:convert';
import 'dart:io';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  static const _scopes = [SheetsApi.spreadsheetsScope, SheetsApi.driveScope];
  final _credentialsFilePath = 'assets/credentials.json'; // chemin vers le fichier de clés JSON

  Future<SheetsApi> _getSheetsApi() async {
    var client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        jsonDecode(await File(_credentialsFilePath).readAsString()),
      ),
      _scopes,
    );
    return SheetsApi(client);
  }

  Future<List<List<Object>>?> getSheetData(String spreadsheetId, String range) async {
    final sheetsApi = await _getSheetsApi();
    final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    // Vérifiez que les données ne contiennent pas de valeurs nulles
    return response.values?.map((row) => row.map((value) => value as Object).toList()).toList();
  }
}
