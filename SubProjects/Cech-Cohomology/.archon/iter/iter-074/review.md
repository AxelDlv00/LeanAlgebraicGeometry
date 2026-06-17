# iter-074 review — CSI route 2→1: `backboneIncl_proj` CLOSED & build-verified

## Overall Progress
- **CSI-route sorry: 2 → 1** (Leg file). Closed: `backboneIncl_proj` (Leg:739). Residual: `pushPull_interLegHom_sections` (Leg:1012) — the LAST CSI leaf.
- Solved: 1. Partial: 1 (last leaf, Steps 0–3′ scratch-green, Step-4 merge pending). Blocked: 0.
- Project term-sorry total = 3 (CSI last leaf + 2 non-active-lane: `CechHigherDirectImage:780` Route-A assembly, `CechAugmentedResolution:229` Sub-brick A glue).
- 67 edits across Leg/CSI/Base; prover ran 0 builds (27-min full check; used scratch vs Base `.olean`). Session killed mid-merge.

## This session's analysis
- **Real, verified progress — the contrast with iter-073 matters.** iter-073 landed 0 edits (tooling-stuck, prover refused lake-unverified work). This iter the iter-073 recommendation was executed: the 2475-LOC CSI file was **split into 3 files** (CSI 1133 / Base 1486 / Leg 1305), which made scratch-validation tractable and let edits land. `sync_leanok` (iter=74, sha dbaa628, 641 s) then ran a dependency-aware `lake build` that **added 19 `\leanok`, removed 0** → the `backboneIncl_proj` merge is kernel-verified, not just LSP-clean. The tooling wall is effectively solved by (split + sync_leanok-as-gate).
- `backboneIncl_proj` (prior 12.8M-heartbeat wall) closed by factoring reassociation into abstract-context lemmas (`entry_chain`/`glue_chain`) + one combo lemma in the cheap pre-extensive context. Pattern is reusable.
- Last leaf `pushPull_interLegHom_sections`: full 5-step route scratch-validated (Steps 0–3′ compile), only Step-4 transcription pending — high-probability close next iter, BUT blocked by a blueprint-adequacy HARD GATE (chapter has no proof sketch for it). Cheap fix: blueprint-writer transcribes the route (already worked out in the task_result) → fast-path re-review → prover finishes.

## Reviews / subagents
- Dispatched lean-auditor (3 CSI files) + lean-vs-blueprint-checker ×2 (Leg, CSI). csi = CLEAN. auditor = 0 must-fix / 2 major / 5 minor (stale Base docstring post-split; helper duplicates; orphaned scaffolding; 6.4M-heartbeat lemmas). leg = 1 must-fix (blueprint silent on last-leaf proof) + stale-`\leanok`-on-`coreIso_comm` note. Landed in recommendations.md.

## Markers
- No manual marker changes. coreIso_comm `\leanok` is sync's correct per-block verdict (transitive `sorryAx` taint through the open leaf is not per-block laundering) — left as-is, clears when the leaf closes.

## Coverage debt
- `unmatched` = 50 (was 0 after covdebt073; the split + new helpers reintroduced it). Full list → recommendations.md for the planner.

## Subagent skips
- lean-vs-blueprint-checker (Base): Base.lean received only mechanical split edits, is term-sorry-free, and introduced no new public statements needing a blueprint check this iter; auditor already covered it (stale-docstring major).

## Hand-off to next plan phase
- Author the `pushPull_interLegHom_sections` blueprint block (route is in `task_results/…Leg.lean.md`), clear the gate via fast-path re-review, then prover finishes Step-4 — likely closes the whole CSI route. Then sweep the 50-item coverage debt and the auditor hygiene items.
