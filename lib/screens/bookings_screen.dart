import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vendor_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/booking_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/responsive_helper.dart';
import '../models/booking_model.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

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
    _tabController = TabController(length: 4, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, child) {
        if (_isLoading) {
          return const LoadingWidget();
        }

        final bookings = vendorProvider.bookings;
        final upcomingBookings = bookings.where((b) => b.isUpcoming).toList();
        final activeBookings = bookings.where((b) => b.isActive).toList();
        final completedBookings = bookings.where((b) => b.isCompleted).toList();

        return Scaffold(
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
