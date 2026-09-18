import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../state/location_provider.dart';

class LocationSearchModal extends StatefulWidget {
  final LocationNotifier locationNotifier;

  const LocationSearchModal({super.key, required this.locationNotifier});

  static Future<void> show(BuildContext context, LocationNotifier notifier) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161A22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => LocationSearchModal(locationNotifier: notifier),
    );
  }

  @override
  State<LocationSearchModal> createState() => _LocationSearchModalState();
}

class _LocationSearchModalState extends State<LocationSearchModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    widget.locationNotifier.clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: ValueListenableBuilder<LocationState>(
        valueListenable: widget.locationNotifier,
        builder: (context, state, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'LOCATIONS & NODES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 14),
              // Search Input Field
              TextField(
                controller: _searchController,
                autofocus: false,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search city or node (e.g. Kyoto, London)...',
                  hintStyle:
                      const TextStyle(color: Colors.white38, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.softAmber, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              color: Colors.white38, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            widget.locationNotifier.clearSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.honeyGold),
                  ),
                ),
                onChanged: (val) => widget.locationNotifier.search(val),
              ),
              const SizedBox(height: 16),
              // Search Results vs Saved Locations
              if (state.isSearching)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(
                        color: AppColors.softAmber, strokeWidth: 2),
                  ),
                )
              else if (state.searchResults.isNotEmpty) ...[
                const Text(
                  'SEARCH RESULTS',
                  style: TextStyle(
                      fontSize: 10,
                      color: AppColors.softAmber,
                      letterSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.searchResults.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                      final item = state.searchResults[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on_outlined,
                            color: AppColors.softAmber, size: 20),
                        title: Text(item.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        subtitle: Text(
                          [item.admin1, item.country]
                              .whereType<String>()
                              .join(', '),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),
                        onTap: () {
                          widget.locationNotifier.addAndSelectLocation(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ] else ...[
                const Text(
                  'SAVED NODES',
                  style: TextStyle(
                      fontSize: 10, color: Colors.white38, letterSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.savedLocations.length,
                    itemBuilder: (context, index) {
                      final loc = state.savedLocations[index];
                      final isActive = index == state.activeIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.honeyGold.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          leading: Icon(
                            loc.isCurrentLocation
                                ? Icons.near_me_rounded
                                : Icons.location_city_rounded,
                            size: 18,
                            color:
                                isActive ? AppColors.honeyGold : Colors.white38,
                          ),
                          title: Text(
                            loc.name,
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.softAmber
                                  : Colors.white70,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            loc.admin1 ?? loc.country ?? '',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 11),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isActive)
                                const Icon(Icons.check_rounded,
                                    color: AppColors.honeyGold, size: 18),
                              if (state.savedLocations.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      size: 16, color: Colors.white30),
                                  onPressed: () => widget.locationNotifier
                                      .removeLocation(index),
                                ),
                            ],
                          ),
                          onTap: () {
                            widget.locationNotifier.setActiveLocation(index);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
