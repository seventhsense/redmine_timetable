[![Build Status](https://travis-ci.org/seventhsense/redmine_timetable.svg)](https://travis-ci.org/seventhsense/redmine_timetable)

# redmine_timetable
Timetable using fullcalendar

## Features
### カレンダー
- 開始時間と終了時間を保存することができるイベントというモデルを追加
- イベントはカレンダー上のドラッグアンドドロップで自由に移動できる
- チケットをカレンダーにドラッグアンドドロップで自分にアサインできる
- チケットは複数のイベントを持つが、一度にカレンダー上に予定できるイベントは一つだけ
- イベントを終了し、チケットが終了していなければ、次のイベントを登録できる
- イベントの終了時に作業時間を登録できる
- 終了したイベントをドラッグアンドドロップすることで作業時間を編集できる
- イベントを削除すると作業時間も削除できる
- 月のカレンダーをクリックすると日のカレンダーに移動
- 週のカレンダーと日のカレンダーからチケット作成
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

## Requirement
- Redmine 3.0.3

## Usage
### 1. ダウンロード
  
```
git clone https://github.com/seventhsense/redmine_timetable plugins/
```
### 2. Gemのインストール
```
bundle
```
### 3. データベースの作成

```
bundle exec rake redmine:plugins:migrate NAME=redmine_timetable`
```

### 4. timezoneの設定

タイムゾーンの設定を奨励します.
```
cp config/additional_enviroment.rb.example config/additional_enviroment.rb
echo "config.time_zone = 'Tokyo'" >> config/additional_environment.rb
```

データベースの設定はRedmineのデフォルトのlocalで構いません.(in config/application.rb)
```
config.active_record.default_timezone = :local
```
ただし、その場合、データベースのタイムゾーンをrailsのタイムゾーンと一致させてください.

## Uninstall
### 1. データベースの削除

```
bundle exec rake redmine:plugins:migrate NAME=redmine_timetable VERSION=0
```

### 2. プラグインの削除

```
rm -rf plugins/redmine_timetable
```

## 対応するデータベース
SQLite3, MySQL

## 開発/テスト
テストをする際は、`test/fixtures`にあるymlファイルをRedmineルートの`text/fixtures`にコピーないしシンボリックリンクを貼る.
