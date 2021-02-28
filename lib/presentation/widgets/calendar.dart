//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/blocs/journal_bloc/journal_bloc.dart';
import 'package:flutter/material.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);


  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }


  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(context),
        ],
      );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(BuildContext contetx) {
    final user = context.select((AuthenticationBloc bloc ) => bloc.state.user);
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {
        CalendarFormat.week : "Semaine",
        CalendarFormat.month : "Mois",
        CalendarFormat.twoWeeks : "2 semaines"
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.green[400],
        todayColor: Colors.green[200],
        markersColor: Colors.brown[700],
        weekendStyle: TextStyle(color: Colors.green),
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.green[600]),
      ),
      onDaySelected: (date,event,holiday) {
        context.read<JournalBloc>().add(
          JournalDateChange(date,user)
        );
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: (first,last,format) {
        context.read<JournalBloc>().add(
          JournalDateChange(DateTime.now(),user)
        );
      },
    );
  }


}