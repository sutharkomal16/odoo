# Role-Based Access Control (RBAC) Documentation

## Overview
The Gear Guard system implements a comprehensive role-based access control system with four distinct user roles:
- **ADMIN** - Full system access
- **MECHANIC** - Mechanical equipment specialists
- **ELECTRICIAN** - Electrical systems specialists
- **IT_SUPPORT** - IT infrastructure specialists

---

## Roles & Permissions

### 1. ADMIN (Administrator)
**Description**: Full system administrator with unrestricted access

**Permissions**:
- ✅ Create Equipment
- ✅ Edit Equipment
- ✅ Delete Equipment
- ✅ Create Maintenance Requests
- ✅ Assign Requests to Technicians
- ✅ View Reports & Analytics
- ✅ Manage Teams
- ✅ Manage Users

**Use Cases**:
- System configuration
- User management
- Policy enforcement
- Report generation
- Emergency escalations

---

### 2. MECHANIC
**Description**: Mechanical equipment maintenance specialist

**Permissions**:
- ❌ Create Equipment
- ✅ Edit Equipment
- ❌ Delete Equipment
- ✅ Create Maintenance Requests
- ❌ Assign Requests
- ✅ View Reports
- ❌ Manage Teams
- ❌ Manage Users

**Use Cases**:
- Perform mechanical maintenance
- Record maintenance work
- Request equipment modifications
- View historical maintenance records
- Generate maintenance reports

**Can Work On**:
- CNC Machines
- Hydraulic Systems
- Conveyor Systems
- Pumps
- Compressors
- General Machinery

---

### 3. ELECTRICIAN
**Description**: Electrical systems maintenance specialist

**Permissions**:
- ❌ Create Equipment
- ✅ Edit Equipment
- ❌ Delete Equipment
- ✅ Create Maintenance Requests
- ❌ Assign Requests
- ✅ View Reports
- ❌ Manage Teams
- ❌ Manage Users

**Use Cases**:
- Perform electrical system maintenance
- Electrical safety inspections
- Power system troubleshooting
- Record electrical work
- Maintain electrical documentation

**Can Work On**:
- Electrical Panel Systems
- Backup Generators
- Motor Systems
- Control Systems
- Lighting Systems
- Server Room Infrastructure

---

### 4. IT_SUPPORT
**Description**: IT infrastructure and systems support specialist

**Permissions**:
- ❌ Create Equipment
- ✅ Edit Equipment
- ❌ Delete Equipment
- ✅ Create Maintenance Requests
- ❌ Assign Requests
- ✅ View Reports
- ❌ Manage Teams
- ❌ Manage Users

**Use Cases**:
- IT hardware maintenance
- Server updates and patches
- Network infrastructure maintenance
- System security updates
- IT asset tracking

**Can Work On**:
- Servers
- Workstations
- Laptops
- Network Equipment
- Storage Systems
- Security Systems

---

## Permission Matrix

| Operation | ADMIN | MECHANIC | ELECTRICIAN | IT_SUPPORT |
|-----------|-------|----------|-------------|-----------|
| Create Equipment | ✅ | ❌ | ❌ | ❌ |
| Edit Equipment | ✅ | ✅ | ✅ | ✅ |
| Delete Equipment | ✅ | ❌ | ❌ | ❌ |
| Create Request | ✅ | ✅ | ✅ | ✅ |
| Assign Request | ✅ | ❌ | ❌ | ❌ |
| View Reports | ✅ | ✅ | ✅ | ✅ |
| Manage Teams | ✅ | ❌ | ❌ | ❌ |
| Manage Users | ✅ | ❌ | ❌ | ❌ |

---

## User Model Structure

```javascript
{
  _id: ObjectId,
  name: String,
  email: String (unique),
  role: String (ADMIN | MECHANIC | ELECTRICIAN | IT_SUPPORT),
  department: String,
  phone: String,
  isActive: Boolean (default: true),
  permissions: {
    canCreateEquipment: Boolean,
    canEditEquipment: Boolean,
    canDeleteEquipment: Boolean,
    canCreateRequest: Boolean,
    canAssignRequest: Boolean,
    canViewReports: Boolean,
    canManageTeams: Boolean,
    canManageUsers: Boolean
  },
  createdAt: Date,
  updatedAt: Date
}
```

---

## API Endpoints

### User Management

#### Create User
```http
POST /users
Content-Type: application/json

{
  "name": "John Mechanic",
  "email": "john@example.com",
  "role": "MECHANIC",
  "department": "Production",
  "phone": "+1-555-0101"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "_id": "...",
    "name": "John Mechanic",
    "email": "john@example.com",
    "role": "MECHANIC",
    "department": "Production",
    "permissions": { ... }
  }
}
```

---

#### Get All Users
```http
GET /users?role=MECHANIC&department=Production&isActive=true
```

---

#### Get User by ID
```http
GET /users/:id
```

---

#### Get Users by Role
```http
GET /users/by-role/MECHANIC
```

Returns all active users with MECHANIC role

---

#### Get User Permissions
```http
GET /users/:id/permissions
```

Returns user's role and permission details:
```json
{
  "success": true,
  "userId": "...",
  "role": "MECHANIC",
  "roleDisplayName": "Mechanic",
  "permissions": {
    "canCreateEquipment": false,
    "canEditEquipment": true,
    "canDeleteEquipment": false,
    "canCreateRequest": true,
    "canAssignRequest": false,
    "canViewReports": true,
    "canManageTeams": false,
    "canManageUsers": false
  }
}
```

---

#### Update User
```http
PUT /users/:id
Content-Type: application/json

{
  "name": "John Mechanic Updated",
  "role": "MECHANIC",
  "department": "Production",
  "isActive": true
}
```

---

#### Delete User
```http
DELETE /users/:id
```

---

#### Get Role Statistics
```http
GET /users/stats/roles
```

Returns user count by role:
```json
{
  "success": true,
  "data": [
    {
      "_id": "ADMIN",
      "count": 1,
      "active": 1
    },
    {
      "_id": "MECHANIC",
      "count": 3,
      "active": 3
    },
    {
      "_id": "ELECTRICIAN",
      "count": 2,
      "active": 2
    },
    {
      "_id": "IT_SUPPORT",
      "count": 1,
      "active": 1
    }
  ]
}
```

---

## Dummy Data (Default Seed)

### Users Created:
1. **Jane Smith** - ADMIN (Operations)
2. **John Doe** - MECHANIC (Production)
3. **Sarah Williams** - ELECTRICIAN (Production)
4. **Mike Johnson** - IT_SUPPORT (IT)
5. **Tom Brown** - MECHANIC (Finance)

### Teams Created:
1. **Mechanics Team** - Led by John Doe
   - Members: John Doe, Tom Brown
2. **Electricians Team** - Led by Sarah Williams
   - Members: Sarah Williams
3. **IT Support Team** - Led by Mike Johnson
   - Members: Mike Johnson

---

## Implementation in Middleware

```javascript
// Example: Check if user is ADMIN
const adminOnly = authorize(['ADMIN']);

// Example: Check specific permission
const canCreateEquipment = checkPermission('canCreateEquipment');

// Example: Multiple roles
const technicianOnly = authorize(['MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT']);
```

---

## Best Practices

1. **Always validate role on server-side**
   - Never trust client-side role information
   - Verify permissions before executing sensitive operations

2. **Use least privilege principle**
   - Grant minimum permissions needed for job
   - Review permissions regularly

3. **Log role-based actions**
   - Track who created/modified/deleted resources
   - Maintain audit trail for compliance

4. **Handle permission errors gracefully**
   - Return 403 Forbidden with clear message
   - Don't expose system details

5. **Regular audits**
   - Review user role assignments
   - Check for orphaned accounts
   - Verify team memberships

---

## Frontend Integration

### Example: Show UI based on Role

```dart
if (user.hasPermission('canCreateEquipment')) {
  // Show create button
}

if (user.role == 'ADMIN') {
  // Show admin panel
}
```

### Example: API Call with Role Check

```dart
Future<bool> canCreateEquipment() async {
  final response = await http.get(
    Uri.parse('/users/$userId/permissions')
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['permissions']['canCreateEquipment'];
  }
  return false;
}
```

---

## Security Considerations

1. **Never expose permissions to client**
   - Always verify server-side
   - Use HTTP 403 for denied access

2. **Implement rate limiting**
   - Prevent brute force attacks
   - Protect against enumeration

3. **Use HTTPS**
   - Encrypt all role information in transit
   - Protect sensitive user data

4. **Regular security reviews**
   - Audit role assignments
   - Review access logs
   - Update policies as needed

---

## Troubleshooting

### User Created But Can't Access Resource
- Check user role and permissions
- Verify user is active (`isActive: true`)
- Check resource requirements match user permissions

### Permission Denied When Should Be Allowed
- Verify role is correctly set
- Check server-side permission logic
- Review team memberships if applicable

### New Role Added But Not Working
- Restart backend server
- Clear frontend cache
- Verify middleware is updated

---

For more information, see the main SETUP_GUIDE.md and API_GUIDE.md files.
