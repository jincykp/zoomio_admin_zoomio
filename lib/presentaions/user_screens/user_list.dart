import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_provider.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserAdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text(
          "Users List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: userProvider.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Consumer<UserAdminProvider>(
            builder: (context, provider, _) {
              if (provider.users.isEmpty) {
                return const Center(child: Text('No users available.'));
              }

              return ListView.builder(
                itemCount: provider.users.length,
                itemBuilder: (context, index) {
                  final user = provider.users[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: user.profileImageUrl != null
                            ? NetworkImage(user.profileImageUrl!)
                            : null,
                        child: user.profileImageUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(user.displayName),
                      subtitle: Text(user.email),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
