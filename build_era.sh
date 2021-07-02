#!/bin/bash

##################################################
# ERHEAのビルドを実行するシェル
# これ単体でも実行できる
##################################################

# ERHEAのビルド
echo "[ビルド開始] ERHEA"
cd packager && ./gradlew jar && cd ../
echo "[ビルド終了] ERHEA"

# 依存ライブラリを流し込み
echo "[作成済シンボリックリンク削除開始] ERHEA_PIの依存ライブラリ（FTG4.50/lib）"
find FTG4.50/lib/ERHEA_PI -type l -exec unlink {} \;
echo "[作成済シンボリックリンク削除終了] ERHEA_PIの依存ライブラリ（FTG4.50/lib）"
echo "[シンボリックリンク作成開始] ERHEA_PIの依存ライブラリ（FTG4.50/lib）"
lndir $(pwd)/packager/build/dependencies $(pwd)/FTG4.50/lib
lndir $(pwd)/packager/build/dependencies $(pwd)/FTG4.50/lib/ERHEA_PI
echo "[シンボリックリンク作成終了] ERHEA_PIの依存ライブラリ（FTG4.50/lib）"

echo "🎉ビルドが完了しました🎉"
