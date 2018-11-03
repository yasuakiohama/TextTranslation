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

#グローバル変数
echo "グローバル変数"
CHECK_FILE_NAME="check.txt"
declare -A CHECK_DATA_LIST;# bashで連想配列を使えるようにする宣言

#引数代入
translate=${1}

#変数作成
echo "変数作成"
base="ja"
baseDirectory="./source/${base}"
translateDirectory="./source/other/${translate}"
baseJsonList=(`find ${baseDirectory} -name "*.json"`)
translateJson="";
logFile="./log/${base}_${translate}_error_log.txt"
baseJson=""
echo "base="'"'"${base}"'"'
echo "translate="'"'"${translate}"'"'
echo "baseDirectory="'"'"${baseDirectory}"'"'
echo "baseJsonList="
echo "${baseJsonList[*]}"
echo "CHECK_FILE_NAME="'"'"${CHECK_FILE_NAME}"'"'
echo "logFile="'"'"${logFile}"'"'
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
  translateJson=`echo "${baseJson}" | sed "s%${baseDirectory}%${translateDirectory}%g"`
  echo "${baseJson}と${translateJson}の比較" >> "${logFile}"
  if [ ! -e "${translateJson}" ]; then
    echo "${translateJson} not found"
    echo "${translateJson} not found" >> "${logFile}"
    return 1
  fi
  checkFile=`dirname ${translateJson}`"/${CHECK_FILE_NAME}"
  if [ ! -e "${checkFile}" ]; then
    echo "${checkFile} not found"
    echo "${checkFile} not found" >> "${logFile}"
    return 2
  fi
  CHECK_DATA_LIST=()
  #表示
  #echo "CHECK_DATA_LIST count:${#CHECK_DATA_LIST[@]}"
  echo "baseJson="'"'"${baseJson}"'"'
  echo "translateJson="'"'"${translateJson}"'"'
  echo "checkFile="'"'"${checkFile}"'"'
  echo
  return 0
}

#チェック対象のデータを取得する
createCheckDataList () {
  echo "チェック対象のデータを取得する"
  local _tagList=(`cut -d ':' -f2 ${checkFile} | cut -d ' ' -f1`)
  local _nameList=(`cut -d ' ' -f3- ${checkFile}`)
  for tag in ${!_tagList[@]}
  do
    CHECK_DATA_LIST[${_tagList[${tag}]}]=${_nameList[${tag}]}
  done
#連想配列表示
  echo "データ数=${#CHECK_DATA_LIST[@]}"
  for tag in ${!CHECK_DATA_LIST[@]};
  do
    echo 'CHECK_DATA_LIST["'${tag}'"]='"${CHECK_DATA_LIST[$tag]}"
  done
  echo
}

#比較を行う
checkJson () {
  echo "比較を行う"
  for tag in ${!CHECK_DATA_LIST[@]}
  do
    local _baseText=`jq '.[] | select(.tag == '${tag}') | .text' "${baseJson}"`
    local _translateText=`jq '.[] | select(.tag == '${tag}') | .text' "${translateJson}"`
    local _checkBeforeAndAfter=""
    if [ "${_baseText}" = "${_translateText}" ]; then
      _checkBeforeAndAfter+=" error01: 未翻訳"
    fi
    if [ "${CHECK_DATA_LIST[${tag}]}" != "${_translateText}" ]; then
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
    echo "tag:${tag} ${base}:${_baseText}, ${translate}:${_translateText}, check:${CHECK_DATA_LIST[${tag}]} $_checkBeforeAndAfter"
    if [ -n "${_checkBeforeAndAfter}" ]; then
      echo "tag:${tag} ${base}:${_baseText}, ${translate}:${_translateText}, check:${CHECK_DATA_LIST[${tag}]} $_checkBeforeAndAfter" >> "${logFile}"
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
    checkJson
  done
}

run
