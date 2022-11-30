import "package:canacache/features/firestore/model/documents/item.dart";
import "package:flutter/material.dart";

class ItemList extends StatefulWidget {
  final List<Item> items;

  const ItemList({super.key, required this.items});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        children: widget.items
            .map(
              (item) => ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                title: Text(item.name),
              ),
            )
            .toList(),
      ),
    );
  }
}
