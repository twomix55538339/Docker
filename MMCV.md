# MMCV

## 組み合わせ試し

```
# RUN mim install "mmcv==2.1.0"
# RUN mim install "mmdet==3.2.0"
# RUN mim install "mmpose==1.3.1"
# 上記の組み合わせはNG。所詮、mmcvはPyTorchと合わないので、mmcv2.1.0のソースをダウンロードして自前ビルドが走る
# ですが、Cudaのnvccがインストールされていないので、コンテナが無事に起動されても、nmsと合わないエラーが発生

# RUN mim install "mmcv==2.2.0"
# RUN mim install "mmdet>=3.3.0"
# RUN mim install "mmpose>=1.3.2"
# 上記のコマンドもNG。下記の原因で、mmcv==2.2.0のWheelを先にダウンロード済みになっても、mmdet 3.2.0を行った後、すぐにのmmcv3.1.0のソースをダウンロードして自前ビルドが走る
# mmpose 1.3.1 requires mmcv<2.2.0,>=2.0.0, but you have mmcv 2.2.0 which is incompatible.
# mmdet 3.2.0 requires mmcv<2.2.0,>=2.0.0rc4, but you have mmcv 2.2.0 which is incompatible.

# RUN pip install "https://download.openmmlab.com/mmcv/dist/cu121/torch2.3.0/mmcv-2.2.0-cp310-cp310-manylinux1_x86_64.whl"
# RUN mim install "mmdet==3.2.0"
# RUN mim install "mmpose==1.3.1"
# 上記のコマンドもNG。同じの原因で、mmcv==2.2.0のWheelを先にダウンロード済みになっても、mmdet 3.2.0を行った後、すぐにのmmcv3.1.0のソースをダウンロードして自前ビルドが走る

RUN mim install "mmcv==2.2.0"
RUN mim install "mmdet==3.2.0" --no-deps
RUN mim install "mmpose==1.3.1" --no-deps
RUN sed -i 's/mmcv_maximum_version = .2.2.0./mmcv_maximum_version = "2.3.0"/' /usr/local/lib/python3.10/dist-packages/mmdet/__init__.py && \
    sed -i 's/mmcv_maximum_version = .2.2.0./mmcv_maximum_version = "2.3.0"/' /usr/local/lib/python3.10/dist-packages/mmpose/__init__.py
# 上記の組み合わせはOK。mmcvの自前ビルドが走ることがない
```

## バージョン確認

1. Python から直接確認する（最も確実）

```
python3 -c "import mmcv; print(mmcv.__version__)"
```

2. pip 経由で確認する
   パッケージのバージョンとインストール先情報を確認できます。

```
pip show mmcv
```

3. OpenMMLab 関連の環境情報をまとめて確認する（推奨）
   PyTorch、CUDA、MMCV の組み合わせが正常か診断したい場合に便利です。

```
python3 -c "import mmcv; from mmcv.utils import collect_env; print(collect_env())"
```

結果の例：

```
OrderedDict([('sys.platform', 'linux'), 
('Python', '3.10.12 (main, Aug 31 2026, 10:18:17) 
[GCC 11.4.0]'), ('CUDA available', True), 
('MUSA available', False), ('numpy_random_seed', 2147483648), 
('GPU 0', 'NVIDIA GeForce RTX 2070'), ('CUDA_HOME', '/usr/local/cuda'),
 ('NVCC', 'Cuda compilation tools, release 12.1, V12.1.105'), 
('GCC', 'x86_64-linux-gnu-gcc (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0'), 
('PyTorch', '2.3.1+cu121'), 
('PyTorch compiling details', 
'PyTorch built with:\n  
- GCC 9.3\n  
- C++ Version: 201703\n  
- Intel(R) oneAPI Math Kernel Library Version 2022.2-Product 
Build 20220804 for Intel(R) 64 architecture applications\n  
- Intel(R) MKL-DNN v3.3.6 (Git Hash 86e6af5974177e513fd3fee58425e1063e7f1361)\n  
- OpenMP 201511 (a.k.a. OpenMP 4.5)\n  
- LAPACK is enabled (usually provided by MKL)\n  
- NNPACK is enabled\n  - CPU capability usage: AVX2\n  
- CUDA Runtime 12.1\n  - NVCC architecture flags: 
-gencode;arch=compute_50,code=sm_50;
-gencode;arch=compute_60,code=sm_60;
-gencode;arch=compute_70,code=sm_70;
-gencode;arch=compute_75,code=sm_75;
-gencode;arch=compute_80,code=sm_80;
-gencode;arch=compute_86,code=sm_86;
-gencode;arch=compute_90,code=sm_90\n  
- CuDNN 8.9.2\n  
- Magma 2.6.1\n  
- Build settings: BLAS_INFO=mkl, BUILD_TYPE=Release, 
CUDA_VERSION=12.1, CUDNN_VERSION=8.9.2, 
CXX_COMPILER=/opt/rh/devtoolset-9/root/usr/bin/c++, 
CXX_FLAGS= -D_GLIBCXX_USE_CXX11_ABI=0 -fabi-version=11 
-fvisibility-inlines-hidden -DUSE_PTHREADPOOL -DNDEBUG 
-DUSE_KINETO -DLIBKINETO_NOROCTRACER -DUSE_FBGEMM -DUSE_QNNPACK 
-DUSE_PYTORCH_QNNPACK -DUSE_XNNPACK -DSYMBOLICATE_MOBILE_DEBUG_HANDLE 
-O2 -fPIC -Wall -Wextra -Werror=return-type -Werror=non-virtual-dtor 
-Werror=bool-operation -Wnarrowing -Wno-missing-field-initializers 
-Wno-type-limits -Wno-array-bounds -Wno-unknown-pragmas 
-Wno-unused-parameter -Wno-unused-function -Wno-unused-result 
-Wno-strict-overflow 
-Wno-strict-aliasing -Wno-stringop-overflow -Wsuggest-override 
-Wno-psabi -Wno-error=pedantic -Wno-error=old-style-cast 
-Wno-missing-braces -fdiagnostics-color=always -faligned-new 
-Wno-unused-but-set-variable -Wno-maybe-uninitialized 
-fno-math-errno 
-fno-trapping-math -Werror=format -Wno-stringop-overflow, 
LAPACK_INFO=mkl, PERF_WITH_AVX=1, PERF_WITH_AVX2=1, PERF_WITH_AVX512=1, 
TORCH_VERSION=2.3.1, USE_CUDA=ON, USE_CUDNN=ON, USE_CUSPARSELT=1, 
USE_EXCEPTION_PTR=1, USE_GFLAGS=OFF, USE_GLOG=OFF, USE_GLOO=ON, 
USE_MKL=ON, USE_MKLDNN=ON, USE_MPI=OFF, USE_NCCL=1, USE_NNPACK=ON, 
USE_OPENMP=ON, USE_ROCM=OFF, USE_ROCM_KERNEL_ASSERT=OFF, \n'), 
('TorchVision', '0.18.1+cu121'), 
('OpenCV', '4.10.0'), ('MMEngine', '0.10.4'), ('MMCV', '2.1.0'), 
('MMCV Compiler', 'GCC 11.4'), ('MMCV CUDA Compiler', '12.1')])
```

# mmcvはwheelか？

コンテナ内で配布済み wheel（公式の事前ビルド済みバイナリ）から導入されたか、それともローカルでソースからビルド（自前ビルド）されたかを判別するには、パッケージのメタデータ（direct_url.json / WHEEL） または 内部のビルド環境情報 を確認します。

### 方法1: メタデータ（direct_url.json）の有無を確認する【最も簡単・確実】
ソースコード（Gitリポジトリやローカルディレクトリ）から pip install . や pip install -e .、python setup.py install 等で自前ビルドした場合、インストール先ディレクトリに direct_url.json という追跡ファイルが生成されます。公式の .whl を直接または -f 経由で入れた場合は通常存在しません。

Docker Desktop の Exec 画面で以下を実行します：

```
python3 -c "
import importlib.metadata as md
try:
    url = md.distribution('mmcv').read_text('direct_url.json')
    print('【自前ビルド / ソースインストール】\n', url)
except Exception:
    print('【公式事前ビルド wheel の可能性が高いです】')
"
```

* **判定:**
  * `direct_url.json` の内容（`file:///...` や git URL など）が表示されたら **自前ビルド（ソースインストール）** です。
  * `【公式事前ビルド wheel の可能性が高いです】` と出た場合は、公式等の wheel ファイルから展開されています。

### 方法2: `WHEEL` メタデータのタグを確認する

事前にビルドされた公式 wheel は、ファイル名と同様に `manylinux` タグが埋め込まれています。一方、ローカルでソースビルドして wheel 化された場合は `linux_x86_64` タグになります。

以下のコマンドを実行します：

```
python3 -c "import importlib.metadata as md; print(md.distribution('mmcv').read_text('WHEEL'))"
```

結果の例１：

```
Wheel-Version: 1.0
Generator: bdist_wheel (0.37.1)
Root-Is-Purelib: false
Tag: cp310-cp310-linux_x86_64
```

結果の例２：

```
Wheel-Version: 1.0
Generator: bdist_wheel (0.41.2)
Root-Is-Purelib: false
Tag: cp310-cp310-manylinux1_x86_64
```

### 方法3: MMCV が記録しているビルド時環境情報を確認する

MMCV はビルドされた環境のコンパイラや PyTorch/CUDA バージョンを内部に記録しています。

```
python3 -c "import mmcv; print(mmcv._ext.__file__ if hasattr(mmcv, '_ext') else 'No CUDA ops'); from mmengine.utils import collect_env; print(collect_env())"
```

または Python インタプリタで以下を実行します：

```
python3 -c "
import mmcv
import torch

print('Torch version (current):', torch.__version__)
print('Torch CUDA version     :', torch.version.cuda)
try:
    from mmcv.ops import get_compiler_version, get_compiling_cuda_version
    print('MMCV built with CUDA   :', get_compiling_cuda_version())
    print('MMCV compiler          :', get_compiler_version())
except ImportError:
    pass
"
```

結果の例：

```
Torch version (current): 2.3.1+cu121
Torch CUDA version     : 12.1
MMCV built with CUDA   : not available
MMCV compiler          : GCC 11.4
```

**判定:**

* コンパイラバージョン（GCC など）がコンテナ自身の `gcc --version` と完全に一致し、カスタムパスが埋め込まれている場合はローカルビルドの痕跡です。
* OpenMMLab 公式の事前ビルド wheel は GitHub Actions などの標準コンパイル環境（特定の古い GCC バージョンなど）でビルドされています。

## mimはどこからmmcvをダウンロードする？

mim install "mmcv==2.2.0" を実行した際、mim（OpenMMLab Install Manager）は内部で以下の流れ・参照先から wheel を探してダウンロードします。

### 方法 1: どこからダウンロードするのか？
   mim は、環境内の PyTorch バージョン と CUDA バージョン を自動検出し、OpenMMLab の公式配信サーバー（AWS S3 ベースの CDN）にある 専用インデックス URL を自動構築して参照します。

ベース URL:

```
https://download.openmmlab.com/mmcv/dist/{cuda_version}/{torch_version}/index.html
```

例えば、コンテナ内が **PyTorch 2.3.1 + CUDA 12.1** の場合、`mim` は内部的に以下の URL を `-f`（find-links）オプションとして `pip` に渡します：

```
https://download.openmmlab.com/mmcv/dist/cu121/torch2.3/index.html
```

実質的には、以下のコマンドを自動生成して実行しているのと同じ動作です：

```
pip install mmcv==2.2.0 -f https://download.openmmlab.com/mmcv/dist/cu121/torch2.3/index.html
```

### 方法 2: もし見つからなかった場合のフォールバック（注意点）

もし上記 URL に一致する事前ビルド済み wheel が存在しない場合（例: マイナーバージョンの不一致や未対応の組み合わせ）、`mim` は通常の **PyPI（pypi.org）** から mmcv のソースコード（`.tar.gz`）を取得しようとします。

* その場合、コンテナ内で C++/CUDA のコンパイル（自前ビルド）が始まります。
* 必要なコンパイラ（`g++` や `nvcc`）がコンテナに揃っていないと、ビルドエラーで停止します。

### 方法 3: `mim` が参照している URL を確認するコマンド

コンテナ内で `mim` がどの URL を解決しているかは、`--verbose` オプションを付けて実行することでログから直接確認できます。

```
mim install "mmcv==2.2.0" --verbose
```

※ ログの冒頭に `Looking in links: [https://download.openmmlab.com/mmcv/dist/](https://download.openmmlab.com/mmcv/dist/)...` と表示され、アクセス先の URL が出力されます。

## CUDA Ops テストコマンド

```
python3 -c "import torch; from mmcv.ops import nms; print('CUDA Available:', torch.cuda.is_available()); boxes = torch.tensor([[0., 0., 10., 10.], [0., 0., 9., 9.]], device='cuda'); scores = torch.tensor([0.9, 0.8], device='cuda'); keep_boxes, keep_idx = nms(boxes, scores, 0.5); print('MMCV CUDA Ops Success! Selected indices:', keep_idx)"
```

結果の例：

```
CUDA Available: True
MMCV CUDA Ops Success! Selected indices: tensor([0], device='cuda:0')
```

## MMDet や MMPose のインポートが通るかも確認

```
python3 -c "import mmdet; import mmpose; print('MMDet:', mmdet.__version__); print('MMPose:', mmpose.__version__)"
```

結果の例：

```
MMDet: 3.2.0
MMPose: 1.3.1
```

## 長いコードを、コンテナのExec画面で実行したい

Docker Desktop の Exec 画面（シェル環境）で長い Python コードを実行する場合、エディタ（`nano` や `vim`）が入っていなくても確実に実行できる方法は主に以下の3通りです。

### 方法 1: `cat << 'EOF'` でファイルを作成して実行（最もおすすめ）

ターミナルにブロックごと貼り付けるだけで、改行崩れを起こさずにファイルを作成できます。

以下のブロックを丸ごとコピーして、Exec 画面に貼り付けて Enter を押します。

```
cat << 'EOF' > test_mmcv.py
import torch

print("=== Environment Check ===")
print(f"PyTorch Version : {torch.__version__}")
print(f"CUDA Available  : {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"Device Name     : {torch.cuda.get_device_name(0)}")
else:
    raise SystemError("CUDA is not available in PyTorch.")

print("\n=== Testing MMCV CUDA Ops ===")
try:
    from mmcv.ops import nms

    boxes = torch.tensor([[0.0, 0.0, 10.0, 10.0],
                          [0.0, 0.0, 9.0, 9.0]], device="cuda")
    scores = torch.tensor([0.9, 0.8], device="cuda")
    iou_threshold = 0.5

    dets, keep_inds = nms(boxes, scores, iou_threshold)

    print("Success: MMCV CUDA ops executed without errors.")
    print(f"Kept indices: {keep_inds.tolist()}")
except Exception as e:
    print("Failed: MMCV CUDA ops error.")
    print(e)
EOF

python3 test_mmcv.py
```

結果の例：

```
=== Environment Check ===
PyTorch Version : 2.3.1+cu121
CUDA Available  : True
Device Name     : NVIDIA GeForce RTX 2070

=== Testing MMCV CUDA Ops ===
Success: MMCV CUDA ops executed without errors.
Kept indices: [0]
```

### 方法 2: ファイルを作らず直接 Python に流し込む（ワンタイム実行）

一時ファイルも残さず実行したい場合は、`python3 << 'EOF'` で標準入力として直接渡します。

```
python3 << 'EOF'
import torch
from mmcv.ops import nms

print("CUDA Available:", torch.cuda.is_available())
boxes = torch.tensor([[0.0, 0.0, 10.0, 10.0], [0.0, 0.0, 9.0, 9.0]], device="cuda")
scores = torch.tensor([0.9, 0.8], device="cuda")
keep_boxes, keep_idx = nms(boxes, scores, 0.5)
print("MMCV CUDA Ops Success! Selected indices:", keep_idx.tolist())
EOF
```

### 方法 3: ホスト（PC側）のファイルをコンテナにコピーする

手元の PC（Windows / Mac）で `test_mmcv.py` を作成済みの場合は、ホスト側のターミナル（PowerShell やコマンドプロンプトなど）から `docker cp` で送り込むのが確実です。

```
# ホスト側のターミナルで実行
docker cp test_mmcv.py <コンテナ名またはコンテナID>:/workspace/test_mmcv.py
```

転送後、Docker Desktop の Exec 画面で実行します：

```
python3 test_mmcv.py
```

