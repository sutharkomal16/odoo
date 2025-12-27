const mongoose = require('mongoose');
require('dotenv').config();

const User = require('../models/user.model');
const Equipment = require('../models/equipment.model');
const MaintenanceTeam = require('../models/maintenance-team.model');
const MaintenanceRequest = require('../models/maintenance-request.model');

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/flutter_db';
    await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB connected');
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

const seedDatabase = async () => {
  try {
    // Clear existing data
    await User.deleteMany({});
    await MaintenanceTeam.deleteMany({});
    await Equipment.deleteMany({});
    await MaintenanceRequest.deleteMany({});
    console.log('Cleared existing data');

    // Create Users
    const users = await User.insertMany([
      {
        name: 'John Doe',
        email: 'john@example.com',
        role: 'MECHANIC',
        department: 'Production',
        phone: '+1-555-0101',
      },
      {
        name: 'Jane Smith',
        email: 'jane@example.com',
        role: 'ADMIN',
        department: 'Operations',
        phone: '+1-555-0102',
      },
      {
        name: 'Mike Johnson',
        email: 'mike@example.com',
        role: 'IT_SUPPORT',
        department: 'IT',
        phone: '+1-555-0103',
      },
      {
        name: 'Sarah Williams',
        email: 'sarah@example.com',
        role: 'ELECTRICIAN',
        department: 'Production',
        phone: '+1-555-0104',
      },
      {
        name: 'Tom Brown',
        email: 'tom@example.com',
        role: 'MECHANIC',
        department: 'Finance',
        phone: '+1-555-0105',
      },
    ]);
    console.log('Created 5 users');

    // Create Maintenance Teams
    const teams = await MaintenanceTeam.insertMany([
      {
        name: 'Mechanics Team',
        specialization: 'MECHANIC',
        description: 'Handles all machinery and mechanical equipment maintenance',
        department: 'Production',
        members: [{ userId: users[0]._id }, { userId: users[4]._id }],
        leader: users[0]._id,
      },
      {
        name: 'Electricians Team',
        specialization: 'ELECTRICIAN',
        description: 'Manages electrical systems and equipment maintenance',
        department: 'Production',
        members: [{ userId: users[3]._id }],
        leader: users[3]._id,
      },
      {
        name: 'IT Support Team',
        specialization: 'IT_SUPPORT',
        description: 'Handles IT infrastructure and computer systems',
        department: 'IT',
        members: [{ userId: users[2]._id }],
        leader: users[2]._id,
      },
    ]);
    console.log('Created 3 maintenance teams');

    // Create Equipment
    const equipment = await Equipment.insertMany([
      {
        name: 'CNC Machine A1',
        serialNumber: 'CNC-2023-001',
        category: 'Machinery',
        department: 'Production',
        assignedEmployee: users[0]._id,
        maintenanceTeam: teams[0]._id,
        assignedTechnician: users[0]._id,
        purchaseDate: new Date('2022-01-15'),
        warrantyExpiryDate: new Date('2025-01-15'),
        location: 'Building A, Floor 2',
        description: 'High-precision CNC machine for manufacturing',
        status: 'Active',
      },
      {
        name: 'Hydraulic Press B2',
        serialNumber: 'PRESS-2023-002',
        category: 'Machinery',
        department: 'Production',
        assignedEmployee: users[3]._id,
        maintenanceTeam: teams[0]._id,
        assignedTechnician: users[3]._id,
        purchaseDate: new Date('2021-06-20'),
        warrantyExpiryDate: new Date('2024-06-20'),
        location: 'Building A, Floor 1',
        description: 'Heavy-duty hydraulic press',
        status: 'Active',
      },
      {
        name: 'Server Room Cooling System',
        serialNumber: 'COOL-2023-003',
        category: 'Electrical',
        department: 'IT',
        assignedEmployee: users[2]._id,
        maintenanceTeam: teams[1]._id,
        assignedTechnician: users[2]._id,
        purchaseDate: new Date('2022-03-10'),
        warrantyExpiryDate: new Date('2025-03-10'),
        location: 'Building C, Basement',
        description: 'Server room HVAC system',
        status: 'Active',
      },
      {
        name: 'Fleet Vehicle 001',
        serialNumber: 'VEH-2022-001',
        category: 'Vehicle',
        department: 'Operations',
        assignedEmployee: users[1]._id,
        maintenanceTeam: teams[2]._id,
        assignedTechnician: users[1]._id,
        purchaseDate: new Date('2022-07-01'),
        warrantyExpiryDate: new Date('2025-07-01'),
        location: 'Fleet Garage',
        description: 'Company delivery truck',
        status: 'Active',
      },
      {
        name: 'Office Computers (10 units)',
        serialNumber: 'COMP-2023-005',
        category: 'Computer',
        department: 'IT',
        assignedEmployee: users[2]._id,
        maintenanceTeam: teams[1]._id,
        assignedTechnician: users[2]._id,
        purchaseDate: new Date('2023-01-15'),
        warrantyExpiryDate: new Date('2026-01-15'),
        location: 'Building B, All Floors',
        description: 'Desktop computers and laptops',
        status: 'Active',
      },
      {
        name: 'Backup Generator',
        serialNumber: 'GEN-2021-001',
        category: 'Electrical',
        department: 'Operations',
        assignedEmployee: users[4]._id,
        maintenanceTeam: teams[2]._id,
        assignedTechnician: users[4]._id,
        purchaseDate: new Date('2021-02-10'),
        warrantyExpiryDate: new Date('2024-02-10'),
        location: 'Building A, Roof',
        description: 'Emergency backup generator system',
        status: 'Active',
      },
    ]);
    console.log('Created 6 equipment items');

    // Create Maintenance Requests
    const now = new Date();
    const requests = await MaintenanceRequest.insertMany([
      {
        title: 'Oil Change for CNC Machine A1',
        description: 'Monthly preventive maintenance - oil change and filter replacement',
        equipment: equipment[0]._id,
        requestedBy: users[1]._id,
        assignedTeam: teams[0]._id,
        assignedTechnician: users[0]._id,
        type: 'Preventive',
        status: 'New',
        priority: 'Medium',
        scheduledDate: new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
        estimatedDuration: 2,
        category: 'Maintenance',
      },
      {
        title: 'Hydraulic Fluid Leak Repair',
        description: 'Emergency: Hydraulic leak detected in Press B2',
        equipment: equipment[1]._id,
        requestedBy: users[3]._id,
        assignedTeam: teams[0]._id,
        assignedTechnician: users[3]._id,
        type: 'Corrective',
        status: 'In Progress',
        priority: 'High',
        scheduledDate: now,
        estimatedDuration: 4,
        category: 'Repair',
      },
      {
        title: 'Server Room Temperature Check',
        description: 'Quarterly preventive maintenance for cooling system',
        equipment: equipment[2]._id,
        requestedBy: users[1]._id,
        assignedTeam: teams[1]._id,
        assignedTechnician: users[2]._id,
        type: 'Preventive',
        status: 'New',
        priority: 'Low',
        scheduledDate: new Date(now.getTime() + 14 * 24 * 60 * 60 * 1000), // 14 days
        estimatedDuration: 1,
        category: 'Inspection',
      },
      {
        title: 'Fleet Vehicle 001 - Oil & Filter Change',
        description: 'Regular maintenance: Oil change, filter replacement, fluid check',
        equipment: equipment[3]._id,
        requestedBy: users[1]._id,
        assignedTeam: teams[2]._id,
        assignedTechnician: users[1]._id,
        type: 'Preventive',
        status: 'Scheduled',
        priority: 'Medium',
        scheduledDate: new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000), // 3 days
        estimatedDuration: 1.5,
        category: 'Maintenance',
      },
      {
        title: 'Computer Update and Security Patch',
        description: 'Apply latest security patches and software updates',
        equipment: equipment[4]._id,
        requestedBy: users[2]._id,
        assignedTeam: teams[1]._id,
        assignedTechnician: users[2]._id,
        type: 'Preventive',
        status: 'Repaired',
        priority: 'Medium',
        scheduledDate: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000), // 7 days ago
        completedDate: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000), // 5 days ago
        estimatedDuration: 2,
        category: 'Maintenance',
      },
      {
        title: 'Generator Annual Inspection',
        description: 'Annual preventive maintenance and safety inspection',
        equipment: equipment[5]._id,
        requestedBy: users[4]._id,
        assignedTeam: teams[2]._id,
        assignedTechnician: users[4]._id,
        type: 'Preventive',
        status: 'On Hold',
        priority: 'Low',
        scheduledDate: new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000), // 30 days
        estimatedDuration: 3,
        category: 'Inspection',
      },
      {
        title: 'CNC Machine - Calibration Check',
        description: 'Quarterly accuracy calibration and test run',
        equipment: equipment[0]._id,
        requestedBy: users[0]._id,
        assignedTeam: teams[0]._id,
        assignedTechnician: users[0]._id,
        type: 'Preventive',
        status: 'New',
        priority: 'High',
        scheduledDate: new Date(now.getTime() + 10 * 24 * 60 * 60 * 1000),
        estimatedDuration: 3,
        category: 'Maintenance',
      },
      {
        title: 'Belt and Chain Inspection',
        description: 'Check and lubricate transmission belts and chains',
        equipment: equipment[1]._id,
        requestedBy: users[3]._id,
        assignedTeam: teams[0]._id,
        assignedTechnician: users[0]._id,
        type: 'Preventive',
        status: 'In Progress',
        priority: 'Medium',
        scheduledDate: now,
        estimatedDuration: 2,
        category: 'Inspection',
      },
    ]);
    console.log('Created 8 maintenance requests');

    console.log('\n✅ Database seeding completed successfully!');
    console.log(`
    Summary:
    - Users: 5
    - Teams: 3
    - Equipment: 6
    - Maintenance Requests: 8
    `);

    process.exit(0);
  } catch (error) {
    console.error('Seeding error:', error);
    process.exit(1);
  }
};

connectDB().then(() => {
  seedDatabase();
});
