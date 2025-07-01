import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/onboarding/presentation/screens/profile_setup_screen.dart';
import '../../features/job_discovery/presentation/screens/discovery_screen.dart';
import '../../features/job_details/presentation/screens/job_details_screen.dart';
import '../../features/application_tracker/presentation/screens/tracker_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

// Smooth ease in/out transition
Page<T> buildPageWithNativeTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Subtle slide with smooth ease in/out
      return SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(0.15, 0.0), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
        ),
        child: FadeTransition(
          opacity: animation.drive(
            Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      );
    },
  );
}

// Smooth fade for main nav
Page<T> buildPageWithNoTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
        ),
        child: child,
      );
    },
  );
}

// Instant transition for tab switching (no animation)
Page<T> buildPageWithInstantTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return NoTransitionPage<T>(
    key: state.pageKey,
    child: child,
  );
}

// App routes
class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profileSetup = '/profile-setup';
  static const String discovery = '/discovery';
  static const String jobDetails = '/job-details';
  static const String tracker = '/tracker';
  static const String profile = '/profile';
}

// Router configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,
    routes: [
      // Welcome & Authentication (outside main app shell)
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        pageBuilder: (context, state) => buildPageWithNoTransition(context, state, const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => buildPageWithNativeTransition(context, state, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) => buildPageWithNativeTransition(context, state, const SignupScreen()),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        name: 'profile-setup',
        pageBuilder: (context, state) => buildPageWithNativeTransition(context, state, const ProfileSetupScreen()),
      ),
      
      // Main App Shell with persistent bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Main tabs with instant switching and state preservation
          GoRoute(
            path: AppRoutes.discovery,
            name: 'discovery',
            pageBuilder: (context, state) => buildPageWithInstantTransition(context, state, const DiscoveryScreen()),
          ),
          GoRoute(
            path: AppRoutes.tracker,
            name: 'tracker',
            pageBuilder: (context, state) => buildPageWithInstantTransition(context, state, const TrackerScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => buildPageWithInstantTransition(context, state, const ProfileScreen()),
          ),
          
          // Detail screens (slide transition, but within shell)
          GoRoute(
            path: '${AppRoutes.jobDetails}/:jobId',
            name: 'job-details',
            pageBuilder: (context, state) {
              final jobId = state.pathParameters['jobId']!;
              return buildPageWithNativeTransition(context, state, JobDetailsScreen(jobId: jobId));
            },
          ),
        ],
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.welcome),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Alias for easier access
final appRouterProvider = goRouterProvider; 