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

# FTG4.50/libに依存関係用のディレクトリを作成
if [ -d FTG4.50/lib/ERHEA_PI ]; then
    echo "[依存関係用ディレクトリ作成済] FTG4.50/lib/ERHEA_PI"
else
    echo "[依存関係用ディレクトリ作成開始] FTG4.50/lib/ERHEA_PI"
    mkdir FTG4.50/lib/ERHEA_PI
    echo "[依存関係用ディレクトリ作成終了] FTG4.50/lib/ERHEA_PI"
fi

if [ -d FTG4.50/lib/ERHEA_PI_DJL ]; then
    echo "[依存関係用ディレクトリ作成済] FTG4.50/lib/ERHEA_PI_DJL"
else
    echo "[依存関係用ディレクトリ作成開始] FTG4.50/lib/ERHEA_PI_DJL"
    mkdir FTG4.50/lib/ERHEA_PI_DJL
    echo "[依存関係用ディレクトリ作成終了] FTG4.50/lib/ERHEA_PI_DJL"
fi

# ERHEA DLJのzipがあれば展開
if [ -f ./ERHEA_PI_DJL.zip ] && ! [ -d ./ERHEA_PI_DJL ]; then
    echo "[配置開始] ERHEA_PI_DJL"
    unzip ERHEA_PI_DJL.zip
    echo "[配置終了] ERHEA_PI_DJL"
elif [ -d ./ERHEA_PI_DJL ]; then
    echo "[展開済] ERHEA_PI_DJL"
else
    echo "[展開スキップ] ERHEA_PI_DJL（ファイルが見つかりませんでした）"
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

# for ERHEA_PI_DJL
if [ -L $(pwd)/packager_2021/lib/FightingICE.jar ]; then
    echo "[シンボリックリンク作成済] packager_2021/lib/FightingICE.jar"
else
    echo "[シンボリックリンク作成開始] packager_2021/lib/FightingICE.jar"
    ln -s $(pwd)/FTG4.50/FightingICE.jar $(pwd)/packager_2021/lib
    echo "[シンボリックリンク作成終了] packager_2021/lib/FightingICE.jar"
fi

if [ -L $(pwd)/FTG4.50/data/aiData/ERHEA_PI_DJL ]; then
    echo "[シンボリックリンク作成済] FTG4.50/data/aiData/ERHEA_PI_DJL"
elif [ -d ./ERHEA_PI_DJL ]; then
    echo "[シンボリックリンク作成開始] FTG4.50/data/aiData/ERHEA_PI_DJL"
    ln -s $(pwd)/ERHEA_PI_DJL/aiData/ERHEA_PI_DJL $(pwd)/FTG4.50/data/aiData/ERHEA_PI_DJL
    echo "[シンボリックリンク作成終了] FTG4.50/data/aiData/ERHEA_PI_DJL"
else
    echo "[シンボリックリンク作成スキップ] ERHEA_PI_DJL（ファイルが見つかりませんでした）"
fi

if [ -f $(pwd)/packager_2021/src/main/java/ERHEA_PI_DJL.java ]; then
    echo "[シンボリックリンク作成済] packager_2021/src/main/java"
elif [ -d ./ERHEA_PI_DJL ]; then
    echo "[シンボリックリンク作成開始] packager_2021/src/main/java"
    lndir $(pwd)/ERHEA_PI_DJL/Code/erhea_mvn/src/main/java $(pwd)/packager_2021/src/main/java
    echo "[シンボリックリンク作成終了] packager_2021/src/main/java"
else
    echo "[シンボリックリンク作成スキップ] ERHEA_PI_DJL（ファイルが見つかりませんでした）"
fi

# どうにかしたいがどうにもならなかった
sed --version &> /dev/null
if [ $? -eq 0 ]; then
    bash ./replace_era_djl_files.sh
else
    sh ./replace_era_djl_files.sh
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

echo "🎉初期化が完了しました🎉"
echo "ERHEA_PIをビルドするには sh ./build_era.sh を実行します"
echo "ERHEA_PI_DJLをビルドするには sh ./build_era_djl.sh を実行します"
