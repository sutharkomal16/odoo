// Maintenance Request Controller
// Handles maintenance request lifecycle and auto-fill logic

const MaintenanceRequest = require('../models/maintenance-request.model');
const Equipment = require('../models/equipment.model');

// Create a new maintenance request with auto-fill logic
exports.createMaintenanceRequest = async (req, res) => {
  try {
    const { type, subject, description, equipment, scheduledDate, priority, estimatedDuration } =
      req.body;

    // Fetch equipment to auto-fill category and team
    const equipmentData = await Equipment.findById(equipment);
    if (!equipmentData) {
      return res.status(404).json({
        success: false,
        message: 'Equipment not found',
      });
    }

    // Auto-fill logic
    const request = new MaintenanceRequest({
      type,
      subject,
      description,
      equipment,
      equipmentCategory: equipmentData.category,
      maintenanceTeam: equipmentData.maintenanceTeam,
      createdBy: req.user?.id || req.body.createdBy,
      scheduledDate: type === 'Preventive' ? scheduledDate : null,
      priority: priority || 'Medium',
      estimatedDuration: estimatedDuration || 0,
      status: 'New',
    });

    await request.save();
    await request.populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo']);

    res.status(201).json({
      success: true,
      data: request,
      message: 'Maintenance request created. Equipment category and team auto-filled.',
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Get all maintenance requests
exports.getAllRequests = async (req, res) => {
  try {
    const { status, type, equipment, team, priority } = req.query;
    let query = {};

    if (status) query.status = status;
    if (type) query.type = type;
    if (equipment) query.equipment = equipment;
    if (team) query.maintenanceTeam = team;
    if (priority) query.priority = priority;

    const requests = await MaintenanceRequest.find(query)
      .populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo'])
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: requests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get request by ID
exports.getRequestById = async (req, res) => {
  try {
    const request = await MaintenanceRequest.findById(req.params.id).populate([
      'equipment',
      'maintenanceTeam',
      'createdBy',
      'assignedTo',
    ]);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    res.status(200).json({
      success: true,
      data: request,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Update request status (Kanban drag & drop)
exports.updateRequestStatus = async (req, res) => {
  try {
    const { status, assignedTo, duration, completionNotes } = req.body;
    const request = await MaintenanceRequest.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    // Update status
    request.status = status;

    // Auto-fill dates based on status
    if (status === 'In Progress' && !request.startDate) {
      request.startDate = new Date();
    }

    if (status === 'Repaired') {
      request.completionDate = new Date();
      request.duration = duration || request.duration;
    }

    // Assign technician if provided
    if (assignedTo) {
      request.assignedTo = assignedTo;
    }

    // Add notes if provided
    if (completionNotes) {
      request.notes = (request.notes || '') + `\n[${new Date().toISOString()}] ${completionNotes}`;
    }

    await request.save();
    await request.populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo']);

    res.status(200).json({
      success: true,
      data: request,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Assign request to technician
exports.assignRequest = async (req, res) => {
  try {
    const { assignedTo } = req.body;

    const request = await MaintenanceRequest.findByIdAndUpdate(
      req.params.id,
      {
        assignedTo,
        status: 'In Progress',
        startDate: new Date(),
      },
      { new: true }
    ).populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo']);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    res.status(200).json({
      success: true,
      data: request,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Get requests by status for Kanban view
exports.getRequestsByStatus = async (req, res) => {
  try {
    const requests = await MaintenanceRequest.find({ status: { $ne: 'Scrap' } })
      .populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo'])
      .sort({ createdAt: -1 });

    // Group by status
    const grouped = {
      New: [],
      'In Progress': [],
      Repaired: [],
      'On Hold': [],
    };

    requests.forEach((req) => {
      if (grouped[req.status]) {
        grouped[req.status].push(req);
      }
    });

    res.status(200).json({
      success: true,
      data: grouped,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get preventive maintenance requests for calendar
exports.getPreventiveRequests = async (req, res) => {
  try {
    const requests = await MaintenanceRequest.find({
      type: 'Preventive',
      status: { $ne: 'Scrap' },
    })
      .populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo'])
      .sort({ scheduledDate: 1 });

    res.status(200).json({
      success: true,
      data: requests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get requests by date range
exports.getRequestsByDateRange = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    const requests = await MaintenanceRequest.find({
      $or: [
        { scheduledDate: { $gte: new Date(startDate), $lte: new Date(endDate) } },
        { createdAt: { $gte: new Date(startDate), $lte: new Date(endDate) } },
      ],
    })
      .populate(['equipment', 'maintenanceTeam', 'createdBy', 'assignedTo'])
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: requests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get report: requests by team
exports.getRequestsByTeam = async (req, res) => {
  try {
    const requests = await MaintenanceRequest.aggregate([
      {
        $match: { status: { $ne: 'Scrap' } },
      },
      {
        $group: {
          _id: '$maintenanceTeam',
          count: { $sum: 1 },
          openCount: {
            $sum: {
              $cond: [{ $in: ['$status', ['New', 'In Progress']] }, 1, 0],
            },
          },
        },
      },
      {
        $lookup: {
          from: 'maintenanceteams',
          localField: '_id',
          foreignField: '_id',
          as: 'teamInfo',
        },
      },
      { $unwind: '$teamInfo' },
      { $sort: { count: -1 } },
    ]);

    res.status(200).json({
      success: true,
      data: requests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get report: requests by equipment category
exports.getRequestsByCategory = async (req, res) => {
  try {
    const requests = await MaintenanceRequest.aggregate([
      {
        $match: { status: { $ne: 'Scrap' } },
      },
      {
        $group: {
          _id: '$equipmentCategory',
          count: { $sum: 1 },
          openCount: {
            $sum: {
              $cond: [{ $in: ['$status', ['New', 'In Progress']] }, 1, 0],
            },
          },
        },
      },
      { $sort: { count: -1 } },
    ]);

    res.status(200).json({
      success: true,
      data: requests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Delete request
exports.deleteRequest = async (req, res) => {
  try {
    const request = await MaintenanceRequest.findByIdAndDelete(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Request deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
