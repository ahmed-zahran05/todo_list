import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDatePicker extends StatefulWidget {
  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> _generateDays() {
    return List.generate(
      30,
          (index) => DateTime.now().add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays();

    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day.day == selectedDate.day &&
              day.month == selectedDate.month &&
              day.year == selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = day;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  )
                ]
                    : [],
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(day),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
