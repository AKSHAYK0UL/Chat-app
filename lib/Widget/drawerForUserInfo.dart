import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Screens/CommunityScreens/CreateCommunity.dart';
import 'package:nex_social/Screens/Drawer/AccountInfo.dart';
import 'package:nex_social/Screens/Drawer/PrivacyPolicy.dart';
import 'package:nex_social/Screens/Drawer/UpdateAccount.dart';
import 'package:nex_social/main.dart';

class drawerForUserInfo extends StatelessWidget {
  drawerForUserInfo({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  Widget drawerTilte(String text, IconData icon) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
          title: Text(
            text,
            style: Theme.of(navigatorkey.currentContext!).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1.5,
          color: Colors.black,
          endIndent: 10,
          indent: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            elevation: 0,
            title: Text(user.displayName!),
            automaticallyImplyLeading: false,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AccountInfo.routeName);
            },
            child: drawerTilte(
              'Account',
              Icons.person,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UpdateAccount.routeName);
            },
            child: drawerTilte(
              'Account Setting',
              Icons.settings,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                CreateCommunity.routeName,
              );
            },
            child: drawerTilte(
              'Create community',
              Icons.group_add_rounded,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: drawerTilte(
              'Your communities',
              Icons.group,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(PrivacyPolicy.routeName);
            },
            child: drawerTilte(
              'Privacy',
              Icons.verified_user,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11.5),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1.5, color: Colors.black),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        'LogOut',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      content: const Text('Are you sure you want to logout'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
                size: 30,
              ),
              label: Text(
                'Logout',
                style: Theme.of(navigatorkey.currentContext!)
                    .textTheme
                    .titleMedium,
              ),
            ),
          )
        ],
      ),
    );
  }
}
