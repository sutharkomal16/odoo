const express = require("express");
const router = express.Router();
const userController = require("../controllers/user.controller");
const { mockUsers } = require("../data/mock-data");

// User CRUD routes
router.post("/", userController.createUser);
router.get("/", userController.getAllUsers);
router.get("/stats/roles", userController.getRoleStats);
router.get("/by-role/:role", userController.getUsersByRole);
router.get("/:id", userController.getUserById);
router.get("/:id/permissions", userController.checkPermissions);
router.put("/:id", userController.updateUser);
router.delete("/:id", userController.deleteUser);

// Mock data endpoint for testing
router.get("/mock/reset", (req, res) => {
  res.json({
    message: "Mock data available. App will use in-memory data.",
    users: mockUsers.length,
  });
});

module.exports = router;
