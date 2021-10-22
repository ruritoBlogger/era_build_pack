#!/bin/bash

##################################################
# ERHEA PPO PGのビルドを実行するシェル
# これ単体でも実行できる
##################################################

# ERHEAのビルド
echo "[ビルド開始] ERHEA"
cd packager_PPO_PG && ./gradlew jar && cd ../
echo "[ビルド終了] ERHEA"

# 依存ライブラリを流し込み
echo "[作成済シンボリックリンク削除開始] ERHEA_PPO_PGの依存ライブラリ（FTG4.50/lib）"
find FTG4.50/lib/ERHEA_PPO_PG -type l -exec unlink {} \;
echo "[作成済シンボリックリンク削除終了] ERHEA_PPO_PGの依存ライブラリ（FTG4.50/lib）"
echo "[シンボリックリンク作成開始] ERHEA_PPO_PGの依存ライブラリ（FTG4.50/lib）"
lndir $(pwd)/packager_PPO_PG/build/dependencies $(pwd)/FTG4.50/lib
lndir $(pwd)/packager_PPO_PG/build/dependencies $(pwd)/FTG4.50/lib/ERHEA_PPO_PG
echo "[シンボリックリンク作成終了] ERHEA_PPO_PGの依存ライブラリ（FTG4.50/lib）"

# 本体を流し込む
if [ -L $(pwd)/FTG4.50/data/ai/ERHEA_PPO_PG.jar ]; then
    echo "[シンボリックリンク作成済] FTG4.50/data/ai/ERHEA_PPO_PG.jar"
else
    echo "[シンボリックリンク作成開始] FTG4.50/data/ai/ERHEA_PPO_PG.jar"
    ln -s $(pwd)/packager_PPO_PG/build/libs/ERHEA_PPO_PG.jar $(pwd)/FTG4.50/data/ai
    echo "[シンボリックリンク作成終了] FTG4.50/data/ai/ERHEA_PPO_PG.jar"
fi

echo "🎉ビルドが完了しました🎉"
