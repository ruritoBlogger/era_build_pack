#!/bin/bash

##################################################
# プロジェクト初期化シェル
# いろいろな依存関係を解決してくれる
##################################################

# サブモジュール取得
git submodule update --init --recursive --remote

# FTG4.50のダウンロード
if [ -d ./FTG4.50 ]; then
    echo "[DL済] FTG4.50"
else
    echo "[DL開始] FTG4.50"
    curl -O 'https://www.ice.ci.ritsumei.ac.jp/~ftgaic/Downloadfiles/FTG4.50.zip'
    echo "[DL終了] FTG4.50"
    echo "[配置開始] FTG4.50"
    unzip FTG4.50.zip
    rm -rf FTG4.50.zip
    echo "[配置終了] FTG4.50"
fi

# どうにかしたいがどうにもならなかった
sed --version &> /dev/null
if [ $? -eq 0 ]; then
    bash ./replace_era_files.sh
else
    sh ./replace_era_files.sh
fi

# シンボリックリンクの作成
if [ -L $(pwd)/packager/lib/FightingICE.jar ]; then
    echo "[シンボリックリンク作成済] packager/lib/FightingICE.jar"
else
    echo "[シンボリックリンク作成開始] packager/lib/FightingICE.jar"
    ln -s $(pwd)/FTG4.50/FightingICE.jar $(pwd)/packager/lib
    echo "[シンボリックリンク作成終了] packager/lib/FightingICE.jar"
fi

if [ -L $(pwd)/FTGrunner/FTG4.50 ]; then
    echo "[シンボリックリンク作成済] FTGrunner/FTG4.50"
else
    echo "[シンボリックリンク作成開始] FTGrunner/FTG4.50"
    ln -s $(pwd)/FTG4.50 $(pwd)/FTGrunner/FTG4.50
    echo "[シンボリックリンク作成終了] FTGrunner/FTG4.50"
fi

if [ -L $(pwd)/packager/src/main/java/ERHEA_PI.java ]; then
    echo "[シンボリックリンク作成済] packager/src/main/java"
else
    echo "[シンボリックリンク作成開始] packager/src/main/java"
    lndir $(pwd)/GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src $(pwd)/packager/src/main/java
    echo "[シンボリックリンク作成終了] packager/src/main/java"
fi

# ERHEAのビルド
sh ./build_era.sh

# ERHEAをFTGにデプロイ
if [ -L $(pwd)/FTG4.50/data/ai/ERHEA_PI.jar ]; then
    echo "[シンボリックリンク作成済] FTG4.50/data/ai/ERHEA_PI.jar"
else
    echo "[シンボリックリンク作成開始] FTG4.50/data/ai/ERHEA_PI.jar"
    ln -s $(pwd)/packager/build/libs/ERHEA_PI.jar $(pwd)/FTG4.50/data/ai
    echo "[シンボリックリンク作成終了] FTG4.50/data/ai/ERHEA_PI.jar"
fi
