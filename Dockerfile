FROM node:8.11.2

# Debian set Locale
RUN apt-get update && \
    apt-get -y install locales task-japanese && \
    locale-gen ja_JP.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LC_ALL=ja_JP.UTF-8 \
    LC_CTYPE=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:jp
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

# Debian set TimeZone
ENV TZ=Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# yarn 追加
RUN npm install yarn -g && \
    chmod 755 /usr/local/bin/yarn

# Windows のローカルインストール用に --no-bin-links しているので、node_modules 配下に個別にパスを通す。
# 今いる場所の相対パスで解決する。
#
# # stencil コマンド
# export PATH=$PATH:./node_modules/\@stencil/core/bin
# # sd コマンド
# export PATH=$PATH:./node_modules/\@stencil/utils/bin
# # stencil-dev-server コマンド
# export PATH=$PATH:./node_modules/\@stencil/dev-server/bin
# # jest コマンド (これは jest.js なので解決できない。test 用なので利用不可のままにしておく)
# # export PATH=$PATH:./node_modules/\@stencil/jest/bin
ENV PATH=$PATH:./node_modules/\@stencil/core/bin:./node_modules/\@stencil/utils/bin:./node_modules/\@stencil/dev-server/bin

# Dockerコンテナの指定したポートを開き他から参照できるようにします。
#  3333: Ionic の stencil-dev-server の httpPort (デフォルト)
# 35729: Ionic の stencil-dev-server の liveReloadPort (デフォルト)
EXPOSE 3333 35729
