# lean-vs-blueprint-checker — GmScaling.lean ↔ AbelianVarietyRigidity.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex` (covers GmScaling.lean per its `% archon:covers` header).

## What changed this iter (Lane A — iter-180)

- 2 TEMP project axioms DELETED (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`).
- `gmScalingP1_chart_PLB_eq` body landed kernel-clean via `set_option backward.isDefEq.respectTransparency false in` + a 6-stage tactic proof (per `analogies/pullbackspeciso-bypass.md`).
- `gmScalingP1_chart_agreement` now has a partial body — diagonal cases closed via `fst_eq_snd_of_mono_eq`; cross-case `(0,1)/(1,0)` left as honest sorry.
- `gmScalingP1_collapse_at_zero` now has an honest direct sorry (was previously axiom-laundered).

## Report bidirectionally

1. **Lean → blueprint**: do the file's actual declarations match the chapter's `\lean{...}` pins (post-Lane A)? Any new helpers / renames that the blueprint should mirror? Any laundering / placeholder bodies (axiom-bodied wrappers were retired; verify they are truly gone).
2. **Blueprint → Lean**: is the chapter detailed enough to have guided the iter-180 Lane A retirement? Specifically, the chart-bridge proof outline (Mumford-style `λ · u = (1/t) · λ` cocycle) — is the blueprint specific enough that the iter-181+ prover can close `gmScalingP1_chart_agreement` cross case + `gmScalingP1_collapse_at_zero` without re-deriving the math from scratch?

Output to `task_results/lean-vs-blueprint-checker-gmscaling.md`.
