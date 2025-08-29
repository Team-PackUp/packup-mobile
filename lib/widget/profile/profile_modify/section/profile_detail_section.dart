import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/user/user_provider.dart';
import '../../../../view/profile/profile_modify/profile_preference.dart';
import '../../../common/category_filter.dart';
import '../profile_preference_card.dart';

class ProfileDetailSection extends StatefulWidget {
  final void Function(List<String>) preferenceChange;

  const ProfileDetailSection({super.key, required this.preferenceChange});

  @override
  State<ProfileDetailSection> createState() => _ProfileDetailSectionState();
}

class _ProfileDetailSectionState extends State<ProfileDetailSection> {

  List<String> selectedPreference = [];

  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;

    final user = context.read<UserProvider>().userModel!;
    selectedPreference = List<String>.from(user.preferCategorySeqJson ?? []);
  }

  void _emitPreference() {
    widget.preferenceChange(selectedPreference);
  }

  void _openPreferencePicker() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePreference(
          initialSelected: selectedPreference,
          onChanged: (list) {
            if (!mounted) return;
            setState(() {
              selectedPreference = list;
              _emitPreference();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePreferenceCard(
            subtitle: selectedPreference,
            onTap: _openPreferencePicker,
          ),
      ],
    );
  }
}

