// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uniguru/widgets/login/google_signin_api.dart';

// class DemoScreen extends ConsumerWidget {
//   const DemoScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider); // Watch the userProvider

//     return Scaffold(
//       body: Center(
//         child: user == null
//             ? const Text('No user signed in') // Handle null case
//             : Text(
//                 'Welcome, ${user.uid}', // Display user email if available
//                 style: const TextStyle(fontSize: 18),
//               ),
//       ),
//     );
//   }
// }
