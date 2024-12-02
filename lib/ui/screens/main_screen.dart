import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/cancelled_task_screen.dart';
import 'package:myapp/ui/screens/completed_task_screen.dart';
import 'package:myapp/ui/screens/new_task_screen.dart';
import 'package:myapp/ui/screens/progress_task_screen.dart';

import '../widgets/app_bar_header.dart';

class MainScreen extends StatefulWidget {
  static const String name = '/main-screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const CancelledTaskScreen(),
    const ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHeader(),
      bottomNavigationBar: _buildNavigationBar(),
      body: _screens[_selectedIndex],
    );
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.new_releases_outlined), label: 'New'),
        NavigationDestination(
            icon: Icon(Icons.check_circle_outline), label: 'Completed'),
        NavigationDestination(
            icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
        NavigationDestination(
            icon: Icon(Icons.incomplete_circle_outlined), label: 'Progress'),
      ],
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
} // This is last curly brace
