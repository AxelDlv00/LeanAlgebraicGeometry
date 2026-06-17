# Blueprint Writer Report

## Slug
invpull

## Status
COMPLETE — all three required blocks added with `\lean{...}` pins, proof sketches, and verbatim Stacks citations.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
Added a new top-level section `\section{Pullback-monoidality: invertibility under a
general scheme morphism}` (`\label{sec:tensorobj_pullback_monoidality}`), inserted
AFTER all restriction-compatibility / stalk-tensor / invertibility-engine material
(after the `IsInvertible` definition `def:scheme_modules_isinvertible`, line ~2298,
so the `\uses` references resolve backward not forward) and immediately BEFORE the
untouched group-law carrier section `\section{The invertibility-carrier Picard
group}` (`sec:tensorobj_pic_carrier`). The group-law section was not modified.

Intro prose records the required distinction explicitly: `lem:tensorobj_restrict_iso`
handles only the OPEN-IMMERSION case via the lax RIGHT adjoint
(`pushforward`/`restrictScalars`), strong monoidal there only because an open
immersion's ring map is a local isomorphism; the general case uses the LEFT adjoint
(pullback = inverse image = extension of scalars), strong monoidal for ANY ring map,
which is why the general lemma is a separate result.

- **Added lemma** `\lemma`/`\label{lem:pullback_tensor_iso}`/`\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` — `f^*(M ⊗_X N) ≅ (f^*M) ⊗_Y (f^*N)` natural, for any scheme morphism `f` and arbitrary `M,N`.
  - Proof sketch added: Y. Mirrors `lem:tensorobj_restrict_iso` via the LEFT adjoint: (1) `sheafificationCompPullback` reduces to presheaf level; (2) presheaf pullback = sectionwise extension of scalars, strong monoidal via `(extendScalars f).Monoidal` (any ring map), tensorator `μ` sheafified gives the iso. Contrast with the right-adjoint open-immersion route spelled out.
  - `\uses{def:scheme_modules_tensorobj}`. Cited Stacks `lemma-tensor-product-pullback` (statement quote).
- **Added lemma** `\lemma`/`\label{lem:pullback_unit_iso}`/`\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` — `f^*𝒪_X ≅ 𝒪_Y`.
  - Proof sketch added: Y. Unit comparison `ε` of `(extendScalars f).Monoidal` (`R ⊗_R S ≅ S`) descends. Flags that the Mathlib morphism `SheafOfModules.pullbackObjUnitToUnit` is an iso for open immersions (finality, as in `IsLocallyTrivial.pullback`) but its general-`f` iso status must be checked separately, and the iso otherwise comes from the `extendScalars` unit comparison.
  - Archon-original (directive named no external source for this block) — no `% SOURCE` lines, per citation discipline.
- **Added lemma** `\lemma`/`\label{lem:isinvertible_pullback}`/`\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` — `IsInvertible M → IsInvertible (f^*M)`.
  - Proof sketch added: Y. Stacks proof in project notation: witness `f^*N`, iso `pullbackTensorIso.symm ≪≫ (pullback f).mapIso e ≪≫ pullbackUnitIso`.
  - `\uses{def:scheme_modules_isinvertible, lem:pullback_tensor_iso, lem:pullback_unit_iso}`. Cited Stacks `lemma-pullback-invertible` (statement quote + `% SOURCE QUOTE PROOF`).

## Cross-references introduced
- `\uses{def:scheme_modules_tensorobj}` in `lem:pullback_tensor_iso` and `lem:pullback_unit_iso` — `def:scheme_modules_tensorobj` exists in this chapter (line ~308).
- `\uses{def:scheme_modules_isinvertible, lem:pullback_tensor_iso, lem:pullback_unit_iso}` in `lem:isinvertible_pullback` — `def:scheme_modules_isinvertible` exists in this chapter (line ~2300, defined before the new section, so the reference is backward); the two `lem:pullback_*` targets are the two preceding new blocks.

## References consulted
- `references/stacks-modules.tex` — verbatim statement quote for `lem:pullback_tensor_iso` (Lemma `lemma-tensor-product-pullback`, L2392–2400); verbatim statement quote (L4142–4147) and `% SOURCE QUOTE PROOF` (L4149–4157) for `lem:isinvertible_pullback` (Lemma `lemma-pullback-invertible`).

## Macros needed (if any)
- None new. Used `\ggg` (amssymb, already available via leanblueprint) for the iso-composition restatement; all other commands (`\Scheme`, `\mathtt`, `\cref`, `\otimes_X`, `\mathcal`) already in use throughout the chapter.

## Reference-retriever dispatches (if any)
- None. The required source line ranges were already present in `references/stacks-modules.tex`.

## Notes for Plan Agent
- The new section is a top-level `\section` (chapter convention is `\section`-only; the directive said "subsection" but a `\subsection` placed there would nest under the prior `sec:tensorobj_invertibility` engine section, which reads worse than a clean standalone unit "separate from the group-law section"). If a `\subsection` is strictly desired, it can be demoted trivially.
- `lem:pullback_unit_iso` deliberately flags an open question for the prover: whether Mathlib's `SheafOfModules.pullbackObjUnitToUnit` is an iso for general `f`, or whether the iso must be sourced from the `extendScalars` unit comparison `ε`. The directive asked this be flagged rather than asserted; the prover should resolve it during formalization.
- Consumer re-base of `OnProduct` onto `IsInvertible` (the future `Picard_LineBundlePullback.tex` edit) is out of scope here and untouched, as directed.

## Strategy-modifying findings
None. The three lemmas are provable as stated and feed exactly the pullback-preservation fact the relative-Picard re-base (Route Y) requires; no strategy-level inconsistency surfaced.
