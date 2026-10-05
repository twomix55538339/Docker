# docker run

docker run -it --gpus all my-mmcv-docker:latest

# docker build

docker build -f Dockerfile_Org -t mmvc-wheel:test .

# Log出力


ログを出力したい。Windowsです。

1. PowerShellの場合（推奨）
   画面にログを表示しながら、同時にファイルへも保存したい場合は Tee-Object が便利です。

画面表示とファイル保存を両立する（標準エラーも含めて保存）:

```docker
docker build -f Dockerfile.dev -t myapp:dev . 2>&1 | Tee-Object -FilePath build.log'''
```

画面には出さず、ファイル出力のみ行う場合:

```docker
docker build -f Dockerfile.dev -t myapp:dev . > build.log 2>&1
```

2. コマンドプロンプト（cmd.exe）の場合
   標準出力とエラー出力（2番）をまとめてリダイレクトします

```docker
docker build -f Dockerfile.dev -t myapp:dev . > build.log 2>&1
```

詳細な進行ログを残したい場合（BuildKit）
最近の Docker では標準で BuildKit が有効になっており、一部のログが折りたたまれることがあります。
すべてのステップの出力を省略せずログに残したい場合は、--progress=plain を追加してください。

```docker
docker build --progress=plain -f Dockerfile.dev -t myapp:dev . 2>&1 | Tee-Object -FilePath build.log
```

