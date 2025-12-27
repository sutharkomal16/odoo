# 📱 Flutter App - Sample Data Display Guide

## 🎯 Overview

The Flutter app is fully configured to fetch and display all mock data from the backend. Here's what you'll see in each screen:

---

## 📊 Sample Data Breakdown

### 1️⃣ EQUIPMENT DATA (6 Items)

```json
Equipment List Response:
[
  {
    "_id": "1",
    "name": "CNC Machine A",
    "serialNumber": "CNC-001",
    "category": "Machinery",
    "department": "Production",
    "status": "Active",
    "installDate": "2022-01-15",
    "lastMaintenance": "2024-12-15",
    "nextMaintenance": "2025-01-15",
    "maintenanceFrequency": 30
  },
  // ... 5 more equipment items
]
```

**What you'll see in Equipment Screen:**
- ✅ CNC Machine A (Machinery - Production)
- ✅ Hydraulic Press B (Machinery - Production)
- ✅ Air Compressor C (Utilities - Production)
- ✅ Conveyor Belt System (Machinery - Production)
- ✅ Electrical Panel E (Electrical - Electrical)
- ✅ Server Cooling Unit (IT - IT)

Each item shows:
- Equipment name and status badge
- Next maintenance date
- Department color-coded
- Maintenance frequency

---

### 2️⃣ USERS DATA (4 Items)

```json
[
  {
    "_id": "1",
    "name": "Jane Smith",
    "email": "jane@example.com",
    "role": "ADMIN",
    "department": "Operations",
    "phone": "+1-555-0102",
    "isActive": true,
    "permissions": {
      "canCreateEquipment": true,
      "canEditEquipment": true,
      "canDeleteEquipment": true,
      "canCreateRequest": true,
      "canAssignRequest": true,
      "canViewReports": true,
      "canManageTeams": true,
      "canManageUsers": true
    }
  },
  // ... 3 more users with different roles
]
```

**Users in App:**
| Name | Role | Department | Permissions |
|------|------|------------|-------------|
| Jane Smith | ADMIN | Operations | All 8 ✅ |
| John Doe | MECHANIC | Production | 5/8 ✅ |
| Sarah Williams | ELECTRICIAN | Electrical | 5/8 ✅ |
| Mike Johnson | IT_SUPPORT | IT | 5/8 ✅ |

---

### 3️⃣ TEAMS DATA (3 Items)

```json
[
  {
    "_id": "1",
    "name": "Mechanics Team",
    "specialization": "MECHANIC",
    "leader": "John Doe",
    "members": [],
    "location": "Floor 1",
    "status": "Active"
  },
  {
    "_id": "2",
    "name": "Electricians Team",
    "specialization": "ELECTRICIAN",
    "leader": "Sarah Williams",
    "members": [],
    "location": "Floor 2",
    "status": "Active"
  },
  {
    "_id": "3",
    "name": "IT Support Team",
    "specialization": "IT_SUPPORT",
    "leader": "Mike Johnson",
    "members": [],
    "location": "IT Department",
    "status": "Active"
  }
]
```

**Teams in App:**
- 🔧 Mechanics Team (John Doe) - Floor 1
- ⚡ Electricians Team (Sarah Williams) - Floor 2
- 💻 IT Support Team (Mike Johnson) - IT Department

---

### 4️⃣ MAINTENANCE REQUESTS DATA (6 Items)

```json
[
  {
    "_id": "1",
    "title": "CNC Machine Regular Maintenance",
    "type": "Preventive",
    "equipment": "CNC Machine A",
    "department": "Production",
    "status": "Completed",
    "priority": "Medium",
    "description": "Regular maintenance and calibration",
    "assignedTo": "John Doe",
    "requestedBy": "Jane Smith",
    "createdDate": "2024-12-15",
    "completedDate": "2024-12-15",
    "duration": 2.5
  },
  {
    "_id": "2",
    "title": "Hydraulic Press Seal Replacement",
    "type": "Corrective",
    "equipment": "Hydraulic Press B",
    "department": "Production",
    "status": "In Progress",
    "priority": "High",
    "description": "Replace worn hydraulic seals",
    "assignedTo": "John Doe",
    "requestedBy": "Jane Smith",
    "createdDate": "2024-12-20"
  },
  // ... 4 more requests
]
```

**Requests Summary:**
| Request | Type | Status | Priority | Assigned To |
|---------|------|--------|----------|------------|
| CNC Machine Regular Maintenance | Preventive | ✅ Completed | Medium | John Doe |
| Hydraulic Press Seal Replacement | Corrective | 🔄 In Progress | High | John Doe |
| Electrical Panel Inspection | Preventive | 🆕 New | Medium | Sarah Williams |
| Server Cooling Unit Fan Replacement | Preventive | 🔄 In Progress | High | Mike Johnson |
| Air Compressor Oil Change | Preventive | 🆕 New | Low | John Doe |
| Conveyor Belt Alignment | Corrective | ✅ Completed | High | John Doe |

---

## 📱 What You'll See in Each Screen

### 🏠 Home Screen
```
┌─────────────────────────────┐
│  Welcome Jane Smith (Admin) │
│  👤 Profile Menu            │
├─────────────────────────────┤
│ 📊 DASHBOARD                │
│                             │
│ Total Equipment:  6         │
│ Active Requests: 4          │
│ Teams:          3           │
│ Users:          4           │
│                             │
│ 🔧 Equipment Overview       │
│  [6 items] →                │
│                             │
│ 📋 Maintenance Overview     │
│  [6 items] →                │
│                             │
│ 👥 Team Status             │
│  [3 teams] →                │
└─────────────────────────────┘
```

### 🏭 Equipment List Screen
```
┌─────────────────────────────┐
│ Equipment (6)               │
│                             │
│ 🏗️ CNC Machine A            │
│    Production • Machinery   │
│    Next: 2025-01-15        │
│                             │
│ 🏗️ Hydraulic Press B        │
│    Production • Machinery   │
│    Next: 2025-01-10        │
│                             │
│ 🏗️ Air Compressor C         │
│    Production • Utilities   │
│    Next: 2025-01-20        │
│                             │
│ [... 3 more items ...]     │
│                             │
│ ➕ Add Equipment            │
└─────────────────────────────┘
```

### 📋 Requests Screen (Kanban View)
```
┌──────────────────────────────────────────────┐
│ Maintenance Requests                         │
├──────────────┬──────────────┬──────────────┤
│ NEW (2)      │ IN PROGRESS  │ COMPLETED   │
│              │ (2)          │ (2)          │
├──────────────┼──────────────┼──────────────┤
│ • Electrical │ • Hydraulic  │ • CNC        │
│   Panel      │   Press Seal │   Machine    │
│   Insp...    │   Repl...    │   Regular    │
│              │              │   Maint...   │
│ • Air        │ • Server     │              │
│   Compressor │   Cooling    │ • Conveyor   │
│   Oil...     │   Unit Fan   │   Belt       │
│              │   Repl...    │   Alignment  │
│              │              │              │
│ (Drag items between columns to update)    │
└──────────────┴──────────────┴──────────────┘
```

### 👥 Users Screen
```
┌──────────────────────────────┐
│ User Management (4)          │
│                              │
│ Role Filters:                │
│ [ADMIN] [MECHANIC]           │
│ [ELECTRICIAN] [IT_SUPPORT]   │
│                              │
│ 👤 Jane Smith                │
│    ADMIN • Operations        │
│    Permissions: 8/8 ✅       │
│    [DELETE] [VIEW]           │
│                              │
│ 👤 John Doe                  │
│    MECHANIC • Production     │
│    Permissions: 5/8 ✅       │
│    [DELETE] [VIEW]           │
│                              │
│ 👤 Sarah Williams            │
│    ELECTRICIAN • Electrical  │
│    Permissions: 5/8 ✅       │
│    [DELETE] [VIEW]           │
│                              │
│ 👤 Mike Johnson              │
│    IT_SUPPORT • IT           │
│    Permissions: 5/8 ✅       │
│    [DELETE] [VIEW]           │
│                              │
│ ➕ Create User               │
└──────────────────────────────┘
```

### ⚙️ Teams Screen
```
┌──────────────────────────────┐
│ Maintenance Teams (3)        │
│                              │
│ 🔧 Mechanics Team            │
│    Leader: John Doe          │
│    Specialization: MECHANIC  │
│    Location: Floor 1         │
│    Members: 0                │
│                              │
│ ⚡ Electricians Team         │
│    Leader: Sarah Williams    │
│    Specialization: ELECTRICAL│
│    Location: Floor 2         │
│    Members: 0                │
│                              │
│ 💻 IT Support Team           │
│    Leader: Mike Johnson      │
│    Specialization: IT        │
│    Location: IT Department   │
│    Members: 0                │
│                              │
│ ➕ Create Team               │
└──────────────────────────────┘
```

---

## 🔄 Real-Time Interactions

### Creating a New Equipment Item
```
API Call: POST /api/maintenance/equipment
{
  "name": "New Compressor",
  "serialNumber": "NC-007",
  "category": "Utilities",
  "department": "Production"
}

Response:
{
  "success": true,
  "data": {
    "_id": "7",
    "name": "New Compressor",
    ...
  }
}

Result: ✅ New item appears in Equipment List
```

### Updating a Request Status
```
API Call: PATCH /api/maintenance/requests/2/status
{
  "status": "In Progress"
}

Response:
{
  "success": true,
  "data": {
    "_id": "2",
    "title": "Hydraulic Press Seal Replacement",
    "status": "In Progress",
    ...
  }
}

Result: ✅ Card moves in Kanban board (New → In Progress)
```

---

## 🎨 Visual Data in Premium Theme

### Colors Used
- **Primary**: Dark Navy (#0a1628)
- **Accent**: Cyan (#00d9ff)
- **Success**: Green (#00e676) - for Completed status
- **Warning**: Amber (#ffb74d) - for In Progress status
- **Info**: Blue (#29b6f6) - for New status
- **Danger**: Red (#ef5350) - for High priority

### Data Display Examples

**Status Badges:**
- 🟢 Completed (Green)
- 🟡 In Progress (Amber)
- 🔵 New (Blue)

**Priority Indicators:**
- 🔴 High Priority (Red)
- 🟡 Medium Priority (Amber)
- 🟢 Low Priority (Green)

**Department Colors:**
- Production: Cyan accent
- Electrical: Orange accent
- IT: Blue accent
- Operations: Purple accent

---

## 📊 Statistics Displayed

### Dashboard Summary
```
Total Equipment:    6 items
Active Equipment:   6 items (100%)

Total Requests:     6 items
Completed:          2 items (33%)
In Progress:        2 items (33%)
New:                2 items (33%)

Total Users:        4 items
ADMIN:              1 user
MECHANIC:           1 user
ELECTRICIAN:        1 user
IT_SUPPORT:         1 user

Total Teams:        3 teams
Average Team Size:  1 member

Next Maintenance:   2025-01-05 (Conveyor Belt)
```

---

## ✅ Data Verification Checklist

Run these commands to verify all data is present:

```bash
# Check Equipment (should return 6)
curl http://localhost:5000/api/maintenance/equipment | jq '.data | length'

# Check Requests (should return 6)
curl http://localhost:5000/api/maintenance/requests | jq '.data | length'

# Check Teams (should return 3)
curl http://localhost:5000/api/maintenance/teams | jq '.data | length'

# Check Users (should return 4)
curl http://localhost:5000/users | jq '.data | length'
```

Expected Output:
```
6  ✅ Equipment
6  ✅ Requests
3  ✅ Teams
4  ✅ Users
```

---

## 🚀 Running the Flutter App

```bash
# Navigate to frontend
cd frontend

# Run the app
flutter run -d web
# or for Android/iOS
flutter run -d android
flutter run -d ios
# or for Windows
flutter run -d windows
```

The app will:
1. Show login screen
2. Accept any of the 4 credentials
3. Fetch sample data from backend
4. Display all data in respective screens
5. Allow CRUD operations on the mock data

---

## 📝 Sample Login Flow

```
1. App starts → Login Screen
2. Enter: admin / admin
3. Click: Login
4. Backend verifies → Returns user data
5. App redirects → Home Screen with all data loaded
6. See 6 equipment items, 6 requests, 3 teams, 4 users
7. Navigate screens → All show sample data
8. Perform CRUD ops → Data updates in real-time
```

---

**Status**: ✅ All 16+ sample data records ready to display
**Backend**: Running on http://localhost:5000
**Frontend**: Ready to fetch and display sample data
