const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/flutter_db';
    await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000,
    });
    console.log('✅ MongoDB connected successfully');
  } catch (error) {
    console.error('⚠️  MongoDB connection failed:', error.message);
    console.log('📝 Running in development mode without MongoDB');
    console.log('💡 To fix: Update MONGODB_URI in .env with your MongoDB Atlas credentials');
    // Don't exit - allow the app to run with mock data
  }
};

module.exports = connectDB;
