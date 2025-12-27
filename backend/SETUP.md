# Gear Guard Backend - Setup Instructions

## Prerequisites
- Node.js (v14 or higher)
- MongoDB (running locally or use MongoDB Atlas)

## Installation & Setup

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment Variables
The `.env` file is already configured with MongoDB URI. Update if needed:
```
MONGODB_URI=mongodb://localhost:27017/flutter_db
PORT=5000
```

### 3. Start MongoDB
If using local MongoDB:
```bash
mongod
```

Or use MongoDB Atlas (update MONGODB_URI in .env with your connection string)

### 4. Seed Database with Dummy Data
```bash
npm run seed
```

This will populate the database with:
- 5 Users (technicians, managers, supervisors)
- 3 Maintenance Teams
- 6 Equipment items
- 8 Maintenance Requests (various statuses and types)

### 5. Start the Server
```bash
npm start
```

Server will run on `http://localhost:5000`

## API Routes

All API routes are prefixed with `/api/maintenance`

### Equipment Routes
- `POST /api/maintenance/equipment` - Create equipment
- `GET /api/maintenance/equipment` - Get all equipment (supports filters: department, category, status)
- `GET /api/maintenance/equipment/:id` - Get equipment by ID
- `PUT /api/maintenance/equipment/:id` - Update equipment
- `DELETE /api/maintenance/equipment/:id` - Delete equipment
- `GET /api/maintenance/equipment/:id/maintenance` - Get maintenance history

### Maintenance Team Routes
- `POST /api/maintenance/teams` - Create team
- `GET /api/maintenance/teams` - Get all teams
- `GET /api/maintenance/teams/:id` - Get team by ID
- `PUT /api/maintenance/teams/:id` - Update team
- `POST /api/maintenance/teams/:id/members` - Add team member
- `DELETE /api/maintenance/teams/:id/members` - Remove team member

### Maintenance Request Routes
- `POST /api/maintenance/requests` - Create maintenance request
- `GET /api/maintenance/requests` - Get all requests (supports filters)
- `GET /api/maintenance/requests/:id` - Get request by ID
- `PATCH /api/maintenance/requests/:id/status` - Update request status
- `PATCH /api/maintenance/requests/:id/assign` - Assign to technician
- `GET /api/maintenance/requests-kanban/all` - Get requests grouped by status (for Kanban view)
- `GET /api/maintenance/requests/type/preventive` - Get preventive requests (for Calendar)
- `GET /api/maintenance/reports/by-team` - Get report by team
- `GET /api/maintenance/reports/by-category` - Get report by category

## Health Check
```
GET http://localhost:5000/health
```

## Development
For development with auto-reload:
```bash
npm run dev
```

This uses `nodemon` to automatically restart the server on file changes.

## Database Models

### User
- name: String
- email: String (unique)
- role: String (Technician, Manager, Supervisor, Admin)
- department: String

### MaintenanceTeam
- name: String
- description: String
- department: String
- members: [User references]
- defaultTechnician: User reference

### Equipment
- name: String
- serialNumber: String (unique)
- category: String (Machinery, Vehicle, Computer, Electrical, Other)
- department: String
- status: String (Active, Inactive, Scrap)
- assignedEmployee: User reference
- maintenanceTeam: MaintenanceTeam reference
- assignedTechnician: User reference
- purchaseDate: Date
- warrantyExpiryDate: Date
- location: String
- description: String

### MaintenanceRequest
- title: String
- description: String
- equipment: Equipment reference
- requestedBy: User reference
- assignedTeam: MaintenanceTeam reference
- assignedTechnician: User reference
- type: String (Preventive, Corrective, Emergency)
- status: String (New, In Progress, Scheduled, On Hold, Repaired)
- priority: String (Low, Medium, High, Critical)
- category: String (Maintenance, Repair, Inspection)
- scheduledDate: Date
- completedDate: Date
- estimatedDuration: Number (in hours)

## Testing the API

### Example: Get All Equipment
```bash
curl http://localhost:5000/api/maintenance/equipment
```

### Example: Create Equipment
```bash
curl -X POST http://localhost:5000/api/maintenance/equipment \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Machine",
    "serialNumber": "SERIAL-2024-001",
    "category": "Machinery",
    "department": "Production",
    "maintenanceTeam": "<team_id>",
    "purchaseDate": "2024-01-01",
    "location": "Building A"
  }'
```

## Troubleshooting

### MongoDB Connection Error
- Ensure MongoDB is running (`mongod` command)
- Check MONGODB_URI in .env file
- Verify connection string format

### Port Already in Use
- Change PORT in .env file
- Or kill the process using the port

### Module Not Found Errors
- Run `npm install` again
- Delete `node_modules` folder and reinstall

## Support
For issues or questions, check the API_GUIDE.md file for more detailed documentation.
