---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: CategoryTheory.InjectiveResolution.horseshoeφ_comm₂₃
docstring: 'The horseshoe right square: `horseshoeι ≫ (I_B → I_C) = (single₀ B → single₀
  C) ≫ I_C.ι`.'
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.InjectiveResolution.horseshoeφ_comm₂₃
type: lean
updated: '2026-07-24T17:02:56'
---
lemma horseshoeφ_comm₂₃ :
    horseshoeι hses I_A I_C ≫ (horseshoeSES hses I_A I_C).g =
      (ses.map (CochainComplex.single₀ 𝒜)).g ≫ I_C.ι := by
  apply single₀_hom_ext
  change (horseshoeι hses I_A I_C ≫
      twistedBiprodSnd (horseshoeτ hses I_A I_C) (horseshoeτ_cocycle hses I_A I_C)).f 0 =
    ((CochainComplex.single₀ 𝒜).map ses.g ≫ I_C.ι).f 0
  rw [HomologicalComplex.comp_f, HomologicalComplex.comp_f, twistedBiprodSnd_f,
    CochainComplex.single₀_map_f_zero, horseshoeι_f_zero, horseshoeβ]
  change biprod.lift (horseshoeβ₁ hses I_A) (ses.g ≫ ιC0 I_C) ≫
    (biprod.snd : I_A.cocomplex.X 0 ⊞ I_C.cocomplex.X 0 ⟶ I_C.cocomplex.X 0) = ses.g ≫ I_C.ι.f 0
  rw [biprod.lift_snd]
  rfl