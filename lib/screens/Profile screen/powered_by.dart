import 'package:flutter/material.dart';
import '../../../constants/color_class.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/icons_class.dart';
import '../../../constants/textstyle_class.dart';

//powered by
class PoweredBy extends StatelessWidget {
  const PoweredBy({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Powered by',
          style: TextStyleClass.poppinsMedium(
            fontSize: 14,
            color: ColorClass.neutral400,
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(IconClass.d4dxLogo, height: 60),
        const SizedBox(height: 8),
        Text(
          'v${GlobalVariables.appVersion}',
          style: TextStyleClass.poppinsRegular(
            fontSize: 12,
            color: ColorClass.neutral400,
          ),
        ),
      ],
    );
  }
}