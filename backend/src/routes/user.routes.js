const express = require("express");
const router = express.Router();
const controller = require("../controllers/user.controller");

router.get("/", controller.getAllUsers);
router.post("/", controller.createUser);

module.exports = router;
