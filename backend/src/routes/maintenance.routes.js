// Routes for Equipment, Maintenance Teams, and Maintenance Requests

const express = require('express');
const router = express.Router();

// Using mock-data controller for development
const mockController = require('../controllers/mock-data.controller');

// ==================== EQUIPMENT ROUTES ====================
// Create equipment
router.post('/equipment', mockController.createEquipment);

// Get all equipment (with filters)
router.get('/equipment', mockController.getAllEquipment);

// Get equipment by ID
router.get('/equipment/:id', mockController.getEquipmentById);

// Update equipment
router.put('/equipment/:id', mockController.updateEquipment);

// Delete equipment
router.delete('/equipment/:id', mockController.deleteEquipment);

// Get maintenance requests for specific equipment
router.get('/equipment/:id/maintenance', mockController.getEquipmentMaintenance);

// Get open maintenance count for equipment (smart button)
router.get('/equipment/:id/maintenance-count', mockController.getMaintenanceCount);

// ==================== MAINTENANCE TEAM ROUTES ====================
// Create team
router.post('/teams', mockController.createTeam);

// Get all teams
router.get('/teams', mockController.getAllTeams);

// Get team by ID
router.get('/teams/:id', mockController.getTeamById);

// Update team
router.put('/teams/:id', mockController.updateTeam);

// Delete/deactivate team
router.delete('/teams/:id', mockController.deleteTeam);

// ==================== MAINTENANCE REQUEST ROUTES ====================
// Create maintenance request (with auto-fill)
router.post('/requests', mockController.createRequest);

// Get all requests (with filters)
router.get('/requests', mockController.getAllRequests);

// Get request by ID
router.get('/requests/:id', mockController.getRequestById);

// Update request status (for Kanban drag & drop)
router.patch('/requests/:id/status', mockController.updateRequestStatus);

// Delete request
router.delete('/requests/:id', mockController.deleteRequest);

module.exports = router;
