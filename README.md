# eg_dock
これだけで開発環境ができちゃうスグレモノ

## 開発環境
- **Docker for Mac**
- CentOS 6.9
- PHP 5.6
- MySQL 5.6
- apache 2.2.15

## 構築方法
#### Dockerインストール
https://docs.docker.com/docker-for-mac/

#### Docker Composeインストール
http://docs.docker.jp/compose/install.html

#### クローン && コンテナ作成
```
$ git clone https://github.com/nagisa-ito/eg-dock.git
$ cd eg-dock
```
.envファイルを自分の環境に合わせて書き直す
```
$ docker-compose build
$ docker-compose up -d
```
