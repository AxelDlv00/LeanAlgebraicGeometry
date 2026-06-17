# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
pullback-monoidal

## Iteration
240

## Structural problem
A left adjoint `L ⊣ R` between (pre)sheaf-of-modules categories — here
`L = f^* = (pushforward f).leftAdjoint` — with no sectionwise/stalkwise value
formula, where we must prove the two oplax-monoidal comparison maps
`L(A⊗B) → LA⊗LB` and `L𝟙 → 𝟙` are isomorphisms (strong monoidality), in a
setting with a conservative "restrict to a local chart" family and comparison
maps that are known-iso after restricting to charts where the comparison
functor is `Final`.

## Direct answers to the three directive questions

**Q1 — Does Mathlib prove any inverse-image of modules/sheaves commutes with ⊗
(is strong monoidal)? NO.**
- `PresheafOfModules.pullback` (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`)
  ships only composition coherence — `pullbackId`, `pullbackComp`,
  `pullback_assoc`, `pullbackPushforwardAdjunction` — and **no tensorator** (no
  `μ`, no `OplaxMonoidal`/`Monoidal` instance).
- `SheafOfModules.pullback` (`…Sheaf.PullbackContinuous`) likewise has no
  monoidal instance.
- The abstract `CategoryTheory.Sheaf.monoidalCategory` and strong-monoidal
  sheafification `CategoryTheory.Sheaf.instMonoidalFunctorOppositePresheafToSheaf`
  (`Mathlib.CategoryTheory.Sites.Monoidal`) exist, but only for `Sheaf J A` over
  a **fixed** monoidal `A` — not `SheafOfModules R` (varying module structure).
  So the directive's "no `MonoidalCategory (SheafOfModules …)`" stands.

**Q2 — Is there a packaged "oplax ⇒ strong under condition X"? YES.**
- `CategoryTheory.Functor.CoreMonoidal.ofOplaxMonoidal`
  (`Mathlib.CategoryTheory.Monoidal.Functor`): given `F.OplaxMonoidal`,
  `[IsIso (OplaxMonoidal.η F)]`, `[∀ X Y, IsIso (OplaxMonoidal.δ F X Y)]`,
  yields `F.CoreMonoidal` (⇒ `F.Monoidal`). Companions
  `ofOplaxMonoidal_εIso` / `ofOplaxMonoidal_μIso` give the inverse comparison
  isos `(asIso η).symm`, `(asIso (δ X Y)).symm`.
- **Correction:** the directive's `Adjunction.leftAdjointOplaxMonoidal` does NOT
  exist. Mathlib ships only `CategoryTheory.Adjunction.rightAdjointLaxMonoidal`
  (same module): `F ⊣ G`, `[F.OplaxMonoidal]` ⇒ `G.LaxMonoidal` (left-oplax ⇒
  right-lax — the OPPOSITE direction). So `δ, η` on `pullback` are **not free**;
  the `OplaxMonoidal` structure on the left adjoint must be built first.
- (`Functor.OplaxMonoidal.instIsIsoδ` in `…Monoidal.Cartesian.Basic` makes δ iso
  for `PreservesFiniteProducts` functors, but modules' ⊗ is not cartesian —
  inapplicable.)

**Q3 — Precedent for iso-by-reduction-to-a-Final-cover? YES, partially.**
- The UNIT comparison's is-iso-when-Final is a Mathlib instance:
  `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`).
- The naturality glue (`pullbackComp`, `pullbackId`, `pullback_assoc`,
  `restrictFunctorIsoPullback`, `pullbackCongr`) exists and is already wired in
  the project's axiom-clean `IsLocallyTrivial.pullback`
  (`AlgebraicJacobian/Picard/LineBundlePullback.lean:156-193`, the `i1…i7`
  chain) together with `isIso_of_isIso_restrict`
  (`…/Picard/TensorObjSubstrate.lean:567`).
- There is **no** Mathlib `pullbackObjTensorToTensor` analogue for the TENSOR
  comparison — that naturality cluster is the genuine gap to build.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Functor.CoreMonoidal.ofOplaxMonoidal` (`…Monoidal.Functor`) | category theory | medium | ANALOGUE_FOUND |
| `instIsIsoPullbackObjUnitToUnitOfFinal` + proven `IsLocallyTrivial.pullback` chart-chase | alg geom / sites | low (unit) | ANALOGUE_FOUND (unit) / PARTIAL (tensor) |
| `Sheaf.monoidalCategory` / `instMonoidalFunctorOppositePresheafToSheaf` (`…Sites.Monoidal`) | topos / sites | high | PARTIAL_ANALOGUE |

## Top suggestion
Run it in two phases and do not chase abstract strong-monoidality first.

**Phase 1 (cheap):** the unit comparison `f^*𝟙 ≅ 𝟙` is reachable today — it is
literally the `i7 = asIso (SheafOfModules.pullbackObjUnitToUnit g)` step already
proven inside `IsLocallyTrivial.pullback`. Lift the same affine-chart-finality
glue (`f.resLE`, `final_of_representablyFlat`, the `pullbackComp` /
`restrictFunctorIsoPullback` naturality) and globalize with the project's
`isIso_of_isIso_restrict`. First file to touch: `LineBundlePullback.lean` (reuse
its imports/lemmas) or a sibling `PullbackMonoidal.lean`.

**Phase 2 (the real gap, NEEDS_MATHLIB_GAP_FILL):** the tensor comparison has no
Mathlib tensorator on `pullback`. Build a `pullbackObjTensorToTensor` analogue of
`pullbackObjUnitToUnit`, prove it iso by the SAME finality chart-chase (on a
Final chart the pullback is locally extension-of-scalars, which is strong
monoidal in `ModuleCat`), then feed `IsIso η` + `∀ IsIso δ` into
`Functor.CoreMonoidal.ofOplaxMonoidal` to obtain the packaged strong-monoidal
structure, with `μIso`/`εIso` delivering the two inverse comparison isos. Read
`Mathlib.CategoryTheory.Monoidal.Functor` (`ofOplaxMonoidal`, `μIso`, `εIso`,
`rightAdjointLaxMonoidal`) and `…Sheaf.PullbackFree` (`pullbackObjUnitToUnit` +
its Final instance) as the templates. Note that producing
`(pullback).OplaxMonoidal` at all is itself non-free (no `leftAdjointOplaxMonoidal`);
expect to construct it as the mate of `pushforward`'s lax structure or from the
presheaf pullback's concrete extension-of-scalars description.

## Discarded
- `Functor.OplaxMonoidal.instIsIsoδ` (cartesian / `PreservesFiniteProducts`):
  modules' ⊗ is not cartesian monoidal.
- `Adjunction.rightAdjointLaxMonoidal` as a comparison-map source: wrong
  direction (gives the right adjoint lax, not the left adjoint oplax) — using it
  would require already knowing `pullback` is oplax, i.e. the thing we need.

## Persistent file
- `analogies/pullback-monoidal.md` — analogue list + directive correction captured for future iters.

Overall verdict: Mathlib has the oplax⇒strong PACKAGER (`CoreMonoidal.ofOplaxMonoidal`) and the unit-comparison Final-iso instance, but NO pullback tensorator and NO left-oplax-from-right-lax transfer — the unit half is a low-cost port of the proven `IsLocallyTrivial.pullback` chart-chase, the tensor half is a genuine NEEDS_MATHLIB_GAP_FILL.
