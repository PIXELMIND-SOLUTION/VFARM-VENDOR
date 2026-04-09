import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/main_screen.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/responsive_helper.dart';
import 'register_screen.dart';
import 'status_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Login failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.w(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: ResponsiveHelper.h(5)),
              // // Back button
              // IconButton(
              //   onPressed: () => Navigator.pop(context),
              //   icon: const Icon(Icons.arrow_back),
              // ),
              // SizedBox(height: ResponsiveHelper.h(5)),
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: ResponsiveHelper.w(25),
                      height: ResponsiveHelper.w(25),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(ResponsiveHelper.w(12.5)),
                        child: Image.asset(
                          "assets/farmhouselogo.png", // 👈 your image path
                          fit: BoxFit.cover, // or BoxFit.contain
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2)),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(1)),
                    Text(
                      'Login to your vendor account',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.5),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(5)),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hint: 'Enter your username',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveHelper.h(2)),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(5)),
              // Login Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                    isLoading: authProvider.isLoading,
                  );
                },
              ),
              SizedBox(height: ResponsiveHelper.h(2)),
              // Track Application Button
              CustomButton(
                text: 'Track Application Status',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StatusScreen()),
                  );
                },
                isOutlined: true,
              ),
              SizedBox(height: ResponsiveHelper.h(3)),
              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveHelper.sp(3.5),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: ResponsiveHelper.sp(3.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
