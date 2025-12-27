# Dummy Data Setup - Gear Guard Application

## Overview

The Gear Guard maintenance management application is now fully populated with realistic mock data for testing and demonstration purposes. All backend endpoints are configured to serve mock data without requiring a MongoDB connection.

## ✅ What's Configured

### Mock Data Collections

#### 1. **Users (4 Records)**
- **Admin User**: Jane Smith
  - Email: jane@example.com
  - Role: ADMIN
  - Department: Operations
  - Permissions: All 8 permissions enabled
  
- **Mechanic**: John Doe
  - Email: john@example.com
  - Role: MECHANIC
  - Department: Production
  - Permissions: Create/Edit Equipment, Create Requests, View Reports (5/8)
  
- **Electrician**: Sarah Williams
  - Email: sarah@example.com
  - Role: ELECTRICIAN
  - Department: Electrical
  - Permissions: Same as Mechanic (5/8)
  
- **IT Support**: Mike Johnson
  - Email: mike@example.com
  - Role: IT_SUPPORT
  - Department: IT
  - Permissions: Same as Mechanic (5/8)

#### 2. **Equipment (6 Records)**
- CNC Machine A (Production - Machinery)
- Hydraulic Press B (Production - Machinery)
- Air Compressor C (Production - Utilities)
- Conveyor Belt System (Production - Machinery)
- Electrical Panel E (Electrical - Electrical)
- Server Cooling Unit (IT - IT)

All equipment items include:
- Serial numbers
- Installation dates
- Last maintenance date
- Next maintenance date
- Maintenance frequency (30-45 days)

#### 3. **Maintenance Teams (3 Records)**
- **Mechanics Team** - Led by John Doe (Floor 1)
  - Members: John Doe, [Additional technician]
  - Specialization: MECHANIC
  
- **Electricians Team** - Led by Sarah Williams (Floor 2)
  - Members: Sarah Williams
  - Specialization: ELECTRICIAN
  
- **IT Support Team** - Led by Mike Johnson (IT Department)
  - Members: Mike Johnson
  - Specialization: IT_SUPPORT

#### 4. **Maintenance Requests (6 Records)**
- CNC Machine Regular Maintenance (Preventive, Completed, Medium)
- Hydraulic Press Seal Replacement (Corrective, In Progress, High)
- Electrical Panel Inspection (Preventive, New, Medium)
- Server Cooling Unit Fan Replacement (Preventive, In Progress, High)
- Air Compressor Oil Change (Preventive, New, Low)
- Conveyor Belt Alignment (Corrective, Completed, High)

Status distribution: 2 Completed, 2 In Progress, 2 New

## 📡 API Endpoints

All endpoints return data in the following format:
```json
{
  "success": true,
  "data": [...]
}
```

### Equipment Endpoints
- `GET /api/maintenance/equipment` - Get all equipment
- `GET /api/maintenance/equipment/:id` - Get equipment by ID
- `POST /api/maintenance/equipment` - Create new equipment
- `PUT /api/maintenance/equipment/:id` - Update equipment
- `DELETE /api/maintenance/equipment/:id` - Delete equipment
- `GET /api/maintenance/equipment/:id/maintenance` - Get maintenance requests for equipment
- `GET /api/maintenance/equipment/:id/maintenance-count` - Get open maintenance count

### Team Endpoints
- `GET /api/maintenance/teams` - Get all teams
- `GET /api/maintenance/teams/:id` - Get team by ID
- `POST /api/maintenance/teams` - Create new team
- `PUT /api/maintenance/teams/:id` - Update team
- `DELETE /api/maintenance/teams/:id` - Delete team

### Request Endpoints
- `GET /api/maintenance/requests` - Get all requests (with filters)
- `GET /api/maintenance/requests/:id` - Get request by ID
- `POST /api/maintenance/requests` - Create new request
- `PATCH /api/maintenance/requests/:id/status` - Update request status
- `DELETE /api/maintenance/requests/:id` - Delete request

### User Endpoints
- `GET /users` - Get all users
- `GET /users/:id` - Get user by ID
- `POST /users` - Create new user
- `PATCH /users/:id` - Update user
- `DELETE /users/:id` - Delete user
- `GET /users/:id/permissions` - Get user permissions

## 🔐 Test Login Credentials

Use any of these credentials to log into the app:

| Username | Password | Role | Department |
|----------|----------|------|------------|
| admin | admin | ADMIN | Operations |
| MECHANIC | MECHANIC | MECHANIC | Production |
| ELECTRICIAN | ELECTRICIAN | ELECTRICIAN | Electrical |
| IT_SUPPORT | IT_SUPPORT | IT_SUPPORT | IT |

## 🎨 UI Features with Mock Data

### Home Screen
- User welcome display with role badge
- Dashboard grid with:
  - Equipment overview
  - Maintenance requests summary
  - Teams status
  - Quick action cards

### Equipment List Screen
- Shows all 6 equipment items
- Color-coded by department
- Maintenance status indicators
- Clickable for detailed view

### Maintenance Requests Screen
- Filter by status (New, In Progress, Completed)
- Filter by priority (Low, Medium, High)
- Kanban view for drag-and-drop
- Real-time status updates

### Teams Screen
- All 3 teams displayed
- Member count per team
- Team leader information
- Specialization badges

### User Management
- User list with role filtering
- Permission matrix display
- Role-based access control
- User creation/editing

### Reports
- Requests by status (pie chart)
- Requests by priority (bar chart)
- Team workload distribution
- Equipment maintenance status

### Calendar View
- Preventive maintenance schedule
- Next maintenance dates
- Request status timeline

### Kanban Board
- Drag-and-drop requests between columns:
  - New → In Progress → Completed
- Real-time status updates
- Team assignment management

## 📋 Data Files

- **Mock Data Definition**: `backend/src/data/mock-data.js`
- **Mock Data Controller**: `backend/src/controllers/mock-data.controller.js`
- **Maintenance Routes**: `backend/src/routes/maintenance.routes.js`
- **User Routes**: `backend/src/routes/user.routes.js`

## 🚀 Getting Started

### Backend
```bash
cd backend
node src/server.js
# Server runs on http://localhost:5000
```

### Frontend
```bash
cd frontend
flutter run -d web
# App runs on http://localhost:50000 (or available port)
```

### Testing the Data

1. **Login** with any test credential (e.g., admin/admin)
2. **Navigate** to different screens to see data populated
3. **Test CRUD Operations**:
   - Create a new equipment item
   - Create a maintenance request
   - Update request status via Kanban board
   - Delete users

## 📊 Mock Data Characteristics

### Response Format
All endpoints return:
```json
{
  "success": true,
  "data": [...data array or object...],
  "message": "Optional message"
}
```

### Status Codes
- `200` - Successful GET/UPDATE/DELETE
- `201` - Successful POST (creation)
- `404` - Resource not found
- `400` - Bad request

### Time Data
- Installation dates range from 2019-2024
- Last maintenance dates are recent (December 2024)
- Next maintenance dates are future-dated (January 2025)

## 🎯 Use Cases Covered

### Administrator (Admin Role)
- ✅ View and manage all equipment
- ✅ Manage all users and roles
- ✅ Assign maintenance requests to teams
- ✅ Generate comprehensive reports
- ✅ Manage maintenance teams

### Technicians (Mechanic/Electrician/IT Support)
- ✅ View assigned equipment
- ✅ Create maintenance requests
- ✅ Update request status
- ✅ View team performance
- ✅ Track maintenance history

## 🔄 Data Persistence

**Important**: Mock data is stored in memory and will reset when the server restarts.

To populate the database with mock data on server startup, the application:
1. Loads mock data from `mock-data.js` on initialization
2. Makes it available via API endpoints
3. Allows CRUD operations on the in-memory data
4. Logs all changes during the session

## 📝 Notes

- All ID values are string-based for consistency
- Dates are in ISO format (YYYY-MM-DD)
- Permission objects are structured with boolean flags for each permission
- Mock data includes realistic values for all fields
- Equipment maintenance frequencies vary (30-45 days)
- Request priorities include Low, Medium, High
- Request types include Preventive and Corrective

## ✨ Next Steps

1. Test all screens with the provided mock data
2. Create additional test users via the UI
3. Create maintenance requests for equipment
4. Test the Kanban board drag-and-drop
5. Generate reports from the data
6. Verify role-based access control
7. Test calendar and schedule views

---

**Status**: ✅ Complete - All 16+ mock data records configured and accessible via API
**Last Updated**: December 2024
