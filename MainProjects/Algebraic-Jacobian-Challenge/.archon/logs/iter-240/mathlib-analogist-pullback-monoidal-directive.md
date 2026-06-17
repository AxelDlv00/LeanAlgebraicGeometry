# Mathlib Analogist Directive

## Mode
cross-domain-inspiration

## Slug
pullback-monoidal

## Structural problem

We need to prove that the **inverse-image (pullback) functor on sheaves of
modules over a scheme is strong monoidal**. Concretely, for a morphism of
schemes `f : Y ⟶ X` and the pullback functor
`f^* : SheafOfModules(𝒪_X) ⥤ SheafOfModules(𝒪_Y)`, we need the two canonical
comparison maps to be **isomorphisms**:

1. `f^*(A ⊗ B) ≅ f^*A ⊗ f^*B`   (tensor comparison)
2. `f^*(𝟙_) ≅ 𝟙_`               (unit comparison: `f^*𝒪_X ≅ 𝒪_Y`)

The abstract obstruction: `f^*` is defined in Mathlib as a **left adjoint**
(`(pushforward f).leftAdjoint`); underlyingly the presheaf pullback
`PresheafOfModules.pullback φ` is also `(pushforward φ).leftAdjoint`, an abstract
left adjoint with **no sectionwise and no stalkwise value formula** in Mathlib at
the pinned commit. So "compute the value of `f^*` on a section and attach a
tensorator" does not typecheck — there is no concrete sectionwise functor to
attach a tensorator to.

The categorical core, stripped of geometry: **a left adjoint `L ⊣ R` where `R`
is lax monoidal (so `L` is oplax monoidal, giving comparison maps `L(A⊗B) →
LA⊗LB` and `L𝟙 → 𝟙` for free via `Adjunction.leftAdjointOplaxMonoidal`); we
need to prove these oplax comparison maps are ISOMORPHISMS** (i.e. `L` is strong
monoidal), in a setting where `L` has no explicit value formula but the ambient
categories are sheaf/presheaf categories with a "restrict to an open / take
stalk" family of conservative functors, and the comparison maps ARE
known-iso after restricting to suitable local charts.

## Failed approaches
- Sectionwise `(extendScalars f).Monoidal` tensorator: `extendScalars` is strong
  monoidal in `ModuleCat`, but it is never definitionally the value of the
  abstract presheaf-pullback left adjoint, so there is no sectionwise
  `(pullback φ).obj` to attach the `extendScalars` tensorator to. Structurally
  blocked.
- `Adjunction.leftAdjointOplaxMonoidal` gives the comparison MAP `δ` for free,
  but only at the PRESHEAF level (there is no `MonoidalCategory (SheafOfModules …)`
  in Mathlib). Proving `IsIso δ` via `isIso_of_isIso_app` reduces to a
  sectionwise identification of the abstract pullback with `extendScalars` = the
  same missing value formula.
- `SheafOfModules.pullbackObjUnitToUnit f` (the canonical `f^*𝒪_X → 𝒪_Y` map) is
  an iso only under `F.Final` (open immersions); FALSE for general `f`.

## What already WORKS in the project (the technique to generalize)
The project has an axiom-clean proof of `IsLocallyTrivial.pullback`
(`AlgebraicJacobian/Picard/LineBundlePullback.lean:156-193`): for general `f`,
pullback preserves "locally `≅ 𝒪`". Its mechanism is **local-chart finality**:
for a point `y`, pick an affine chart `V ⊆ Y`, factor `V.ι ≫ f` through a local
map `g = f.resLE U V` whose `Opens.map g.base` is `Final` (via
`final_of_representablyFlat`), and then `pullbackObjUnitToUnit g` IS an iso
because `g` is "final". The global comparison map, restricted to `V`, is
identified with the local `pullbackObjUnitToUnit g` through the naturality of
`restrictFunctorIsoPullback` / `pullbackComp` / `pullbackCongr`. The project
also has `isIso_of_isIso_restrict`
(`AlgebraicJacobian/Picard/TensorObjSubstrate.lean:567`, axiom-clean): a
`Scheme.Modules` morphism that is an iso after restricting to every chart of an
open cover is a global iso (stalkwise route).

So the SHAPE that works is: **(comparison map iso) ⟸ (comparison map iso on
every local chart) ⟸ (on a chart, the restricted map equals the local map for a
FINAL morphism, which is iso by the finality instance)**. The missing pieces are
the NATURALITY lemmas tying the restricted global comparison map to the local
one (`pullbackObjUnitToUnit` vs `pullbackComp`/`restrictFunctorIsoPullback`), and
the analogous chain for the TENSOR comparison (where no canonical sheaf-level
comparison map even exists yet — only the presheaf oplax `δ`).

## Search radius
narrow

(Stay within category theory / algebraic geometry / topos theory, but cross
sub-areas. The analogue is likely "one shelf over": some other place in Mathlib
where a left adjoint / inverse-image functor is shown strong monoidal, or where
an oplax-monoidal comparison map is proven iso by reduction to local/stalk
charts, or where pullback of sheaves is shown to commute with tensor.)

## Hints (use sparingly — find what we can't)
Concretely answer, if you can, these three questions (each with a real
`Mathlib.X.Y` path + line citation, verified via the LSP — do NOT allude):
1. Does Mathlib ANYWHERE prove that an inverse-image / pullback functor (of
   sheaves of modules, quasi-coherent sheaves, presheaves of modules, or
   sheaves of abelian groups) commutes with the tensor product, or is strong
   monoidal? Search `PresheafOfModules`, `SheafOfModules`, `QuasicoherentSheaf`,
   and the `CategoryTheory.Sites` pullback/inverse-image API.
2. Is there a Mathlib lemma proving an `Adjunction.leftAdjointOplaxMonoidal`
   comparison map (or `OplaxMonoidalFunctor`/`Functor.OplaxMonoidal` unit/tensor
   comparison) is an iso under some hypothesis — i.e. a packaged "oplax ⇒ strong
   under condition X" result we could instantiate?
3. Is there a precedent for proving a sheaf-morphism is an iso by reduction to a
   FINAL covering functor (the `pullbackObjUnitToUnit` is-iso-when-Final pattern
   already used in `IsLocallyTrivial.pullback`) — i.e. a general
   "iso-after-restriction-to-each-of-a-final-cover ⇒ iso" lemma, OR the relevant
   naturality lemmas for `pullbackComp` / `restrictFunctorIsoPullback` /
   `pullbackObjUnitToUnit` that the local-chart route needs?

The deliverable that helps most: a ranked list of concrete techniques (with
citations) for proving the tensor + unit pullback comparison maps are isos,
ordered by porting cost, PLUS an honest "Mathlib has nothing; the project must
build the naturality cluster from scratch (NEEDS_MATHLIB_GAP_FILL)" if that is
the truth.
