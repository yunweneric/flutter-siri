import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget circleButton({required BuildContext context, required String icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).cardColor,
      child: SvgPicture.asset(icon, color: Theme.of(context).primaryColorLight),
    ),
  );
}
