import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DateInputDropDown extends StatelessWidget {
  const DateInputDropDown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(
              Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }
}

class EventDateTimePicker extends StatelessWidget {
  ///`EventDate`,`EventStart`,`EventEnd` in EventDate Time Picker,
  /// There should be 2 TimePicker available.
  const EventDateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.eventStartTime,
      this.eventEndTime,
      this.selectDate,
      this.endSelect,
      this.startSelect})
      : super(key: key);
  final TimeOfDay eventEndTime;
  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay eventStartTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> startSelect;

  final ValueChanged<TimeOfDay> endSelect;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: eventStartTime);
    if (picked != null && picked != eventStartTime) startSelect(picked);
  }

  Future<Null> _endSelect(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: eventEndTime);
    if (picked != null && picked != eventStartTime) endSelect(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.subhead;
    return new Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new DateInputDropDown(
              labelText: labelText,
              valueText: new DateFormat.yMMMd().format(selectedDate),
              valueStyle: valueStyle,
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        new Expanded(
          child: new DateInputDropDown(
            labelText: 'From',
            valueText: eventStartTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectStart(context);
            },
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        new Expanded(
          flex: 1,
          child: new DateInputDropDown(
            labelText: 'To',
            valueText: eventEndTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _endSelect(context);
            },
          ),
        ),
      ],
    );
  }
}
