import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/models/vendor_model.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/responsive_helper.dart';
import '../utils/validators.dart';
import 'package:geolocator/geolocator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amenitiesController = TextEditingController();
  final _bookingForController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  List<File> _selectedImages = [];
  bool _isUploading = false;
  String? _applicationId;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _amenitiesController.dispose();
    _bookingForController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages = images.map((xfile) => File(xfile.path)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

// Method to fetch current location
  Future<void> _fetchCurrentLocation() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) Navigator.pop(context);
        _showLocationErrorDialog(
          'Location services are disabled. Please enable location services in your device settings.',
        );
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) Navigator.pop(context);
          _showLocationErrorDialog(
            'Location permissions are denied. Please allow location access to fetch coordinates.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) Navigator.pop(context);
        _showLocationErrorDialog(
          'Location permissions are permanently denied. Please enable location access in app settings.',
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      // Update the text fields with coordinates
      setState(() {
        _latitudeController.text = position.latitude.toStringAsFixed(6);
        _longitudeController.text = position.longitude.toStringAsFixed(6);
      });

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Current location fetched successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (context.mounted) Navigator.pop(context);

      // Show error message
      _showLocationErrorDialog(
        'Failed to get current location: ${e.toString()}\nPlease check your GPS and try again.',
      );
    }
  }

// Helper method to show location error dialog
  void _showLocationErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Location Error',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _selectedImages.add(File(photo.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select multiple images'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take a Photo'),
              subtitle: const Text('Capture from camera'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least one farmhouse image'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final request = RegisterRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      lat: double.parse(_latitudeController.text),
      lng: double.parse(_longitudeController.text),
      price: double.parse(_priceController.text),
      description: _descriptionController.text.trim(),
      amenities:
          _amenitiesController.text.split(',').map((e) => e.trim()).toList(),
      bookingFor: _bookingForController.text.trim(),
      images: _selectedImages, // Pass files for upload
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.registerWithImages(request);

    setState(() {
      _isUploading = false;
    });

    if (success && mounted) {
      _applicationId = authProvider.applicationId;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Application Submitted!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Your farmhouse application has been submitted successfully.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Application ID:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _applicationId ?? 'Not available',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please save this Application ID to track your application status.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Registration failed'),
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
        title: const Text('Register Farmhouse'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isUploading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.w(4)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Basic Information Section
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.h(1)),
                  child: Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(4.5),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(1)),

                CustomTextField(
                  controller: _nameController,
                  label: 'Farmhouse Name',
                  hint: 'Enter farmhouse name',
                  prefixIcon: Icons.home,
                  validator: Validators.validateName,
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter email address',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                CustomTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter full address',
                  prefixIcon: Icons.location_on,
                  maxLines: 2,
                  validator: Validators.validateAddress,
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                // Images Section (Mandatory)
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.h(1)),
                  child: Row(
                    children: [
                      Text(
                        'Farmhouse Images',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(4.5),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Required',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(1)),

                _buildImageSection(),
                SizedBox(height: ResponsiveHelper.h(2)),

// Location Section with Fetch Coordinates Button
                // Location Section with Fetch Coordinates Button
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.h(1)),
                  child: Row(
                    children: [
                      Text(
                        'Location (Coordinates)',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(4.5),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Wrap the button in a Flexible widget to prevent infinite width
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => _fetchCurrentLocation(),
                          icon: const Icon(Icons.my_location, size: 18),
                          label: const Text(
                            'Get Current Location',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(1)),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _latitudeController,
                        label: 'Latitude',
                        hint: 'e.g., 19.0760',
                        prefixIcon: Icons.location_searching,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Latitude is required';
                          }
                          final lat = double.tryParse(value);
                          if (lat == null) {
                            return 'Enter a valid number';
                          }
                          if (lat < -90 || lat > 90) {
                            return 'Latitude must be between -90 and 90';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(3)),
                    Expanded(
                      child: CustomTextField(
                        controller: _longitudeController,
                        label: 'Longitude',
                        hint: 'e.g., 72.8777',
                        prefixIcon: Icons.location_searching,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Longitude is required';
                          }
                          final lng = double.tryParse(value);
                          if (lng == null) {
                            return 'Enter a valid number';
                          }
                          if (lng < -180 || lng > 180) {
                            return 'Longitude must be between -180 and 180';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                // Pricing Section
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.h(1)),
                  child: Text(
                    'Pricing & Details',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(4.5),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(1)),

                CustomTextField(
                  controller: _priceController,
                  label: 'Price per day (₹)',
                  hint: 'Enter price',
                  prefixIcon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Enter a valid price greater than 0';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                CustomTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Describe your farmhouse',
                  prefixIcon: Icons.description,
                  maxLines: 3,
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                CustomTextField(
                  controller: _amenitiesController,
                  label: 'Amenities',
                  hint: 'Pool, WiFi, Parking (comma separated)',
                  prefixIcon: Icons.checklist,
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                CustomTextField(
                  controller: _bookingForController,
                  label: 'Booking For',
                  hint: 'Weddings, Parties, Corporate events',
                  prefixIcon: Icons.event,
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                // Info Box
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(3)),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: ResponsiveHelper.sp(4), color: AppColors.info),
                      SizedBox(width: ResponsiveHelper.w(2)),
                      Expanded(
                        child: Text(
                          'How to get coordinates:\n1. Open Google Maps\n2. Right-click on your farmhouse location\n3. Select "What\'s here?"\n4. Copy the coordinates (latitude, longitude)',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(3),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(3)),

                // Submit Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: 'Submit Application',
                      onPressed: _isUploading ? null : _handleRegister,
                      isLoading: authProvider.isLoading || _isUploading,
                    );
                  },
                ),
                SizedBox(height: ResponsiveHelper.h(2)),

                Text(
                  'Note: Your application will be reviewed by admin. You will receive credentials via email upon approval.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(3),
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Image Button
        GestureDetector(
          onTap: _showImagePickerOptions,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedImages.isEmpty
                    ? AppColors.error
                    : AppColors.primary,
                width: _selectedImages.isEmpty ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 40,
                  color: _selectedImages.isEmpty
                      ? AppColors.error
                      : AppColors.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedImages.isEmpty
                      ? 'Please add farmhouse images (Required)'
                      : 'Tap to add more images',
                  style: TextStyle(
                    color: _selectedImages.isEmpty
                        ? AppColors.error
                        : AppColors.primary,
                    fontWeight: _selectedImages.isEmpty
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedImages.length} image(s) selected',
                  style: TextStyle(
                    fontSize: 12,
                    color: _selectedImages.isEmpty
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Image Preview Grid
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImages[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
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
}
