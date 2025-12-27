const User = require("../models/user.model");

exports.getAllUsers = async (req, res) => {
  const users = await User.getUsers();
  res.json(users);
};

exports.createUser = async (req, res) => {
  const { name, email } = req.body;
  await User.addUser(name, email);
  res.json({ message: "User added" });
};
