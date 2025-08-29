import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/category_filter.dart';

class ProfilePreferenceCard extends StatelessWidget {
  const ProfilePreferenceCard({
    super.key,
    required this.onTap,
    required this.subtitle,
  });

  final VoidCallback onTap;
  final List<String> subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '개인 취향',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CategoryFilter<String>(
              items: subtitle,
              labelBuilder: (c) => c,
              mode: SelectionMode.multiple,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
