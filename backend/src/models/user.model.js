const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, 'Please provide a valid email'],
    },
    role: {
      type: String,
      enum: ['ADMIN', 'MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT'],
      default: 'MECHANIC',
      required: true,
    },
    department: {
      type: String,
      enum: ['Production', 'IT', 'HR', 'Finance', 'Operations', 'Other'],
      required: true,
    },
    phone: {
      type: String,
      trim: true,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    permissions: {
      canCreateEquipment: { type: Boolean, default: false },
      canEditEquipment: { type: Boolean, default: false },
      canDeleteEquipment: { type: Boolean, default: false },
      canCreateRequest: { type: Boolean, default: true },
      canAssignRequest: { type: Boolean, default: false },
      canViewReports: { type: Boolean, default: false },
      canManageTeams: { type: Boolean, default: false },
      canManageUsers: { type: Boolean, default: false },
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

// Middleware to set permissions based on role
userSchema.pre('save', function (next) {
  const rolePermissions = {
    ADMIN: {
      canCreateEquipment: true,
      canEditEquipment: true,
      canDeleteEquipment: true,
      canCreateRequest: true,
      canAssignRequest: true,
      canViewReports: true,
      canManageTeams: true,
      canManageUsers: true,
    },
    MECHANIC: {
      canCreateEquipment: false,
      canEditEquipment: true,
      canDeleteEquipment: false,
      canCreateRequest: true,
      canAssignRequest: false,
      canViewReports: true,
      canManageTeams: false,
      canManageUsers: false,
    },
    ELECTRICIAN: {
      canCreateEquipment: false,
      canEditEquipment: true,
      canDeleteEquipment: false,
      canCreateRequest: true,
      canAssignRequest: false,
      canViewReports: true,
      canManageTeams: false,
      canManageUsers: false,
    },
    IT_SUPPORT: {
      canCreateEquipment: false,
      canEditEquipment: true,
      canDeleteEquipment: false,
      canCreateRequest: true,
      canAssignRequest: false,
      canViewReports: true,
      canManageTeams: false,
      canManageUsers: false,
    },
  };

  if (this.isModified('role') || !this.permissions) {
    this.permissions = rolePermissions[this.role] || rolePermissions.MECHANIC;
  }

  next();
});

// Method to check if user has permission
userSchema.methods.hasPermission = function (permission) {
  return this.permissions[permission] === true;
};

// Method to get role display name
userSchema.methods.getRoleDisplayName = function () {
  const roleNames = {
    ADMIN: 'Administrator',
    MECHANIC: 'Mechanic',
    ELECTRICIAN: 'Electrician',
    IT_SUPPORT: 'IT Support',
  };
  return roleNames[this.role] || this.role;
};

module.exports = mongoose.model('User', userSchema);
