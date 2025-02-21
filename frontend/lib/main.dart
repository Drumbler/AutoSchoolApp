import 'package:flutter/material.dart';
import 'package:frontend/widgets/calendar_widget.dart';
import 'package:frontend/utils/calendar_logic.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ru_RU', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('ru', 'RU')],
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = CalendarLogic.defaultTime;

  void _updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text("Calendar App")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            CalendarWidget(
              isDarkMode: isDarkMode,
              selectedDate: selectedDate,
              onDaySelected: _updateDate,
            ),
            TextButton(
              onPressed: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: TimePickerThemeData(
                          hourMinuteColor: Color(0xf0f98133),
                          dialHandColor: Color(0xfff98133),
                          cancelButtonStyle: TextButton.styleFrom(
                            foregroundColor: Color(0xfff98133),
                          ),
                          confirmButtonStyle: TextButton.styleFrom(
                            foregroundColor: Color(0xfff98133),
                          ),
                          
                          hourMinuteShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Color(0xfff98133)),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (newTime != null) {
                  setState(() {
                    selectedTime = newTime;
                  });
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xfff98133),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Select Time'),
            ),
            const Expanded(child: SizedBox()),
            OutlinedButton(
              onPressed: () {
                print(
                  'Запись на ${CalendarLogic.formatDate(selectedDate)}, в ${CalendarLogic.formatTime(selectedTime)}',
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xfff98133), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Записаться',
                style: TextStyle(
                  color: isDarkMode ? Color(0xfff0f0f0) : Color(0xff333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
