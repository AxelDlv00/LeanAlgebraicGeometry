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

## STATUS (WORK IN PROGRESS — not committed, not wired into the root)

The two headline definitions and their auxiliary isos (pinned exactly per the ratified
`informal/w7-k1-worksheet.md`) elaborate green, as does the reduction key
`RelPicTransportFamily.picEtAffHom_congr` and the full Leg-1..3 component reduction of
`pic0Theta_id`. The two keystones `pic0Theta_id`/`pic0Theta_comp` bottom out in a single
`sorry` each — the Leg-4 section-ring **atom** (base-field shuffle vs. curve base-change
transport), reduced to a scheme-morphism identity on the product carriers. The exact
remaining plan is recorded inline at each `sorry`. Do NOT import this file from the root
until both `sorry`s are closed and the file is committed.
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
  simp [Over.pullbackId]

open Limits in
/-- Transport of `pullback.fst` along an equality of the second leg (proof-irrelevant
`eqToHom` cast). -/
private theorem pullback_fst_congr_left.{w} {D : Type w} [Category.{u} D] {W S T : D}
    (a : W ⟶ S) {f g : T ⟶ S} (hfg : f = g) [HasPullback a f] [HasPullback a g]
    (heq : Limits.pullback a f = Limits.pullback a g) :
    eqToHom heq ≫ pullback.fst a g = pullback.fst a f := by
  subst hfg; exact Category.id_comp _

open Limits in
set_option maxHeartbeats 1000000 in
-- The `eqToIso`/`pullbackId` cast term is large; the kernel needs a wider budget.
/-- The forward identity base-change iso on the frozen `Challenge` spelling has first
projection `pullback.fst` along the trivial base map. -/
theorem baseChange_idIso_hom_app_left (k : Type u) [Field k] (C : Over (Spec (.of k))) :
    ((baseChange.idIso k).hom.app C).left
      = pullback.fst C.hom (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
  have hσ : Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 (Spec (.of k)) := by
    rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]
  simp only [baseChange.idIso, Iso.trans_hom, NatTrans.comp_app, Over.comp_left, eqToIso.hom,
    eqToHom_app, pullbackId_hom_app_left, Over.eqToHom_left]
  exact pullback_fst_congr_left C.hom hσ _

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
  refine picEt.ext fun W => ?_
  rw [picEtCrossBaseInv_val, picEtMap_val]
  -- REMAINING ATOM (Leg 4). Goal:
  --   `(sectionShuffle k k C T.unop W.1).symm (lam.1.1 W)`
  --     `= picEtMapVal C ((mIdσ k).hom.app T.unop)`
  --         `(picEtPullback ((baseChange.idIso k).app C).inv T.unop lam.1) W`.
  -- PLAN (all pieces below verified in isolation this session except the scheme identity):
  --  (1) `sectionShuffle k k C T.unop W.1 = baseFieldShuffle k k C Γ(T.left,W.1)` (rfl),
  --      whose `.symm` is `(crossBaseTransportFamilyInv k k C).picEtAffHom Γ(…)`.
  --  (2) The RHS `picEtMapVal` along `(mIdσ k).hom.app T.unop` — whose `.left` is the
  --      carrier-identity (`eqToHom`/`𝟙`) — collapses via `picEtMapVal_eq_mapAlg` (V := W,
  --      the preimage `≤` from the carrier identity) to `picEtPullback`'s value, i.e.
  --      `PicEtAff.curveMap Γ(…) ((baseChange.idIso k).app C).inv = `
  --      `(curveTransportFamily ((baseChange.idIso k).app C).inv).picEtAffHom Γ(…)`.
  --      Use `Over.isScalarTower_sections_map`-ascribed `letI` at the `T.left` spelling;
  --      seam crossings term-mode only (I-0216 notes 1–2).
  --  (3) Close by `RelPicTransportFamily.picEtAffHom_congr` (above) fed the SCHEME IDENTITY
  --      `(crossBaseAffineIso k k C B).inv = ((baseChange.idIso k).app C).inv ▷ overSpec k B).left`
  --      (both are `hom B` of the two families; typechecked this session). Prove it by
  --      `(Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext`:
  --        · snd-leg: `crossBaseAffineIso_inv_snd` and `whiskerRight_snd` both give
  --          `(snd C (overSpec k B)).left`;
  --        · fst-leg: `(g ▷ X) ≫ fst = fst ≫ g` (`whiskerRight_fst`) gives
  --          `(fst C _).left ≫ ((baseChange.idIso k).app C).inv.left`; match against
  --          `crossBaseAffineIso`'s fst (the `whiskerLeftIso C mapOverSpecIso` only touches
  --          snd, so its fst is `crossBaseIso`'s, via `Over.crossBaseIso_hom_fst`), using
  --          `baseChange.idIso = eqToIso _ ≪≫ Over.pullbackId` so `g.left` is `pullbackId`.
  by
    exact rfl

end Identity

/-! ## K-1b: the θ cocycle coherence over `Over.pullbackComp` -/

section Cocycle

variable (k L M : Type u) [Field k] [Field L] [Field M]
  [Algebra k L] [Algebra L M] [Algebra k M] [IsScalarTower k L M]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- The iso-grade curve transport at the tower composite: `pic0PullbackNat` of the frozen
`baseChange.compIso`. -/
noncomputable def eCurve :
    pic0Functor ((baseChange k M).obj C)
      ≅ pic0Functor ((baseChange k L ⋙ baseChange L M).obj C) where
  hom := pic0PullbackNat ((baseChange.compIso k L M).app C).inv
  inv := pic0PullbackNat ((baseChange.compIso k L M).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

/-- The σ-side reassociation: the `Over.mapComp` mirror of `baseChange.compIso`, on the
covariant `Over.map` side at `σ_{kM}`. -/
noncomputable def σMapCompIso :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))
      ≅ Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))
          ⋙ Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k M))
      = Spec.map (CommRingCat.ofHom (algebraMap L M))
          ≫ Spec.map (CommRingCat.ofHom (algebraMap k L)) by
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, ← IsScalarTower.algebraMap_eq]]) ≪≫
    Over.mapComp _ _

/-- The op-side bridge: `(σ_{LM}).op ⋙ (σ_{kL}).op = (σ_{LM} ≫ σ_{kL}).op` is definitional
(`eqToIso rfl`), composed with the op of the `Over.mapComp` reassociation. -/
noncomputable def αOp :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))).op
        ⋙ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).op
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))).op :=
  eqToIso rfl ≪≫ (NatIso.op (σMapCompIso k L M))

/-- The right-hand side of the θ cocycle coherence, assembled through the frozen
`baseChange.compIso` vehicle. -/
noncomputable def cocycleRHS :
    pic0Functor ((baseChange k M).obj C)
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))).op ⋙ pic0Functor C :=
  eCurve k L M C
    ≪≫ pic0Theta L M ((baseChange k L).obj C)
    ≪≫ Functor.isoWhiskerLeft
        (Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))).op (pic0Theta k L C)
    ≪≫ (Functor.associator _ _ _).symm
    ≪≫ Functor.isoWhiskerRight (αOp k L M) (pic0Functor C)

/-- **K-1b — the θ cocycle coherence** (θ over `Over.pullbackComp`): `θ_{k,M}` factors as
`θ_{k,L} ∘ θ_{L,M}` read across the tower `k → L → M`. -/
theorem pic0Theta_comp : pic0Theta k M C = cocycleRHS k L M C := by
  -- REDUCTION (mirror of `pic0Theta_id`): `apply Iso.ext; ext T lam; refine Subtype.ext ?_`,
  -- then `change` to the underlying `picEt`-class composite (the RHS collapses by defeq:
  -- `Functor.leftUnitor`/`isoWhiskerLeft`/`isoWhiskerRight`/`associator`/`NatIso.op` components
  -- through `pic0Functor_map`+`pic0Map_coe`, `pic0PullbackNat_app`+`pic0Pullback_coe`, and
  -- `pic0Theta_hom_app`+`pic0CrossBaseEquiv_apply_coe`), landing at the TOWER ATOM: the
  -- backward shuffle for `k → M` equals the composite `shuffle_{L→M} ∘ shuffle_{k→L}`
  -- transported along the curve `baseChange.compIso`, with the `σMapCompIso` reindex.
  -- Close as in `pic0Theta_id`: reduce `sectionShuffle`/`curveMap` to `picEtAffHom`s and apply
  -- `RelPicTransportFamily.picEtAffHom_congr` fed the SCHEME IDENTITY
  --   `(crossBaseAffineIso k M C B).inv`
  --     `= ((crossBaseAffineIso L M _ B).inv ≫ (crossBaseAffineIso k L C B).inv-transported)`
  --   composed with `((baseChange.compIso k L M).app C).inv ▷ overSpec k B).left`,
  -- proved by `(Over.isPullback_left …).hom_ext` on fst/snd (fst uses `whiskerRight_fst`,
  -- `Over.crossBaseIso_hom_fst`, and `baseChange.compIso = eqToIso _ ≪≫ Over.pullbackComp`).
  -- Authorized reorientation bail (worksheet §2) applies here if the op/associator bookkeeping
  -- balloons: prove the `.symm`/inv orientation the frozen `baseChangeIso` consumes.
  sorry

end Cocycle

end AlgebraicGeometry
