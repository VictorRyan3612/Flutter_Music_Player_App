import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExtensibleLateralBar extends HookWidget {
  const ExtensibleLateralBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color colorContainer = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    var isOpen = useState(false);
    return Builder(
      builder: (context) {
        if (isOpen.value) {
          return Expanded(
            flex: 2,
            child: Container(
              color: colorContainer,
              child: ListView(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      isOpen.value = !isOpen.value;
                    }, 
                  ),
                  ListTile(
                    leading: Icon(Icons.home_filled),
                    title: Text("Inicio"),
                    onTap: () {
                      
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text("Artistas"),
                    onTap: () {
                      
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.library_music),
                    title: Text("Albums"),
                    onTap: () {
                      
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Configuracoes"),
                    onTap: () {
                      Navigator.pushNamed(context, '/configs');
                    },)
                ],
              ),
            ),
          );
        } else {
          return Container(
            color: colorContainer,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      isOpen.value = !isOpen.value;
                    }, 
                  ),
                  IconButton(
                    icon: Icon(Icons.home_filled),
                    onPressed: () {
                      
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.people),
                    onPressed: () {
                      
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.library_music),
                    onPressed: () {
                      
                    },
                  ),
                  Divider(),

                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: (){
                      Navigator.pushNamed(context, '/configs');
                      },
                    )
                ]
              ),
            ),
          );
        }
      },
    );
  }
}