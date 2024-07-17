import 'package:flutter/material.dart';

class OtherPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;

  const OtherPageAppBar({
    Key? key,
    required this.heading,
    this.rightIcon,
    this.onRightIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kblue = Color(0xFF71b8ff);
    return SafeArea(
      child: AppBar(
        title: Text(
          heading,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, 
          ),
        ),
        centerTitle: true,

        backgroundColor: kblue, 
        toolbarHeight: 80, 
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), 
            bottomRight: Radius.circular(10), 
          ),
        ),
        
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(64); 
}
