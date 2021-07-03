# ERHEA Build Pack

## 概要
* ERHEAをFightingICEに組み込むための自動スクリプト群です。
* 必要な依存関係を解決し、ERHEAをFightingICEで実行可能にします。
* シンボリックリンクで構築しているため、ファイルを更新しても改めてコピーする必要はありません。

## 必要要件
* nkfコマンド
* lndirコマンド
* Java 1.8

## 動作確認環境
* MacOS 10.15.7
* Ubuntu 18.04.5 LTS

## 実行コマンド
### 初期化スクリプト実行
`sh init.sh`

### ERHEAビルドスクリプト実行（ERHEAのコードを改変したときに実行します）
`sh build_era.sh`

### ERHEA DJLビルドスクリプト実行（ERHEA DJLのコードを改変したときに実行します）
`sh build_era_djl.sh`

## やってること
1. Gitサブモジュールの取得（GameAI-FightingAI, FTGrunner）\[init.sh\]
1. FTG4.50のダウンロード\[init.sh\]
1. ERHEAのファイル書き換え\[replace_era_files.sh\]
1. シンボリックリンクの作成
    * ERHEAビルドのためのFightingICE.jar\[init.sh\]
    * FTGrunner実行のためのFTG4.50\[init.sh\]
    * ERHEAビルドのためのGameAI-FightingAIソース\[init.sh\]
1. ERHEAのビルド\[build_era.sh\]
1. シンボリックリンクの作成
    * FTG4.50実行のためのERHEA_PI.jarが依存するライブラリ群\[build_era.sh\]
    * ERHEAをFTG4.50に読み込むためのERHEA_PI.jar\[init.sh\]

## ディレクトリ構造
```bash
.
├── FTG4.50 # FTG4.5本体
│   ├── data
│   │   ├── ai # ERHEA_PI.jarのシンボリックリンクがある
│   └── lib # ERHEA_PI.jarが依存するライブラリのシンボリックリンクがある
├── FTGrunner
│   ├── FTG4.50 # FTG4.50のシンボリックリンク
├── GameAI-FightingAI # ビルド時のエラー回避のためにinit.shでファイルを編集します
├── README.md # このドキュメント
├── build_era.sh # ERHEAビルドスクリプト
├── init.sh # 初期化スクリプト
├── packager
│   ├── build
│   │   ├── dependencies # ERHEA_PI.jarが依存するライブラリのjarが格納されています
│   │   └── libs # ビルド後のERHEA_PI.jarが格納されています
│   ├── build.gradle # Javaをビルドするための設定ファイル
│   ├── lib
│   │   └── FightingICE.jar # FTG4.50/FightingICE.jarのシンボリックリンク
│   └── src
│       └── main
│           └── java # GameAI-FightingAI/FTGAI-RHEA/2020-ERHEA/srcのシンボリックリンク
└── replace_era_files.sh # ERHEAのファイルを書き換えるスクリプト
```
