/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.HigherDirectImage

/-!
# Čech computation of the higher direct images `Rⁱ f_*` (unconditional)

This file constructs the higher derived direct images `Rⁱ f_* F` for `i ≥ 1`
**without appealing to injective resolutions** in the category of sheaves of
modules. The companion `Cohomology/HigherDirectImage.lean` defines `Rⁱ f_*` as a
right derived functor, which requires the ambient category of `O_X`-modules to
have enough injectives — a property not currently available for sheaves of
modules over a sheaf of rings whose value category varies over the site. The
Čech approach developed here sidesteps the issue: it computes `Rⁱ f_* F` as the
cohomology of an explicit complex built from the pushforwards of `F` over the
finite intersections of an affine open cover, producing an **unconditional**
construction of `Rⁱ f_*` for quasi-coherent `F` and separated quasi-compact `f`.

Throughout, `f : X ⟶ S` is a quasi-compact, separated morphism of schemes (so
all finite intersections of an affine open cover of `X` are again affine), and
`F : X.Modules` is a quasi-coherent `O_X`-module. A base change of `f` along
`g : S' ⟶ S` is recorded by a cartesian square
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
with `F' = (g')^* F` the pullback of `F` to `X'`.

The six main declarations are:

* `AlgebraicGeometry.CechNerve` — the (augmented) Čech nerve of an affine open
  cover, an augmented cosimplicial object of `O_X`-modules.
* `AlgebraicGeometry.CechComplex` — the relative Čech complex in `QCoh(S)`, a
  cochain complex of `O_S`-modules whose degree-`p` term is the product of the
  pushforwards of `F` over the `(p+1)`-fold intersections of the cover.
* `AlgebraicGeometry.CechAcyclic.affine` — Čech acyclicity on affines: the Čech
  complex of a standard cover of an affine scheme has vanishing cohomology in
  all positive degrees (Serre vanishing for quasi-coherent sheaves on affines).
* `AlgebraicGeometry.cech_computes_higherDirectImage` — the cohomology of the
  relative Čech complex is canonically isomorphic to `Rⁱ f_* F` wherever the
  derived functor is defined.
* `AlgebraicGeometry.cechHigherDirectImage` — the **unconditional** `i`-th higher
  direct image, defined as the `i`-th cohomology sheaf of the relative Čech
  complex (no enough-injectives hypothesis required).
* `AlgebraicGeometry.cech_flatBaseChange` — flat base change for the
  unconditional Čech higher direct images.

See `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

Source: Stacks Project, Cohomology of Schemes, §Čech cohomology of quasi-coherent
sheaves and §Quasi-coherence of higher direct images; Tags 02KE
(`lemma-cech-cohomology-quasi-coherent`), 02KG
(`lemma-quasi-coherent-affine-cohomology-zero`), 02KH
(`lemma-flat-base-change-cohomology`).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {S S' X X' : Scheme.{u}}

/-- **Čech nerve of an affine open cover** (Stacks, Cohomology of Schemes, §Čech
cohomology of quasi-coherent sheaves).

For a scheme `X`, a finite affine open cover `𝒰 : X = ⋃ Uᵢ` and a quasi-coherent
sheaf `F`, the *Čech nerve* is the augmented cosimplicial object of
`O_X`-modules whose object in simplicial degree `p` is the product, over the
`(p+1)`-tuples `(i₀,…,i_p)` of indices, of the direct images
`(j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})` of the restriction of `F` to the
`(p+1)`-fold intersection `U_{i₀…i_p} = U_{i₀} ∩ ⋯ ∩ U_{i_p}` along the open
immersion `j_{i₀…i_p} : U_{i₀…i_p} ↪ X`. Faces are the restriction maps that
omit one index, degeneracies repeat one index, and the augmentation in degree
`-1` is `F` itself on all of `X`. When `X` is separated each intersection
`U_{i₀…i_p}` is affine.

Source: Stacks Project, Cohomology of Schemes,
`lemma-cech-cohomology-quasi-coherent-trivial`. -/
noncomputable def CechNerve (𝒰 : X.OpenCover) (F : X.Modules) :
    CosimplicialObject.Augmented X.Modules :=
  -- Construction (Stacks): the augmented cosimplicial object
  -- `[p] ↦ ∏_{(i₀,…,i_p)} (j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})` with faces the
  -- index-omitting restriction maps, degeneracies the index-repeating maps, and
  -- augmentation `F`. Requires the nerve of the cover (intersection products of
  -- pushforwards) as a functor out of `SimplexCategory`, currently absent from
  -- Mathlib for `Scheme.Modules`.
  sorry

/-- **Relative Čech complex of a quasi-coherent sheaf** (Stacks, Cohomology of
Schemes, `lemma-cech-cohomology-quasi-coherent-trivial`).

For `f : X ⟶ S`, a finite affine open cover `𝒰` of `X` (with all intersections
affine, e.g. `X` separated) and a quasi-coherent sheaf `F`, the *relative Čech
complex* `Č•(𝒰, F)` is the cochain complex of `O_S`-modules with degree-`p` term
```
  Čᵖ(𝒰, F) = ∏_{(i₀,…,i_p)} (f|_{U_{i₀…i_p}})_* (F|_{U_{i₀…i_p}}),
```
and differential the alternating sum of the restriction maps
`(d s)_{i₀…i_{p+1}} = Σⱼ (-1)ʲ s_{i₀…î_j…i_{p+1}}|_{U_{i₀…i_{p+1}}}`. Over an
affine `U = Spec A` with `F|_U = M~` and a standard cover by the `D(fᵢ)`, this is
the complex of localisations `∏ M_{f_{i₀}} → ∏ M_{f_{i₀}f_{i₁}} → ⋯`. Each term
is quasi-coherent because the intersections are affine and the pushforward of a
quasi-coherent sheaf along a quasi-compact quasi-separated morphism is
quasi-coherent.

Source: Stacks Project, Cohomology of Schemes,
`lemma-cech-cohomology-quasi-coherent-trivial`. -/
noncomputable def CechComplex (f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) :
    CochainComplex S.Modules ℕ :=
  -- Construction (Stacks): the cochain complex obtained by applying the relative
  -- pushforward `f_*` over each finite intersection to the Čech nerve
  -- `CechNerve 𝒰 F`, with the alternating-sum Čech differential. Requires the
  -- nerve together with the alternating-sum face map assembled into a
  -- `CochainComplex`, currently absent from Mathlib for `Scheme.Modules`.
  sorry

/-- **Čech acyclicity on affines** (Stacks 02KG;
`lemma-cech-cohomology-quasi-coherent-trivial` and
`lemma-quasi-coherent-affine-cohomology-zero`).

Let `X = Spec A` be affine, `F` a quasi-coherent `O_X`-module, and `𝒰` a finite
standard open cover (the `fᵢ ∈ A` generate the unit ideal). Then the relative
Čech complex (here with `f` an affine morphism) has vanishing cohomology in all
positive degrees: `Hᵖ = 0` for `p ≥ 1`, equivalently `Hᵖ(X, F) = 0` for `p > 0`
(Serre vanishing for quasi-coherent sheaves on affines).

The proof (Stacks): write `F|_X = M~`; the Čech complex of the standard cover is
the complex of localisations, and `Hᵖ = 0` for `p > 0` is equivalent to exactness
of the extended complex `0 → M → ∏ M_{f_{i₀}} → ⋯`. Exactness is checked after
localising at an arbitrary prime `𝔭`; choosing `i_fix` with `f_{i_fix} ∉ 𝔭`, the
prescription `h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}` is a contracting homotopy, so the
localised complex is exact, hence so is the complex. The Čech-to-cohomology
comparison on the basis of affine opens then gives the sheaf statement. -/
theorem CechAcyclic.affine [IsAffine X] (f : X ⟶ S) [IsAffineHom f]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) :
    IsZero ((CechComplex f 𝒰 F).homology p) := by
  -- Proof (Stacks 02KG): on the affine `X = Spec A` the Čech complex of the
  -- standard cover is the complex of localisations; positive-degree exactness
  -- follows from the prime-local contracting homotopy `h(s)_{i₀…i_p} =
  -- s_{i_fix i₀…i_p}` (where `f_{i_fix} ∉ 𝔭`), giving `(dh + hd) = id`. Needs the
  -- explicit localisation description of `CechComplex` on affines and the
  -- module-level homotopy, currently absent from Mathlib for `Scheme.Modules`.
  sorry

/-- **The Čech complex computes the higher direct images** (Stacks 02KE;
`lemma-cech-cohomology-quasi-coherent` and
`lemma-quasi-coherence-higher-direct-images-application`).

Let `f : X ⟶ S` be separated and quasi-compact, `F` a quasi-coherent
`O_X`-module, and `𝒰` a finite affine open cover of `X` (so, by separatedness,
every intersection is affine). Then the cohomology sheaves of the relative Čech
complex compute the higher direct images: for every `i ≥ 0` there is a canonical
isomorphism of `O_S`-modules
```
  Hⁱ(Č•(𝒰, F)) ≅ Rⁱ f_* F.
```
In particular, over an affine base `S = Spec A`, taking global sections gives
`Hⁱ(X, F) = Čⁱ(𝒰, F) = H⁰(S, Rⁱ f_* F)` as `A`-modules.

We state the isomorphism as `Nonempty (… ≅ …)` and compare against the
derived-functor higher direct image `higherDirectImage` wherever the latter is
defined (`HasInjectiveResolutions X.Modules`).

The proof (Stacks 02KE): the question is local on `S`, reducing to `S` affine; by
affine acyclicity (`CechAcyclic.affine`) the higher cohomology of `F` over each
affine intersection vanishes, so the Čech-to-cohomology spectral sequence
collapses to its `q = 0` row, identifying Čech cohomology with sheaf cohomology;
over affine `S` the Leray spectral sequence then degenerates (Serre vanishing for
the quasi-coherent `Rⁱ f_* F`), giving the stated isomorphism. -/
theorem cech_computes_higherDirectImage [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F) := by
  -- Proof (Stacks 02KE): reduce to `S` affine; affine acyclicity
  -- (`CechAcyclic.affine`) collapses the Čech-to-cohomology spectral sequence to
  -- its `q = 0` row, and the Leray spectral sequence degenerates by Serre
  -- vanishing for the quasi-coherent `Rⁱ f_* F`, yielding the comparison iso.
  -- Needs the two spectral sequences for `Scheme.Modules`, currently absent from
  -- Mathlib.
  sorry

/-- **The unconditional higher direct image via Čech** (Stacks
`lemma-quasi-coherence-higher-direct-images-application`; unconditional packaging
is Archon-original).

For `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent and a finite affine
open cover `𝒰` of `X`, the *(unconditional) `i`-th higher direct image* is the
`i`-th cohomology sheaf of the relative Čech complex,
```
  Rⁱ f_* F := Hⁱ(Č•(𝒰, F)) ∈ QCoh(S).
```
This requires **no** enough-injectives hypothesis: the right-hand side is the
cohomology of an explicit complex of quasi-coherent sheaves. By
`cech_computes_higherDirectImage` it agrees with the derived-functor higher
direct image wherever the latter is defined, and is independent of the chosen
affine cover up to canonical isomorphism. For `i = 0` one recovers the ordinary
pushforward `R⁰ f_* F = f_* F`. -/
noncomputable def cechHigherDirectImage (f : X ⟶ S) (𝒰 : X.OpenCover)
    (F : X.Modules) (i : ℕ) : S.Modules :=
  (CechComplex f 𝒰 F).homology i

/-- **Flat base change for the Čech higher direct images** (Stacks 02KH,
`lemma-flat-base-change-cohomology`).

Given the cartesian square
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
with `f` separated and quasi-compact, `F` quasi-coherent, `F' = (g')^* F`, and
`g` flat, for every `i ≥ 0` the canonical base-change map between the
unconditional Čech higher direct images is an isomorphism
```
  g^*(Rⁱ f_* F) ≅ Rⁱ f'_* ((g')^* F).
```
Equivalently, for `S = Spec A`, `S' = Spec B` with `A → B` flat, the comparison
`Hⁱ(X, F) ⊗_A B → Hⁱ(X', F')` of `B`-modules is an isomorphism.

We state the isomorphism as `Nonempty (… ≅ …)`; `𝒰` and `𝒰'` are finite affine
covers of `X` and `X' = X ×_S S'` (the latter the base change of the former).

The proof (Stacks 02KH): local on `S'`, reduce to `S = Spec A`, `S' = Spec B`,
`A → B` flat. Base changing the cover, the affine base change for the `i = 0`
direct image identifies each term of the base-changed Čech complex with the
original tensored over `A` with `B`, giving `Č•(𝒰_B, F_B) ≅ Č•(𝒰, F) ⊗_A B`;
flatness of `A → B` makes `- ⊗_A B` exact, so it commutes with `Hⁱ`, yielding the
isomorphism. -/
theorem cech_flatBaseChange
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (𝒰' : X'.OpenCover) [Finite 𝒰'.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i) := by
  -- Proof (Stacks 02KH): local on `S'`, reduce to `S = Spec A`, `S' = Spec B`,
  -- `A → B` flat; base change of the cover and the affine `i = 0` base change give
  -- `Č•(𝒰_B, F_B) ≅ Č•(𝒰, F) ⊗_A B`, and flatness makes `- ⊗_A B` commute with
  -- `Hⁱ`. Needs the term-wise affine base change of the Čech complex and exactness
  -- of `- ⊗_A B` on `Scheme.Modules`, currently absent from Mathlib.
  sorry

end AlgebraicGeometry
