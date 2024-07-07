// ignore_for_file: unnecessary_null_comparison

import 'package:cat_gps/model/date_filter.dart';
import 'package:flutter/material.dart';

class AppDatePicker extends StatefulWidget {
  const AppDatePicker({super.key});

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime _startDate = DateTime.now().subtract(const Duration(hours: 1));
  DateTime _endDate = DateTime.now();

  Future<void> _selectDate(
      BuildContext context, bool isStart, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _startDate.hour,
            _startDate.minute,
          );
        } else {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _endDate.hour,
            _endDate.minute,
          );
        }
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, bool isStart, TimeOfDay initialtime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialtime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
            picked.hour,
            picked.minute,
          );
        } else {
          _endDate = DateTime(
            _endDate.year,
            _endDate.month,
            _endDate.day,
            picked.hour,
            picked.minute,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Start Date:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          _startDate != null
                              ? _startDate.toLocal().toString().split(' ')[0]
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () =>
                              _selectDate(context, true, _startDate),
                          child: const Icon(Icons.calendar_month_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Start Time:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          _startDate != null
                              ? TimeOfDay.fromDateTime(_startDate)
                                  .format(context)
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () => _selectTime(
                            context,
                            true,
                            TimeOfDay(
                              hour: (TimeOfDay.now().hour != 0
                                      ? TimeOfDay.now().hour
                                      : 24) -
                                  1,
                              minute: TimeOfDay.now().minute,
                            ),
                          ),
                          child: const Icon(Icons.watch_later_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('End Date:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          _endDate != null
                              ? _endDate.toLocal().toString().split(' ')[0]
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () =>
                              _selectDate(context, false, _endDate),
                          child: const Icon(Icons.calendar_month_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('End Time:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          _endDate != null
                              ? TimeOfDay.fromDateTime(_endDate).format(context)
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () => _selectTime(
                            context,
                            false,
                            TimeOfDay.now(),
                          ),
                          child: const Icon(Icons.watch_later_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    DateFilter(
                      startDate: _startDate,
                      endDate: _endDate,
                    ),
                  );
                },
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
