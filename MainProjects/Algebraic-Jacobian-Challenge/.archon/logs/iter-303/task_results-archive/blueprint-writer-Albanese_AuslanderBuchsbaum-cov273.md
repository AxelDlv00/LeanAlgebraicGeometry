# Blueprint Writer Report

## Slug
Albanese_AuslanderBuchsbaum-cov273

## Status
COMPLETE — added 31 coverage blocks (one per in-file uncovered Lean decl), wired
each into the chapter's dependency cone, and fixed all literal `REF` placeholders.
The 32nd listed decl (`AlgebraicGeometry.Scheme.PrimeDivisor.ext`) is a
misattribution: it lives in a different chapter's Lean file and is flagged below
(not added — out of write-domain).

## Target chapter
blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex

## Changes Made

### New coverage blocks added (label + `\lean{}`), grouped by new subsection

All blocks carry exactly one `\lean{}` pin (verified pinned exactly once across the
whole blueprint) and at least one `\uses{}` edge in or out. Proof bodies are
`Proved directly in Lean.` (these are sorry-free internal helpers).

New section `\section{Substrate helper declarations (1-to-1 Lean coverage)}`
(`\label{sec:ab_substrate_helpers}`), inserted just before the
`Corollary: regular local rings are Cohen--Macaulay` section, with five subsections:

**Ext-annihilation and depth-bound substrate** (`subsec:ab_ext_depth_substrate`)
- `lem:ext_smul_eq_zero_of_mem_annihilator` — `RingTheory.Module.ext_smul_eq_zero_of_mem_annihilator`
- `lem:ext_vanish_of_natCast_lt_depth` — `RingTheory.Module.ext_vanish_of_natCast_lt_depth`
- `lem:natCast_add_one_le_of_le_sub_one` — `RingTheory.Module.natCast_add_one_le_of_le_sub_one`
- `lem:depth_eq_of_linearEquiv` — `RingTheory.Module.depth_eq_of_linearEquiv`

**Depth of a constant product module** (`subsec:ab_depth_pi_substrate`)
- `lem:ideal_smul_top_pi_const` — `RingTheory.Module.ideal_smul_top_pi_const`
- `lem:ideal_smul_top_pi_const_eq_top_iff` — `RingTheory.Module.ideal_smul_top_pi_const_eq_top_iff`
- `def:quotSMulTopPiConstLinearEquiv` — `RingTheory.Module.quotSMulTopPiConstLinearEquiv` (definition)
- `lem:isRegular_pi_const_iff_of_nonempty` — `RingTheory.Module.isRegular_pi_const_iff_of_nonempty`
- `lem:depth_pi_const_eq_depth_of_nonempty` — `RingTheory.Module.depth_pi_const_eq_depth_of_nonempty`

**Surjection and projective-dimension substrate** (`subsec:ab_surjection_substrate`)
- `lem:exists_isSMulRegular_of_one_le_depth` — `RingTheory.Module.exists_isSMulRegular_of_one_le_depth`
- `lem:depth_ses_ineqs_of_surjection_finite_localRing` — `RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing`
- `lem:exists_ne_zero_ext_of_depth_eq` — `RingTheory.Module.exists_ne_zero_ext_of_depth_eq`
- `lem:projectiveDimension_ker_eq_of_surjection` — `RingTheory.projectiveDimension_ker_eq_of_surjection`
- `lem:enat_ab_inductive_combine` — `RingTheory.enat_ab_inductive_combine`

**Matrix-collapse on Ext** (`subsec:ab_matrix_collapse_substrate`)
- `def:elemMap` — `RingTheory.Module.elemMap` (definition)
- `lem:elemMap_apply` — `RingTheory.Module.elemMap_apply`
- `lem:linearMap_finFunR_matrix_decomp` — `RingTheory.Module.linearMap_finFunR_matrix_decomp`
- `lem:ext_comp_mk_zero_ofHom_eq_zero_of_entries_mem_annihilator` — `RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`

**Regular-sequence and domain substrate** (`subsec:ab_regular_domain_substrate`)
- `lem:length_le_ringKrullDim_of_isRegular` — `RingTheory.CohenMacaulay.length_le_ringKrullDim_of_isRegular`
- `lem:toCotangent_ne_zero_of_not_mem_sq` — `RingTheory.CohenMacaulay.toCotangent_ne_zero_of_not_mem_sq`
- `lem:finrank_cotangentSpace_quot_span_singleton_succ` — `RingTheory.CohenMacaulay.finrank_cotangentSpace_quot_span_singleton_succ`
- `lem:exists_notMemSq_of_spanFinrank_pos` — `RingTheory.CohenMacaulay.exists_notMemSq_of_spanFinrank_pos`
- `lem:isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero` — `RingTheory.CohenMacaulay.isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero`
- `lem:regularLocal_quotient_isRegularLocal_of_notMemSq` — `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`
- `lem:exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes` — `RingTheory.CohenMacaulay.exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`
- `lem:notMem_minimalPrimes_of_regularLocal_succ` — `RingTheory.CohenMacaulay.notMem_minimalPrimes_of_regularLocal_succ`
- `lem:isDomain_of_regularLocal` — `RingTheory.CohenMacaulay.isDomain_of_regularLocal`
- `lem:exists_isSMulRegular_notMemSq_of_regularLocal_succ` — `RingTheory.CohenMacaulay.exists_isSMulRegular_notMemSq_of_regularLocal_succ`
- `lem:exists_isSMulRegular_quotient_isRegularLocal_succ` — `RingTheory.CohenMacaulay.exists_isSMulRegular_quotient_isRegularLocal_succ`
- `lem:regularLocal_inductive_step` — `RingTheory.CohenMacaulay.regularLocal_inductive_step`
- `lem:exists_isRegular_of_regularLocal` — `RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal`

### `\uses{}` edges added to EXISTING blocks (preferred wiring into the public cone)
- `lem:depth_via_ext` (statement): `+def:depth, +lem:ext_smul_eq_zero_of_mem_annihilator`.
- `lem:depth_short_exact_sequence` (proof): `+lem:depth_via_ext, +lem:ext_vanish_of_natCast_lt_depth, +lem:natCast_add_one_le_of_le_sub_one`.
- `thm:auslander_buchsbaum` (proof): `+lem:depth_short_exact_sequence, +lem:auslander_buchsbaum_formula_succ_pd, +lem:depth_eq_of_linearEquiv, +lem:depth_pi_const_eq_depth_of_nonempty` (matches the Lean body: base case calls `depth_eq_of_linearEquiv` + `depth_pi_const_eq_depth_of_nonempty`; inductive step delegates to `_succ_pd`).
- `lem:auslander_buchsbaum_formula_succ_pd` (proof): `+lem:depth_ses_ineqs_of_surjection_finite_localRing, +lem:exists_ne_zero_ext_of_depth_eq, +lem:ext_comp_mk_zero_ofHom_eq_zero_of_entries_mem_annihilator, +lem:enat_ab_inductive_combine, +lem:projectiveDimension_ker_eq_of_surjection` (all directly called in the `_succ_pd` Lean body).
- `lem:depth_ker_ge_min_of_surjection_finite_localRing`: `+lem:depth_pi_const_eq_depth_of_nonempty`.
- `cor:regular_cohen_macaulay`: `+lem:exists_isRegular_of_regularLocal, +lem:length_le_ringKrullDim_of_isRegular` (the lower/upper-bound halves of `CohenMacaulay.of_regular`).

### `\uses{}` edges internal to the new blocks (real Lean call graph)
- `lem:ext_vanish_of_natCast_lt_depth → lem:depth_via_ext`
- `lem:ideal_smul_top_pi_const_eq_top_iff → lem:ideal_smul_top_pi_const`
- `def:quotSMulTopPiConstLinearEquiv → lem:ideal_smul_top_pi_const`
- `lem:isRegular_pi_const_iff_of_nonempty → def:quotSMulTopPiConstLinearEquiv`
- `lem:depth_pi_const_eq_depth_of_nonempty → lem:ideal_smul_top_pi_const_eq_top_iff, lem:isRegular_pi_const_iff_of_nonempty`
- `lem:depth_ses_ineqs_of_surjection_finite_localRing → lem:depth_short_exact_sequence, lem:depth_pi_const_eq_depth_of_nonempty`
- `lem:exists_ne_zero_ext_of_depth_eq → lem:depth_via_ext`
- `lem:projectiveDimension_ker_eq_of_surjection → def:projective_dimension, lem:hasProjectiveDimensionLT_succ_of_projectiveDimension_eq, lem:hasProjectiveDimensionLT_ker_of_surjection, lem:hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`
- `lem:elemMap_apply → def:elemMap`
- `lem:linearMap_finFunR_matrix_decomp → def:elemMap, lem:elemMap_apply`
- `lem:ext_comp_mk_zero_ofHom_eq_zero_of_entries_mem_annihilator → lem:linearMap_finFunR_matrix_decomp, lem:ext_smul_eq_zero_of_mem_annihilator`
- `lem:finrank_cotangentSpace_quot_span_singleton_succ → lem:toCotangent_ne_zero_of_not_mem_sq`
- `lem:regularLocal_quotient_isRegularLocal_of_notMemSq → lem:finrank_cotangentSpace_quot_span_singleton_succ`
- `lem:notMem_minimalPrimes_of_regularLocal_succ → lem:exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes, lem:regularLocal_quotient_isRegularLocal_of_notMemSq`
- `lem:isDomain_of_regularLocal → lem:isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero, lem:exists_notMemSq_of_spanFinrank_pos, lem:regularLocal_quotient_isRegularLocal_of_notMemSq, lem:notMem_minimalPrimes_of_regularLocal_succ`
- `lem:exists_isSMulRegular_notMemSq_of_regularLocal_succ → lem:exists_notMemSq_of_spanFinrank_pos, lem:isDomain_of_regularLocal`
- `lem:exists_isSMulRegular_quotient_isRegularLocal_succ → lem:exists_isSMulRegular_notMemSq_of_regularLocal_succ, lem:finrank_cotangentSpace_quot_span_singleton_succ`
- `lem:regularLocal_inductive_step → lem:exists_isSMulRegular_quotient_isRegularLocal_succ`
- `lem:exists_isRegular_of_regularLocal → lem:regularLocal_inductive_step`
- Outgoing-only edges (kept non-isolated, no in-file caller): `lem:exists_isSMulRegular_of_one_le_depth → def:depth` (off-critical companion to the depth-drop step); `lem:depth_eq_of_linearEquiv → def:depth` (also pulled into `thm:auslander_buchsbaum`); `lem:ext_smul_eq_zero_of_mem_annihilator → def:depth` (also incoming from `lem:depth_via_ext`).

End state: `cor:regular_cohen_macaulay` and `thm:auslander_buchsbaum` transitively
`\uses{}` every new helper; `leandag query --isolated --chapter Albanese_AuslanderBuchsbaum`
returns 0 results.

### Literal `REF` placeholders fixed (22 prose sites)
All literal `Definition~REF` / `Lemma~REF` / `Theorem~REF` / `Corollary~REF` /
`Section~REF` in rendered prose replaced with the correct `\cref{...}`:
- §Setup/motivation (L42, the 5-item enumerate L47–55, the closing paragraph L57–58):
  → `cor:regular_cohen_macaulay`, `def:depth`, `lem:depth_via_ext`,
  `def:projective_dimension`, `lem:depth_short_exact_sequence`,
  `thm:auslander_buchsbaum`, `sec:ab_application_to_a4a`.
- §Projective dimension (L192) → `thm:auslander_buchsbaum`.
- Proof of `lem:depth_short_exact_sequence` (L269) → `lem:depth_via_ext`.
- §Application (the codim-1 enumerate + gating paragraph) → `cor:regular_cohen_macaulay`,
  `thm:auslander_buchsbaum`.
- §Lean encoding (Mathlib-substrate bullets + the 3-step plan) → `def:depth`,
  `def:projective_dimension`, `def:cohen_macaulay_local`, `thm:auslander_buchsbaum`,
  `lem:depth_via_ext`, `cor:regular_cohen_macaulay`.
- §Out of scope (L1224) → `cor:regular_cohen_macaulay`.

`grep "REF"` of all non-comment lines now returns empty. (The `REF` tokens that
remain are only inside the verbatim `% SOURCE QUOTE PROOF:` comments copied from
Stacks — those are intentionally left verbatim and are not rendered.)

## Cross-references introduced
All new `\uses{}` targets verified to exist via `leandag build --json`
(`unknown_uses` touching this chapter: none; `unmatched_lean` touching this
chapter: none). All `\cref{}` targets used in the REF cleanup are labels that
exist in this same chapter.

## Verification
- `leandag query --isolated --chapter Albanese_AuslanderBuchsbaum` → 0 isolated nodes.
- `leandag build --json`: no `unknown_uses` and no `unmatched_lean` involving this
  chapter's 64 labels.
- All 31 new `\lean{}` pins occur exactly once across `blueprint/src/chapters/`.
- LaTeX environments balanced: lemma 38/38, definition 5/5, theorem 1/1,
  corollary 1/1, proof 36/36. `\lean` pins 46, `\label`s 64.
- No `\leanok` added (left to the deterministic `sync_leanok` phase).

## References consulted
None — no external citation blocks were authored. Every new block is an internal
helper of the existing, already-cited public API (`thm:auslander_buchsbaum`,
`cor:regular_cohen_macaulay`, `def:depth`, etc.), so per the descriptor the blocks
stand on their `Proved directly in Lean.` proof line without a `% SOURCE:` quote.
Source material read this session was the Lean file
`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (signatures + docstrings of
all 31 helpers) and the chapter itself.

## Notes for Plan Agent
- **Misattributed decl `AlgebraicGeometry.Scheme.PrimeDivisor.ext` (NOT added).**
  The directive's uncovered list includes `AlgebraicGeometry.Scheme.PrimeDivisor.ext`,
  but that declaration is defined in
  `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:153` (the structure
  `Scheme.PrimeDivisor` is at L94), which is covered by chapter
  `RiemannRoch_WeilDivisor.tex` (`% archon:covers ...WeilDivisor.lean`), NOT by
  `AuslanderBuchsbaum.tex` (`% archon:covers ...AuslanderBuchsbaum.lean`). It is
  currently only *mentioned in prose* (RiemannRoch_WeilDivisor.tex L430) and has no
  `\lean{}` pin anywhere. Adding it here would be a wrong cross-file attribution and
  is outside my write-domain. **Recommend re-dispatching a coverage block for
  `AlgebraicGeometry.Scheme.PrimeDivisor.ext` to the `RiemannRoch_WeilDivisor`
  writer**, where it belongs (one `\lean{}`-pinned block wired into the WeilDivisor
  prime-divisor API).
- The two outgoing-only helpers `lem:exists_isSMulRegular_of_one_le_depth` and
  `lem:depth_eq_of_linearEquiv` have no in-file *additional* caller beyond what I
  wired; `exists_isSMulRegular_of_one_le_depth` in particular is an off-critical
  companion to the depth-drop step and is not invoked elsewhere in the current Lean
  source. It is non-isolated (edge to `def:depth`) and faithfully stated; flagging
  in case a future refactor wants to consume it (it is the natural
  "regular element exists when depth ≥ 1" primitive).

## Strategy-modifying findings
None.
