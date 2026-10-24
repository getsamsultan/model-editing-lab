# Station 0 — PyTorch on ROCm sees an R9700 (2026-10-25)

**Image:** `rocm/pytorch:rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.9.1`, digest `sha256:7fe531fa185af260352fe7fbb3fa64ad749abe72adf0600a648c4692801b125a`
**GPU:** one Radeon AI PRO R9700 (`HIP_VISIBLE_DEVICES=2`, the chipset-slot card), while the other two served a model

```
torch 2.9.1+rocm7.2.4.git39497456 | HIP 7.2.53211-97f5574fe2
GPU available: True
AMD Radeon Graphics 31.9 GiB gfx1201
matmul ok
```

Run with `--device /dev/kfd --device /dev/dri --group-add 44 --group-add 992 --security-opt seccomp=unconfined`. Result: PASS. A 4096 × 4096 matrix multiply ran on the GPU.
