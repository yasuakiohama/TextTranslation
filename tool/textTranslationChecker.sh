#!/usr/local/bin/bash

#インストール
#brew install bash
#brew install jq

if [ $# -ne 1 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには1個の引数が必要です。" 1>&2
  echo "実行例"
  echo "/usr/local/bin/bash tool/textTranslationChecker.sh kr"
  echo "以下インストールしていなければ入れてください"
  echo "brew install bash"
  echo "brew install jq"
  exit 1
fi

#実行例
#

#区切り文字をここで変更している
OLDIFS=$IFS
IFS=$'\n'

#ディレクトリ
#.
#├── log
#│   └── ja_kr_error_log.txt
#├── source
#│   ├── ja
#│   │   ├── checkNotFound
#│   │   │   └── week.json
#│   │   ├── jsonNotFound
#│   │   │   └── week.json
#│   │   ├── specialCharacter
#│   │   │   ├── false
#│   │   │   │   └── text.json
#│   │   │   └── true
#│   │   │       └── text.json
#│   │   └── week
#│   │       ├── false
#│   │       │   └── week.json
#│   │       └── true
#│   │           └── week.json
#│   └── other
#│       └── kr
#│           ├── checkNotFound
#│           │   └── week.json
#│           ├── jsonNotFound
#│           ├── specialCharacter
#│           │   ├── false
#│           │   │   ├── check.txt
#│           │   │   └── text.json
#│           │   └── true
#│           │       ├── check.txt
#│           │       └── text.json
#│           └── week
#│               ├── false
#│               │   ├── check.txt
#│               │   └── week.json
#│               └── true
#│                   ├── check.txt
#│                   └── week.json
#└── tool
#    └── textTranslationChecker.sh

#引数代入
translate=${1}

#基本パラメータ作成
echo "基本パラメータ作成"
base="ja"
logFile="./log/${base}_${translate}_error_log.txt"
checkFileName="check.txt"
baseDirectory="./source/${base}"
translateDirectory="./source/other/${translate}"
echo "base="'"'"${base}"'"'
echo "translate="'"'"${translate}"'"'
echo "logFile="'"'"${logFile}"'"'
echo "checkFileName="'"'"${checkFileName}"'"'
echo "baseDirectory="'"'"${baseDirectory}"'"'
echo "translateDirectory="'"'"${translateDirectory}"'"'
echo

#変数作成
echo "変数作成"
declare -A checkDataList;# bashで連想配列を使えるようにする宣言
baseJsonList=(`find ${baseDirectory} -name "*.json"`)
baseCheckFile=""
translateJson="";
translateCheckFile=""
baseJson=""
echo "baseJsonList="
echo "${baseJsonList[*]}"
echo

#ディレクトリ作成
echo "ディレクトリ作成"
mkdir -p log
echo "mkdir -p log"

#削除
rm -rf ./log/*
echo "ログファイル削除"
echo "rm -rf ./log/*"
echo

init () {
  #初期化
  baseJson=${1}
  translateJson=`echo "${baseJson}" | sed "s%${baseDirectory}%${translateDirectory}%g"` #ディレクトリのパスのため区切り文字が被らないように%に変えて置換を行う
  echo "${baseJson}と${translateJson}の比較" >> "${logFile}"
  if [ ! -e "${translateJson}" ]; then
    echo "${translateJson} not found"
    echo "${translateJson} not found" >> "${logFile}"
    return 1
  fi
  baseCheckFile=`dirname ${baseJson}`"/${checkFileName}"
  if [ ! -e "${baseCheckFile}" ]; then
    echo "${baseCheckFile} not found"
    echo "${baseCheckFile} not found" >> "${logFile}"
    return 2
  fi
  translateCheckFile=`dirname ${translateJson}`"/${checkFileName}"
  if [ ! -e "${translateCheckFile}" ]; then
    echo "${translateCheckFile} not found"
    echo "${translateCheckFile} not found" >> "${logFile}"
    return 3
  fi
  checkDataList=()
  #表示
  #echo "checkDataList count:${#checkDataList[@]}"
  echo "baseJson="'"'"${baseJson}"'"'
  echo "translateJson="'"'"${translateJson}"'"'
  echo "baseCheckFile="'"'"${baseCheckFile}"'"'
  echo "translateCheckFile="'"'"${translateCheckFile}"'"'
  echo
  return 0
}

#チェック対象のデータを取得する
createCheckDataList () {
  echo "チェック対象のデータを取得する"
  local _tagList=(`cut -d ':' -f2 ${translateCheckFile} | cut -d ' ' -f1 | tr -d '\r'`)
  local _textList=(`cut -d ' ' -f3- ${translateCheckFile} | tr -d '\r'`)
  for tag in ${!_tagList[@]}
  do
    checkDataList[${_tagList[${tag}]}]=${_textList[${tag}]}
  done
#連想配列表示
  echo "データ数=${#checkDataList[@]}"
  for tag in ${!checkDataList[@]};
  do
    echo 'checkDataList["'${tag}'"]='"${checkDataList[$tag]}"
  done
  echo
}


containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

checkUpdate () {
  echo "元ファイルの更新を確認する"
  local _tagList=(`cut -d ':' -f2 ${baseCheckFile} | cut -d ' ' -f1 | tr -d '\r'`)
  local _textList=(`cut -d ' ' -f3- ${baseCheckFile} | tr -d '\r'`)
  for index in ${!_tagList[@]};
  do
    containsElement "${_tagList[$index]}" "${!checkDataList[@]}"
    if [ $? -ne 0 ]; then
      echo "tag:${_tagList[$index]} text:${_textList[$index]} が${translateJson}にありません。元のファイルが更新されています"
      echo "tag:${_tagList[$index]} text:${_textList[$index]} が${translateJson}にありません。元のファイルが更新されています" >> "${logFile}"
    fi
  done
  echo
}

#比較を行う
checkJson () {
  echo "比較を行う"
  for tag in ${!checkDataList[@]}
  do
    local _baseText=`jq 'recurse | select(.tag == '${tag}')? | .text' "${baseJson}"`
    local _translateText=`jq 'recurse | select(.tag == '${tag}')? | .text' "${translateJson}"`
    local _checkBeforeAndAfter=""
    if [ "${_baseText}" = "${_translateText}" ]; then
      _checkBeforeAndAfter+=" error01: 未翻訳"
    fi
    if [ "${checkDataList[${tag}]}" != "${_translateText}" ]; then
      _checkBeforeAndAfter+=" error02: チェック翻訳と違う"
    fi
    if [ "${_baseText}" = '""' ]; then
      _checkBeforeAndAfter+=" error03: ${base}の翻訳が無い"
    fi
    if [ "${_translateText}" = '""' ]; then
      _checkBeforeAndAfter+=" error04: ${translate}の翻訳が無い"
    fi
    if [ -z "$_baseText" ]; then
      _checkBeforeAndAfter+=" error05: ${base}のtagが無い"
    fi
    if [ -z "$_translateText" ]; then
      _checkBeforeAndAfter+=" error06: ${translate}のtagが無い"
    fi
    echo "tag:${tag} ${base}:${_baseText}, ${translate}:${_translateText}, check:${checkDataList[${tag}]} $_checkBeforeAndAfter"
    if [ -n "${_checkBeforeAndAfter}" ]; then
      echo "tag:${tag} ${base}:${_baseText}, ${translate}:${_translateText}, check:${checkDataList[${tag}]} $_checkBeforeAndAfter" >> "${logFile}"
    fi
  done
  echo
  echo "" >> "${logFile}"
}

# 実行
run () {
  for index in ${baseJsonList[@]};
  do
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "${index}ファイルの翻訳チェック"
    init ${index}
    if [ $? -ne 0 ]; then
      echo
      echo "" >> "${logFile}"
      continue
    fi
    createCheckDataList
    checkUpdate
    checkJson
  done
}

run
