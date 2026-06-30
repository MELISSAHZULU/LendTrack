import 'package:flutter/material.dart';
import 'package:lendtrack_app/presentation/screens/auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile
          const Text('Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white)),
              title: const Text('Admin User'),
              subtitle: const Text('admin@lendtrack.com'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),

          // Payment Settings
          const Text('Payment Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildSettingItem(Icons.percent, 'Default Interest Rate', '10% per annum'),
                const Divider(height: 1),
                _buildSettingItem(Icons.payment, 'Payment Method', 'PayChangu'),
                const Divider(height: 1),
                _buildSettingItem(Icons.attach_money, 'Currency', 'MK (Malawian Kwacha)'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Security
          const Text('Security', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildSettingItem(Icons.lock_outline, 'Change Password', ''),
                const Divider(height: 1),
                _buildSettingItem(Icons.fingerprint, 'Biometric Login', 'Enabled'),
                const Divider(height: 1),
                _buildSettingItem(Icons.security, 'Two-Factor Auth', 'Disabled'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About
          Card(
            child: Column(
              children: [
                _buildSettingItem(Icons.info_outline, 'Version', '1.0.0'),
                const Divider(height: 1),
                _buildSettingItem(Icons.description_outlined, 'Terms & Conditions', ''),
                const Divider(height: 1),
                _buildSettingItem(Icons.privacy_tip_outlined, 'Privacy Policy', ''),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 22),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
