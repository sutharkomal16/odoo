import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/maintenance_request.dart';
import '../services/api_service.dart';
import 'equipment_form_screen.dart';
import 'maintenance_request_form_screen.dart';

class EquipmentDetailScreen extends StatefulWidget {
  final String equipmentId;

  const EquipmentDetailScreen({Key? key, required this.equipmentId}) : super(key: key);

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  late Future<Equipment?> equipmentFuture;
  late Future<List<MaintenanceRequest>> maintenanceFuture;
  late Future<int> maintenanceCountFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    equipmentFuture = ApiService.fetchEquipmentById(widget.equipmentId);
    maintenanceFuture = ApiService.getEquipmentMaintenance(widget.equipmentId);
    maintenanceCountFuture = ApiService.getMaintenanceCount(widget.equipmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Details'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FutureBuilder<Equipment?>(
                    future: equipmentFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return EquipmentFormScreen(initialEquipment: snapshot.data);
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ).then((_) {
                setState(() => _loadData());
              });
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Mark as Scrap'),
                onTap: () => _showScrapDialog(context),
              ),
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: () => _deleteEquipment(context),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Equipment?>(
        future: equipmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Equipment not found'));
          }

          final equipment = snapshot.data!;

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
                        equipment.name,
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
                            'S/N: ${equipment.serialNumber}',
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
                              color: _getStatusColor(equipment.status).withOpacity(0.2),
                              border: Border.all(color: _getStatusColor(equipment.status)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              equipment.status,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(equipment.status),
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
                      _buildDetailSection('Basic Information', [
                        _buildDetailRow('Category', equipment.category),
                        _buildDetailRow('Department', equipment.department),
                        _buildDetailRow('Location', equipment.location),
                      ]),
                      const SizedBox(height: 24),
                      _buildDetailSection('Dates', [
                        _buildDetailRow(
                          'Purchase Date',
                          equipment.purchaseDate.toString().split(' ')[0],
                        ),
                        _buildDetailRow(
                          'Warranty Expiry',
                          equipment.warrantyExpiryDate?.toString().split(' ')[0] ??
                              'Not set',
                        ),
                      ]),
                      if (equipment.description != null) ...[
                        const SizedBox(height: 24),
                        _buildDetailSection('Description', [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(equipment.description!),
                          ),
                        ]),
                      ],
                    ],
                  ),
                ),

                // Smart Button - Maintenance Requests
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<int>(
                    future: maintenanceCountFuture,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Card(
                        color: Colors.amber.shade50,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) =>
                                  MaintenanceRequestsBottomSheet(equipment: equipment),
                            ).then((_) {
                              setState(() => _loadData());
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Maintenance Requests',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'View related maintenance work',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: count > 0 ? Colors.red : Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$count Open',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.orange;
      case 'Scrap':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showScrapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark as Scrap'),
        content: const Text(
          'Are you sure you want to mark this equipment as scrap? Related maintenance requests will also be marked as scrap.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.scrapEquipment(
                widget.equipmentId,
                reason: 'Equipment marked as scrap',
              );
              setState(() => _loadData());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Equipment marked as scrap')),
              );
            },
            child: const Text('Mark as Scrap', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteEquipment(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Equipment'),
        content: const Text('Are you sure you want to delete this equipment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.deleteEquipment(widget.equipmentId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Equipment deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class MaintenanceRequestsBottomSheet extends StatefulWidget {
  final Equipment equipment;

  const MaintenanceRequestsBottomSheet({Key? key, required this.equipment})
      : super(key: key);

  @override
  State<MaintenanceRequestsBottomSheet> createState() =>
      _MaintenanceRequestsBottomSheetState();
}

class _MaintenanceRequestsBottomSheetState extends State<MaintenanceRequestsBottomSheet> {
  late Future<List<MaintenanceRequest>> maintenanceFuture;

  @override
  void initState() {
    super.initState();
    maintenanceFuture = ApiService.getEquipmentMaintenance(widget.equipment.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maintenance for ${widget.equipment.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MaintenanceRequestFormScreen(equipment: widget.equipment),
                    ),
                  ).then((_) {
                    setState(() {
                      maintenanceFuture =
                          ApiService.getEquipmentMaintenance(widget.equipment.id!);
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<MaintenanceRequest>>(
              future: maintenanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No maintenance requests'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final request = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(request.subject),
                        subtitle: Text(
                          '${request.type} - ${request.status}',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(request.status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            request.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(request.status),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Repaired':
        return Colors.green;
      case 'On Hold':
        return Colors.grey;
      case 'Scrap':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
