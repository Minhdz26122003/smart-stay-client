import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../property/presentation/cubit/property_state.dart';
import '../../../listing/presentation/cubit/listing_cubit.dart';
import '../../../listing/presentation/cubit/listing_state.dart';
import '../../../property/presentation/cubit/property_cubit.dart';
import '../../../listing/domain/entities/listing.dart';

class LandlordListingsScreen extends StatefulWidget {
  const LandlordListingsScreen({super.key});

  @override
  State<LandlordListingsScreen> createState() => _LandlordListingsScreenState();
}

class _LandlordListingsScreenState extends State<LandlordListingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final propState = context.read<PropertyCubit>().state;
    String? propertyId;
    propState.maybeWhen(
      loaded: (_, selected) => propertyId = selected?.id,
      orElse: () {},
    );
    context.read<ListingCubit>().loadLandlordListings(propertyId);
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final propState = context.read<PropertyCubit>().state;
    String? currentPropId;
    propState.maybeWhen(loaded: (_, s) => currentPropId = s?.id, orElse: () {});

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Quản lý đăng tin',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<ListingCubit, ListingState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text('Lỗi: $msg')),
            loaded: (listings) {
              final activeCount = listings.where((l) => l.isActive).length;
              final hiddenCount = listings.where((l) => !l.isActive).length;

              return Column(
                children: [
                  // Stats
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        _StatBox(
                          label: 'Đang đăng',
                          value: '$activeCount',
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        _StatBox(
                          label: 'Đã ẩn',
                          value: '$hiddenCount',
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  // Listing list
                  Expanded(
                    child: listings.isEmpty
                        ? const Center(
                            child: Text(
                              'Chưa có tin đăng nào. \nHãy tạo tin mới!',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: listings.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (ctx, i) {
                              final l = listings[i];
                              final statusColor = l.isActive
                                  ? Colors.green
                                  : Colors.grey;
                              final statusText = l.isActive
                                  ? 'Đang hiển thị'
                                  : 'Đã ẩn';

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    // Image placeholder
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                      child: Container(
                                        height: 110,
                                        color: cs.primaryContainer.withValues(
                                          alpha: 0.3,
                                        ),
                                        child: Stack(
                                          children: [
                                            if (l.photoUrls.isNotEmpty)
                                              Positioned.fill(
                                                child: Image.network(
                                                  l.photoUrls.first,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            else
                                              Center(
                                                child: Icon(
                                                  Icons.apartment_rounded,
                                                  size: 40,
                                                  color: cs.primary.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                ),
                                              ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: statusColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  statusText,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  l.title,
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '${_formatPrice(l.price)}/tháng',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: cs.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              l.description,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: cs.onSurface
                                                        .withValues(alpha: 0.5),
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          // Action row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                l.isActive
                                                    ? 'Bật hiển thị'
                                                    : 'Đã ẩn',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: cs.onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                              ),
                                              Switch(
                                                value: l.isActive,
                                                onChanged: (val) {
                                                  context
                                                      .read<ListingCubit>()
                                                      .toggleListing(
                                                        l.id,
                                                        currentPropId,
                                                      );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/landlord/add'),
        backgroundColor: cs.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Đăng tin mới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
