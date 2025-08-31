import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/guide/listing_create_provider.dart';

class StepLocationPin extends StatefulWidget {
  const StepLocationPin({super.key});

  @override
  State<StepLocationPin> createState() => _StepLocationPinState();
}

class _StepLocationPinState extends State<StepLocationPin> {
  double lat = 37.5665;
  double lng = 126.9780;

  late final ListingCreateProvider _p;

  @override
  void initState() {
    super.initState();
    _p = context.read<ListingCreateProvider>();

    lat = _p.getField<double>('meet.lat') ?? lat;
    lng = _p.getField<double>('meet.lng') ?? lng;

    _p.setNextGuard('pin', () async {
      _p.setFields({'meet.lat': lat, 'meet.lng': lng});
      return true;
    });
  }

  @override
  void dispose() {
    _p.setNextGuard('pin', null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '핀의 위치가 정확한가요?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '지도를 움직여 핀 위치를 조정하세요.',
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          const SizedBox(height: 16),

          // 지도 api 연동
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 260,
              color: const Color(0xFFF2F2F5),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?q=80&w=1400&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  const Icon(
                    Icons.location_on,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Column(
                      children: [
                        _circleButton(
                          Icons.add,
                          onTap: () => setState(() => lat += 0.0005),
                        ),
                        const SizedBox(height: 8),
                        _circleButton(
                          Icons.remove,
                          onTap: () => setState(() => lat -= 0.0005),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            '현재 좌표  lat: ${lat.toStringAsFixed(5)}, lng: ${lng.toStringAsFixed(5)}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: Icon(icon)),
      ),
    );
  }
}
