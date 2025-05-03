# ステージ1: ビルドステージ
FROM node:18 AS build

# 作業ディレクトリの作成
WORKDIR /app

# package.jsonとpackage-lock.jsonをコピーして依存関係をインストール
COPY package*.json ./
RUN npm install

# アプリケーションのソースをコピーしてビルド
COPY . .
RUN npm run build

# ステージ2: 実行ステージ（軽量なイメージを使用）
FROM node:18-slim

WORKDIR /app

# 必要なファイルだけをコピー
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./

# 本番用依存関係だけインストール
RUN npm install --only=production

# アプリケーションの起動
CMD ["node", "dist/index.js"]
