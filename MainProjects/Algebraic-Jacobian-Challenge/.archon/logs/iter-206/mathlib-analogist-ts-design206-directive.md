# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
ts-design206

## Design question
To equip the relative Picard functor with its abelian-group structure
(`AddCommGroup` on `Pic(C ×_S T) / π_T^* Pic(T)`, i.e. the group law
"tensor product of line bundles"), the project is building the FULL
symmetric monoidal category structure on `Scheme.Modules X` (all
quasi-coherent modules), realised as `sheafification ∘
PresheafOfModules.Monoidal.tensorObj`. Closing that monoidal-category
instance has bottomed out in a verified-absent Mathlib instance
`MonoidalClosed (PresheafOfModules R₀)` (the relative module tensor over a
*varying* base ring), needed only to prove that sheafification inverts
`F ◁ g` (the `whiskerLeft` stability of the localizing morphism property).

**Is building the full `MonoidalCategory (Scheme.Modules X)` the right
Mathlib-aligned shape for obtaining only the group law on LINE BUNDLES
(invertible/locally-free-rank-1 sheaves), or does Mathlib have a lighter
idiom — a Picard group of invertible sheaves, the group of invertible
objects (`≅`-units) of a monoidal category, invertible-module units, etc.
— that yields the `AddCommGroup` (= `CommGroup` written additively) on
line-bundle iso-classes WITHOUT requiring the full monoidal (let alone
monoidal-closed) structure on all modules?**

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:113–150 —
  `Scheme.Modules.tensorObj` (= `sheafification ∘ presheaf tensorObj`) and
  the `monoidalCategory` instance (L150, `:= sorry`).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:277–342 —
  `tensorObj_isLocallyTrivial`, `exists_tensorObj_inverse`,
  `addCommGroup_via_tensorObj` (L339) — the group-law cone whose terminal
  target is the `AddCommGroup`.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:411–453 —
  `isMonoidal_W_of_whiskerLeft`, `monoidalCategoryOfIsMonoidalW` (the
  localization-transport infra that reduces the cone to `whiskerLeft`).
- `AlgebraicJacobian/Picard/RelPicFunctor.lean`:235 — the `addCommGroup`
  sorry this cone is meant to discharge (the relative Picard quotient group).

## Why now
Three consecutive net-0-sorry TS iters (−2, 0, 0); the lane has reached a
multi-file Mathlib infrastructure boundary (`MonoidalClosed
(PresheafOfModules R₀)`, verified absent) identical in class to the
blocker that paused the COE lane. Before committing a multi-file
Mathlib-PR-scale sub-lane to build that closed structure, I need to know
whether the project is over-building: the group law it actually needs is
just "tensor of two line bundles is a line bundle, with inverses" — a
`CommGroup` on Pic — which classically needs far less than a full
monoidal-closed category on all quasi-coherent modules.

## Hints (optional)
- Mathlib namespaces likely relevant: `CategoryTheory.Monoidal` (units /
  invertible objects — is there a `Monoidal....Grp` of `≅`-invertible
  objects?), `AlgebraicGeometry` Picard-group material if any,
  `Mathlib.Algebra.Category.ModuleCat.{Sheaf,Presheaf}`, invertible-module
  / `Module.Picard` if it exists, `CategoryTheory.Localization.Monoidal`,
  `CategoryTheory.Sites.Monoidal` (`J.W.IsMonoidal` — ambient `⊗_ℤ`, NOT
  the relative tensor, already a dead-end).
- The line-bundle tensor preserves locally-trivial-rank-1 LOCALLY (where
  both are trivial), which `tensorObj_isLocallyTrivial` already proves
  modulo `tensorObj_restrict_iso`. The question is whether the
  group-of-invertibles can be assembled from that local fact directly,
  bypassing the global `MonoidalCategory` instance.
- Already-exhausted dead-ends (do NOT recommend): `Sites/Monoidal.lean`'s
  `J.W.IsMonoidal` (wrong tensor); sectionwise presheaf-pullback
  strong-monoidal (absent); elementwise exactness (needs flatness).

## Severity expectation
high-stakes
