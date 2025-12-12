// lib/pages/settings.dart (Serving the Farmer role)
import 'package:flutter/material.dart';
import '../utils/supabase_service.dart';
import '../widgets/bottom_nav.dart'; 
import 'login_farmer.dart';

class SettingsPage extends StatefulWidget { 
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SupabaseService _supabaseService = SupabaseService();
  String _fullName = 'Loading...';
  String _email = 'Loading...';
  String _phone = 'N/A';
  String _location = 'N/A'; // Stores Farm Location
  String _role = 'Farmer'; // Default
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _fullName = 'Not Logged In';
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final response = await supabase
          .from('profiles')
          .select('full_name, email, phone_number, farm_location, role')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _fullName = response['full_name'] ?? 'No Name Set';
          _email = response['email'] ?? user.email ?? 'No Email';
          _phone = response['phone_number'] ?? 'N/A';
          _location = response['farm_location'] ?? 'N/A';
          _role = response['role'] ?? 'Farmer';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fullName = 'Error loading profile';
          _isLoading = false;
        });
      }
      print('Error fetching profile: $e');
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _supabaseService.signOut();
      if (mounted) {
        // Navigate to login page and clear the entire navigation stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginFarmerPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Profile Card
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D5F3F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF9BB8A3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Profile Icon
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF2D5F3F),
                                size: 35,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Name and Role (DYNAMIC)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _fullName, // DYNAMIC NAME
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _role, // DYNAMIC ROLE
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Edit Button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Contact Information (DYNAMIC)
                        _buildInfoRow('Email', _email),
                        const SizedBox(height: 10),
                        _buildInfoRow('Phone', _phone),
                        const SizedBox(height: 10),
                        _buildInfoRow('Location', _location), // Uses _location for Farmer
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Settings Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSettingsTile(context, icon: Icons.lock_outline, title: 'Change Password', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildSettingsTile(context, icon: Icons.notifications_outlined, title: 'Notification Preferences', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildSettingsTile(context, icon: Icons.language, title: 'Language', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildSettingsTile(context, icon: Icons.person_outline, title: 'Contact Admin', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildSettingsTile(context, icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildSettingsTile(context, icon: Icons.description_outlined, title: 'Terms of Service', onTap: () {}),
                  const SizedBox(height: 20),

                  // Logout Button
                  InkWell(
                    onTap: _isLoading ? null : () => _showLogoutDialog(context),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9BB8A3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: _isLoading ? Colors.grey : const Color(0xFF2D5F3F),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF2D5F3F)),
                                )
                              : const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Color(0xFF2D5F3F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF9BB8A3),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2D5F3F),
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF2D5F3F),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F3F),
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5F3F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}