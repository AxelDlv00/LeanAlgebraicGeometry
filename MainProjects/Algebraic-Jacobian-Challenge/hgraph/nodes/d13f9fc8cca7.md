---
author: sync
content_type: theorem
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.rank_pushforward_eq_fiberH0
docstring: '**The pushforward stalk rank is the fibre `h⁰`.**  Let `p : X ⟶ Spec R`
  be

  quasi-compact and quasi-separated, `𝒰` a bundled two-chart affine cover of `X`,

  `M` a quasi-coherent module on `X`, and `t : Spec R` a point whose fibre

  inclusion `p.fiberι t` is affine.  If the Čech `H⁰`, i.e.

  `ker (𝒰.moduleSectionDiffBase p M)`, is finite (`hfin`) and projective

  (`hproj`) over `Γ(Spec R, ⊤)`, and its formation commutes with arbitrary base

  change (`hbc`: `AlgebraicJacobian.TwoTerm.kerBaseChange` bijective over every

  `Γ(Spec R, ⊤)`-algebra `B`), then


  `sectionsRankAtStalk ((Modules.pushforward p).obj M) t = p.fiberH0 M t`.


  This is the general form of leaf 3''s rank identification — no projective line

  occurs, so it is equally available for a curve `C_A ⟶ Spec A`.  Surjectivity of

  the Čech differential is *not* required: it is subsumed by `hbc`.  Nor is

  finite presentation of `M`, properness of `p`, or any finiteness of `R`.  The

  three hypotheses that do occur are genuinely necessary; see the module

  docstring for the counterexample that drops `hproj`.


  Sources: Stacks 02KG at `i = 0`, 00NX; Mumford, *Abelian Varieties*, II §5.'
file: AlgebraicJacobian/Picard/RigidPushforwardRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rank_pushforward_eq_fiberH0
type: lean
updated: '2026-07-27T19:08:27'
---
theorem rank_pushforward_eq_fiberH0
    (p : X ⟶ Spec R) (𝒰 : X.AffineCoverMVSquare) (M : X.Modules)
    [M.IsQuasicoherent] [QuasiCompact p] [QuasiSeparated p]
    (t : PrimeSpectrum R) [IsAffineHom (p.fiberι t)]
    (hfin :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      Module.Finite Γ(Spec R, ⊤) (LinearMap.ker (𝒰.moduleSectionDiffBase p M)))
    (hproj :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      Module.Projective Γ(Spec R, ⊤) (LinearMap.ker (𝒰.moduleSectionDiffBase p M)))
    (hbc :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      ∀ (B : Type u) [CommRing B] [Algebra Γ(Spec R, ⊤) B],
        Function.Bijective (AlgebraicJacobian.TwoTerm.kerBaseChange
          (𝒰.moduleSectionDiffBase p M) B)) :
    sectionsRankAtStalk ((Scheme.Modules.pushforward p).obj M) t = p.fiberH0 M t := by
  letI m1 := p.baseSectionsModule M 𝒰.U₁
  letI m2 := p.baseSectionsModule M 𝒰.U₂
  letI m0 := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
  letI mT := p.baseSectionsModule M (⊤ : X.Opens)
  haveI := hfin
  haveI := hproj
  letI n1 := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    ((𝒰.preimage (p.fiberι t)).U₁)
  letI n2 := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    ((𝒰.preimage (p.fiberι t)).U₂)
  letI n0 := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    ((𝒰.preimage (p.fiberι t)).U₁ ⊓ (𝒰.preimage (p.fiberι t)).U₂)
  letI nT := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    (⊤ : (p.fiber t).Opens)
  letI aRK : Algebra Γ(Spec R, ⊤) Γ(Spec ((Spec R).residueField t), ⊤) :=
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  have e0 : Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens))
      ≃ₗ[Γ(Spec R, ⊤)] LinearMap.ker (𝒰.moduleSectionDiffBase p M) :=
    (Scheme.Modules.pushforwardTopEquivBaseSections p M) ≪≫ₗ
      (𝒰.globalSectionsEquivKerModuleSectionDiffBase p M)
  haveI : Module.Finite Γ(Spec R, ⊤)
      Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)) := Module.Finite.equiv e0.symm
  haveI : Module.Projective Γ(Spec R, ⊤)
      Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)) :=
    Module.Projective.of_equiv e0.symm
  haveI := module_finite_top_of_gammaSpecTop ((Scheme.Modules.pushforward p).obj M) ‹_›
  haveI := module_projective_top_of_gammaSpecTop ((Scheme.Modules.pushforward p).obj M) ‹_›
  haveI : Module.Flat R Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)) :=
    Module.Flat.of_projective
  have step1 : sectionsRankAtStalk ((Scheme.Modules.pushforward p).obj M) t
      = Module.finrank t.asIdeal.ResidueField
          (t.asIdeal.Fiber Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens))) :=
    Module.rankAtStalk_eq _
  -- STEP 2, now via the two new bricks
  have step2 : Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          (TensorProduct Γ(Spec R, ⊤) Γ(Spec ((Spec R).residueField t), ⊤)
            (LinearMap.ker (𝒰.moduleSectionDiffBase p M))) := by
    refine finrank_tensor_eq_of_ringEquiv
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm
      (specResidueFieldRingEquiv R t) ?_ e0.toAddEquiv ?_
    · intro r
      have h := appLE_fromSpecResidueField_apply R t
        ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm r)
      rw [RingEquiv.apply_symm_apply] at h
      exact h.symm
    · intro r n
      rw [smul_gammaSpecTop ((Scheme.Modules.pushforward p).obj M) r n]
      exact e0.map_smul _ _
  have hbcK := hbc Γ(Spec ((Spec R).residueField t), ⊤)
  have step3 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (TensorProduct Γ(Spec R, ⊤) Γ(Spec ((Spec R).residueField t), ⊤)
          (LinearMap.ker (𝒰.moduleSectionDiffBase p M)))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          (LinearMap.ker (((𝒰.moduleSectionDiffBase p M).baseChange
            Γ(Spec ((Spec R).residueField t), ⊤)))) :=
    LinearEquiv.finrank_eq (LinearEquiv.ofBijective _ hbcK)
  have step4 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (LinearMap.ker (((𝒰.moduleSectionDiffBase p M).baseChange
          Γ(Spec ((Spec R).residueField t), ⊤))))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          (LinearMap.ker ((𝒰.preimage (p.fiberι t)).moduleSectionDiffBase
            (p.fiberToSpecResidueField t) (p.fiberModule t M))) :=
    finrank_ker_baseChange_residueField 𝒰 p M t
  have step5 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (LinearMap.ker ((𝒰.preimage (p.fiberι t)).moduleSectionDiffBase
          (p.fiberToSpecResidueField t) (p.fiberModule t M)))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          Γ(p.fiberModule t M, (⊤ : (p.fiber t).Opens)) :=
    (LinearEquiv.finrank_eq ((𝒰.preimage (p.fiberι t)).globalSectionsEquivKerModuleSectionDiffBase
      (p.fiberToSpecResidueField t) (p.fiberModule t M))).symm
  have step6 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        Γ(p.fiberModule t M, (⊤ : (p.fiber t).Opens))
      = p.fiberH0 M t := by
    letI := p.fiberSectionsModule t (p.fiberModule t M)
    refine finrank_eq_of_ringEquiv_addEquiv
      (Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv
      (AddEquiv.refl _) ?_
    intro r m
    change r • m = _
    rw [Scheme.Hom.baseSectionsModule_smul_def]
    change _ = ((p.fiberResidueMap t).hom
      ((Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv r)) • m
    congr 1
    simp only [Scheme.Hom.fiberResidueMap, CommRingCat.hom_comp, RingHom.comp_apply]
    have hLE : (p.fiberToSpecResidueField t).appLE ⊤ ⊤ le_top
        = (p.fiberToSpecResidueField t).appTop := Scheme.Hom.appLE_eq_app _
    rw [hLE]
    congr 1
    have h1 := congrArg (fun φ : Γ(Spec ((Spec R).residueField t), ⊤) ⟶
        Γ(Spec ((Spec R).residueField t), ⊤) => φ.hom r)
      (Scheme.ΓSpecIso ((Spec R).residueField t)).hom_inv_id
    simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_id,
      RingHom.id_apply] at h1
    exact h1.symm
  rw [step1, step2, step3, step4, step5, step6]

/-! ## §5. The consumer: `P1RankIdentity` -/

namespace Adelic

open Scheme

variable {k : Type u} [Field k]