import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/job_discovery/presentation/screens/discovery_screen.dart';
import '../../features/application_tracker/presentation/screens/tracker_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// Alternative navigation using IndexedStack for persistent bottom navigation
/// This preserves state automatically and has no transitions between tabs
class IndexedStackNavigation extends StatefulWidget {
  const IndexedStackNavigation({super.key});

  @override
  State<IndexedStackNavigation> createState() => _IndexedStackNavigationState();
}

class _IndexedStackNavigationState extends State<IndexedStackNavigation> {
  int _currentIndex = 0;

  // Define your tab screens here
  final List<Widget> _screens = const [
    DiscoveryScreen(),
    TrackerScreen(),
    ProfileScreen(),
  ];

  // Tab navigation data
  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.explore_outlined),
      activeIcon: Icon(Icons.explore),
      label: 'Discover',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.work_outline),
      activeIcon: Icon(Icons.work),
      label: 'Applications',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: _navItems,
        ),
      ),
    );
  }
}

/// Extension to add navigation helpers if needed
extension IndexedStackNavigationExtension on _IndexedStackNavigationState {
  /// Navigate to specific tab programmatically
  void navigateToTab(int index) {
    if (index >= 0 && index < _screens.length) {
      _onTabSelected(index);
    }
  }
  
  /// Get current tab index
  int get currentTabIndex => _currentIndex;
  
  /// Get current screen widget
  Widget get currentScreen => _screens[_currentIndex];
}

/// Static helper class for external navigation to tabs
class TabNavigator {
  static final GlobalKey<_IndexedStackNavigationState> _navKey = 
      GlobalKey<_IndexedStackNavigationState>();
  
  /// Set the navigation key (call this when creating IndexedStackNavigation)
  static void setNavigationKey(GlobalKey<_IndexedStackNavigationState> key) {
    // This allows external navigation if needed
  }
  
  /// Navigate to specific tab from anywhere in the app
  static void navigateToTab(int index) {
    _navKey.currentState?.navigateToTab(index);
  }
  
  /// Tab indices for easy reference
  static const int discoverTab = 0;
  static const int applicationsTab = 1;
  static const int profileTab = 2;
} 