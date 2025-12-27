// Equipment Model
// Tracks all company assets (machines, vehicles, computers, etc.)

const mongoose = require('mongoose');

const equipmentSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    serialNumber: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    category: {
      type: String,
      required: true,
      enum: ['Machinery', 'Vehicle', 'Computer', 'Electrical', 'Other'],
    },
    department: {
      type: String,
      required: true,
      enum: ['Production', 'IT', 'HR', 'Finance', 'Operations', 'Other'],
    },
    assignedEmployee: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
    maintenanceTeam: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'MaintenanceTeam',
      required: true,
    },
    assignedTechnician: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
    purchaseDate: {
      type: Date,
      required: true,
    },
    warrantyExpiryDate: {
      type: Date,
    },
    location: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    status: {
      type: String,
      enum: ['Active', 'Inactive', 'Scrap'],
      default: 'Active',
    },
    notes: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Equipment', equipmentSchema);
