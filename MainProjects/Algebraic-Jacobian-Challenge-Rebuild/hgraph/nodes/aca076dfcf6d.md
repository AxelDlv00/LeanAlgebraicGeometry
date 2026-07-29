---
author: sync
content_type: theorem
created: '2026-07-30T00:05:11'
decl: ProbeP4c.qc_of_surj
file: scratch_p4/Probe3.lean
generated: lean
lean_status: lean_ok
title: ProbeP4c.qc_of_surj
type: lean
updated: '2026-07-30T00:05:11'
---
theorem qc_of_surj (J : Over (Spec (.of k)))
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C DivO)
    (hsurj : Function.Surjective (rep.homEquiv.symm lam).left.base) :
    QuasiCompact J.hom :=
  quasiCompact_of_surjective_from_divScheme A B g r₁ r₂ b₁ b₂ J
    (rep.homEquiv.symm lam).left hsurj

-- Q2: THE SQUARE.  For q : overSpec k K ⟶ DivO an Over-morphism, is
-- q.left ≫ (rep.homEquiv.symm lam).left  =  (q ≫ rep.homEquiv.symm lam).left  by rfl?
example (J : Over (Spec (.of k)))
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C DivO) {K : Type u} [Field K] [Algebra k K]
    (q : overSpec k K ⟶ DivO) :
    q.left ≫ (rep.homEquiv.symm lam).left
      = (q ≫ rep.homEquiv.symm lam).left := rfl

-- Q3: and does homEquiv of that composite equal pic0Map of lam?  (naturality)
example (J : Over (Spec (.of k)))
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C DivO) {K : Type u} [Field K] [Algebra k K]
    (q : overSpec k K ⟶ DivO) :
    rep.homEquiv (q ≫ rep.homEquiv.symm lam) = pic0Map C q lam := by
  rw [rep.homEquiv_comp (f := q), Equiv.apply_symm_apply]
  rfl

-- Q4: THE PAYOFF.  Suppose for every y : J.left there is q : overSpec k κ(y) ⟶ DivO
-- with pic0Map C q lam = the class of y (i.e. homEquiv of testPoint y).  Then the
-- composite q ≫ abel EQUALS testPoint y by faithfulness of homEquiv -- so the
-- residue-field lift exists and qc follows.  No separate SQUARE needed.