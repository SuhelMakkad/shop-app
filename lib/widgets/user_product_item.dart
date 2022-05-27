import 'package:flutter/material.dart';

class UserProdcutItem extends StatelessWidget {
  const UserProdcutItem({
    required this.title,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              color: themeData.colorScheme.primary,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: themeData.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
