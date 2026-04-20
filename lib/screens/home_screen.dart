import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/bookings_screen.dart';
import 'package:vendor_app/widgets/global_back_control.dart';
import '../providers/vendor_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../utils/responsive_helper.dart';
import '../utils/date_formatter.dart';
import '../models/dashboard_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getDashboard();
    await vendorProvider.getBookings();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await Future.wait([
      vendorProvider.getDashboard(),
      vendorProvider.getBookings(),
    ]);

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  // Then update your _showExitConfirmation method:
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              SystemNavigator.pop(); // ACTUALLY EXIT THE APP
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return GlobalBackControl(
      onBackPressed: () {
        // Optional: Add custom back behavior
        // For example, show confirmation dialog before exiting
        _showExitConfirmation();
      },
      child: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          if (_isLoading) {
            return const LoadingWidget();
          }

          final dashboard = vendorProvider.dashboard;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: _isRefreshing
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeHeader(dashboard),
                        SizedBox(height: ResponsiveHelper.h(3)),
                        _buildStatisticsGrid(context, dashboard),
                        SizedBox(height: ResponsiveHelper.h(3)),
                        _buildRecentBookingsSection(context, dashboard),
                        SizedBox(height: ResponsiveHelper.h(3)),
                        _buildRevenueChart(context, dashboard),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  // Rest of the methods remain the same...
  Widget _buildWelcomeHeader(DashboardModel? dashboard) {
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
          // const CircleAvatar(
          //   radius: 30,
          //   backgroundColor: Colors.white,
          //   child: Icon(Icons.store, size: 30, color: AppColors.primary),
          // ),
          // SizedBox(width: ResponsiveHelper.w(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard?.farmhouse.name ?? 'Farmhouse',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dashboard?.vendor.email ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, DashboardModel? dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(2)),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: ResponsiveHelper.w(3),
          mainAxisSpacing: ResponsiveHelper.h(2),
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total Bookings',
              dashboard?.statistics.totalBookings.toString() ?? '0',
              Icons.book_online,
              AppColors.primary,
              () => _navigateToBookings(0), // All tab
            ),
            _buildStatCard(
              'Total Revenue',
              '₹${dashboard?.statistics.totalRevenue.toStringAsFixed(0) ?? '0'}',
              Icons.currency_rupee,
              AppColors.secondary,
              null, // No navigation for revenue
            ),
            _buildStatCard(
              'Today\'s Bookings',
              dashboard?.statistics.todayBookings.toString() ?? '0',
              Icons.today,
              AppColors.info,
              () => _navigateToBookings(0), // All tab (or create Today tab)
            ),
            _buildStatCard(
              'Upcoming',
              dashboard?.statistics.upcomingBookings.toString() ?? '0',
              Icons.upcoming,
              AppColors.warning,
              () => _navigateToBookings(1), // Upcoming tab
            ),
            _buildStatCard(
              'Completed',
              dashboard?.statistics.completedBookings.toString() ?? '0',
              Icons.check_circle,
              AppColors.success,
              () => _navigateToBookings(3), // Completed tab
            ),
            _buildStatCard(
              'Cancelled',
              dashboard?.statistics.cancelledBookings.toString() ?? '0',
              Icons.cancel,
              AppColors.error,
              () => _navigateToBookings(
                  0), // All tab with filter? Or create Cancelled tab
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToBookings(int tabIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingsScreen(initialTabIndex: tabIndex),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap, // Make it clickable

      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(3)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: ResponsiveHelper.w(6), color: color),
            SizedBox(height: ResponsiveHelper.h(1)),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(5),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(0.5)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(3),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookingsSection(
      BuildContext context, DashboardModel? dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Bookings',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(4.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Navigate to bookings tab
            //   },
            //   child: const Text('View All'),
            // ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(2)),
        if (dashboard?.recentBookings.isEmpty ?? true)
          Center(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.h(5)),
              child: Text(
                'No recent bookings',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: ResponsiveHelper.sp(4),
                ),
              ),
            ),
          )
        else
          Column(
            children: dashboard!.recentBookings.take(5).map((recentBooking) {
              return _buildRecentBookingCard(recentBooking);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildRecentBookingCard(RecentBooking recentBooking) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recentBooking.user,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.h(0.5)),
                          Text(
                            recentBooking.label,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(3.2),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(2),
                        vertical: ResponsiveHelper.h(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(recentBooking.status)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recentBooking.status,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(2.8),
                          color: _getStatusColor(recentBooking.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(2)),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: ResponsiveHelper.sp(4),
                      color: AppColors.grey,
                    ),
                    SizedBox(width: ResponsiveHelper.w(2)),
                    Text(
                      DateFormatter.formatDate(recentBooking.date),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.2),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(4)),
                    Icon(
                      Icons.access_time,
                      size: ResponsiveHelper.sp(4),
                      color: AppColors.grey,
                    ),
                    SizedBox(width: ResponsiveHelper.w(2)),
                    Text(
                      DateFormatter.formatTime(recentBooking.checkIn),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.2),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(1.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(3),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '₹${recentBooking.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(4.5),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: ResponsiveHelper.w(2),
                    //     vertical: ResponsiveHelper.h(0.5),
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: recentBooking.paymentStatus == 'completed'
                    //         ? AppColors.success.withOpacity(0.1)
                    //         : AppColors.warning.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   child: Text(
                    //     recentBooking.paymentStatus == 'completed'
                    //         ? 'Paid'
                    //         : 'Pending',
                    //     style: TextStyle(
                    //       fontSize: ResponsiveHelper.sp(2.8),
                    //       color: recentBooking.paymentStatus == 'completed'
                    //           ? AppColors.success
                    //           : AppColors.warning,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context, DashboardModel? dashboard) {
    final monthlyRevenue = dashboard?.monthlyRevenue ?? [];

    return Column(
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
        Container(
          height: ResponsiveHelper.h(25),
          padding: EdgeInsets.all(ResponsiveHelper.w(3)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: monthlyRevenue.isEmpty
              ? Center(
                  child: Text(
                    'No revenue data available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveHelper.sp(3.5),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: monthlyRevenue.length,
                  itemBuilder: (context, index) {
                    final data = monthlyRevenue[index];
                    final maxRevenue = monthlyRevenue.fold<double>(
                      0,
                      (max, item) => item.revenue > max ? item.revenue : max,
                    );
                    final height =
                        maxRevenue > 0 ? (data.revenue / maxRevenue) * 100 : 0;

                    return Container(
                      width: ResponsiveHelper.w(12),
                      margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '₹${(data.revenue / 1000).toStringAsFixed(0)}k',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(2.5),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.h(1)),
                          Container(
                            height: ResponsiveHelper.h(5),
                            width: ResponsiveHelper.w(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.h(1)),
                          Text(
                            data.month,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(2.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.primary;
      default:
        return AppColors.grey;
    }
  }
}
