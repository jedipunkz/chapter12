chapter12
=========

OpenStack 書籍 第12章用レポジトリ

格納しているファイル達
----

* Ruby RPM

rpm ディレクトリに格納されているのはOpenStack書籍で扱う 'centos-base' イメージ用の ruby 2.1.3 (執筆時点最新ステーブル版)の RPM パッケージです。

* Fog サンプルコード

fog ディレクトリに格納されているのは書籍で扱う Fog 用サンプルコードです。

* Fog パッチ

patch-fog ディレクトリに格納されているのは Fog に対するパッチです。サブネット作成の際にゲートウェイ無しを選択出来ない不具合を修正するためのパッチになります。

その他のレポジトリ
----

本レポジトリとは別に第12章では Chef 用のレポジトリを用います。Berkshelf で取得するため別のレポジトリとして保管してあります。

* cookbook-opensatck-sample

    https://github.com/josug-book1-materials/cookbook-openstack-sample

* nginx

    https://github.com/josug-book1-materials/nginx
