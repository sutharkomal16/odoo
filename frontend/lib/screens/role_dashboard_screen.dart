import 'package:flutter/material.dart';
import '../theme/premium_theme.dart';
import '../services/api_service.dart';

class RoleDashboardScreen extends StatefulWidget {
  const RoleDashboardScreen({Key? key}) : super(key: key);

  @override
  State<RoleDashboardScreen> createState() => _RoleDashboardScreenState();
}

class _RoleDashboardScreenState extends State<RoleDashboardScreen> {
  late Future<Map<String, dynamic>> roleStatsFuture;
  late Future<List<dynamic>> usersByRoleFuture;

  final Map<String, Map<String, dynamic>> roleInfo = {
    'ADMIN': {
      'label': 'Administrator',
      'color': PremiumColors.accentGold,
      'icon': Icons.admin_panel_settings,
      'description': 'Full system access and user management',
      'permissions': [
        'Create/Edit/Delete Equipment',
        'Create/Edit/Delete Maintenance Requests',
        'Manage Teams and Members',
        'Manage Users and Permissions',
        'View Analytics and Reports',
        'System Settings',
      ]
    },
    'MECHANIC': {
      'label': 'Mechanic',
      'color': PremiumColors.statusInfo,
      'icon': Icons.build,
      'description': 'Manage mechanical equipment and maintenance',
      'permissions': [
        'View Equipment Details',
        'Create Maintenance Requests',
        'Edit/Delete Own Requests',
        'View Team Schedule',
        'Update Request Status',
        'Record Maintenance Hours',
      ]
    },
    'ELECTRICIAN': {
      'label': 'Electrician',
      'color': PremiumColors.statusWarning,
      'icon': Icons.bolt,
      'description': 'Manage electrical systems and requests',
      'permissions': [
        'View Equipment Details',
        'Create Maintenance Requests',
        'Edit/Delete Own Requests',
        'View Team Schedule',
        'Update Request Status',
        'Record Electrical Logs',
      ]
    },
    'IT_SUPPORT': {
      'label': 'IT Support',
      'color': PremiumColors.statusSuccess,
      'icon': Icons.computer,
      'description': 'Manage IT infrastructure and support',
      'permissions': [
        'View IT Equipment',
        'Create Support Requests',
        'Manage IT Resources',
        'View Support Tickets',
        'Update System Status',
        'Monitor Infrastructure',
      ]
    },
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    roleStatsFuture = ApiService.getRoleStats();
    usersByRoleFuture = ApiService.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Dashboard'),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Role Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: PremiumColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'User distribution and role permissions',
                style: TextStyle(
                  fontSize: 13,
                  color: PremiumColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Role Statistics Cards
              FutureBuilder<List<dynamic>>(
                future: usersByRoleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const SizedBox();
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return _buildRoleStatistics(users);
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 24),

              // Detailed Role Information
              const Text(
                'Role Permissions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PremiumColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._buildRoleDetailsCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleStatistics(List<dynamic> users) {
    final stats = <String, int>{
      'ADMIN': 0,
      'MECHANIC': 0,
      'ELECTRICIAN': 0,
      'IT_SUPPORT': 0,
    };

    for (var user in users) {
      final role = user['role'] ?? 'MECHANIC';
      if (stats.containsKey(role)) {
        stats[role] = (stats[role] ?? 0) + 1;
      }
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: stats.entries.map((entry) {
        final roleData = roleInfo[entry.key]!;
        return _buildStatCard(
          role: entry.key,
          label: roleData['label'],
          count: entry.value,
          color: roleData['color'],
          icon: roleData['icon'],
        );
      }).toList(),
    );
  }

  Widget _buildStatCard({
    required String role,
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            PremiumColors.surfaceDark,
            PremiumColors.bgTertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: PremiumShadows.elevation1,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: PremiumColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleDetailsCards() {
    return roleInfo.entries.map((entry) {
      final role = entry.key;
      final data = entry.value as Map<String, dynamic>;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildRoleCard(
          role: role,
          label: data['label'],
          description: data['description'],
          color: data['color'],
          icon: data['icon'],
          permissions: List<String>.from(data['permissions']),
        ),
      );
    }).toList();
  }

  Widget _buildRoleCard({
    required String role,
    required String label,
    required String description,
    required Color color,
    required IconData icon,
    required List<String> permissions,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            PremiumColors.surfaceDark,
            PremiumColors.bgTertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: PremiumShadows.elevation1,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: PremiumColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            color: PremiumColors.borderColor,
            height: 1,
          ),
          const SizedBox(height: 12),
          const Text(
            'Permissions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PremiumColors.textMuted,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          ...permissions.map((permission) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      permission,
                      style: const TextStyle(
                        fontSize: 12,
                        color: PremiumColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              );
            );
          }).toList(),
        ],
      ),
    );
  }
}
