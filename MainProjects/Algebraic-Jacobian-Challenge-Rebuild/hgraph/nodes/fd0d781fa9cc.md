---
author: sync
content_type: theorem
created: '2026-07-28T14:44:52'
decl: AlgebraicGeometry.AffAdaptation.projective_glued_of_swallowedBy
docstring: '**Clause (c2)-projectivity reduces to the piece colengths.**  The index
  is a `Fin`, so the

  product is the direct sum and `Module.Projective.directSum` applies.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.projective_glued_of_swallowedBy
type: lean
updated: '2026-07-28T14:44:52'
---
theorem projective_glued_of_swallowedBy (h : D.SwallowedBy d)
    (hproj : ∀ j, Module.Projective R (A.colength j)) :
    Module.Projective R A.Glued := by
  haveI := hproj
  haveI : Module.Projective R A.chartProd :=
    Module.Projective.of_equiv
      (DirectSum.linearEquivFunOnFintype R D.index A.colength)
  exact Module.Projective.of_equiv (A.gluedEquivChartProd_of_swallowedBy h).symm

/-! ### The diagonal overlap IS the piece colength

The identification the cert-collapse node calls "the one technical lemma still needed", in the
only case the straddling shape leaves: the diagonal.  It is easier there than in general
(`pieces i ⊓ pieces i = pieces i` needs no unit argument, only `inf_idem`) but it is NOT
definitional — `Γ(pieces i ⊓ pieces i)` and `Γ(pieces i)` are different types, which is the
`inf`-bookkeeping hazard the node flags.  So it goes through a genuine algebra equivalence. -/