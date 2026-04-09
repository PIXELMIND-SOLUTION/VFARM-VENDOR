import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Contact V Farm House'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildHeader(),
            const SizedBox(height: 32),
            _buildContactCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFECDD3), Color(0xFFFBCFE8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.headset_mic,
              size: 48,
              color: Color(0xFFE11D48),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contact V Farm House',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "We're here to help with bookings, support, and any questions about your farmhouse experience.",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFECDD3),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Text(
              'Operated by VARAHI AUTOMOTIVES AND TRAVELS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFBE123C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCards() {
    final contactPoints = [
      ContactPoint(
        icon: Icons.email_outlined,
        title: 'Email Support',
        details: ['support@vfarmhouses.com', 'justforfun54992@gmail.com'],
        response: 'Response within 4 hours',
        gradientColors: [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
      ),
      ContactPoint(
        icon: Icons.phone_outlined,
        title: 'Phone Support',
        details: ['+91 95738 19495', '+91 82474 02358'],
        response: 'Available 9 AM - 7 PM',
        gradientColors: [const Color(0xFFA855F7), const Color(0xFF8B5CF6)],
      ),
      ContactPoint(
        icon: Icons.access_time_outlined,
        title: 'Business Hours',
        details: ['Monday - Saturday', '9:00 AM - 7:00 PM IST'],
        response: 'Closed on Sundays',
        gradientColors: [const Color(0xFF3B82F6), const Color(0xFF06B6D4)],
      ),
      ContactPoint(
        icon: Icons.location_on_outlined,
        title: 'Registered Office',
        details: [
          'Plot No 358, Teachers Colony',
          'Bn Reddy Nagar, Hyderabad Rangareddy',
          'Telangana 500070, India'
        ],
        response: 'By appointment only',
        gradientColors: [const Color(0xFFF59E0B), const Color(0xFFF97316)],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: contactPoints.length,
        itemBuilder: (context, index) {
          return _buildContactCard(contactPoints[index]);
        },
      ),
    );
  }

  Widget _buildContactCard(ContactPoint point) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: point.gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: point.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          point.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...point.details.map((detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          detail,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      )),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        point.response,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper classes
class ContactPoint {
  final IconData icon;
  final String title;
  final List<String> details;
  final String response;
  final List<Color> gradientColors;

  ContactPoint({
    required this.icon,
    required this.title,
    required this.details,
    required this.response,
    required this.gradientColors,
  });
}

class SupportFeature {
  final IconData icon;
  final String text;
  final String subtext;

  SupportFeature({
    required this.icon,
    required this.text,
    required this.subtext,
  });
}

class CommonQuery {
  final String question;
  final String answer;

  CommonQuery({
    required this.question,
    required this.answer,
  });
}
