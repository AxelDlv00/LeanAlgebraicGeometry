# mathlib-analogist ana258-d3

## Mode: cross-domain-inspiration

## Structural problem
We have an oplax-monoidal comparison map δ (the "tensorator") for a left adjoint
`pullback φ : PresheafOfModules R_X ⥤ PresheafOfModules R_Y` (a `leftAdjointOplaxMonoidal`),
built via `Functor.OplaxMonoidal`. We need the **monoidality of the composite-of-left-adjoints
natural iso** `PresheafOfModules.pullbackComp`:
```
pullbackComp φ ψ : pullback φ ⋙ pullback ψ  ≅  pullback (F:=F⋙G) (φ ≫ whiskerLeft F.op ψ)
```
Concretely: that this connecting iso intertwines the oplax δ on the single composite pullback with
the composite oplax δ (`G.map (δ F) ≫ δ G`) on `pullback φ ⋙ pullback ψ` — i.e.
`δ(pullback φ_{h≫f}) = pullbackComp.inv ≫ δ(comp) ≫ (pullbackComp.hom ⊗ pullbackComp.hom)`.
This is "Sq2b" in our 4-square proof of `pullbackTensorMap_restrict` (D3′), the comparison-iso
naturality on line bundles.

## Failed approaches (last 2 iters, all on `Picard/TensorObjSubstrate.lean`)
- iter-256: the "mirror `pullbackObjUnitToUnit_comp`" recipe — DISPROVEN: `pullbackTensorMap` is a
  hand-built 4-fold composite, NOT an adjunction transpose, so there is no `homEquiv` bridge.
- iter-257: tried to STATE the `pullbackComp`-monoidality lemma directly. Three frictions blocked even
  the statement: (1) `Functor.OplaxMonoidal.δ (pullback φ')` leaves the CommRingCat/`forget₂`
  `MonoidalCategory`-instance metavars STUCK (needs the D1′ `let φ' : …⋙forget₂…`/`show…from`
  canonical-spelling device); (2) `pullbackComp` pins `(F:=Opens.map f.base ⋙ Opens.map h.base)` with
  morphism `φ_f ≫ whiskerLeft φ_h`, and unifying a standalone δ's `pullback` against that codomain stalls
  on higher-order unification through the `(F⋙G).op⋙T = F.op⋙(G.op⋙T)` associativity defeq;
  (3) the ring-map reconciliation `(toRingCatSheafHom (h≫f)).hom = φ_f ≫ whiskerLeft φ_h` is `rfl` but does
  NOT fire during the `≫`/`.app` connecting-object unification even with `respectTransparency false`.
- Negative Mathlib search: `Adjunction.leftAdjointOplaxMonoidal_δ` (transport lemma) does not exist;
  no lemma for the δ-transport of `Adjunction.leftAdjointCompIso`/`pullbackComp`.

## What we already know is the template
`CategoryTheory.Adjunction.isMonoidal_comp` (`Mathlib/CategoryTheory/Monoidal/Functor.lean` ~L990):
its `leftAdjoint_μ` proof already uses `comp_δ` + `δ_natural` + `tensorHom_comp_tensorHom` via the mate
calculus. We want to know how to PORT that mate-calculus pattern to our `pullbackComp` setting.

## Search radius: narrow
(same area — monoidal/adjunction mate calculus in Mathlib category theory).

## What I need
A ranked list of Mathlib precedents where the **monoidality of a composite/connecting natural iso of
(op)lax-monoidal adjoint functors** is proved by mate calculus — with the citation (file:line), the exact
technique (which mate lemmas / `conjugateEquiv` / `IsMonoidal` packaging), and a concrete porting
suggestion for our `pullbackComp` Sq2b: in particular whether to (a) package `pullback φ` as a bundled
`Functor.OplaxMonoidal`/`Monoidal` and use `isMonoidal_comp`'s machinery wholesale, vs (b) prove the
δ-transport equation by hand via `conjugateEquiv_pullbackComp_inv` (the project mate bridge, Sheaf.lean:238)
+ `comp_δ` + `δ_natural`. Also: is there a cleaner Mathlib idiom that AVOIDS the `forget₂` monoidal-instance
pin friction entirely (e.g. proving monoidality at PresheafOfModules level before forget₂)?

GOAL: decide whether D3′ Sq2b is dispatchable to a prover THIS iter with a concrete recipe, or whether it
needs a structural refactor first. Confirm Mathlib names via the LSP; flag `[unconfirmed]` otherwise.
Write rationale to `analogies/d3sq2b258.md` + report to task_results.
