import 'package:flutter/material.dart';
import '../constants/icons_class.dart';
import '../constants/color_class.dart';
import '../routes/routes_names.dart';
import '../utils/navigation_helper.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? selectedRole = 'User';
  bool isPhoneEntered = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // final TextEditingController _otpController = TextEditingController();
  // final FocusNode _otpFocusNode = FocusNode();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final bool _isOtpSent = false;
  // final bool _isOtpVerified = false;
  // final bool _isLoading = false;

  bool isValidPhoneNumber(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  bool isValidUsername(String? value) {
    return value != null && value.isNotEmpty && value.length >= 3; 
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }


  List<DropdownMenuItem<String>> _buildRoleDropdownItems() {
    final Map<String, IconData> roleIcons = {
      'User': LucideIcons.user,
      'Manager': LucideIcons.shieldCheck,
      'Mess Staff': LucideIcons.utensils,
      'Reception': LucideIcons.personStanding,
    };

    return roleIcons.entries.map((entry) {
      return DropdownMenuItem(
        value: entry.key,
        child: Row(
          children: [
            Icon(
              entry.value,
              size: 20,
              color: ColorClass.iconStrong900,
            ),
            const SizedBox(width: 12),
            Text(
              entry.key,
              style: TextStyle(
                color: ColorClass.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorClass.brandDarkGreen, // top
              ColorClass.middleGradient, 
              ColorClass.bottomGradient,// bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height:190),
                  Image.asset(
                    IconClass.splashLogo,
                    width: 58,
                    height: 58,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Hira Plus',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: ColorClass.brandLightGreen.withValues(alpha: 1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hira Automation System',
                    style: TextStyle(fontSize: 16, color: ColorClass.brandLightGreen.withValues(alpha: 1)),
                  ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          icon: Icon(
                            LucideIcons.chevronDown,
                            color: ColorClass.black,
                          ),
                          value: selectedRole,
                          items: _buildRoleDropdownItems(),
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                              isPhoneEntered = false;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        TextField(
                          controller: selectedRole == 'User' ? _phoneController : _usernameController,
                          keyboardType: selectedRole == 'User' ? TextInputType.phone : TextInputType.text,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: selectedRole == 'User' ? 'Phone Number' : 'Username',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              selectedRole == 'User' ? LucideIcons.smartphone : LucideIcons.user,
                              color: ColorClass.black,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedRole == 'User') {
                              if (isValidPhoneNumber(_phoneController.text)) {
                                navigateReplaceTo(context: context, route: RouteNames.home);
                              } else {
                                toastification.show(
                                  context: context,
                                  title: Text('Error'),
                                  description: Text('Please enter a valid 10-digit phone number'),
                                  type: ToastificationType.error,
                                  autoCloseDuration: Duration(seconds: 3),
                                );
                              }
                            } else {
                              if (isValidUsername(_usernameController.text)) {
                                navigateReplaceTo(context: context, route: RouteNames.home);
                              } else {
                                toastification.show(
                                  context: context,
                                  title: Text('Error'),
                                  description: Text('Please enter a valid username (min 3 characters)'),
                                  type: ToastificationType.error,
                                  autoCloseDuration: Duration(seconds: 3),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: ColorClass.brandLightGreen,
                            foregroundColor: ColorClass.brandDarkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text('Continue', style: TextStyle(color: ColorClass.black.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            // help
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            backgroundColor: ColorClass.brandLightGreen.withValues(alpha: 0.1), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: ColorClass.brandLightGreen,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Need help? Contact Hira Manager',
                                style: TextStyle(color: ColorClass.brandLightGreen.withValues(alpha: 1), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}