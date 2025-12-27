import 'package:flutter/material.dart';
import '../models/maintenance_request.dart';
import '../services/api_service.dart';
import '../theme/premium_theme.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({Key? key}) : super(key: key);

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  late Future<Map<String, List<MaintenanceRequest>>> requestsFuture;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      requestsFuture = ApiService.getRequestsByStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Kanban Board'),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, List<MaintenanceRequest>>>(
        future: requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found'));
          }

          final grouped = snapshot.data!;
          final statuses = ['New', 'In Progress', 'Repaired', 'On Hold'];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statuses.map((status) {
                return KanbanColumn(
                  status: status,
                  requests: grouped[status] ?? [],
                  onRequestUpdated: _loadRequests,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class KanbanColumn extends StatefulWidget {
  final String status;
  final List<MaintenanceRequest> requests;
  final VoidCallback onRequestUpdated;

  const KanbanColumn({
    Key? key,
    required this.status,
    required this.requests,
    required this.onRequestUpdated,
  }) : super(key: key);

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.status);

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: PremiumColors.bgSecondary,
        border: Border(
          left: BorderSide(
            color: statusColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.9),
                  statusColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.requests.length} tasks',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.requests.length,
              itemBuilder: (context, index) {
                return KanbanCard(
                  request: widget.requests[index],
                  onStatusChanged: widget.onRequestUpdated,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return PremiumColors.statusInfo;
      case 'In Progress':
        return PremiumColors.statusPending;
      case 'Repaired':
        return PremiumColors.statusSuccess;
      case 'On Hold':
        return PremiumColors.statusWarning;
      default:
        return PremiumColors.statusWarning;
    }
  }
}

class KanbanCard extends StatefulWidget {
  final MaintenanceRequest request;
  final VoidCallback onStatusChanged;

  const KanbanCard({
    Key? key,
    required this.request,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  bool isLoading = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => isLoading = true);

    try {
      await ApiService.updateRequestStatus(widget.request.id!, newStatus);
      widget.onStatusChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
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
    final priorityColor = _getPriorityColor(widget.request.priority);
    final isOverdue = widget.request.isOverdue &&
        widget.request.status != 'Repaired' &&
        widget.request.status != 'Scrap';

    return GestureDetector(
      onLongPress: () {
        _showStatusOptions(context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: isLoading ? 4 : 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: priorityColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Request Number and Priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.request.requestNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.request.priority,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Subject
                Text(
                  widget.request.subject,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Equipment Info
                Text(
                  'Equipment: ${widget.request.equipmentName ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Assigned To
                if (widget.request.assignedToName != null)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blue.shade700,
                        child: Text(
                          widget.request.assignedToName![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.request.assignedToName ?? 'Unassigned',
                          style: const TextStyle(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (widget.request.assignedToName == null)
                  Text(
                    'Unassigned',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 8),
                // Overdue Indicator
                if (isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '⚠️ OVERDUE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Drag Hint
                Text(
                  'Long press to change status',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusOptions(BuildContext context) {
    final statuses = ['New', 'In Progress', 'Repaired', 'On Hold'];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...statuses
                .where((s) => s != widget.request.status)
                .map(
                  (status) => ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateStatus(status);
                    },
                    child: Text(status),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
