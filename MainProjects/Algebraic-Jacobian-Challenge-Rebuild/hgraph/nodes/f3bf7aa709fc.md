---
author: sync
content_type: theorem
created: '2026-07-30T00:05:11'
decl: AlgebraicGeometry.quasiCompact_of_extensionTolerant_lift
docstring: '**The qc field from the extension-tolerant hypothesis** — the form to
  hand a producer,

  since it accepts a divisor produced over any extension of the residue field.'
file: AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.quasiCompact_of_extensionTolerant_lift
type: lean
updated: '2026-07-31T20:15:26'
---
theorem quasiCompact_of_extensionTolerant_lift {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (h : ∀ y : J.left, ∃ (T : Over (Spec (.of k))) (_ : Nonempty T.left)
      (e : T ⟶ overSpec k (Over.testPointField y))
      (q : T ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂),
      pic0Map C q lam = rep.homEquiv (e ≫ Over.testPoint y)) :
    QuasiCompact J.hom :=
  quasiCompact_of_surjective_from_divScheme A B g r₁ r₂ b₁ b₂ J
    (abelOfPic0Class rep lam).left (surjective_of_extensionTolerant_lift rep lam h)