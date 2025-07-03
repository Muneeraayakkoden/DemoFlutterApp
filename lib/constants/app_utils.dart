// ignore_for_file: avoid_print

// import 'dart:io';

// import 'package:flutter_application_1/constants/color_class.dart';
// import 'package:flutter_application_1/constants/textstyle_class.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';
// import 'dart:developer' as developer;
//

class AppUtils {
  // static final Logger _logger = Logger();

  // ///To check internet connection
  // static Future<bool> hasInternet() async {
  //   try {
  //     _logger.d('🌐 [CONNECTIVITY] Checking internet connection');
  //     developer.log('🌐 Checking internet connection', name: 'AppUtils');
      
  //     if (kIsWeb) {
  //       _logger.d('🌐 [CONNECTIVITY] Web platform detected, returning true');
  //       developer.log('🌐 Web platform detected', name: 'AppUtils');
  //       return true; // Web browsers handle offline state automatically
  //     } else {
  //       try {
  //         final result = await InternetAddress.lookup('google.com')
  //             .timeout(const Duration(seconds: 5));
          
  //         final hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
          
  //         _logger.i('🌐 [CONNECTIVITY] Connection status: ${hasConnection ? 'Connected' : 'Disconnected'}');
  //         developer.log('🌐 Connection status: ${hasConnection ? 'Connected' : 'Disconnected'}', name: 'AppUtils');
          
  //         return hasConnection;
  //       } on SocketException catch (e) {
  //         _logger.e('🔌 [CONNECTIVITY] Socket exception: $e');
  //         developer.log('🔌 Socket exception: $e', name: 'AppUtils');
  //         return false;
  //       }
  //     }
  //   } catch (e) {
  //     _logger.e('❌ [CONNECTIVITY] Error checking internet: $e');
  //     developer.log('❌ Error checking internet: $e', name: 'AppUtils', error: e);
  //     return false;
  //   }
  // }

  // static showInSnackBarNormal(String message, BuildContext context) {
  //   try {
  //     _logger.d('📢 [SNACKBAR] Showing message: $message');
  //     developer.log('📢 Showing snackbar message', name: 'AppUtils');
      
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         closeIconColor: ColorClass.white,
  //         backgroundColor: ColorClass.greenDark,
  //         showCloseIcon: true,
  //         duration: const Duration(seconds: 2),
  //         behavior: SnackBarBehavior.floating,
  //         margin: const EdgeInsets.all(5),
  //         content: Text(
  //           message,
  //           style: TextStyleClass.poppinsRegular(
  //               fontSize: 15, color: ColorClass.white),
  //         )));
  //   } catch (e) {
  //     _logger.e('❌ [SNACKBAR] Error showing snackbar: $e');
  //     developer.log('❌ Error showing snackbar: $e', name: 'AppUtils', error: e);
  //   }
  // }

  // static buttonWithOnlyText({
  //   required void Function() onTap,
  //   required double horizontalPadding,
  //   required double verticalPadding,
  //   required String title,
  //   required Color color,
  //   required Color borderColor,
  //   required double borderRadius,
  //   double borderWidth = 1,
  //   required TextStyle textStyle,
  // }) {
  //   _logger.d('🔘 [BUTTON] Creating button with text: $title');
  //   developer.log('🔘 Creating button with text: $title', name: 'AppUtils');
    
  //   return GestureDetector(
  //     onTap: () {
  //       _logger.d('👆 [BUTTON] Button tapped: $title');
  //       developer.log('👆 Button tapped: $title', name: 'AppUtils');
  //       onTap();
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //           horizontal: horizontalPadding, vertical: verticalPadding),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(borderRadius),
  //         border: Border.all(color: borderColor, width: borderWidth),
  //         color: color,
  //       ),
  //       child: Text(title, style: textStyle),
  //     ),
  //   );
  // }

  // static agreeButton({
  //   required void Function() onTap,
  //   required String title,
  //   required double width,
  //   bool isDisabled = false,
  //   bool isLoading = false,
  // }) {
  //   _logger.d('✅ [AGREE_BUTTON] Creating agree button: $title (disabled: $isDisabled, loading: $isLoading)');
  //   developer.log('✅ Creating agree button: $title', name: 'AppUtils');
    
  //   return GestureDetector(
  //     onTap: isDisabled
  //         ? () {
  //             _logger.d('🚫 [AGREE_BUTTON] Button disabled, ignoring tap');
  //             developer.log('🚫 Button disabled, ignoring tap', name: 'AppUtils');
  //           }
  //         : () {
  //             _logger.d('👆 [AGREE_BUTTON] Agree button tapped: $title');
  //             developer.log('👆 Agree button tapped: $title', name: 'AppUtils');
  //             onTap();
  //           },
  //     child: Container(
  //       width: width,
  //       height: 52,
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: isDisabled ? ColorClass.neutral200 : ColorClass.greenDark,
  //           boxShadow: [
  //             BoxShadow(
  //                 color: isDisabled
  //                     ? ColorClass.neutral200.withOpacity(0.08)
  //                     : ColorClass.greenDark.withOpacity(0.08),
  //                 blurRadius: 2,
  //                 spreadRadius: 0,
  //                 offset: const Offset(0, 1))
  //           ]),
  //       child: Center(
  //           child: isLoading
  //               ? const CupertinoActivityIndicator(
  //                   color: Colors.white,
  //                 )
  //               : Text(
  //                   title,
  //                   style: TextStyleClass.poppinsMedium(
  //                           fontSize: 16, color: ColorClass.white)
  //                       .copyWith(height: 2.08),
  //                 )),
  //     ),
  //   );
  // }

  // static noDataFoundWidget() {
  //   _logger.d('📭 [NO_DATA] Creating no data found widget');
  //   developer.log('📭 Creating no data found widget', name: 'AppUtils');
    
  //   return Center(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         // SvgPicture.asset(
  //         //   ImageClass
  //         //       .no_data_image, height: 80.0,),
  //         const SizedBox(
  //           height: 10.0,
  //         ),
  //         Text(
  //           "Oops!!",
  //           style: TextStyleClass.poppinsRegular(
  //               fontSize: 15, color: ColorClass.greenDark),
  //         ),
  //         const SizedBox(
  //           height: 10.0,
  //         ),
  //         Text(
  //           "No data found ",
  //           style: TextStyleClass.poppinsRegular(
  //               fontSize: 15, color: ColorClass.greenDark),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // static loadingWidget(BuildContext context, double? size) {
  //   _logger.d('⏳ [LOADING] Creating loading widget with size: $size');
  //   developer.log('⏳ Creating loading widget', name: 'AppUtils');
    
  //   return SizedBox(
  //       height: size,
  //       child: const Center(
  //           child: CupertinoActivityIndicator(
  //         radius: 10.0,
  //       )));
  // }

  // static String formatTime(DateTime? dateTime) {
  //   try {
  //     _logger.d('🕐 [TIME_FORMAT] Formatting time: $dateTime');
  //     developer.log('🕐 Formatting time', name: 'AppUtils');
      
  //     // Format the DateTime to "hh:mm a" using intl package
  //     String formattedDate =
  //         DateFormat("hh:mm a").format(dateTime ?? DateTime.now());
      
  //     _logger.d('🕐 [TIME_FORMAT] Formatted result: $formattedDate');
  //     return formattedDate;
  //   } catch (e) {
  //     _logger.e('❌ [TIME_FORMAT] Error formatting time: $e');
  //     developer.log('❌ Error formatting time: $e', name: 'AppUtils', error: e);
  //     return DateFormat("hh:mm a").format(DateTime.now());
  //   }
  // }

  // static String formatDateForApi(String dateStr) {
  //   try {
  //     _logger.d('📅 [DATE_FORMAT] Formatting date for API: $dateStr');
  //     developer.log('📅 Formatting date for API: $dateStr', name: 'AppUtils');
      
  //     // Split the date string
  //     final parts = dateStr.split('-');
  //     if (parts.length == 3) {
  //       final day = parts[0];
  //       final month = parts[1];
  //       final year = parts[2];
  //       final result = '$year-$month-$day'; // Convert to ISO format
        
  //       _logger.d('📅 [DATE_FORMAT] Formatted result: $result');
  //       developer.log('📅 Formatted result: $result', name: 'AppUtils');
  //       return result;
  //     }
      
  //     _logger.w('⚠️ [DATE_FORMAT] Invalid date format, returning original: $dateStr');
  //     developer.log('⚠️ Invalid date format: $dateStr', name: 'AppUtils');
  //     return dateStr;
  //   } catch (e) {
  //     _logger.e('❌ [DATE_FORMAT] Error formatting date: $e');
  //     developer.log('❌ Error formatting date: $e', name: 'AppUtils', error: e);
  //     return dateStr;
  //   }
  // }

  // static loadingWidgetWhite(BuildContext context, double? size) {
  //   _logger.d('⏳ [LOADING_WHITE] Creating white loading widget with size: $size');
  //   developer.log('⏳ Creating white loading widget', name: 'AppUtils');
    
  //   return SizedBox(
  //       height: size,
  //       child: const Center(
  //           child: CupertinoActivityIndicator(
  //         radius: 10.0,
  //         color: Colors.white,
  //       )));
  // }
}