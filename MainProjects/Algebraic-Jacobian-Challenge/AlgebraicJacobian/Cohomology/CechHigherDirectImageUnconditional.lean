/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.FlatBaseChange
import AlgebraicJacobian.Cohomology.QcohTildeSections
import AlgebraicJacobian.Cohomology.CechTermAcyclic
import AlgebraicJacobian.Cohomology.ModulesCoverConservativity

/- USER (2026-06-29): `cech_flatBaseChange` (Stacks 02KH) is the Kleiman-4.8 Step-1 prerequisite and the
   active target. PER USER, close it via the ČECH-TO-COHOMOLOGY SPECTRAL SEQUENCE: build the relative SS
   `E₂^{p,q}=Ȟ^p(𝒰,R^q f_*F) ⟹ R^{p+q}f_*F` (Stacks 01EO/03OW, Cohomology 20.11.5) from Mathlib's
   abstract `Algebra.Homology.SpectralObject.*` / `SpectralSequence.Basic` / `TotalComplex` (total of the
   Čech×resolution bicomplex; the Čech side = `cechComplexOnX`/`cech_computes_higherDirectImage`). The
   SS's base-change functoriality (E₂ = Čech cohomology of `R^q f_*`, base-changed via the termwise
   affine iso `cechComplex_baseChange_iso` / concrete-tilde route) yields FBC and lifts the separated
   case to general — replacing the walled termwise mate-calculus. Scope the SS as a new blueprint node
   `lem:cech_to_derived_pushforward_ss`. Full plan + anchors: `.archon/USER_HINTS.md` temporary hint. -/

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
* `cech_flatBaseChange` (Stacks 02KH) is now sorry-free *modulo* the following named leaves
  (currently 7 open `sorry`s, all blueprinted): the homology-side flat left-exactness
  `pullback_preservesFiniteLimits` (the abstract-left-adjoint wall); the two degreewise
  Beck–Chevalley leaves `cech_pushforward_baseChange_natIso` (S-level square along `g`,
  `naturality` residual) and `twisted_cech_nerve_iso` (X-level square along `g'`, `naturality`
  residual); the per-σ single-open S-level base change `pushPullObj_coverInter_baseChange`
  (the affine-reduction heart — its LHS half is now LANDED via
  `pushPullObj_pushforward_iso_tilde_affine`, residual = RHS half + affine gap); the RHS leaf
  `pushPullObj_coverInter_baseChanged_pushforward_iso_tilde`; the X-level per-σ Beck–Chevalley
  `twisted_cech_nerve_per_sigma`; and its core open-immersion Beck–Chevalley
  `openImmersion_beckChevalley` — STAGE 1 (iter-326) is landed sorry-free (the pseudofunctor
  telescope `openImmersion_bc_telescope` + the bare mate `openImmersion_bareBC` collapse it to the
  single obligation `IsIso (openImmersion_bareBC … |>.app (p^* F))`); STAGE 2's mate
  factorization is now ALSO landed sorry-free (this session: `openImmersion_bareBC_app_eq`
  exhibits the mate as `p'`-unit ≫ isos, `openImmersion_pullback_counit_isIso` inverts the
  `p`-counit, `openImmersion_unit_isIso_of_essImage` inverts the unit on the essential image
  of the fully-faithful `p'_*`), so the residual is the single existence node
  `openImmersion_pushPull_essImage` (`g'^*(p_*(p^* F)) ∈ essImage p'_*`). The abstract→affine
  bridge `pushPullObj_pushforward_iso_tilde_affine` (abstract `[IsAffine S]`, transported along
  `S.isoSpec`) is sorry-free and axiom-clean (iter-325). The
  monolithic cosimplicial base-change iso `e` was decomposed (iter-315) and packaged
  sorry-free as `cechComplex_baseChange_cosimplicialIso =
  cech_pushforward_baseChange_natIso ≪≫ (pushforward f')_*.mapIso twisted_cech_nerve_iso`.
  Both leaves reduce degreewise, through the product decomposition `pushPull_sigma_iso`
  to the per-σ open `pushPullObj_coverInter_baseChange`, and thence through the shared
  affine brick `cech_degree_affine_baseChange` (this file), to the sorry-free affine
  termwise base change `affinePushforwardPullbackBaseChange` (`FlatBaseChange.lean`); the
  residual is the abstract→affine identification of the fibre-power push–pull objects
  with `tilde`-modules over `Spec` (see those leaves).
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
   `g^*` degreewise to `Č•(𝒰, F)` recovers `Č•(𝒰', g'^* F)`. It is supplied (iter-315) by
   `cechComplex_baseChange_cosimplicialIso`, the whiskered composite of the cosimplicial
   Beck–Chevalley iso `cech_pushforward_baseChange_natIso` (degreewise → per-σ
   `pushPullObj_coverInter_baseChange`, the affine-reduction heart routing through the
   altitude-2 bridge `pushPullObj_pushforward_iso_tilde` to the **sorry-free** affine
   termwise base change `affinePushforwardPullbackBaseChange` via the carved
   `restrictedCartesianAffinePushout` ring-pushout square) with the twisted-nerve
   identification `twisted_cech_nerve_iso` (per-σ `twisted_cech_nerve_per_sigma`, the
   X-level open-immersion Beck–Chevalley `openImmersion_beckChevalley` over the
   cover-base-change identity `coverInterOpen_baseChange_eq`). The route uses the
   concrete-tilde non-mate brick, NOT the adjoint-mate machinery. This is the genuine open
   content of Stacks 02KG/02KH.
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

/-! ## Project-local Mathlib supplement — additive functors and the alternating coface complex

The relative Čech complex `CechComplex` is, by construction
(`relativeCechComplexOfNerve`), the alternating coface-map cochain complex of a
cosimplicial object. The leaf-2 base change `cechComplex_baseChange_iso` must move the
degreewise pullback `g^*` *inside* this `alternatingCofaceMapComplex` construction. The
following two general declarations package exactly that move at the right (cosimplicial)
altitude, with no reference to schemes: an additive functor `F` commutes with the
alternating coface map complex, naturally in the cosimplicial variable. This is
Mathlib-absent and is the cosimplicial-natural-iso brick flagged in
`analogies/02kh-leaves-304.md` (step (b)). -/

section AlternatingCoface

open AlgebraicTopology

variable {C D : Type*} [Category.{u} C] [Category.{u} D] [Preadditive C] [Preadditive D]

/-- The degree-`n` differential of the alternating coface complex is the alternating sum
`objD`. Project-local unfolding lemma. -/
private theorem alternatingCofaceMapComplex_d
    (Y : CosimplicialObject C) (n : ℕ) :
    ((alternatingCofaceMapComplex C).obj Y).d n (n + 1)
      = AlternatingCofaceMapComplex.objD Y n := by
  simp only [alternatingCofaceMapComplex, AlternatingCofaceMapComplex.obj, CochainComplex.of_d]

/-- **An additive functor commutes with the alternating coface differential.** For an
additive functor `F : C ⥤ D` and a cosimplicial object `Y`, applying `F` to the
degree-`n` alternating coface differential `objD Y n = ∑ᵢ (-1)ⁱ • Yδᵢ` equals the
alternating coface differential of the post-composed cosimplicial object `Y ⋙ F`. This is
`F.map_sum` together with `Functor.map_zsmul` (both available since `F` is additive).
Project-local. -/
theorem map_alternatingCofaceMapComplex_objD (F : C ⥤ D) [F.Additive]
    (Y : CosimplicialObject C) (i : ℕ) :
    F.map (AlternatingCofaceMapComplex.objD Y i)
      = AlternatingCofaceMapComplex.objD
          (((CosimplicialObject.whiskering C D).obj F).obj Y) i := by
  rw [AlternatingCofaceMapComplex.objD, AlternatingCofaceMapComplex.objD, Functor.map_sum]
  apply Finset.sum_congr rfl
  intro k _
  rw [Functor.map_zsmul]
  rfl

/-- **Additive functors commute with `alternatingCofaceMapComplex`.** For an additive
functor `F : C ⥤ D` and a cosimplicial object `Y` in `C`, applying `F` degreewise to the
alternating coface map cochain complex of `Y` yields the alternating coface map cochain
complex of the post-composed cosimplicial object `F ∘ Y`:
`F.mapHomologicalComplex (alternatingCofaceMapComplex Y) ≅ alternatingCofaceMapComplex (F ∘ Y)`.
The degreewise components are identities (the degree-`n` terms are `F.obj (Y.obj [n])` on
both sides) and the differential compatibility is `map_alternatingCofaceMapComplex_objD`.
This is the cosimplicial-altitude brick (step (b)) used to push `g^*` into the relative
Čech complex `relativeCechComplexOfNerve`. Project-local Mathlib supplement. -/
-- (v4.31.0: `CechToHigherDirectImage` also defines a public `mapAlternatingCofaceMapComplexIso`
-- — that file never compiled before the migration so the name clash was latent; now that it
-- builds, both being public collides at the root import. This copy is used only inside this file,
-- so mark it `private` to resolve the clash without rebuilding the 4.3 h `CechToHigherDirectImage`.)
private noncomputable def mapAlternatingCofaceMapComplexIso (F : C ⥤ D) [F.Additive]
    (Y : CosimplicialObject C) :
    (F.mapHomologicalComplex (ComplexShape.up ℕ)).obj ((alternatingCofaceMapComplex C).obj Y)
      ≅ (alternatingCofaceMapComplex D).obj
          (((CosimplicialObject.whiskering C D).obj F).obj Y) :=
  HomologicalComplex.Hom.isoOfComponents (fun _ => Iso.refl _) (by
    rintro i j (rfl : i + 1 = j)
    have h : F.map (((alternatingCofaceMapComplex C).obj Y).d i (i + 1))
        = ((alternatingCofaceMapComplex D).obj
            (((CosimplicialObject.whiskering C D).obj F).obj Y)).d i (i + 1) := by
      rw [alternatingCofaceMapComplex_d, alternatingCofaceMapComplex_d]
      exact map_alternatingCofaceMapComplex_objD F Y i
    rw [Functor.mapHomologicalComplex_obj_d, h]
    erw [Category.id_comp, Category.comp_id])

end AlternatingCoface

/-- **The degreewise pullback of the relative Čech complex, in alternating-coface form.**
Specialising `mapAlternatingCofaceMapComplexIso` to `F = g^* = Scheme.Modules.pullback g`
and the push-forward cosimplicial object underlying `CechComplex f 𝒰 F`, this identifies
`g^*` applied degreewise to `Č•(𝒰, F)` with the alternating coface complex of the
cosimplicial object obtained by post-composing the dropped Čech nerve with `f_*` then `g^*`.
This is the first concrete step of the leaf-2 assembly `cechComplex_baseChange_iso`:
it moves the degreewise pullback inside the `alternatingCofaceMapComplex` construction,
reducing the remaining content to a (Beck–Chevalley) natural isomorphism of the underlying
cosimplicial objects `(g^* ∘ f_* ∘ nerve) ≅ (f'_* ∘ g'^* ∘ nerve')`. Project-local. -/
noncomputable def pullback_cechComplex_alternatingIso (f : X ⟶ S) (g : S' ⟶ S)
    (𝒰 : X.OpenCover) (F : X.Modules) :
    ((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (CechComplex f 𝒰 F)
      ≅ (AlgebraicTopology.alternatingCofaceMapComplex S'.Modules).obj
          (((CosimplicialObject.whiskering S.Modules S'.Modules).obj
              (Scheme.Modules.pullback g)).obj
            (((CosimplicialObject.whiskering X.Modules S.Modules).obj
                (Scheme.Modules.pushforward f)).obj
              (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))) :=
  mapAlternatingCofaceMapComplexIso (Scheme.Modules.pullback g) _

/-- **Reduction of leaf 2 to a cosimplicial Beck–Chevalley isomorphism.** The full Čech
base-change isomorphism `cechComplex_baseChange_iso` follows *mechanically* from a single
natural isomorphism of the underlying cosimplicial objects: the cosimplicial object
`g^* ∘ f_* ∘ (Čech nerve of 𝒰, F)` is isomorphic to `f'_* ∘ g'^* ∘ (Čech nerve of 𝒰', g'^*F)`.
Given such an `e`, `Functor.mapIso (alternatingCofaceMapComplex …)` transports it to a chain
isomorphism whose differential compatibility is automatic, and pre-composing with
`pullback_cechComplex_alternatingIso` (which moves `g^*` inside the alternating-coface
construction) yields the claim. This isolates the genuine open content of Stacks 02KG/02KH
— the Beck–Chevalley natural iso `g^* ∘ f_* ≅ f'_* ∘ g'^*` whiskered through the nerve,
together with the affine reduction on `S` — into the single hypothesis `e`. Project-local. -/
noncomputable def cechComplex_baseChange_iso_of_cosimplicialIso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) (F : X.Modules)
    (e : ((CosimplicialObject.whiskering S.Modules S'.Modules).obj
            (Scheme.Modules.pullback g)).obj
          (((CosimplicialObject.whiskering X.Modules S.Modules).obj
              (Scheme.Modules.pushforward f)).obj
            (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
        ≅ ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
            (Scheme.Modules.pushforward f')).obj
          (CosimplicialObject.Augmented.drop.obj
            (CechNerve ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
              h.isoPullback.symm.hom) ((Scheme.Modules.pullback g').obj F)))) :
    ((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (CechComplex f 𝒰 F)
      ≅ CechComplex f'
          ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
          ((Scheme.Modules.pullback g').obj F) :=
  pullback_cechComplex_alternatingIso f g 𝒰 F ≪≫
    (AlgebraicTopology.alternatingCofaceMapComplex S'.Modules).mapIso e

/-- **Degreewise affine reduction of the Čech base change** (Stacks 02KG; shared sub-lemma).
Fix a cosimplicial degree `p`. On the standard affine model of the cover the `(p+1)`-fold
fibre power `U_{i₀…iₚ} = U_{i₀} ×_X ⋯ ×_X U_{iₚ}` is `Spec` of the finite affine intersection
`A := A_{i₀} ⊗_R ⋯ ⊗_R A_{iₚ}` of the coordinate rings of the cover members, and the X-level
cartesian square defining the base change along `g'` restricts, over `U_{i₀…iₚ}`, to the affine
pushout (tensor) square of rings `(φ : R ⟶ A, ψ : R ⟶ R', ρ : A ⟶ B, σ : R' ⟶ B)`. On that
affine model the degreewise Beck–Chevalley comparison
```
  g'^*(p_* p^* F)  ≅  p'_* p'^*(g'^* F)        over U_{i₀…iₚ}
```
IS the affine termwise base change `affinePushforwardPullbackBaseChange`
(`FlatBaseChange.lean`), assembled from the concrete tilde dictionaries
`pushforward_spec_tilde_iso` / `pullback_spec_tilde_iso` and the commutative-algebra
cancellation `cancelBaseChange` — *not* the canonical adjoint mate `pushforwardBaseChangeMap`.
These affine identifications are natural with respect to the index-omission maps that generate
the cosimplicial structure of the nerve (each coface is the ring inclusion that inserts the
omitted tensor factor), since `affinePushforwardPullbackBaseChange` is natural in the ring.

This is the **shared per-degree brick** consumed by both
`cech_pushforward_baseChange_natIso` and `twisted_cech_nerve_iso`: at each degree, after the
affine identification of the fibre power, the `app` field of either leaf is this isomorphism.
Sorry-free: a direct repackaging of the affine termwise base change at the intersection ring
`A`. Project-local; see blueprint `lem:cech_degree_affine_baseChange`. -/
noncomputable def cech_degree_affine_baseChange {R A R' B : CommRingCat.{u}}
    (φ : R ⟶ A) (ψ : R ⟶ R') (ρ : A ⟶ B) (σ : R' ⟶ B)
    (h : CategoryTheory.IsPushout φ ψ ρ σ) (M : ModuleCat.{u} A) :
    (Scheme.Modules.pullback (Spec.map ψ)).obj
        ((Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M)) ≅
      (Scheme.Modules.pushforward (Spec.map σ)).obj
        ((Scheme.Modules.pullback (Spec.map ρ)).obj (tilde M)) :=
  affinePushforwardPullbackBaseChange φ ψ ρ σ h M

/-! ## Project-local Mathlib supplement — the abstract→affine `pushPullObj ≅ tilde` bridge

The two degreewise Beck–Chevalley leaves (`cech_pushforward_baseChange_natIso`,
`twisted_cech_nerve_iso`) reduce, on the affine model of the cover, to the sorry-free affine
brick `cech_degree_affine_baseChange`. The missing edge (Stacks 01I8 / 01BG) is the identification
of the abstract push–pull data of a fibre power with the `tilde`-model over `Spec`. We build it at
the two well-typed altitudes flagged in `analogies/fbc-pushpull-tilde-317.md`:

* **altitude 1** (`pullbackRestrict_iso_tilde`): the restriction `p^* F = (V.ι)^* F` of a
  quasi-coherent `F` to an affine open `V` of `X`, *pushed forward along the whole-scheme iso*
  `V ≅ Spec Γ(X, V)` (`IsAffineOpen.isoSpec`), is `tilde` of its global sections over
  `Spec Γ(X, V)`. Quasi-coherence is preserved by pullback along the open immersion `V.ι`
  (`pullback_isQuasicoherent`/`isQuasicoherent_pullback_opens`) and by pushforward along the
  iso `isoSpec` (`pushforward_iso_preserves_qcoh`), so the affine structure theorem 01I8
  (`qcoh_iso_tilde_sections`, unconditional via the live instance
  `isIso_fromTildeΓ_of_quasicoherent`) applies.
* **altitude 2** (`pushPullObj_pushforward_iso_tilde`): over the affine base `S = Spec R`, the
  pushed-forward push–pull object `f_*(p_* p^* F) = f_*((V.ι)_* (V.ι)^* F)` is `(Spec φ)_* (tilde N)`
  — collapse `f_* ∘ (V.ι)_*` to `(V.ι ≫ f)_*` by `pushforwardComp`, factor
  `V.ι ≫ f = isoSpec.hom ≫ Spec.map φ` (with `φ := Spec.preimage (fromSpec ≫ f)`,
  `Spec.map_preimage`), split off `(Spec.map φ)_*` by `pushforwardComp` again, and feed altitude 1
  through `(Spec.map φ)_*`. This is exactly the form the brick `cech_degree_affine_baseChange`
  consumes. See blueprint `lem:pullback_preserves_quasicoherent`, `lem:pushPullObj_iso_tilde`.

All ingredients are axiom-clean project infrastructure: `isQuasicoherent_pullback_opens`
(`CechTermAcyclic`), `pushforward_iso_preserves_qcoh` (`OpenImmersionPushforward`),
`qcoh_iso_tilde_sections` (`QcohTildeSections`, the unconditional 01I8 structure theorem).
-/

/-- **Pullback preserves quasi-coherence** (Stacks 01BG, open case).  For an open `V` of `X` and a
quasi-coherent `F : X.Modules`, the restriction `(V.ι)^* F` is quasi-coherent on `V`.  This is the
open-immersion case the fibre-power projections of the {\v C}ech nerve require (each
`Y_n = U_{i₀} ∩ ⋯ ∩ U_{iₙ} ↪ X` is an open immersion); the general-morphism case is absent from both
Mathlib and the project (the abstract left-adjoint route via `Presentation.map` only transports a
*global* presentation, whereas quasi-coherence is *local*).  A thin re-export of
`isQuasicoherent_pullback_opens` (proved via `IsQuasicoherent.of_coversTop` on the preimage cover).
Project-local; blueprint `lem:pullback_preserves_quasicoherent`. -/
theorem pullback_isQuasicoherent (V : X.Opens) (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((Scheme.Modules.pullback V.ι).obj F).IsQuasicoherent :=
  isQuasicoherent_pullback_opens V F hF

/-- **Altitude 1 of the bridge: `(V.ι)^* F` pushed to `Spec Γ(X,V)` is `tilde N`** (Stacks 01I8).
For a quasi-coherent `F : X.Modules` and an affine open `V` of `X`, the restriction `(V.ι)^* F`,
pushed forward along the whole-scheme iso `isoSpec : V ≅ Spec Γ(X, V)`, is canonically isomorphic to
the `tilde` of its module of global sections `N = Γ(Spec Γ(X,V), -)`.  The pullback is quasi-coherent
(`pullback_isQuasicoherent`) and quasi-coherence is preserved by the iso-pushforward
(`pushforward_iso_preserves_qcoh`), so the unconditional affine structure theorem 01I8
(`qcoh_iso_tilde_sections`, via the live instance `isIso_fromTildeΓ_of_quasicoherent`) applies.
Project-local; blueprint `lem:pushPullObj_iso_tilde` (altitude 1). -/
noncomputable def pullbackRestrict_iso_tilde (F : X.Modules) (hF : F.IsQuasicoherent)
    {V : X.Opens} (hV : IsAffineOpen V) :
    (Scheme.Modules.pushforward hV.isoSpec.hom).obj ((Scheme.Modules.pullback V.ι).obj F) ≅
      tilde (moduleSpecΓFunctor.obj
        ((Scheme.Modules.pushforward hV.isoSpec.hom).obj ((Scheme.Modules.pullback V.ι).obj F))) :=
  haveI : ((Scheme.Modules.pushforward hV.isoSpec.hom).obj
      ((Scheme.Modules.pullback V.ι).obj F)).IsQuasicoherent :=
    pushforward_iso_preserves_qcoh hV.isoSpec ((Scheme.Modules.pullback V.ι).obj F)
      (pullback_isQuasicoherent V F hF)
  qcoh_iso_tilde_sections _

/-- **Altitude 2 of the bridge: `f_*(p_* p^* F) ≅ (Spec φ)_* (tilde N)`** (Stacks 01I8, assembled
pushed-forward level).  Over the affine base `S = Spec R`, with `V` an affine open of `X` and
`φ := Spec.preimage (fromSpec ≫ f) : R ⟶ Γ(X, V)` the ring map presenting the composite
`isoSpec.inv ≫ V.ι ≫ f = fromSpec ≫ f` as `Spec.map φ`, the pushed-forward push–pull object
`(pushforward f).obj (pushPullObj F (Over.mk V.ι))` is canonically isomorphic to
`(pushforward (Spec.map φ)).obj (tilde N)`.

The construction: collapse `f_* ∘ (V.ι)_*` to `(V.ι ≫ f)_*` by `pushforwardComp`; rewrite
`V.ι ≫ f = isoSpec.hom ≫ Spec.map φ` (from `Spec.map_preimage` and `isoSpec_inv_ι`) by
`pushforwardCongr`; split off `(Spec.map φ)_*` by `pushforwardComp` again (leaving the altitude-1
domain `(isoSpec.hom)_* ((V.ι)^* F)`); then push altitude 1 (`pullbackRestrict_iso_tilde`) through
`(Spec.map φ)_*`.  The right-hand side is exactly the form consumed by the brick
`cech_degree_affine_baseChange`.  Project-local; blueprint `lem:pushPullObj_iso_tilde` (altitude 2). -/
noncomputable def pushPullObj_pushforward_iso_tilde {R : CommRingCat.{u}}
    (f : X ⟶ Spec R) (F : X.Modules) (hF : F.IsQuasicoherent)
    {V : X.Opens} (hV : IsAffineOpen V) :
    (Scheme.Modules.pushforward f).obj (pushPullObj F (Over.mk V.ι)) ≅
      (Scheme.Modules.pushforward (Spec.map (Spec.preimage (hV.fromSpec ≫ f)))).obj
        (tilde (moduleSpecΓFunctor.obj
          ((Scheme.Modules.pushforward hV.isoSpec.hom).obj ((Scheme.Modules.pullback V.ι).obj F)))) :=
  have heq : V.ι ≫ f = hV.isoSpec.hom ≫ Spec.map (Spec.preimage (hV.fromSpec ≫ f)) := by
    rw [Spec.map_preimage, ← IsAffineOpen.isoSpec_inv_ι hV, Category.assoc, Iso.hom_inv_id_assoc]
  (pushforwardComp V.ι f).app ((Scheme.Modules.pullback V.ι).obj F) ≪≫
    (pushforwardCongr heq).app ((Scheme.Modules.pullback V.ι).obj F) ≪≫
    (pushforwardComp hV.isoSpec.hom (Spec.map (Spec.preimage (hV.fromSpec ≫ f)))).symm.app
      ((Scheme.Modules.pullback V.ι).obj F) ≪≫
    (Scheme.Modules.pushforward (Spec.map (Spec.preimage (hV.fromSpec ≫ f)))).mapIso
      (pullbackRestrict_iso_tilde F hF hV)

/-- **Altitude 2 over an abstract affine base** (Stacks 01I8, abstract-`S` generalization of
`pushPullObj_pushforward_iso_tilde`).  For a *separated* `f : X ⟶ S` with `S` an **abstract** affine
scheme (`[IsAffine S]`, so `S` need not be a literal `Spec`), write `e_S := S.isoSpec : S ≅ Spec Γ(S)`
for the canonical affine identification.  The pushed-forward push–pull object
`(pushforward f).obj (pushPullObj F (Over.mk V.ι))` is canonically isomorphic to the altitude-2
`(Spec φ)_*(tilde N)` form, **transported back along `e_S⁻¹`** so it lands in `O_S`-modules rather
than `O_{Spec Γ(S)}`-modules, where `φ := Spec.preimage (hV.fromSpec ≫ (f ≫ e_S.hom))` presents
`(e_S ∘ f) ∘ (isoSpec ∘ j_V)` as `Spec φ`.

Construction (≤10 lines): the composite `f ≫ e_S.hom : X ⟶ Spec Γ(S)` has a *literal* affine base,
so the literal-Spec bridge `pushPullObj_pushforward_iso_tilde` applies to it; then conjugate by
`(pushforward e_S.inv)` and collapse `pushforward e_S.hom ⋙ pushforward e_S.inv ≅ id` via
`pushforwardComp`/`pushforwardCongr`/`pushforwardId` (the `e_S` cancellation).  This is the form the
heart `pushPullObj_coverInter_baseChange` consumes (the abstract-`S` ↔ `Spec R` transport, applied
once for both `f` and `f'`).  Project-local; blueprint `lem:pushPullObj_iso_tilde_affine`. -/
noncomputable def pushPullObj_pushforward_iso_tilde_affine [IsAffine S]
    (f : X ⟶ S) (F : X.Modules) (hF : F.IsQuasicoherent)
    {V : X.Opens} (hV : IsAffineOpen V) :
    (Scheme.Modules.pushforward f).obj (pushPullObj F (Over.mk V.ι)) ≅
      (Scheme.Modules.pushforward S.isoSpec.inv).obj
        ((Scheme.Modules.pushforward (Spec.map (Spec.preimage
            (hV.fromSpec ≫ (f ≫ S.isoSpec.hom))))).obj
          (tilde (moduleSpecΓFunctor.obj
            ((Scheme.Modules.pushforward hV.isoSpec.hom).obj
              ((Scheme.Modules.pullback V.ι).obj F))))) :=
  -- `collapse : (e_S⁻¹)_* ((f ≫ e_S)_* P) ≅ f_* P`, the `e_S` cancellation; take `.symm` to start
  -- from `f_* P`, then push the literal bridge through `(e_S⁻¹)_*`.
  ((Scheme.Modules.pushforward S.isoSpec.inv).mapIso
        ((Scheme.Modules.pushforwardComp f S.isoSpec.hom).symm.app
          (pushPullObj F (Over.mk V.ι))) ≪≫
      (Scheme.Modules.pushforwardComp S.isoSpec.hom S.isoSpec.inv).app
        ((Scheme.Modules.pushforward f).obj (pushPullObj F (Over.mk V.ι))) ≪≫
      (Scheme.Modules.pushforwardCongr S.isoSpec.hom_inv_id).app
        ((Scheme.Modules.pushforward f).obj (pushPullObj F (Over.mk V.ι))) ≪≫
      (Scheme.Modules.pushforwardId S).app
        ((Scheme.Modules.pushforward f).obj (pushPullObj F (Over.mk V.ι)))).symm ≪≫
    (Scheme.Modules.pushforward S.isoSpec.inv).mapIso
      (pushPullObj_pushforward_iso_tilde (f ≫ S.isoSpec.hom) F hF hV)

/-- **Čech intersection opens are affine** (separated case).  For a separated `f : X ⟶ S`
with `S` affine and an affine open cover `𝒰` of `X`, every finite nonempty fibre-power
intersection open `coverInterOpen 𝒰 σ = ⨅ k, (𝒰.f (σ k)).opensRange` is affine.  `X` is
separated over the terminal scheme (`f` separated and `S` affine — hence separated — so the
composite `terminal.from X = f ≫ terminal.from S` is separated), so the absolute diagonal of
`X` is a closed immersion, hence affine; finite intersections of affine opens of a scheme with
affine diagonal are affine (`IsAffineOpen.iInf`), and each member open is affine as the range of
an open immersion out of the affine `𝒰.X (σ k)` (`isAffineOpen_opensRange`).  This is the
affineness ingredient consumed by the affine-reduction heart `pushPullObj_coverInter_baseChange`.
Project-local; blueprint `lem:cech_degree_affine_baseChange` (affineness side-condition). -/
theorem coverInterOpen_isAffine (f : X ⟶ S) [IsSeparated f] [IsAffine S]
    (𝒰 : X.OpenCover) [∀ i, IsAffine (𝒰.X i)] {κ : Type} [Finite κ] [Nonempty κ]
    (σ : κ → 𝒰.I₀) : IsAffineOpen (coverInterOpen 𝒰 σ) := by
  -- `X` is separated over the terminal scheme: `terminal.from X = f ≫ terminal.from S`, with
  -- `f` separated and `terminal.from S` separated (`S` affine ⟹ `S.IsSeparated`).
  haveI hsep : IsSeparated (terminal.from X) := by
    rw [← terminal.comp_from f]
    exact IsSeparated.comp_iff.mpr ‹IsSeparated f›
  -- hence the absolute diagonal is a closed immersion (⟹ affine), unlocking `IsAffineOpen.iInf`.
  haveI : IsClosedImmersion (pullback.diagonal (terminal.from X)) :=
    IsSeparated.isClosedImmersion_diagonal
  exact IsAffineOpen.iInf (fun k => isAffineOpen_opensRange (𝒰.f (σ k)))

/-- **Restriction of the cartesian square over an affine intersection open is a (ring) pushout**
(Stacks 02KG; carved block `lem:restricted_cartesian_affine_pushout`).  Restricting the global
cartesian square `X' = X ×_S S' → X` over the Čech fibre-power intersection open
`V = coverInterOpen 𝒰 σ ↪ X` (open immersion `j_σ`) replaces `X` by `V` and `X'` by the fibre
product `X' ×_X V`, and the restricted square
```
  X' ×_X V --pullback.fst--> V
   |pullback.snd             |j_σ
   v                         v
  X'  --------g'------------> X
```
is cartesian.  This is the geometric half of the carved block: under `[IsSeparated f]`,
`[IsAffine S]`, `[IsAffine S']` and an affine cover, `V` is affine (`coverInterOpen_isAffine`)
and `X' ×_X V` is affine, so applying global sections turns this cartesian square of affines into
the cocartesian (pushout) square of rings `R → A_σ`, `R → R'`, `A_σ → A_σ ⊗_R R'` via the
affine-pullback ↔ ring-pushout equivalence `CommRingCat.isPushout_iff_isPushout`
(`lem:commRingCat_isPushout_iff_mathlib`, `\mathlibok`) — exactly the affine pushout square
consumed by `cech_degree_affine_baseChange`.  Sorry-free: the restricted square is a pullback by
construction (`IsPullback.of_hasPullback`).  Project-local; blueprint
`lem:restricted_cartesian_affine_pushout`. -/
theorem restrictedCartesianAffinePushout (g' : X' ⟶ X)
    (𝒰 : X.OpenCover) {κ : Type} (σ : κ → 𝒰.I₀) :
    IsPullback (pullback.snd g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))
      (pullback.fst g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))
      (Scheme.Opens.ι (coverInterOpen 𝒰 σ)) g' :=
  (IsPullback.of_hasPullback g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).flip

/-- **LHS abstract → tilde for a single intersection open** (carved block
`lem:coverinter_lhs_iso_tilde`).  Over the affine base `S = Spec R`, for a separated `f : X ⟶ Spec R`,
an affine open-immersion cover `𝒰` and a finite nonempty multi-index `σ`, the intersection open
`V = coverInterOpen 𝒰 σ` is affine (`coverInterOpen_isAffine`) and the pushed-forward push–pull object
`f_*(pushPullObj F (Over.mk j_σ)) = f_*((j_σ)_* (j_σ)^* F)` is the affine pushforward
`(Spec φ)_*(tilde N)` of the tilde of its global sections, where `φ = Spec.preimage (fromSpec ≫ f)`
presents `f ∘ j_σ` as `Spec φ`.  This is the LHS comparison side of the per-intersection-open base
change; it is the altitude-2 bridge `pushPullObj_pushforward_iso_tilde` applied at the affine open
`V = coverInterOpen 𝒰 σ`.  Project-local; blueprint `lem:coverinter_lhs_iso_tilde`. -/
noncomputable def pushPullObj_coverInter_pushforward_iso_tilde {R : CommRingCat.{u}}
    (f : X ⟶ Spec R) [IsSeparated f]
    (𝒰 : X.OpenCover) [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent)
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pushforward f).obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅
      (Scheme.Modules.pushforward (Spec.map (Spec.preimage
          ((coverInterOpen_isAffine f 𝒰 σ).fromSpec ≫ f)))).obj
        (tilde (moduleSpecΓFunctor.obj
          ((Scheme.Modules.pushforward (coverInterOpen_isAffine f 𝒰 σ).isoSpec.hom).obj
            ((Scheme.Modules.pullback (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).obj F)))) :=
  pushPullObj_pushforward_iso_tilde f F hF (coverInterOpen_isAffine f 𝒰 σ)

/-- **The base-changed sections are the tensor base change of `N`** (carved block
`lem:coverinter_baseChanged_module_iso_tensor`).  For the affine pushout square of rings cut out by
restricting the cartesian base-change square over the affine intersection open `V = Spec A_σ`
(`φ : R ⟶ A_σ`, `ψ : R ⟶ R'`, `ρ : A_σ ⟶ B`, `σ' : R' ⟶ B` with corner `B ≅ A_σ ⊗_R R'`), the
base-changed module of sections `N' = (j'_σ)^*((g')^* F)` over the affine `V' = Spec B` is, as a
`B`-module restricted to `R'` (resp. read as the corner `B`-module `B ⊗_{A_σ} N`), the tensor base
change `N ⊗_R R' = R' ⊗_R N`.  This is precisely the module-level corner identification realised by
the inverse of `baseChangeCancelModuleIso`: `restrict_σ'(B ⊗_{A_σ} N) ≅ R' ⊗_R N`.  The geometric
wrapping (relating the geometric `Γ(V', (j'_σ)^*((g')^*F))` to `B ⊗_{A_σ} N` via the cartesian
pullback comparison and the affine tilde dictionary) is carried by the RHS leaf
`pushPullObj_coverInter_baseChanged_pushforward_iso_tilde`.  Project-local; blueprint
`lem:coverinter_baseChanged_module_iso_tensor` (module core). -/
noncomputable def coverInter_baseChanged_sections_iso_tensor {R A R' B : CommRingCat.{u}}
    (φ : R ⟶ A) (ψ : R ⟶ R') (ρ : A ⟶ B) (σ' : R' ⟶ B)
    (h : CategoryTheory.IsPushout φ ψ ρ σ') (N : ModuleCat.{u} A) :
    (ModuleCat.restrictScalars σ'.hom).obj ((ModuleCat.extendScalars ρ.hom).obj N) ≅
      (ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj N) :=
  (baseChangeCancelModuleIso φ ψ ρ σ' h N).symm

/-- **RHS abstract → tilde for a single intersection open (base-changed side)** (carved block
`lem:coverinter_rhs_iso_tilde`).  Over the affine bases `S = Spec R`, `S' = Spec R'`, for the
cartesian base-change square `h : IsPullback g' f' f g` with `f : X ⟶ Spec R` separated, the
base-changed RHS push–pull object `f'_*((g')^*(pushPullObj F (Over.mk j_σ)))` is the affine
pushforward `(Spec ψ)_*(tilde (N ⊗_R R'))` of the tilde of the base-changed module, where
`ψ : R' ⟶ A_σ ⊗_R R'` presents `f' ∘ j'_σ` as `Spec ψ` and `N = Γ(V, (j_σ)^* F)`.

*(STUB — the largest carved piece, the previously-glossed multi-hundred-LOC gap.  Intended route:
push `g'` through the per-σ X-level Beck–Chevalley `twisted_cech_nerve_per_sigma` to turn
`(g')^*((j_σ)_*(j_σ)^* F)` into `(j'_σ)_*(j'_σ)^*((g')^*F) = pushPullObj ((g')^*F) (Over.mk j'_σ)`;
the base-changed open `V' = X' ×_X V` is affine (`restrictedCartesianAffinePushout` over the affine
`V`, `S'`), so the altitude-2 bridge `pushPullObj_pushforward_iso_tilde` for `f'` at `V'` gives
`(Spec ψ)_*(tilde N')`; then `coverInter_baseChanged_sections_iso_tensor` identifies the corner module
`N' ≅ N ⊗_R R'`.)*  Project-local; blueprint `lem:coverinter_rhs_iso_tilde`. -/
noncomputable def pushPullObj_coverInter_baseChanged_pushforward_iso_tilde
    {R R' : CommRingCat.{u}}
    (f : X ⟶ Spec R) (g : Spec R' ⟶ Spec R) (f' : X' ⟶ Spec R') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [IsSeparated f] [IsSeparated f']
    (𝒰 : X.OpenCover) [∀ i, IsAffine (𝒰.X i)]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent)
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pushforward f').obj
        ((Scheme.Modules.pullback g').obj
          (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))) ≅
      (Scheme.Modules.pushforward (Spec.map (Spec.preimage
          ((coverInterOpen_isAffine f'
            ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
            σ).fromSpec ≫ f')))).obj
        (tilde (moduleSpecΓFunctor.obj
          ((Scheme.Modules.pushforward (coverInterOpen_isAffine f'
              ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
              σ).isoSpec.hom).obj
            ((Scheme.Modules.pullback (Scheme.Opens.ι (coverInterOpen
                ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
                σ))).obj
              ((Scheme.Modules.pullback g').obj F))))) :=
  -- RESIDUAL: the multi-hundred-LOC RHS abstract → tilde reduction (see docstring sketch).
  -- Intended route: under `f'_*`, apply `twisted_cech_nerve_per_sigma` to rewrite
  -- `(g')^*((j_σ)_*(j_σ)^* F)` as `pushPullObj ((g')^*F) (Over.mk j'_σ)` over the base-changed
  -- intersection open `V' = coverInterOpen 𝒰' σ`, then apply the altitude-2 bridge
  -- `pushPullObj_pushforward_iso_tilde f' (g'^*F) _ (coverInterOpen_isAffine f' 𝒰' σ)`.
  sorry

/-- **Per-intersection-open S-level base change** (the per-σ residual of the degreewise
Beck–Chevalley leaf, after the product decomposition `pushPull_sigma_iso`).  For a Čech
fibre-power intersection open `V = coverInterOpen 𝒰 σ` of `X` (affine under `[IsSeparated f]`
+ affine cover), the abstract base-change iso
```
  g^*(f_*(p_* p^* F))  ≅  f'_*(g'^*(p_* p^* F))   over the single open `V`
```
at the single-open push–pull object `pushPullObj F (Over.mk V.ι)`, for the cartesian square `h`
with affine base `S` and `S'`.

This is the genuine open content of Stacks 02KG/02KH that survives the (now-closed) coproduct/
product decomposition layer: `V` is affine (`IsAffineOpen.biInf` over the affine cover, `X`
separated), so the abstract `f_*(p_* p^* F)` is identified with the affine `(Spec φ)_*(tilde N)`
form by the bridge `pushPullObj_pushforward_iso_tilde` (altitude 2; this requires the affine
base `S = Spec R`, reached via `S.isoSpec`), at which point the comparison IS the sorry-free
affine termwise base change `cech_degree_affine_baseChange` (= `affinePushforwardPullbackBaseChange`)
for the affine pushout square of rings cut out by restricting `h` over `V`.  The residual `sorry`
is exactly the extraction of that affine pushout square `(φ, ψ, ρ, σ', h')` from the restricted
cartesian square and the identification of `g'^*(p_* p^* F)` with the matching `tilde` — the
multi-hundred-LOC affine-reduction heart.  Project-local; blueprint `lem:cech_degree_affine_baseChange`
(per-open instance). -/
noncomputable def pushPullObj_coverInter_baseChange
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [IsSeparated f] [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent)
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pullback g).obj
        ((Scheme.Modules.pushforward f).obj
          (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))) ≅
      (Scheme.Modules.pushforward f').obj
        ((Scheme.Modules.pullback g').obj
          (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))) := by
  -- The intersection open `V = coverInterOpen 𝒰 σ` is affine (the genuinely geometric
  -- side-condition; proved sorry-free).  This `hV` is the affine open over which the bridge
  -- altitude-2 identification `pushPullObj_pushforward_iso_tilde` and the affine brick
  -- `cech_degree_affine_baseChange` are applied.
  have hV : IsAffineOpen (coverInterOpen 𝒰 σ) := coverInterOpen_isAffine f 𝒰 σ
  -- LHS → tilde (iter-325 LANDED): route the LHS pushforward `f_*(p_* p^* F)` through the new
  -- abstract-affine bridge `pushPullObj_pushforward_iso_tilde_affine` (altitude 2 over the abstract
  -- base `S`, transported along `S.isoSpec : S ≅ Spec Γ(S)`) to its affine `(Spec φ)_*(tilde N)`
  -- form, then apply `g^*`.  This discharges the LHS half of the comparison.
  refine (Scheme.Modules.pullback g).mapIso
      (pushPullObj_pushforward_iso_tilde_affine f F hF hV) ≪≫ ?_
  -- RESIDUAL (the RHS half + affine gap): it remains to identify the RHS abstract term
  -- `f'_*(g'^*(p_* p^* F))` with the same `(Spec ψ)_*(tilde (N ⊗_R R'))` affine form — this is the
  -- RHS leaf `pushPullObj_coverInter_baseChanged_pushforward_iso_tilde` (currently a sorry, blocked
  -- on the X-level open-immersion Beck–Chevalley `openImmersion_beckChevalley`, whose STAGE 1 is a
  -- living `mateEquiv`-based telescope sorry-free, reduced to the single residual `IsIso bareBC`
  -- node = the Stacks-01HQ pullback-section Mathlib gap) — and to close the affine gap
  -- `g^*((Spec φ)_*(tilde N)) ≅
  -- (Spec ψ)_*(tilde (N ⊗_R R'))` via the sorry-free affine brick `cech_degree_affine_baseChange`
  -- for the ring pushout square CARVED by `restrictedCartesianAffinePushout g' 𝒰 σ` + the global
  -- sections of `Γ` (`CommRingCat.isPushout_iff_isPushout`).  The abstract base `S, S'` must also be
  -- transported to `Spec R, Spec R'` via the affine bridges for `g` and `f'` (the same `S'.isoSpec`
  -- conjugation as on the LHS).  Both pieces remain open; the LHS reduction above is landed.
  sorry

/-- **Beck–Chevalley natural iso through the Čech nerve** (Stacks 02KG, genuine content).
Whiskered through the Čech nerve, the cosimplicial `O_{S'}`-module obtained by pushing the
nerve forward along `f` and then pulling back along `g` is naturally isomorphic to the one
obtained by first pulling back along `g'` (at the `X`-level) and then pushing forward along
`f'`:
```
  g^* ∘ (pushforward f) ∘ drop(nerve 𝒰 F)  ≅  (pushforward f') ∘ g'^* ∘ drop(nerve 𝒰 F).
```
This is the Beck–Chevalley comparison for the cartesian square `h`, valid at every
cosimplicial degree. Each cosimplicial degree of the Čech nerve is a finite affine
intersection `U_{i₀…iₚ}` over which the cartesian square restricts to the affine pushout
square, so degreewise the asserted isomorphism is the sorry-free affine termwise base change
`affinePushforwardPullbackBaseChange` (FlatBaseChange.lean), assembled from the concrete tilde
dictionaries `pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` and the commutative-algebra
cancellation `cancelBaseChange` — *not* the canonical adjoint mate `pushforwardBaseChangeMap`.
Cosimplicial naturality is restriction along inclusions of finite affine intersections.

*(STUB — the multi-hundred-LOC Beck–Chevalley heart. The decomposition is in place: this is
the genuine open content of 02KG/02KH; the residual `sorry` is the degreewise + naturality
assembly of `affinePushforwardPullbackBaseChange`.)* Project-local. -/
noncomputable def cech_pushforward_baseChange_natIso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    [IsSeparated f] [IsAffine S] [IsAffine S'] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((CosimplicialObject.whiskering S.Modules S'.Modules).obj
        (Scheme.Modules.pullback g)).obj
      (((CosimplicialObject.whiskering X.Modules S.Modules).obj
          (Scheme.Modules.pushforward f)).obj
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
      ≅ ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
          (Scheme.Modules.pushforward f')).obj
        (((CosimplicialObject.whiskering X.Modules X'.Modules).obj
            (Scheme.Modules.pullback g')).obj
          (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))) :=
  -- The natural iso is constructed degreewise via `NatIso.ofComponents`.
  --
  -- COPRODUCT/PRODUCT LAYER — NOW CLOSED (compiling).  The degree-`n` fibre power
  -- `Yₙ = (coverCechNerveOver 𝒰).obj (op n)` is the coproduct `∐_σ U_σ` over index tuples
  -- `σ : Fin (n.len + 1) → 𝒰.I₀` of the intersection opens `U_σ = coverInterOpen 𝒰 σ`, so the
  -- push–pull object decomposes as a product `pushPullObj F Yₙ ≅ ∏_σ pushPullObj F (Over.mk j_σ)`
  -- by the sorry-free `pushPull_sigma_iso` (needs `[Finite 𝒰.I₀]`).  Both `pushforward` and
  -- `pullback` preserve this finite product (`PreservesProduct.iso`), so the degree-`n` `app`
  -- reduces *mechanically* (no remaining cosimplicial/sheaf plumbing) to the per-σ single-open
  -- base-change iso `pushPullObj_coverInter_baseChange`.
  --
  -- RESIDUAL (per-σ, the genuine open content): `pushPullObj_coverInter_baseChange` — the
  -- single-intersection-open S-level base change, dischargeable via the bridge
  -- `pushPullObj_pushforward_iso_tilde` (altitude 2) + the affine brick
  -- `cech_degree_affine_baseChange`; its body carries the affine-pushout-square-extraction sorry.
  -- `naturality` is the index-omission restriction compatibility of those degreewise isos.
  NatIso.ofComponents
    (fun n =>
      (Scheme.Modules.pullback g).mapIso
          ((Scheme.Modules.pushforward f).mapIso (pushPull_sigma_iso 𝒰 F n.len)) ≪≫
        (Scheme.Modules.pullback g).mapIso
          (Limits.PreservesProduct.iso (Scheme.Modules.pushforward f) _) ≪≫
        Limits.PreservesProduct.iso (Scheme.Modules.pullback g) _ ≪≫
        Limits.Pi.mapIso (fun σ => pushPullObj_coverInter_baseChange f g f' g' h 𝒰 F hF σ) ≪≫
        (Limits.PreservesProduct.iso (Scheme.Modules.pushforward f') _).symm ≪≫
        (Scheme.Modules.pushforward f').mapIso
          (Limits.PreservesProduct.iso (Scheme.Modules.pullback g') _).symm ≪≫
        (Scheme.Modules.pushforward f').mapIso
          ((Scheme.Modules.pullback g').mapIso (pushPull_sigma_iso 𝒰 F n.len).symm))
    (fun {n m} φ => sorry)

/-- For a finite family of opens, the lattice infimum has carrier the set intersection
(`⨅` over a `Finite` index is the finite intersection, which is again open).  Project-local
topology helper used by `coverInterOpen_baseChange_eq`. -/
private theorem coe_iInf_of_finite {Y : Scheme.{u}} {κ : Type} [Finite κ]
    (U : κ → Y.Opens) :
    (↑(⨅ k, U k) : Set Y) = ⋂ k, (↑(U k) : Set Y) := by
  apply subset_antisymm
  · exact Set.subset_iInter fun k => SetLike.coe_subset_coe.mpr (iInf_le U k)
  · have hopen : IsOpen (⋂ k, (↑(U k) : Set Y)) := isOpen_iInter_of_finite fun k => (U k).2
    have hO : (⟨⋂ k, (↑(U k) : Set Y), hopen⟩ : Y.Opens) ≤ ⨅ k, U k :=
      le_iInf fun k => Set.iInter_subset _ k
    exact SetLike.coe_subset_coe.mpr hO

/-- **The range of a base-changed cover member is the preimage of the original member's range.**
For the base-changed cover `𝒰' = (openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom`
of `X' = X ×_S S'`, the open `(𝒰'.f i).opensRange = (g')⁻¹((𝒰.f i).opensRange)`.  The member map
`𝒰'.f i` is the base change of the open immersion `𝒰.f i` along `g'` (the `openCoverOfLeft`
square, transported along the iso `X' ≅ pullback f g` to land on `g'`), so this is the
open-immersion base-change range identity
`IsOpenImmersion.image_preimage_eq_preimage_image_of_isPullback`.  Project-local; the per-member
content of `lem:coverinteropen_basechange_eq`. -/
private theorem coverOpen_baseChange_eq (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) (i : 𝒰.I₀) :
    (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom).f i).opensRange
      = g' ⁻¹ᵁ (𝒰.f i).opensRange := by
  -- expose the member of the base-changed cover as `oclf.f i ≫ (the iso)`
  have e1 : ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom).f i
      = (Scheme.Pullback.openCoverOfLeft 𝒰 f g).f i ≫ h.isoPullback.symm.hom := rfl
  -- mathlib's base-change square for `openCoverOfLeft` (cf. `Scheme.isPullback_of_openCover`)
  have hbase : IsPullback (pullback.fst (𝒰.f i ≫ f) g)
      ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).f i) (𝒰.f i) (pullback.fst f g) := by
    rw [Scheme.Pullback.openCoverOfLeft_f]
    refine IsPullback.of_bot ?_ ?_ (IsPullback.of_hasPullback f g)
    · have hs : pullback.map (𝒰.f i ≫ f) g f g (𝒰.f i) (𝟙 S') (𝟙 S) (by simp) (by simp) ≫
          pullback.snd f g = pullback.snd (𝒰.f i ≫ f) g := by rw [pullback.lift_snd]; simp
      rw [hs]; exact IsPullback.of_hasPullback (𝒰.f i ≫ f) g
    · rw [pullback.lift_fst]
  -- transport along the iso `pullback f g ≅ X'` so the bottom edge becomes `g'`
  have hsq : IsPullback (pullback.fst (𝒰.f i ≫ f) g)
      (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom).f i)
      (𝒰.f i) g' := by
    refine hbase.of_iso (Iso.refl _) (Iso.refl _) h.isoPullback.symm (Iso.refl _) ?_ ?_ ?_ ?_
    · simp
    · rw [Iso.refl_hom, Category.id_comp]; exact e1.symm
    · rw [Iso.refl_hom, Iso.refl_hom, Category.comp_id, Category.id_comp]
    · rw [Iso.refl_hom, Category.comp_id, Iso.symm_hom]; exact h.isoPullback_inv_fst.symm
  haveI hoi : IsOpenImmersion
      (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom).f i) :=
    Scheme.Cover.map_prop
      ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom) i
  haveI hoiV : IsOpenImmersion (𝒰.f i) := Scheme.Cover.map_prop 𝒰 i
  -- the open-immersion base-change range identity for the cartesian square `hsq`
  have key := @AlgebraicGeometry.IsOpenImmersion.image_preimage_eq_preimage_image_of_isPullback
    X' X _ _ g' (pullback.fst (𝒰.f i ≫ f) g)
    (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom).f i)
    (𝒰.f i) hoiV hoi hsq ⊤
  rw [Scheme.Hom.preimage_top] at key
  rw [(@Scheme.Hom.image_top_eq_opensRange _ _ _ hoi).symm,
    (@Scheme.Hom.image_top_eq_opensRange _ _ (𝒰.f i) hoiV).symm]
  exact key

/-- **The base-changed cover intersection is the preimage of the intersection** (Stacks 02KG;
carved block `lem:coverinteropen_basechange_eq`).  For the base-changed cover
`𝒰' = (openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom` of `X' = X ×_S S'` and a
*finite* index family `σ : κ → 𝒰.I₀`, the Čech intersection open of `𝒰'` is the `g'`-preimage of
the intersection open of `𝒰`:
```
  coverInterOpen 𝒰' σ = (g')⁻¹(coverInterOpen 𝒰 σ).
```
Per member `coverOpen_baseChange_eq` gives the preimage identity, and preimage commutes with the
finite intersection (`coe_iInf_of_finite` + `Set.preimage_iInter`).  Finiteness of `κ` is genuinely
needed (the `Opens.map` frame hom preserves only *finite* meets); the Čech use is over
`Fin (n+1)`.  Project-local; blueprint `lem:coverinteropen_basechange_eq`. -/
theorem coverInterOpen_baseChange_eq (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) {κ : Type} [Finite κ] (σ : κ → 𝒰.I₀) :
    coverInterOpen ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom) σ
      = g' ⁻¹ᵁ coverInterOpen 𝒰 σ := by
  apply TopologicalSpace.Opens.ext
  rw [coverInterOpen, coverInterOpen, coe_iInf_of_finite, TopologicalSpace.Opens.map_coe,
    coe_iInf_of_finite, Set.preimage_iInter]
  refine Set.iInter_congr fun k => ?_
  have hk := coverOpen_baseChange_eq f g f' g' h 𝒰 (σ k)
  simp only [coverOpen]
  rw [hk, TopologicalSpace.Opens.map_coe]

/-- **Bare Beck–Chevalley mate** for the restricted cartesian square `IsPullback gV p' p g'`
(`gV ≫ p = p' ≫ g'`).  This is the canonical base-change natural transformation
`g'^* ∘ p_* ⟶ p'_* ∘ gV^*` obtained as the *mate* (Beck–Chevalley transform) — under the
`pullback ⊣ pushforward` adjunctions for `p` and `p'` — of the canonical pullback 2-isomorphism
`pullback g' ⋙ pullback p' ≅ pullback p ⋙ pullback gV` coming from `p' ≫ g' = gV ≫ p`.

This natural transformation always exists (no flatness, no open-immersion hypothesis): it is the
*comparison map* whose being an iso is the genuine Beck–Chevalley content.  It is a 6-line local
restatement of the (sorry-tainted-`QuotScheme`) `canonicalBaseChangeMap` so that this file does
not import `QuotScheme`.  Project-local; blueprint `lem:openimm_beckchevalley` (mate). -/
noncomputable def openImmersion_bareBC {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') :
    pushforward p ⋙ Scheme.Modules.pullback g' ⟶
      Scheme.Modules.pullback gV ⋙ pushforward p' :=
  CategoryTheory.mateEquiv
    (pullbackPushforwardAdjunction p)
    (pullbackPushforwardAdjunction p')
    (((pullbackComp p' g') ≪≫
      pullbackCongr hsq.w.symm ≪≫
      (pullbackComp gV p).symm).hom)

/-- **Pullback telescope across the restricted cartesian square** (the pseudofunctor leg of the
open-immersion Beck–Chevalley).  Using only the pseudofunctor structure of `pullback`
(`pullbackComp`, `pullbackCongr`) and the square equation `p' ≫ g' = gV ≫ p`, the iterated
pullback `p'^*(g'^* F)` is canonically isomorphic to `gV^*(p^* F)`:
```
  p'^*(g'^* F) ≅ (p' ≫ g')^* F = (gV ≫ p)^* F ≅ gV^*(p^* F).
```
Sorry-free, build-cheap (no flatness, no affineness).  Together with `openImmersion_bareBC` this
collapses `openImmersion_beckChevalley` to the single obligation `IsIso (openImmersion_bareBC …)`.
Project-local; blueprint `lem:openimm_beckchevalley` (telescope). -/
noncomputable def openImmersion_bc_telescope {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') (F : X.Modules) :
    (Scheme.Modules.pullback p').obj ((Scheme.Modules.pullback g').obj F) ≅
      (Scheme.Modules.pullback gV).obj ((Scheme.Modules.pullback p).obj F) :=
  ((pullbackComp p' g') ≪≫
      pullbackCongr hsq.w.symm ≪≫
      (pullbackComp gV p).symm).app F

/-- **The base-changed edge `p'` of the restricted cartesian square is an open immersion.**
For the cartesian square `hsq : IsPullback gV p' p g'` (so `p' : V' ⟶ X'` is the base change of
`p` along `g'`), if `p` is an open immersion then so is `p'` — open immersions are stable under
base change (`MorphismProperty.IsStableUnderBaseChange @IsOpenImmersion`).  This is the
open-immersion-ness of the *left* edge of the square that the sectionwise cover-refinement route
of `openImmersion_beckChevalley` (Stage 2) consumes: it is what lets `pushforward p'` / `pullback p'`
be identified with restriction along `p'` (`restrictFunctorIsoPullback p'`) on the target side of
the bare Beck–Chevalley mate.  Project-local; blueprint `lem:openimm_beckchevalley` (left-edge
open-immersion side-condition). -/
theorem isOpenImmersion_of_isPullback_left {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') [IsOpenImmersion p] : IsOpenImmersion p' :=
  MorphismProperty.IsStableUnderBaseChange.of_isPullback hsq ‹IsOpenImmersion p›

/-! ## Stage-2 reduction: the bare mate factors as `unit ≫ iso`

The mate formula (`mateEquiv_apply`) exhibits `openImmersion_bareBC` at each object `c` as
```
  unit_{p'} (g'^*(p_* c)) ≫ p'_*(telescope-iso) ≫ p'_*(gV^*(counit_p c)).
```
For an *open immersion* `p`, the counit of the geometric adjunction
`pullback p ⊣ pushforward p` is an isomorphism — it is conjugate, under the
`leftAdjointUniq` comparison `restrictFunctorIsoPullback p`, to the counit of the
site-level `restrictAdjunction p`, invertible in Mathlib.  Hence the *only* non-iso
factor is the leading `p'`-unit, and `IsIso (bareBC.app c)` collapses to the single
node `IsIso (unit_{p'}.app (g'^*(p_* c)))` — "`g'^*(p_* c)` is in the essential image
of `p'_*`".  This is a strict sharpening of the blueprint Stage-2 chain
(`lem:openimm_bareBC_isIso`): the legs-are-restrictions reduction
(`lem:openimm_bareBC_legs_restriction`) is here replaced by the exact mate
factorization, so the member/assembly work only ever has to handle the unit. -/

set_option backward.isDefEq.respectTransparency false in
/-- **The geometric counit at an open immersion is an isomorphism.**  For an open
immersion `q`, the counit `q^*(q_* c) ⟶ c` of the geometric adjunction
`pullback q ⊣ pushforward q` is invertible: by
`Adjunction.leftAdjointUniq_hom_app_counit` it factors the counit of the site-level
`restrictAdjunction q` — an isomorphism in Mathlib (`restrictFunctorAdjCounitIso`) —
through the `leftAdjointUniq` comparison (`restrictFunctorIsoPullback q`, an iso).
Project-local; blueprint `lem:openimm_pullback_counit_isIso`. -/
theorem openImmersion_pullback_counit_isIso {V : Scheme.{u}} (q : V ⟶ X)
    [IsOpenImmersion q] (c : V.Modules) :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction q).counit.app c) := by
  haveI hnat : IsIso ((Scheme.Modules.restrictAdjunction q).counit) :=
    inferInstanceAs (IsIso (Scheme.Modules.restrictFunctorAdjCounitIso q).hom)
  haveI happ : IsIso ((Scheme.Modules.restrictAdjunction q).counit.app c) :=
    NatIso.isIso_app_of_isIso _ c
  exact IsIso.of_isIso_fac_left (Adjunction.leftAdjointUniq_hom_app_counit
    (Scheme.Modules.restrictAdjunction q) (Scheme.Modules.pullbackPushforwardAdjunction q) c)

set_option backward.isDefEq.respectTransparency false in
/-- **Mate factorization of the bare Beck–Chevalley comparison.**  At each `c : V.Modules`
the mate `openImmersion_bareBC` is, per the `mateEquiv` formula, the `p'`-unit at
`g'^*(p_* c)` followed by `p'_*` of the three pullback-telescope iso components and
`p'_*(gV^*(-))` of the `p`-counit.  Every factor after the unit is an isomorphism.
Project-local; blueprint `lem:openimm_bareBC_isIso` (factorization). -/
theorem openImmersion_bareBC_app_eq {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') (c : V.Modules) :
    (openImmersion_bareBC g' p p' gV hsq).app c =
      (Scheme.Modules.pullbackPushforwardAdjunction p').unit.app
          ((Scheme.Modules.pullback g').obj ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map
          ((pullbackComp p' g').hom.app ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map
          ((pullbackCongr hsq.w.symm).hom.app ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map
          ((pullbackComp gV p).inv.app ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map ((Scheme.Modules.pullback gV).map
          ((Scheme.Modules.pullbackPushforwardAdjunction p).counit.app c)) := by
  simp [openImmersion_bareBC, mateEquiv_apply]
  erw [Category.id_comp, Category.id_comp, Category.comp_id]
  rfl

set_option backward.isDefEq.respectTransparency false in
/-- **`IsIso bareBC` collapses to the unit node.**  Since the telescope components and the
`p`-counit factor (`openImmersion_pullback_counit_isIso`) are isomorphisms, the mate
`openImmersion_bareBC` is an isomorphism at `c` as soon as the `p'`-unit is one at
`g'^*(p_* c)` — i.e. as soon as `g'^*(p_* c)` lies in the essential image of `p'_*`.
Project-local; blueprint `lem:openimm_bareBC_isIso` (reduction). -/
theorem openImmersion_bareBC_app_isIso_of_unit {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') [IsOpenImmersion p] (c : V.Modules)
    (hu : IsIso ((Scheme.Modules.pullbackPushforwardAdjunction p').unit.app
      ((Scheme.Modules.pullback g').obj ((Scheme.Modules.pushforward p).obj c)))) :
    IsIso ((openImmersion_bareBC g' p p' gV hsq).app c) := by
  rw [openImmersion_bareBC_app_eq]
  haveI := hu
  haveI := openImmersion_pullback_counit_isIso p c
  infer_instance

/-- **Unit-iso from essential-image membership** (open-immersion case).  For an open
immersion `p'`, the pushforward `p'_*` is fully faithful (Mathlib instances on
`restrictAdjunction`), so by `Adjunction.isIso_unit_app_of_iso` the unit of
`pullback p' ⊣ pushforward p'` is an isomorphism at every module in the essential image
of `p'_*`.  Project-local; blueprint `lem:openimm_bareBC_isIso` (essential-image form). -/
theorem openImmersion_unit_isIso_of_essImage {V' : Scheme.{u}} (p' : V' ⟶ X')
    [IsOpenImmersion p'] (M : X'.Modules)
    (h : (Scheme.Modules.pushforward p').essImage M) :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction p').unit.app M) := by
  obtain ⟨K, ⟨e⟩⟩ := h
  exact (Scheme.Modules.pullbackPushforwardAdjunction p').isIso_unit_app_of_iso e.symm

/-! ## Project-local Mathlib supplement — refining affine cover for the open-immersion
Beck–Chevalley assembly (Stage-2 reduction of `openImmersion_beckChevalley`)

The `IsIso bareBC` residual of `openImmersion_beckChevalley` is checked *cover-locally* on `X'`
(keystone `Scheme.Modules.Hom.isIso_iff_isIso_restrict`).  This section supplies the geometric
input for that assembly: an affine open cover `{Wⱼ}` of `X'` such that each `g'|_{Wⱼ}` lands in an
affine open `Uⱼ ⊆ X` (so `g'|_{Wⱼ}` is a map of affine schemes, a `Spec`-map).  It is pure geometry
(no flatness, no quasi-coherence), obtained by pulling the standard affine cover of `X` back along
`g'` and refining each preimage to affine members. -/

/-- **Packaged output of `openImmersion_refiningAffineCover`.**  An affine open cover of `X'`
together with, for each member `Wⱼ`, an affine open `Uⱼ ⊆ X` containing the image `g'(Wⱼ)` (recorded
as the range containment `Set.range (Wⱼ.f ≫ g').base ⊆ Uⱼ`).  Project-local packaging of the
Stage-2 geometric datum of `openImmersion_beckChevalley`; blueprint
`lem:openimm_refining_affine_cover`. -/
structure OpenImmersionRefiningAffineCover (g' : X' ⟶ X) where
  /-- the affine open cover of `X'`. -/
  cover : X'.OpenCover
  /-- every member of `cover` is affine. -/
  isAffine_cover : ∀ j, IsAffine (cover.X j)
  /-- the containing affine open of `X` for each member. -/
  U : cover.I₀ → X.Opens
  /-- each `U j` is an affine open. -/
  isAffineOpen_U : ∀ j, IsAffineOpen (U j)
  /-- the image `g'(Wⱼ)` is contained in `U j`. -/
  le_U : ∀ j, Set.range (cover.f j ≫ g').base ⊆ (U j : Set X)

/-- The pullback of the standard affine cover of `X` along `g'`, refined to affine members. -/
private noncomputable abbrev pullbackAffineRefinementCover (g' : X' ⟶ X) : X'.OpenCover :=
  (Scheme.OpenCover.affineRefinement (X.affineOpenCover.openCover.pullback₁ g')).openCover

set_option backward.isDefEq.respectTransparency false in
/-- **Affine cover of `X'` refining preimages of affine opens of `X`** (blueprint
`lem:openimm_refining_affine_cover`).  For any `g' : X' ⟶ X` there is an affine open cover `{Wⱼ}` of
`X'` together with, for each `j`, an affine open `Uⱼ ⊆ X` with `g'(Wⱼ) ⊆ Uⱼ`; hence `g'|_{Wⱼ}` is a
map of affine schemes.  Constructed by pulling `X.affineOpenCover` back along `g'`
(`OpenCover.pullback₁`) — whose member over index `i` maps, via `Cover.pullbackHom`, into the affine
`X.affineOpenCover.X i` — and refining each (possibly non-affine) preimage member to affine pieces
(`OpenCover.affineRefinement`).  The containment is the range monotonicity
`Set.range (φ ≫ g'(=…≫ Uᵢ.ι)).base ⊆ Set.range Uᵢ.ι.base = Uᵢ`.  Pure geometry — no flatness or
quasi-coherence.  Project-local: the Stage-2 geometric input of `openImmersion_beckChevalley`. -/
noncomputable def openImmersion_refiningAffineCover (g' : X' ⟶ X) :
    OpenImmersionRefiningAffineCover g' where
  cover := pullbackAffineRefinementCover g'
  isAffine_cover j := by infer_instance
  U j := (X.affineOpenCover.openCover.f j.1).opensRange
  isAffineOpen_U j := isAffineOpen_opensRange _
  le_U j := by
    have hcomp : (pullbackAffineRefinementCover g').f j ≫ g'
        = (((X.affineOpenCover.openCover.pullback₁ g').X j.1).affineCover.f j.2
            ≫ X.affineOpenCover.openCover.pullbackHom g' j.1)
          ≫ X.affineOpenCover.openCover.f j.1 := by
      have hf : (pullbackAffineRefinementCover g').f j
          = ((X.affineOpenCover.openCover.pullback₁ g').X j.1).affineCover.f j.2
          ≫ (X.affineOpenCover.openCover.pullback₁ g').f j.1 := rfl
      rw [hf, Category.assoc, ← Scheme.Cover.pullbackHom_map, ← Category.assoc]
    rintro x ⟨y, rfl⟩
    rw [SetLike.mem_coe, Scheme.Hom.mem_opensRange]
    exact ⟨(((X.affineOpenCover.openCover.pullback₁ g').X j.1).affineCover.f j.2
            ≫ X.affineOpenCover.openCover.pullbackHom g' j.1).base y,
      by rw [hcomp, Scheme.Hom.comp_base]; rfl⟩

/-- **Open-immersion Beck–Chevalley over a restricted cartesian square** (Stacks 02KG; carved
block `lem:openimm_beckchevalley`).  Let `p : V ⟶ X` be an *open immersion* and let the square
```
  V' --gV--> V
  |p'        |p
  v          v
  X' --g'--> X
```
be cartesian (`hsq`), so `p'` is the open immersion onto the preimage `(g')⁻¹(V)`.  Then there is
a Beck–Chevalley isomorphism of `O_{X'}`-modules
```
  (g')^*(p_* p^* F) ≅ p'_* p'^*((g')^* F),
```
i.e. `(pullback g').obj (pushPullObj F (Over.mk p)) ≅ pushPullObj ((pullback g').obj F)
(Over.mk p')`.

**STAGE 1 (landed, sorry-free): structural reduction.**  The body is built as
`asIso (openImmersion_bareBC … |>.app (p^* F)) ≪≫ (pushforward p').mapIso (telescope).symm`,
where `telescope = openImmersion_bc_telescope …` rewrites the RHS pullback `p'^*(g'^* F)` into
`gV^*(p^* F)` purely by the pseudofunctor structure of `pullback`.  This collapses the leaf to the
**single residual obligation** `IsIso ((openImmersion_bareBC g' p p' gV hsq).app (p^* F))` — the
bare Beck–Chevalley comparison being an iso.

**STAGE 2 (mate factorization LANDED; residual = the essential-image node).**  The mate formula
(`openImmersion_bareBC_app_eq`) factors `bareBC.app (p^* F)` as the `p'`-unit at
`g'^*(p_*(p^* F))` followed by isomorphisms (the pullback-telescope components and the `p`-counit,
invertible for open immersions by `openImmersion_pullback_counit_isIso`).  Since `p'_*` is fully
faithful for the open immersion `p'`, the unit is an isomorphism at every module in the essential
image of `p'_*` (`openImmersion_unit_isIso_of_essImage`), so the SOLE residual obligation is the
essential-image node `openImmersion_pushPull_essImage`:
`g'^*(p_*(p^* F)) ∈ essImage p'_*`.  (The earlier docstring sketch "`p_*` is extension-by-zero
off `V`" was mathematically WRONG — `p_*` is the *right adjoint* direct image; the off-`V'` data
is real and is exactly what the essential-image node encodes.)  Project-local; blueprint
`lem:openimm_beckchevalley`. -/
/-- **The essential-image node** (the genuine Stage-2 frontier, post mate-factorization).
For the restricted cartesian square `hsq : IsPullback gV p' p g'` with `p` an open
immersion, `V` affine, `X` separated and `F` quasi-coherent, the pulled-back push–pull
module `g'^*(p_*(p^* F))` lies in the essential image of `p'_*` — its sections over
`U ⊆ X'` are already determined by those over `U ∩ (g')⁻¹(V)`.  This is now the SOLE
open obligation of `openImmersion_beckChevalley` (hence of `IsIso bareBC`): a bare
existence statement `∃ K, p'_* K ≅ g'^*(p_*(p^* F))`, with no residual mate/adjunction
matching.

*(STUB — the hypotheses are exactly those under which the statement is true (the
arbitrary-`F` form is FALSE, see the blueprint remark at `lem:openimm_beckchevalley`).
Intended route (blueprint `lem:openimm_bareBC_app_isIso_affine`): the candidate `K` is
`gV^*(p^* F)`; comparing `p'_*(gV^*(p^* F))` with `g'^*(p_*(p^* F))` is iso-ness of a
GLOBAL map only over a cover, so instead one shows directly that the *unit-style*
restriction comparison for `M = g'^*(p_*(p^* F))` is an isomorphism cover-locally: check
on the refining affine cover `openImmersion_refiningAffineCover g'`
(`isIso_iff_isIso_restrict`); over each member `W_j = Spec B` with `g'(W_j) ⊆ U_j =
Spec A`, the restriction `M|_{W_j}` is `(g'|_{W_j})^*((p_* p^* F)|_{U_j})` (pullback
pseudofunctor), `(p_* p^* F)|_{U_j} = (V∩U_j ↪ U_j)_*(p^*F|_{V∩U_j})` (open-open
pushforward–restriction commutation, the `glueOverlapBaseChangeIso` pattern of
`Picard/GlueDescent`), `V ∩ U_j` is affine (`X` separated), so the fully-affine brick
`affinePushforwardPullbackBaseChange` + the tilde dictionary `qcoh_iso_tilde_sections`
exhibit `M|_{W_j}` as a pushforward from `W_j ∩ (g')⁻¹(V)`.)*
Project-local; blueprint `lem:openimm_bareBC_isIso` (essential-image node). -/
theorem openImmersion_pushPull_essImage {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') [IsOpenImmersion p] [IsAffine V]
    [IsSeparated (terminal.from X)] (F : X.Modules) (hF : F.IsQuasicoherent) :
    (Scheme.Modules.pushforward p').essImage
      ((Scheme.Modules.pullback g').obj ((Scheme.Modules.pushforward p).obj
        ((Scheme.Modules.pullback p).obj F))) := by
  sorry

/-- **The unit node**, derived from the essential-image node
(`openImmersion_pushPull_essImage` + `openImmersion_unit_isIso_of_essImage`): for the
restricted cartesian square with `p` an open immersion, `V` affine, `X` separated and `F`
quasi-coherent, the `p'`-unit is an isomorphism at `g'^*(p_*(p^* F))`.  No `sorry` of its
own.  Project-local; blueprint `lem:openimm_bareBC_isIso` (unit node). -/
theorem openImmersion_pushPull_unit_isIso {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') [IsOpenImmersion p] [IsAffine V]
    [IsSeparated (terminal.from X)] (F : X.Modules) (hF : F.IsQuasicoherent) :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction p').unit.app
      ((Scheme.Modules.pullback g').obj ((Scheme.Modules.pushforward p).obj
        ((Scheme.Modules.pullback p).obj F)))) := by
  haveI : IsOpenImmersion p' := isOpenImmersion_of_isPullback_left g' p p' gV hsq
  exact openImmersion_unit_isIso_of_essImage p' _
    (openImmersion_pushPull_essImage g' p p' gV hsq F hF)

noncomputable def openImmersion_beckChevalley {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') [IsOpenImmersion p] [IsAffine V]
    [IsSeparated (terminal.from X)] (F : X.Modules) (hF : F.IsQuasicoherent) :
    (Scheme.Modules.pullback g').obj (pushPullObj F (Over.mk p)) ≅
      pushPullObj ((Scheme.Modules.pullback g').obj F) (Over.mk p') := by
  -- STAGE 1 (sorry-free): the pseudofunctor telescope reduces the leaf to one `IsIso` on the
  -- bare mate `openImmersion_bareBC … |>.app (p^* F)`.
  haveI hiso : IsIso ((openImmersion_bareBC g' p p' gV hsq).app
      ((Scheme.Modules.pullback p).obj F)) :=
    -- STAGE 2 (mate factorization landed): the telescope component and the `p`-counit factor
    -- are isos (`openImmersion_bareBC_app_isIso_of_unit`), so the comparison is an iso as soon
    -- as the `p'`-unit is one at `g'^*(p_*(p^* F))` — the residual unit node
    -- `openImmersion_pushPull_unit_isIso`.
    openImmersion_bareBC_app_isIso_of_unit g' p p' gV hsq _
      (openImmersion_pushPull_unit_isIso g' p p' gV hsq F hF)
  exact (@asIso _ _ _ _ ((openImmersion_bareBC g' p p' gV hsq).app
      ((Scheme.Modules.pullback p).obj F)) hiso) ≪≫
    ((pushforward p').mapIso (openImmersion_bc_telescope g' p p' gV hsq F)).symm

/-- **Per-intersection-open X-level Beck–Chevalley** (the per-σ residual of the X-level leaf
`twisted_cech_nerve_iso`, after the product decomposition `pushPull_sigma_iso`).  For a Čech
fibre-power intersection open `U_σ = coverInterOpen 𝒰 σ ↪ X` (open immersion `j_σ`), pulling the
single-open push–pull object `pushPullObj F (Over.mk j_σ) = (j_σ)_* (j_σ)^* F` back along `g'`
is the push–pull object of the base-changed data `(g'^* F)` over the corresponding intersection
`U'_σ = coverInterOpen 𝒰' σ ↪ X'` of the base-changed cover
`𝒰' = (openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom`:
```
  g'^*((j_σ)_* (j_σ)^* F)  ≅  (j'_σ)_* (j'_σ)^* (g'^* F)        over U'_σ.
```
This is the open-immersion Beck–Chevalley identification for the cartesian square cut out over
`U_σ` (`X`-level square, no base affineness): geometrically `U'_σ = (g')⁻¹(U_σ)` (pullback
preserves the fibre powers `U_{i₀} ×_X ⋯ ×_X U_{iₚ}`), so the restricted square is cartesian and
the push–pull of the restriction commutes with `g'^*`.  The residual `sorry` is exactly that
cover-base-change identification `coverInterOpen 𝒰' σ = (g')⁻¹(coverInterOpen 𝒰 σ)` together with
the open-immersion Beck–Chevalley for the restricted square — the genuine open content of this
leaf, blueprinted `lem:twisted_cech_nerve_iso` (per-open instance).  Project-local. -/
noncomputable def twisted_cech_nerve_per_sigma
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) {κ : Type} [Finite κ] [Nonempty κ]
    (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pullback g').obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅
      pushPullObj ((Scheme.Modules.pullback g').obj F)
        (Over.mk (Scheme.Opens.ι (coverInterOpen
          ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom) σ))) :=
  -- RESIDUAL (the X-level open content) — now reduced to two CLOSED carved blocks + a transport:
  --   (1) the restricted cartesian square over `U_σ = coverInterOpen 𝒰 σ` is supplied by the
  --       sorry-free `restrictedCartesianAffinePushout g' 𝒰 σ`
  --       (`IsPullback (pullback.snd g' (ι U_σ)) (pullback.fst g' (ι U_σ)) (ι U_σ) g'`);
  --   (2) `openImmersion_beckChevalley g' (ι U_σ) (pullback.fst g' (ι U_σ)) (pullback.snd …) (…) F`
  --       gives `g'^*(pushPullObj F (Over.mk (ι U_σ))) ≅ pushPullObj (g'^*F)
  --       (Over.mk (pullback.fst g' (ι U_σ)))`;
  --   (3) `pullback.fst g' (ι U_σ)` and `ι (coverInterOpen 𝒰' σ)` are open immersions with the SAME
  --       range `(g')⁻¹(U_σ)` — by `Scheme.Hom.opensRange_pullbackFst` and the CLOSED
  --       `coverInterOpen_baseChange_eq` (needs `[Finite κ]`) — so an `IsOpenImmersion.isoOfRangeEq`
  --       transports the `pushPullObj` to the asserted `Over.mk (ι (coverInterOpen 𝒰' σ))` form.
  -- Only `openImmersion_beckChevalley` (the open-immersion Beck–Chevalley sheaf iso) remains a leaf.
  sorry

/-- **The base-changed nerve is the nerve of the base-changed data** (Stacks 02KG, the
mechanical half). Applying `(g')^*` (at the `X`-level) to the dropped Čech nerve of
`(𝒰, F)` yields the dropped Čech nerve of the base-changed data `(𝒰', (g')^* F)`, where
`𝒰' = (openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom` is the base change of
`𝒰` along `g'`:
```
  g'^* ∘ drop(nerve 𝒰 F)  ≅  drop(nerve 𝒰' (g'^* F)).
```
The geometric backbone `coverCechNerve` of `𝒰` base-changes to that of `𝒰'`: the fibre
powers `U_{i₀} ×_X ⋯ ×_X U_{iₚ}` commute with the base change `g'` (pullback preserves fibre
products), so the preimages `(g')⁻¹(U_{i₀…iₚ})` are exactly the corresponding intersections
of `𝒰'`. The pullback then commutes with the push–pull functor `pushPullFunctor` termwise —
itself a Beck–Chevalley identification `g'^* (p_* p^* F) ≅ p'_* p'^* (g'^* F)` for the
restricted cartesian square — and the identifications are compatible with the cosimplicial
structure maps because both are induced by the same inclusions of intersections.

*(STUB — the residual `sorry` is the termwise commuting of `g'^*` with `pushPullFunctor`
along the base-changed fibre powers; structurally lighter than
`cech_pushforward_baseChange_natIso` but still a Beck–Chevalley identification.)*
Project-local. -/
noncomputable def twisted_cech_nerve_iso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    [IsSeparated f] [IsAffine S] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((CosimplicialObject.whiskering X.Modules X'.Modules).obj
        (Scheme.Modules.pullback g')).obj
      (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))
      ≅ CosimplicialObject.Augmented.drop.obj
          (CechNerve ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
            h.isoPullback.symm.hom) ((Scheme.Modules.pullback g').obj F)) :=
  -- LHS COPRODUCT/PRODUCT LAYER — NOW CLOSED (compiling).  The degree-`n` `app` obligation is the
  -- X-level Beck–Chevalley iso
  --     `(pullback g').obj (pushPullObj F Yₙ) ≅ pushPullObj (g'^* F) Y'ₙ`
  -- (`g'^*(p_* p^* F) ≅ p'_* p'^*(g'^* F)`), where `Yₙ = (coverCechNerveOver 𝒰).obj (op n)` and
  -- `Y'ₙ = (coverCechNerveOver 𝒰').obj (op n)` for the base-changed cover `𝒰'`.  The LHS
  -- decomposes as a product over the index tuples `σ` via the sorry-free `pushPull_sigma_iso` and
  -- preservation of finite products by `pullback g'` (`PreservesProduct.iso`):
  --     LHS ≅ ∏_σ (pullback g').obj (pushPullObj F (Over.mk j_σ)).
  --
  -- RESIDUAL (the genuine open content + the RHS-matching obstruction): the remaining goal is
  --     `∏_σ (pullback g').obj (pushPullObj F (Over.mk j_σ)) ≅ pushPullObj (g'^* F) Y'ₙ`.
  -- The per-σ X-level Beck–Chevalley iso `(pullback g').obj (pushPullObj F (Over.mk j_σ)) ≅
  -- pushPullObj (g'^* F) (Over.mk j'_σ)` (base change of push–pull along the open immersion j_σ,
  -- for the restricted cartesian square over `U_σ`) is the per-σ content; reassembling the σ-product
  -- on the RHS would use `(pushPull_sigma_iso 𝒰' (g'^* F) n.len).symm`, but that needs
  -- `[Finite 𝒰'.I₀]` and `[∀ i, IsAffine (𝒰'.X i)]` for the base-changed cover `𝒰'`, which are NOT
  -- available in this signature (the X-level leaf carries no `[IsAffine S']`; the base-changed cover
  -- members' affineness is the geometric cover-base-change route `coverInterOpen 𝒰' σ = g'⁻¹(U_σ)`).
  -- That cover-base-change identification is the residual Beck–Chevalley heart of this leaf.
  -- STEP-1 sig extension landed `[Finite 𝒰'.I₀]`/`[∀ i, IsAffine (𝒰'.X i)]` for the base-changed
  -- cover `𝒰'`, so the σ-product on the RHS *can now* be reassembled by
  -- `(pushPull_sigma_iso 𝒰' (g'^* F) n.len).symm`.  The residual per-σ content is isolated into the
  -- named leaf `twisted_cech_nerve_per_sigma` (the open-immersion Beck–Chevalley + cover-base-change
  -- identification).  Only the cosimplicial `naturality` remains beyond that leaf.
  NatIso.ofComponents
    (fun n =>
      (Scheme.Modules.pullback g').mapIso (pushPull_sigma_iso 𝒰 F n.len) ≪≫
        Limits.PreservesProduct.iso (Scheme.Modules.pullback g') _ ≪≫
        Limits.Pi.mapIso (fun σ => twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F hF σ) ≪≫
        (pushPull_sigma_iso ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
          h.isoPullback.symm.hom) ((Scheme.Modules.pullback g').obj F) n.len).symm)
    (fun {n m} φ => sorry)

/-- **The cosimplicial Beck–Chevalley iso `e`** consumed by
`cechComplex_baseChange_iso_of_cosimplicialIso`. It is the whiskered composite of the
Beck–Chevalley natural iso `cech_pushforward_baseChange_natIso` with the twisted-nerve
identification `twisted_cech_nerve_iso` pushed forward along `f'`:
```
  e = cech_pushforward_baseChange_natIso ≪≫ (pushforward f')_* .mapIso twisted_cech_nerve_iso.
```
Project-local; isolates the open content into the two lemmas above. -/
noncomputable def cechComplex_baseChange_cosimplicialIso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    [IsSeparated f] [IsAffine S] [IsAffine S'] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((CosimplicialObject.whiskering S.Modules S'.Modules).obj
        (Scheme.Modules.pullback g)).obj
      (((CosimplicialObject.whiskering X.Modules S.Modules).obj
          (Scheme.Modules.pushforward f)).obj
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
      ≅ ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
          (Scheme.Modules.pushforward f')).obj
        (CosimplicialObject.Augmented.drop.obj
          (CechNerve ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
            h.isoPullback.symm.hom) ((Scheme.Modules.pullback g').obj F))) :=
  cech_pushforward_baseChange_natIso f g f' g' h 𝒰 F hF ≪≫
    ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
        (Scheme.Modules.pushforward f')).mapIso (twisted_cech_nerve_iso f g f' g' h 𝒰 F hF)

/-- **Tensorial base change of the Čech complex** (Stacks 02KG; *load-bearing*, OPEN).
Applying `g^*` degreewise to the relative Čech complex `Č•(𝒰, F)` yields the relative
Čech complex `Č•(𝒰', g'^* F)` of the base-changed data. Sorry-free *modulo* the cosimplicial
Beck–Chevalley iso `cechComplex_baseChange_cosimplicialIso`: the live route is the whiskered
composite of `cech_pushforward_baseChange_natIso` (degreewise → the per-σ affine-reduction heart
`pushPullObj_coverInter_baseChange`, which routes through the altitude-2 bridge
`pushPullObj_pushforward_iso_tilde` to the **sorry-free** affine termwise base change
`affinePushforwardPullbackBaseChange` via the carved ring-pushout `restrictedCartesianAffinePushout`)
with the twisted-nerve identification `twisted_cech_nerve_iso` (per-σ
`twisted_cech_nerve_per_sigma`, the X-level open-immersion Beck–Chevalley
`openImmersion_beckChevalley` over the cover-base-change identity `coverInterOpen_baseChange_eq`).
The route uses the concrete-tilde non-mate brick, NOT the walled adjoint-mate machinery. *(STUB —
the residual content is the named per-σ leaves above; the genuine open content of 02KH/02KG.)* -/
/- USER (Stacks 02KH leaf 2/2 — the LOAD-BEARING one, Stacks 02KG): close
   `affineBaseChange_pushforward_iso` (`Cohomology/FlatBaseChange.lean`) FIRST — that is
   the termwise affine `i = 0` base change over each finite affine intersection — then
   assemble the per-degree isos into a chain isomorphism compatible with the alternating
   Čech differentials, taking `𝒰'` = base change of `𝒰` along `g'`. Reference: Stacks
   02KG/02KH. Use the concrete-tilde isos, NOT the adjoint-mate machinery that walled FBC-B. -/
noncomputable def cechComplex_baseChange_iso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (CechComplex f 𝒰 F)
      ≅ CechComplex f'
          ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
          ((Scheme.Modules.pullback g').obj F) :=
  -- Reduced (iter-304) to the factoring lemma: the homology/differential plumbing is
  -- discharged, so the SOLE residual obligation is the cosimplicial Beck–Chevalley iso `e`
  -- (`g^* ∘ f_* ∘ nerve ≅ f'_* ∘ g'^* ∘ nerve'`). Decomposed (iter-315): `e` is supplied by
  -- `cechComplex_baseChange_cosimplicialIso`, the whiskered composite of the Beck–Chevalley
  -- natural iso `cech_pushforward_baseChange_natIso` with the twisted-nerve identification
  -- `twisted_cech_nerve_iso`. The monolithic sorry is thereby replaced by those two named,
  -- blueprinted residuals — the genuine open content of Stacks 02KG/02KH.
  cechComplex_baseChange_iso_of_cosimplicialIso f g f' g' h 𝒰 F
    (cechComplex_baseChange_cosimplicialIso f g f' g' h 𝒰 F hF)

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

We state the isomorphism as `Nonempty (… ≅ …)`; `𝒰` is a finite affine open cover of `X`,
and the cover of `X' = X ×_S S'` used on the right is its canonical base change along `g'`
(`Scheme.Pullback.openCoverOfLeft 𝒰 f g` transported to `X'` via `IsPullback.isoPullback`). -/
theorem cech_flatBaseChange
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        ((Scheme.Modules.pullback g').obj F) i) := by
  -- Re-wired (iter-304): the assembly is now sorry-free *modulo* the single load-bearing
  -- leaf-2 iso `cechComplex_baseChange_iso`. The two-step composite is:
  --   (1) `pullback_mapHC_homologyIso` (flat exactness, complex level) commuting `g^*` with
  --       Čech homology, and (2) `homologyMapIso` of the tensorial base-change iso
  --       `cechComplex_baseChange_iso`. `cechHigherDirectImage = (CechComplex …).homology i`
  --       definitionally, so the two endpoints match up to `rfl`.
  exact ⟨(pullback_mapHC_homologyIso g (CechComplex f 𝒰 F) i).symm ≪≫
    HomologicalComplex.homologyMapIso (cechComplex_baseChange_iso f g f' g' h 𝒰 F hF) i⟩

end AlgebraicGeometry
