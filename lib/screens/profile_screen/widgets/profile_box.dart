import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';
import 'package:lucide_icons/lucide_icons.dart';

//Profile Box
class ProfileBox extends StatelessWidget {
  final String userName;
  final String phone;
  final String designation;

  const ProfileBox({super.key, 
    required this.userName,
    required this.phone,
    required this.designation,
  });

  bool get isEmptyData =>
    userName.trim().isEmpty &&
    phone.trim().isEmpty &&
    designation.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmptyData) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorClass.greenDarker,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: ColorClass.brandLightGreen,
              child: Icon(LucideIcons.user, color: ColorClass.greenDarker, size: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text('No data available',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorClass.greenDarker,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: ColorClass.brandLightGreen,
            child: Text(userName[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 28,
                color: ColorClass.brandDarkGreen,
                fontWeight: FontWeight.bold)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(phone, style: const TextStyle(fontSize: 16, color: Colors.white70),),
                Text(designation, style: const TextStyle(fontSize: 16, color: Colors.white70),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}