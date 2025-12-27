# Gear Guard API Integration Guide

## Base URL
```
http://10.0.2.2:5000  (for Android emulator)
http://localhost:5000  (for local development)
```

## Authentication
Currently using basic request structure. Add authentication headers as needed:
```dart
headers: {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token"  // If needed
}
```

## Response Format

All successful responses follow this format:
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Success message"
}
```

Error responses:
```json
{
  "success": false,
  "message": "Error description"
}
```

## Equipment API

### Create Equipment
```
POST /equipment
Content-Type: application/json

{
  "name": "CNC Machine 01",
  "serialNumber": "CNC-2024-001",
  "category": "Machinery",
  "department": "Production",
  "maintenanceTeam": "team_id",
  "purchaseDate": "2024-01-15",
  "warrantyExpiryDate": "2025-01-15",
  "location": "Building A, Floor 2"
}
```

### List Equipment
```
GET /equipment?department=Production&category=Machinery&status=Active
```

Query Parameters:
- `department`: Production, IT, HR, Finance, Operations, Other
- `category`: Machinery, Vehicle, Computer, Electrical, Other
- `status`: Active, Inactive, Scrap

### Get Equipment Details
```
GET /equipment/:id
```

### Update Equipment
```
PUT /equipment/:id
Content-Type: application/json

{ /* Updated fields */ }
```

### Get Equipment Maintenance History
```
GET /equipment/:id/maintenance
```

Returns all non-scrap maintenance requests for this equipment.

### Get Open Maintenance Count (for Smart Button)
```
GET /equipment/:id/maintenance-count
```

Response:
```json
{
  "success": true,
  "count": 3
}
```

### Mark Equipment as Scrap
```
PATCH /equipment/:id/scrap
Content-Type: application/json

{
  "reason": "Equipment beyond repair"
}
```

## Maintenance Team API

### Create Team
```
POST /teams
Content-Type: application/json

{
  "name": "Mechanics",
  "description": "Mechanical equipment maintenance",
  "members": [
    {
      "userId": "user_id",
      "role": "Manager"
    }
  ],
  "defaultTechnician": "user_id"
}
```

### List Teams
```
GET /teams
```

Returns all active teams with member information.

### Get Team Details
```
GET /teams/:id
```

### Update Team
```
PUT /teams/:id
```

### Add Team Member
```
POST /teams/:id/members
Content-Type: application/json

{
  "userId": "user_id",
  "role": "Technician"  // Manager, Technician, Lead
}
```

### Remove Team Member
```
DELETE /teams/:id/members
Content-Type: application/json

{
  "memberId": "user_id"
}
```

## Maintenance Request API

### Create Request (with Auto-fill)
```
POST /requests
Content-Type: application/json

{
  "type": "Corrective",  // or "Preventive"
  "subject": "Leaking Oil",
  "description": "Machine is leaking oil from seal",
  "equipment": "equipment_id",
  "priority": "High",
  "estimatedDuration": 2,
  "scheduledDate": "2024-02-15"  // For preventive only
}
```

**Auto-fill happens automatically:**
- Equipment category → fetched from equipment
- Maintenance team → fetched from equipment's assigned team

### List Requests
```
GET /requests?status=New&type=Corrective&team=team_id&priority=High
```

Query Parameters:
- `status`: New, In Progress, Repaired, Scrap, On Hold
- `type`: Corrective, Preventive
- `equipment`: equipment_id
- `team`: team_id
- `priority`: Low, Medium, High, Critical

### Get Request Details
```
GET /requests/:id
```

### Update Request Status (Kanban)
```
PATCH /requests/:id/status
Content-Type: application/json

{
  "status": "In Progress",
  "assignedTo": "user_id",
  "duration": 1.5,
  "completionNotes": "Oil seal replaced"
}
```

### Assign Request to Technician
```
PATCH /requests/:id/assign
Content-Type: application/json

{
  "assignedTo": "user_id"
}
```

### Get Requests by Status (Kanban View)
```
GET /requests-kanban/all
```

Returns:
```json
{
  "success": true,
  "data": {
    "New": [ /* requests */ ],
    "In Progress": [ /* requests */ ],
    "Repaired": [ /* requests */ ],
    "On Hold": [ /* requests */ ]
  }
}
```

### Get Preventive Maintenance (Calendar)
```
GET /requests/type/preventive
```

Returns all preventive maintenance requests with scheduled dates.

### Get Requests by Date Range
```
GET /requests/dates/range?startDate=2024-02-01&endDate=2024-02-28
```

### Get Reports

#### By Team
```
GET /reports/by-team
```

Response:
```json
{
  "success": true,
  "data": [
    {
      "_id": "team_id",
      "count": 15,
      "openCount": 3,
      "teamInfo": {
        "name": "Mechanics"
      }
    }
  ]
}
```

#### By Category
```
GET /reports/by-category
```

Response:
```json
{
  "success": true,
  "data": [
    {
      "_id": "Machinery",
      "count": 10,
      "openCount": 2
    }
  ]
}
```

## Frontend Implementation Examples

### Fetch Equipment with Filters
```dart
final equipment = await ApiService.fetchAllEquipment(
  department: 'Production',
  category: 'Machinery',
  status: 'Active'
);
```

### Create Maintenance Request
```dart
final request = MaintenanceRequest(
  requestNumber: '',
  type: 'Corrective',
  subject: 'Leaking oil',
  equipment: equipment.id,
  // Other fields...
);

final created = await ApiService.createMaintenanceRequest(request);
```

### Update Request Status (Kanban)
```dart
await ApiService.updateRequestStatus(
  requestId,
  'In Progress',
  assignedTo: technicianId,
);
```

### Get Dashboard Data
```dart
final allRequests = await ApiService.fetchAllRequests();
final newCount = allRequests.where((r) => r.status == 'New').length;
final overdueCount = allRequests.where((r) => r.isOverdue).length;
```

## Error Handling

```dart
try {
  final equipment = await ApiService.createEquipment(newEquipment);
  if (equipment != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Equipment created successfully'))
    );
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e'))
  );
}
```

## Rate Limiting & Performance

- Implement caching for frequently accessed data
- Use pagination for large lists (add offset/limit parameters)
- Debounce search filters
- Consider local storage for offline support

## Testing Endpoints

Use Postman or curl:

```bash
# Get all equipment
curl http://localhost:5000/equipment

# Create request
curl -X POST http://localhost:5000/requests \
  -H "Content-Type: application/json" \
  -d '{
    "type": "Corrective",
    "subject": "Test",
    "equipment": "equipment_id",
    "priority": "High"
  }'

# Get requests by team
curl http://localhost:5000/reports/by-team
```

## Troubleshooting

### 404 Not Found
- Check endpoint path spelling
- Verify resource ID is valid
- Check HTTP method (GET, POST, etc.)

### 400 Bad Request
- Verify all required fields are present
- Check JSON syntax is valid
- Ensure field values match expected types/enums

### 500 Server Error
- Check server logs
- Verify MongoDB connection
- Check data validation rules

## Timestamps

All timestamps are ISO 8601 format:
```
2024-02-15T10:30:00.000Z
```

Parse in Flutter:
```dart
DateTime.parse(jsonString)
```

Convert to JSON:
```dart
dateTime.toIso8601String()
```

## Next Steps

1. Add authentication (JWT tokens)
2. Implement pagination
3. Add file upload for attachments
4. Setup real-time updates with WebSockets
5. Add advanced filtering and search
