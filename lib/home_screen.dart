import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../google_sheets_service.dart'; // Assurez-vous que le chemin est correct

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();
  List<List<Object>>? _sheetData;

  @override
  void initState() {
    super.initState();
    // Fetch initial sheet data
    _fetchSheetData();
  }

  Future<void> _fetchSheetData() async {
    const spreadsheetId = '1Az0Og6iT_LynDM6viNSGQbvL7qG3SVcrqe4bX2MZa_E';
    const range = 'Sheet1!A1:E10'; // Remplacez par votre plage de données
    final data = await _googleSheetsService.getSheetData(spreadsheetId, range);
    setState(() {
      _sheetData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2099, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchSheetData,
            child: Text('Fetch Sheet Data'),
          ),
          Expanded(
            child: _sheetData == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _sheetData!.length,
              itemBuilder: (context, index) {
                final row = _sheetData![index];
                return ListTile(
                  title: Text(row.join(', ')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
