import 'package:flutter/material.dart';
import 'package:packup/provider/tour/guide/tour_listing_provider.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/tour/guide/listing/tour_listing_card.dart';
import 'package:packup/widget/tour/guide/listing/section/tour_listing_empty_section.dart';

class TourListingListSection extends StatefulWidget {
  const TourListingListSection({super.key});

  @override
  State<TourListingListSection> createState() => _TourListingListSectionState();
}

class _TourListingListSectionState extends State<TourListingListSection> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final p = context.read<TourListingProvider>();
      if (!p.loading &&
          p.hasMore &&
          _controller.position.pixels >
              _controller.position.maxScrollExtent - 200) {
        p.fetchNext();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TourListingProvider>(
      builder: (_, p, __) {
        if (p.loading && p.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (p.items.isEmpty) return const TourListingEmptySection();

        return RefreshIndicator(
          onRefresh: p.refresh,
          child: ListView.separated(
            controller: _controller,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: p.items.length + (p.loading ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              if (i >= p.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              final item = p.items[i];
              return TourListingCard(
                item: item,
                onTap: () {
                  // 상세/편집 라우팅
                  // context.push('/g/listing/${item.id}');
                },
              );
            },
          ),
        );
      },
    );
  }
}
