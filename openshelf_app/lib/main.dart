import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/welcome_screen.dart';
import 'screens/responsive_home.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/demo_hub.dart';
import 'screens/widget_tree_demo.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/hot_reload_devtools_demo.dart';
import 'screens/navigation_hub.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_about_screens.dart';
import 'screens/responsive_layout.dart';
import 'screens/scrollable_views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenShelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/responsive': (context) => const ResponsiveHome(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/demo-hub': (context) => const DemoHub(),
        '/widget-tree-demo': (context) => const WidgetTreeDemo(),
        '/stateless-stateful-demo': (context) => const StatelessStatefulDemo(),
        '/hot-reload-devtools-demo': (context) => const HotReloadDevtoolsDemo(),
        '/navigation-hub': (context) => const NavigationHub(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/responsive-layout': (context) => ResponsiveLayout(),
        '/scrollable-views': (context) => const ScrollableViews(),
      },
    );
  }
}
