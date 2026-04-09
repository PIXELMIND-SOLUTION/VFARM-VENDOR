import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/contact_screen.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../utils/responsive_helper.dart';
import 'login_screen.dart';
import 'farmhouse_update_screen.dart';
import 'earnings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.w(4)),
            child: Column(
              children: [
                _buildProfileHeader(authProvider),
                SizedBox(height: ResponsiveHelper.h(3)),
                _buildMenuItems(context),
                SizedBox(height: ResponsiveHelper.h(3)),
                _buildLogoutButton(context, authProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authProvider.vendor?.name ?? 'Vendor Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  authProvider.vendor?.email ?? 'vendor@email.com',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ResponsiveHelper.h(1)),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(2),
                    vertical: ResponsiveHelper.h(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    authProvider.vendor?.statusText ?? 'Approved',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version ${AppConstants.appVersion}',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          const Divider(height: 1),

          _buildMenuItem(
            icon: Icons.edit,
            title: 'Farmhouse Details',
            subtitle: 'View and update farmhouse',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const FarmhouseUpdateScreen()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.attach_money,
            title: 'Earnings',
            subtitle: 'View revenue and payouts',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EarningsScreen()),
              );
            },
          ),
          // const Divider(height: 1),
          // _buildMenuItem(
          //   icon: Icons.notifications,
          //   title: 'Notifications',
          //   subtitle: 'Manage notifications',
          //   onTap: () {
          //     // Navigate to notifications (coming soon)
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('Notifications feature coming soon!'),
          //         duration: Duration(seconds: 2),
          //       ),
          //     );
          //   },
          // ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return CustomButton(
      text: 'Logout',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          await authProvider.logout();
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        }
      },
      backgroundColor: AppColors.error,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home_work, size: 50, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              AppConstants.appName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Version ${AppConstants.appVersion}'),
            const SizedBox(height: 10),
            const Text(
              'Farmhouse Vendor Management App',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
