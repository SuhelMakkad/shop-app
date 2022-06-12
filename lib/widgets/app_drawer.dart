import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildListItem({
    required String title,
    required IconData icon,
    required void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              "My Shope",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          _buildListItem(
            title: "Shop",
            icon: Icons.shop,
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          _buildListItem(
            title: "Orders",
            icon: Icons.payments,
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          _buildListItem(
            icon: Icons.edit,
            title: "Manage Products",
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          _buildListItem(
            icon: Icons.exit_to_app,
            title: "Log Out",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");

              final authData = Provider.of<Auth>(context, listen: false);
              authData.logout();
            },
          ),
        ],
      ),
    );
  }
}
