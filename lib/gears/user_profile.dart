import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This file is not currently used but is essential for a future update.
// "final profile" will hold even more personalized settings to give the user a more personalized experience
class UserProfile extends StatelessWidget {
  const UserProfile({super.key, this.profile});

  final profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(child: profile),
    );
  }
}
