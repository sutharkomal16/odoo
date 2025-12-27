const db = require("../config/db");

const getUsers = async () => {
  const result = await db.query("SELECT * FROM users");
  return result.rows;
};

const addUser = async (name, email) => {
  await db.query(
    "INSERT INTO users (name, email) VALUES ($1, $2)",
    [name, email]
  );
};

module.exports = { getUsers, addUser };
