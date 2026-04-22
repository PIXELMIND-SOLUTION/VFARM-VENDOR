import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/home_screen.dart';
import 'package:vendor_app/screens/main_screen.dart';
import '../providers/vendor_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/booking_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/global_back_control.dart';
import '../utils/responsive_helper.dart';
import '../models/booking_model.dart';

class BookingsScreen extends StatefulWidget {
  final int initialTabIndex; // Add this parameter

  const BookingsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4, vsync: this,
      initialIndex: widget.initialTabIndex, // Use the passed index
    );
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getBookings();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getBookings();
  }

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

    return WillPopScope(
      onWillPop: () async {
        // Navigate to home screen when back button is pressed
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        return false; // Prevent default back behavior
      },
      child: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          if (_isLoading) {
            return const LoadingWidget();
          }

          final bookings = vendorProvider.bookings;
          final upcomingBookings = bookings.where((b) => b.isUpcoming).toList();
          final activeBookings = bookings.where((b) => b.isActive).toList();
          final completedBookings =
              bookings.where((b) => b.isCompleted).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Bookings'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              bottom: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(bookings, 'all', _refreshData),
                _buildBookingList(upcomingBookings, 'upcoming', _refreshData),
                _buildBookingList(activeBookings, 'active', _refreshData),
                _buildBookingList(completedBookings, 'completed', _refreshData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings, String type,
      Future<void> Function() onRefresh) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_online,
              size: ResponsiveHelper.w(15),
              color: AppColors.grey,
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            Text(
              'No $type bookings found',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(4),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveHelper.w(3)),
        itemCount: bookings.length,
        itemBuilder: (ctx, index) {
          return BookingCard(booking: bookings[index]);
        },
      ),
    );
  }
}
