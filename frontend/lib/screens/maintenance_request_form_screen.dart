import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/maintenance_request.dart';
import '../models/maintenance_team.dart';
import '../services/api_service.dart';

class MaintenanceRequestFormScreen extends StatefulWidget {
  final Equipment? equipment;
  final MaintenanceRequest? initialRequest;

  const MaintenanceRequestFormScreen({
    Key? key,
    this.equipment,
    this.initialRequest,
  }) : super(key: key);

  @override
  State<MaintenanceRequestFormScreen> createState() =>
      _MaintenanceRequestFormScreenState();
}

class _MaintenanceRequestFormScreenState extends State<MaintenanceRequestFormScreen> {
  late TextEditingController subjectController;
  late TextEditingController descriptionController;
  late TextEditingController estimatedDurationController;

  String selectedType = 'Corrective'; // Corrective or Preventive
  String selectedPriority = 'Medium';
  String? selectedEquipmentId;
  String? selectedEquipmentCategory;
  String? selectedTeamId;
  DateTime? scheduledDate;

  late Future<List<Equipment>> equipmentFuture;
  late Future<List<MaintenanceTeam>> teamsFuture;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController(text: widget.initialRequest?.subject ?? '');
    descriptionController =
        TextEditingController(text: widget.initialRequest?.description ?? '');
    estimatedDurationController = TextEditingController(
      text: widget.initialRequest?.estimatedDuration.toString() ?? '',
    );

    selectedType = widget.initialRequest?.type ?? 'Corrective';
    selectedPriority = widget.initialRequest?.priority ?? 'Medium';
    selectedEquipmentId = widget.equipment?.id ?? widget.initialRequest?.equipmentId;
    selectedEquipmentCategory =
        widget.equipment?.category ?? widget.initialRequest?.equipmentCategory;
    selectedTeamId = widget.equipment?.maintenanceTeamId ?? widget.initialRequest?.maintenanceTeamId;
    scheduledDate = widget.initialRequest?.scheduledDate;

    equipmentFuture = ApiService.fetchAllEquipment();
    teamsFuture = ApiService.fetchAllTeams();
  }

  @override
  void dispose() {
    subjectController.dispose();
    descriptionController.dispose();
    estimatedDurationController.dispose();
    super.dispose();
  }

  Future<void> _selectScheduledDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: scheduledDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        scheduledDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (subjectController.text.isEmpty ||
        selectedEquipmentId == null ||
        selectedTeamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (selectedType == 'Preventive' && scheduledDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a scheduled date for preventive maintenance')),
      );
      return;
    }

    setState(() => isLoading = true);

    final request = MaintenanceRequest(
      requestNumber: widget.initialRequest?.requestNumber ?? '',
      type: selectedType,
      subject: subjectController.text,
      description: descriptionController.text.isEmpty ? null : descriptionController.text,
      equipmentId: selectedEquipmentId,
      equipmentCategory: selectedEquipmentCategory,
      maintenanceTeamId: selectedTeamId,
      status: widget.initialRequest?.status ?? 'New',
      priority: selectedPriority,
      scheduledDate: selectedType == 'Preventive' ? scheduledDate : null,
      estimatedDuration: estimatedDurationController.text.isNotEmpty
          ? double.parse(estimatedDurationController.text)
          : 0,
    );

    try {
      await ApiService.createMaintenanceRequest(request);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maintenance request created successfully')),
      );
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
        title: const Text('Create Maintenance Request'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Request Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Type *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeButton('Corrective', 'Corrective', Colors.red),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child:
                              _buildTypeButton('Preventive', 'Preventive', Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedType == 'Corrective'
                          ? 'Unplanned repair (Breakdown)'
                          : 'Planned maintenance (Routine Checkup)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Equipment Selection with Auto-fill
            FutureBuilder<List<Equipment>>(
              future: equipmentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final equipmentList = snapshot.data ?? [];
                final isEquipmentDisabled = widget.equipment != null;

                return DropdownButtonFormField<String>(
                  value: selectedEquipmentId,
                  items: equipmentList
                      .map((eq) => DropdownMenuItem(
                            value: eq.id,
                            child: Text(eq.name),
                          ))
                      .toList(),
                  onChanged: isEquipmentDisabled
                      ? null
                      : (value) {
                          setState(() {
                            selectedEquipmentId = value;
                            // Auto-fill logic
                            final selected =
                                equipmentList.firstWhere((eq) => eq.id == value);
                            selectedEquipmentCategory = selected.category;
                            selectedTeamId = selected.maintenanceTeamId;
                          });
                        },
                  decoration: InputDecoration(
                    labelText: 'Equipment *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    helperText: 'Selecting equipment will auto-fill category and team',
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Category (Auto-filled, Read-only)
            TextField(
              controller: TextEditingController(text: selectedEquipmentCategory ?? ''),
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Equipment Category (Auto-filled)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Team (Auto-filled but editable if needed)
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
                      .map((team) => DropdownMenuItem(
                            value: team.id,
                            child: Text(team.name),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedTeamId = value),
                  decoration: InputDecoration(
                    labelText: 'Maintenance Team * (Auto-filled)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Subject
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject (What is wrong?) *',
                hintText: 'e.g., Leaking Oil, Screen Not Working',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Priority
            DropdownButtonFormField<String>(
              value: selectedPriority,
              items: ['Low', 'Medium', 'High', 'Critical']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) => setState(() => selectedPriority = value!),
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Estimated Duration
            TextField(
              controller: estimatedDurationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Estimated Duration (hours)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Scheduled Date (only for Preventive)
            if (selectedType == 'Preventive')
              ListTile(
                title: Text(
                  'Scheduled Date: ${scheduledDate?.toString().split(' ')[0] ?? 'Select date'}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectScheduledDate(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
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
                      'Create Request',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String value, Color color) {
    final isSelected = selectedType == value;
    return OutlinedButton(
      onPressed: () => setState(() => selectedType = value),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.transparent,
        side: BorderSide(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
