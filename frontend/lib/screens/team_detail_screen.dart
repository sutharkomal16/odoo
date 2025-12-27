import 'package:flutter/material.dart';
import '../models/maintenance_team.dart';
import '../services/api_service.dart';
import 'team_form_screen.dart';

class TeamDetailScreen extends StatefulWidget {
  final String teamId;

  const TeamDetailScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  late Future<MaintenanceTeam?> teamFuture;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  void _loadTeam() {
    teamFuture = ApiService.fetchTeamById(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FutureBuilder<MaintenanceTeam?>(
                    future: teamFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return TeamFormScreen(initialTeam: snapshot.data);
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ).then((_) {
                setState(() => _loadTeam());
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<MaintenanceTeam?>(
        future: teamFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Team not found'));
          }

          final team = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${team.members.length} Members',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: team.isActive
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              border: Border.all(
                                color: team.isActive ? Colors.green : Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              team.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: team.isActive ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Details Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (team.description != null) ...[
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(team.description!),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (team.defaultTechnicianName != null) ...[
                        const Text(
                          'Default Technician',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade700,
                              child: Text(
                                team.defaultTechnicianName![0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(team.defaultTechnicianName!),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Members List
                      const Text(
                        'Team Members',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (team.members.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'No members in this team',
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
                          itemCount: team.members.length,
                          itemBuilder: (context, index) {
                            final member = team.members[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade700,
                                  child: Text(
                                    (member.userName ?? member.userId)[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(member.userName ?? member.userId),
                                subtitle: Text(member.role),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(member.role)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    member.role,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getRoleColor(member.role),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Manager':
        return Colors.red;
      case 'Lead':
        return Colors.orange;
      case 'Technician':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
