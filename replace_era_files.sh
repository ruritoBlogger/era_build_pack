#!/bin/bash

##################################################
# ERHEAのコンパイルエラーをなくすためのシェル
# 通常はinit.shから呼ばれるがあまりにも趣旨から外れるため
# ファイル置換だけシェルを分けた
# ファイルが正しく修正されると
#   // modify by init.sh
# というコメントが追記される
# これは編集の重複を防ぐためのコメントでもある
##################################################

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
result=$(cat GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/ERHEA_PI.java | grep '// modify by init.sh')
if [ "$result" != '' ]; then
    echo "[ファイル修正済] GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/ERHEA_PI.java"
else
    echo "[ファイル修正開始] GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/ERHEA_PI.java"
    import='\/\/ modify by init.sh\
import struct.Key;\
import struct.ScreenData;'
    sed -i${sedopt}'' "s/import struct.Key;/${import}/" GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/ERHEA_PI.java > /dev/null

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
    sed -i${sedopt}'' "s/^}$/${impl}/" GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/ERHEA_PI.java > /dev/null
    echo "[ファイル修正完了] GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/ERHEA_PI.java"
fi

# 変な文字コードを排除
result=$(cat GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java | grep '// modify by init.sh')
if [ "$result" != '' ]; then
    echo "[ファイル修正済] GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java"
else
    echo "[ファイル修正開始] GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java"
    i=1; modifired=0;
    while read line; do
        enc=$(echo $line | nkf --guess)
        if ! [[ "$enc" =~ ^.*ASCII.*$ ]] && ! [[ "$enc" =~ ^.*UTF-8.*$ ]]; then
            sed -i${sedopt}'' "${i}d" GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java > /dev/null
            modifired=$(expr $modifired + 1)
        else
            # コメントが削除されたときは行数が1行減るため
            # インクリメントは削除しなかったときのみ
            i=$(expr $i + 1)
        fi
    done < GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java

    # 2回目の編集を防ぐ
    class='\/\/ modify by init.sh\
public class Population {'
    sed -i${sedopt}'' "s/^public class Population {$/${class}/" GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java > /dev/null
    echo "[ファイル修正終了] GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/src/RHEA/Population.java（${modifired}行）"
fi

