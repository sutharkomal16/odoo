const express = require("express");
const router = express.Router();
const userController = require("../controllers/user.controller");

// User CRUD routes
router.post("/", userController.createUser);
router.get("/", userController.getAllUsers);
router.get("/stats/roles", userController.getRoleStats);
router.get("/by-role/:role", userController.getUsersByRole);
router.get("/:id", userController.getUserById);
router.get("/:id/permissions", userController.checkPermissions);
router.put("/:id", userController.updateUser);
router.delete("/:id", userController.deleteUser);

module.exports = router;
