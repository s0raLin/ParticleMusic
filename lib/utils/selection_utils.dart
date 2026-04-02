import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/my_audio_metadata.dart';

/// 获取当前被选中的项（按逆序返回）
List<T> getSelectedItems<T>(
  List<ValueNotifier<bool>> isSelectedList,
  List<T> items,
) {
  final result = <T>[];
  for (int i = isSelectedList.length - 1; i >= 0; i--) {
    if (isSelectedList[i].value) {
      result.add(items[i]);
    }
  }
  return result;
}

/// 清除列表中的所有选中状态
void clearSelection(List<ValueNotifier<bool>> isSelectedList) {
  for (var item in isSelectedList) {
    item.value = false;
  }
}

/// 统计当前选中的项数量。
int countSelected(List<ValueNotifier<bool>> isSelectedList) {
  int count = 0;
  for (final item in isSelectedList) {
    if (item.value) count++;
  }
  return count;
}

/// 从播放队列中获取选中的歌曲（按逆序返回）
List<MyAudioMetadata> getSelectedSongs(
  List<ValueNotifier<bool>> isSelectedList,
  List<MyAudioMetadata> songList,
) {
  return getSelectedItems(isSelectedList, songList);
}