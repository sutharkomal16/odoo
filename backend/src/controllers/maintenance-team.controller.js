// Maintenance Team Controller
// Handles team management and member operations

const MaintenanceTeam = require('../models/maintenance-team.model');

// Create a new maintenance team
exports.createTeam = async (req, res) => {
  try {
    const { name, description, members, defaultTechnician } = req.body;

    const team = new MaintenanceTeam({
      name,
      description,
      members: members || [],
      defaultTechnician,
    });

    await team.save();
    await team.populate('members.userId defaultTechnician');

    res.status(201).json({
      success: true,
      data: team,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Get all teams
exports.getAllTeams = async (req, res) => {
  try {
    const teams = await MaintenanceTeam.find({ isActive: true })
      .populate('members.userId defaultTechnician')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: teams,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get team by ID
exports.getTeamById = async (req, res) => {
  try {
    const team = await MaintenanceTeam.findById(req.params.id).populate(
      'members.userId defaultTechnician'
    );

    if (!team) {
      return res.status(404).json({
        success: false,
        message: 'Team not found',
      });
    }

    res.status(200).json({
      success: true,
      data: team,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Update team
exports.updateTeam = async (req, res) => {
  try {
    const team = await MaintenanceTeam.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    }).populate('members.userId defaultTechnician');

    if (!team) {
      return res.status(404).json({
        success: false,
        message: 'Team not found',
      });
    }

    res.status(200).json({
      success: true,
      data: team,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Add member to team
exports.addTeamMember = async (req, res) => {
  try {
    const { userId, role } = req.body;

    const team = await MaintenanceTeam.findByIdAndUpdate(
      req.params.id,
      {
        $push: {
          members: {
            userId,
            role: role || 'Technician',
          },
        },
      },
      { new: true }
    ).populate('members.userId defaultTechnician');

    if (!team) {
      return res.status(404).json({
        success: false,
        message: 'Team not found',
      });
    }

    res.status(200).json({
      success: true,
      data: team,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Remove member from team
exports.removeTeamMember = async (req, res) => {
  try {
    const { memberId } = req.body;

    const team = await MaintenanceTeam.findByIdAndUpdate(
      req.params.id,
      {
        $pull: {
          members: { userId: memberId },
        },
      },
      { new: true }
    ).populate('members.userId defaultTechnician');

    if (!team) {
      return res.status(404).json({
        success: false,
        message: 'Team not found',
      });
    }

    res.status(200).json({
      success: true,
      data: team,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Delete team
exports.deleteTeam = async (req, res) => {
  try {
    const team = await MaintenanceTeam.findByIdAndUpdate(
      req.params.id,
      { isActive: false },
      { new: true }
    );

    if (!team) {
      return res.status(404).json({
        success: false,
        message: 'Team not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Team deactivated successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
