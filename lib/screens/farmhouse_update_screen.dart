import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vendor_provider.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../models/farmhouse_model.dart';

class FarmhouseUpdateScreen extends StatefulWidget {
  const FarmhouseUpdateScreen({super.key});

  @override
  State<FarmhouseUpdateScreen> createState() => _FarmhouseUpdateScreenState();
}

class _FarmhouseUpdateScreenState extends State<FarmhouseUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _amenitiesController;
  late TextEditingController _bookingForController;

  bool _isLoading = true;
  bool _isSaving = false;
  FarmhouseModel? _farmhouse;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getFarmhouse();

    if (mounted) {
      setState(() {
        _farmhouse = vendorProvider.farmhouse;
        if (_farmhouse != null) {
          _initControllers();
        }
        _isLoading = false;
      });
    }
  }

  void _initControllers() {
    _nameController = TextEditingController(text: _farmhouse!.name);
    _addressController = TextEditingController(text: _farmhouse!.address);
    _descriptionController =
        TextEditingController(text: _farmhouse!.description ?? '');
    _priceController =
        TextEditingController(text: _farmhouse!.price.toString());
    _amenitiesController =
        TextEditingController(text: _farmhouse!.amenities.join(', '));
    _bookingForController =
        TextEditingController(text: _farmhouse!.bookingFor ?? '');
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final amenitiesList = _amenitiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updateData = {
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.parse(_priceController.text),
      'amenities': amenitiesList,
      'bookingFor': _bookingForController.text.trim(),
    };

    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    final success = await vendorProvider.updateFarmhouse(updateData);

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              success ? 'Farmhouse updated successfully!' : 'Update failed'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _amenitiesController.dispose();
    _bookingForController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Farmhouse'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Farmhouse Name',
              icon: Icons.home,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Address is required';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            _buildTextField(
              controller: _priceController,
              label: 'Price per day (₹)',
              icon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 3,
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            _buildTextField(
              controller: _amenitiesController,
              label: 'Amenities',
              hint: 'Separate with commas (e.g., Pool, WiFi, Parking)',
              icon: Icons.checklist,
              maxLines: 2,
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            _buildTextField(
              controller: _bookingForController,
              label: 'Booking For',
              hint: 'e.g., Weddings, Parties, Corporate events',
              icon: Icons.event,
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, ResponsiveHelper.h(6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
