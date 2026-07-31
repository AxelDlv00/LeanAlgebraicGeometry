---
author: sync
content_type: theorem
created: '2026-07-31T11:59:12'
decl: AlgebraicGeometry.subsingleton_pic0Subgroup_of_rigidity
docstring: '**THE REDUCTION**: at genus `0`, field-point rigidity of `picEt` gives
  the `pic⁰` vanishing

  at **every** test object.


  `hrig`''s statement carries no degree, no χ, no divisor and no chart — it is separation
  of the

  presheaf `picEt C ·` against field points.  The proof is `fibre_eq_one_of_mem_pic0Subgroup`
  fed

  to `hrig`, twice.  (Per `I-1650`: the *hypothesis* is nonetheless the same one,
  so this is a

  change of spelling with a statability payoff, not a discount.)'
file: AlgebraicJacobian/Picard/Pic0VanishingRigidityReduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.subsingleton_pic0Subgroup_of_rigidity
type: lean
updated: '2026-07-31T20:15:27'
---
theorem subsingleton_pic0Subgroup_of_rigidity (hg : genus C = 0)
    (hrig : ∀ (T : Over (Spec (.of k))) (lam : picEt C T),
      (∀ (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T),
        picEtMap C t lam = 1) → lam = 1)
    (T : Over (Spec (.of k))) : Subsingleton (pic0Subgroup C T) := by
  refine ⟨fun s t => Subtype.ext ?_⟩
  have key : ∀ w : pic0Subgroup C T, (w : picEt C T) = 1 := fun w =>
    hrig T _ fun K _ _ tp => fibre_eq_one_of_mem_pic0Subgroup C hg w K tp
  rw [key s, key t]