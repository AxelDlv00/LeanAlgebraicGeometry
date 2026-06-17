/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Higher direct images `Rⁱ f_*` of quasi-coherent sheaves (`i ≥ 1`)

This file treats the higher derived direct images `Rⁱ f_* F` for `i ≥ 1`,
complementing the `i = 0` (direct-image) case of `Cohomology/FlatBaseChange.lean`.

Throughout, `f : X ⟶ S` is a morphism of schemes and `F : X.Modules` a sheaf of
modules on `X`. The `i`-th higher direct image `Rⁱ f_* F` is the `i`-th right
derived functor of the pushforward functor `f_*` applied to `F`.

The four main declarations are:

* `AlgebraicGeometry.higherDirectImage` — the higher direct image `Rⁱ f_* F`.
* `AlgebraicGeometry.higherDirectImage_isQuasiCoherent` — `Rⁱ f_* F` is
  quasi-coherent when `f` is quasi-compact and quasi-separated.
* `AlgebraicGeometry.higherDirectImage_affine_eq_zero` — `Rⁱ f_* F = 0` for
  `i ≥ 1` when `f` is affine.
* `AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso` — flat base change
  for the higher direct images (`i ≥ 1` case).

See `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`.

Source: Stacks Project, Cohomology of Schemes, Tags 02KE (quasi-coherence of
higher direct images), 02KG (relative affine vanishing), 02KH (flat base change).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {S S' X X' : Scheme.{u}}

/-- The `i`-th higher direct image `Rⁱ f_* F` of a sheaf of modules `F` on `X`
along a morphism `f : X ⟶ S`, defined as the `i`-th right derived functor of the
pushforward functor `f_*` applied to `F`.

For `i = 0` this recovers the ordinary pushforward `R⁰ f_* F = f_* F`.

Source: Stacks Project, Cohomology of Schemes, Definition of `Rⁱ f_*`. -/
noncomputable def higherDirectImage [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) (i : ℕ) (F : X.Modules) : S.Modules :=
  ((pushforward f).rightDerived i).obj F

/-- **Quasi-coherence of higher direct images** (Stacks 02KE, part (1)).
If `f : X ⟶ S` is quasi-compact and quasi-separated and `F` is a quasi-coherent
`O_X`-module, then `Rⁱ f_* F` is a quasi-coherent `O_S`-module for every `i`.

The proof (Stacks 02KE) is local on `S`, reducing to `S` affine; one then runs the
induction principle for quasi-compact opens of the quasi-compact quasi-separated
`X`: the affine base case uses relative affine vanishing
(`higherDirectImage_affine_eq_zero`) together with quasi-coherence of `f_*` for
the `i = 0` part, and the inductive step uses the relative Mayer–Vietoris
sequence, whose terms are quasi-coherent.

Source: Stacks Project, Tag 02KE ("Quasi-coherence of higher direct images"). -/
theorem higherDirectImage_isQuasiCoherent [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [QuasiSeparated f] (i : ℕ) (F : X.Modules)
    (hF : F.IsQuasicoherent) :
    (higherDirectImage f i F).IsQuasicoherent := by
  -- Proof (Stacks 02KE) via the induction principle for q.c. opens of the q.c.q.s.
  -- scheme `X`, using relative affine vanishing in the affine base case and the
  -- relative Mayer–Vietoris sequence in the inductive step.  Needs the explicit
  -- description of `Rⁱ f_*` as the sheafification of `V ↦ Hⁱ(f⁻¹ V, F|…)` and the
  -- Mayer–Vietoris infrastructure, both currently absent from Mathlib.
  sorry

/-- **Relative affine vanishing** (Stacks 02KG).
If `f : X ⟶ S` is an affine morphism and `F` is a quasi-coherent `O_X`-module,
then `Rⁱ f_* F = 0` for all `i ≥ 1`.

The proof (Stacks 02KG): `Rⁱ f_* F` is the sheafification of
`V ↦ Hⁱ(f⁻¹ V, F|_{f⁻¹ V})`; for `V` affine, `f⁻¹ V` is affine (as `f` is affine),
so the higher cohomology of the quasi-coherent `F|_{f⁻¹ V}` vanishes. As the affine
opens form a basis of `S`, the sheafification of a presheaf vanishing on a basis is
zero.

Source: Stacks Project, Tag 02KG ("Relative affine vanishing"). -/
theorem higherDirectImage_affine_eq_zero [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [IsAffineHom f] (i : ℕ) (hi : 1 ≤ i) (F : X.Modules)
    (hF : F.IsQuasicoherent) :
    IsZero (higherDirectImage f i F) := by
  -- Proof (Stacks 02KG): on affine opens `V ⊆ S` the preimage `f⁻¹ V` is affine,
  -- so `Hⁱ(f⁻¹ V, F|…) = 0` for `i ≥ 1` (vanishing of higher cohomology of a
  -- quasi-coherent sheaf on an affine scheme), hence the defining presheaf of
  -- `Rⁱ f_* F` vanishes on a basis and its sheafification is zero.  Needs the
  -- explicit `V ↦ Hⁱ(f⁻¹ V, F|…)` description and affine-cohomology vanishing,
  -- both currently absent from Mathlib for `Scheme.Modules`.
  sorry

/-- **Flat base change for the higher direct images** (Stacks 02KH, `i ≥ 1` case).
Given a cartesian square
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
with `F` a quasi-coherent `O_X`-module, `g` flat and `f` quasi-compact and
quasi-separated, the canonical base-change map is an isomorphism
```
  g^*(Rⁱ f_* F) ≅ Rⁱ f'_* ((g')^* F)
```
for every `i ≥ 1`.

The proof (Stacks 02KH) reduces to `S = Spec A`, `S' = Spec B` with `A → B` flat;
by quasi-coherence (`higherDirectImage_isQuasiCoherent`) the two sides correspond
to the `A`-module `Hⁱ(X, F)` and the `B`-module `Hⁱ(X_B, F_B)`, and one shows
`Hⁱ(X, F) ⊗_A B ≅ Hⁱ(X_B, F_B)` via base change of a Čech complex (separated case)
and the Čech-to-cohomology spectral sequence (quasi-separated case), using flatness
of `A → B`.

We state the isomorphism as `Nonempty (… ≅ …)`: the canonical higher base-change
map (the `i ≥ 1` analogue of `pushforwardBaseChangeMap`) is not yet constructed.

Source: Stacks Project, Tag 02KH ("Flat base change"), the `i ≥ 1` case. -/
theorem flatBaseChange_higherDirectImage_isIso
    [HasInjectiveResolutions X.Modules] [HasInjectiveResolutions X'.Modules]
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f]
    (i : ℕ) (F : X.Modules) (hF : F.IsQuasicoherent) :
    Nonempty ((Scheme.Modules.pullback g).obj (higherDirectImage f i F) ≅
      higherDirectImage f' i ((Scheme.Modules.pullback g').obj F)) := by
  -- Proof (Stacks 02KH): local on `S'`, reduce to `S = Spec A`, `S' = Spec B`,
  -- `A → B` flat.  By quasi-coherence the two higher direct images are the
  -- tilde-modules of `Hⁱ(X, F)` and `Hⁱ(X_B, F_B)`, and pullback along `g`
  -- corresponds to `- ⊗_A B`; the comparison `Hⁱ(X, F) ⊗_A B ≅ Hⁱ(X_B, F_B)`
  -- follows from base change of the Čech complex (separated case) and the
  -- Čech-to-cohomology spectral sequence (q.s. case), using flatness.  Needs the
  -- Čech-cohomology / spectral-sequence infrastructure for `Scheme.Modules`,
  -- currently absent from Mathlib.
  sorry

end AlgebraicGeometry
