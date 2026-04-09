import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vendor_provider.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../utils/date_formatter.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  bool _isLoading = true;
  double _totalRevenue = 0;
  int _totalBookings = 0;
  List<dynamic> _monthlyData = [];

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getBookings();

    final bookings = vendorProvider.bookings;
    final completedBookings = bookings.where((b) => b.isCompleted).toList();

    _totalRevenue =
        completedBookings.fold<double>(0, (sum, b) => sum + b.totalAmount);
    _totalBookings = completedBookings.length;

    // Group by month
    final Map<String, double> monthlyMap = {};
    for (var booking in completedBookings) {
      final month =
          DateFormatter.formatDate(booking.createdAt, pattern: 'MMM yyyy');
      monthlyMap[month] = (monthlyMap[month] ?? 0) + booking.totalAmount;
    }

    _monthlyData = monthlyMap.entries
        .map((e) => {
              'month': e.key,
              'revenue': e.value,
            })
        .toList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEarnings,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    SizedBox(height: ResponsiveHelper.h(3)),
                    _buildMonthlyChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.5),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${_totalRevenue.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(7),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(3)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.attach_money,
                    size: ResponsiveHelper.w(8),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            const Divider(),
            SizedBox(height: ResponsiveHelper.h(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total Bookings',
                  _totalBookings.toString(),
                  Icons.book_online,
                ),
                _buildStatItem(
                  'Average Booking',
                  '₹${_totalBookings > 0 ? (_totalRevenue / _totalBookings).toStringAsFixed(0) : '0'}',
                  Icons.trending_up,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: ResponsiveHelper.sp(5), color: AppColors.primary),
        SizedBox(height: ResponsiveHelper.h(1)),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(5),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(3),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Revenue',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(4.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            if (_monthlyData.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.h(5)),
                  child: Text(
                    'No revenue data available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveHelper.sp(3.5),
                    ),
                  ),
                ),
              )
            else
              ..._monthlyData.map((data) {
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveHelper.h(2)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['month'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(3.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${data['revenue'].toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(3.5),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(1)),
                      LinearProgressIndicator(
                        value: data['revenue'] / _totalRevenue,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        color: AppColors.primary,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
