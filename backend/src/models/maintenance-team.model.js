// Maintenance Team Model
// Defines teams and their members who handle maintenance requests

const mongoose = require('mongoose');

const maintenanceTeamSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      enum: ['Mechanics', 'Electricians', 'IT Support', 'General Maintenance', 'Other'],
    },
    description: {
      type: String,
      trim: true,
    },
    members: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'User',
          required: true,
        },
        role: {
          type: String,
          enum: ['Manager', 'Technician', 'Lead'],
          default: 'Technician',
        },
        joinedDate: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    defaultTechnician: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('MaintenanceTeam', maintenanceTeamSchema);
