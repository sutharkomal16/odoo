# User Management System Documentation

## Overview

The User Management System is a comprehensive role-based access control (RBAC) implementation integrated throughout the Gear Guard maintenance management platform. It provides fine-grained control over user permissions, roles, and team assignments.

## Frontend Screens

### 1. User Management Screen
**Location:** `lib/screens/user_management_screen.dart`

**Purpose:** View and manage all users in the system with filtering capabilities.

**Features:**
- List all users with their details (name, email, role, department, phone)
- Filter users by role using chip buttons (All, ADMIN, MECHANIC, ELECTRICIAN, IT_SUPPORT)
- View user status (Active/Inactive)
- Delete users with confirmation dialog
- Navigate to user detail screen for more information
- Floating action button to create new users

**Key Methods:**
- `_loadUsers()` - Fetch users from API
- `_buildRoleFilter()` - Create role filter chips
- `_buildUserCard()` - Display individual user card
- `_showDeleteConfirmation()` - Show delete confirmation dialog
- `_deleteUser()` - Delete user and refresh list

**Color Coding by Role:**
- ADMIN → Gold (#ffb74d)
- MECHANIC → Blue (#29b6f6)
- ELECTRICIAN → Amber (#ffc107)
- IT_SUPPORT → Green (#00e676)

### 2. User Detail Screen
**Location:** `lib/screens/user_detail_screen.dart`

**Purpose:** View detailed information about a specific user including permissions.

**Features:**
- Display user header with role badge and active status
- Show complete user information (email, department, phone, status)
- Display all user permissions in a checklist format
- Visual indication of granted vs. denied permissions
- Color-coded role information
- Edit button (for future implementation)
- Role-specific icon display

**Key Methods:**
- `_buildUserHeader()` - Display user header card
- `_buildUserInfo()` - Display user information section
- `_buildPermissionsList()` - Display user permissions
- `_buildSection()` - Build styled section containers
- `_getRoleColor()` - Get role-specific color
- `_getRoleDisplayName()` - Get display name for role
- `_getRoleIcon()` - Get icon for role

### 3. Create User Screen
**Location:** `lib/screens/create_user_screen.dart`

**Purpose:** Create new user accounts with role assignment.

**Features:**
- Form validation for all required fields
- Text input for name, email, and phone (optional)
- Dropdown selection for role
- Dropdown selection for department
- Role-specific permission description display
- Visual role options with color coding
- Loading state during submission
- Success/error feedback via SnackBar

**Form Fields:**
- Name (required, 2-50 characters)
- Email (required, valid email format)
- Phone (optional)
- Role (required, dropdown)
- Department (required, dropdown)

**Available Roles:**
- ADMIN (Administrator)
- MECHANIC
- ELECTRICIAN
- IT_SUPPORT

**Available Departments:**
- Production
- IT
- HR
- Finance
- Operations
- Other

### 4. Role Dashboard Screen
**Location:** `lib/screens/role_dashboard_screen.dart`

**Purpose:** View role-based statistics and permission overview.

**Features:**
- Display user count by role in grid format
- Show detailed role descriptions
- List all permissions for each role
- Color-coded role cards with icons
- Role hierarchy visualization
- Complete permission matrix

**Role Information Displayed:**
1. **ADMIN (Administrator)**
   - Full system access
   - Permissions: Create/Edit/Delete Equipment, Manage Users, View Reports, System Settings

2. **MECHANIC**
   - Mechanical equipment management
   - Permissions: View Equipment, Create Requests, Update Status, Record Hours

3. **ELECTRICIAN**
   - Electrical systems management
   - Permissions: View Equipment, Create Requests, Update Status, Record Logs

4. **IT_SUPPORT**
   - IT infrastructure management
   - Permissions: View IT Equipment, Create Tickets, Manage Resources, Monitor Infrastructure

## Backend API Endpoints

### User Endpoints

#### Create User
```
POST /users
Headers: Content-Type: application/json
Body: {
  "name": "string",
  "email": "string",
  "role": "ADMIN|MECHANIC|ELECTRICIAN|IT_SUPPORT",
  "department": "string",
  "phone": "string (optional)"
}
Response: 201 Created
{
  "success": true,
  "data": { User object },
  "message": "User created successfully"
}
```

#### Get All Users
```
GET /users?role=ROLE&department=DEPT&isActive=true
Response: 200 OK
[
  { User object },
  ...
]
```

#### Get User by ID
```
GET /users/:id
Response: 200 OK
{ User object with permissions }
```

#### Update User
```
PUT /users/:id
Headers: Content-Type: application/json
Body: {
  "name": "string (optional)",
  "email": "string (optional)",
  "role": "string (optional)",
  "department": "string (optional)",
  "phone": "string (optional)",
  "isActive": "boolean (optional)"
}
Response: 200 OK
{ Updated User object }
```

#### Delete User
```
DELETE /users/:id
Response: 200 OK or 204 No Content
```

#### Get User Permissions
```
GET /users/:id/permissions
Response: 200 OK
{
  "permissions": {
    "canCreateEquipment": boolean,
    "canEditEquipment": boolean,
    "canDeleteEquipment": boolean,
    "canCreateRequest": boolean,
    "canAssignRequest": boolean,
    "canViewReports": boolean,
    "canManageTeams": boolean,
    "canManageUsers": boolean
  }
}
```

#### Get Users by Role
```
GET /users/by-role/:role
Response: 200 OK
[
  { User object },
  ...
]
```

#### Get Role Statistics
```
GET /users/stats/roles
Response: 200 OK
{
  "ADMIN": { count: number, percentage: number },
  "MECHANIC": { count: number, percentage: number },
  "ELECTRICIAN": { count: number, percentage: number },
  "IT_SUPPORT": { count: number, percentage: number }
}
```

## API Service Methods (Frontend)

### Location: `lib/services/api_service.dart`

```dart
// Fetch all users with optional filtering
static Future<List<dynamic>> fetchAllUsers({
  String? role,
  String? department,
  bool? isActive,
}) async

// Fetch single user by ID
static Future<Map<String, dynamic>> getUserById(String userId) async

// Create a new user
static Future<Map<String, dynamic>> createUser({
  required String name,
  required String email,
  required String role,
  required String department,
  String? phone,
}) async

// Update user
static Future<Map<String, dynamic>> updateUser(
  String userId, {
  String? name,
  String? email,
  String? role,
  String? department,
  String? phone,
  bool? isActive,
}) async

// Delete user
static Future<bool> deleteUser(String userId) async

// Get user permissions
static Future<Map<String, dynamic>> getUserPermissions(String userId) async

// Get users by role
static Future<List<dynamic>> getUsersByRole(String role) async

// Get role statistics
static Future<Map<String, dynamic>> getRoleStats() async
```

## Database Schema

### User Model

```javascript
{
  _id: ObjectId,
  name: String (required),
  email: String (required, unique),
  role: String (ADMIN|MECHANIC|ELECTRICIAN|IT_SUPPORT),
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

## Permission Matrix

### ADMIN
- ✅ Create Equipment
- ✅ Edit Equipment
- ✅ Delete Equipment
- ✅ Create Maintenance Request
- ✅ Assign Request to Technician
- ✅ View Reports & Analytics
- ✅ Manage Teams
- ✅ Manage Users

### MECHANIC
- ✅ Create Equipment
- ✅ Edit Equipment
- ❌ Delete Equipment
- ✅ Create Maintenance Request
- ❌ Assign Request to Technician
- ✅ View Reports & Analytics
- ❌ Manage Teams
- ❌ Manage Users

### ELECTRICIAN
- ✅ Create Equipment
- ✅ Edit Equipment
- ❌ Delete Equipment
- ✅ Create Maintenance Request
- ❌ Assign Request to Technician
- ✅ View Reports & Analytics
- ❌ Manage Teams
- ❌ Manage Users

### IT_SUPPORT
- ✅ Create Equipment
- ✅ Edit Equipment
- ❌ Delete Equipment
- ✅ Create Maintenance Request
- ❌ Assign Request to Technician
- ✅ View Reports & Analytics
- ❌ Manage Teams
- ❌ Manage Users

## Theme Integration

All user management screens use the Premium Theme system:

**Colors Used:**
- Primary Background: #0a1628 (Deep Navy)
- Secondary Background: #051019 (Darker Navy)
- Text Primary: #e0e0e0 (Light Gray)
- Text Secondary: #9e9e9e (Medium Gray)
- Accent Gold: #ffb74d
- Status Success: #00e676 (Green)
- Status Danger: #ef5350 (Red)
- Status Warning: #ffc107 (Amber)
- Status Info: #29b6f6 (Blue)

**Text Styles:**
- Headers: FontWeight.w700, Size 16-22
- Body: FontWeight.w500, Size 13-14
- Labels: FontWeight.w600, Size 11-13

## Usage Examples

### Navigating to User Management
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const UserManagementScreen()),
);
```

### Creating a New User
```dart
await ApiService.createUser(
  name: 'John Doe',
  email: 'john@example.com',
  role: 'MECHANIC',
  department: 'Production',
  phone: '+1234567890',
);
```

### Fetching User Details
```dart
final user = await ApiService.getUserById(userId);
final permissions = await ApiService.getUserPermissions(userId);
```

### Filtering Users by Role
```dart
final mechanics = await ApiService.fetchAllUsers(role: 'MECHANIC');
```

### Deleting a User
```dart
await ApiService.deleteUser(userId);
```

## Error Handling

All screens implement comprehensive error handling:

1. **Network Errors:** Displayed via SnackBar with error message
2. **Validation Errors:** Form fields show validation messages
3. **API Errors:** Caught and displayed to user
4. **Loading States:** CircularProgressIndicator shown during data fetch

## Testing Checklist

- [ ] Create user with each role type
- [ ] Verify email uniqueness validation
- [ ] Test filtering by each role
- [ ] Verify permission display matches role
- [ ] Test user deletion confirmation dialog
- [ ] Verify color coding matches theme
- [ ] Test navigation between screens
- [ ] Verify API endpoints respond correctly
- [ ] Test with various department values
- [ ] Verify phone number optional functionality

## Future Enhancements

1. Edit user details screen
2. Bulk user import/export
3. User activity logs
4. Permission customization per user
5. Team assignment in user creation
6. Two-factor authentication
7. Password reset functionality
8. User search functionality
9. Advanced filtering options
10. User role change history
