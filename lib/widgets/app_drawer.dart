import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildListItem({
    required BuildContext ctx,
    required String title,
    required IconData icon,
    required String routeName,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.of(ctx).pushReplacementNamed(routeName);
      },
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
            ctx: context,
            title: "Shop",
            icon: Icons.shop,
            routeName: "/",
          ),
          _buildListItem(
            ctx: context,
            title: "Orders",
            icon: Icons.payments,
            routeName: OrdersScreen.routeName,
          ),
          _buildListItem(
            ctx: context,
            icon: Icons.edit,
            title: "Manage Products",
            routeName: UserProductsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
