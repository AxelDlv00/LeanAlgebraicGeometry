# Blueprint Writer Report

## Slug
iter059

## Status
COMPLETE — all five tasks (A–E) executed; leandag clean (`unknown_uses: []`).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task A — σ-component slice-product bridge note
- **Revised** `lem:coproduct_distrib_fibrePower_zero` — appended a bridge sentence stating the Lean
  σ-component is kept in slice-product normal form `∏ᶜ_k Over.mk(f∘σ k)` in `Over S`, identified with
  the wide fibre power via `lem:widePullback_overX_eq_prod` at the assembly site
  `lem:cech_backbone_left_sigma`. Its `\uses{}` already contained `lem:widePullback_overX_eq_prod`
  (both statement and proof) — no `\uses` change needed.
- **Revised** `lem:coproduct_distrib_fibrePower` — appended the same bridge sentence to the statement
  body. Its statement `\uses{}` already listed `lem:widePullback_overX_eq_prod`; the proof block too.

### Task B — universe-reduction note (CRITICAL)
- **Revised** `lem:cech_backbone_left_sigma` proof — added a "Universe reduction" paragraph: the
  distributivity leaves live at `Type 0` because Mathlib's `isIso_sigmaDesc_fst` is `Type 0`-only;
  the cover index `I` is reduced to `Fin n` (via `I ≃ Fin n` from finiteness), the family/indices
  reindexed, the `Type 0` decomposition applied, and the iso transported back. States explicitly that
  naively widening leaves to `Type*` breaks `isIso_sigmaDesc_fst`.
- **Revised** `lem:coproduct_distrib_fibrePower` statement — added a one-line "Universe caveat"
  pointing at `lem:isIso_sigmaDesc_fst_mathlib` and naming `lem:cech_backbone_left_sigma` as the
  reduction site.
- **Added Mathlib anchor** `lem:isIso_sigmaDesc_fst_mathlib` /
  `\lean{CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_fst}` / `\mathlibok` — placed right after
  `lem:isIso_sigmaDesc_map_mathlib`. States the `{α : Type 0}` restriction explicitly.
- **Fixed dependencies** `lem:prod_coproduct_distrib` (statement + proof) — added
  `lem:isIso_sigmaDesc_fst_mathlib` to `\uses{}`.

### Task C — new sub-lemma `lem:overProd_coproduct_distrib`
- **Added lemma** `lem:overProd_coproduct_distrib` /
  `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib}` (build-target `% NOTE:`)
  right after `lem:prod_coproduct_distrib`. Statement: `(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)` in `Over S` for
  `{ι : Type 0} [Finite]`. Proof sketch: `Over.forget S` reflects isos → match `.left` via
  `Over.prodLeftIsoPullback`, reduce to `lem:prod_coproduct_distrib`. `\uses{lem:prod_coproduct_distrib,
  lem:overProdLeftIsoPullback_mathlib}` on both statement and proof.
- **Added Mathlib anchor** `lem:overProdLeftIsoPullback_mathlib` /
  `\lean{CategoryTheory.Over.prodLeftIsoPullback}` / `\mathlibok`.
- **Fixed dependencies** `lem:coproduct_distrib_fibrePower` — added `lem:overProd_coproduct_distrib`
  to `\uses{}` of both statement and proof blocks; expanded the inductive-step prose to note
  distributivity is consumed in the `Over S` binary-product form.

### Task D — `\uses{}` on `lem:pushforward_iso_preserves_qcoh`
- **Fixed dependencies** `lem:pushforward_iso_preserves_qcoh` (statement + proof) — added
  `\uses{lem:modules_pushforward_mathlib}` (the pushforward functor/equivalence
  `pushforwardEquivOfIso` is built from it). I did **not** add a "iso preserves IsQuasicoherent"
  Mathlib anchor: I could not confirm such a precise declaration exists in Mathlib under a known name,
  and an invented `\mathlibok` is worse than the bare edge (the proof argues qcoh-preservation from the
  local-presentation characterization directly). See Notes.

### Task E — bundle lean_aux helper names
- `lem:widePullback_overX_eq_prod` `\lean{}` += `CategoryTheory.widePullback_overX_isLimit`.
- `lem:coverArrow_over_sigma` `\lean{}` += `CategoryTheory.overSigmaDescCofan`,
  `overSigmaDescIsColimit`, `overSigmaDescIso`.
- `lem:coproduct_distrib_fibrePower` `\lean{}` += `CategoryTheory.FinitaryPreExtensive.prodFinSuccIso`.
- `lem:affine_cech_vanishing_general_seed` `\lean{}` += `AlgebraicGeometry.affine_tildeVanishing_general`.
- `lem:widePullback_openImm_inter` `\lean{}` += `AlgebraicGeometry.mem_iInf_opens_of_finite`.
- `lem:cechSection_complex_iso` `\lean{}` += `AlgebraicGeometry.sectionCechComplexV`.
- Did NOT touch `AlgebraicGeometry.CechAcyclic.affine` (dead, per directive).

## Cross-references introduced
- `lem:overProd_coproduct_distrib` (new, this chapter) — used by `lem:coproduct_distrib_fibrePower`.
- `lem:overProdLeftIsoPullback_mathlib` (new mathlib anchor, this chapter) — used by
  `lem:overProd_coproduct_distrib`.
- `lem:isIso_sigmaDesc_fst_mathlib` (new mathlib anchor, this chapter) — used by
  `lem:prod_coproduct_distrib`; referenced by `lem:coproduct_distrib_fibrePower` and
  `lem:cech_backbone_left_sigma` prose.
- All resolve: `leandag build --json` → `unknown_uses: []`.

## leandag verification
`leandag build --json`: 252 blueprint nodes parsed, `unknown_uses: []`, isolated = 1 (a pre-existing
unmatched `lean_aux` node, NOT one of my blocks; all three new blueprint blocks are wired in). The
three new `\lean{}` targets that are build-targets / mathlib appear in `unmatched_lean` exactly like
their siblings (`overProd_coproduct_distrib` = prover target; the two `\mathlibok` anchors match the
pattern of every other mathlib anchor in the chapter, whose Mathlib decls aren't in the local Lean
scan). Task E bundles reduced the unmatched `lean_aux` set (summary `lean_aux_nodes: 1`).

## References consulted
None this session — all five tasks were structural (`\uses`/`\lean` wiring, universe/normal-form
documentation notes, and one Archon-original bridge sub-lemma). No new external-source citation blocks
were authored; the one new project lemma (`lem:overProd_coproduct_distrib`) is bespoke and carries no
`% SOURCE` block. The pre-existing `% SOURCE`/`% SOURCE QUOTE` lines on `lem:affine_cech_vanishing_general_seed`
were left untouched (only its `\lean{}` list was extended).

## Macros needed
None. The slice-product notation uses `\prod^{\mathrm{c}}_{k}` (plain LaTeX, no new macro).

## Reference-retriever dispatches
None.

## Notes for Plan Agent
- **Task D Mathlib anchor deferred (truthfulness).** The directive offered the option of a `\mathlibok`
  anchor for "an equivalence/iso of schemes preserves `IsQuasicoherent`." I did not find a Mathlib
  declaration with that exact statement that I could name confidently, so I wired
  `lem:pushforward_iso_preserves_qcoh` to `lem:modules_pushforward_mathlib` only and left
  `pushforward_iso_preserves_qcoh` as the project's own build-target proving qcoh-preservation from the
  local-presentation characterization. If the reviewer/prover knows the precise Mathlib name (e.g. a
  `IsQuasicoherent` transport along an iso of ringed spaces / `Scheme.Modules` equivalence), adding a
  `\mathlibok` anchor and `\uses`-ing it would be the better edge.
- The new `lem:overProd_coproduct_distrib` and `lem:isIso_sigmaDesc_fst_mathlib` both pin the index
  type at `Type 0`; the prover should keep the whole `widePullback_coproduct_iso` chain at `Type 0`
  and perform the `Fin n` reduction only at `cechBackbone_left_sigma`, as the new prose documents.

## Strategy-modifying findings
None.
