# Model Editing Lab

**What does it cost to change an open model's weights? Measured on 1–3× AMD Radeon AI PRO R9700 (RDNA4, ROCm).**

The companion to [rdna4-local-ai-lab](https://github.com/getsamsultan/rdna4-local-ai-lab). That repo measures how models *run*; this one measures what happens when you *change* them, starting with abliteration (removing a model's refusal behaviour without training) and moving on to LoRA fine-tuning.

The question isn't "can it be done": it can, in minutes. The question is **what it costs**: how much quality, stability and safety you trade for each change. That matters to anyone deploying open models locally, because a model's safety behaviour can be stripped by anyone with the weights.

## Ground rules

- **Methods and measurements are published here. Edited model weights are not.** No uncensored models are uploaded from this lab.
- Small public models only, under licences that allow modification (Qwen3: Apache-2.0).
- Every result records the tool version, model name and hash, settings and scores, like the RDNA4 lab.
- Experiments run in their own containers, separate from any production stack.

## Method in one paragraph

Run the model on prompts it refuses and prompts it answers, record its internal activations, and take the difference: research shows refusal mostly lives along one direction ([Arditi et al., 2024](https://arxiv.org/abs/2406.11717)). Edit the weights so they can't write along that direction. Then measure the trade-off: refusal rate against KL divergence (how much harmless answers changed), perplexity and task quality. Tooling: [Heretic](https://github.com/p-e-w/heretic) (AGPL-3.0) on PyTorch for ROCm.

## Progress

See [ROADMAP.md](ROADMAP.md) for each station and where it's up to.

## Rig

3× ASRock Radeon AI PRO R9700 Creator (32 GB each, gfx1201) · Ryzen 9 9950X · 96 GB DDR5 · Ubuntu 24.04, kernel 7.0 · ROCm 7.2 (`rocm/pytorch` container). Full details in the [RDNA4 lab](https://github.com/getsamsultan/rdna4-local-ai-lab#the-rig).

## Layout

```
findings/   One write-up per finding
data/       Raw scores and run records
scripts/    Setup checks and helpers
ROADMAP.md  Stations to tick off
```

---

<sub>Measurements and decisions are mine. Not affiliated with AMD, Qwen or the Heretic project. Licence: scripts under [MIT](LICENSE); write-ups and data under [CC BY 4.0](LICENSE-CONTENT), so reuse them freely with credit. No model weights are included.</sub>
