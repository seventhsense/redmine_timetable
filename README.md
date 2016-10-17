[![GitHub version](https://badge.fury.io/gh/seventhsense%2Fredmine_timetable.svg)](http://badge.fury.io/gh/seventhsense%2Fredmine_timetable)
[![Build Status](https://travis-ci.org/seventhsense/redmine_timetable.svg)](https://travis-ci.org/seventhsense/redmine_timetable)
[![Dependency Status](https://gemnasium.com/seventhsense/redmine_timetable.svg)](https://gemnasium.com/seventhsense/redmine_timetable)
[![Coverage Status](https://coveralls.io/repos/seventhsense/redmine_timetable/badge.svg?branch=master)](https://coveralls.io/r/seventhsense/redmine_timetable?branch=master)

# redmine_timetable
自分の時間表に、ドラッグ・アンド・ドロップでチケットの予定を登録できます.
![イベントの作成](https://raw.github.com/wiki/seventhsense/redmine_timetable/images/redmine_timetable_1_create_event.gif)
やることを全部書き出して、時間表に登録しておけば、安心して今のタスクに集中できます.


## 機能
### カレンダー
- 開始時間と終了時間を保存することができるイベントというモデルを追加
- イベントはカレンダー上のドラッグアンドドロップで自由に移動できる
- チケットをカレンダーにドラッグアンドドロップで自分にアサインできる
- チケットは複数のイベントを持つが、一度にカレンダー上に予定できるイベントは一つだけ
- イベントを終了し、チケットが終了していなければ、次のイベントを登録できる
- イベントの終了時に作業時間を登録できる
- 終了したイベントをドラッグアンドドロップすることで作業時間を編集できる
- イベントを削除すると作業時間も削除できる
- 週のカレンダーと月のカレンダーをクリックすると日のカレンダーに移動
- 日のカレンダーからチケット作成
- チケットの期限に応じたイベントの色
- 期限の設定やイベントの移動に応じて自動的に色が変わる
- Railsのconfig.time_zoneとユーザーごとのタイムゾーン設定に対応
- 日本の祝日表示

### 統計情報
- 担当プロジェクト数
- 担当チケット数
- 新規担当チケット数
- 終了チケット数
- チケットの収支
- 日ごとの終了したイベント数・作業時間の平均
- 残イベント数・時間数
- 残イベントの消化に要する日数
- 月ごとの作業時間・終了したイベント数
- 日ごとの作業時間・終了したイベント数
- 日報
- 日報のcsvダウンロード
- グラフ表示
  - 月次の新規チケット数と終了チケット数
  - プロジェクトごとの作業時間の割合
  - 月次の終了イベント数とイベント作業時間
  - 日時の終了イベント数とイベント作業時間

## 環境
- Redmine 3.0.3

## インストール
### 1. ダウンロード
 Redmineのpluginsにダウンロードします。 
```
git clone https://github.com/seventhsense/redmine_timetable plugins/
```
### 2. Gemのインストール
```
bundle --without development,test
```
### 3. データベースの作成

```
RAILS_ENV=production bundle exec rake redmine:plugins:migrate NAME=redmine_timetable
```

### 4. timezoneの設定

Redmineのタイムゾーンも設定します.
```
cp config/additional_enviroment.rb.example config/additional_enviroment.rb
echo "config.time_zone = 'Tokyo'" >> config/additional_environment.rb
```

データベースの設定はRedmineのデフォルトのlocalで構いません.(in config/application.rb)
```
config.active_record.default_timezone = :local
```
ただし、その場合、データベースのタイムゾーンをrailsのタイムゾーンと一致させてください.

MySQLでは、タイムゾーンの設定を奨励します.

## 使い方
[Wiki](https://github.com/seventhsense/redmine_timetable/wiki)を参照してください.

## アンインストール
### 1. データベースの削除

```
bundle exec rake redmine:plugins:migrate NAME=redmine_timetable VERSION=0
```

### 2. プラグインの削除

```
cd plugins
rm -rf redmine_timetable
```

## 対応するデータベース
SQLite3, MySQL
