import 'package:flutter/material.dart';
import '../theme/premium_theme.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Mock user database
  static const Map<String, String> users = {
    'admin': 'admin',
    'MECHANIC': 'MECHANIC',
    'ELECTRICIAN': 'ELECTRICIAN',
    'IT_SUPPORT': 'IT_SUPPORT',
  };

  static const Map<String, String> roleMap = {
    'admin': 'ADMIN',
    'MECHANIC': 'MECHANIC',
    'ELECTRICIAN': 'ELECTRICIAN',
    'IT_SUPPORT': 'IT_SUPPORT',
  };

  String? _currentUser;
  String? _currentRole;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;
  String? get currentRole => _currentRole;

  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (users.containsKey(username) && users[username] == password) {
      _currentUser = username;
      _currentRole = roleMap[username];
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _currentRole = null;
    _isAuthenticated = false;
  }
}
