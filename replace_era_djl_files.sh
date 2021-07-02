#!/bin/bash

##################################################
# ERHEA DJLのコンパイルエラーをなくすためのシェル
# 通常はinit.shから呼ばれるがあまりにも趣旨から外れるため
# ファイル置換だけシェルを分けた
# ファイルが正しく修正されると
#   // modify by init.sh
# というコメントが追記される
# これは編集の重複を防ぐためのコメントでもある
##################################################

if [ -d ./ERHEA_PI_DJL ]; then

    sed --version &> /dev/null

    if [ $? -eq 0 ]; then
        # GNU版はversionオプションがある
        sedopt=''
        echo '[sed判定] GNU sed'
    else
        # BSD版はversionオプションがない
        sedopt=' '
        echo '[sed判定] BSD sed'
    fi

    # メインファイルコンパイルエラーを修正する
    result=$(cat packager_2021/src/main/java/ERHEA_PI_DJL.java | grep '// modify by init.sh')
    if [ "$result" != '' ]; then
        echo "[ファイル修正済] packager_2021/src/main/java/ERHEA_PI_DJL.java"
    else
        echo "[ファイル修正開始] packager_2021/src/main/java/ERHEA_PI_DJL.java"

        import='\/\/ modify by init.sh\
import struct.Key;\
import struct.ScreenData;'
    sed -i${sedopt}'' "s/import struct.Key;/${import}/" ERHEA_PI_DJL/Code/erhea_mvn/src/main/java/ERHEA_PI_DJL.java > /dev/null

        impl='    \/\/ modify by init.sh\
    @Override\
    public void getInformation(FrameData frameData) {\
\
    }\
\
    @Override\
    public void getScreenData(ScreenData sd) {\
        AIInterface.super.getScreenData(sd);\
    }\
\
}\
'
        sed -i${sedopt}'' "s/^}/${impl}/" ERHEA_PI_DJL/Code/erhea_mvn/src/main/java/ERHEA_PI_DJL.java > /dev/null
        echo "[ファイル修正完了] packager_2021/src/main/java/ERHEA_PI_DJL.java"
    fi

else
    echo "[ファイル修正スキップ] ERHEA_PI_DJL（ファイルが見つかりませんでした）"
fi

