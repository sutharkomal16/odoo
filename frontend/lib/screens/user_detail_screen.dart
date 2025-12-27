import 'package:flutter/material.dart';
import '../theme/premium_theme.dart';
import '../services/api_service.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<Map<String, dynamic>> userFuture;
  late Future<Map<String, dynamic>> permissionsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    userFuture = ApiService.getUserById(widget.userId);
    permissionsFuture = ApiService.getUserPermissions(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header Card
                  _buildUserHeader(user),
                  const SizedBox(height: 20),

                  // User Information
                  _buildSection(
                    'Information',
                    Icons.person,
                    _buildUserInfo(user),
                  ),
                  const SizedBox(height: 16),

                  // Permissions
                  FutureBuilder<Map<String, dynamic>>(
                    future: permissionsFuture,
                    builder: (context, permSnapshot) {
                      if (permSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (permSnapshot.hasError) {
                        return const SizedBox();
                      } else if (permSnapshot.hasData) {
                        final permissions = permSnapshot.data!['permissions'] ?? {};
                        return _buildSection(
                          'Permissions',
                          Icons.security,
                          _buildPermissionsList(permissions),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserHeader(Map<String, dynamic> user) {
    final role = user['role'] ?? 'Unknown';
    final roleColor = _getRoleColor(role);
    final isActive = user['isActive'] ?? true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PremiumColors.surfaceDark,
            PremiumColors.bgTertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: roleColor.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: PremiumShadows.elevation2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: PremiumColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'] ?? 'No email',
                      style: const TextStyle(
                        fontSize: 13,
                        color: PremiumColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getRoleIcon(role),
                  color: roleColor,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: roleColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getRoleDisplayName(role),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: roleColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? PremiumColors.statusSuccess.withOpacity(0.15)
                      : PremiumColors.statusDanger.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? PremiumColors.statusSuccess.withOpacity(0.3)
                        : PremiumColors.statusDanger.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? PremiumColors.statusSuccess
                        : PremiumColors.statusDanger,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> user) {
    return Column(
      children: [
        _buildInfoRow('Email', user['email'] ?? 'N/A', Icons.email),
        const Divider(color: PremiumColors.borderColor),
        _buildInfoRow('Department', user['department'] ?? 'N/A', Icons.business),
        const Divider(color: PremiumColors.borderColor),
        _buildInfoRow(
          'Phone',
          user['phone'] ?? 'Not provided',
          Icons.phone,
        ),
        const Divider(color: PremiumColors.borderColor),
        _buildInfoRow(
          'Status',
          user['isActive'] == true ? 'Active' : 'Inactive',
          Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: PremiumColors.accentGold, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: PremiumColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: PremiumColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsList(Map<String, dynamic> permissions) {
    final permissionsMap = {
      'canCreateEquipment': 'Create Equipment',
      'canEditEquipment': 'Edit Equipment',
      'canDeleteEquipment': 'Delete Equipment',
      'canCreateRequest': 'Create Maintenance Request',
      'canAssignRequest': 'Assign Request to Technician',
      'canViewReports': 'View Reports & Analytics',
      'canManageTeams': 'Manage Teams',
      'canManageUsers': 'Manage Users',
    };

    return Column(
      children: permissionsMap.entries.map((entry) {
        final hasPermission = permissions[entry.key] == true;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: hasPermission
                      ? PremiumColors.statusSuccess.withOpacity(0.2)
                      : PremiumColors.statusDanger.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: hasPermission
                        ? PremiumColors.statusSuccess
                        : PremiumColors.statusDanger,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  hasPermission ? Icons.check : Icons.close,
                  size: 14,
                  color: hasPermission
                      ? PremiumColors.statusSuccess
                      : PremiumColors.statusDanger,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 13,
                    color: hasPermission
                        ? PremiumColors.textPrimary
                        : PremiumColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Container(
      width: double.infinity,
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
          color: PremiumColors.borderColor,
          width: 0.5,
        ),
        boxShadow: PremiumShadows.elevation1,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: PremiumColors.accentGold, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: PremiumColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return PremiumColors.accentGold;
      case 'MECHANIC':
        return PremiumColors.statusInfo;
      case 'ELECTRICIAN':
        return PremiumColors.statusWarning;
      case 'IT_SUPPORT':
        return PremiumColors.statusSuccess;
      default:
        return PremiumColors.textSecondary;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'ADMIN':
        return 'Administrator';
      case 'MECHANIC':
        return 'Mechanic';
      case 'ELECTRICIAN':
        return 'Electrician';
      case 'IT_SUPPORT':
        return 'IT Support';
      default:
        return role;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'ADMIN':
        return Icons.admin_panel_settings;
      case 'MECHANIC':
        return Icons.build;
      case 'ELECTRICIAN':
        return Icons.bolt;
      case 'IT_SUPPORT':
        return Icons.computer;
      default:
        return Icons.person;
    }
  }
}
