import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../state/location_provider.dart';

class SavedLocationsDrawer extends StatefulWidget {
  final LocationNotifier locationNotifier;

  const SavedLocationsDrawer({
    super.key,
    required this.locationNotifier,
  });

  static Future<void> show(
    BuildContext context, {
    required LocationNotifier locationNotifier,
  }) {
    HapticFeedbackHelper.medium();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          SavedLocationsDrawer(locationNotifier: locationNotifier),
    );
  }

  @override
  State<SavedLocationsDrawer> createState() => _SavedLocationsDrawerState();
}

class _SavedLocationsDrawerState extends State<SavedLocationsDrawer> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearchingLocally = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _isSearchingLocally = query.trim().isNotEmpty;
        });
        widget.locationNotifier.search(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder<LocationState>(
      valueListenable: widget.locationNotifier,
      builder: (context, state, child) {
        return Container(
          height: screenHeight * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF13171F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 30,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pull handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.honeyGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/app_logo.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.location_city_rounded,
                              color: AppColors.honeyGold,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SAVED LOCATIONS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.8,
                                color:
                                    AppColors.honeyGold.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${state.savedLocations.length} Cities Monitored',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white60),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Action: Detect Live Location Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: state.isLocating
                          ? null
                          : () async {
                              HapticFeedbackHelper.selection();
                              await widget.locationNotifier
                                  .detectCurrentLocation(autoSelect: true);
                              if (context.mounted) Navigator.pop(context);
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: AppColors.twilightCyan.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                AppColors.twilightCyan.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (state.isLocating)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.twilightCyan,
                                ),
                              )
                            else
                              const Icon(
                                Icons.near_me_rounded,
                                color: AppColors.twilightCyan,
                                size: 18,
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.isLocating
                                        ? 'Detecting Current Location...'
                                        : 'Use My Current Location',
                                    style: const TextStyle(
                                      color: AppColors.twilightCyan,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  const Text(
                                    'GPS & Keyless IP Microclimate Node',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.twilightCyan,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E242E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search city, country, or neighborhood...',
                        hintStyle: const TextStyle(
                            color: Colors.white38, fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Colors.white54, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: Colors.white38, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Live Search Results or Saved List
                Expanded(
                  child: _isSearchingLocally || state.isSearching
                      ? _buildSearchResults(state)
                      : _buildSavedLocationsList(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(LocationState state) {
    if (state.isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.honeyGold,
        ),
      );
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.travel_explore_rounded,
                size: 40, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            const Text(
              'No matching locations found',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: state.searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final loc = state.searchResults[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              HapticFeedbackHelper.selection();
              await widget.locationNotifier.addAndSelectLocation(loc);
              if (context.mounted) Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B202B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warmSage.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_location_alt_rounded,
                        color: AppColors.warmSage, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (loc.country != null && loc.country!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            loc.country!,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white30, size: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedLocationsList(LocationState state) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: state.savedLocations.length,
      // ignore: deprecated_member_use
      onReorder: (oldIndex, newIndex) {
        HapticFeedbackHelper.selection();
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        widget.locationNotifier.reorderLocations(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final loc = state.savedLocations[index];
        final isActive = index == state.activeIndex;

        return Dismissible(
          key: ValueKey('${loc.name}_${loc.latitude}_${loc.longitude}'),
          direction: state.savedLocations.length > 1
              ? DismissDirection.endToStart
              : DismissDirection.none,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: Colors.redAccent, size: 24),
          ),
          onDismissed: (_) {
            HapticFeedbackHelper.medium();
            widget.locationNotifier.removeLocation(index);
          },
          child: Padding(
            key: ValueKey('pad_${loc.name}_$index'),
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  HapticFeedbackHelper.selection();
                  await widget.locationNotifier.setActiveLocation(index);
                  if (context.mounted) Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.honeyGold.withValues(alpha: 0.12)
                        : const Color(0xFF1E242E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive
                          ? AppColors.honeyGold.withValues(alpha: 0.4)
                          : Colors.white.withValues(alpha: 0.05),
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.honeyGold.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          loc.isCurrentLocation
                              ? Icons.near_me_rounded
                              : (isActive
                                  ? Icons.check_circle_rounded
                                  : Icons.location_on_outlined),
                          color: loc.isCurrentLocation
                              ? AppColors.twilightCyan
                              : (isActive
                                  ? AppColors.honeyGold
                                  : Colors.white60),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    loc.name,
                                    style: TextStyle(
                                      color: isActive
                                          ? AppColors.honeyGold
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (loc.isCurrentLocation) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: AppColors.twilightCyan
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'GPS LIVE',
                                      style: TextStyle(
                                        color: AppColors.twilightCyan,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (loc.country != null &&
                                loc.country!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                [loc.admin1, loc.country]
                                    .whereType<String>()
                                    .join(', '),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.drag_handle_rounded,
                              color: Colors.white24, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
