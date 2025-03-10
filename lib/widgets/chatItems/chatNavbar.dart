// ChatNavBar.dart
import 'package:flutter/material.dart';
import 'package:uniguru/widgets/dropdown.dart';

class ChatNavBar extends StatelessWidget {
  final String? selectedUsers;
  final List<String> gurus;
  final Function(String?) onUserSelected;
  final VoidCallback onMenuTap;
  final List<String> guruId;

  const ChatNavBar({
    super.key,
    required this.selectedUsers,
    required this.gurus,
    required this.onUserSelected,
    required this.onMenuTap,
    required this.guruId,
    required bool isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: isDesktop
                    ? 30
                    : isTablet
                        ? 15
                        : 0),
            child: CustomDropdown(
              guruId: [...guruId],
              assetPath: 'assets/spritual_light.png',
              items: [...gurus],
              selectedValue: selectedUsers,
              onChanged: onUserSelected,
              hint: 'Uniguru',
              isDesktop: isDesktop,
            ),
          ),
          GestureDetector(
            onTap: onMenuTap,
            child: const SizedBox(
              height: 50,
              width: 50,
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
