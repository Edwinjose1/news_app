// // lib/presentation/widgets/custom_app_bar.dart
// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;
//   final Widget? leading;
//   final bool centerTitle;
//   final double elevation;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.actions,
//     this.leading,
//     this.centerTitle = true,
//     this.elevation = 0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return AppBar(
//       title: Text(
//         title,
//         style: TextStyle(
//           color: theme.colorScheme.onPrimary,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       backgroundColor: theme.colorScheme.primary,
//       elevation: elevation,
//       centerTitle: centerTitle,
//       leading: leading,
//       actions: actions,
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }