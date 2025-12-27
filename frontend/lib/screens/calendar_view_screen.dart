import 'package:flutter/material.dart';
import '../models/maintenance_request.dart';
import '../services/api_service.dart';
import 'maintenance_request_form_screen.dart';

class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({Key? key}) : super(key: key);

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  late Future<List<MaintenanceRequest>> preventiveRequestsFuture;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPreventiveRequests();
  }

  void _loadPreventiveRequests() {
    setState(() {
      preventiveRequestsFuture = ApiService.getPreventiveRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preventive Maintenance Calendar'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPreventiveRequests,
          ),
        ],
      ),
      body: FutureBuilder<List<MaintenanceRequest>>(
        future: preventiveRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              children: [
                // Calendar View
                CalendarWidget(
                  requests: requests,
                  onDateSelected: (date) {
                    setState(() => selectedDate = date);
                  },
                ),
                const SizedBox(height: 16),
                // Requests for Selected Date
                DayScheduleWidget(
                  date: selectedDate,
                  requests: requests,
                  onRequestAdded: _loadPreventiveRequests,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final List<MaintenanceRequest> requests;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    Key? key,
    required this.requests,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime focusedMonth;

  @override
  void initState() {
    super.initState();
    focusedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      focusedMonth =
                          DateTime(focusedMonth.year, focusedMonth.month - 1);
                    });
                  },
                ),
                Text(
                  '${_monthName(focusedMonth.month)} ${focusedMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      focusedMonth =
                          DateTime(focusedMonth.year, focusedMonth.month + 1);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Days Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Text(
                        day,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar Grid
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getDaysInMonth(focusedMonth.year, focusedMonth.month) +
                  _getFirstDayOfMonth(focusedMonth.year, focusedMonth.month),
              itemBuilder: (context, index) {
                final firstDay =
                    _getFirstDayOfMonth(focusedMonth.year, focusedMonth.month);
                final dayNumber = index - firstDay + 1;

                if (index < firstDay || dayNumber > _getDaysInMonth(focusedMonth.year, focusedMonth.month)) {
                  return const SizedBox();
                }

                final date = DateTime(focusedMonth.year, focusedMonth.month, dayNumber);
                final dayRequests = widget.requests
                    .where((req) =>
                        req.scheduledDate?.year == date.year &&
                        req.scheduledDate?.month == date.month &&
                        req.scheduledDate?.day == date.day)
                    .toList();

                return CalendarDayCell(
                  date: date,
                  requestCount: dayRequests.length,
                  requests: dayRequests,
                  onDateSelected: widget.onDateSelected,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    }
    return DateTime(year, month + 1, 0).day;
  }

  int _getFirstDayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday % 7;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final int requestCount;
  final List<MaintenanceRequest> requests;
  final Function(DateTime) onDateSelected;

  const CalendarDayCell({
    Key? key,
    required this.date,
    required this.requestCount,
    required this.requests,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        decoration: BoxDecoration(
          color: isToday ? Colors.blue.shade100 : Colors.transparent,
          border: Border.all(
            color: isToday ? Colors.blue : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.blue : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  if (requestCount > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '$requestCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DayScheduleWidget extends StatelessWidget {
  final DateTime date;
  final List<MaintenanceRequest> requests;
  final VoidCallback onRequestAdded;

  const DayScheduleWidget({
    Key? key,
    required this.date,
    required this.requests,
    required this.onRequestAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayRequests = requests
        .where((req) =>
            req.scheduledDate?.year == date.year &&
            req.scheduledDate?.month == date.month &&
            req.scheduledDate?.day == date.day)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scheduled Maintenance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date.toString().split(' ')[0],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MaintenanceRequestFormScreen(),
                    ),
                  ).then((_) => onRequestAdded());
                },
                icon: const Icon(Icons.add),
                label: const Text('New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (dayRequests.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No maintenance scheduled for this date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayRequests.length,
              itemBuilder: (context, index) {
                final request = dayRequests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(request.subject),
                    subtitle: Text(
                      'Team: ${request.maintenanceTeamName ?? 'N/A'}\nEquipment: ${request.equipmentName ?? 'N/A'}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(request.status),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Repaired':
        return Colors.green;
      case 'On Hold':
        return Colors.grey;
      case 'Scrap':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
