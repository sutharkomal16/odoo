import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/maintenance_team.dart';
import '../services/api_service.dart';

class EquipmentFormScreen extends StatefulWidget {
  final Equipment? initialEquipment;

  const EquipmentFormScreen({Key? key, this.initialEquipment}) : super(key: key);

  @override
  State<EquipmentFormScreen> createState() => _EquipmentFormScreenState();
}

class _EquipmentFormScreenState extends State<EquipmentFormScreen> {
  late TextEditingController nameController;
  late TextEditingController serialNumberController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;

  String? selectedCategory;
  String? selectedDepartment;
  String? selectedTeamId;
  DateTime? purchaseDate;
  DateTime? warrantyDate;

  late Future<List<MaintenanceTeam>> teamsFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialEquipment?.name ?? '');
    serialNumberController =
        TextEditingController(text: widget.initialEquipment?.serialNumber ?? '');
    locationController = TextEditingController(text: widget.initialEquipment?.location ?? '');
    descriptionController =
        TextEditingController(text: widget.initialEquipment?.description ?? '');

    selectedCategory = widget.initialEquipment?.category;
    selectedDepartment = widget.initialEquipment?.department;
    selectedTeamId = widget.initialEquipment?.maintenanceTeamId;
    purchaseDate = widget.initialEquipment?.purchaseDate ?? DateTime.now();
    warrantyDate = widget.initialEquipment?.warrantyExpiryDate;

    teamsFuture = ApiService.fetchAllTeams();
  }

  @override
  void dispose() {
    nameController.dispose();
    serialNumberController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isWarranty) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isWarranty ? (warrantyDate ?? DateTime.now()) : purchaseDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isWarranty) {
          warrantyDate = picked;
        } else {
          purchaseDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (nameController.text.isEmpty ||
        serialNumberController.text.isEmpty ||
        selectedCategory == null ||
        selectedDepartment == null ||
        selectedTeamId == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    final equipment = Equipment(
      id: widget.initialEquipment?.id,
      name: nameController.text,
      serialNumber: serialNumberController.text,
      category: selectedCategory!,
      department: selectedDepartment!,
      maintenanceTeamId: selectedTeamId!,
      purchaseDate: purchaseDate!,
      warrantyExpiryDate: warrantyDate,
      location: locationController.text,
      description: descriptionController.text.isEmpty ? null : descriptionController.text,
    );

    try {
      if (widget.initialEquipment == null) {
        await ApiService.createEquipment(equipment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Equipment created successfully')),
        );
      } else {
        await ApiService.updateEquipment(widget.initialEquipment!.id!, equipment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Equipment updated successfully')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialEquipment == null ? 'Add Equipment' : 'Edit Equipment'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Equipment Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Equipment Name *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Serial Number
            TextField(
              controller: serialNumberController,
              decoration: InputDecoration(
                labelText: 'Serial Number *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ['Machinery', 'Vehicle', 'Computer', 'Electrical', 'Other']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => setState(() => selectedCategory = value),
              decoration: InputDecoration(
                labelText: 'Category *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Department Dropdown
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              items: ['Production', 'IT', 'HR', 'Finance', 'Operations', 'Other']
                  .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                  .toList(),
              onChanged: (value) => setState(() => selectedDepartment = value),
              decoration: InputDecoration(
                labelText: 'Department *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Maintenance Team
            FutureBuilder<List<MaintenanceTeam>>(
              future: teamsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final teams = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: selectedTeamId,
                  items: teams
                      .map((team) =>
                          DropdownMenuItem(value: team.id, child: Text(team.name)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedTeamId = value),
                  decoration: InputDecoration(
                    labelText: 'Maintenance Team *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Location
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Purchase Date
            ListTile(
              title: Text('Purchase Date: ${purchaseDate?.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            // Warranty Date
            ListTile(
              title: Text(
                'Warranty Expiry: ${warrantyDate?.toString().split(' ')[0] ?? 'Not set'}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Equipment',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
