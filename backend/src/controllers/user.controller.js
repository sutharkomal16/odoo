// User Controller
// Handles user-related operations

const User = require("../models/user.model");
const { mockUsers } = require("../data/mock-data");

// Create a new user
exports.createUser = async (req, res) => {
  try {
    const { name, email, role, department, phone } = req.body;

    // Validate role
    const validRoles = ['ADMIN', 'MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT'];
    if (!validRoles.includes(role)) {
      return res.status(400).json({
        success: false,
        message: `Invalid role. Must be one of: ${validRoles.join(', ')}`,
      });
    }

    // Use mock data if MongoDB not available
    const newUser = {
      _id: (mockUsers.length + 1).toString(),
      name,
      email,
      role,
      department,
      phone,
      isActive: true,
      permissions: generatePermissions(role),
    };
    
    mockUsers.push(newUser);

    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const { role, department, isActive } = req.query;
    
    let filteredUsers = [...mockUsers];

    if (role) filteredUsers = filteredUsers.filter(u => u.role === role);
    if (department) filteredUsers = filteredUsers.filter(u => u.department === department);
    if (isActive !== undefined) filteredUsers = filteredUsers.filter(u => u.isActive === (isActive === 'true'));

    res.json(filteredUsers);
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get user by ID
exports.getUserById = async (req, res) => {
  try {
    const user = mockUsers.find(u => u._id === req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Update user
exports.updateUser = async (req, res) => {
  try {
    const { name, email, role, department, phone, isActive } = req.body;

    // Validate role if provided
    if (role) {
      const validRoles = ['ADMIN', 'MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT'];
      if (!validRoles.includes(role)) {
        return res.status(400).json({
          success: false,
          message: `Invalid role. Must be one of: ${validRoles.join(', ')}`,
        });
      }
    }

    const user = await User.findByIdAndUpdate(
      req.params.id,
      { name, email, role, department, phone, isActive, updatedAt: Date.now() },
      { new: true, runValidators: true }
    );

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.status(200).json({
      success: true,
      data: user,
      message: 'User updated successfully',
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Email already exists',
      });
    }
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Delete user
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'User deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get users by role
exports.getUsersByRole = async (req, res) => {
  try {
    const { role } = req.params;

    const validRoles = ['ADMIN', 'MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT'];
    if (!validRoles.includes(role)) {
      return res.status(400).json({
        success: false,
        message: `Invalid role. Must be one of: ${validRoles.join(', ')}`,
      });
    }

    const users = await User.find({ role, isActive: true }).select('-permissions');

    res.status(200).json({
      success: true,
      role,
      data: users,
      count: users.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get role statistics
exports.getRoleStats = async (req, res) => {
  try {
    const stats = await User.aggregate([
      {
        $group: {
          _id: '$role',
          count: { $sum: 1 },
          active: {
            $sum: {
              $cond: [{ $eq: ['$isActive', true] }, 1, 0],
            },
          },
        },
      },
      {
        $sort: { count: -1 },
      },
    ]);

    res.status(200).json({
      success: true,
      data: stats,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Check user permissions
exports.checkPermissions = async (req, res) => {
  try {
    const user = mockUsers.find(u => u._id === req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.json({
      userId: user._id,
      role: user.role,
      permissions: user.permissions,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Helper function to generate permissions based on role
function generatePermissions(role) {
  const basePermissions = {
    canCreateEquipment: false,
    canEditEquipment: false,
    canDeleteEquipment: false,
    canCreateRequest: false,
    canAssignRequest: false,
    canViewReports: false,
    canManageTeams: false,
    canManageUsers: false,
  };

  switch (role) {
    case 'ADMIN':
      return { ...basePermissions, ...{
        canCreateEquipment: true,
        canEditEquipment: true,
        canDeleteEquipment: true,
        canCreateRequest: true,
        canAssignRequest: true,
        canViewReports: true,
        canManageTeams: true,
        canManageUsers: true,
      }};
    case 'MECHANIC':
    case 'ELECTRICIAN':
    case 'IT_SUPPORT':
      return { ...basePermissions, ...{
        canCreateEquipment: true,
        canEditEquipment: true,
        canCreateRequest: true,
        canViewReports: true,
      }};
    default:
      return basePermissions;
  }
}
