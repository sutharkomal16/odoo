// Role-Based Access Control Middleware

const authorize = (allowedRoles) => {
  return (req, res, next) => {
    // This is a basic implementation
    // In a real app, you'd extract the user from JWT token
    // For now, we'll check if allowedRoles includes the user's role
    
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'User not authenticated',
      });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: `Access denied. Required roles: ${allowedRoles.join(', ')}`,
      });
    }

    next();
  };
};

// Permission-based middleware
const checkPermission = (permission) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'User not authenticated',
      });
    }

    if (!req.user.hasPermission(permission)) {
      return res.status(403).json({
        success: false,
        message: `Permission denied. Required permission: ${permission}`,
      });
    }

    next();
  };
};

// Admin only middleware
const adminOnly = authorize(['ADMIN']);

// Technician roles (Mechanic, Electrician, IT Support)
const technicianOnly = authorize(['MECHANIC', 'ELECTRICIAN', 'IT_SUPPORT']);

module.exports = {
  authorize,
  checkPermission,
  adminOnly,
  technicianOnly,
};
