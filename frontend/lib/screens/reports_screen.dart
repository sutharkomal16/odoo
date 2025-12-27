import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/premium_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedReport = 'byTeam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Reports'),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Column(
        children: [
          // Report Type Selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildReportButton('By Team', 'byTeam'),
                  const SizedBox(width: 8),
                  _buildReportButton('By Category', 'byCategory'),
                ],
              ),
            ),
          ),
          // Report Content
          Expanded(
            child: selectedReport == 'byTeam'
                ? const RequestsByTeamReport()
                : const RequestsByCategoryReport(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton(String label, String value) {
    final isSelected = selectedReport == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedReport = value;
        });
      },
      selectedColor: Colors.blue.shade700,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}

class RequestsByTeamReport extends StatefulWidget {
  const RequestsByTeamReport({Key? key}) : super(key: key);

  @override
  State<RequestsByTeamReport> createState() => _RequestsByTeamReportState();
}

class _RequestsByTeamReportState extends State<RequestsByTeamReport> {
  late Future<List<dynamic>> teamReportFuture;

  @override
  void initState() {
    super.initState();
    teamReportFuture = ApiService.getRequestsByTeam();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: teamReportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!;
        int maxCount = 0;
        for (var item in data) {
          if ((item['count'] ?? 0) > maxCount) {
            maxCount = item['count'];
          }
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Maintenance Requests by Team',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ...data.map((item) {
                  final teamName = item['teamInfo']?['name'] ?? 'Unknown';
                  final count = item['count'] ?? 0;
                  final openCount = item['openCount'] ?? 0;
                  final percentage = maxCount > 0 ? (count / maxCount) * 100 : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                teamName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$count Total',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$openCount Open',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              LinearProgressIndicator(
                                value: percentage / 100,
                                minHeight: 24,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTeamColor(data.indexOf(item)),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTeamColor(int index) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}

class RequestsByCategoryReport extends StatefulWidget {
  const RequestsByCategoryReport({Key? key}) : super(key: key);

  @override
  State<RequestsByCategoryReport> createState() =>
      _RequestsByCategoryReportState();
}

class _RequestsByCategoryReportState extends State<RequestsByCategoryReport> {
  late Future<List<dynamic>> categoryReportFuture;

  @override
  void initState() {
    super.initState();
    categoryReportFuture = ApiService.getRequestsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: categoryReportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!;
        int totalCount = 0;
        for (var item in data) {
          totalCount += ((item['count'] ?? 0) as num).toInt();
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Maintenance Requests by Equipment Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // Pie Chart-like representation using bars
                ...data.map((item) {
                  final category = item['_id'] ?? 'Unknown';
                  final count = item['count'] ?? 0;
                  final openCount = item['openCount'] ?? 0;
                  final percentage =
                      totalCount > 0 ? (count / totalCount) * 100 : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$count',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$openCount open',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              LinearProgressIndicator(
                                value: percentage / 100,
                                minHeight: 24,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getCategoryColor(data.indexOf(item)),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Total Requests',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$totalCount',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}
