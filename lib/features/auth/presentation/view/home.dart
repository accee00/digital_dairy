import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MilkMate Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMilkSummaryCard(),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 16),
            _buildCattleHealthAlerts(),
            const SizedBox(height: 16),
            _buildReminders(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: context.colorScheme.primary,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: context.colorScheme.primary,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Milk Log'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Cattle'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildMilkSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Today\'s Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('🥛 Morning: 12 L'),
            Text('🌙 Evening: 10 L'),
            Text('🧮 Total: 22 L'),
            Text('💰 Income: ₹660'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(Icons.add, 'Milk Entry', () {}),
        _actionButton(Icons.pets, 'New Cattle', () {}),
        _actionButton(Icons.attach_money, 'Income/Expense', () {}),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          child: IconButton(icon: Icon(icon), onPressed: onPressed),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }

  Widget _buildCattleHealthAlerts() {
    return Card(
      color: Colors.orange[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🐄 Cattle Health Alerts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('⚠️ Cow #12 missed milking today'),
            Text('💉 Vaccination due for Cow #7'),
            Text('🩺 Pregnancy check reminder'),
          ],
        ),
      ),
    );
  }

  Widget _buildReminders() {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('🔔 Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('🕗 Feed time for Cow #3'),
            Text('💊 Medicine for Cow #5 at 4 PM'),
          ],
        ),
      ),
    );
  }
}
