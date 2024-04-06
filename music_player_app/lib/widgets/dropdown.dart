import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DropdownWidget extends HookWidget {
  const DropdownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var menuItems = <String>[
      'title',
      'album',
      'artist'
    ];
    List<DropdownMenuItem<String>> dropdownMenuItems = menuItems.map(
      (String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ),
    ).toList();

    var textValue = useState<String?>(null);

    return DropdownButton(
      value: textValue.value,
      hint: const Text('Choose'),
      onChanged: (String? newValue) {
        if (newValue != null) {
          textValue.value = newValue;
        }
      },
      items: dropdownMenuItems,
    );
  }
}
