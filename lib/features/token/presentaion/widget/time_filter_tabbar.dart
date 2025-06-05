import 'package:flutter/material.dart';

enum TimeFilter {
  hour('1H'),
  today('1D'),
  thisWeek('1W'),
  thisMonth('1M'),
  thisYear('1Y'),
  allTime('ALL');

  final String abbreviation;
  const TimeFilter(this.abbreviation);
}

class TimeFilterTabBar extends StatefulWidget {
  final ValueChanged<TimeFilter> onFilterChanged;
  final TimeFilter initialFilter;

  const TimeFilterTabBar({
    Key? key,
    required this.onFilterChanged,
    this.initialFilter = TimeFilter.today,
  }) : super(key: key);

  @override
  _TimeFilterTabBarState createState() => _TimeFilterTabBarState();
}

class _TimeFilterTabBarState extends State<TimeFilterTabBar> {
  late TimeFilter _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TimeFilter.values.map((filter) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
              widget.onFilterChanged(filter);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedFilter == filter
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                filter.abbreviation,
                style: TextStyle(
                  color:
                      _selectedFilter == filter ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
