import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'equipment_list_screen.dart';
import 'team_list_screen.dart';
import 'kanban_board_screen.dart';
import 'calendar_view_screen.dart';
import 'reports_screen.dart';
import 'maintenance_request_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, int>> dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    dashboardDataFuture = _fetchDashboardData();
  }

  Future<Map<String, int>> _fetchDashboardData() async {
    try {
      final allRequests = await ApiService.fetchAllRequests();
      final equipment = await ApiService.fetchAllEquipment();
      final teams = await ApiService.fetchAllTeams();

      int newRequests = allRequests.where((r) => r.status == 'New').length;
      int inProgressRequests =
          allRequests.where((r) => r.status == 'In Progress').length;
      int overdueRequests = allRequests.where((r) => r.isOverdue).length;

      return {
        'equipment': equipment.length,
        'teams': teams.length,
        'totalRequests': allRequests.length,
        'newRequests': newRequests,
        'inProgress': inProgressRequests,
        'overdue': overdueRequests,
      };
    } catch (e) {
      return {
        'equipment': 0,
        'teams': 0,
        'totalRequests': 0,
        'newRequests': 0,
        'inProgress': 0,
        'overdue': 0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gear Guard - Maintenance Management'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadDashboardData();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dashboard Stats
              FutureBuilder<Map<String, int>>(
                future: dashboardDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final data = snapshot.data ?? {};

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Equipment',
                                data['equipment'].toString(),
                                Icons.build,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Teams',
                                data['teams'].toString(),
                                Icons.people,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'New Requests',
                                data['newRequests'].toString(),
                                Icons.new_releases,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'In Progress',
                                data['inProgress'].toString(),
                                Icons.hourglass_bottom,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Overdue',
                                data['overdue'].toString(),
                                Icons.warning,
                                Colors.red,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Total Requests',
                                data['totalRequests'].toString(),
                                Icons.checklist,
                                Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'New Request',
                            Icons.add_circle_outline,
                            Colors.blue,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MaintenanceRequestFormScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            'Add Equipment',
                            Icons.add_box_outlined,
                            Colors.green,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EquipmentListScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu Sections
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Modules',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuTile(
                      'Equipment Management',
                      'Manage company assets and equipment',
                      Icons.build,
                      Colors.blue.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EquipmentListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMenuTile(
                      'Maintenance Teams',
                      'Manage teams and technicians',
                      Icons.people,
                      Colors.green.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TeamListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMenuTile(
                      'Kanban Board',
                      'Track requests with drag & drop',
                      Icons.view_kanban,
                      Colors.orange.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KanbanBoardScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMenuTile(
                      'Calendar View',
                      'Schedule preventive maintenance',
                      Icons.calendar_today,
                      Colors.purple.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CalendarViewScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMenuTile(
                      'Reports & Analytics',
                      'View maintenance statistics',
                      Icons.bar_chart,
                      Colors.red.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Gear Guard v1.0',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Asset & Maintenance Management System',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildMenuTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    _loadDashboardData();
  }
}
