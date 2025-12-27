import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../services/api_service.dart';
import '../theme/premium_theme.dart';
import 'equipment_detail_screen.dart';
import 'equipment_form_screen.dart';

class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({Key? key}) : super(key: key);

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  late Future<List<Equipment>> equipmentList;
  String selectedFilter = 'All';
  String? selectedDepartment;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  void _loadEquipment() {
    setState(() {
      equipmentList = ApiService.fetchAllEquipment(
        department: selectedDepartment,
        category: selectedCategory,
        status: selectedFilter == 'All' ? null : selectedFilter,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Management'),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Column(
        children: [
          // Filter Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildFilterChip('All', 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', 'Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Inactive', 'Inactive'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Scrap', 'Scrap'),
                  const SizedBox(width: 8),
                  _buildDepartmentFilter(),
                  const SizedBox(width: 8),
                  _buildCategoryFilter(),
                ],
              ),
            ),
          ),
          // Equipment List
          Expanded(
            child: FutureBuilder<List<Equipment>>(
              future: equipmentList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No equipment found'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final equipment = snapshot.data![index];
                    return EquipmentCard(
                      equipment: equipment,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EquipmentDetailScreen(equipmentId: equipment.id!),
                          ),
                        );
                      },
                    );
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
            MaterialPageRoute(
              builder: (_) => const EquipmentFormScreen(),
            ),
          ).then((_) => _loadEquipment());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedFilter = value;
          _loadEquipment();
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

  Widget _buildDepartmentFilter() {
    return DropdownButton<String?>(
      value: selectedDepartment,
      hint: const Text('Department'),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Departments')),
        const DropdownMenuItem(value: 'Production', child: Text('Production')),
        const DropdownMenuItem(value: 'IT', child: Text('IT')),
        const DropdownMenuItem(value: 'HR', child: Text('HR')),
        const DropdownMenuItem(value: 'Finance', child: Text('Finance')),
        const DropdownMenuItem(value: 'Operations', child: Text('Operations')),
      ],
      onChanged: (value) {
        setState(() {
          selectedDepartment = value;
          _loadEquipment();
        });
      },
    );
  }

  Widget _buildCategoryFilter() {
    return DropdownButton<String?>(
      value: selectedCategory,
      hint: const Text('Category'),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Categories')),
        const DropdownMenuItem(value: 'Machinery', child: Text('Machinery')),
        const DropdownMenuItem(value: 'Vehicle', child: Text('Vehicle')),
        const DropdownMenuItem(value: 'Computer', child: Text('Computer')),
        const DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
        const DropdownMenuItem(value: 'Other', child: Text('Other')),
      ],
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
          _loadEquipment();
        });
      },
    );
  }
}

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback onTap;

  const EquipmentCard({
    Key? key,
    required this.equipment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = equipment.status == 'Active'
        ? Colors.green
        : equipment.status == 'Inactive'
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                          equipment.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'S/N: ${equipment.serialNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      equipment.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildInfoChip('📍', equipment.location),
                  _buildInfoChip('🏢', equipment.department),
                  _buildInfoChip('🔧', equipment.category),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
