# eg_dock
これだけで開発環境ができちゃう便利なモノ

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
$ docker-compose build
$ docker-compose up -d
```
