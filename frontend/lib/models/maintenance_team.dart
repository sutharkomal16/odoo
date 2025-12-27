// Maintenance Team Model for Flutter

class TeamMember {
  final String userId;
  final String? userName;
  final String role; // Manager, Technician, Lead
  final DateTime joinedDate;

  TeamMember({
    required this.userId,
    this.userName,
    required this.role,
    required this.joinedDate,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      userId: json['userId']?['_id'] ?? json['userId'] ?? '',
      userName: json['userId']?['name'] ?? json['userName'],
      role: json['role'] ?? 'Technician',
      joinedDate: json['joinedDate'] != null ? DateTime.parse(json['joinedDate']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'role': role,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}

class MaintenanceTeam {
  final String? id;
  final String name;
  final String? description;
  final List<TeamMember> members;
  final String? defaultTechnicianId;
  final String? defaultTechnicianName;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MaintenanceTeam({
    this.id,
    required this.name,
    this.description,
    this.members = const [],
    this.defaultTechnicianId,
    this.defaultTechnicianName,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceTeam.fromJson(Map<String, dynamic> json) {
    List<TeamMember> members = [];
    if (json['members'] != null) {
      members = (json['members'] as List).map((m) => TeamMember.fromJson(m)).toList();
    }

    return MaintenanceTeam(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      members: members,
      defaultTechnicianId:
          json['defaultTechnician']?['_id'] ?? json['defaultTechnician'],
      defaultTechnicianName: json['defaultTechnician']?['name'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'members': members.map((m) => m.toJson()).toList(),
      'defaultTechnician': defaultTechnicianId,
      'isActive': isActive,
    };
  }

  MaintenanceTeam copyWith({
    String? id,
    String? name,
    String? description,
    List<TeamMember>? members,
    String? defaultTechnicianId,
    String? defaultTechnicianName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaintenanceTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      defaultTechnicianId: defaultTechnicianId ?? this.defaultTechnicianId,
      defaultTechnicianName: defaultTechnicianName ?? this.defaultTechnicianName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
