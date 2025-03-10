// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:uniguru/widgets/dropdown.dart';
// import 'package:uniguru/widgets/starScreen/star_background.dart';

// class PreferenceScreen extends StatefulWidget {
//   const PreferenceScreen({super.key});

//   @override
//   State<PreferenceScreen> createState() => _PreferenceScreenState();
// }

// class _PreferenceScreenState extends State<PreferenceScreen> {
//   String? selectedUsers;
//   List<String> users = [
//     "Blackhole Guru",
//     "AI Guru",
//     "Robot Guru",
//     "Human Guru",
//     "Khol Guru"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
//         (screenWidth > 600 && screenWidth / screenHeight < 0.6);

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0513),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Star background
//           StarBackground(),

//           // Blur the entire background
//           ImageFiltered(
//             imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//             child: Container(
//               color: Colors.black.withOpacity(0.2),
//             ),
//           ),

//           // Blur entire content
//           ImageFiltered(
//             imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//             child: Opacity(
//               opacity: 0.9,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(height: screenHeight * 0.1),

//                   // Header Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Circle Avatar
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: GestureDetector(
//                           onTap: () {},
//                           child: SizedBox(
//                             height: 50,
//                             width: 50,
//                             child: Image.asset('assets/spritual_light.png'),
//                           ),
//                         ),
//                       ),
//                       // DropDown List
//                       CustomDropdown(
//                         assetPath: 'assets/spritual_light.png',
//                         selectedValue: selectedUsers,
//                         items: users,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedUsers = newValue;
//                           });
//                         },
//                         hint: 'BlackHole Guru',
//                       ),
//                       // Settings Button
//                       GestureDetector(
//                         onTap: () {},
//                         child: SizedBox(
//                           height: 50,
//                           width: 50,
//                           child: Icon(
//                             Icons.menu,
//                             color: Colors.white,
//                             size: 32,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: screenHeight * 0.2),

//                   SizedBox(height: screenHeight * 0.55),

//                   // Footer Row with Flexible and Expanded widgets
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       children: [
//                         // Ask Your Guru Label with Expanded
//                         Expanded(
//                           flex: isTablet ? 25 : 7,
//                           child: Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF18141C),
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                             child: const Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 'Ask Your Guru..',
//                                 style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // Mic Button
//                         Flexible(
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF18141C),
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.mic),
//                               color: Colors.white,
//                               onPressed: () {},
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // Send Button
//                         Flexible(
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF18141C),
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.send),
//                               color: Colors.white,
//                               onPressed: () {},
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Unblurred Preference Container
//           Center(
//             child: Container(
//               height: isTablet ? screenHeight * 0.35 : screenHeight * 0.3,
//               width: isTablet ? screenWidth * 0.26 : screenWidth * 0.75,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2B1736),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.5),
//                   width: 2,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   const Center(
//                     child: Text(
//                       'Select Your Preference',
//                       style: TextStyle(
//                         fontFamily: 'Lexend',
//                         fontSize: 15.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFFFFFFF),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/chat');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 13),
//                       backgroundColor: const Color(0xFF8AA2D5),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     child: const Text(
//                       "Let's Chat...",
//                       style: TextStyle(
//                         fontFamily: 'Lexend',
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const Text('OR'),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/chat');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 13),
//                       backgroundColor: const Color(0xFF8AA2D5),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     child: const Text(
//                       "Let's Talk...",
//                       style: TextStyle(
//                         fontFamily: 'Lexend',
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
