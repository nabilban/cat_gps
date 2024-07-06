import 'package:cat_gps/model/date_filter.dart';
import 'package:flutter/material.dart';

class AppDatePicker extends StatefulWidget {
  const AppDatePicker({super.key});

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _startDate?.hour ?? 0,
            _startDate?.minute ?? 0,
          );
        } else {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _endDate?.hour ?? 0,
            _endDate?.minute ?? 0,
          );
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(
            _startDate?.year ?? DateTime.now().year,
            _startDate?.month ?? DateTime.now().month,
            _startDate?.day ?? DateTime.now().day,
            picked.hour,
            picked.minute,
          );
        } else {
          _endDate = DateTime(
            _endDate?.year ?? DateTime.now().year,
            _endDate?.month ?? DateTime.now().month,
            _endDate?.day ?? DateTime.now().day,
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
              const SizedBox(height: 20),
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
                              ? _startDate!.toLocal().toString().split(' ')[0]
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, true),
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
                              ? TimeOfDay.fromDateTime(_startDate!)
                                  .format(context)
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () => _selectTime(context, true),
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
                              ? _endDate!.toLocal().toString().split(' ')[0]
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, false),
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
                              ? TimeOfDay.fromDateTime(_endDate!)
                                  .format(context)
                              : 'Not selected',
                        ),
                        TextButton(
                          onPressed: () => _selectTime(context, false),
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
                  if (_startDate != null && _endDate != null) {
                    Navigator.of(context).pop(
                      DateFilter(
                        startDate: _startDate!,
                        endDate: _endDate!,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please select both start and end dates and times.'),
                      ),
                    );
                  }
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
