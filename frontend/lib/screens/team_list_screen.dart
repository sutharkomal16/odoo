import 'package:flutter/material.dart';
import '../models/maintenance_team.dart';
import '../services/api_service.dart';
import 'team_form_screen.dart';
import 'team_detail_screen.dart';

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({Key? key}) : super(key: key);

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  late Future<List<MaintenanceTeam>> teamsFuture;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  void _loadTeams() {
    setState(() {
      teamsFuture = ApiService.fetchAllTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Teams'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<List<MaintenanceTeam>>(
        future: teamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No teams found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final team = snapshot.data![index];
              return TeamCard(
                team: team,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamDetailScreen(teamId: team.id!),
                    ),
                  ).then((_) => _loadTeams());
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TeamFormScreen(),
            ),
          ).then((_) => _loadTeams());
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final MaintenanceTeam team;
  final VoidCallback onTap;

  const TeamCard({
    Key? key,
    required this.team,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                          team.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (team.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            team.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: team.isActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      border: Border.all(
                        color: team.isActive ? Colors.green : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      team.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: team.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildInfoChip('👥', '${team.members.length} Members'),
                  if (team.defaultTechnicianName != null)
                    _buildInfoChip('⭐', team.defaultTechnicianName!),
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
