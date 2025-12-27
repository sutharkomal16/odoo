# Gear Guard - Maintenance Management System

A comprehensive maintenance management module built with Flutter (frontend) and Node.js/Express (backend) that allows companies to track assets and manage maintenance requests seamlessly.

## 📋 System Overview

Gear Guard is an Odoo-like maintenance management system designed to:
- **Track Equipment**: Centralize all company assets (machines, vehicles, computers)
- **Manage Teams**: Organize maintenance teams with specialized technicians
- **Handle Requests**: Process both corrective (breakdown) and preventive maintenance requests
- **Visualize Work**: Use Kanban boards, calendars, and reports for better visibility

## 🏗️ Architecture

### Backend Stack
- **Framework**: Node.js with Express
- **Database**: MongoDB
- **Language**: JavaScript

### Frontend Stack
- **Framework**: Flutter
- **Language**: Dart
- **HTTP Client**: http package

## 📁 Project Structure

```
backend/
├── src/
│   ├── models/
│   │   ├── equipment.model.js
│   │   ├── maintenance-team.model.js
│   │   └── maintenance-request.model.js
│   ├── controllers/
│   │   ├── equipment.controller.js
│   │   ├── maintenance-team.controller.js
│   │   └── maintenance-request.controller.js
│   └── routes/
│       └── maintenance.routes.js

frontend/
├── lib/
│   ├── models/
│   │   ├── equipment.dart
│   │   ├── maintenance_team.dart
│   │   ├── maintenance_request.dart
│   │   └── user_model.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── equipment_list_screen.dart
│   │   ├── equipment_form_screen.dart
│   │   ├── equipment_detail_screen.dart
│   │   ├── team_list_screen.dart
│   │   ├── team_form_screen.dart
│   │   ├── team_detail_screen.dart
│   │   ├── maintenance_request_form_screen.dart
│   │   ├── kanban_board_screen.dart
│   │   ├── calendar_view_screen.dart
│   │   └── reports_screen.dart
│   ├── services/
│   │   └── api_service.dart
│   └── main.dart
```

## 🎯 Core Features

### A. Equipment Management

#### Key Fields
- **Equipment Name** & **Serial Number**: Unique identification
- **Category**: Machinery, Vehicle, Computer, Electrical, Other
- **Department**: Production, IT, HR, Finance, Operations, Other
- **Location**: Physical location of equipment
- **Purchase Date** & **Warranty Information**
- **Assigned Employee**: Owner of the equipment
- **Maintenance Team**: Responsible team for maintenance
- **Default Technician**: Assigned by default from team
- **Status**: Active, Inactive, or Scrap

#### Smart Button
- **Equipment Detail Screen** includes a "Maintenance" button
- Displays count of open maintenance requests
- Click to view all related maintenance history

#### Scrap Logic
- Mark equipment as Scrap when no longer usable
- Automatically marks related pending requests as Scrap
- Logs the action with timestamp

### B. Maintenance Teams

#### Team Structure
- **Team Name**: Mechanics, Electricians, IT Support, General Maintenance, Other
- **Team Members**: Link specific users with roles (Manager, Technician, Lead)
- **Default Technician**: Automatically assigned to new equipment
- **Status**: Active or Inactive

#### Workflow Logic
- When a maintenance request is created for equipment:
  - System automatically fetches the assigned Maintenance Team
  - Only team members can pick up the request
  - Supports role-based task assignment

### C. Maintenance Requests

#### Request Types

**Flow 1: The Breakdown (Corrective Maintenance)**
1. Any user creates a request for broken equipment
2. Auto-fill logic activates:
   - Equipment category is fetched
   - Maintenance team is populated
3. Request starts in "New" stage
4. Manager/Technician assigns themselves
5. Status moves to "In Progress"
6. Technician records duration and moves to "Repaired"

**Flow 2: The Routine Checkup (Preventive Maintenance)**
1. Manager creates request with type "Preventive"
2. Sets a Scheduled Date
3. Request appears on Calendar View for technician visibility
4. Technician can see all scheduled work for the day

#### Request Fields
- **Request Type**: Corrective or Preventive
- **Subject**: What is wrong? (e.g., "Leaking Oil")
- **Description**: Detailed description
- **Equipment**: Which machine is affected (with auto-fill)
- **Maintenance Team**: Responsible team (auto-filled from equipment)
- **Equipment Category**: Auto-filled from selected equipment
- **Priority**: Low, Medium, High, Critical
- **Status**: New → In Progress → Repaired (or Scrap/On Hold)
- **Scheduled Date**: For preventive maintenance
- **Duration**: Hours spent on repair
- **Cost**: Total maintenance cost
- **Parts Used**: List of replacement parts
- **Attachments**: Photos/documents
- **Overdue Indicator**: Shows if request is overdue

## 🎨 User Interface & Views

### 1. Dashboard/Home Screen
- Statistics cards showing:
  - Total equipment
  - Active teams
  - New requests
  - In-progress requests
  - Overdue requests
- Quick action buttons for common tasks
- Module navigation with descriptions

### 2. Equipment Management
- **Equipment List**: Filter by department, category, or status
- **Equipment Detail**: View full information with maintenance history
- **Equipment Form**: Add/edit equipment with all required fields
- **Smart Maintenance Button**: View open requests count and history

### 3. Kanban Board
- **Drag & Drop**: Move cards between status columns
- **Status Columns**: New | In Progress | Repaired | On Hold
- **Visual Indicators**:
  - Technician avatar
  - Priority color coding (Red: Critical, Orange: High, Amber: Medium, Green: Low)
  - Overdue indicator with warning color
- **Long Press**: Change status from any column
- **Card Information**:
  - Request number
  - Subject
  - Equipment name
  - Assigned technician
  - Priority level

### 4. Calendar View
- **Monthly Calendar**: Navigate through months
- **Request Count**: Shows number of scheduled maintenance per day
- **Day Details**: Click date to see all requests scheduled
- **Color Coding**: Orange badge for days with scheduled work
- **Quick Add**: Create new maintenance request for selected date

### 5. Reports & Analytics
- **By Team Report**:
  - Horizontal bar chart showing requests per team
  - Total and open count per team
  - Percentage visualization

- **By Category Report**:
  - Bar chart showing requests per equipment category
  - Open vs. completed breakdown
  - Total request summary card

### 6. Teams Management
- **Team List**: View all active teams with member count
- **Team Details**: View team information, description, members
- **Team Members**: Show member roles and join dates
- **Default Technician**: Highlighted with star icon
- **Add/Edit Teams**: Form to manage team composition

## 🔌 Backend API Endpoints

### Equipment Endpoints
- `POST /equipment` - Create equipment
- `GET /equipment` - Get all equipment (with filters)
- `GET /equipment/:id` - Get specific equipment
- `PUT /equipment/:id` - Update equipment
- `DELETE /equipment/:id` - Delete equipment
- `GET /equipment/:id/maintenance` - Get requests for equipment
- `GET /equipment/:id/maintenance-count` - Get open request count
- `PATCH /equipment/:id/scrap` - Mark as scrap

### Team Endpoints
- `POST /teams` - Create team
- `GET /teams` - Get all teams
- `GET /teams/:id` - Get specific team
- `PUT /teams/:id` - Update team
- `POST /teams/:id/members` - Add team member
- `DELETE /teams/:id/members` - Remove team member
- `DELETE /teams/:id` - Deactivate team

### Maintenance Request Endpoints
- `POST /requests` - Create request (with auto-fill)
- `GET /requests` - Get all requests (with filters)
- `GET /requests/:id` - Get specific request
- `PATCH /requests/:id/status` - Update status (Kanban drag & drop)
- `PATCH /requests/:id/assign` - Assign to technician
- `GET /requests-kanban/all` - Get grouped by status
- `GET /requests/type/preventive` - Get preventive maintenance
- `GET /requests/dates/range` - Get requests by date range
- `GET /reports/by-team` - Team statistics
- `GET /reports/by-category` - Category statistics
- `DELETE /requests/:id` - Delete request

## 🚀 Getting Started

### Prerequisites
- Node.js v14+
- Flutter 3.0+
- MongoDB database

### Backend Setup

1. **Install dependencies**
```bash
cd backend
npm install
```

2. **Configure environment variables**
Create `.env` file with:
```
MONGODB_URI=your_mongodb_uri
PORT=5000
```

3. **Start server**
```bash
npm start
```

### Frontend Setup

1. **Get dependencies**
```bash
cd frontend
flutter pub get
```

2. **Update API URL**
Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = "http://your_api_url:5000";
```

3. **Run app**
```bash
flutter run
```

## 💡 Business Logic Implementation

### Auto-Fill Logic
When user selects equipment in maintenance request form:
1. Equipment data is fetched from backend
2. Equipment category is automatically populated (read-only)
3. Maintenance team is auto-filled from equipment's assigned team
4. Form shows "Auto-filled" status

### Status Transitions
```
New → In Progress → Repaired
  ↓
 On Hold → In Progress
  ↓
  Scrap (from any state)
```

### Overdue Calculation
- Request is marked overdue if:
  - Status is not "Repaired" or "Scrap"
  - Scheduled date is in the past
  - Displayed with red warning indicator

### Team Assignment
- Equipment is assigned to a specific team
- Default technician from team is suggested
- Only team members can be assigned to team's requests

## 🔒 Data Relationships

```
Equipment
├── Assigned Employee (User)
├── Maintenance Team (MaintenanceTeam)
└── Assigned Technician (User from Team)

MaintenanceTeam
├── Team Members (List of Users with roles)
└── Default Technician (User)

MaintenanceRequest
├── Equipment (Equipment)
├── Maintenance Team (MaintenanceTeam)
├── Created By (User)
├── Assigned To (User/Technician)
├── Parts Used (List)
└── Attachments (List)
```

## 📊 Reporting & Analytics

### Pivot Reports
1. **Requests by Team**: Shows load distribution across teams
2. **Requests by Category**: Shows which equipment types need most maintenance

### Key Metrics
- Total open requests
- Average resolution time
- Team productivity
- Equipment failure frequency
- Overdue request count

## 🛠️ Technology Highlights

### Frontend (Flutter)
- **State Management**: SetState for simplicity (can upgrade to Provider/BLoC)
- **HTTP Communication**: http package for API calls
- **UI Components**: Material Design 3
- **Navigation**: Named routes with bottom tab navigation
- **Forms**: Form validation with custom widgets

### Backend (Node.js/Express)
- **Database**: MongoDB with Mongoose ODM
- **Auto-Generation**: Request numbers auto-generated
- **Validation**: Schema validation on model layer
- **Relationships**: References between collections
- **Middleware**: Standard Express middleware for JSON handling

## 📝 Future Enhancements

- Notification system for overdue requests
- Photo upload for equipment damage documentation
- Cost analysis and budget tracking
- Predictive maintenance using historical data
- Mobile app for technicians in field
- Integration with IoT sensors for real-time equipment monitoring
- Inventory management for spare parts
- Email notifications for status changes

## 📄 License

This project is part of the Odoo maintenance module ecosystem.

---

**Version**: 1.0  
**Last Updated**: December 2025  
**Status**: Production Ready
