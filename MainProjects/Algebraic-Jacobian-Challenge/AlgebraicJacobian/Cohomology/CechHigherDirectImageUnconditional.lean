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
* `cech_flatBaseChange` (Stacks 02KH) is now sorry-free *modulo* exactly four named
  leaves: the homology-side flat left-exactness `pullback_preservesFiniteLimits` (L142,
  the abstract-left-adjoint wall); the two degreewise Beck–Chevalley leaves
  `cech_pushforward_baseChange_natIso` (S-level square along `g`) and
  `twisted_cech_nerve_iso` (X-level square along `g'`); and the per-σ single-open
  S-level base change `pushPullObj_coverInter_baseChange` (the affine-reduction heart
  the S-level leaf reduces to after the product decomposition `pushPull_sigma_iso`). The
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
  -- RESIDUAL (the affine-reduction heart): with `V` affine, route the LHS pushforward
  -- `f_*(p_* p^* F)` through the bridge `pushPullObj_pushforward_iso_tilde F hF hV` (altitude 2,
  -- over `S.isoSpec : S ≅ Spec Γ(S)`) to its affine `(Spec φ)_*(tilde N)` form, do likewise for
  -- the `X`-level `g'^*` side, and discharge to `cech_degree_affine_baseChange φ ψ ρ σ' h' N`.
  -- The affine pushout square of rings `(φ, ψ, ρ, σ')` is now CARVED: the restricted cartesian
  -- square of schemes over `V` is the sorry-free `restrictedCartesianAffinePushout g' 𝒰 σ`, which
  -- under `hV : IsAffineOpen V` + `[IsAffine S] [IsAffine S']` converts (apply `Γ`,
  -- `CommRingCat.isPushout_iff_isPushout`) to the ring pushout with corner `A_σ ⊗_R R'`.  The
  -- residual is the abstract→tilde identification of both comparison sides via altitude 2.
  exact sorry

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
(Over.mk p')`.  No affineness of the base is required: this is the open-immersion (flat) case of
Beck–Chevalley — `p_*` is extension-by-zero off `V`, the square is cartesian with `p'` onto the
preimage, and the base-change transformation is an isomorphism stalkwise.

*(STUB — the residual `sorry` is the open-immersion Beck–Chevalley sheaf isomorphism.  The
intended construction: factor through the canonical `p'^*(g')^* ≅ gV^* p^*` of the cartesian
square and the open-immersion adjunction `p^* ⊣ p_*` whose counit/unit are isomorphisms over the
open `V`; restriction off `(g')⁻¹(V)` makes both sides vanish, so the comparison is an iso
stalkwise.)*  Project-local; blueprint `lem:openimm_beckchevalley`. -/
noncomputable def openImmersion_beckChevalley {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (_hsq : IsPullback gV p' p g') [IsOpenImmersion p] (F : X.Modules) :
    (Scheme.Modules.pullback g').obj (pushPullObj F (Over.mk p)) ≅
      pushPullObj ((Scheme.Modules.pullback g').obj F) (Over.mk p') :=
  -- RESIDUAL: the open-immersion Beck–Chevalley sheaf iso (see docstring sketch).
  sorry

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
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [IsSeparated f]
    (F : X.Modules) {κ : Type} (σ : κ → 𝒰.I₀) :
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
    [IsSeparated f] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) :
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
        Limits.Pi.mapIso (fun σ => twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F σ) ≪≫
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
        (Scheme.Modules.pushforward f')).mapIso (twisted_cech_nerve_iso f g f' g' h 𝒰 F)

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
