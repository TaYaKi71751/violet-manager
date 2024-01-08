import 'package:flutter/material.dart';
import 'package:violet_manager/page/home.dart';
import 'package:violet_manager/page/settings.dart';

/// Flutter code sample for [NavigationBar].

// void main() => runApp(const NavigationBarApp());
// https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationPage(),
    );
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: HomePage()
            )
          ),
        ),
        /// Settings page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: SettingsPage()
            )
          ),
        ),
      ][currentPageIndex],
    );
  }
}
