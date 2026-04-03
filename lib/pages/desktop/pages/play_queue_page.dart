import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/components/cover_art_widget.dart';
import 'package:particle_music/components/playlist_widgets.dart';
import 'package:particle_music/l10n/generated/app_localizations.dart';
import 'package:particle_music/viewmodels/my_audio_metadata.dart';
import 'package:particle_music/utils/utils.dart';
import 'package:super_context_menu/super_context_menu.dart';

class PlayQueuePage extends StatefulWidget {
  const PlayQueuePage({super.key});

  @override
  State<PlayQueuePage> createState() => _PlayQueuePageState();
}

class _PlayQueuePageState extends State<PlayQueuePage> {
  final scrollController = ScrollController();
  final selectedIndicesNotifier = ValueNotifier<Set<int>>({});
  int continuousSelectBeginIndex = 0;

  late bool isMiniMode;
  static const double itemExtent = 64.0;

  @override
  void initState() {
    super.initState();
    isMiniMode = miniModeNotifier.value;
    _resetSelection();
    if (!isMiniMode) {
      displayPlayQueuePageNotifier.addListener(_resetSelection);
    }
  }

  @override
  void dispose() {
    if (!isMiniMode) {
      displayPlayQueuePageNotifier.removeListener(_resetSelection);
    }
    selectedIndicesNotifier.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _resetSelection() {
    selectedIndicesNotifier.value = {};
    continuousSelectBeginIndex = 0;
  }

  void _jumpToCurrentSong({bool animate = false}) {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    final target = (itemExtent * audioHandler.currentIndex)
        .clamp(position.minScrollExtent, position.maxScrollExtent);

    if (animate) {
      scrollController.animateTo(target, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      scrollController.jumpTo(target);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    if (oldIndex == audioHandler.currentIndex) {
      audioHandler.currentIndex = newIndex;
    } else if (oldIndex < audioHandler.currentIndex && newIndex >= audioHandler.currentIndex) {
      audioHandler.currentIndex -= 1;
    } else if (oldIndex > audioHandler.currentIndex && newIndex <= audioHandler.currentIndex) {
      audioHandler.currentIndex += 1;
    }

    final item = playQueue.removeAt(oldIndex);
    playQueue.insert(newIndex, item);
    audioHandler.saveAllStates();

    _resetSelection();
  }

  List<MyAudioMetadata> _getSelectedSongs() {
    final indices = selectedIndicesNotifier.value;
    return indices.where((i) => i < playQueue.length).map((i) => playQueue[i]).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        _buildTopBar(l10n),
        const SizedBox(height: 10),
        Expanded(
          child: RepaintBoundary(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverReorderableList(
                  itemExtent: itemExtent,
                  onReorder: _onReorder,
                  itemCount: playQueue.length,
                  itemBuilder: (context, index) => _buildQueueItem(context, index, l10n),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Text(
          l10n.playQueue,
          style: TextStyle(
            fontSize: isMiniMode ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: isMiniMode ? Colors.grey.shade100 : null,
          ),
        ),
        const Spacer(),
        IconButton(
          color: isMiniMode ? Colors.grey.shade100 : iconColor,
          onPressed: () {
            audioHandler.reversePlayQueue();
            _jumpToCurrentSong();
            _resetSelection();
          },
          icon: ImageIcon(reverseImage),
        ),
        ValueListenableBuilder<int>(
          valueListenable: playModeNotifier,
          builder: (_, playMode, _) => IconButton(
            color: isMiniMode ? Colors.grey.shade100 : iconColor,
            icon: ImageIcon(
              playMode == 0 ? loopImage : playMode == 1 ? shuffleImage : repeatImage,
            ),
            onPressed: () {
              if (playModeNotifier.value != 2) {
                audioHandler.switchPlayMode();
                showCenterMessage(context, playModeNotifier.value == 0 ? l10n.loop : l10n.shuffle);
                _jumpToCurrentSong();
              }
            },
            onLongPress: () {
              audioHandler.toggleRepeat();
              final msg = switch (playModeNotifier.value) {
                0 => l10n.loop,
                1 => l10n.shuffle,
                _ => l10n.repeat,
              };
              showCenterMessage(context, msg);
            },
          ),
        ),
        IconButton(
          color: isMiniMode ? Colors.grey.shade100 : iconColor,
          onPressed: () => _jumpToCurrentSong(animate: true),
          icon: ImageIcon(location),
        ),
        IconButton(
          onPressed: () async {
            if (await showConfirmDialog(context, l10n.clear)) {
              await audioHandler.clear();
              displayPlayQueuePageNotifier.value = false;
              displayLyricsPageNotifier.value = false;
            }
          },
          icon: ImageIcon(deleteImage, color: isMiniMode ? Colors.grey.shade100 : iconColor),
        ),
      ],
    );
  }

  Widget _buildQueueItem(BuildContext context, int index, AppLocalizations l10n) {
    return ContextMenuWidget(
      key: ValueKey(playQueue[index].id ?? index),
      child: PlayQueueItem(
        index: index,
        selectedIndicesNotifier: selectedIndicesNotifier,
        continuousSelectBeginIndex: continuousSelectBeginIndex,
        onTap: () => _handleItemTap(index),
        onContinuousBeginChanged: (newBegin) => continuousSelectBeginIndex = newBegin,
      ),
      menuProvider: (_) => _buildContextMenu(context, index, l10n),
    );
  }

  Menu _buildContextMenu(BuildContext context, int index, AppLocalizations l10n) {
    final selected = selectedIndicesNotifier.value;
    if (!selected.contains(index)) {
      selectedIndicesNotifier.value = {index};
      continuousSelectBeginIndex = index;
    }

    return Menu(
      children: [
        MenuAction(
          title: l10n.add2Playlist,
          image: MenuImage.icon(Icons.playlist_add_rounded),
          callback: () => showAddPlaylistDialog(context, _getSelectedSongs()),
        ),
        MenuAction(
          title: l10n.playNext,
          image: MenuImage.icon(Icons.navigate_next_rounded),
          callback: _playSelectedNext,
        ),
        MenuAction(
          title: l10n.remove,
          image: MenuImage.icon(Icons.close_rounded),
          callback: _removeSelected,
        ),
      ],
    );
  }

  void _handleItemTap(int index) {
    final selected = selectedIndicesNotifier.value.toSet();

    if (ctrlIsPressed) {
      selected.contains(index) ? selected.remove(index) : selected.add(index);
      continuousSelectBeginIndex = index;
    } else if (shiftIsPressed) {
      final left = continuousSelectBeginIndex < index ? continuousSelectBeginIndex : index;
      final right = continuousSelectBeginIndex > index ? continuousSelectBeginIndex : index;
      selected.clear();
      for (int i = left; i <= right; i++) {
        selected.add(i);
      }
    } else {
      selected.clear();
      selected.add(index);
      continuousSelectBeginIndex = index;
    }

    selectedIndicesNotifier.value = selected;
  }

  void _playSelectedNext() {
    for (final song in _getSelectedSongs()) {
      audioHandler.insert2Next(song);
    }
    audioHandler.saveAllStates();
    _resetSelection();
  }

  Future<void> _removeSelected() async {
    bool removeCurrent = false;
    final indices = selectedIndicesNotifier.value.toList()..sort((a, b) => b.compareTo(a));

    for (final i in indices) {
      if (i < audioHandler.currentIndex) {
        audioHandler.currentIndex -= 1;
      } else if (i == audioHandler.currentIndex) {
        removeCurrent = true;
        if (audioHandler.currentIndex == playQueue.length - 1 && playQueue.isNotEmpty) {
          audioHandler.currentIndex = 0;
        }
      }
      audioHandler.delete(i);
    }

    _resetSelection();

    if (playQueue.isEmpty) {
      await audioHandler.clear();
      displayPlayQueuePageNotifier.value = false;
      displayLyricsPageNotifier.value = false;
    } else if (removeCurrent) {
      await audioHandler.load();
    }
    audioHandler.saveAllStates();
  }
}

// ====================== PlayQueueItem ======================

class PlayQueueItem extends StatefulWidget {
  final int index;
  final ValueNotifier<Set<int>> selectedIndicesNotifier;
  final int continuousSelectBeginIndex;
  final VoidCallback onTap;
  final ValueChanged<int> onContinuousBeginChanged;

  const PlayQueueItem({
    super.key,
    required this.index,
    required this.selectedIndicesNotifier,
    required this.continuousSelectBeginIndex,
    required this.onTap,
    required this.onContinuousBeginChanged,
  });

  @override
  State<PlayQueueItem> createState() => _PlayQueueItemState();
}

class _PlayQueueItemState extends State<PlayQueueItem> {
  final showPlayButtonNotifier = ValueNotifier(false);

  @override
  void dispose() {
    showPlayButtonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: widget.index,
      child: ValueListenableBuilder<Set<int>>(
        valueListenable: widget.selectedIndicesNotifier,
        builder: (context, selected, child) {
          final isSelected = selected.contains(widget.index);

          return ValueListenableBuilder<MyAudioMetadata?>(
            valueListenable: currentSongNotifier,
            builder: (_, currentSong, __) {
              return Material(
                color: isSelected
                    ? (miniModeNotifier.value ? currentCoverArtColor : selectedItemColor)
                    : Colors.transparent,
                child: child,
              );
            },
            child: MouseRegion(
              onEnter: (_) => showPlayButtonNotifier.value = true,
              onExit: (_) => showPlayButtonNotifier.value = false,
              child: InkWell(
                onTap: widget.onTap,
                child: _buildListTile(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile() {
    final song = playQueue[widget.index];

    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          miniModeNotifier.value
              ? CoverArtWidget(size: 40, borderRadius: 4, song: song)
              : CoverArtWidget(size: 50, borderRadius: 5, song: song),
          ValueListenableBuilder<bool>(
            valueListenable: showPlayButtonNotifier,
            builder: (_, show, __) => show
                ? IconButton(
                    onPressed: () async {
                      audioHandler.currentIndex = widget.index;
                      await audioHandler.load();
                      await audioHandler.play();
                    },
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: miniModeNotifier.value ? 20 : 30,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      title: ValueListenableBuilder<MyAudioMetadata?>(
        valueListenable: currentSongNotifier,
        builder: (_, currentSong, __) {
          final isCurrent = playQueue[widget.index] == currentSong;   // ← 正确使用

          return Text(
            getTitle(song),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isCurrent
                  ? (miniModeNotifier.value ? Colors.white : highlightTextColor)
                  : (miniModeNotifier.value ? Colors.grey.shade100 : null),
              fontWeight: isCurrent ? FontWeight.bold : null,
              fontSize: 15,
            ),
          );
        },
      ),
      subtitle: Text(
        "${getArtist(song)} - ${getAlbum(song)}",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: miniModeNotifier.value ? Colors.grey.shade100 : null,
        ),
      ),
      trailing: Text(
        formatDuration(getDuration(song)),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: miniModeNotifier.value ? Colors.grey.shade100 : null,
        ),
      ),
    );
  }
}