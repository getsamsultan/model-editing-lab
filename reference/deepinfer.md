# Reference engine: DeepSeek DeepInfer

**Status here: read, not run.** Recorded 19 November 2026.

## What it is

DeepInfer is DeepSeek's own production inference engine, open-sourced on 20 October 2026 under Apache-2.0 at [deepseek-ai/DeepInfer](https://github.com/deepseek-ai/DeepInfer). It serves one model: DeepSeek-V4.1-Flash (default checkpoint `deepseek-ai/DeepSeek-V4.1-Flash-1017`, MIT-licensed weights). The release covers offline inference and benchmarking; an HTTP server, a persistent KV cache, disaggregated prefill and decode, and load balancing are left to the user.

## Why it does not run on this rig

| | DeepInfer | This lab |
|---|---|---|
| Hardware | NVIDIA SM100 with CUDA 13, or Huawei Ascend 950 with CANN 9.2 | 3x Radeon AI PRO R9700 (RDNA4, gfx1201), ROCm |
| Scale | DeepSeek's notes give 64 prefill + 64 decode GPUs as the smallest efficient unit | 96 GB VRAM in total |
| Model precision | Native FP8/FP4 | The same model only fits here at about 1.6 bits per weight (233 GiB, via llama.cpp with RAM and SSD offload) |

Community ports exist but are not merged:

- **NVIDIA Hopper** (PR #92): runs end to end; the maintainer replied that it will not be merged and the author can maintain it.
- **AMD MI350X/MI355X, gfx950** ([PR #201](https://github.com/deepseek-ai/DeepInfer/pull/201), opened 22 Oct 2026, no maintainer review as of 19 Nov): replaces most NVIDIA-specific kernels (DeepGEMM, FlashMLA, fused MoE paths) with AITER, Triton, Gluon, CK flash-attention and a patched TileLang HIP backend. Single node only. Its own notes say: *"Batch-invariant mode is NVIDIA-only, so ROCm runs are not bit-reproducible."*

Porting to RDNA4 would mean rewriting most of those kernels again (different matrix instructions, far less on-chip memory than gfx950), and the model still would not fit at the engine's precision. Not pursued.

## What this lab uses it for

1. **Batch invariance (open research item).** DeepInfer has a batch-invariant mode on NVIDIA (`DEEPINFER_BATCH_INVARIANT=1`) so that a request gives the same output whatever batch it runs in, which matters for evaluations. The AMD port could not bring it across. Early measurements on this rig suggest the same can happen with llama.cpp on ROCm (details to follow in a separate write-up). Edits in this lab are judged by small output differences (KL divergence, refusal rate), so run-to-run variation from batch size has to be measured and kept out of the comparison. Next steps:
   - [ ] Read how DeepInfer achieves batch invariance on NVIDIA (fixed reduction order, same kernel at every batch size) and write it up here.
   - [ ] Measure the effect on llama.cpp ROCm directly: the same prompt at different batch and micro-batch sizes, KL divergence against a fixed reference.
   - [ ] Decide whether a batch-invariant mode for llama.cpp on ROCm is worth proposing upstream, with the numbers.
2. **A reference implementation of DeepSeek-V4.1-Flash.** The RDNA4 lab runs this model through an unmerged llama.cpp pull request. DeepInfer is DeepSeek's own definition of the architecture (attention, MoE, Engram). Reading the two side by side is a correctness review that needs no NVIDIA hardware.
3. **Background** on expert-parallel load balancing and speculative decoding, relevant to the MoE stations here.

## Sources

- [DeepInfer: hardware requirements, offline setup, serving gaps (AiCybr)](https://aicybr.com/blog/deepseek-deepinfer-offline-inference-hardware-benchmarks-deployment)
- [DeepInfer: read it, not run it (BuildMVPFast, 5 Nov 2026)](https://www.buildmvpfast.com/blog/deepinfer-deepseek-inference-engine-open-source-2026)
- [AMD ROCm backend, PR #201](https://github.com/deepseek-ai/DeepInfer/pull/201) and [PR #202](https://github.com/deepseek-ai/DeepInfer/pull/202)
- [Hopper and AMD ports (AgentsPulse)](https://agentspulse.github.io/tutorials/deepinfer-benchmarks/)

Details above come from the release notes and these write-ups, not from running the engine. Check the repository before relying on them.
