import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/constants/api_constants.dart';
import 'package:vendor_app/screens/contact_screen.dart';
import 'package:vendor_app/screens/home_screen.dart';
import 'package:vendor_app/screens/main_screen.dart';
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

    return WillPopScope(
      onWillPop: () async {
        // Navigate to home screen when back button is pressed
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        return false; // Prevent default back behavior
      },
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.w(4)),
              child: Column(
                children: [
                  _buildProfileHeader(authProvider),
                  SizedBox(height: ResponsiveHelper.h(3)),
                  _buildMenuItems(context, authProvider),
                  SizedBox(height: ResponsiveHelper.h(3)),
                  _buildLogoutButton(context, authProvider),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _buildMenuItems(BuildContext context, AuthProvider authProvider) {
    return Card(
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About Us',
            subtitle: 'Checkout our profile',
            onTap: () => _launchURL(ApiConstants.about),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.edit,
            title: 'Farmhouse Details',
            subtitle: 'View and edit farmhouse',
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
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => _launchURL(ApiConstants.privacyPolicyUrl),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read terms and conditions',
            onTap: () => _launchURL(ApiConstants.termsAndConditionsUrl),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () => _showDeleteAccountConfirmation(context, authProvider),
            isDestructive: true,
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
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive ? AppColors.error : AppColors.primary),
      title: Text(title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : null,
          )),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right,
          color: isDestructive ? AppColors.error : null),
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Future<void> _showDeleteAccountConfirmation(
      BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(color: AppColors.error),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'This action is irreversible and will:',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 8),
            Text(
              '• Permanently delete all your personal data\n'
              '• Remove all your farmhouse listings\n'
              '• Delete your earnings history\n'
              '• Cancel all active bookings\n'
              '• You will lose access to your account forever',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _deleteAccount(context, authProvider);
    }
  }

  Future<void> _deleteAccount(
      BuildContext context, AuthProvider authProvider) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call your API to delete account
      final success = await authProvider.deleteAccount();

      // Close loading dialog if it's still showing
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (success && context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else if (context.mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete account. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if it's still showing
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
