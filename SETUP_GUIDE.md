# Gear Guard - Complete Setup Guide

## 🚀 Quick Start

### Backend Setup (Node.js + MongoDB)

#### Step 1: Install Dependencies
```bash
cd backend
npm install
```

#### Step 2: Configure Database
Make sure you have MongoDB installed and running:
- **Local MongoDB**: Run `mongod` in a separate terminal
- **MongoDB Atlas**: Update `MONGODB_URI` in `.env` file with your connection string

#### Step 3: Seed Database with Dummy Data
```bash
npm run seed
```

This creates:
- ✅ 5 Users (technicians, managers, supervisors)
- ✅ 3 Maintenance Teams
- ✅ 6 Equipment items
- ✅ 8 Maintenance Requests

#### Step 4: Start Backend Server
```bash
npm start
```
Server runs on: `http://localhost:5000`

For development with auto-reload:
```bash
npm run dev
```

---

### Frontend Setup (Flutter)

#### Step 1: Install Dependencies
```bash
cd frontend
flutter pub get
```

#### Step 2: Run the App
For Android Emulator:
```bash
flutter run
```

For Web:
```bash
flutter run -d chrome
```

---

## 📊 Database Schema

### Users Collection
```javascript
{
  _id: ObjectId,
  name: String,
  email: String (unique),
  role: String (Technician, Manager, Supervisor, Admin),
  department: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Equipment Collection
```javascript
{
  _id: ObjectId,
  name: String,
  serialNumber: String (unique),
  category: String (Machinery, Vehicle, Computer, Electrical, Other),
  department: String,
  status: String (Active, Inactive, Scrap),
  assignedEmployee: ObjectId (ref: User),
  maintenanceTeam: ObjectId (ref: MaintenanceTeam),
  assignedTechnician: ObjectId (ref: User),
  purchaseDate: Date,
  warrantyExpiryDate: Date,
  location: String,
  description: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Maintenance Teams Collection
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  department: String,
  members: [ObjectId] (ref: User),
  defaultTechnician: ObjectId (ref: User),
  createdAt: Date,
  updatedAt: Date
}
```

### Maintenance Requests Collection
```javascript
{
  _id: ObjectId,
  title: String,
  description: String,
  equipment: ObjectId (ref: Equipment),
  requestedBy: ObjectId (ref: User),
  assignedTeam: ObjectId (ref: MaintenanceTeam),
  assignedTechnician: ObjectId (ref: User),
  type: String (Preventive, Corrective, Emergency),
  status: String (New, In Progress, Scheduled, On Hold, Repaired),
  priority: String (Low, Medium, High, Critical),
  category: String (Maintenance, Repair, Inspection),
  scheduledDate: Date,
  completedDate: Date,
  estimatedDuration: Number,
  isOverdue: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🔗 API Endpoints

### Equipment
- `GET /api/maintenance/equipment` - Get all equipment
- `POST /api/maintenance/equipment` - Create equipment
- `GET /api/maintenance/equipment/:id` - Get equipment details
- `PUT /api/maintenance/equipment/:id` - Update equipment
- `DELETE /api/maintenance/equipment/:id` - Delete equipment

### Teams
- `GET /api/maintenance/teams` - Get all teams
- `POST /api/maintenance/teams` - Create team
- `GET /api/maintenance/teams/:id` - Get team details
- `PUT /api/maintenance/teams/:id` - Update team
- `DELETE /api/maintenance/teams/:id` - Delete team

### Maintenance Requests
- `GET /api/maintenance/requests` - Get all requests
- `POST /api/maintenance/requests` - Create request
- `GET /api/maintenance/requests/:id` - Get request details
- `PATCH /api/maintenance/requests/:id/status` - Update status
- `PATCH /api/maintenance/requests/:id/assign` - Assign technician
- `GET /api/maintenance/requests-kanban/all` - Get by status (Kanban)
- `GET /api/maintenance/requests/type/preventive` - Get preventive (Calendar)

### Reports
- `GET /api/maintenance/reports/by-team` - Report by team
- `GET /api/maintenance/reports/by-category` - Report by category

---

## 🎨 Color Scheme (Premium Theme)

- **Primary Dark**: #0a1628 (Deep Navy)
- **Primary Darker**: #051019 (Almost Black)
- **Accent (Cyan)**: #00d9ff
- **Success (Green)**: #00e676
- **Warning (Amber)**: #ffb74d
- **Danger (Red)**: #ef5350
- **Info (Blue)**: #29b6f6
- **Pending (Purple)**: #ab47bc

---

## 📱 App Features

### Home Screen
- Dashboard with key metrics
- Quick action buttons
- Module grid navigation
- Status overview bar

### Equipment Management
- List all equipment with filters
- Add new equipment
- View equipment details
- Track maintenance history

### Maintenance Teams
- Manage teams and members
- Assign technicians
- View team workload

### Kanban Board
- Visual task management
- Drag-and-drop status updates
- Quick request overview

### Calendar View
- Schedule preventive maintenance
- View upcoming tasks
- Plan maintenance timeline

### Reports & Analytics
- Analyze by team
- Analyze by category
- View performance metrics

---

## ⚙️ Configuration Files

### Backend (.env)
```
MONGODB_URI=mongodb://localhost:27017/flutter_db
PORT=5000
```

### Frontend (API Service)
```dart
static const String baseUrl = "http://10.0.2.2:5000/api/maintenance";
```

---

## 🐛 Troubleshooting

### MongoDB Connection Failed
- Ensure MongoDB is running: `mongod`
- Check connection string in `.env`
- Verify MongoDB is accessible on `localhost:27017`

### "Connection Refused" Error
- Start the backend server: `npm start`
- Check PORT in `.env` (default: 5000)
- Ensure no firewall blocks the port

### Flutter App Can't Connect to Backend
- For Android Emulator: Use `10.0.2.2:5000` (default in code)
- For Physical Device: Use your machine's IP address
- Update API endpoint in `lib/services/api_service.dart`

### Port Already in Use
- Change PORT in `.env` file
- Or kill the process: `netstat -ano | findstr :5000` (Windows)

### No Data Showing in App
- Verify backend is running
- Check database seeding: `npm run seed`
- Look for error logs in browser console (F12)

---

## 📝 Default Dummy Data

### Sample Users
- John Doe (Technician)
- Jane Smith (Manager)
- Mike Johnson (Technician)
- Sarah Williams (Technician)
- Tom Brown (Supervisor)

### Sample Equipment
- CNC Machine A1
- Hydraulic Press B2
- Server Room Cooling System
- Fleet Vehicle 001
- Office Computers
- Backup Generator

### Sample Requests
- Oil Change (Preventive)
- Hydraulic Leak Repair (Corrective)
- Temperature Check (Inspection)
- And more...

---

## 🔄 Development Workflow

1. **Start MongoDB**: `mongod` (in separate terminal)
2. **Start Backend**: `npm start` (in backend directory)
3. **Start Frontend**: `flutter run` (in frontend directory)
4. **Make changes** to code
5. **Backend auto-reloads** with `npm run dev`
6. **Frontend hot-reloads** automatically

---

## 📦 Dependencies

### Backend
- Express.js (API framework)
- MongoDB + Mongoose (Database)
- CORS (Cross-origin requests)
- dotenv (Environment variables)

### Frontend
- Flutter (UI framework)
- http (HTTP requests)
- intl (Internationalization)

---

## ✅ Verification Checklist

- [ ] MongoDB is running
- [ ] Backend dependencies installed (`npm install`)
- [ ] Database seeded (`npm run seed`)
- [ ] Backend server running (`npm start`)
- [ ] Frontend dependencies installed (`flutter pub get`)
- [ ] Frontend app running (`flutter run`)
- [ ] Can see dashboard with dummy data
- [ ] Can navigate between screens
- [ ] Color scheme matches premium theme

---

For more detailed API documentation, see `API_GUIDE.md`
