# Iter 002 — Objectives

2 prover lanes, both `prove` mode (switched from fine-grained — decomposition complete).

1. **DualInverse.lean** (DUAL) — close L525+L388 (shared ε-naturality `erw` paste:
   `restrictScalarsLaxε`+`NatTrans.naturality`), then L627/L629 (round-trip cancellation).
   Anchor Stacks 0B8K; recipe ma-legb262.md. Bar: naturality pair axiom-clean.

2. **TensorObjSubstrate.lean** (D3′) — close L2623 `comp_tail` via non-circular fallback
   (surjective/injective reduction of `leftAdjointCompNatTrans_assoc`, mirrors Mathlib
   `SheafOfModules.pullback_assoc`); then L2851 if it lands. Recipe d3-mate271.md.
   L712 untouched (cycle). Bar: comp_tail axiom-clean.

Mode rationale: both iter-001 fine-grained provers reported "no sentence left to extract;
residual is concrete recipe." `prove` executes the recipe; re-fine-graining = churn.
