import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final String assetPath;

  const CustomDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.hint,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selectedValue,
      hint: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF664D00), // Dark Golden
              Color(0xFF7F6209), // Dark Orchid
              Color(0xFFDAA520), // Golden Rod
              Color(0xFF7F6209), // Dark Orchid
              Color(0xFF664D00), // Dark Golden
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'Lexend',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onChanged: onChanged,
      items: items.asMap().entries.map<DropdownMenuItem<String?>>(
        (entry) {
          int index = entry.key;
          String value = entry.value;

          return DropdownMenuItem<String?>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF59D2BF), // Teal
                      Color(0xFF74BDCC), // Aqua Blue
                      Color(0xFF9791DB), // Soft Blue
                    ],
                  ).createShader(bounds),
                  child: Text(
                    '${index + 1}.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  assetPath,
                  height: 25,
                  width: 25,
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF59D2BF), // Teal
                      Color(0xFF74BDCC), // Aqua Blue
                      Color(0xFF9791DB), // Soft Blue
                    ],
                  ).createShader(bounds),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),

      // This is where the selected value is shown.
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF664D00), // Dark Golden
                  Color(0xFF7F6209), // Dark Orchid
                  Color(0xFFDAA520), // Golden Rod
                  Color(0xFF7F6209), // Dark Orchid
                  Color(0xFF664D00), // Dark Golden
                ],
              ).createShader(bounds),
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList();
      },
      dropdownColor: const Color(0xFF2B1736),
      style: const TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.bold),
      iconEnabledColor: const Color(0xFF7F6209), // Golden Rod
      borderRadius: BorderRadius.circular(20),
      underline: const SizedBox.shrink(),
    );
  }
}
