$gpuName = (nvidia-smi --query-gpu=name --format=csv,noheader)[0]
Write-Host "検出されたGPU: $gpuName"

if ($gpuName -like "*5090*") {
    docker build -f Dockerfile.rtx5090 -t my-cuda:rtx5090 .
} else {
    docker build -f Dockerfile.rtx4090 -t my-cuda:rtx4090 .
}
