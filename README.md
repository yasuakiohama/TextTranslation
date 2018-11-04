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
基本パラメータ作成
base="ja"
translate="kr"
logFile="./log/ja_kr_error_log.txt"
checkFileName="check.txt"
baseDirectory="./source/ja"
translateDirectory="./source/other/kr"

変数作成
baseJsonList=
./source/ja/checkNotFound/a/week.json
./source/ja/checkNotFound/b/week.json
./source/ja/jsonNotFound/week.json
./source/ja/specialCharacter/false/text.json
./source/ja/specialCharacter/true/text.json
./source/ja/update/week.json
./source/ja/week/false/week.json
./source/ja/week/true/week.json

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
checkDataList["0"]="~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____"
checkDataList["1"]="\"\n\\n\t\r\\t\\rfdfdffff____"

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
checkDataList["0"]="~!@#$%^&*()_+{}|:<>?'fdfd`fdfd____"
checkDataList["1"]="\"\n\\n\t\r\\t\\rfdfdffff____"

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
checkDataList["0"]="일요일"
checkDataList["1"]="월요일"
checkDataList["2"]="화요일"
checkDataList["3"]="수요일"
checkDataList["4"]="목요일"
checkDataList["5"]="금요일"
checkDataList["6"]="토요일"

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
checkDataList["0"]="일요일"
checkDataList["1"]="월요일"
checkDataList["2"]="화요일"
checkDataList["3"]="수요일"
checkDataList["4"]="목요일"
checkDataList["5"]="금요일"
checkDataList["6"]="토요일"

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
checkDataList["0"]="일요일"
checkDataList["1"]="월요일"
checkDataList["2"]="화요일"
checkDataList["3"]="수요일"
checkDataList["4"]="목요일"
checkDataList["5"]="금요일"
checkDataList["6"]="토요일"

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

# 参考URL  
jq  
https://jqplay.org/jq  
https://stedolan.github.io/jq/  

json  
https://www.json-generator.com/    

bash  
https://qiita.com/b4b4r07/items/e56a8e3471fb45df2f59 
http://labs.opentone.co.jp/?p=5890  
https://qiita.com/kaw/items/034bc4221c4526fe8866　　　

sed　　　

https://qiita.com/takech9203/items/b96eff5773ce9d9cc9b3  
https://qiita.com/hirohiro77/items/7fe2f68781c41777e507  

cut  
http://www.rep1.co.jp/staff/200vcxg/217rav/cut_lcd_-linux_command_diction.htm  

tr  
https://tech.nikkeibp.co.jp/it/article/COLUMN/20060421/235900/  

そのた
https://ja.stackoverflow.com/questions/44344/%E3%82%B7%E3%82%A7%E3%83%AB%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%81%A7%E7%89%B9%E5%AE%9A%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97%E3%81%8B%E3%82%89%E7%89%B9%E5%AE%9A%E3%81%AE%E6%96%87%E5%AD%97%E3%81%BE%E3%81%A7%E3%82%92%E6%8A%BD%E5%87%BA%E3%81%97%E3%81%9F%E3%81%84  

# メモ  
jqの?
```
.[]?
Like .[], but no errors will be output if . is not an array or object.
```

containsElement   
https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value   
