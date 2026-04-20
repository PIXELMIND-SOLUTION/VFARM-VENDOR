import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/home_screen.dart';
import 'package:vendor_app/screens/main_screen.dart';
import '../providers/vendor_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../utils/responsive_helper.dart';
import '../utils/date_formatter.dart';
import '../models/farmhouse_model.dart';

class FarmhouseScreen extends StatefulWidget {
  const FarmhouseScreen({super.key});

  @override
  State<FarmhouseScreen> createState() => _FarmhouseScreenState();
}

class _FarmhouseScreenState extends State<FarmhouseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getFarmhouse();
  }

  Future<void> _refreshData() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getFarmhouse();
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
          final farmhouse = vendorProvider.farmhouse;
          final isLoading = vendorProvider.isLoading;

          if (isLoading && farmhouse == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (farmhouse == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load farmhouse data',
                    style: TextStyle(fontSize: ResponsiveHelper.sp(4)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.w(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusToggle(context, farmhouse),
                  const SizedBox(height: 16),
                  _buildFarmhouseDetails(farmhouse),
                  const SizedBox(height: 16),
                  _buildTimeSlotsSection(farmhouse),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusToggle(BuildContext context, FarmhouseModel farmhouse) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(3)),
      decoration: BoxDecoration(
        color: farmhouse.active
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  farmhouse.active ? Icons.check_circle : Icons.cancel,
                  color: farmhouse.active ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 8),
                Text(
                  farmhouse.active ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        farmhouse.active ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () => _showToggleDialog(context, farmhouse),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor:
                    farmhouse.active ? AppColors.error : AppColors.success,
              ),
              child: Text(farmhouse.active ? 'Deactivate' : 'Activate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmhouseDetails(FarmhouseModel farmhouse) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              farmhouse.name,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(5),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(farmhouse.rating.toString()),
                const Spacer(),
                Text(
                  '₹${farmhouse.price}/day',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(4.5),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    farmhouse.address,
                    style: TextStyle(fontSize: ResponsiveHelper.sp(3.5)),
                  ),
                ),
              ],
            ),
            if (farmhouse.description != null &&
                farmhouse.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                farmhouse.description!,
                style: TextStyle(fontSize: ResponsiveHelper.sp(3.5)),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Amenities',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(4),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (farmhouse.amenities.isEmpty)
              Text(
                'No amenities listed',
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(3.5),
                  color: AppColors.textSecondary,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: farmhouse.amenities.map((amenity) {
                  return Chip(
                    label: Text(amenity),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsSection(FarmhouseModel farmhouse) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Slots',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(4.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Permanent Deactivate/Activate All Slots
                // PopupMenuButton<String>(
                //   icon: const Icon(Icons.more_vert),
                //   onSelected: (value) {
                //     if (value == 'deactivate_all') {
                //       _showDeactivateAllSlotsDialog(farmhouse);
                //     } else if (value == 'activate_all') {
                //       _showActivateAllSlotsDialog(farmhouse);
                //     }
                //   },
                //   itemBuilder: (context) => [
                //     const PopupMenuItem(
                //       value: 'deactivate_all',
                //       child: Row(
                //         children: [
                //           Icon(Icons.cancel, color: Colors.red, size: 20),
                //           SizedBox(width: 8),
                //           Text('Deactivate All Slots Permanently'),
                //         ],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: 'activate_all',
                //       child: Row(
                //         children: [
                //           Icon(Icons.check_circle,
                //               color: Colors.green, size: 20),
                //           SizedBox(width: 8),
                //           Text('Activate All Slots'),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            const SizedBox(height: 16),
            if (farmhouse.timePrices.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.h(5)),
                  child: Text(
                    'No time slots configured',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(4),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...farmhouse.timePrices.map((slot) {
                return _buildSlotCard(farmhouse, slot);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotCard(FarmhouseModel farmhouse, TimePrice slot) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(2)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.access_time,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          slot.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              slot.timing,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (!slot.isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Permanently Inactive',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        trailing: Text(
          '₹${slot.price}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Permanent Toggle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Permanent Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              slot.isActive
                                  ? 'Slot is currently active'
                                  : 'Slot is permanently deactivated',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: slot.isActive,
                        onChanged: (value) {
                          _showPermanentToggleDialog(farmhouse, slot, value);
                        },
                        activeColor: AppColors.success,
                        inactiveThumbColor: AppColors.error,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Date-specific deactivations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Date',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddDateDialog(farmhouse, slot),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Date'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (slot.inactiveDates.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.h(3)),
                    child: Center(
                      child: Text(
                        'No dates deactivated for this slot',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: ResponsiveHelper.sp(3.5),
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: slot.inactiveDates.length,
                    itemBuilder: (context, index) {
                      final inactiveDate = slot.inactiveDates[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormatter.formatDate(inactiveDate.date),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (inactiveDate.reason != null)
                                    Text(
                                      inactiveDate.reason!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: AppColors.error,
                              ),
                              onPressed: () {
                                _showRemoveDateDialog(
                                  farmhouse,
                                  slot,
                                  inactiveDate,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPermanentToggleDialog(
    FarmhouseModel farmhouse,
    TimePrice slot,
    bool newValue,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(newValue ? 'Activate Slot?' : 'Deactivate Slot?'),
        content: Text(
          newValue
              ? 'Are you sure you want to permanently activate this slot?'
              : 'Are you sure you want to permanently deactivate this slot? This will make it unavailable for all future bookings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider =
                  Provider.of<VendorProvider>(context, listen: false);
              final success = await provider.toggleSlotActive(
                slotId: slot.id,
                isActive: newValue,
                date: DateTime.now(),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        success ? 'Slot status updated' : 'Operation failed'),
                    backgroundColor:
                        success ? AppColors.success : AppColors.error,
                  ),
                );
                if (success) {
                  _refreshData();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newValue ? AppColors.success : AppColors.error,
            ),
            child: Text(newValue ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showAddDateDialog(FarmhouseModel farmhouse, TimePrice slot) {
    final selectedDate = DateTime.now();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Deactivate Slot for Specific Date'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(DateFormatter.formatDate(selectedDate)),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {});
                    }
                  },
                ),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason (Optional)',
                    hintText: 'e.g., Maintenance, Private event',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final provider =
                      Provider.of<VendorProvider>(context, listen: false);
                  final success = await provider.toggleSlotActive(
                    slotId: slot.id,
                    isActive: false,
                    date: selectedDate,
                    reason: reasonController.text.isEmpty
                        ? null
                        : reasonController.text,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            success ? 'Date deactivated' : 'Operation failed'),
                        backgroundColor:
                            success ? AppColors.success : AppColors.error,
                      ),
                    );
                    if (success) {
                      _refreshData();
                    }
                  }
                },
                child: const Text('Deactivate'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRemoveDateDialog(
    FarmhouseModel farmhouse,
    TimePrice slot,
    InactiveDate inactiveDate,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reactivate Date?'),
        content: Text(
          'Are you sure you want to reactivate ${DateFormatter.formatDate(inactiveDate.date)} for this slot?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider =
                  Provider.of<VendorProvider>(context, listen: false);
              final success = await provider.toggleSlotActive(
                slotId: slot.id,
                isActive: true,
                date: inactiveDate.date,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(success ? 'Date reactivated' : 'Operation failed'),
                    backgroundColor:
                        success ? AppColors.success : AppColors.error,
                  ),
                );
                if (success) {
                  _refreshData();
                }
              }
            },
            child: const Text('Reactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateAllSlotsDialog(FarmhouseModel farmhouse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate All Slots?'),
        content: const Text(
          'Are you sure you want to permanently deactivate all slots? This will make your farmhouse unavailable for booking.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider =
                  Provider.of<VendorProvider>(context, listen: false);
              int successCount = 0;
              for (var slot in farmhouse.timePrices) {
                final success = await provider.toggleSlotActive(
                  slotId: slot.id,
                  isActive: false,
                  date: DateTime.now(),
                );
                if (success) successCount++;
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '$successCount/${farmhouse.timePrices.length} slots deactivated'),
                    backgroundColor:
                        successCount > 0 ? AppColors.success : AppColors.error,
                  ),
                );
                _refreshData();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Deactivate All'),
          ),
        ],
      ),
    );
  }

  void _showActivateAllSlotsDialog(FarmhouseModel farmhouse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate All Slots?'),
        content: const Text(
          'Are you sure you want to activate all slots? This will make your farmhouse available for booking again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider =
                  Provider.of<VendorProvider>(context, listen: false);
              int successCount = 0;
              for (var slot in farmhouse.timePrices) {
                final success = await provider.toggleSlotActive(
                  slotId: slot.id,
                  isActive: true,
                  date: DateTime.now(),
                );
                if (success) successCount++;
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '$successCount/${farmhouse.timePrices.length} slots activated'),
                    backgroundColor:
                        successCount > 0 ? AppColors.success : AppColors.error,
                  ),
                );
                _refreshData();
              }
            },
            child: const Text('Activate All'),
          ),
        ],
      ),
    );
  }

  void _showToggleDialog(BuildContext context, FarmhouseModel farmhouse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            farmhouse.active ? 'Deactivate Farmhouse?' : 'Activate Farmhouse?',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                farmhouse.active
                    ? 'Are you sure you want to deactivate your farmhouse? This will make it unavailable for booking.'
                    : 'Are you sure you want to activate your farmhouse? This will make it available for booking.',
              ),
              const SizedBox(height: 16),
              if (farmhouse.active)
                const Text(
                  'Note: You can also deactivate for specific dates.',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final provider =
                    Provider.of<VendorProvider>(context, listen: false);
                final success = await provider.toggleFarmhouseActive(
                  active: !farmhouse.active,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(success ? 'Status updated' : 'Operation failed'),
                      backgroundColor:
                          success ? AppColors.success : AppColors.error,
                    ),
                  );
                  if (success) {
                    _refreshData();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: farmhouse.active
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
              child: Text(farmhouse.active ? 'Deactivate' : 'Activate'),
            ),
          ],
        );
      },
    );
  }
}
