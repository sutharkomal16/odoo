// Routes for Equipment, Maintenance Teams, and Maintenance Requests

const express = require('express');
const router = express.Router();

const equipmentController = require('../controllers/equipment.controller');
const maintenanceTeamController = require('../controllers/maintenance-team.controller');
const maintenanceRequestController = require('../controllers/maintenance-request.controller');

// ==================== EQUIPMENT ROUTES ====================
// Create equipment
router.post('/equipment', equipmentController.createEquipment);

// Get all equipment (with filters)
router.get('/equipment', equipmentController.getAllEquipment);

// Get equipment by ID
router.get('/equipment/:id', equipmentController.getEquipmentById);

// Update equipment
router.put('/equipment/:id', equipmentController.updateEquipment);

// Delete equipment
router.delete('/equipment/:id', equipmentController.deleteEquipment);

// Get maintenance requests for specific equipment
router.get('/equipment/:id/maintenance', equipmentController.getEquipmentMaintenance);

// Get open maintenance count for equipment (smart button)
router.get('/equipment/:id/maintenance-count', equipmentController.getMaintenanceCount);

// Mark equipment as scrap
router.patch('/equipment/:id/scrap', equipmentController.scrapEquipment);

// ==================== MAINTENANCE TEAM ROUTES ====================
// Create team
router.post('/teams', maintenanceTeamController.createTeam);

// Get all teams
router.get('/teams', maintenanceTeamController.getAllTeams);

// Get team by ID
router.get('/teams/:id', maintenanceTeamController.getTeamById);

// Update team
router.put('/teams/:id', maintenanceTeamController.updateTeam);

// Add member to team
router.post('/teams/:id/members', maintenanceTeamController.addTeamMember);

// Remove member from team
router.delete('/teams/:id/members', maintenanceTeamController.removeTeamMember);

// Delete/deactivate team
router.delete('/teams/:id', maintenanceTeamController.deleteTeam);

// ==================== MAINTENANCE REQUEST ROUTES ====================
// Create maintenance request (with auto-fill)
router.post('/requests', maintenanceRequestController.createMaintenanceRequest);

// Get all requests (with filters)
router.get('/requests', maintenanceRequestController.getAllRequests);

// Get request by ID
router.get('/requests/:id', maintenanceRequestController.getRequestById);

// Update request status (for Kanban drag & drop)
router.patch('/requests/:id/status', maintenanceRequestController.updateRequestStatus);

// Assign request to technician
router.patch('/requests/:id/assign', maintenanceRequestController.assignRequest);

// Get requests grouped by status (Kanban view)
router.get('/requests-kanban/all', maintenanceRequestController.getRequestsByStatus);

// Get preventive maintenance requests (for Calendar)
router.get('/requests/type/preventive', maintenanceRequestController.getPreventiveRequests);

// Get requests by date range
router.get('/requests/dates/range', maintenanceRequestController.getRequestsByDateRange);

// Get report: requests by team
router.get('/reports/by-team', maintenanceRequestController.getRequestsByTeam);

// Get report: requests by category
router.get('/reports/by-category', maintenanceRequestController.getRequestsByCategory);

// Delete request
router.delete('/requests/:id', maintenanceRequestController.deleteRequest);

module.exports = router;
