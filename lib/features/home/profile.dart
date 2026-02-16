import 'package:flutter/material.dart';
import 'package:alumns_app/features/home/widgets/app_layout.dart';
import 'package:alumns_app/core/api/api_helper.dart';
import 'package:alumns_app/features/auth/models/api_models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 1;
  User? _currentUser;
  bool _isLoading = true;
  String? _error;

  // Edit form controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserProfile();
    context.trackPageView('profile');
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await ApiHelper.getUserProfile(context: context);
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
          // Pre-fill form
          _nameController.text = user?.name ?? '';
          _phoneController.text = user?.phone ?? '';
          _bioController.text = user?.bio ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load profile';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    context.showLoading();

    await ApiHelper.updateProfile(
      context: context,
      name: _nameController.text,
      phone: _phoneController.text,
      bio: _bioController.text,
      onSuccess: () {
        context.closeLoading();
        context.showSuccess('Profile updated!');
        _loadUserProfile();
      },
      onError: (error) {
        context.closeLoading();
        context.showError('Failed to update');
      },
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // Already on Profile
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/events');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/jobs');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/circle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUserProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _buildProfileContent(),
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _currentUser?.avatar != null
                      ? NetworkImage(_currentUser!.avatar!)
                      : null,
                  child: _currentUser?.avatar == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  _currentUser?.name ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentUser?.email ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Edit Form
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            decoration: InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          // Update Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C3FCA),
              ),
              onPressed: _updateProfile,
              child: const Text(
                'Update Profile',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
