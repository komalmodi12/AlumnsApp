import 'package:flutter/material.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:alumns_app/core/api/api_service_manager.dart';
import 'package:alumns_app/core/api/api_helper.dart';
import 'package:alumns_app/features/auth/models/api_models.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({super.key});

  @override
  State<CirclePage> createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  int selectedIndex = 4;
  List<User> users = [];
  bool isLoading = true;
  String? error;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
    context.trackPageView('circle');
  }

  Future<void> _loadUsers() async {
    try {
      final allUsers = await ApiService.user.getAllUsers();
      if (mounted) {
        setState(() {
          users = allUsers;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load users';
          isLoading = false;
        });
      }
    }
  }

  List<User> get filteredUsers {
    if (searchQuery.isEmpty) {
      return users;
    }
    return users
        .where(
          (user) =>
              user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: selectedIndex,
      onTabSelected: onTabSelected,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUsers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(child: Text('No users found'))
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: user.avatar != null
                                    ? NetworkImage(user.avatar!)
                                    : null,
                                child: user.avatar == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                // Navigate to user detail screen if needed
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
