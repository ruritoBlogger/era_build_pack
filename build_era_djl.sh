#!/bin/bash

##################################################
# ERHEA DJLのビルドを実行するシェル
# これ単体でも実行できる
##################################################

# ERHEA DJLのビルド
echo "[ビルド開始] ERHEA DJL"
cd packager_2021 && ./gradlew jar && cd ../
echo "[ビルド終了] ERHEA DJL"

# ERHEA_PI_DJLをFTGにデプロイ
if [ -L $(pwd)/FTG4.50/data/ai/ERHEA_PI_DJL.jar ]; then
    echo "[シンボリックリンク作成済] FTG4.50/data/ai/ERHEA_PI_DJL.jar"
else
    echo "[シンボリックリンク作成開始] FTG4.50/data/ai/ERHEA_PI_DJL.jar"
    ln -s $(pwd)/packager_2021/build/libs/ERHEA_PI_DJL.jar $(pwd)/FTG4.50/data/ai
    echo "[シンボリックリンク作成終了] FTG4.50/data/ai/ERHEA_PI_DJL.jar"
fi

# 依存ライブラリを流し込み
echo "[作成済シンボリックリンク削除開始] ERHEA_PI_DJLの依存ライブラリ（FTG4.50/lib）"
find FTG4.50/lib/ERHEA_PI_DJL -type l -exec unlink {} \;
echo "[作成済シンボリックリンク削除終了] ERHEA_PI_DJLの依存ライブラリ（FTG4.50/lib）"
echo "[シンボリックリンク作成開始] ERHEA_PI_DJLの依存ライブラリ（FTG4.50/lib）"
lndir $(pwd)/packager_2021/build/dependencies $(pwd)/FTG4.50/lib
lndir $(pwd)/packager_2021/build/dependencies $(pwd)/FTG4.50/lib/ERHEA_PI_DJL
echo "[シンボリックリンク作成終了] ERHEA_PI_DJLの依存ライブラリ（FTG4.50/lib）"

echo "🎉ビルドが完了しました🎉"
