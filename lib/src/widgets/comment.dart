import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>> itemMap;
  final int depth;

  Comment({required this.itemId, required this.itemMap,required this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel?>(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;
        if (item == null) {
          return Text('Comment not found');
        }


        final children = <Widget>[
          ListTile(
            title:buildText(item),
            subtitle:Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0,
            ),
          ),
          Divider(),
        ];

        if (item.kids.isNotEmpty) {
          children.addAll(
            item.kids.map((kidId) {
              return Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              );
            }).toList(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
    );
  }

   buildText(ItemModel item){
    final text = item.text
        .replaceAll('&#x2F'," ' ")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');

    return Text(text);
  }
}


