# Blueprint Writer Report

## Slug
fbc-diamond

## Status
COMPLETE — all three required edits applied; `leandag` reports no broken `\uses` and no isolated
blocks in the chapter.

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### MUST-FIX §1 — `lem:base_change_mate_inner_eCancel_assemble` (diamond + term-mode mechanism)
- **Revised statement block**: added a `% NOTE (mechanism, for the prover):` comment naming the
  obstruction (nested-image `G.obj (H.obj M)` vs composed-functor `(H ⋙ G).obj M` object diamond on
  the `X.Modules` `CategoryStruct.comp`/`Functor.map` instance), why every keyed `rw`/`simp`/`erw`
  fails (motive-abstraction failure on the syntactic mismatch; `whnf` heartbeat timeout on the
  defeq-tolerant `erw` over the large leg term), and the Lean idiom for the fix
  (`congrArg (· ≫ _)` / `congrArg (_ ≫ ·)` / `Functor.congr_map`, `.trans`-chained, `exact`-closed),
  with the three in-file precedents (`pullbackPushforward_unit_comp`,
  `base_change_mate_fstar_reindex_legs_gammaDistribute`,
  `base_change_mate_inner_eCancel_pushforwardComp`). The NOTE records that the atoms are already in
  the goal's `Γ ∘ (Spec φ)_*` form and must be spliced directly (abandon `hpfc` / bare
  `gammaMap_pushforwardComp_hom_eq_id`).
- **Revised proof prose** (rendered, no Lean tactic strings): replaced the "apply the three atoms in
  turn … each atom matches on the nose" sketch — which mis-stated that definitional legs suffice —
  with three labelled paragraphs: *The residual obstruction* (the obj-form diamond stated
  mathematically), *The resolution: single-factor surgery in term mode* (lift each factor-equation
  into the composite by congruence on one neighbour at a time, chain, close on the definitional
  bridge where the diamond is absorbed; the three eCancel atoms spliced directly in their shipped
  `Γ ∘ (Spec φ)_*` form), and *The three cancellations* (the eUnit / pushforwardComp / pullbackComp
  cancellations, lone survivor the affine `(Spec ιA)`-unit → ρ via Seam 1).

### MUST-FIX §2 — `lem:base_change_mate_gstar_transpose` (step-3 dependency + uses)
- **Fixed `\uses{}`** (statement and proof, both blocks): added
  `lem:base_change_mate_fstar_reindex_legs` and `lem:base_change_mate_inner_eCancel_assemble` to
  reflect the real dependency — the Seam-A inner value routes through the leg-parametrised reindex,
  which carries the §1 `_legs` eCancel obligation.
- **Revised "Inner value (Seam A)" prose**: corrected the claim that the inner value is established —
  it now states the value routes through `lem:base_change_mate_fstar_reindex_legs` (instantiated at
  the projection legs) and carries the same residual eCancel obligation as
  `lem:base_change_mate_inner_eCancel_assemble`, discharged by the same term-mode surgery; only once
  discharged is it cited directly.
- **Revised "Counit factorization" prose**: added that the factor-splitting move past `Θ_src` /
  regroup / `Θ_tgt` meets the same nested-image vs composed-functor diamond and is carried out by the
  same term-mode single-factor surgery (the analogist's "ports identically" point), not a head-symbol
  cancellation.
- **Added `% NOTE (mechanism, for the prover):`** to the statement after the RECIPE comment,
  recording that step-2's conjugate-counit factor lives in the same locked `Γ`-image composite and
  uses the same term-mode mechanism, and that the inner-value citation is gated on the `_legs`
  obligation.

### Coverage / cleanup §3
- **Removed phantom `lem:base_change_regroup_linearEquiv`** from both `\uses{}` blocks of
  `lem:base_change_mate_regroupEquiv` (statement + proof) and **rewrote the prose `\ref`** at the
  start of that proof to point directly at `lem:isPushout_cancelBaseChange_mathlib` (the equivalence
  the phantom helper described), eliminating the dangling reference. Verified: the label
  `base_change_regroup_linearEquiv` no longer appears anywhere in the chapter, and it had no `\label`
  block (genuine phantom).
- **Added `% NOTE:`** on `lem:gammaMap_pushforwardComp_hom_eq_id` documenting that this atom and the
  two following (`gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) are `private`
  in Lean (mangled names), so the public-form `\lean{}` pins are an expected pin-resolution mismatch
  and a prover-side de-privatisation matter. Pins left unchanged, per directive.

## Cross-references introduced
- `\uses{lem:base_change_mate_fstar_reindex_legs}` and
  `\uses{lem:base_change_mate_inner_eCancel_assemble}` added to `lem:base_change_mate_gstar_transpose`
  (statement + proof) — both labels exist in this chapter (verified by `leandag`, `unknown_uses: []`).
- Prose `\ref{lem:isPushout_cancelBaseChange_mathlib}` now stands in for the removed phantom ref in
  `lem:base_change_mate_regroupEquiv`'s proof — target exists at chapter line ~1018.

## References consulted
- `analogies/fbc-functorimage-diamond.md` — the obstruction statement (nested-`obj` vs composed-`⋙`)
  and the term-mode resolution recipe (`congrArg`/`Functor.congr_map`/`.trans`/`exact`), plus the
  three in-file precedents, folded into the §1/§2 NOTEs and prose.
- `.archon/task_results/mathlib-analogist-fbc-diamond.md` — confirmation that the mechanism ports to
  `gstar_transpose` identically and the "splice atoms already in `Γ ∘ (Spec φ)_*` form" point.
- No external `references/**` files were needed: the source statement (Stacks 02KH part 2) is already
  cited in-chapter and the mechanism is a formalization technique, not new mathematics. No
  reference-retriever dispatched.

## Macros needed
- None. All new prose uses existing macros / standard `\(...\)` and `\[...\]` delimiters.

## Notes for Plan Agent
- The §1/§2 edits are pure proof-sketch / NOTE / `\uses` changes; no `\leanok` touched (those remain
  for `sync_leanok`). The `\lean{}` pins for `base_change_mate_inner_eCancel_assemble` and
  `gstar_transpose` were left as-is (both already pin the subsuming theorem
  `base_change_mate_fstar_reindex_legs`, per the existing LEAN-INTERNAL convention in the chapter).
- The private-atom NOTE documents a real Lean↔blueprint pin mismatch the prover must resolve
  (de-privatise the three atoms or accept the mangled-name pin); flagged here so the next lvb/doctor
  pass does not re-report it as a writer error.

## Strategy-modifying findings
- None. The mechanism is a formalization technique that unblocks the existing strategy; it does not
  change the mathematical content or the route.
