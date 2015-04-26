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

## Requirement
- Redmine 3.0.1

## Usage
### 1. ダウンロード
  
```
git clone https://github.com/seventhsense/redmine_timetable plugins/
```

### 2. データベースの作成

```
bundle exec rake redmine:plugins:migrate NAME=redmine_timetable`
```

### 3. timezoneの設定

タイムゾーンの設定を奨励します.
```
cp config/additional_enviroment.rb.example config/additional_enviroment.rb
echo "config.time_zone = 'Tokyo'" >> config/additional_environment.rb
```

## Uninstall
### 1. データベースの削除

```
bundle exec rake redmine:plugins:migrate NAME=redmine_timetable` VERSION=0
```

### 2. プラグインの削除

```
rm -rf plugins/redmine_timetable
```
