import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/equipment_list_screen.dart';
import 'screens/kanban_board_screen.dart';
import 'screens/calendar_view_screen.dart';
import 'screens/reports_screen.dart';
import 'theme/premium_theme.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: PremiumTheme.getLightTheme(),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MaintenanceManagementApp(),
        '/equipment': (context) => const EquipmentListScreen(),
        '/kanban': (context) => const KanbanBoardScreen(),
        '/calendar': (context) => const CalendarViewScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    // Check if user is already authenticated
    if (authService.isAuthenticated) {
      return const MaintenanceManagementApp();
    }
    
    return const LoginScreen();
  }
}

class MaintenanceManagementApp extends StatefulWidget {
  const MaintenanceManagementApp({Key? key}) : super(key: key);

  @override
  State<MaintenanceManagementApp> createState() =>
      _MaintenanceManagementAppState();
}

class _MaintenanceManagementAppState extends State<MaintenanceManagementApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const EquipmentListScreen(),
    const KanbanBoardScreen(),
    const CalendarViewScreen(),
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Equipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_kanban),
            label: 'Kanban',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}
