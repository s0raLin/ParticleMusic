<div align="center">
    <img src="./app_icons/icon.png" width="256"/>

# ParticleMusic

一款跨平台本地音乐播放器，支持 Android、iOS、Windows、Linux 和 macOS。

[English](./README.md) | 中文

</div>

## 功能特性

- **本地音乐库** — 基于文件夹扫描的音乐管理，支持搜索与排序
- **Navidrome 服务器** — 支持从 Subsonic/Navidrome 服务器串流播放
- **歌词显示** — LRC 解析、卡拉OK 式滚动歌词、独立桌面歌词窗口
- **迷你播放器** — 桌面端紧凑模式
- **播放队列管理** — 随机播放、单曲循环、列表循环、下一首播放、末尾添加
- **播放列表** — 本地播放列表 + Navidrome 同步
- **播放历史** — 按播放次数排行榜、最近播放
- **睡眠定时器** — 支持播放完成后暂停
- **深色模式** — 浅色/深色主题切换
- **自定义主题色** — 16 种颜色可调，支持从封面提取主色调
- **中英文双语** — 完整的中英文国际化支持
- **桌面端特色** — 系统托盘、键盘快捷键、多窗口歌词

## 支持格式

| 文件格式    | 元数据格式                      |
|------------|--------------------------------|
| AAC (ADTS) | `ID3v2`, `ID3v1`              |
| Ape        | `APE`, `ID3v2`\*, `ID3v1`     |
| AIFF       | `ID3v2`, `Text Chunks`        |
| FLAC       | `Vorbis Comments`, `ID3v2`\*  |
| MP3        | `ID3v2`, `ID3v1`, `APE`       |
| MP4        | `iTunes-style ilst`           |
| MPC        | `APE`, `ID3v2`\*, `ID3v1`\*   |
| Opus       | `Vorbis Comments`             |
| Ogg Vorbis | `Vorbis Comments`             |
| Speex      | `Vorbis Comments`             |
| WAV        | `ID3v2`, `RIFF INFO`          |
| WavPack    | `APE`, `ID3v1`                |

\* 标记为 `*` 的格式仅支持读取，不支持写入

## 项目结构

```
lib/
├── api/                          # API 请求
│   └── navidrome_client.dart     # Subsonic/Navidrome API 客户端
├── components/                   # 公共组件
│   ├── lyrics.dart               # 歌词解析与显示
│   ├── seekbar.dart              # 进度条
│   ├── cover_art_widget.dart     # 封面组件
│   ├── play_queue_sheet.dart     # 播放队列面板
│   └── ...
├── constants/                    # 常量文件
│   ├── common.dart               # 全局常量与图片资源
│   └── app_theme.dart            # 主题配置
├── l10n/                         # 国际化 (中/英)
├── pages/                        # 页面
│   ├── view_entry.dart           # 视图路由入口
│   ├── landscape_view/           # 桌面端 UI（侧边栏、面板、标题栏）
│   ├── portrait_view/            # 移动端 UI（抽屉、页面）
│   ├── mini_view/                # 迷你播放器
│   └── layer/                    # 导航图层系统
├── routes/                       # 路由配置
├── stores/                       # 全局状态
│   ├── audio_state.dart          # 播放状态
│   ├── ui_state.dart             # UI 状态
│   ├── settings_state.dart       # 设置状态
│   ├── color_state.dart          # 颜色状态
│   └── desktop_lyrics_state.dart # 桌面歌词状态
├── utils/                        # 工具类
│   ├── dialog_utils.dart         # 弹窗工具
│   ├── song_utils.dart           # 歌曲元数据、排序
│   ├── image_utils.dart          # 封面加载、颜色提取
│   ├── path_utils.dart           # 路径处理
│   └── ...
├── viewmodels/                   # 数据模型与管理器
│   ├── audio_handler.dart        # 音频播放引擎
│   ├── library.dart              # 音乐库管理
│   ├── playlists.dart            # 播放列表管理
│   ├── history.dart              # 播放历史
│   └── ...
└── main.dart                     # 应用入口
```

## 技术栈

| 用途         | 依赖                                          |
|-------------|-----------------------------------------------|
| 音频播放     | [media_kit](https://github.com/media-kit/media-kit.git) (基于 mpv/FFmpeg) |
| 后台播放     | [audio_service](https://pub.dev/packages/audio_service) |
| 媒体键集成   | audio_service_mpris (Linux), audio_service_win (Windows) |
| 桌面窗口     | [window_manager](https://github.com/leanflutter/window_manager.git) |
| 系统托盘     | [tray_manager](https://github.com/leanflutter/tray_manager.git) |
| 多窗口       | [desktop_multi_window](https://pub.dev/packages/desktop_multi_window) |
| 元数据读写   | [audio_tags_lofty](https://github.com/AfalpHy/audio_tags_lofty.git) (基于 Rust lofty) |
| 网络请求     | [dio](https://pub.dev/packages/dio) |
| 状态管理     | ValueNotifier + ValueListenableBuilder |
| 数据持久化   | JSON 文件 |
| 国际化       | Flutter 内置 l10n |
| 字体         | Google Fonts (Windows Noto Serif SC) |

## 构建与运行

请先按照 [Flutter 官方安装指南](https://docs.flutter.dev/install/manual) 安装 Flutter。

### Ubuntu/Debian

```bash
# 安装 Flutter 依赖
sudo apt install clang lld cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# 安装音频库
sudo apt install libmpv-dev

git clone https://github.com/AfalpHy/ParticleMusic.git
cd ParticleMusic

# 检查开发环境
flutter doctor -v

# 调试模式运行
flutter run

# 发布模式运行
flutter run --release

# 构建
flutter build linux

# 生成 .deb 安装包
flutter build linux && ./generate_deb.sh
```

### Windows

安装 [Visual Studio](https://visualstudio.microsoft.com/)。

```bash
git clone https://github.com/AfalpHy/ParticleMusic.git
cd ParticleMusic

flutter doctor -v
flutter run              # 调试模式
flutter run --release    # 发布模式
flutter build windows    # 构建
```

### macOS & iOS

安装 Xcode 及 Xcode Command Line Tools，参考 [Apple Developer 下载页面](https://developer.apple.com/download/all/)。

```bash
git clone https://github.com/AfalpHy/ParticleMusic.git
cd ParticleMusic

# 安装 CocoaPods
sudo gem install cocoapods
# 或
brew install cocoapods

flutter doctor -v
flutter run
flutter run --release
flutter build macos

# 构建未签名的 IPA (iOS)
flutter build ios --release --no-codesign && \
mkdir -p Payload && \
cp -r build/ios/iphoneos/Runner.app Payload/ && \
zip -r ParticleMusic.ipa Payload && \
rm -rf Payload
```

### Android

安装 [Android Studio](https://developer.android.com/studio) 及 Android SDK Command-line Tools。

```bash
git clone https://github.com/AfalpHy/ParticleMusic.git
cd ParticleMusic

# 接受 SDK 许可
flutter doctor --android-licenses

flutter doctor -v
flutter run
flutter run --release
flutter build apk
```

## 应用截图

### iOS
<div>
    <img src="./screenshot/mobile0.png" width="270" height="540" />
    <img src="./screenshot/mobile1.png" width="270" height="540" />
    <img src="./screenshot/mobile2.png" width="270" height="540" />
</div>

<div>
    <img src="./screenshot/mobile3.png" width="270" height="540" />
    <img src="./screenshot/mobile4.png" width="270" height="540" />
    <img src="./screenshot/mobile5.png" width="270" height="540" />
</div>

<div>
    <img src="./screenshot/mobile6.png" width="270" height="540" />
    <img src="./screenshot/mobile7.png" width="270" height="540" />
    <img src="./screenshot/mobile8.png" width="270" height="540" />
</div>

### Windows

![](./screenshot/desktop0.png)
![](./screenshot/desktop1.png)
![](./screenshot/desktop2.png)
![](./screenshot/desktop3.png)
![](./screenshot/desktop4.png)
![](./screenshot/desktop5.png)
![](./screenshot/desktop6.png)
![](./screenshot/desktop7.png)
![](./screenshot/desktop8.png)
![](./screenshot/desktop9.png)
![](./screenshot/desktop10.png)

## 许可证

本项目仅供学习和个人使用。
