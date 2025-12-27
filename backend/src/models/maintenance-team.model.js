// Maintenance Team Model
// Defines teams and their members who handle maintenance requests

const mongoose = require('mongoose');

const maintenanceTeamSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      enum: ['Mechanics Team', 'Electricians Team', 'IT Support Team', 'General Maintenance', 'Specialized Team'],
    },
    description: {
      type: String,
      trim: true,
    },
    specialization: {
      type: String,
      enum: ['MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT', 'GENERAL'],
      required: true,
    },
    members: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'User',
          required: true,
        },
        joinedDate: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    leader: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
    department: {
      type: String,
      enum: ['Production', 'IT', 'HR', 'Finance', 'Operations', 'Other'],
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
