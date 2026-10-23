#!/usr/bin/env bash
# Station 0: run inside the rocm/pytorch container. Prints what PyTorch sees and exits non-zero if no GPU.
python - <<'PY'
import sys, torch
ok = torch.cuda.is_available()
print("torch", torch.__version__, "| HIP", torch.version.hip)
print("GPU available:", ok)
if ok:
    for i in range(torch.cuda.device_count()):
        p = torch.cuda.get_device_properties(i)
        print(f"  {i}: {p.name}, {p.total_memory/2**30:.1f} GiB, {getattr(p, 'gcnArchName', '?')}")
    x = torch.randn(4096, 4096, device="cuda"); y = (x @ x).sum().item()
    print("matmul test: ok")
sys.exit(0 if ok else 1)
PY
