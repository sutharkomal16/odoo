// Mock Data Controller
// Returns mock data for development/testing

const {
  mockUsers,
  mockEquipment,
  mockTeams,
  mockRequests,
} = require('../data/mock-data');

// ==================== EQUIPMENT ENDPOINTS ====================
exports.getAllEquipment = (req, res) => {
  const { department, category, status } = req.query;
  
  let filtered = [...mockEquipment];
  
  if (department) filtered = filtered.filter(e => e.department === department);
  if (category) filtered = filtered.filter(e => e.category === category);
  if (status) filtered = filtered.filter(e => e.status === status);
  
  res.json({
    success: true,
    data: filtered,
  });
};

exports.getEquipmentById = (req, res) => {
  const equipment = mockEquipment.find(e => e._id === req.params.id);
  
  if (!equipment) {
    return res.status(404).json({
      success: false,
      message: 'Equipment not found',
    });
  }
  
  res.json({
    success: true,
    data: equipment,
  });
};

exports.createEquipment = (req, res) => {
  const { name, serialNumber, category, department, status } = req.body;
  
  const newEquipment = {
    _id: (mockEquipment.length + 1).toString(),
    name,
    serialNumber,
    category,
    department,
    status: status || 'Active',
    installDate: new Date().toISOString().split('T')[0],
    lastMaintenance: new Date().toISOString().split('T')[0],
    nextMaintenance: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
    maintenanceFrequency: 30,
  };
  
  mockEquipment.push(newEquipment);
  res.status(201).json({
    success: true,
    data: newEquipment,
  });
};

exports.updateEquipment = (req, res) => {
  const index = mockEquipment.findIndex(e => e._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Equipment not found',
    });
  }
  
  mockEquipment[index] = { ...mockEquipment[index], ...req.body };
  res.json({
    success: true,
    data: mockEquipment[index],
  });
};

exports.deleteEquipment = (req, res) => {
  const index = mockEquipment.findIndex(e => e._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Equipment not found',
    });
  }
  
  mockEquipment.splice(index, 1);
  res.json({
    success: true,
  });
};

exports.getEquipmentMaintenance = (req, res) => {
  const requests = mockRequests.filter(r => r.equipment === req.params.id);
  res.json({
    success: true,
    data: requests,
  });
};

exports.getMaintenanceCount = (req, res) => {
  const count = mockRequests.filter(r => r.equipment === req.params.id && r.status !== 'Completed').length;
  res.json({
    success: true,
    count: count,
  });
};

// ==================== TEAM ENDPOINTS ====================
exports.getAllTeams = (req, res) => {
  res.json({
    success: true,
    data: mockTeams,
  });
};

exports.getTeamById = (req, res) => {
  const team = mockTeams.find(t => t._id === req.params.id);
  
  if (!team) {
    return res.status(404).json({
      success: false,
      message: 'Team not found',
    });
  }
  
  res.json({
    success: true,
    data: team,
  });
};

exports.createTeam = (req, res) => {
  const { name, specialization, leader, location } = req.body;
  
  const newTeam = {
    _id: (mockTeams.length + 1).toString(),
    name,
    specialization,
    leader,
    members: [],
    location: location || 'TBD',
    status: 'Active',
  };
  
  mockTeams.push(newTeam);
  res.status(201).json({
    success: true,
    data: newTeam,
  });
};

exports.updateTeam = (req, res) => {
  const index = mockTeams.findIndex(t => t._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Team not found',
    });
  }
  
  mockTeams[index] = { ...mockTeams[index], ...req.body };
  res.json({
    success: true,
    data: mockTeams[index],
  });
};

exports.deleteTeam = (req, res) => {
  const index = mockTeams.findIndex(t => t._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Team not found',
    });
  }
  
  mockTeams.splice(index, 1);
  res.json({
    success: true,
  });
};

// ==================== REQUEST ENDPOINTS ====================
exports.getAllRequests = (req, res) => {
  const { status, type, priority } = req.query;
  
  let filtered = [...mockRequests];
  
  if (status) filtered = filtered.filter(r => r.status === status);
  if (type) filtered = filtered.filter(r => r.type === type);
  if (priority) filtered = filtered.filter(r => r.priority === priority);
  
  res.json({
    success: true,
    data: filtered,
  });
};

exports.getRequestById = (req, res) => {
  const request = mockRequests.find(r => r._id === req.params.id);
  
  if (!request) {
    return res.status(404).json({
      success: false,
      message: 'Request not found',
    });
  }
  
  res.json({
    success: true,
    data: request,
  });
};

exports.createRequest = (req, res) => {
  const {
    title,
    type,
    equipment,
    department,
    priority,
    description,
    assignedTo,
    requestedBy,
  } = req.body;
  
  const newRequest = {
    _id: (mockRequests.length + 1).toString(),
    title,
    type,
    equipment,
    department,
    status: 'New',
    priority: priority || 'Medium',
    description,
    assignedTo,
    requestedBy,
    createdDate: new Date().toISOString().split('T')[0],
  };
  
  mockRequests.push(newRequest);
  res.status(201).json({
    success: true,
    data: newRequest,
  });
};

exports.updateRequest = (req, res) => {
  const index = mockRequests.findIndex(r => r._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Request not found',
    });
  }
  
  mockRequests[index] = { ...mockRequests[index], ...req.body };
  res.json({
    success: true,
    data: mockRequests[index],
  });
};

exports.updateRequestStatus = (req, res) => {
  const { status, completionNotes, duration } = req.body;
  const index = mockRequests.findIndex(r => r._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Request not found',
    });
  }
  
  mockRequests[index] = {
    ...mockRequests[index],
    status,
    completionNotes,
    duration,
    completedDate: status === 'Completed' ? new Date().toISOString().split('T')[0] : null,
  };
  
  res.json({
    success: true,
    data: mockRequests[index],
  });
};

exports.deleteRequest = (req, res) => {
  const index = mockRequests.findIndex(r => r._id === req.params.id);
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Request not found',
    });
  }
  
  mockRequests.splice(index, 1);
  res.json({
    success: true,
  });
};
