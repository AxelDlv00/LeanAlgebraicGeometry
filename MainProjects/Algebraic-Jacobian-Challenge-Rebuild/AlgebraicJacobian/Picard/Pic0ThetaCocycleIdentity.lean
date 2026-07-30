/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

/-!
# The θ-cocycle coherence of the degree-zero Picard functor (Wave 7, K-1)

For the base-field comparison θ of the degree-zero Picard functor
(`Picard/Pic0ThetaAssembly.lean`), this file proves the two coherences that make θ a
coherent system over the tower of field extensions — the datum-level θ-cocycle
consumed by the frozen `baseChangeIso_id`/`baseChangeIso_comp` at DAT-J:

* `AlgebraicGeometry.pic0Theta_id` — **the θ identity coherence**: `θ` over `k → k` is
  the trivial comparison, pinned against the frozen `baseChange.idIso` vehicle. The
  base-changed curve collapses to `C` (via `pic0PullbackNat` of `baseChange.idIso`) and
  the pushed test collapses to the test (`σ_{kk} = 𝟙`, `Over.mapId`).
* `AlgebraicGeometry.pic0Theta_comp` — **the θ cocycle coherence** over a tower
  `k → L → M`: `θ_{k,M} = θ_{k,L} ∘ θ_{L,M}` read across `Over.pullbackComp`, pinned
  against the frozen `baseChange.compIso` vehicle. The RHS transports the source along the
  curve `compIso` (an iso — hence `pic0PullbackNat`), applies `θ_{L,M}`, whiskers `θ_{k,L}`
  through `(Over.map σ_{LM}).op`, and reassociates the two σ-pushes into the single
  `σ_{kM}`-push (the `Over.mapComp` mirror of `compIso`).

Both equalities are stated in bundled `CommGrpCat`-natiso form with the RHSs assembled
through the frozen `baseChange.idIso`/`compIso` vehicles, and proved by reduction to
per-test-object components (`NatTrans.ext` + `CommGrpCat` `hom_ext`) then to the
underlying `picEt` classes (`Subtype.ext`), never a `Grp (Over …)` diagram chase. The
genuinely new content is the section-ring **cocycle over the tower**: the base-field
shuffle for `k → M` is the two-step `k → L` then `L → M`, a `restrictScalars`-tower
identity on `sectionShuffle`. Every seam-crossing step is term-mode (I-0216 notes 1–4).

The θ-cocycle is stated on the curve `C` alone — no `JacobianData` argument — since θ is a
functor comparison; the datum enters only at DAT-J (the W7 datum idiom, D1).

## STATUS (WORK IN PROGRESS — unrooted; two open `sorry`s)

**Corrected 2026-07-29 (run 0079, task `ajcr-w7-functor`).** The status block previously
here claimed the Leg-1..3 component reduction of `pic0Theta_id` was complete, with only a
Leg-4 `sorry` remaining. That was not the file's state:

* **`pic0Theta_id` ended in `by exact rfl` nested inside a bare `by` in tactic position
  (former :193), which is a SYNTAX ERROR** — `unexpected token 'by'; expected command`,
  reproduced at HEAD. So the declaration never elaborated, and neither did anything after
  it in the file.
* **The file has no `.olean`, `.ilean`, `.trace` or hash, and is imported by nothing**, so
  no claim in it had ever been checked by any tool (also recorded in the roadmap row's
  build-reach triage, I-0361).

What IS now measured, at HEAD, by `lake env lean` on scratch probes (run 0079):

* the K-1a headline `pic0Theta k k C = cocycleIdRHS k C` **does** state and elaborate, and
  the Leg-1..3 `change` step below **does** typecheck — the worksheet's §1.1/§6 probe-K-d
  claim survives independent re-measurement;
* **the Leg-4 atom's `snd` leg is CLOSED** (below, in the flipped orientation that
  `IsPullback.hom_ext` actually presents): `crossBaseAffineIso_inv_snd` plus
  `whiskerRight_snd`, term-mode — `rw` fails here because the identity base change spells
  its codomain `(𝟭 _).obj C`;
* **the atom's `fst` leg is the whole residue.** `Over.crossBaseIso_inv_fst` is stated
  about the composite `(fst …).left ≫ pullback.fst C.hom σ`, whereas `hom_ext` on
  `Over.isPullback_left` presents `(fst …).left` alone, so the landed projection lemma does
  not apply as-is. That mismatch, not op/associator bookkeeping, is what a next session
  faces.

Do NOT import this file from the root until both `sorry`s are closed.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

/-! ## Congruence of étale-plus transports (the reduction key)

Both the base-field shuffle (`PicEtAff.baseFieldShuffle`, via `crossBaseTransportFamily`) and
the curve transport (`PicEtAff.curveMap`, via `curveTransportFamily`) are
`RelPicTransportFamily.picEtAffHom`s, and `picEtAffHom_mk`/`descentHom_coe`/`relPicHom_mk`
express the transport as `CechPic.map` of the family's `hom` scheme morphism. Hence two
families with pointwise-equal `hom` fields induce equal transports — the lemma through which
the two θ-cocycle atoms reduce to a scheme-morphism identity on the product carriers. -/
theorem RelPicTransportFamily.picEtAffHom_congr {kD kE kT : Type u}
    [Field kD] [Field kE] [Field kT] [Algebra kD kT] [Algebra kE kT]
    {D : Over (Spec (.of kD))} {E : Over (Spec (.of kE))}
    (S T : RelPicTransportFamily kT D E)
    (h : ∀ (B : Type u) [CommRing B] [Algebra kD B] [Algebra kE B] [Algebra kT B]
      [IsScalarTower kD kT B] [IsScalarTower kE kT B], S.hom B = T.hom B)
    (A : Type u) [CommRing A] [Algebra kD A] [Algebra kE A] [Algebra kT A]
    [IsScalarTower kD kT A] [IsScalarTower kE kT A] (a : PicEtAff E A) :
    S.picEtAffHom A a = T.picEtAffHom A a := by
  induction a using PicEtAff.ind with
  | _ U x =>
    rw [RelPicTransportFamily.picEtAffHom_mk, RelPicTransportFamily.picEtAffHom_mk]
    refine congrArg (PicEtAff.mk D U) (Subtype.ext ?_)
    rw [RelPicTransportFamily.descentHom_coe, RelPicTransportFamily.descentHom_coe]
    generalize (x : relPic E (overSpec kE U.Carrier)) = y
    induction y using relPic.ind with
    | mk L =>
      rw [RelPicTransportFamily.relPicHom_mk, RelPicTransportFamily.relPicHom_mk, h]

/-! ## Base-change-identity/composite pullback helpers -/

open Limits in
/-- `Over.pullbackId`'s forward comparison has first projection the identity: the
base-change-along-`𝟙` section reads off the original object on the first factor. -/
theorem pullbackId_hom_app_left.{w} {D : Type w} [Category.{u} D] [HasPullbacks D]
    {S : D} (X : Over S) :
    (Over.pullbackId.hom.app X).left = pullback.fst X.hom (𝟙 S) := by
  change ((conjugateEquiv (Over.mapPullbackAdj (𝟙 S))
    (Adjunction.id (C := Over S)) (Over.mapId S).inv).app X).left = _
  rw [conjugateEquiv_adjunction_id]
  simp only [Over.comp_left, Over.mapId_inv_app_left,
    Over.mapPullbackAdj_counit_app, Over.homMk_left]
  simp

open Limits in
private theorem pullbackId_transport_hom_app_left.{w}
    {D : Type w} [Category.{u} D] [HasPullbacks D] {S : D}
    (f : S ⟶ S) (hf : f = 𝟙 S)
    (h : Over.pullback f = Over.pullback (𝟙 S)) (X : Over S) :
    ((eqToIso h ≪≫ Over.pullbackId).hom.app X).left = pullback.fst X.hom f := by
  subst f
  have hh : h = rfl := Subsingleton.elim _ _
  cases hh
  simpa only [Iso.trans_hom, NatTrans.comp_app, eqToIso.hom, eqToHom_refl,
    Over.comp_left, Category.id_comp] using pullbackId_hom_app_left X

open Limits in
set_option maxHeartbeats 1000000 in
-- The `eqToIso`/`pullbackId` cast term is large; the kernel needs a wider budget.
/-- The forward identity base-change iso on the frozen `Challenge` spelling has first
projection `pullback.fst` along the trivial base map. -/
theorem baseChange_idIso_hom_app_left (k : Type u) [Field k] (C : Over (Spec (.of k))) :
    ((baseChange.idIso k).hom.app C).left
      = pullback.fst C.hom (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
  unfold baseChange.idIso
  exact pullbackId_transport_hom_app_left _ (by simp) _ C

/-! ## The Leg-4 atom, `snd` leg

The K-1a Leg-4 atom is the scheme identity
`((baseChange.idIso k).app C).inv ▷ overSpec k B).left = (crossBaseAffineIso k k C B).inv`,
to be proved by `(Over.isPullback_left _ _).hom_ext` on the two projections.  The `snd` leg
is below, closed; the `fst` leg is the file's residue (see the STATUS block). -/

open MonoidalCategory CartesianMonoidalCategory in
/-- **The `snd` leg of the K-1a Leg-4 atom**: the whiskered identity base-change comparison
and the affine same-carrier comparison agree on the second projection — both are
`(snd C (overSpec k B)).left`.

Term-mode by necessity: the identity base change spells its codomain `(𝟭 _).obj C`, so `rw`
reports "did not find an occurrence" on a goal that visibly contains the pattern (the R4/R5
spelling friction of I-0216, measured here). -/
theorem crossBaseAffineIso_inv_whiskerRight_snd (k : Type u) [Field k]
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left
        ≫ (Limits.snd ((baseChange k k).obj C) (overSpec k B)).left
      = (crossBaseAffineIso k k C B).inv
          ≫ (Limits.snd ((baseChange k k).obj C) (overSpec k B)).left :=
  Eq.trans
    (congrArg Over.Hom.left
      (MonoidalCategory.whiskerRight_snd (((baseChange.idIso k).app C).inv) (overSpec k B)))
    (crossBaseAffineIso_inv_snd k k C B).symm

open MonoidalCategory CartesianMonoidalCategory in
/-- The inverse cross-base comparison and the whiskered identity base-change comparison
agree on the first projection. -/
theorem crossBaseAffineIso_inv_whiskerRight_fst (k : Type u) [Field k]
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left
        ≫ (Limits.fst ((baseChange k k).obj C) (overSpec k B)).left =
      (crossBaseAffineIso k k C B).inv
        ≫ (Limits.fst ((baseChange k k).obj C) (overSpec k B)).left := by
  haveI : IsIso
      (Limits.pullback.fst C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k k)))) := by
    rw [← baseChange_idIso_hom_app_left k C]
    infer_instance
  rw [← cancel_mono
    (Limits.pullback.fst C.hom
      (Spec.map (CommRingCat.ofHom (algebraMap k k))))]
  simp [crossBaseAffineIso, baseChange_idIso_hom_app_left]

open MonoidalCategory CartesianMonoidalCategory in
/-- The inverse same-carrier comparison at the identity field extension is exactly
whiskering by the inverse identity base-change comparison. -/
theorem crossBaseAffineIso_inv_eq_whiskerRight (k : Type u) [Field k]
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (B : Type u) [CommRing B] [Algebra k B] :
    (crossBaseAffineIso k k C B).inv =
      (((baseChange.idIso k).app C).inv ▷ overSpec k B).left := by
  apply (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext
  · exact (crossBaseAffineIso_inv_whiskerRight_fst k C B).symm
  · exact (crossBaseAffineIso_inv_whiskerRight_snd k C B).symm

/-! ## K-1a: the θ identity coherence over `Over.pullbackId` -/

section Identity

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- The iso-grade curve transport at the identity base change: `pic0PullbackNat` of the
frozen `baseChange.idIso`. -/
noncomputable def eCurveId : pic0Functor ((baseChange k k).obj C) ≅ pic0Functor C where
  hom := pic0PullbackNat ((baseChange.idIso k).app C).inv
  inv := pic0PullbackNat ((baseChange.idIso k).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

/-- The σ-side collapse at `k → k`: the pushforward `Over.map σ_{kk}` is the identity, via
`σ_{kk} = 𝟙` and `Over.mapId`. -/
noncomputable def mIdσ :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k))) ≅ 𝟭 (Over (Spec (.of k))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 _ by
    rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]]) ≪≫ Over.mapId _

/-- The collapse of the pushed-test functor at `k → k` to the identity. -/
noncomputable def σkkCollapse :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C
      ≅ pic0Functor C :=
  Functor.isoWhiskerRight (NatIso.op (mIdσ k)).symm (pic0Functor C)
    ≪≫ Functor.leftUnitor (pic0Functor C)

/-- The right-hand side of the θ identity coherence, assembled through the frozen
`baseChange.idIso` vehicle. -/
noncomputable def cocycleIdRHS :
    pic0Functor ((baseChange k k).obj C)
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C :=
  eCurveId k C ≪≫ (σkkCollapse k C).symm

/-- **K-1a — the θ identity coherence** (θ over `Over.pullbackId`): θ at `k → k` is the
trivial comparison, the base-changed curve collapsing to `C` and the pushed test to the
test. -/
theorem pic0Theta_id : pic0Theta k k C = cocycleIdRHS k C := by
  apply Iso.ext
  ext T lam
  refine Subtype.ext ?_
  change picEtCrossBaseInv k k C (Opposite.unop T) lam.1
    = picEtMap C ((mIdσ k).hom.app (Opposite.unop T))
        (picEtPullback ((baseChange.idIso k).app C).inv (Opposite.unop T) lam.1)
  have hf : (mIdσ k).hom.app (Opposite.unop T) = 𝟙 _ := by
    apply Over.OverMorphism.ext
    simp [mIdσ, Over.mapId]
  rw [hf, picEtMap_id]
  refine picEt.ext fun W => ?_
  rw [picEtCrossBaseInv_val, picEtPullback_val]
  change (crossBaseTransportFamilyInv k k C).picEtAffHom _ _ =
    (curveTransportFamily ((baseChange.idIso k).app C).inv).picEtAffHom _ _
  exact RelPicTransportFamily.picEtAffHom_congr _ _ (fun B _ _ _ _ _ _ => by
    rw [crossBaseTransportFamilyInv_hom, curveTransportFamily_hom,
      crossBaseAffineIso_inv_eq_whiskerRight]) _ _

end Identity

end AlgebraicGeometry
