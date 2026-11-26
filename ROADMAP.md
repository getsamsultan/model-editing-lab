# Roadmap

Each station ends with something measured and written down. Tick it off when the data is in `data/`.

## Abliteration

- [x] **Station 0: Setup.** (passed 2026-10-25, [record](data/2026-10-25-station-0-rocm-pytorch.md)) PyTorch in the `rocm/pytorch:rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.9.1` container sees an R9700 (`scripts/check-rocm-torch.sh` passes)
- [ ] **Station 1: First run.** Heretic on Qwen3-4B-Instruct-2507, one card. Record: Heretic version, chosen settings, refusal count, KL divergence, run time
- [ ] **Station 2: Measure properly.** Convert original and edited models to GGUF Q8_0. Compare perplexity, `llama-bench` speed and a fixed 20–30-question task set
- [ ] **Station 3: Cost curve.** Repeat with three different results from the same search: refusal rate against KL divergence and perplexity → **Finding 01**
- [ ] **Station 4: Bigger dense model.** Qwen3-14B on one card (~28 GB at full precision). Does the cost grow with size?
- [ ] **Station 5: MoE.** Qwen3-30B-A3B across two or three cards. Does abliteration behave differently when only some experts are active?
- [ ] **Station 6: Security write-up.** What this means for organisations deploying open models locally → **Finding 02**

## Fine-tuning (LoRA)

- [ ] **Station 7: First LoRA.** Small Qwen fine-tuned on public material (Modbus specification, own lab notes) with PEFT + TRL on ROCm
- [ ] **Station 8: Learned vs forgot.** Before/after on held-out questions plus perplexity → **Finding 03**

## Research items

- [ ] **Batch invariance on ROCm.** Same request, different batch size, different output: measure it on llama.cpp ROCm and study how DeepSeek's DeepInfer avoids it on NVIDIA. Needed so small edit effects are not confused with run-to-run variation. See [reference/deepinfer.md](reference/deepinfer.md)

- [ ] **Songe: a model that fine-tunes itself.** [Songe](https://github.com/sous-labs/songe) (Apache-2.0) trains a LoRA adapter from an agent's own conversations while the machine is idle. Does it run on ROCm, what does each automatic edit gain and cost, and can an injected instruction be learned into the weights? Pairs with the RDNA4 lab's [OpenAPPA plan](https://github.com/getsamsultan/rdna4-local-ai-lab/blob/main/docs/test-plans/openappa-local-models.md) → [test plan](plans/songe-self-learning.md)

## Blocked for now

- [ ] **Qwen3.8-Flash-Next.** ~354 GB at full precision and a new architecture (`qwen4exp`): too big for this rig, and not yet supported by the tools
