# 📱 Sample Data Display Reference

## 🎯 Complete Data Structure

All sample data is structured to automatically populate the Flutter app screens. Here's the complete reference:

---

## 🔐 LOGIN CREDENTIALS

**4 Pre-configured Users:**

```
┌─────────────────┬──────────────┬───────────────┬────────────────────┐
│ Username        │ Password      │ Role          │ Department         │
├─────────────────┼──────────────┼───────────────┼────────────────────┤
│ admin           │ admin         │ ADMIN         │ Operations         │
│ MECHANIC        │ MECHANIC      │ MECHANIC      │ Production         │
│ ELECTRICIAN     │ ELECTRICIAN   │ ELECTRICIAN   │ Electrical         │
│ IT_SUPPORT      │ IT_SUPPORT    │ IT_SUPPORT    │ IT                 │
└─────────────────┴──────────────┴───────────────┴────────────────────┘
```

---

## 🏭 EQUIPMENT DATABASE

**6 Equipment Items Across 3 Departments:**

```
PRODUCTION DEPARTMENT (4 items):
┌─────────────────────────────────────────────────────────────────┐
│ 1. CNC Machine A                   (Machinery)                  │
│    Serial: CNC-001  |  Status: Active  |  Freq: Every 30 days  │
│    Installed: 2022-01-15                                        │
│    Last Maintenance: 2024-12-15                                 │
│    Next Maintenance: 2025-01-15                                 │
│                                                                 │
│ 2. Hydraulic Press B               (Machinery)                  │
│    Serial: HP-002   |  Status: Active  |  Freq: Every 30 days  │
│    Installed: 2021-06-20                                        │
│    Last Maintenance: 2024-12-10                                 │
│    Next Maintenance: 2025-01-10                                 │
│                                                                 │
│ 3. Air Compressor C                (Utilities)                  │
│    Serial: AC-003   |  Status: Active  |  Freq: Every 30 days  │
│    Installed: 2020-03-10                                        │
│    Last Maintenance: 2024-12-20                                 │
│    Next Maintenance: 2025-01-20                                 │
│                                                                 │
│ 4. Conveyor Belt System            (Machinery)                  │
│    Serial: CBS-004  |  Status: Active  |  Freq: Every 30 days  │
│    Installed: 2019-11-05                                        │
│    Last Maintenance: 2024-12-05                                 │
│    Next Maintenance: 2025-01-05                                 │
└─────────────────────────────────────────────────────────────────┘

ELECTRICAL DEPARTMENT (1 item):
┌─────────────────────────────────────────────────────────────────┐
│ 5. Electrical Panel E              (Electrical)                 │
│    Serial: EP-005   |  Status: Active  |  Freq: Every 45 days  │
│    Installed: 2021-08-12                                        │
│    Last Maintenance: 2024-12-12                                 │
│    Next Maintenance: 2025-01-12                                 │
└─────────────────────────────────────────────────────────────────┘

IT DEPARTMENT (1 item):
┌─────────────────────────────────────────────────────────────────┐
│ 6. Server Cooling Unit             (IT)                         │
│    Serial: SCU-006  |  Status: Active  |  Freq: Every 30 days  │
│    Installed: 2022-05-20                                        │
│    Last Maintenance: 2024-12-18                                 │
│    Next Maintenance: 2025-01-18                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 👥 USER MANAGEMENT DATABASE

**4 Users with Complete Profiles:**

```
USER #1: ADMINISTRATOR
┌─────────────────────────────────────────────────────────┐
│ Name:           Jane Smith                              │
│ Email:          jane@example.com                        │
│ Role:           ADMIN                                   │
│ Department:     Operations                              │
│ Phone:          +1-555-0102                             │
│ Status:         Active ✅                               │
│ Permissions:    ALL 8/8 ✅                              │
│  ✅ Create Equipment                                    │
│  ✅ Edit Equipment                                      │
│  ✅ Delete Equipment                                    │
│  ✅ Create Requests                                     │
│  ✅ Assign Requests                                     │
│  ✅ View Reports                                        │
│  ✅ Manage Teams                                        │
│  ✅ Manage Users                                        │
└─────────────────────────────────────────────────────────┘

USER #2: MECHANIC
┌─────────────────────────────────────────────────────────┐
│ Name:           John Doe                                │
│ Email:          john@example.com                        │
│ Role:           MECHANIC                                │
│ Department:     Production                              │
│ Phone:          +1-555-0101                             │
│ Status:         Active ✅                               │
│ Permissions:    5/8 ✅                                  │
│  ✅ Create Equipment                                    │
│  ✅ Edit Equipment                                      │
│  ❌ Delete Equipment                                    │
│  ✅ Create Requests                                     │
│  ❌ Assign Requests                                     │
│  ✅ View Reports                                        │
│  ❌ Manage Teams                                        │
│  ❌ Manage Users                                        │
└─────────────────────────────────────────────────────────┘

USER #3: ELECTRICIAN
┌─────────────────────────────────────────────────────────┐
│ Name:           Sarah Williams                          │
│ Email:          sarah@example.com                       │
│ Role:           ELECTRICIAN                             │
│ Department:     Electrical                              │
│ Phone:          +1-555-0103                             │
│ Status:         Active ✅                               │
│ Permissions:    5/8 ✅                                  │
│  ✅ Create Equipment                                    │
│  ✅ Edit Equipment                                      │
│  ❌ Delete Equipment                                    │
│  ✅ Create Requests                                     │
│  ❌ Assign Requests                                     │
│  ✅ View Reports                                        │
│  ❌ Manage Teams                                        │
│  ❌ Manage Users                                        │
└─────────────────────────────────────────────────────────┘

USER #4: IT SUPPORT
┌─────────────────────────────────────────────────────────┐
│ Name:           Mike Johnson                            │
│ Email:          mike@example.com                        │
│ Role:           IT_SUPPORT                              │
│ Department:     IT                                      │
│ Phone:          +1-555-0104                             │
│ Status:         Active ✅                               │
│ Permissions:    5/8 ✅                                  │
│  ✅ Create Equipment                                    │
│  ✅ Edit Equipment                                      │
│  ❌ Delete Equipment                                    │
│  ✅ Create Requests                                     │
│  ❌ Assign Requests                                     │
│  ✅ View Reports                                        │
│  ❌ Manage Teams                                        │
│  ❌ Manage Users                                        │
└─────────────────────────────────────────────────────────┘
```

---

## ⚙️ MAINTENANCE TEAMS DATABASE

**3 Teams Across 3 Specializations:**

```
TEAM #1: MECHANICS
┌─────────────────────────────────────────────────────────┐
│ Team Name:      Mechanics Team                          │
│ Specialization: MECHANIC                                │
│ Team Leader:    John Doe                                │
│ Location:       Floor 1                                 │
│ Status:         Active ✅                               │
│ Members:        []  (No members yet)                     │
│ Assigned:       4 equipment items                       │
└─────────────────────────────────────────────────────────┘

TEAM #2: ELECTRICIANS
┌─────────────────────────────────────────────────────────┐
│ Team Name:      Electricians Team                       │
│ Specialization: ELECTRICIAN                             │
│ Team Leader:    Sarah Williams                          │
│ Location:       Floor 2                                 │
│ Status:         Active ✅                               │
│ Members:        []  (No members yet)                     │
│ Assigned:       1 equipment item                        │
└─────────────────────────────────────────────────────────┘

TEAM #3: IT SUPPORT
┌─────────────────────────────────────────────────────────┐
│ Team Name:      IT Support Team                         │
│ Specialization: IT_SUPPORT                              │
│ Team Leader:    Mike Johnson                            │
│ Location:       IT Department                           │
│ Status:         Active ✅                               │
│ Members:        []  (No members yet)                     │
│ Assigned:       1 equipment item                        │
└─────────────────────────────────────────────────────────┘
```

---

## 📋 MAINTENANCE REQUESTS DATABASE

**6 Requests Across 3 Status Levels:**

```
NEW REQUESTS (2):
┌─────────────────────────────────────────────────────────┐
│ REQUEST #3: Electrical Panel Inspection                 │
│ Type:        Preventive                                 │
│ Equipment:   Electrical Panel E                         │
│ Department:  Electrical                                 │
│ Status:      🔵 New                                     │
│ Priority:    Medium 🟡                                  │
│ Description: Routine electrical safety inspection       │
│ Assigned To: Sarah Williams (ELECTRICIAN)               │
│ Created:     2024-12-25                                 │
│                                                         │
│ REQUEST #5: Air Compressor Oil Change                   │
│ Type:        Preventive                                 │
│ Equipment:   Air Compressor C                           │
│ Department:  Production                                 │
│ Status:      🔵 New                                     │
│ Priority:    Low 🟢                                     │
│ Description: Regular oil change and filter replacement  │
│ Assigned To: John Doe (MECHANIC)                        │
│ Created:     2024-12-24                                 │
└─────────────────────────────────────────────────────────┘

IN PROGRESS REQUESTS (2):
┌─────────────────────────────────────────────────────────┐
│ REQUEST #2: Hydraulic Press Seal Replacement            │
│ Type:        Corrective                                 │
│ Equipment:   Hydraulic Press B                          │
│ Department:  Production                                 │
│ Status:      🟡 In Progress                             │
│ Priority:    High 🔴                                    │
│ Description: Replace worn hydraulic seals               │
│ Assigned To: John Doe (MECHANIC)                        │
│ Created:     2024-12-20                                 │
│ Duration:    (In progress)                              │
│                                                         │
│ REQUEST #4: Server Cooling Unit Fan Replacement         │
│ Type:        Preventive                                 │
│ Equipment:   Server Cooling Unit                        │
│ Department:  IT                                         │
│ Status:      🟡 In Progress                             │
│ Priority:    High 🔴                                    │
│ Description: Replace cooling unit fans                  │
│ Assigned To: Mike Johnson (IT_SUPPORT)                  │
│ Created:     2024-12-22                                 │
│ Duration:    (In progress)                              │
└─────────────────────────────────────────────────────────┘

COMPLETED REQUESTS (2):
┌─────────────────────────────────────────────────────────┐
│ REQUEST #1: CNC Machine Regular Maintenance             │
│ Type:        Preventive                                 │
│ Equipment:   CNC Machine A                              │
│ Department:  Production                                 │
│ Status:      🟢 Completed                               │
│ Priority:    Medium 🟡                                  │
│ Description: Regular maintenance and calibration        │
│ Assigned To: John Doe (MECHANIC)                        │
│ Requested By: Jane Smith (ADMIN)                        │
│ Created:     2024-12-15                                 │
│ Completed:   2024-12-15                                 │
│ Duration:    2.5 hours                                  │
│                                                         │
│ REQUEST #6: Conveyor Belt Alignment                     │
│ Type:        Corrective                                 │
│ Equipment:   Conveyor Belt System                       │
│ Department:  Production                                 │
│ Status:      🟢 Completed                               │
│ Priority:    High 🔴                                    │
│ Description: Fix belt misalignment issue                │
│ Assigned To: John Doe (MECHANIC)                        │
│ Requested By: Jane Smith (ADMIN)                        │
│ Created:     2024-12-10                                 │
│ Completed:   2024-12-12                                 │
│ Duration:    3 hours                                    │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 Data Statistics

```
SUMMARY METRICS:
┌────────────────────────────────┐
│ Total Equipment:        6      │
│ Total Users:            4      │
│ Total Teams:            3      │
│ Total Requests:         6      │
│                                │
│ STATUS DISTRIBUTION:           │
│  • Completed:     2 (33%)      │
│  • In Progress:   2 (33%)      │
│  • New:           2 (33%)      │
│                                │
│ PRIORITY DISTRIBUTION:         │
│  • High:          3 (50%)      │
│  • Medium:        2 (33%)      │
│  • Low:           1 (17%)      │
│                                │
│ ROLE DISTRIBUTION:             │
│  • ADMIN:         1 (25%)      │
│  • MECHANIC:      1 (25%)      │
│  • ELECTRICIAN:   1 (25%)      │
│  • IT_SUPPORT:    1 (25%)      │
│                                │
│ DEPARTMENT DISTRIBUTION:       │
│  • Production:    4 items      │
│  • Electrical:    1 item       │
│  • IT:            1 item       │
│  • Operations:    1 user       │
└────────────────────────────────┘
```

---

## 🔄 Data Flow in Flutter App

```
[Login Screen]
    ↓
  Login with credentials (4 options)
    ↓
[Backend Authentication] - Validates user
    ↓
[Home Screen] - Loads all data
    ├→ Fetches 6 Equipment
    ├→ Fetches 6 Requests
    ├→ Fetches 3 Teams
    ├→ Fetches 4 Users
    └→ Calculates Dashboard Stats
    ↓
[User Navigates Between Screens]
    ├→ Equipment Screen (6 items)
    ├→ Requests/Kanban (6 items in 3 columns)
    ├→ Teams Screen (3 teams)
    ├→ User Management (4 users)
    └→ Dashboard (statistics)
    ↓
[CRUD Operations]
    ├→ Create: Adds to mock array, updates UI
    ├→ Read: Fetches from API
    ├→ Update: Modifies mock data
    └→ Delete: Removes from mock array
    ↓
[Logout] - Returns to Login Screen
```

---

## ✅ Data Validation Checklist

Before running the app, verify:

- ✅ 6 Equipment items with dates
- ✅ 4 Users with roles and permissions
- ✅ 3 Teams with leaders
- ✅ 6 Requests with status distribution
- ✅ All IDs are unique strings
- ✅ All dates are ISO format (YYYY-MM-DD)
- ✅ All statuses match expected values
- ✅ All priority levels are assigned
- ✅ All permissions are boolean flags
- ✅ API returns proper response format

---

## 🎯 What You'll See When Running

After logging in with `admin/admin`:

1. **Home Screen**: Dashboard with 6 equipment, 6 requests, 3 teams, 4 users
2. **Equipment Screen**: All 6 items listed with next maintenance dates
3. **Requests Screen**: Kanban board with 2 columns (New, In Progress, Completed)
4. **Teams Screen**: 3 teams with leaders and specializations
5. **User Management**: 4 users with role badges and permission counts
6. **Reports**: Charts showing data distribution

All data is **real, testable, and immediately visible**.

---

**Total Sample Data Records: 16+ items**  
**Backend Endpoint**: http://localhost:5000  
**Status**: ✅ Ready for Flutter App Display
