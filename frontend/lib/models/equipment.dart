// Equipment Model for Flutter

class Equipment {
  final String? id;
  final String name;
  final String serialNumber;
  final String category;
  final String department;
  final String? assignedEmployeeId;
  final String? maintenanceTeamId;
  final String? assignedTechnicianId;
  final DateTime purchaseDate;
  final DateTime? warrantyExpiryDate;
  final String location;
  final String? description;
  final String status; // Active, Inactive, Scrap
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Equipment({
    this.id,
    required this.name,
    required this.serialNumber,
    required this.category,
    required this.department,
    this.assignedEmployeeId,
    this.maintenanceTeamId,
    this.assignedTechnicianId,
    required this.purchaseDate,
    this.warrantyExpiryDate,
    required this.location,
    this.description,
    this.status = 'Active',
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      category: json['category'] ?? '',
      department: json['department'] ?? '',
      assignedEmployeeId: json['assignedEmployee']?['_id'] ?? json['assignedEmployee'],
      maintenanceTeamId: json['maintenanceTeam']?['_id'] ?? json['maintenanceTeam'],
      assignedTechnicianId: json['assignedTechnician']?['_id'] ?? json['assignedTechnician'],
      purchaseDate: DateTime.parse(json['purchaseDate'] ?? DateTime.now().toIso8601String()),
      warrantyExpiryDate: json['warrantyExpiryDate'] != null
          ? DateTime.parse(json['warrantyExpiryDate'])
          : null,
      location: json['location'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'Active',
      notes: json['notes'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'serialNumber': serialNumber,
      'category': category,
      'department': department,
      'assignedEmployee': assignedEmployeeId,
      'maintenanceTeam': maintenanceTeamId,
      'assignedTechnician': assignedTechnicianId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'warrantyExpiryDate': warrantyExpiryDate?.toIso8601String(),
      'location': location,
      'description': description,
      'status': status,
      'notes': notes,
    };
  }

  Equipment copyWith({
    String? id,
    String? name,
    String? serialNumber,
    String? category,
    String? department,
    String? assignedEmployeeId,
    String? maintenanceTeamId,
    String? assignedTechnicianId,
    DateTime? purchaseDate,
    DateTime? warrantyExpiryDate,
    String? location,
    String? description,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      serialNumber: serialNumber ?? this.serialNumber,
      category: category ?? this.category,
      department: department ?? this.department,
      assignedEmployeeId: assignedEmployeeId ?? this.assignedEmployeeId,
      maintenanceTeamId: maintenanceTeamId ?? this.maintenanceTeamId,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyExpiryDate: warrantyExpiryDate ?? this.warrantyExpiryDate,
      location: location ?? this.location,
      description: description ?? this.description,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
