# Blueprint-reviewer directive — iter-045

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). Standard per-chapter completeness + correctness
checklist + unstarted-phase proposals.

## Focus (gate-relevant this iter)
The prover lanes this iter target:
- `Picard/FlatteningStratification.lean` (GF-G1 build) → chapter `Picard_FlatteningStratification.tex`,
  block `lem:gf_qcoh_fintype_finite_sections` (Stacks 01PB). Confirm complete+correct (HARD GATE).
- `Cohomology/FlatBaseChange.lean` (FBC keystone) → chapter `Cohomology_FlatBaseChange.tex`, block
  `lem:base_change_mate_fstar_reindex_legs_conj`. Confirm content is sufficient.

## New blueprint blocks this iter (verify they are well-formed)
Added to `Picard_QuotScheme.tex`: `def:pullback_open_immersion_unit_iso`, `def:pullback_preimage_iota_iso`
(coverage-debt helpers for landed Lean decls), and `lem:modules_annihilator_ideal` (reverse-inclusion
characterization, tex-precedes-Lean, iter-046 target — wires the previously-isolated
`lem:annihilator_localization_eq_map`).

## Note for you
`thm:generic_flatness` block (~line 1597 of Picard_FlatteningStratification.tex) has a structurally odd
header (`\leanok` + `[name]` appearing after `\begin{theorem}` on separate lines). Flag if malformed.

Report per-chapter verdicts + any unstarted-phase proposals (e.g. SNAP `def:sectionGradedRing`,
GR-quot/repr).
