import 'package:flutter/material.dart';
import '../theme/premium_theme.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'user_detail_screen.dart';
import 'create_user_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Future<List<dynamic>> usersFuture;
  String selectedRoleFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      usersFuture = _fetchUsers();
    });
  }

  Future<List<dynamic>> _fetchUsers() async {
    try {
      final response = await ApiService.fetchAllUsers();
      return response;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Role Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildRoleFilter('All', 'All'),
                  const SizedBox(width: 8),
                  _buildRoleFilter('ADMIN', 'ADMIN'),
                  const SizedBox(width: 8),
                  _buildRoleFilter('MECHANIC', 'MECHANIC'),
                  const SizedBox(width: 8),
                  _buildRoleFilter('ELECTRICIAN', 'ELECTRICIAN'),
                  const SizedBox(width: 8),
                  _buildRoleFilter('IT_SUPPORT', 'IT_SUPPORT'),
                ],
              ),
            ),
          ),
          // Users List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                final users = snapshot.data!;
                final filteredUsers = selectedRoleFilter == 'All'
                    ? users
                    : users.where((u) => u['role'] == selectedRoleFilter).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateUserScreen()),
          ).then((_) => _loadUsers());
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildRoleFilter(String label, String role) {
    final isSelected = selectedRoleFilter == role;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedRoleFilter = role;
        });
      },
      selectedColor: PremiumColors.accentGold,
      labelStyle: TextStyle(
        color: isSelected ? PremiumColors.primaryDark : PremiumColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      backgroundColor: PremiumColors.bgSecondary,
      side: BorderSide(
        color: isSelected ? PremiumColors.accentGold : PremiumColors.borderColor,
        width: isSelected ? 2 : 0.5,
      ),
    );
  }

  Widget _buildUserCard(dynamic user) {
    final roleColor = _getRoleColor(user['role']);
    final isActive = user['isActive'] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          color: roleColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: PremiumShadows.elevation1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserDetailScreen(userId: user['_id']),
              ),
            ).then((_) => _loadUsers());
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: PremiumColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user['email'] ?? 'No email',
                            style: const TextStyle(
                              fontSize: 12,
                              color: PremiumColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: roleColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getRoleDisplayName(user['role']),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: roleColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 14,
                          color: PremiumColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user['department'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 12,
                            color: PremiumColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (user['phone'] != null)
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: PremiumColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user['phone'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: PremiumColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? PremiumColors.statusSuccess.withOpacity(0.15)
                            : PremiumColors.statusDanger.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? PremiumColors.statusSuccess
                              : PremiumColors.statusDanger,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showDeleteConfirmation(user),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: PremiumColors.statusDanger.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: PremiumColors.statusDanger,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  void _showDeleteConfirmation(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: PremiumColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: PremiumColors.borderColor,
              width: 0.5,
            ),
            gradient: LinearGradient(
              colors: [
                PremiumColors.surfaceDark,
                PremiumColors.bgTertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PremiumColors.statusDanger.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: PremiumColors.statusDanger,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete User?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PremiumColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete ${user['name']}?\nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: PremiumColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PremiumColors.bgSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: PremiumColors.borderColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: PremiumColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _deleteUser(user['_id'], user['name']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PremiumColors.statusDanger,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        shadowColor: PremiumColors.statusDanger.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteUser(String userId, String userName) async {
    try {
      await ApiService.deleteUser(userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$userName deleted successfully'),
            backgroundColor: PremiumColors.statusSuccess,
            duration: const Duration(seconds: 2),
          ),
        );
        _loadUsers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting user: $e'),
            backgroundColor: PremiumColors.statusDanger,
          ),
        );
      }
    }
  }
}
