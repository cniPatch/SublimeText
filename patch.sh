#!/bin/bash

if [[ ! -e /usr/bin/bspatch ]]; then
	echo "应用补丁需要 bspatch 程序, 请运行 brew install bsdiff 进行安装.";
	exit 2
fi

SHA="a3ff4cd33bf5b8d171a17f7061e5f59c95d1957756560cab870041d799b1cc97"
SUBLIME="/Applications/Sublime Text.app/Contents/MacOS/Sublime Text"
SUBLIME_TMP="/Applications/Sublime Text.app/Contents/MacOS/Sublime Text.tmp"
SUBLIME_PATCH="./SublimeText-3173.patch"

VERSION=3173

if [[ -e /usr/bin/bspatch ]]; then
	while :
	do
		clear
		echo "已安装 bspatch 程序, 准备应用补丁...";
		echo
		echo "本补丁仅适用于 SublimeText 3173 版本, 请确认您已将程序安装至应用程序目录?"
		echo "  1) 已经安装原版"
		echo "  2) 退出补丁"
		read -p "请选择 [1-2]: " option
		case $option in
			1)
			echo
			echo "开始目标文件程序版本是否正确..."
			echo
			FILESHA=$(shasum -a 256 "$SUBLIME" | cut -f 1 -d " ")
			if [[ "$FILESHA" == "$SHA" ]]; then
				echo
				echo "准备开始应用补丁..."
				echo

				if [[ ! -e "$SUBLIME_TMP" ]]; then
					bspatch "$SUBLIME" "$SUBLIME_TMP" "$SUBLIME_PATCH"
				fi
				if [[ -e "$SUBLIME_TMP" ]]; then
					rm "$SUBLIME"
					mv "$SUBLIME_TMP" "$SUBLIME"
					chmod a+x "$SUBLIME"
					rm "$SUBLIME_TMP"
				fi
				echo "搞定啦!"
			else
				echo "您的文件版本不正确, 或已被修改, 请通过官方网站下载  SublimeText 3173 版本."
				exit 3
			fi
			exit
			;;
			2) exit;;
		esac
	done
fi


