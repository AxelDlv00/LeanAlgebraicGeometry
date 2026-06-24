/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage

/-!
# Unconditional `Rⁱ f_*` via Čech + flat base change (target-local roadmap)

These two declarations are **target-local** content preserved across the
enrich merge of the `Cech-Cohomology` subproject (2026-06-18). They originally
lived at the tail of the target's `Cohomology/CechHigherDirectImage.lean`, which
was replaced wholesale by the source library's (more fundamental and more
complete) `CechHigherDirectImage.lean`. The source development does not package
these two specific lemmas, so they are reinstated here on top of the merged
`CechComplex` so that the target's blueprint scope (`def:cech_higher_direct_image`,
`lem:cech_flat_base_change`) is preserved and its `\uses{}` graph stays intact.

* `cechHigherDirectImage` is sorry-free (a one-liner on the merged `CechComplex`).
* `cech_flatBaseChange` remains the target's pre-existing roadmap `sorry`
  (Stacks 02KH) — unchanged from before the merge.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {S S' X X' : Scheme.{u}}

/-- **Unconditional higher direct image via Čech.** For a separated quasi-compact
`f : X ⟶ S`, a finite affine open cover `𝒰` of `X`, and a quasi-coherent
`F : X.Modules`, the `i`-th higher direct image is the `i`-th cohomology of the
relative Čech complex. This needs **no** enough-injectives hypothesis on
`O_X`-modules: it is the cohomology of an explicit complex of quasi-coherent
sheaves. By `cech_computes_higherDirectImage` it agrees with the derived-functor
higher direct image wherever the latter is defined, and is independent of the
chosen affine cover up to canonical isomorphism. For `i = 0` one recovers the
ordinary pushforward `R⁰ f_* F = f_* F`. -/
noncomputable def cechHigherDirectImage (f : X ⟶ S) (𝒰 : X.OpenCover)
    (F : X.Modules) (i : ℕ) : S.Modules :=
  (CechComplex f 𝒰 F).homology i

/-! ### Skeleton for `cech_flatBaseChange` (Stacks 02KH, separated case)

The proof decomposes into the following pieces, assembled in `cech_flatBaseChange`:

1. **Homology side — DONE (modulo flat left-exactness).** The pullback `g^*` is exact,
   so it commutes with `HomologicalComplex.homology`:
   * `pullback_preservesFiniteColimits` — free, `g^*` is a left adjoint;
   * `pullback_preservesFiniteLimits` — **the one genuine homology-side gap**: `g`
     flat ⇒ `g^*` is left-exact (Mathlib has this affine-locally for `extendScalars`,
     `ModuleCat.preservesFiniteLimits_extendScalars_of_flat`, but not yet lifted
     through sheafification to `SheafOfModules.pullback`);
   * `pullback_preservesHomology` — then *derived* (no `sorry`) via
     `Functor.preservesHomologyOfExact`;
   * `mapHomologicalComplexHomologyIso` / `pullback_mapHC_homologyIso` — the
     complex-level upgrade of `ShortComplex.mapHomologyIso`, **sorry-free**.
2. **`cechComplex_baseChange_iso` (load-bearing, Stacks 02KG) — STILL OPEN.** Applying
   `g^*` degreewise to `Č•(𝒰, F)` recovers `Č•(𝒰', g'^* F)`. Termwise this is the
   affine `i = 0` base change `affineBaseChange_pushforward_iso`, which is *itself*
   `sorry` in `Cohomology/FlatBaseChange.lean` (two documented Mathlib-absent
   obligations: the affine reduction and the adjoint-mate ↔ `cancelBaseChange`
   identification), and must additionally be made compatible with the alternating Čech
   differentials and the cover base change. This is the genuine research frontier.
3. Assembly `cech_flatBaseChange` — **sorry-free**, reduces to 1 + 2.

No spectral sequence is needed here: this is the *separated* case (`[IsSeparated f]`).
The Čech-to-cohomology spectral sequence enters only in the separated → general
quasi-separated promotion of Stacks 02KH, which is **not** this lemma. -/

section HomologyComm

variable {C D : Type*} [Category.{u} C] [Category.{u} D] [Preadditive C] [Preadditive D]
  [CategoryWithHomology C] [CategoryWithHomology D]

/-- **Complex-level upgrade of `ShortComplex.mapHomologyIso`.** An additive functor `F`
that preserves homology commutes with `HomologicalComplex.homology`. The degree-`i`
short complex of `(F.mapHomologicalComplex c).obj K` is *definitionally* `F` applied to
the degree-`i` short complex `K.sc i` of `K` (both have `Xⱼ = F.obj (K.Xⱼ)` and
`d = F.map (K.d)`), so this is exactly `ShortComplex.mapHomologyIso (K.sc i) F`. -/
noncomputable def mapHomologicalComplexHomologyIso (F : C ⥤ D) [F.Additive]
    [F.PreservesHomology] {ι : Type*} {c : ComplexShape ι} (K : HomologicalComplex C c) (i : ι) :
    ((F.mapHomologicalComplex c).obj K).homology i ≅ F.obj (K.homology i) :=
  ShortComplex.mapHomologyIso (K.sc i) F

end HomologyComm

/-- **Flat base change has left-adjoint pullback**, hence `g^*` preserves finite
colimits (free: `g^* = pullback g` is a left adjoint). -/
instance pullback_preservesFiniteColimits (g : S' ⟶ S) :
    Limits.PreservesFiniteColimits (Scheme.Modules.pullback g) := inferInstance

/-- **Flat ⇒ `g^*` is left-exact** *(STUB — the one genuine homology-side gap)*.

The mathematical reduction is verified and worth recording. By
`SheafOfModules.pullbackIso`, the pullback factors as
`g^* ≅ forget ⋙ (PresheafOfModules.pullback φ.hom ⋙ PresheafOfModules.sheafification)`.
Two of the three factors preserve finite limits *in Mathlib already*:
* `SheafOfModules.forget` — `SheafOfModules.forgetPreservesFiniteLimits` (it is a right
  adjoint to sheafification);
* `PresheafOfModules.sheafification` — the instance in
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafification.lean` (sheafification is a
  left-exact reflector; needs `HasSheafify J AddCommGrpCat`, which holds for the scheme
  site since `X.Modules` is abelian).

So the *only* irreducible content is that the **presheaf-level** pullback
`PresheafOfModules.pullback φ.hom` preserves finite limits when `g` is flat. Mathlib
defines this presheaf pullback purely as `(pushforward φ).leftAdjoint` with **no
pointwise description**; mathematically it is the inverse image `g⁻¹` (exact) followed
by extension of scalars along the flat ring map (left-exact, cf.
`ModuleCat.preservesFiniteLimits_extendScalars_of_flat`), but neither this factorisation
nor its left-exactness is packaged. Closing it is a genuine multi-hundred-LOC Mathlib
development (assembling it via `pullbackIso` additionally requires resolving the
`sheafification`/`HasSheafify` instances for the concrete scheme site). -/
/- USER (Stacks 02KH leaf 1/2): close via the reduction proved out in the docstring —
   transfer along `SheafOfModules.pullbackIso` and discharge `forget` + `sheafification`
   (both already preserve finite limits in Mathlib: `SheafOfModules.forgetPreservesFiniteLimits`,
   the `sheafification` instance in `Presheaf/Sheafification.lean`). The irreducible core is
   that `PresheafOfModules.pullback` is left-exact under flat (mathematically `g⁻¹` exact,
   then flat `extendScalars` left-exact via `ModuleCat.preservesFiniteLimits_extendScalars_of_flat`).
   Likely path: stalkwise (stalk of pullback = `extendScalars` of stalk + pointwise flat
   exactness). This is pure exactness of flat pullback — no Čech/cohomology or spectral
   sequence is involved here (those belong to the base-change *assembly*, not this leaf).
   Reference: Stacks 02KH (the flatness input). -/
instance pullback_preservesFiniteLimits (g : S' ⟶ S) [Flat g] :
    Limits.PreservesFiniteLimits (Scheme.Modules.pullback g) := sorry

/-- **Flat ⇒ `g^*` preserves homology** — *derived* from left-exactness +
left-adjointness via `Functor.preservesHomologyOfExact`. No `sorry` of its own. -/
instance pullback_preservesHomology (g : S' ⟶ S) [Flat g] :
    (Scheme.Modules.pullback g).PreservesHomology := inferInstance

/-- **`g^*` commutes with Čech homology** (flat exactness, complex level). **Sorry-free:**
a direct specialisation of `mapHomologicalComplexHomologyIso` to `g^* = pullback g`,
which is additive and (for `g` flat) preserves homology. -/
noncomputable def pullback_mapHC_homologyIso (g : S' ⟶ S) [Flat g]
    (K : CochainComplex S.Modules ℕ) (i : ℕ) :
    (((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj K).homology i
      ≅ (Scheme.Modules.pullback g).obj (K.homology i) :=
  mapHomologicalComplexHomologyIso (Scheme.Modules.pullback g) K i

/-- **Tensorial base change of the Čech complex** (Stacks 02KG; *load-bearing*, OPEN).
Applying `g^*` degreewise to the relative Čech complex `Č•(𝒰, F)` yields the relative
Čech complex `Č•(𝒰', g'^* F)` of the base-changed data. Termwise this is the affine
`i = 0` base change `affineBaseChange_pushforward_iso` over each finite affine
intersection — which is *itself* `sorry` in `Cohomology/FlatBaseChange.lean` — assembled
into a chain isomorphism compatible with the alternating Čech differentials, with `𝒰'`
the base change of `𝒰` along `g'` (or via cover-independence). *(STUB — depends on the
still-open `affineBaseChange_pushforward_iso`; the genuine open content of 02KH/02KG.)* -/
/- USER (Stacks 02KH leaf 2/2 — the LOAD-BEARING one, Stacks 02KG): close
   `affineBaseChange_pushforward_iso` (`Cohomology/FlatBaseChange.lean`) FIRST — that is
   the termwise affine `i = 0` base change over each finite affine intersection — then
   assemble the per-degree isos into a chain isomorphism compatible with the alternating
   Čech differentials, taking `𝒰'` = base change of `𝒰` along `g'`. Reference: Stacks
   02KG/02KH. Use the concrete-tilde isos, NOT the adjoint-mate machinery that walled FBC-B. -/
noncomputable def cechComplex_baseChange_iso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [QuasiCompact f] [IsSeparated f]
    (𝒰 : X.OpenCover) (𝒰' : X'.OpenCover) (F : X.Modules) :
    ((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (CechComplex f 𝒰 F)
      ≅ CechComplex f' 𝒰' ((Scheme.Modules.pullback g').obj F) := sorry

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
covers of `X` and `X' = X ×_S S'` (the latter the base change of the former). -/
theorem cech_flatBaseChange
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (𝒰' : X'.OpenCover) [Finite 𝒰'.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i) := by
  -- Assembly (Stacks 02KH, separated case): `g^*` commutes with `Hⁱ` (flat
  -- exactness, `pullback_mapHC_homologyIso`), and the Čech complex transforms
  -- tensorially under base change (`cechComplex_baseChange_iso`, Stacks 02KG).
  refine ⟨?_⟩
  calc (Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i)
      ≅ (((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj
            (CechComplex f 𝒰 F)).homology i :=
        (pullback_mapHC_homologyIso g (CechComplex f 𝒰 F) i).symm
    _ ≅ (CechComplex f' 𝒰' ((Scheme.Modules.pullback g').obj F)).homology i :=
        HomologicalComplex.homologyMapIso
          (cechComplex_baseChange_iso f g f' g' h 𝒰 𝒰' F) i
    _ = cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i := rfl

end AlgebraicGeometry
