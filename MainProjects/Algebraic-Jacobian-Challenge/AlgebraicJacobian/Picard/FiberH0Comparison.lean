/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.RigidPushforwardRank

/-!
# The fibre `h⁰` comparison, without projectivity

**The bridge B5 needs, and the one `rank_pushforward_eq_fiberH0` cannot give.**

`AlgebraicGeometry.rank_pushforward_eq_fiberH0` (`Picard/RigidPushforwardRank.lean`)
proves `sectionsRankAtStalk (p_* M) t = p.fiberH0 M t` under three hypotheses
`hfin`, `hproj`, `hbc`.  Its own module docstring establishes that `hproj`
(`Module.Projective` of the Čech `H⁰`) is **load-bearing**: dropped, the
statement is false, with the counterexample `A = k[x]`,
`M = 𝒪_{ℙ¹_A}/x` recorded at `Picard/RigidPushforwardP1Sheaf.lean`:567-576.

That is true of *that* statement, and it has been read as a bound on what the
machinery can deliver.  It is not.  Reading which step consumes which
hypothesis shows `hfin` and `hproj` are used **only in step 1**, the appeal to
`Module.rankAtStalk_eq` that converts `sectionsRankAtStalk` — a
`Module.rankAtStalk`, which is a statement about the module being flat — into a
fibre dimension.  Steps 2 through 6, the entire semilinear transport

```
κ(t)-fibre of Γ(p_* M, ⊤)  ≅  κ(t) ⊗ ker d  ≅  ker (d ⊗ κ(t))
                           ≅  ker d_t       ≅  Γ(X_t, M_t)
```

are **unconditional**.  So the comparison between the *fibre dimension of the
base section module* and `fiberH0` needs only `hbc`, and this file states it
that way:

* `fiberRank_gammaTop_eq_fiberH0` — no `hfin`, no `hproj`.

## Why this is the statement B5 wants

`Scheme.HasH0Semicontinuity` (`Picard/SemicontinuityH0.lean`) asks for openness
of `{t | q.fiberH0 L t ≤ n}`.  Semicontinuity is only informative where the
fibre dimension *jumps*, and `hproj` forces it to be locally constant
(`Module.isLocallyConstant_rankAtStalk`) — so the `sectionsRankAtStalk` form
cannot be an input to it.  The `Ideal.fiberRank` form here has no such effect:
it is the fibre dimension of an arbitrary module on the base, which is exactly
what `Scheme.Modules.isOpen_pointRank_le`
(`Picard/PointRankSemicontinuity.lean`) proves is upper semicontinuous.

## What is still open

The remaining hypothesis `hbc` — bijectivity of
`AlgebraicJacobian.TwoTerm.kerBaseChange` over every algebra — is *not* free:
its producer in the tree
(`TwoTerm.bijective_kerBaseChange_of_surjective`) goes through surjectivity of
the Čech differential, i.e. through `h¹`-vanishing.  So this file converts the
B5 obligation from "find a projectivity-free rank bridge" (impossible, and the
route the gate's docstring prescribes) into "supply `hbc` without
`h¹`-vanishing", which is the honest half of cohomology-and-base-change
(Stacks 02KG).  That is a strictly smaller and correctly-located obligation,
and it is still open.

## References

Stacks 02KG (cohomology and base change at `i = 0`), 00NX; Mumford,
*Abelian Varieties*, II §5; Hartshorne III 12.8, 12.11.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Module Limits TensorProduct

namespace AlgebraicGeometry

variable {R : CommRingCat.{u}} {X : Scheme.{u}}

/-- **The fibre-`h⁰` comparison, with no projectivity and no finiteness.**

For quasi-compact quasi-separated `p : X ⟶ Spec R`, quasi-coherent `M` carrying
a two-chart affine cover `𝒰`, and `t : Spec R` with affine fibre inclusion, the
`κ(t)`-fibre dimension of the base section module `Γ(p_* M, ⊤)` equals the
fibre `h⁰`, assuming only the base-change bijectivity `hbc`.

This is steps 2-6 of `rank_pushforward_eq_fiberH0` with step 1 — the only step
that consumes `hfin`/`hproj` — removed, and the conclusion restated on
`Ideal.fiberRank` rather than on `sectionsRankAtStalk`.  See the module
docstring for why that restatement is what milestone B5 needs. -/
theorem fiberRank_gammaTop_eq_fiberH0
    (p : X ⟶ Spec R) (𝒰 : X.AffineCoverMVSquare) (M : X.Modules)
    [M.IsQuasicoherent] [QuasiCompact p] [QuasiSeparated p]
    (t : PrimeSpectrum R) [IsAffineHom (p.fiberι t)]
    (hbc :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      ∀ (B : Type u) [CommRing B] [Algebra Γ(Spec R, ⊤) B],
        Function.Bijective (AlgebraicJacobian.TwoTerm.kerBaseChange
          (𝒰.moduleSectionDiffBase p M) B)) :
    Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)))
      = p.fiberH0 M t := by
  letI m1 := p.baseSectionsModule M 𝒰.U₁
  letI m2 := p.baseSectionsModule M 𝒰.U₂
  letI m0 := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
  letI mT := p.baseSectionsModule M (⊤ : X.Opens)
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
  -- STEP 2 (unconditional)
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
  have step4 := finrank_ker_baseChange_residueField 𝒰 p M t
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
  rw [step2, step3, step4, step5, step6]

end AlgebraicGeometry
