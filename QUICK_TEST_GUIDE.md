# Quick Testing Guide - Gear Guard App

## 🚀 Quick Start

### 1. Backend Status
- ✅ Running on `http://localhost:5000`
- ✅ Mock data endpoints active
- ✅ All 4 data collections populated

### 2. Login to App
The app will show a login screen first. Use any of these credentials:

```
Username: admin          → Password: admin          (Admin role - all permissions)
Username: MECHANIC       → Password: MECHANIC       (Mechanic - limited permissions)
Username: ELECTRICIAN    → Password: ELECTRICIAN    (Electrician - limited permissions)
Username: IT_SUPPORT     → Password: IT_SUPPORT     (IT Support - limited permissions)
```

### 3. Verify Mock Data is Loading

After login, you should see:

**Home Screen:**
- User name and role displayed in header
- Dashboard with statistics
- Equipment overview (6 items visible)
- Recent requests (6 items in various statuses)

**Equipment Screen:**
- List of 6 equipment items with details
- Filters by department/category/status
- Maintenance status for each item

**Requests Screen:**
- 6 maintenance requests total:
  - 2 Completed (CNC Maintenance, Conveyor Belt Alignment)
  - 2 In Progress (Hydraulic Press, Server Cooling)
  - 2 New (Electrical Panel, Air Compressor)
- Kanban view showing 3 columns (New, In Progress, Completed)
- Priority indicators (Low, Medium, High)

**Teams Screen:**
- 3 maintenance teams:
  - Mechanics Team (Production focused)
  - Electricians Team (Electrical systems)
  - IT Support Team (IT infrastructure)
- Team members and leaders listed

**User Management Screen:**
- 4 users with different roles
- Filter buttons for each role
- Permission matrix for each user
- Delete and create options

### 4. Test CRUD Operations

#### Create Equipment
1. Go to Equipment screen
2. Tap "+" button (FAB)
3. Fill in: Name, Serial Number, Category, Department
4. Submit → New item appears in list

#### Create Maintenance Request
1. Go to Requests screen
2. Tap "+" button
3. Select equipment, type, priority
4. Submit → New request appears as "New" status

#### Update Request Status
1. Go to Requests → Kanban view
2. Drag request from "New" → "In Progress" → "Completed"
3. Status updates in real-time

#### Delete Equipment/Request
1. Select item from list
2. Long-press or tap delete icon
3. Confirm deletion
4. Item removed from list

### 5. Verify API Responses

Test endpoints directly using curl or your browser:

```bash
# Get all equipment
curl http://localhost:5000/api/maintenance/equipment

# Get all requests
curl http://localhost:5000/api/maintenance/requests

# Get all teams
curl http://localhost:5000/api/maintenance/teams

# Get all users
curl http://localhost:5000/users
```

All should return:
```json
{
  "success": true,
  "data": [...]
}
```

### 6. Expected Response Examples

**Equipment List Response:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "1",
      "name": "CNC Machine A",
      "serialNumber": "CNC-001",
      "category": "Machinery",
      "department": "Production",
      "status": "Active",
      "nextMaintenance": "2025-01-15",
      ...
    }
  ]
}
```

**Requests Response:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "1",
      "title": "CNC Machine Regular Maintenance",
      "type": "Preventive",
      "equipment": "CNC Machine A",
      "status": "Completed",
      "priority": "Medium",
      ...
    }
  ]
}
```

## 🎯 Key Features to Test

### Authentication ✅
- [ ] Login with each role
- [ ] Logout from hamburger menu
- [ ] Verify role-specific UI elements
- [ ] Check permission display in user detail

### Equipment Management ✅
- [ ] View 6 equipment items
- [ ] Filter by department
- [ ] Create new equipment
- [ ] Update equipment details
- [ ] Delete equipment

### Request Management ✅
- [ ] View 6 maintenance requests
- [ ] Filter by status/priority
- [ ] Create new request
- [ ] Drag request in Kanban board
- [ ] Update request status
- [ ] Delete request

### Team Management ✅
- [ ] View 3 teams
- [ ] See team members
- [ ] See team leaders
- [ ] View team specialization

### User Management ✅
- [ ] View all 4 users
- [ ] Filter users by role
- [ ] See permission matrix
- [ ] Create new user
- [ ] Delete user
- [ ] View role dashboard

### Reports/Dashboard ✅
- [ ] Status pie chart (completed/in-progress/new)
- [ ] Priority distribution
- [ ] Team workload
- [ ] Equipment status
- [ ] Calendar view with maintenance dates

## 📊 Mock Data Summary

| Entity | Count | Example |
|--------|-------|---------|
| Users | 4 | Jane Smith (Admin), John Doe (Mechanic) |
| Equipment | 6 | CNC Machine, Hydraulic Press, Air Compressor |
| Teams | 3 | Mechanics, Electricians, IT Support |
| Requests | 6 | Preventive & Corrective maintenance |
| Permissions | 8 | Create Equipment, Manage Users, etc. |

## 🔄 Data Persistence Note

- Mock data is in-memory (stored in RAM)
- Data persists during app session
- Restarting backend will reset data to initial state
- Changes made in UI are reflected immediately

## 📱 Screen Checklist

### Navigation Flow
- [ ] Login Screen → Home Screen (on auth success)
- [ ] Home Screen → Equipment List
- [ ] Home Screen → Requests/Kanban Board
- [ ] Home Screen → Teams List
- [ ] Home Screen → User Management
- [ ] Home Screen → Reports
- [ ] Home Screen → Calendar View
- [ ] Any Screen → Logout (from menu)

### Visual Verification
- [ ] Dark premium theme applied
- [ ] Cyan accent colors visible
- [ ] Role badges showing correct role
- [ ] User info in app bar (name + role)
- [ ] Status indicators color-coded
- [ ] Priority levels visually distinct
- [ ] Team colors consistent

## 🐛 Troubleshooting

### "Cannot connect to backend"
- Check backend is running: `node src/server.js`
- Verify port 5000 is available
- Check firewall settings

### "No data showing"
- Verify API endpoints return data (test with curl)
- Check browser console for errors
- Ensure login was successful

### "Changes not persisting"
- Mock data is in-memory only
- Restart app to reset to original mock data
- This is expected behavior for development

## ✨ Demo Script (3 minutes)

1. **Login** with admin/admin
2. **Navigate** to Equipment → Show 6 items with maintenance dates
3. **Create** new equipment item → Show appearing in list
4. **Go to** Kanban board → Drag request between columns
5. **Show** Reports → Display charts from mock data
6. **View** User Management → Show 4 users with permissions
7. **Logout** → Return to login screen

---

**Status**: ✅ All mock data configured and ready for testing
**Backend**: http://localhost:5000
**Records**: 16+ items across 4 collections
