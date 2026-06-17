# Blueprint Writer Report

## Slug
quot-bridgeC

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### Job 1 — coverage blocks for the 6 new infra decls + 3 Mathlib anchors
Added a new sub-section **"The over-site/open-subspace sheaf equivalence (bridge C, topological
layer)"** immediately before the `% --- (C) The single slice-touching bridge ---` marker
(before `lem:over_restrict_iso`), with a one-line intro noting it fills the Mathlib
`Topology/Sheaves/Over.lean` TODO.

Six project-local infra blocks (each `\label` + `\lean{}` + `\uses{}` + one-line informal proof,
no `\leanok` added):

- **Added lemma** `\label{lem:overEquivalence_functor_isCocontinuous}` /
  `\lean{AlgebraicGeometry.overEquivalence_functor_isCocontinuous}` — functor cover-lifting via
  the over-sieve image criterion + pointwise opens covering + transport across the open
  embedding. `\uses{lem:opens_overEquivalence_mathlib}`. Proof sketch: Y.
- **Added lemma** `\label{lem:overEquivalence_inverse_isCocontinuous}` /
  `\lean{AlgebraicGeometry.overEquivalence_inverse_isCocontinuous}` — symmetric (preimage along
  the embedding). `\uses{lem:opens_overEquivalence_mathlib}`. Proof sketch: Y.
- **Added lemma** `\label{lem:overEquivalence_inverse_isDenseSubsite}` /
  `\lean{AlgebraicGeometry.overEquivalence_inverse_isDenseSubsite}` — formal from both
  cocontinuities. `\uses{lem:overEquivalence_functor_isCocontinuous,
  lem:overEquivalence_inverse_isCocontinuous}`.
- **Added lemma** `\label{lem:overEquivalence_functor_isContinuous}` /
  `\lean{AlgebraicGeometry.overEquivalence_functor_isContinuous}` — left adjoint of a
  cocontinuous functor is continuous, via the equivalence adjunction.
  `\uses{lem:overEquivalence_inverse_isCocontinuous}`.
- **Added lemma** `\label{lem:overEquivalence_inverse_isContinuous}` /
  `\lean{AlgebraicGeometry.overEquivalence_inverse_isContinuous}` — symmetric.
  `\uses{lem:overEquivalence_functor_isCocontinuous}`.
- **Added definition** `\label{def:overEquivalence_sheafCongr}` /
  `\lean{AlgebraicGeometry.overEquivalence_sheafCongr}` — the keystone sheaf-category
  equivalence `Sheaf (J_X|_U) A ≌ Sheaf (J_U) A` from the dense-subsite witness via the general
  sheaf-congruence construction. `\uses{lem:opens_overEquivalence_mathlib,
  lem:equivalence_sheafCongr_mathlib, lem:overEquivalence_inverse_isDenseSubsite}`.

Three new Mathlib dependency anchors (`\mathlibok`, names verified live via the Lean LSP, see
below):

- **Added lemma** `\label{lem:opens_overEquivalence_mathlib}` /
  `\lean{TopologicalSpace.Opens.overEquivalence}` — `\mathlibok`, the underlying site
  equivalence `(Opens X)_{/U} ≃ Opens U`.
- **Added lemma** `\label{lem:equivalence_sheafCongr_mathlib}` /
  `\lean{CategoryTheory.Equivalence.sheafCongr}` — `\mathlibok`, sheaf-category equivalence of
  equivalent sites under a dense-subsite hypothesis.
- **Added lemma** `\label{lem:pushforwardPushforwardEquivalence_mathlib}` /
  `\lean{SheafOfModules.pushforwardPushforwardEquivalence}` — `\mathlibok`, module-sheaf
  transport across an equivalence of ringed sites (the step-3 lift).

### Job 2 — `lem:over_restrict_iso` (bridge C)
- **Revised** `lem:over_restrict_iso` statement `\uses{}` — added
  `def:overEquivalence_sheafCongr, lem:overEquivalence_functor_isContinuous,
  lem:overEquivalence_inverse_isContinuous, lem:opens_overEquivalence_mathlib,
  lem:pushforwardPushforwardEquivalence_mathlib` (statement otherwise unchanged).
- **Revised** the statement `% NOTE:` block — kept the decl-not-yet-existing note; refined the
  `set_option backward.isDefEq.respectTransparency false` note to say it may be needed for the
  step-3 module-level synthesis (slice `IsRightAdjoint`/`HasSheafify` timeout), NOT the
  topological layer (cocontinuity went through plainly without it); added a note that the literal
  Lean form of `overRestrictIso` may need sharpening by routing THROUGH the step-3 equivalence
  functor, since the two sides live in different module categories.
- **Replaced** the proof body with the concrete 4-step decomposition: Step 1 (topological layer,
  done — `def:overEquivalence_sheafCongr`); Step 2 (geometric ring-sheaf identification, marked
  as the **current obstacle**, with the `U.ι.opensFunctor = (overEquivalence U).inverse ∘
  Over.forget U` factorization and the `restrictFunctor = pushforward` lead); Step 3 (module lift
  via `pushforwardPushforwardEquivalence`); Step 4 (compose with `restrictFunctorIsoPullback`,
  with the cross-category / route-through-step-3 caveat and the `D(r) ≅ Spec R_r` affine
  specialization). Proof `\uses{}` updated to list all four steps' components.

## Cross-references introduced
All resolve (leandag `unknown_uses` = 0). New intra-chapter edges:
- `def:overEquivalence_sheafCongr` → `lem:opens_overEquivalence_mathlib`,
  `lem:equivalence_sheafCongr_mathlib`, `lem:overEquivalence_inverse_isDenseSubsite`
- `lem:overEquivalence_inverse_isDenseSubsite` → the two cocontinuity lemmas
- continuity lemmas → the opposite-leg cocontinuity lemma
- `lem:over_restrict_iso` (statement + proof) → `def:overEquivalence_sheafCongr` and the two
  continuity lemmas + the two new Mathlib anchors.

## Verification
- `leandag build --json`: `unknown_uses = 0`, `conflicts = []`.
- The 6 project-local infra decls (`AlgebraicGeometry.overEquivalence_*`) are now **matched**
  (none remain in `unmatched_lean`) — the coverage debt for these 6 is cleared.
- The 3 new `\mathlibok` anchors appear in `unmatched_lean` exactly as every pre-existing
  Mathlib anchor in this chapter does (their `\lean{}` resolves to external Mathlib, not project
  source) — the established, correct pattern.
- LaTeX balance: 175 `\begin`/175 `\end` environments; 50 `\[`/50 `\]` display-math delimiters.
- Lean names verified live via the LSP before marking `\mathlibok`:
  `TopologicalSpace.Opens.overEquivalence` (hover), `CategoryTheory.Equivalence.sheafCongr`
  (hover), `SheafOfModules.pushforwardPushforwardEquivalence` (loogle, module
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.PushforwardContinuous`).

## References consulted
No external textbook/reference files were opened — all new blocks are project-bespoke
infrastructure or Mathlib dependency anchors, so no `% SOURCE:`/`% SOURCE QUOTE:` citation blocks
were written. Lean declaration signatures were confirmed against the project's
`AlgebraicJacobian/Picard/QuotScheme.lean` and the Mathlib source via the Lean LSP.

## Macros needed
None — used only existing macros (`\Spec`, `\cref`, `\mathrm`, standard math).

## Reference-retriever dispatches
None.

## Notes for Plan Agent
- Step 2 (the ring-sheaf identification, `O_X.over U ≅ U.toScheme.ringCatSheaf` across the
  `RingCat`-valued sheaf equivalence) is the only remaining geometric obstacle for
  `overRestrictIso`; the prose now leads the prover with the `opensFunctor` factorization and the
  `restrictFunctor = pushforward` identity. The topological layer (step 1) is in place and
  axiom-clean.
- `lem:isLocalization_basicOpen_mathlib` is referenced in the step-4 prose and is in both the
  statement and proof `\uses{}`.

## Strategy-modifying findings
None.
