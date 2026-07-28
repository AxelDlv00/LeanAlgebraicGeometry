---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorPowAdd_assoc_succ_core
docstring: '**Generic-`M` core of the succ-case canonical pentagon residual of `tensorPowAdd_assoc`.**

  Stated over an arbitrary monoidal category `M` so that all `≫`/`▷`/`◁`/`α_` resolve
  to a single

  uniform category instance (no `LocalizedMonoidal`/`X.Modules` comp-instance diamond),
  making the

  fold + cancellation + associator-naturality simp set fire.  Plugged into the succ
  branch by `exact`

  (the instance diamond is `rfl`-defeq, so `exact`''s `isDefEq` bridges it; cf.

  `tensorObjAssoc_associator_counit_coherence`).  `foldhyp` is the whiskered inductive
  hypothesis

  `ihRh`; `hμ5` is the second-index succ-unfold of the right comparison atom `μ_{m,m''+(c+1)}`.  The

  proof folds `foldhyp` (after cancelling its `iABCL.inv` epi prefix), substitutes
  `hμ5`, telescopes

  the bridge `hom`/`inv` pairs, and closes the residual associator-naturality square
  with one

  `associator_inv_naturality_left` slide + `whisker_assoc`/`whisker_exchange` + `monoidal`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.tensorPowAdd_assoc_succ_core
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma tensorPowAdd_assoc_succ_core
    {M : Type*} [Category M] [MonoidalCategory M]
    {a b cc l ab abc bc r Pab Pcl Pbc Pbcl Pabc Q8
      Q1 Q2 Q5 Q6 Q7 Q9 Q10 Q11 : M}
    (iAB_CL : Pab ⊗ Pcl ≅ Q1) (iCL : cc ⊗ l ≅ Pcl)
    (iAB_C : Pab ⊗ cc ≅ Pabc) (iab_C : ab ⊗ cc ≅ Q2)
    (iR_L : r ⊗ l ≅ Q5)
    (iAB : a ⊗ b ≅ Pab) (iB_CL : b ⊗ Pcl ≅ Pbcl) (iB_C : b ⊗ cc ≅ Pbc)
    (iT : Pbc ⊗ l ≅ Q11)
    (iBC_L : bc ⊗ l ≅ Q6) (iA_S : a ⊗ Q6 ≅ Q7)
    (iABCL : Pabc ⊗ l ≅ Q8) (iA_BC : a ⊗ Pbc ≅ Q9) (iA_bc : a ⊗ bc ≅ Q10)
    (μ1 : Pab ⟶ ab) (μ2 : Q2 ⟶ abc) (μ3 : Q10 ⟶ r) (μ4 : Pbc ⟶ bc) (μ5 : Q7 ⟶ Q5)
    (e : abc ⟶ r)
    (foldhyp :
      iABCL.inv ≫ (iAB_C.inv ≫ μ1 ▷ cc ≫ iab_C.hom) ▷ l ≫ μ2 ▷ l ≫ e ▷ l ≫ iR_L.hom
        = iABCL.inv ≫ (iAB_C.inv ≫ iAB.inv ▷ cc ≫ (α_ a b cc).hom ≫ a ◁ iB_C.hom ≫ iA_BC.hom) ▷ l
            ≫ (iA_BC.inv ≫ a ◁ μ4 ≫ iA_bc.hom) ▷ l ≫ μ3 ▷ l ≫ iR_L.hom)
    (hμ5 : iA_S.hom ≫ μ5
        = a ◁ iBC_L.inv ≫ (α_ a bc l).inv ≫ iA_bc.hom ▷ l ≫ μ3 ▷ l ≫ iR_L.hom) :
    -- v4.31 statement shape: the goal this is `exact`ed against is now fully flattened with the
    -- `iab_CL`/`iABC_L` hom/inv pairs already cancelled, and the right-hand `a ◁ (…)`
    -- factor split at
    -- the bridge `iT` — mirror that shape here (the proof normalises both forms identically).
    iAB_CL.inv ≫ Pab ◁ iCL.inv ≫ (α_ Pab cc l).inv ≫ iAB_C.hom ▷ l
        ≫ (iAB_C.inv ≫ μ1 ▷ cc ≫ iab_C.hom) ▷ l ≫ iab_C.inv ▷ l ≫ (α_ ab cc l).hom
        ≫ ab ◁ iCL.hom ≫ ab ◁ iCL.inv ≫ (α_ ab cc l).inv ≫ iab_C.hom ▷ l ≫ μ2 ▷ l
        ≫ e ▷ l ≫ iR_L.hom
      = iAB_CL.inv ≫ iAB.inv ▷ Pcl ≫ (α_ a b Pcl).hom ≫ a ◁ iB_CL.hom
        ≫ a ◁ (iB_CL.inv ≫ b ◁ iCL.inv ≫ (α_ b cc l).inv ≫ iB_C.hom ▷ l ≫ iT.hom)
        ≫ a ◁ (iT.inv ≫ μ4 ▷ l ≫ iBC_L.hom)
        ≫ iA_S.hom ≫ μ5 := by
  rw [hμ5]
  have foldhyp' := (cancel_epi iABCL.inv).mp foldhyp
  simp only [Iso.hom_inv_id_assoc,
    MonoidalCategory.whiskerLeft_hom_inv_assoc, MonoidalCategory.inv_hom_whiskerRight_assoc]
  rw [foldhyp']
  simp only [Category.assoc, MonoidalCategory.comp_whiskerRight, MonoidalCategory.whiskerLeft_comp,
    MonoidalCategory.hom_inv_whiskerRight_assoc,
    MonoidalCategory.whiskerLeft_hom_inv_assoc]
  rw [← MonoidalCategory.associator_inv_naturality_left_assoc]
  simp only [Category.assoc, MonoidalCategory.whisker_assoc,
    MonoidalCategory.whisker_exchange_assoc]
  monoidal

-- The final `exact tensorPowAdd_assoc_succ_core (M := LocalizedMonoidal …) …` in the succ branch
-- discharges the canonical pentagon via a head-aligned `isDefEq` across the `instCategory`/
-- `LocalizedMonoidal` rfl-diamond; pinning `M` makes it short-circuit, but it still
-- recurses past the
-- default `maxRecDepth = 512` (a stack-depth bound, NOT the forbidden heartbeat bump).
set_option maxRecDepth 4000 in
set_option backward.isDefEq.respectTransparency false in