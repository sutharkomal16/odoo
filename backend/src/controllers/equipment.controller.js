// Equipment Controller
// Handles all equipment-related operations

const Equipment = require('../models/equipment.model');
const MaintenanceRequest = require('../models/maintenance-request.model');
const MaintenanceTeam = require('../models/maintenance-team.model');

// Create a new equipment
exports.createEquipment = async (req, res) => {
  try {
    const {
      name,
      serialNumber,
      category,
      department,
      maintenanceTeam,
      purchaseDate,
      warrantyExpiryDate,
      location,
      description,
    } = req.body;

    const equipment = new Equipment({
      name,
      serialNumber,
      category,
      department,
      maintenanceTeam,
      purchaseDate,
      warrantyExpiryDate,
      location,
      description,
    });

    // Set default technician from team
    const team = await MaintenanceTeam.findById(maintenanceTeam);
    if (team && team.defaultTechnician) {
      equipment.assignedTechnician = team.defaultTechnician;
    }

    await equipment.save();
    await equipment.populate(['assignedEmployee', 'maintenanceTeam', 'assignedTechnician']);

    res.status(201).json({
      success: true,
      data: equipment,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Get all equipment
exports.getAllEquipment = async (req, res) => {
  try {
    const { department, category, status } = req.query;
    let query = {};

    if (department) query.department = department;
    if (category) query.category = category;
    if (status) query.status = status;

    const equipment = await Equipment.find(query)
      .populate(['assignedEmployee', 'maintenanceTeam', 'assignedTechnician'])
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: equipment,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get equipment by ID
exports.getEquipmentById = async (req, res) => {
  try {
    const equipment = await Equipment.findById(req.params.id).populate([
      'assignedEmployee',
      'maintenanceTeam',
      'assignedTechnician',
    ]);

    if (!equipment) {
      return res.status(404).json({
        success: false,
        message: 'Equipment not found',
      });
    }

    res.status(200).json({
      success: true,
      data: equipment,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Update equipment
exports.updateEquipment = async (req, res) => {
  try {
    const equipment = await Equipment.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    }).populate(['assignedEmployee', 'maintenanceTeam', 'assignedTechnician']);

    if (!equipment) {
      return res.status(404).json({
        success: false,
        message: 'Equipment not found',
      });
    }

    res.status(200).json({
      success: true,
      data: equipment,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Delete equipment
exports.deleteEquipment = async (req, res) => {
  try {
    const equipment = await Equipment.findByIdAndDelete(req.params.id);

    if (!equipment) {
      return res.status(404).json({
        success: false,
        message: 'Equipment not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Equipment deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get maintenance requests for specific equipment
exports.getEquipmentMaintenance = async (req, res) => {
  try {
    const requests = await MaintenanceRequest.find({
      equipment: req.params.id,
      status: { $ne: 'Scrap' },
    })
      .populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo'])
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: requests,
      count: requests.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get maintenance count for equipment (for smart button)
exports.getMaintenanceCount = async (req, res) => {
  try {
    const count = await MaintenanceRequest.countDocuments({
      equipment: req.params.id,
      status: { $in: ['New', 'In Progress', 'On Hold'] },
    });

    res.status(200).json({
      success: true,
      count: count,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Mark equipment as scrap
exports.scrapEquipment = async (req, res) => {
  try {
    const equipment = await Equipment.findByIdAndUpdate(
      req.params.id,
      {
        status: 'Scrap',
        notes: (req.body.reason || 'Equipment marked as scrap') + ` - ${new Date().toISOString()}`,
      },
      { new: true }
    ).populate(['assignedEmployee', 'maintenanceTeam', 'assignedTechnician']);

    // Update related maintenance requests to Scrap status
    await MaintenanceRequest.updateMany(
      { equipment: req.params.id, status: { $ne: 'Repaired' } },
      { status: 'Scrap' }
    );

    res.status(200).json({
      success: true,
      message: 'Equipment marked as scrap',
      data: equipment,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};
