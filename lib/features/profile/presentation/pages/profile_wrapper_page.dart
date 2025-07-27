import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/auth_feature.dart';
import 'profile_page.dart';

class ProfileWrapperPage extends StatefulWidget {
  const ProfileWrapperPage({super.key});

  @override
  State<ProfileWrapperPage> createState() => _ProfileWrapperPageState();
}

class _ProfileWrapperPageState extends State<ProfileWrapperPage> {
  @override
  void initState() {
    super.initState();
    // AuthBloc zaten Shell Route'da initialize edildi
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF090909),
      body: ProfilePage(),
    );
  }
} 