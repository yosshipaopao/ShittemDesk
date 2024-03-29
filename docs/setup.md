# environment
- [Godot Engine 4.2.1 (Mono)](https://godotengine.org/)
- [Rust (windows)](https://www.rust-lang.org/ja)
- [Visual Studio 2022](https://visualstudio.microsoft.com/ja/vs/) with c++
- [SCons](https://scons.org/)

# How to Setup

## setup winrt

```
cargo build --manifest-path winrt/Cargo.toml
cargo build --manifest-path winrt/Cargo.toml --release
```
## setup gd_cubism
[gd_cubism docs](https://mizunagikb.github.io/gd_cubism/BUILD.html) を参考にしてください

```
git clone https://github.com/MizunagiKB/gd_cubism.git
cd gd_cubism
git submodule update --init
```
download sdk from [Live2d official page](https://www.live2d.com/)
```
scons platform=windows arch=x86_64 target=template_debug
scons platform=windows arch=x86_64 target=template_release
```

bring files from `gd_cubism\demo\addons\gd_cubism\bin\*` to `Godot\addons\gd_cubism\bin`

# Directory Structures
```
.
├── assets                  # アセットを作るにあたって作成したプロジェクトファイルなど
├── ShittemDesk             # 主となるGodotのプロジェクトファイル
├── docs                    # ドキュメント
├── Setup                   # 配布用のインストーラーを作成するVSのソリューション
├── winrt                   # Godotで無理やりwinrtを使うためのGDExtesion
├── LICENSE
└── README.md
```

# Related Information
- [gdext](https://godot-rust.github.io/)
- [windows-rs](https://github.com/microsoft/windows-rs)
- [WinRT](https://learn.microsoft.com/ja-jp/uwp/api/)
- [Live2D Cubism SDK](https://www.live2d.com/sdk/about/)
- [gd_cubism](https://github.com/MizunagiKB/gd_cubism)
