import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/models/vendor_model.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/responsive_helper.dart';
import '../utils/date_formatter.dart';
import 'login_screen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _applicationIdController = TextEditingController();
  bool _hasSearched = false;

  @override
  void dispose() {
    _applicationIdController.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final appId = _applicationIdController.text.trim();
    if (appId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Application ID')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final status = await authProvider.getApplicationStatus(appId);

    if (status != null && mounted) {
      setState(() {
        _hasSearched = true;
      });

      showDialog(
        context: context,
        builder: (context) => StatusDialog(status: status),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to get status'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Your Application',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(5),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(1)),
            Text(
              'Enter your Application ID to check the status',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(3.5),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(3)),
            CustomTextField(
              controller: _applicationIdController,
              label: 'Application ID',
              hint: 'e.g., APP-1234567890-abc123',
              prefixIcon: Icons.numbers,
            ),
            SizedBox(height: ResponsiveHelper.h(3)),
            CustomButton(
              text: 'Check Status',
              onPressed: _checkStatus,
            ),
            if (_hasSearched) ...[
              SizedBox(height: ResponsiveHelper.h(3)),
              _buildStatusInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: ResponsiveHelper.w(2)),
              Expanded(
                child: Text(
                  'Your Application ID is sent to your registered email address after submission.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(3.2),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusDialog extends StatelessWidget {
  final ApplicationStatusResponse status;

  const StatusDialog({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            status.status == 'approved'
                ? Icons.check_circle
                : status.status == 'rejected'
                    ? Icons.cancel
                    : Icons.pending,
          ),
          SizedBox(width: ResponsiveHelper.w(2)),
          // Text(status.statusText),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow('Application ID', status.applicationId),
            _buildInfoRow('Farmhouse Name', status.farmhouseName),
            _buildInfoRow(
                'Submitted Date', DateFormatter.formatDate(status.submittedAt)),
            if (status.reviewedAt != null)
              _buildInfoRow('Reviewed Date',
                  DateFormatter.formatDate(status.reviewedAt!)),
            if (status.adminNotes != null)
              _buildInfoRow('Admin Notes', status.adminNotes!),
            if (status.rejectedReason != null)
              _buildInfoRow('Rejection Reason', status.rejectedReason!),
            if (status.credentials != null) ...[
              const Divider(),
              const Text(
                'Login Credentials',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: ResponsiveHelper.h(1)),
              _buildInfoRow('Username', status.credentials!.vendorName),
              _buildInfoRow('Password', status.credentials!.password),
              SizedBox(height: ResponsiveHelper.h(2)),
              CustomButton(
                text: 'Go to Login',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.w(25),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
