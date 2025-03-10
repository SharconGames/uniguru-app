import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniguru/context/AuthNotifier.dart';

class CustomDropdown extends ConsumerStatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final String assetPath;
  final List<String> guruId;

  const CustomDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.hint,
    required this.assetPath,
    required this.guruId,
    required bool isDesktop,
  });

  @override
  ConsumerState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends ConsumerState<CustomDropdown> {
  late List<String> itemsWithCreateGuru;

  @override
  void initState() {
    super.initState();
    itemsWithCreateGuru = [...widget.items, "Create Guru"];
  }

  //Function for extended guruname with three...
  String _truncateText(String text) {
    if (text.length > 8) {
      return '${text.substring(0, 8)}..';
    }
    return text;
  }

  void _deleteGuru(String guruId, BuildContext context, WidgetRef ref) async {
    try {
      // Get the current auth state
      final currentState = ref.read(authStateProvider);

      // Check if the guru is currently selected
      final isSelected = currentState.selectedGuru?.id == guruId;

      if (isSelected) {
        // Show warning dialog for selected guru
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF2B1736),
              title: Text(
                'Cannot Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                constraints: BoxConstraints(
                  maxWidth: 260,
                  maxHeight: 100,
                ),
                child: Text(
                  'Select a different guru before deleting the current one.',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lexend',
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              actionsPadding: EdgeInsets.only(
                bottom: 10,
                right: 10,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

      // Perform deletion immediately in the UI
      setState(() {
        // Remove the guru from the local lists
        final index = widget.guruId.indexOf(guruId);
        if (index != -1) {
          itemsWithCreateGuru.removeAt(index);
          (widget.guruId).removeAt(index);
        }
      });

      // Perform backend deletion
      await ref.read(authStateProvider.notifier).removeGuru(guruId);

      // Save updated guruIds to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('guruIds', widget.guruId);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Guru deleted successfully!'),
          backgroundColor: Color(0xFF2B1736),
        ),
      );

      // Close the dropdown or dialog
      Navigator.pop(context);
    } catch (error) {
      // Revert UI changes if deletion fails
      setState(() {
        // Restore the original lists
        itemsWithCreateGuru = [...widget.items, "Create Guru"];
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting guru: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DropdownMenuItem<String?> _buildCreateGuruItem() {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    // Font size calculation function
    double calculateFontSize(double baseSize) {
      return isDesktop
          ? screenWidth * 0.010
          : isTablet
              ? screenWidth * 0.020
              : baseSize * (textScaleFactor > 1.0 ? 0.7 : 1.0);
    }

    return DropdownMenuItem<String?>(
      value: null,
      enabled: false,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/createguru');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2B1736),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: const Color(0xFF9790DA),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF9790DA),
                        Color(0xFFAD7FDF),
                        Color(0xFF779BED),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Create Guru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    bool isMTablet = MediaQuery.of(context).size.shortestSide >= 900;

    return Consumer(
      builder: (context, ref, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dropdownWidth = isDesktop
            ? screenWidth * 0.18
            : isTablet
                ? screenWidth * 0.30
                : isMTablet
                    ? screenWidth * 0.35
                    : screenWidth * 0.55;

        // Dynamically adjust leftPadding based on selected value's length
        double leftPadding = 10.0;
        if (widget.selectedValue != null) {
          if (widget.selectedValue!.length > 10) {
            leftPadding =
                20.0; // If the selected value is long, add more padding
          } else if (widget.selectedValue!.length > 5) {
            leftPadding = 15.0; // Slight padding for medium length values
          }
        }

        return SizedBox(
          width: dropdownWidth,
          child: Container(
            decoration: BoxDecoration(
              border: isDesktop
                  ? Border.all(color: Colors.white24) // Border for desktop
                  : isTablet
                      ? Border.all(color: Colors.white24)
                      : null, // No border for non-desktop
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String?>(
                  menuMaxHeight: 300,
                  itemHeight: null,
                  isExpanded: true,
                  value: widget.selectedValue,
                  icon: Padding(
                    padding: EdgeInsets.only(left: leftPadding),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF7F6209),
                      size: 30,
                    ),
                  ),
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF664D00),
                              Color(0xFF7F6209),
                              Color(0xFFDAA520),
                              Color(0xFF7F6209),
                              Color(0xFF664D00),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            widget.hint,
                            style: const TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onChanged: widget.onChanged,
                  items: [
                    ...widget.items
                        .asMap()
                        .entries
                        .map<DropdownMenuItem<String?>>(
                          (entry) => DropdownMenuItem<String?>(
                            value: entry.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                            colors: [
                                              Color(0xFF59D2BF),
                                              Color(0xFF74BDCC),
                                              Color(0xFF9791DB),
                                            ],
                                          ).createShader(bounds),
                                          child: Text(
                                            '${entry.key + 1}.',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                const LinearGradient(
                                              colors: [
                                                Color(0xFF59D2BF),
                                                Color(0xFF74BDCC),
                                                Color(0xFF9791DB),
                                              ],
                                            ).createShader(bounds),
                                            child: Text(
                                              entry.value,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (entry.value != "UniGuru")
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _deleteGuru(widget.guruId[entry.key],
                                            context, ref);
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    _buildCreateGuruItem(),
                  ],
                  selectedItemBuilder: (BuildContext context) {
                    return [...widget.items, 'Create Guru']
                        .map<Widget>((String item) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF664D00),
                                Color(0xFF7F6209),
                                Color(0xFFDAA520),
                                Color(0xFF7F6209),
                                Color(0xFF664D00),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              _truncateText(item),
                              style: const TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  dropdownColor: const Color(0xFF2B1736),
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                  ),
                  iconEnabledColor: const Color(0xFF7F6209),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
