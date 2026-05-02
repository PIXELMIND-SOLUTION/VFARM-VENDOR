// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/vendor_provider.dart';
// import '../constants/app_colors.dart';
// import '../utils/responsive_helper.dart';
// import '../models/farmhouse_model.dart';

// class FarmhouseUpdateScreen extends StatefulWidget {
//   const FarmhouseUpdateScreen({super.key});

//   @override
//   State<FarmhouseUpdateScreen> createState() => _FarmhouseUpdateScreenState();
// }

// class _FarmhouseUpdateScreenState extends State<FarmhouseUpdateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _addressController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _priceController;
//   late TextEditingController _amenitiesController;
//   late TextEditingController _bookingForController;

//   bool _isLoading = true;
//   bool _isSaving = false;
//   FarmhouseModel? _farmhouse;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
//     await vendorProvider.getFarmhouse();

//     if (mounted) {
//       setState(() {
//         _farmhouse = vendorProvider.farmhouse;
//         if (_farmhouse != null) {
//           _initControllers();
//         }
//         _isLoading = false;
//       });
//     }
//   }

//   void _initControllers() {
//     _nameController = TextEditingController(text: _farmhouse!.name);
//     _addressController = TextEditingController(text: _farmhouse!.address);
//     _descriptionController =
//         TextEditingController(text: _farmhouse!.description ?? '');
//     _priceController =
//         TextEditingController(text: _farmhouse!.price.toString());
//     _amenitiesController =
//         TextEditingController(text: _farmhouse!.amenities.join(', '));
//     _bookingForController =
//         TextEditingController(text: _farmhouse!.bookingFor ?? '');
//   }

//   Future<void> _saveChanges() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isSaving = true;
//     });

//     final amenitiesList = _amenitiesController.text
//         .split(',')
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)
//         .toList();

//     final updateData = {
//       'name': _nameController.text.trim(),
//       'address': _addressController.text.trim(),
//       'description': _descriptionController.text.trim(),
//       'price': double.parse(_priceController.text),
//       'amenities': amenitiesList,
//       'bookingFor': _bookingForController.text.trim(),
//     };

//     final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
//     final success = await vendorProvider.updateFarmhouse(updateData);

//     setState(() {
//       _isSaving = false;
//     });

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               success ? 'Farmhouse updated successfully!' : 'Update failed'),
//           backgroundColor: success ? AppColors.success : AppColors.error,
//         ),
//       );
//       if (success) {
//         Navigator.pop(context);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     _amenitiesController.dispose();
//     _bookingForController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ResponsiveHelper.init(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Farmhouse'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _buildForm(),
//     );
//   }

//   Widget _buildForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(ResponsiveHelper.w(4)),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(
//               controller: _nameController,
//               label: 'Farmhouse Name',
//               icon: Icons.home,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Name is required';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: ResponsiveHelper.h(2)),
//             _buildTextField(
//               controller: _addressController,
//               label: 'Address',
//               icon: Icons.location_on,
//               maxLines: 2,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Address is required';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: ResponsiveHelper.h(2)),
//             _buildTextField(
//               controller: _priceController,
//               label: 'Price per day (₹)',
//               icon: Icons.currency_rupee,
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Price is required';
//                 }
//                 if (double.tryParse(value) == null) {
//                   return 'Enter a valid number';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: ResponsiveHelper.h(2)),
//             _buildTextField(
//               controller: _descriptionController,
//               label: 'Description',
//               icon: Icons.description,
//               maxLines: 3,
//             ),
//             SizedBox(height: ResponsiveHelper.h(2)),
//             _buildTextField(
//               controller: _amenitiesController,
//               label: 'Amenities',
//               hint: 'Separate with commas (e.g., Pool, WiFi, Parking)',
//               icon: Icons.checklist,
//               maxLines: 2,
//             ),
//             SizedBox(height: ResponsiveHelper.h(2)),
//             _buildTextField(
//               controller: _bookingForController,
//               label: 'Booking For',
//               hint: 'e.g., Weddings, Parties, Corporate events',
//               icon: Icons.event,
//             ),
//             SizedBox(height: ResponsiveHelper.h(4)),
//             ElevatedButton(
//               onPressed: _isSaving ? null : _saveChanges,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//                 minimumSize: Size(double.infinity, ResponsiveHelper.h(6)),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: _isSaving
//                   ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : const Text(
//                       'Save Changes',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     String? hint,
//     required IconData icon,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon, color: AppColors.primary),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.primary),
//         ),
//       ),
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       validator: validator,
//     );
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
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

  // Text controllers
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _amenitiesController;
  late TextEditingController _bookingForController;
  late TextEditingController _noOfPersonsController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  bool _isLoading = true;
  bool _isSaving = false;
  FarmhouseModel? _farmhouse;

  // Media files
  List<File> _newImages = [];
  List<String> _existingImages = [];
  File? _videoFile;
  bool _deleteVideo = false;
  bool _isGettingLocation = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    await vendorProvider.getFarmhouse();

    if (mounted) {
      final updatedFarmhouse = vendorProvider.farmhouse;
      if (updatedFarmhouse != null) {
        _farmhouse = updatedFarmhouse;

        // Initialize existing images (even if empty)
        _existingImages = List.from(updatedFarmhouse.images);

        // Reset new media states
        _newImages.clear();
        _videoFile = null;
        _deleteVideo = false;

        // Initialize controllers
        _initControllers();
      }

      setState(() {
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
    _noOfPersonsController =
        TextEditingController(text: _farmhouse!.noOfPersons.toString());
    _latController = TextEditingController(text: _farmhouse!.lat.toString());
    _lngController = TextEditingController(text: _farmhouse!.lng.toString());
  }

  void _disposeControllers() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _amenitiesController.dispose();
    _bookingForController.dispose();
    _noOfPersonsController.dispose();
    _latController.dispose();
    _lngController.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permission denied', isError: true);
          setState(() => _isGettingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permission permanently denied', isError: true);
        setState(() => _isGettingLocation = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        _isGettingLocation = false;
      });

      _showSnackBar('Location fetched successfully!');
    } catch (e) {
      _showSnackBar('Error getting location: $e', isError: true);
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedImages = await _imagePicker.pickMultiImage();
      if (pickedImages != null && pickedImages.isNotEmpty) {
        setState(() {
          _newImages.addAll(pickedImages.map((xfile) => File(xfile.path)));
        });
        _showSnackBar('${pickedImages.length} images selected');
      }
    } catch (e) {
      _showSnackBar('Error picking images: $e', isError: true);
    }
  }

  Future<void> _removeExistingImage(int index) async {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  Future<void> _removeNewImage(int index) async {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedVideo = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedVideo != null) {
        setState(() {
          _videoFile = File(pickedVideo.path);
          _deleteVideo = false;
        });
        _showSnackBar('Video selected: ${pickedVideo.name}');
      }
    } catch (e) {
      _showSnackBar('Error picking video: $e', isError: true);
    }
  }

  void _removeVideo() {
    setState(() {
      if (_videoFile != null) {
        _videoFile = null;
      } else if (_farmhouse?.video != null) {
        _deleteVideo = true;
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate that at least one image exists
    if (_existingImages.isEmpty && _newImages.isEmpty) {
      _showSnackBar('Please add at least one image for the farmhouse',
          isError: true);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final amenitiesList = _amenitiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final fields = {
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': _priceController.text,
      'amenities': jsonEncode(amenitiesList),
      'bookingFor': _bookingForController.text.trim(),
      'noOfPersons': _noOfPersonsController.text.trim(),
      'lat': _latController.text.trim(),
      'lng': _lngController.text.trim(),
    };

    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);

    final success = await vendorProvider.updateFarmhouseWithMedia(
      fields: fields,
      newImages: _newImages.isNotEmpty ? _newImages : null,
      imagesToKeep: _existingImages.isNotEmpty ? _existingImages : null,
      videoFile: _videoFile,
      deleteVideo: _deleteVideo,
    );

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      if (success) {
        _showSnackBar('Farmhouse updated successfully!');
        await _loadData(); // Reload to show updated data
      } else {
        _showSnackBar('Update failed', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    _disposeControllers();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.w(4)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildSectionHeader('Basic Information', Icons.info),
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

                    // Pricing & Capacity
                    _buildSectionHeader(
                        'Pricing & Capacity', Icons.attach_money),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
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
                        ),
                        SizedBox(width: ResponsiveHelper.w(4)),
                        Expanded(
                          child: _buildTextField(
                            controller: _noOfPersonsController,
                            label: 'Max Persons',
                            icon: Icons.people,
                            keyboardType: TextInputType.number,
                            hint: 'Maximum number of guests',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final persons = int.tryParse(value);
                              if (persons == null) {
                                return 'Enter a valid number';
                              }
                              if (persons <= 0) {
                                return 'Must be greater than 0';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.h(2)),

                    // Location
                    _buildSectionHeader('Location', Icons.location_on),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _latController,
                            label: 'Latitude',
                            icon: Icons.map,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.w(4)),
                        Expanded(
                          child: _buildTextField(
                            controller: _lngController,
                            label: 'Longitude',
                            icon: Icons.map,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.h(1)),
                    ElevatedButton.icon(
                      onPressed:
                          _isGettingLocation ? null : _getCurrentLocation,
                      icon: _isGettingLocation
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: const Text('Get Current Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2)),

                    // Description
                    _buildSectionHeader('Description', Icons.description),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    SizedBox(height: ResponsiveHelper.h(2)),

                    // Amenities & Booking Type
                    _buildSectionHeader(
                        'Amenities & Services', Icons.checklist),
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
                    SizedBox(height: ResponsiveHelper.h(2)),

                    // Images Section
                    _buildSectionHeader('Images', Icons.image),
                    _buildImageSection(),
                    SizedBox(height: ResponsiveHelper.h(2)),

                    // Video Section
                    _buildSectionHeader('Video Tour', Icons.video_library),
                    _buildVideoSection(),
                    SizedBox(height: ResponsiveHelper.h(4)),

                    // Save Button
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize:
                            Size(double.infinity, ResponsiveHelper.h(6)),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(1.5)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          SizedBox(width: ResponsiveHelper.w(2)),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    final hasExistingImages = _existingImages.isNotEmpty;
    final hasNewImages = _newImages.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info message
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(2)),
          margin: EdgeInsets.only(bottom: ResponsiveHelper.h(1.5)),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'At least one image is required. You can select multiple images at once.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // Existing Images
        const Text('Current Images',
            style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: ResponsiveHelper.h(1)),
        if (hasExistingImages)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _existingImages.length,
              itemBuilder: (context, index) {
                return _buildImageCard(
                  imageUrl: _existingImages[index],
                  isNetwork: true,
                  onRemove: () => _removeExistingImage(index),
                );
              },
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(3)),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.no_photography, size: 40, color: Colors.grey),
                  SizedBox(height: ResponsiveHelper.h(1)),
                  const Text(
                    'No images uploaded yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    'Click "Add Images" below to upload',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

        SizedBox(height: ResponsiveHelper.h(2)),

        // New Images
        if (hasNewImages) ...[
          const Text('New Images to Upload',
              style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: ResponsiveHelper.h(1)),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _newImages.length,
              itemBuilder: (context, index) {
                return _buildImageCard(
                  imageFile: _newImages[index],
                  isNetwork: false,
                  onRemove: () => _removeNewImage(index),
                );
              },
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(2)),
        ],

        // Add Images Button
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon:
              Icon(_newImages.isEmpty ? Icons.add_photo_alternate : Icons.add),
          label: Text(_newImages.isEmpty ? 'Add Images' : 'Add More Images'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            foregroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard({
    String? imageUrl,
    File? imageFile,
    required bool isNetwork,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: ResponsiveHelper.w(2)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isNetwork
                ? Image.network(
                    imageUrl!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  )
                : Image.file(
                    imageFile!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    final hasExistingVideo = _farmhouse?.video != null &&
        _farmhouse!.video!.isNotEmpty &&
        !_deleteVideo;
    final hasNewVideo = _videoFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info message
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(2)),
          margin: EdgeInsets.only(bottom: ResponsiveHelper.h(1.5)),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Video is optional. Upload a promo video to showcase your farmhouse.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // Existing Video
        const Text('Current Video',
            style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: ResponsiveHelper.h(1)),
        if (hasExistingVideo)
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(2)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
              color: Colors.green.shade50,
            ),
            child: Row(
              children: [
                const Icon(Icons.video_file, color: Colors.green),
                SizedBox(width: ResponsiveHelper.w(2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Video uploaded',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _farmhouse!.video!.split('/').last,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   onPressed: _removeVideo,
                //   tooltip: 'Remove video',
                // ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(3)),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.video_library, size: 40, color: Colors.grey),
                  SizedBox(height: ResponsiveHelper.h(1)),
                  const Text(
                    'No video uploaded yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    'Click "Add Video" below to upload',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

        SizedBox(height: ResponsiveHelper.h(2)),

        // Delete confirmation
        if (_deleteVideo && _farmhouse?.video != null)
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(2)),
            margin: EdgeInsets.only(bottom: ResponsiveHelper.h(1.5)),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Current video will be deleted',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

        // New Video
        if (hasNewVideo) ...[
          const Text('New Video to Upload',
              style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: ResponsiveHelper.h(1)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(2)),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Row(
              children: [
                const Icon(Icons.video_file, color: AppColors.primary),
                SizedBox(width: ResponsiveHelper.w(2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New video ready to upload',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _videoFile!.path.split('/').last,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _removeVideo,
                  tooltip: 'Remove video',
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(2)),
        ],

        // Add Video Button
        if (_videoFile == null && (!_deleteVideo || _farmhouse?.video == null))
          ElevatedButton.icon(
            onPressed: _pickVideo,
            icon: const Icon(Icons.video_library),
            label: Text(hasExistingVideo ? 'Replace Video' : 'Add Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
            ),
          ),

        // Replace button when video exists
        if (hasExistingVideo && _videoFile == null && !_deleteVideo)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveHelper.h(1)),
            child: TextButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Replace with new video'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
      ],
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
