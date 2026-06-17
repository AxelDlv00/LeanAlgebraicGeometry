# Blueprint Writer Report

## Slug
fbc-decomp

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### TASK 1 — Rewrote the proof of `lem:base_change_mate_regroupEquiv`
- **Revised** proof block of `\label{lem:base_change_mate_regroupEquiv}` /
  `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}`. Statement block left
  unchanged (signature, SOURCE/SOURCE QUOTE, tensor-order convention NOTE all intact).
- Removed the unsound prescription ("obtain the `ModuleCat` iso directly from
  `base_change_regroup_linearEquiv` by `LinearEquiv.toModuleIso`; the separate
  compilation unit normalises the diamond so `map_smul'` discharges") and the
  iter-006 review `% NOTE`. The refutation reasoning is now encoded as the proof
  rationale (mathematical prose, no session narrative):
  1. **Identity bridge `eT` is mandatory.** The helper's source
     `(A ⊗_R R') ⊗_A^can M` (canonical `Algebra.TensorProduct` A-action) and the
     carrier `(extendScalars ι).obj M` (`restrict_ι` A-action) are *different types*
     because the A-module is an instance argument of the relative tensor product; a
     compilation boundary normalises the value-level `Module A` diamond but never the
     tensor type, so the identity-A-linear bridge cannot be elided.
  2. **Residue = R'-linearity, checked on generators at the full carrier.** Primary
     formalization route presented: a `TensorProduct.ext`-style linearity check that
     keeps the generator `(a ⊗ s) ⊗ m` typed at the full carrier object, so the
     object's own (transparent) R'-instance is in play and the reduction chain
     `restrictScalars.smul_def → ExtendScalars.smul_tmul → tmul_mul_tmul →
     helper comm/cancelBaseChange_tmul/comm` fires. The generator computation
     `(1⊗r')·((a⊗s)⊗m) = (a⊗(r's))⊗m ↦ (r's)⊗(a·m) = r'·(s⊗(a·m))` is written out.
  - **Fallback route (b)** mentioned in prose: a small project-local `ModuleCat`-level
    base-change iso for the mixed `restrict ∘ extendScalars` square (Beck–Chevalley
    style) exposing a transparent R'-action. I chose route **(a)** as primary (more
    direct, matches the exact reduction chain the prover identified as firing) and
    therefore did NOT add a standalone helper block — the directive only requires one
    "if you choose (b)".
- `\uses{lem:cancelBaseChange_mathlib, lem:base_change_regroup_linearEquiv}` retained.

### TASK 2 — Decomposed `lem:base_change_mate_generator_trace_eq` into three sub-lemmas
Three NEW sub-lemma blocks added immediately before the trace_eq lemma (these are new
Lean declarations the prover will create next iter — they correctly show as
`unmatched_lean` in leandag now):

- **Sub-lemma A — unit value.** `\label{lem:base_change_mate_unit_value}` /
  `\lean{AlgebraicGeometry.base_change_mate_unit_value}`.
  `\uses{lem:base_change_mate_codomain_read, lem:pullback_spec_tilde_iso}`.
  States: the `((g')^*,(g')_*)`-unit η' on global M, read through Θ_tgt, is
  `m ↦ (1⊗1)⊗m`. Proof via `pullback_spec_tilde_iso` naturality at the unit.

- **Sub-lemma C — pseudofunctor reindex.** `\label{lem:base_change_mate_fstar_reindex}` /
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}`.
  `\uses{lem:base_change_mate_codomain_read, lem:base_change_mate_unit_value}`.
  States: `f_* = restr_φ` leaves `m ↦ (1⊗1)⊗m` unchanged on elements; pseudofunctor
  identities `(g'f)_* = (f'g)_* = g_* f'_*` reindex the target as the codomain read.
  Prose remark records that the prover closes this by the in-file category API
  (pushforward-composition + pushforward-congruence naturality).

- **Sub-lemma B — transpose-on-elements.** `\label{lem:base_change_mate_gstar_transpose}` /
  `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}`.
  `\uses{lem:base_change_mate_domain_read, lem:base_change_mate_unit_value}`.
  States the standard `(g^*⊣g_*)`-transpose-on-elements formula
  `û(r'⊗m) = r'·u(m)`, applied to the unit assignment to give
  `r'⊗m ↦ (r'⊗1)⊗m`. Carries a `% NOTE:` citation anchor (extension–restriction
  adjunction; no external reference, per directive) rather than a fabricated SOURCE.

- **Rewrote** the proof of `\label{lem:base_change_mate_generator_trace_eq}` as a thin
  assembly invoking A, C, B in sequence to land
  `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m = regroup⁻¹` on generators, hence everywhere by R'-linearity.
  Statement block (with `\leanok` and SOURCE/SOURCE QUOTE) left unchanged.
  Proof `\uses{}` now wires:
  `def:pushforward_base_change_map, lem:base_change_mate_domain_read,
   lem:base_change_mate_codomain_read, lem:base_change_mate_regroupEquiv,
   lem:base_change_mate_unit_value, lem:base_change_mate_fstar_reindex,
   lem:base_change_mate_gstar_transpose`.

All prose uses prose tensor orientation `(R' ⊗_R A) ⊗_A M` with generator `(r'⊗1)⊗m`,
consistent with the existing trace_eq statement and the regroupEquiv convention NOTE.
No `\leanok` added anywhere; no other declaration touched.

## Cross-references introduced / `\uses{}` graph consistency
Verified with `leandag build --json`:
- `unknown_uses: []` — no broken `\uses` references introduced.
- `isolated: 0` — no isolated nodes.
- `conflicts: []`.
- Dependency chain is consistent:
  - assembly `lem:base_change_mate_generator_trace_eq`
    → A `lem:base_change_mate_unit_value`,
      C `lem:base_change_mate_fstar_reindex`,
      B `lem:base_change_mate_gstar_transpose`,
      + domain/codomain reads + regroupEquiv + def.
  - A → `lem:base_change_mate_codomain_read`, `lem:pullback_spec_tilde_iso`.
  - C → `lem:base_change_mate_codomain_read`, A.
  - B → `lem:base_change_mate_domain_read`, A.
- The three new sub-lemmas appear under leandag `unmatched_lean` (blueprint node
  present, Lean declaration not yet created). This is EXPECTED per the directive — the
  prover creates `AlgebraicGeometry.base_change_mate_unit_value`,
  `…_fstar_reindex`, `…_gstar_transpose` next iter.

## References consulted
None opened this session beyond the target chapter and its sibling
`Cohomology_RegroupHelper.tex` (read for the `base_change_regroup_linearEquiv` API:
factorisation `comm → cancelBaseChange → comm`, generator
`(a⊗s)⊗m ↦ s⊗(a·m)`, and the `rightAlgebra` R'-action `r'·(a⊗s) = a⊗(r's)`). No new
citation blocks were authored; existing SOURCE/SOURCE QUOTE blocks (Stacks "Affine base
change") were left verbatim and unchanged. No reference-retriever dispatched.

## Macros needed (if any)
None. All commands used (`\operatorname`, `\otimes`, `\texttt`, `\widehat`, etc.) are
standard and already in use throughout the chapter.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- TASK 1 route choice: I selected route **(a)** (inline `TensorProduct.ext` linearity
  check at the full carrier) as primary and route **(b)** (standalone ModuleCat
  base-change iso) as a named fallback in prose. No new helper block was added, so the
  regroupEquiv node count is unchanged. If the iter-008 prover finds route (a) still
  fights an opaque instance, the fallback (b) is the cue to dispatch a writer to add the
  small ModuleCat-square helper block — flag me and I can author it.
- The three new sub-lemma `\lean{}` targets do not yet exist in Lean (expected). They
  are well-typed, focused statements ready for the prover. The `pushforwardComp` /
  `pushforwardCongr` API named for sub-lemma C is in-file Lean category API, not a
  blueprint node, so it is carried as a prose remark (not a `\uses`), as directed.

## Strategy-modifying findings
None. The decomposition and the corrected regroupEquiv rationale are faithful to the
existing strategy (FBC-A, i=0 affine base-change on global sections); the rewrite only
replaces an unsound formalization prescription with a sound one and splits a
Mathlib-absent monolith into provable pieces. No strategy-level assumption changed.
