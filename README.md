# 概要
シェルとjqのお勉強のために適当な仕様を作りそれをチェックする機能を作成した
- 文字の変換
- ファイルの存在
- 条件文
- 引数
- key, valueの配列処理
- function
- ファイルの読み込み書き込み

# やってて思った 
最初はjsonを書き換える機能を作ろうと思った。csv管理した方が基本は良いが、一対一の翻訳ではない場合（場所によって同じ日本語でも翻訳言語が違うようにしたい時）の対応ができないため、色々てまがかかるので今回はチェックのみにした。書き換え機能作るならcheck.txtよりどこかのファイルにまとめて以下のようなの作って自動的に文言を上書きした方がいい。後、区切り文字は考える必要がある
```
"path/to/file.json:tagNumber","日本語","韓国語"
```

# 仕様
以下のようなディレクトリの構成の中で翻訳が行われているのか確認する
- jsonデータの中の日本語のデータに更新がないか確認
- 韓国語のJsonデータがあるか確認
- チェック用の翻訳と違っていないか確認
- jsonデータの中の日本語が韓国語に変わっているかチェック
```
.
├── log
│   └── ja_kr_error_log.txt
├── source (いろんな言語データ)
└── tool
    └── textTranslationChecker.sh
```

# 起動に必要なもの
$　brew install bash  
$　brew install jq  

# 実行例
$ /usr/local/bin/bash tool/textTranslationChecker.sh 
```
指定された引数は0個です。
実行するには1個の引数が必要です。
実行例
/usr/local/bin/bash tool/textTranslationChecker.sh kr
以下インストールしていなければ入れてください
brew install bash
brew install jq
```
$ /usr/local/bin/bash tool/textTranslationChecker.sh kr 
```
グローバル変数
変数作成
base="ja"
translate="kr"
baseDirectory="./source/ja"
baseJsonList=
./source/ja/checkNotFound/a/week.json
./source/ja/checkNotFound/b/week.json
./source/ja/jsonNotFound/week.json
./source/ja/specialCharacter/false/text.json
./source/ja/specialCharacter/true/text.json
./source/ja/update/week.json
./source/ja/week/false/week.json
./source/ja/week/true/week.json
CHECK_FILE_NAME="check.txt"
logFile="./log/ja_kr_error_log.txt"

ディレクトリ作成
mkdir -p log
ログファイル削除
rm -rf ./log/*

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/checkNotFound/a/week.jsonファイルの翻訳チェック
./source/other/kr/checkNotFound/a/check.txt not found

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/checkNotFound/b/week.jsonファイルの翻訳チェック
./source/ja/checkNotFound/b/check.txt not found

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/jsonNotFound/week.jsonファイルの翻訳チェック
./source/other/kr/jsonNotFound/week.json not found

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/specialCharacter/false/text.jsonファイルの翻訳チェック
baseJson="./source/ja/specialCharacter/false/text.json"
translateJson="./source/other/kr/specialCharacter/false/text.json"
baseCheckFile="./source/ja/specialCharacter/false/check.txt"
translateCheckFile="./source/other/kr/specialCharacter/false/check.txt"

チェック対象のデータを取得する
データ数=2
CHECK_DATA_LIST["0"]="~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____"
CHECK_DATA_LIST["1"]="\"\n\\n\t\r\\t\\rfdfdffff____"

元ファイルの更新を確認する

比較を行う
tag:0 ja:"~!@#$%^&*()_+{}|:<>?'fdfd`fdfd", kr:"~!@#$%^&*()_+{}|:<>?'fdfd`fdfd", check:"~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____"  error01: 未翻訳 error02: チェック翻訳と違う
tag:1 ja:"\"\n\\n\t\r\\t\\rfdfdffff", kr:"\"\n\\n\t\r\\t\\rfdfdffff", check:"\"\n\\n\t\r\\t\\rfdfdffff____"  error01: 未翻訳 error02: チェック翻訳と違う

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/specialCharacter/true/text.jsonファイルの翻訳チェック
baseJson="./source/ja/specialCharacter/true/text.json"
translateJson="./source/other/kr/specialCharacter/true/text.json"
baseCheckFile="./source/ja/specialCharacter/true/check.txt"
translateCheckFile="./source/other/kr/specialCharacter/true/check.txt"

チェック対象のデータを取得する
データ数=2
CHECK_DATA_LIST["0"]="~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____"
CHECK_DATA_LIST["1"]="\"\n\\n\t\r\\t\\rfdfdffff____"

元ファイルの更新を確認する

比較を行う
tag:0 ja:"~!@#$%^&*()_+{}|:<>?'fdfd`fdfd", kr:"~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____", check:"~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____" 
tag:1 ja:"\"\n\\n\t\r\\t\\rfdfdffff", kr:"\"\n\\n\t\r\\t\\rfdfdffff____", check:"\"\n\\n\t\r\\t\\rfdfdffff____" 

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/update/week.jsonファイルの翻訳チェック
baseJson="./source/ja/update/week.json"
translateJson="./source/other/kr/update/week.json"
baseCheckFile="./source/ja/update/check.txt"
translateCheckFile="./source/other/kr/update/check.txt"

チェック対象のデータを取得する
データ数=7
CHECK_DATA_LIST["0"]="일요일"
CHECK_DATA_LIST["1"]="월요일"
CHECK_DATA_LIST["2"]="화요일"
CHECK_DATA_LIST["3"]="수요일"
CHECK_DATA_LIST["4"]="목요일"
CHECK_DATA_LIST["5"]="금요일"
CHECK_DATA_LIST["6"]="토요일"

元ファイルの更新を確認する
tag:7 text:"雷曜日" が./source/other/kr/update/week.jsonにありません。元のファイルが更新されています

比較を行う
tag:0 ja:"日曜日", kr:"일요일", check:"일요일" 
tag:1 ja:"月曜日", kr:"월요일", check:"월요일" 
tag:2 ja:"火曜日", kr:"화요일", check:"화요일" 
tag:3 ja:"水曜日", kr:"수요일", check:"수요일" 
tag:4 ja:"木曜日", kr:"목요일", check:"목요일" 
tag:5 ja:"金曜日", kr:"금요일", check:"금요일" 
tag:6 ja:"土曜日", kr:"토요일", check:"토요일" 

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/week/false/week.jsonファイルの翻訳チェック
baseJson="./source/ja/week/false/week.json"
translateJson="./source/other/kr/week/false/week.json"
baseCheckFile="./source/ja/week/false/check.txt"
translateCheckFile="./source/other/kr/week/false/check.txt"

チェック対象のデータを取得する
データ数=7
CHECK_DATA_LIST["0"]="일요일"
CHECK_DATA_LIST["1"]="월요일"
CHECK_DATA_LIST["2"]="화요일"
CHECK_DATA_LIST["3"]="수요일"
CHECK_DATA_LIST["4"]="목요일"
CHECK_DATA_LIST["5"]="금요일"
CHECK_DATA_LIST["6"]="토요일"

元ファイルの更新を確認する

比較を行う
tag:0 ja:"日曜日", kr:"일요일", check:"일요일" 
tag:1 ja:"月曜日", kr:"月曜日", check:"월요일"  error01: 未翻訳 error02: チェック翻訳と違う
tag:2 ja:"火曜日", kr:"火曜日", check:"화요일"  error01: 未翻訳 error02: チェック翻訳と違う
tag:3 ja:"水曜日", kr:"", check:"수요일"  error02: チェック翻訳と違う error04: krの翻訳が無い
tag:4 ja:"木曜日", kr:"목", check:"목요일"  error02: チェック翻訳と違う
tag:5 ja:"金曜日", kr:"금요일", check:"금요일" 
tag:6 ja:"土曜日", kr:, check:"토요일"  error02: チェック翻訳と違う error06: krのtagが無い

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
./source/ja/week/true/week.jsonファイルの翻訳チェック
baseJson="./source/ja/week/true/week.json"
translateJson="./source/other/kr/week/true/week.json"
baseCheckFile="./source/ja/week/true/check.txt"
translateCheckFile="./source/other/kr/week/true/check.txt"

チェック対象のデータを取得する
データ数=7
CHECK_DATA_LIST["0"]="일요일"
CHECK_DATA_LIST["1"]="월요일"
CHECK_DATA_LIST["2"]="화요일"
CHECK_DATA_LIST["3"]="수요일"
CHECK_DATA_LIST["4"]="목요일"
CHECK_DATA_LIST["5"]="금요일"
CHECK_DATA_LIST["6"]="토요일"

元ファイルの更新を確認する

比較を行う
tag:0 ja:"日曜日", kr:"일요일", check:"일요일" 
tag:1 ja:"月曜日", kr:"월요일", check:"월요일" 
tag:2 ja:"火曜日", kr:"화요일", check:"화요일" 
tag:3 ja:"水曜日", kr:"수요일", check:"수요일" 
tag:4 ja:"木曜日", kr:"목요일", check:"목요일" 
tag:5 ja:"金曜日", kr:"금요일", check:"금요일" 
tag:6 ja:"土曜日", kr:"토요일", check:"토요일" 
```
