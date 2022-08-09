import 'package:flutter/material.dart';
import 'configuraion_expansion_tile.dart';

class DetailsExpansionTile extends StatelessWidget {
  final String title;
  final bool expand;
  final List<Widget> children;
  final ValueChanged<bool>? onExpansionChanged;
  final GlobalKey? expansionTileKey;

  DetailsExpansionTile(
      {required this.title,
      required this.children,
      this.expand = false,
      this.onExpansionChanged,
      this.expansionTileKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 21.0),
      child: ConfigurableExpansionTile(
        initiallyExpanded: expand,
        headerExpanded: Flexible(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Container(
                  child: Icon(Icons.keyboard_arrow_up_outlined),
                  height: 20,
                  width: 20,
                )
              ]),
        ),
        header: Flexible(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                Icon(Icons.keyboard_arrow_down)
              ]),
        ),
        children: children,
        onExpansionChanged: onExpansionChanged,
        key: expansionTileKey,
      ),
    );
  }
}
