# z80oolong/git に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/git に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

## Formula 一覧

### z80oolong/git/git

VFAT ファイルシステム及び [Android OS][ANDR] 及び [Debian noroot 環境][DBNR]における外部ストレージ領域において、 ```git clone``` コマンド等を用いて新しい git リポジトリを作成する場合に、 ```.git/config``` ファイルの lock ファイルについて lock ファイルの権限の変更に失敗するために、 ```.git/config``` の lock に失敗し、リポジトリが作成できない問題を修正した [git][GIT_] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

即ち、この Formula は、 [git][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

### z80oolong/git/git@2.17

この Formula は、旧安定版である [git 2.17.2][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.17``` コマンドを実行する必要があります。

### z80oolong/git/git@2.18

この Formula は、旧安定版である [git 2.18.1][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.18``` コマンドを実行する必要があります。

### z80oolong/git/git@2.19

この Formula は、旧安定版である [git 2.19.2][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.19``` コマンドを実行する必要があります。

### z80oolong/git/git@2.20

この Formula は、旧安定版である [git 2.20.1][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.20``` コマンドを実行する必要があります。

### z80oolong/git/git@2.21

この Formula は、旧安定版である [git 2.21.0][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.21``` コマンドを実行する必要があります。

### z80oolong/git/git@2.22

この Formula は、旧安定版である [git 2.22.1][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.22``` コマンドを実行する必要があります。

### z80oolong/git/git@2.23

この Formula は、安定版である [git 2.21.0][GIT_] に、 "[git 2.17.0 以降において config ファイルの lock に失敗する場合の挙動を変更する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [git][GIT_] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [git][GIT_] を使用するには、 ```brew link --force z80oolong/git/git@2.23``` コマンドを実行する必要があります。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[DBNR]:https://play.google.com/store/apps/details?id=com.cuntubuntu&hl=ja
[ANDR]:https://www.android.com/intl/ja_jp/
[GIT_]:https://git-scm.com/
[GST1]:https://gist.github.com/z80oolong/d33892b66257242b347211c944de78c8
