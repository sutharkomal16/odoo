// Maintenance Request Model
// Handles both corrective (breakdown) and preventive (routine checkup) maintenance

const mongoose = require('mongoose');

const maintenanceRequestSchema = new mongoose.Schema(
  {
    requestNumber: {
      type: String,
      unique: true,
      trim: true,
    },
    type: {
      type: String,
      enum: ['Corrective', 'Preventive'],
      required: true,
    },
    subject: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    equipment: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Equipment',
      required: true,
    },
    equipmentCategory: {
      type: String,
      trim: true,
    },
    maintenanceTeam: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'MaintenanceTeam',
      required: true,
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    assignedTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
    status: {
      type: String,
      enum: ['New', 'In Progress', 'Repaired', 'Scrap', 'On Hold'],
      default: 'New',
    },
    priority: {
      type: String,
      enum: ['Low', 'Medium', 'High', 'Critical'],
      default: 'Medium',
    },
    scheduledDate: {
      type: Date,
    },
    startDate: {
      type: Date,
    },
    completionDate: {
      type: Date,
    },
    duration: {
      type: Number, // Hours spent on maintenance
      default: 0,
    },
    estimatedDuration: {
      type: Number,
      default: 0,
    },
    cost: {
      type: Number,
      default: 0,
    },
    parts: [
      {
        name: String,
        quantity: Number,
        cost: Number,
      },
    ],
    notes: {
      type: String,
      trim: true,
    },
    isOverdue: {
      type: Boolean,
      default: false,
    },
    attachments: [
      {
        url: String,
        fileName: String,
        uploadedAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
  },
  {
    timestamps: true,
  }
);

// Auto-generate request number before saving
maintenanceRequestSchema.pre('save', async function (next) {
  if (!this.requestNumber) {
    const count = await mongoose.model('MaintenanceRequest').countDocuments();
    this.requestNumber = `MR-${Date.now()}-${count + 1}`;
  }
  next();
});

module.exports = mongoose.model('MaintenanceRequest', maintenanceRequestSchema);
