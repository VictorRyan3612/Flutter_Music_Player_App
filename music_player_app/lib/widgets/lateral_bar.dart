import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExtensibleLateralBarItem{
  final Icon icon;
  final Text title;
  final Function onTap;

  const ExtensibleLateralBarItem({required this.icon, required this.title, required this.onTap});
}

class ExtensibleLateralBar extends HookWidget {
  final List<ExtensibleLateralBarItem> items;
  const ExtensibleLateralBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    Color colorContainer = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    var isOpen = useState(true);
    return Expanded(
      flex: isOpen.value == true ? 2 : 1,
      child: Container(
        color: colorContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      isOpen.value = !isOpen.value;
                    }, 
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        if(isOpen.value == true){
                          return ListTile(
                            leading: items[index].icon,
                            title: items[index].title,
                            onTap: items[index].onTap()
                          );
                        }
                        else{
                          return IconButton(
                            onPressed: items[index].onTap(),
                            icon: items[index].icon,
                            tooltip: items[index].title.data,
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}