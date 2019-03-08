# 作成するコンテナの基となるイメージを指定
FROM centos:centos6.10

# ARG Dockerfile内で使用できる変数
# docker buildの際にのみ利用を想定される値に使用
ARG PORT=5000

# ENV コンテナ内(build後)でも環境変数として利用したい場合に利用
ENV ENV_PORT ${PORT}

# 作成者
MAINTAINER nagisa0129

# yumアップデート
RUN yum update -y

# epel, remi インストール
RUN yum install -y epel-release
# remi CentOS6系
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# CentOS timezoneの設定
RUN \cp -f /usr/share/zoneinfo/Japan /etc/localtime
RUN sed -ri "s/Etc\/UTC/Asia\/Tokyo/" /etc/sysconfig/clock

# PHP5.6 インストール
# PHPモジュールを追加する時はここに追記する
# 追記せずに直接コンテナに入りインストールしても再buildした時に消えてしまうので注意
RUN yum install -y --enablerepo=remi,remi-php56 php php-devel php-mysql php-mbstring php-pdo php-pecl-apc

# php.iniの設定書き換え
RUN sed -ri 's/;date.timezone =/date.timezone = Asia\/Tokyo/g' /etc/php.ini
RUN sed -ri 's/display_errors = Off/display_errors = On/g' /etc/php.ini
RUN sed -ri 's/;error_log = php_errors.log/error_log = \/var\/log\/php_errors.log/g' /etc/php.ini

# その他よく使うパッケージをインストール(必要に応じて追記)
# インストールされたパッケージ一覧は yum list installed で確認可能
RUN yum install -y httpd git vim nodejs gcc-c++ make
RUN yum install -y install cronie-noanacron && yum remove cronie-anacron

# composerインストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Apacheの設定
RUN sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/    AllowOverride None/    AllowOverride All/' /etc/httpd/conf/httpd.conf && \
    sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/    Options Indexes FollowSymLinks/    Options Indexes FollowSymLinks Includes/' /etc/httpd/conf/httpd.conf && \
    sed -ri 's/DirectoryIndex index.html index.html.var/DirectoryIndex index.html index.shtml index.html.var/' /etc/httpd/conf/httpd.conf && \
    sed -ie '/^<Directory \/>$/a \    SetEnv APP_ENV "development"' /etc/httpd/conf/httpd.conf

# ENTRYPOINT コマンド
# docker runの際に実行される
ENTRYPOINT /bin/bash

# RUN, CMD, ENTRYPOINT, COPY, ADDを実行する時のワーキングディレクトリを指定
WORKDIR /var/www/html

# 指定したポートの開放
EXPOSE ${ENV_PORT}
