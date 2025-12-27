import 'package:flutter/material.dart';
import '../models/maintenance_team.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class TeamFormScreen extends StatefulWidget {
  final MaintenanceTeam? initialTeam;

  const TeamFormScreen({Key? key, this.initialTeam}) : super(key: key);

  @override
  State<TeamFormScreen> createState() => _TeamFormScreenState();
}

class _TeamFormScreenState extends State<TeamFormScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  String? selectedName;
  String? selectedDefaultTechnician;
  List<TeamMember> teamMembers = [];

  late Future<List<User>> usersFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialTeam?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.initialTeam?.description ?? '');

    selectedName = widget.initialTeam?.name;
    selectedDefaultTechnician = widget.initialTeam?.defaultTechnicianId;
    teamMembers = List.from(widget.initialTeam?.members ?? []);

    usersFuture = ApiService.fetchUsers();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a team name')),
      );
      return;
    }

    setState(() => isLoading = true);

    final team = MaintenanceTeam(
      id: widget.initialTeam?.id,
      name: selectedName!,
      description: descriptionController.text.isEmpty ? null : descriptionController.text,
      members: teamMembers,
      defaultTechnicianId: selectedDefaultTechnician,
    );

    try {
      await ApiService.createTeam(team);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team created successfully')),
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
        title: Text(widget.initialTeam == null ? 'Create Team' : 'Edit Team'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Team Name Dropdown
            DropdownButtonFormField<String>(
              value: selectedName,
              items: ['Mechanics', 'Electricians', 'IT Support', 'General Maintenance', 'Other']
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (value) => setState(() => selectedName = value),
              decoration: InputDecoration(
                labelText: 'Team Name *',
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
            const SizedBox(height: 24),

            // Members Section
            const Text(
              'Team Members',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Add Member Form
            FutureBuilder<List<User>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final users = snapshot.data ?? [];
                final availableUsers = users
                    .where((user) =>
                        !teamMembers.any((member) => member.userId == user.id))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String?>(
                            value: null,
                            hint: const Text('Select user to add'),
                            items: availableUsers
                                .map((user) => DropdownMenuItem<String?>(
                                      value: user.id.toString(),
                                      child: Text(user.name),
                                    ))
                                .toList(),
                            onChanged: (userId) {
                              if (userId != null) {
                                setState(() {
                                  final user = users.firstWhere((u) => u.id.toString() == userId);
                                  teamMembers.add(
                                    TeamMember(
                                      userId: userId,
                                      userName: user.name,
                                      role: 'Technician',
                                      joinedDate: DateTime.now(),
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Members List
                    if (teamMembers.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No members added yet',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: teamMembers.length,
                        itemBuilder: (context, index) {
                          final member = teamMembers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(member.userName ?? member.userId),
                              subtitle: Text(member.role),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() => teamMembers.removeAt(index));
                                },
                              ),
                              onTap: () {
                                _showRoleDialog(context, member, index);
                              },
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Default Technician
            FutureBuilder<List<User>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final users = snapshot.data ?? [];
                return DropdownButtonFormField<String?>(
                  value: selectedDefaultTechnician,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...users
                        .map((user) => DropdownMenuItem<String?>(
                              value: user.id.toString(),
                              child: Text(user.name),
                            ))
                        .toList(),
                  ],
                  onChanged: (value) => setState(() => selectedDefaultTechnician = value),
                  decoration: InputDecoration(
                    labelText: 'Default Technician',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
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
                      'Save Team',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, TeamMember member, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Role'),
        content: DropdownButton<String>(
          value: member.role,
          items: ['Manager', 'Technician', 'Lead']
              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                teamMembers[index] = member.copyWith(role: value);
              });
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

extension TeamMemberCopyWith on TeamMember {
  TeamMember copyWith({
    String? userId,
    String? userName,
    String? role,
    DateTime? joinedDate,
  }) {
    return TeamMember(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
