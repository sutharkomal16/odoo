# Integration Guide: Adding User Management to Home Screen

## Overview
This guide explains how to integrate the new user management screens into the Gear Guard home screen module grid.

## Current Home Screen Structure

The home screen displays a grid of modules including:
- Equipment
- Teams
- Kanban Board
- Calendar View
- Reports

## Adding User Management Module

### Step 1: Update Home Screen Imports

Add the following import to `lib/screens/home_screen.dart`:

```dart
import 'screens/user_management_screen.dart';
import 'screens/role_dashboard_screen.dart';
```

### Step 2: Add User Management Navigation

In the module grid section of home screen, add:

```dart
_buildModuleCard(
  'Users',
  Icons.people,
  PremiumColors.accentGold,
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UserManagementScreen(),
      ),
    );
  },
),
```

### Step 3: Add Role Dashboard Module (Optional)

For role overview, add:

```dart
_buildModuleCard(
  'Roles',
  Icons.security,
  PremiumColors.statusInfo,
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleDashboardScreen(),
      ),
    );
  },
),
```

### Step 4: Update Grid Layout

If adding both modules, update the grid crossAxisCount:

**Current (2 columns):**
```dart
GridView.count(
  crossAxisCount: 2,
  ...
)
```

**For 3 columns (to fit 6+ modules):**
```dart
GridView.count(
  crossAxisCount: 2,  // Keep 2 for better spacing
  ...
)
```

Or use a flexible approach:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
    childAspectRatio: 1.2,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
  ),
  itemCount: modules.length,
  itemBuilder: (context, index) => _buildModuleCard(...),
)
```

## Full Integration Example

Here's a complete example of updated home screen module section:

```dart
// Module Grid
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Modules',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: PremiumColors.textPrimary,
        ),
      ),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          // Equipment
          _buildModuleCard(
            'Equipment',
            Icons.precision_manufacturing,
            PremiumColors.statusInfo,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EquipmentListScreen()),
            ),
          ),
          // Teams
          _buildModuleCard(
            'Teams',
            Icons.groups,
            PremiumColors.accentGold,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MaintenanceTeamScreen()),
            ),
          ),
          // Kanban
          _buildModuleCard(
            'Kanban',
            Icons.view_agenda,
            PremiumColors.statusSuccess,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KanbanBoardScreen()),
            ),
          ),
          // Calendar
          _buildModuleCard(
            'Calendar',
            Icons.calendar_month,
            PremiumColors.statusWarning,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarViewScreen()),
            ),
          ),
          // Users - NEW
          _buildModuleCard(
            'Users',
            Icons.people,
            PremiumColors.statusInfo,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManagementScreen()),
            ),
          ),
          // Roles - NEW (Optional)
          _buildModuleCard(
            'Roles',
            Icons.security,
            PremiumColors.accentGold,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoleDashboardScreen()),
            ),
          ),
        ],
      ),
    ],
  ),
),
```

## Settings/Admin Section Alternative

If you prefer to keep user management in a separate admin section rather than the main module grid, you can:

### 1. Create an Admin Screen

```dart
// lib/screens/admin_screen.dart
class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminMenuItem(
            context,
            'User Management',
            Icons.people,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManagementScreen()),
            ),
          ),
          _buildAdminMenuItem(
            context,
            'Role Dashboard',
            Icons.security,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoleDashboardScreen()),
            ),
          ),
          _buildAdminMenuItem(
            context,
            'Settings',
            Icons.settings,
            () => {/* Navigate to settings */},
          ),
        ],
      ),
    );
  }

  Widget _buildAdminMenuItem(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
```

### 2. Add Admin Icon to Home Screen Header

```dart
AppBar(
  title: const Text('Gear Guard'),
  actions: [
    IconButton(
      icon: const Icon(Icons.admin_panel_settings),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      ),
    ),
  ],
)
```

## Role-Based Visibility (Advanced)

To show user management only to ADMIN users, add:

```dart
// In home_screen.dart
bool _isAdmin = false;

@override
void initState() {
  super.initState();
  _checkUserRole();
}

void _checkUserRole() async {
  // Get current user from authentication/session
  // Set _isAdmin based on user role
}

// In module grid
if (_isAdmin)
  _buildModuleCard(
    'Users',
    Icons.people,
    () => Navigator.push(...),
  ),
```

## Screen Size Considerations

For responsive grid layout on different screen sizes:

```dart
// Update grid layout based on screen width
int crossAxisCount;
if (MediaQuery.of(context).size.width > 800) {
  crossAxisCount = 3;
} else if (MediaQuery.of(context).size.width > 600) {
  crossAxisCount = 2;
} else {
  crossAxisCount = 1;
}

GridView.count(
  crossAxisCount: crossAxisCount,
  ...
)
```

## Navigation Deep Link Support

To support deep linking to user management:

```dart
// In main.dart, add to named routes
Route<dynamic> Function(RouteSettings)? onGenerateRoute = (settings) {
  switch (settings.name) {
    case '/users':
      return MaterialPageRoute(builder: (_) => const UserManagementScreen());
    case '/users/:id':
      final userId = settings.name!.split('/').last;
      return MaterialPageRoute(
        builder: (_) => UserDetailScreen(userId: userId),
      );
    case '/roles':
      return MaterialPageRoute(builder: (_) => const RoleDashboardScreen());
    default:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
  }
};
```

## Quick Action Integration

Add user-related quick actions to the home screen:

```dart
// Quick Actions Section
Container(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      Expanded(
        child: _buildActionButton(
          'New User',
          Icons.person_add,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateUserScreen()),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _buildActionButton(
          'Users',
          Icons.people,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserManagementScreen()),
          ),
        ),
      ),
    ],
  ),
)
```

## Import All Required Classes

```dart
// In home_screen.dart
import '../screens/user_management_screen.dart';
import '../screens/user_detail_screen.dart';
import '../screens/create_user_screen.dart';
import '../screens/role_dashboard_screen.dart';
```

## Testing Integration

After adding user management to home screen, test:

1. **Navigation**
   - [ ] Tap Users module card → Opens UserManagementScreen
   - [ ] Tap Roles module card → Opens RoleDashboardScreen
   - [ ] Back button returns to home screen

2. **Functionality**
   - [ ] Create new user from Create User Screen
   - [ ] View user details
   - [ ] Delete user with confirmation
   - [ ] Filter users by role
   - [ ] View role statistics

3. **Styling**
   - [ ] Module cards display correctly
   - [ ] Colors match theme
   - [ ] Icons show properly
   - [ ] Grid layout responsive

4. **Performance**
   - [ ] Home screen loads quickly
   - [ ] No lag when opening user screens
   - [ ] API calls complete smoothly

## Common Issues & Solutions

### Issue: Import errors for new screens
**Solution:** Ensure all screen files are in `lib/screens/` directory

### Issue: Module grid too crowded
**Solution:** Reduce grid columns or move to separate admin section

### Issue: Missing role info in home screen
**Solution:** Fetch current user role in `initState()` and store in state variable

### Issue: Navigation not working
**Solution:** Check that MaterialPageRoute is properly imported and screen constructors are correct

## Code Snippet Library

### Module Card Builder
```dart
Widget _buildModuleCard(
  String label,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            PremiumColors.surfaceDark,
            PremiumColors.bgTertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: PremiumShadows.elevation1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PremiumColors.textPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
```

## Summary

The user management system integrates seamlessly with the home screen. You can:

1. **Add to main module grid** for quick access
2. **Create admin section** for cleaner organization
3. **Implement role-based visibility** for security
4. **Support deep linking** for advanced navigation
5. **Add quick actions** for common tasks

Choose the integration approach that best fits your application's information architecture.
