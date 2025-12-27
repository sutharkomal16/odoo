// Maintenance Request Model for Flutter

class MaintenancePart {
  final String name;
  final int quantity;
  final double cost;

  MaintenancePart({
    required this.name,
    required this.quantity,
    required this.cost,
  });

  factory MaintenancePart.fromJson(Map<String, dynamic> json) {
    return MaintenancePart(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      cost: (json['cost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'cost': cost,
    };
  }
}

class MaintenanceAttachment {
  final String url;
  final String fileName;
  final DateTime uploadedAt;

  MaintenanceAttachment({
    required this.url,
    required this.fileName,
    required this.uploadedAt,
  });

  factory MaintenanceAttachment.fromJson(Map<String, dynamic> json) {
    return MaintenanceAttachment(
      url: json['url'] ?? '',
      fileName: json['fileName'] ?? '',
      uploadedAt: json['uploadedAt'] != null ? DateTime.parse(json['uploadedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'fileName': fileName,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

class MaintenanceRequest {
  final String? id;
  final String requestNumber;
  final String type; // Corrective, Preventive
  final String subject;
  final String? description;
  final String? equipmentId;
  final String? equipmentName;
  final String? equipmentCategory;
  final String? maintenanceTeamId;
  final String? maintenanceTeamName;
  final String? createdById;
  final String? createdByName;
  final String? assignedToId;
  final String? assignedToName;
  final String status; // New, In Progress, Repaired, Scrap, On Hold
  final String priority; // Low, Medium, High, Critical
  final DateTime? scheduledDate;
  final DateTime? startDate;
  final DateTime? completionDate;
  final double duration; // Hours spent
  final double estimatedDuration;
  final double cost;
  final List<MaintenancePart> parts;
  final String? notes;
  final bool isOverdue;
  final List<MaintenanceAttachment> attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MaintenanceRequest({
    this.id,
    required this.requestNumber,
    required this.type,
    required this.subject,
    this.description,
    this.equipmentId,
    this.equipmentName,
    this.equipmentCategory,
    this.maintenanceTeamId,
    this.maintenanceTeamName,
    this.createdById,
    this.createdByName,
    this.assignedToId,
    this.assignedToName,
    this.status = 'New',
    this.priority = 'Medium',
    this.scheduledDate,
    this.startDate,
    this.completionDate,
    this.duration = 0.0,
    this.estimatedDuration = 0.0,
    this.cost = 0.0,
    this.parts = const [],
    this.notes,
    this.isOverdue = false,
    this.attachments = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    List<MaintenancePart> parts = [];
    if (json['parts'] != null) {
      parts = (json['parts'] as List).map((p) => MaintenancePart.fromJson(p)).toList();
    }

    List<MaintenanceAttachment> attachments = [];
    if (json['attachments'] != null) {
      attachments = (json['attachments'] as List)
          .map((a) => MaintenanceAttachment.fromJson(a))
          .toList();
    }

    return MaintenanceRequest(
      id: json['_id'] ?? json['id'],
      requestNumber: json['requestNumber'] ?? '',
      type: json['type'] ?? 'Corrective',
      subject: json['subject'] ?? '',
      description: json['description'],
      equipmentId: json['equipment']?['_id'] ?? json['equipment'],
      equipmentName: json['equipment']?['name'],
      equipmentCategory: json['equipmentCategory'],
      maintenanceTeamId: json['maintenanceTeam']?['_id'] ?? json['maintenanceTeam'],
      maintenanceTeamName: json['maintenanceTeam']?['name'],
      createdById: json['createdBy']?['_id'] ?? json['createdBy'],
      createdByName: json['createdBy']?['name'],
      assignedToId: json['assignedTo']?['_id'] ?? json['assignedTo'],
      assignedToName: json['assignedTo']?['name'],
      status: json['status'] ?? 'New',
      priority: json['priority'] ?? 'Medium',
      scheduledDate: json['scheduledDate'] != null ? DateTime.parse(json['scheduledDate']) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      completionDate:
          json['completionDate'] != null ? DateTime.parse(json['completionDate']) : null,
      duration: (json['duration'] ?? 0).toDouble(),
      estimatedDuration: (json['estimatedDuration'] ?? 0).toDouble(),
      cost: (json['cost'] ?? 0).toDouble(),
      parts: parts,
      notes: json['notes'],
      isOverdue: json['isOverdue'] ?? false,
      attachments: attachments,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requestNumber': requestNumber,
      'type': type,
      'subject': subject,
      'description': description,
      'equipment': equipmentId,
      'equipmentCategory': equipmentCategory,
      'maintenanceTeam': maintenanceTeamId,
      'createdBy': createdById,
      'assignedTo': assignedToId,
      'status': status,
      'priority': priority,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'duration': duration,
      'estimatedDuration': estimatedDuration,
      'cost': cost,
      'parts': parts.map((p) => p.toJson()).toList(),
      'notes': notes,
      'isOverdue': isOverdue,
      'attachments': attachments.map((a) => a.toJson()).toList(),
    };
  }

  MaintenanceRequest copyWith({
    String? id,
    String? requestNumber,
    String? type,
    String? subject,
    String? description,
    String? equipmentId,
    String? equipmentName,
    String? equipmentCategory,
    String? maintenanceTeamId,
    String? maintenanceTeamName,
    String? createdById,
    String? createdByName,
    String? assignedToId,
    String? assignedToName,
    String? status,
    String? priority,
    DateTime? scheduledDate,
    DateTime? startDate,
    DateTime? completionDate,
    double? duration,
    double? estimatedDuration,
    double? cost,
    List<MaintenancePart>? parts,
    String? notes,
    bool? isOverdue,
    List<MaintenanceAttachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaintenanceRequest(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      equipmentId: equipmentId ?? this.equipmentId,
      equipmentName: equipmentName ?? this.equipmentName,
      equipmentCategory: equipmentCategory ?? this.equipmentCategory,
      maintenanceTeamId: maintenanceTeamId ?? this.maintenanceTeamId,
      maintenanceTeamName: maintenanceTeamName ?? this.maintenanceTeamName,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      duration: duration ?? this.duration,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      cost: cost ?? this.cost,
      parts: parts ?? this.parts,
      notes: notes ?? this.notes,
      isOverdue: isOverdue ?? this.isOverdue,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
