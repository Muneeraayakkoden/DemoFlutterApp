import 'package:flutter/material.dart';
import '../../../constants/icons_class.dart';
import '../../../constants/color_class.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(entry.value, size: 20, color: ColorClass.iconStrong900),
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
          ],
        ),
      );
    }).toList();
  }

  Widget _buildOtpField(BuildContext context, AuthProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorClass.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Pinput(
          length: 6,
          controller: provider.otpController,
          focusNode: provider.otpFocusNode,
          defaultPinTheme: PinTheme(
            width: 56,
            height: 56,
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorClass.brandLightGreen.withValues(alpha: 0.5),
              ),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 56,
            height: 56,
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorClass.brandLightGreen, width: 2),
            ),
          ),
          errorPinTheme: PinTheme(
            width: 56,
            height: 56,
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red, width: 2),
            ),
          ),
          onCompleted: (pin) {
            // Auto-submit when OTP is complete
            if (pin.length == 6) {
              provider.handleContinue(context);
            }
          },
          showCursor: true,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed:
                  provider.isLoading ? null : () => provider.resendOtp(context),
              icon: Icon(
                LucideIcons.refreshCw,
                size: 16,
                color: ColorClass.brandLightGreen,
              ),
              label: Text(
                'Resend OTP',
                style: TextStyle(
                  color: ColorClass.brandLightGreen,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneOrUsernameField(
    BuildContext context,
    AuthProvider provider,
  ) {
    if (provider.isUserRole && provider.isPhoneEntered) {
      return _buildOtpField(context, provider);
    }
    return TextFormField(
      controller:
          provider.isUserRole
              ? provider.phoneController
              : provider.usernameController,
      focusNode: provider.isUserRole ? provider.phoneFocusNode : null,
      keyboardType:
          provider.isUserRole ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        return provider.getFieldValidationMessage(value);
      },
      onFieldSubmitted: (_) {
        final form = Form.of(context);
        if (form.validate()) {
          provider.handleContinue(context);
        }
      },
      decoration: InputDecoration(
        hintText: provider.isUserRole ? 'Phone Number' : 'Username',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(
          provider.isUserRole ? LucideIcons.smartphone : LucideIcons.user,
          color: ColorClass.black,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorClass.brandLightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorClass.brandLightGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorClass.brandDarkGreen,
              ColorClass.middleGradient,
              ColorClass.bottomGradient,
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
                  const SizedBox(height: 190),
                  Image.asset(IconClass.splashLogo, width: 58, height: 58),
                  const SizedBox(height: 32),
                  Text(
                    'Hira Plus',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: ColorClass.brandLightGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hira Automation System',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorClass.brandLightGreen,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Form(
                      child: Column(
                        children: [
                          if (!provider.isPhoneEntered)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              icon: Icon(
                                LucideIcons.chevronDown,
                                color: ColorClass.black,
                              ),
                              value: provider.selectedRole,
                              items: _buildRoleDropdownItems(),
                              onChanged:
                                  provider.isPhoneEntered
                                      ? null
                                      : (value) => provider.setRole(value),
                            ),
                          const SizedBox(height: 20),
                          _buildPhoneOrUsernameField(context, provider),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed:
                                provider.isLoading
                                    ? null
                                    : () => provider.handleContinue(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: ColorClass.brandLightGreen,
                              foregroundColor: ColorClass.brandDarkGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child:
                                provider.isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      provider.isPhoneEntered
                                          ? 'Verify OTP'
                                          : 'Continue',
                                      style: TextStyle(
                                        color: ColorClass.black.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              // help
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              backgroundColor: ColorClass.brandLightGreen
                                  .withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                  style: TextStyle(
                                    color: ColorClass.brandLightGreen,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
