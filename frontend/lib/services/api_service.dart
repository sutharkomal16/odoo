import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/equipment.dart';
import '../models/maintenance_team.dart';
import '../models/maintenance_request.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/api/maintenance";
  static const String usersEndpoint = "http://10.0.2.2:5000/users";
  static const String equipmentEndpoint = "$baseUrl/equipment";
  static const String teamsEndpoint = "$baseUrl/teams";
  static const String requestsEndpoint = "$baseUrl/requests";
  static const String reportsEndpoint = "$baseUrl/reports";

  // ==================== USER ENDPOINTS ====================
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(usersEndpoint));
    final List data = jsonDecode(response.body);
    return data.map((e) => User.fromJson(e)).toList();
  }

  static Future<void> addUser(String name, String email) async {
    await http.post(
      Uri.parse(usersEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email}),
    );
  }

  // Fetch all users with optional filtering
  static Future<List<dynamic>> fetchAllUsers({
    String? role,
    String? department,
    bool? isActive,
  }) async {
    Uri uri = Uri.parse('$usersEndpoint').replace(queryParameters: {
      if (role != null) 'role': role,
      if (department != null) 'department': department,
      if (isActive != null) 'isActive': isActive.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      }
    }
    return [];
  }

  // Fetch single user by ID
  static Future<Map<String, dynamic>> getUserById(String userId) async {
    final response = await http.get(Uri.parse('$usersEndpoint/$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return (data as Map).cast<String, dynamic>();
      }
    }
    throw Exception('Failed to fetch user');
  }

  // Create a new user
  static Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String role,
    required String department,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse(usersEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'email': email,
        'role': role,
        'department': department,
        if (phone != null) 'phone': phone,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return (data as Map).cast<String, dynamic>();
      }
    }
    throw Exception('Failed to create user');
  }

  // Update user
  static Future<Map<String, dynamic>> updateUser(
    String userId, {
    String? name,
    String? email,
    String? role,
    String? department,
    String? phone,
    bool? isActive,
  }) async {
    final response = await http.put(
      Uri.parse('$usersEndpoint/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (role != null) 'role': role,
        if (department != null) 'department': department,
        if (phone != null) 'phone': phone,
        if (isActive != null) 'isActive': isActive,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return (data as Map).cast<String, dynamic>();
      }
    }
    throw Exception('Failed to update user');
  }

  // Delete user
  static Future<bool> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$usersEndpoint/$userId'));
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // Get user permissions
  static Future<Map<String, dynamic>> getUserPermissions(String userId) async {
    final response = await http.get(Uri.parse('$usersEndpoint/$userId/permissions'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return (data as Map).cast<String, dynamic>();
      }
    }
    return {'permissions': {}};
  }

  // Get users by role
  static Future<List<dynamic>> getUsersByRole(String role) async {
    final response = await http.get(Uri.parse('$usersEndpoint/by-role/$role'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      }
    }
    return [];
  }

  // Get role statistics
  static Future<Map<String, dynamic>> getRoleStats() async {
    final response = await http.get(Uri.parse('$usersEndpoint/stats/roles'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return (data as Map).cast<String, dynamic>();
      }
    }
    return {};
  }

  // ==================== EQUIPMENT ENDPOINTS ====================
  static Future<List<Equipment>> fetchAllEquipment({
    String? department,
    String? category,
    String? status,
  }) async {
    Uri uri = Uri.parse(equipmentEndpoint).replace(queryParameters: {
      if (department != null) 'department': department,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => Equipment.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<Equipment?> fetchEquipmentById(String id) async {
    final response = await http.get(Uri.parse('$equipmentEndpoint/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return Equipment.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<Equipment?> createEquipment(Equipment equipment) async {
    final response = await http.post(
      Uri.parse(equipmentEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(equipment.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return Equipment.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<Equipment?> updateEquipment(String id, Equipment equipment) async {
    final response = await http.put(
      Uri.parse('$equipmentEndpoint/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(equipment.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return Equipment.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<bool> deleteEquipment(String id) async {
    final response = await http.delete(Uri.parse('$equipmentEndpoint/$id'));
    return response.statusCode == 200;
  }

  static Future<List<MaintenanceRequest>> getEquipmentMaintenance(String equipmentId) async {
    final response = await http.get(Uri.parse('$equipmentEndpoint/$equipmentId/maintenance'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => MaintenanceRequest.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<int> getMaintenanceCount(String equipmentId) async {
    final response = await http.get(Uri.parse('$equipmentEndpoint/$equipmentId/maintenance-count'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['count'] ?? 0;
      }
    }
    return 0;
  }

  static Future<bool> scrapEquipment(String id, {String? reason}) async {
    final response = await http.patch(
      Uri.parse('$equipmentEndpoint/$id/scrap'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'reason': reason}),
    );
    return response.statusCode == 200;
  }

  // ==================== MAINTENANCE TEAM ENDPOINTS ====================
  static Future<List<MaintenanceTeam>> fetchAllTeams() async {
    final response = await http.get(Uri.parse(teamsEndpoint));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => MaintenanceTeam.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<MaintenanceTeam?> fetchTeamById(String id) async {
    final response = await http.get(Uri.parse('$teamsEndpoint/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceTeam.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<MaintenanceTeam?> createTeam(MaintenanceTeam team) async {
    final response = await http.post(
      Uri.parse(teamsEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(team.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceTeam.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<MaintenanceTeam?> updateTeam(String id, MaintenanceTeam team) async {
    final response = await http.put(
      Uri.parse('$teamsEndpoint/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(team.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceTeam.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<bool> addTeamMember(String teamId, String userId, String role) async {
    final response = await http.post(
      Uri.parse('$teamsEndpoint/$teamId/members'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'userId': userId, 'role': role}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> removeTeamMember(String teamId, String userId) async {
    final response = await http.delete(
      Uri.parse('$teamsEndpoint/$teamId/members'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'memberId': userId}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteTeam(String id) async {
    final response = await http.delete(Uri.parse('$teamsEndpoint/$id'));
    return response.statusCode == 200;
  }

  // ==================== MAINTENANCE REQUEST ENDPOINTS ====================
  static Future<MaintenanceRequest?> createMaintenanceRequest(
      MaintenanceRequest request) async {
    final response = await http.post(
      Uri.parse(requestsEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceRequest.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<List<MaintenanceRequest>> fetchAllRequests({
    String? status,
    String? type,
    String? equipment,
    String? team,
    String? priority,
  }) async {
    Uri uri = Uri.parse(requestsEndpoint).replace(queryParameters: {
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (equipment != null) 'equipment': equipment,
      if (team != null) 'team': team,
      if (priority != null) 'priority': priority,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => MaintenanceRequest.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<MaintenanceRequest?> fetchRequestById(String id) async {
    final response = await http.get(Uri.parse('$requestsEndpoint/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceRequest.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<MaintenanceRequest?> updateRequestStatus(
    String id,
    String status, {
    String? assignedTo,
    double? duration,
    String? completionNotes,
  }) async {
    final response = await http.patch(
      Uri.parse('$requestsEndpoint/$id/status'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'status': status,
        if (assignedTo != null) 'assignedTo': assignedTo,
        if (duration != null) 'duration': duration,
        if (completionNotes != null) 'completionNotes': completionNotes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceRequest.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<MaintenanceRequest?> assignRequest(String id, String assignedTo) async {
    final response = await http.patch(
      Uri.parse('$requestsEndpoint/$id/assign'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'assignedTo': assignedTo}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return MaintenanceRequest.fromJson(data['data']);
      }
    }
    return null;
  }

  static Future<Map<String, List<MaintenanceRequest>>> getRequestsByStatus() async {
    final response = await http.get(Uri.parse('$requestsEndpoint-kanban/all'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Map<String, List<MaintenanceRequest>> grouped = {};
        final groupedData = data['data'];
        groupedData.forEach((key, value) {
          grouped[key] = (value as List).map((e) => MaintenanceRequest.fromJson(e)).toList();
        });
        return grouped;
      }
    }
    return {};
  }

  static Future<List<MaintenanceRequest>> getPreventiveRequests() async {
    final response = await http.get(Uri.parse('$requestsEndpoint/type/preventive'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => MaintenanceRequest.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<List<MaintenanceRequest>> getRequestsByDateRange(
      DateTime startDate, DateTime endDate) async {
    Uri uri = Uri.parse('$requestsEndpoint/dates/range').replace(queryParameters: {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => MaintenanceRequest.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<List<dynamic>> getRequestsByTeam() async {
    final response = await http.get(Uri.parse('$reportsEndpoint/by-team'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] ?? [];
      }
    }
    return [];
  }

  static Future<List<dynamic>> getRequestsByCategory() async {
    final response = await http.get(Uri.parse('$reportsEndpoint/by-category'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] ?? [];
      }
    }
    return [];
  }

  static Future<bool> deleteRequest(String id) async {
    final response = await http.delete(Uri.parse('$requestsEndpoint/$id'));
    return response.statusCode == 200;
  }
}
