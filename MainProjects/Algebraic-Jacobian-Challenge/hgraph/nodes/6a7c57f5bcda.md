---
author: sync
content_type: theorem
created: '2026-07-30T19:29:12'
decl: AlgebraicGeometry.Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient
docstring: '**Clause (1) of the seam, in full, from the bundled quotient.**


  No `Nonempty` wrapper is needed here and none is used: clause (1) is itself an

  existential, so this eliminates the quotient''s `∃` into a `Prop` and stays

  choice-free in that step. **This is the statement the `sorry` of

  `Scheme.fgaPicardRepresentability` consumes**, reduced to: a `k''`-side

  representation, a Galois quotient of its canonical action, `hcov`, the `G1` match,

  and local finiteness of the quotient.'
file: AlgebraicJacobian/Picard/PicEtDescentGoal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient
type: lean
updated: '2026-07-30T20:02:49'
---
theorem seamClauseOne_of_isGaloisQuotient
    (hq : IsGaloisQuotient ρ Y.hom)
    (hcov : ∀ T : Over (Spec (CommRingCat.of k)), Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      Scheme.etaleTopologyOver k (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (hmatch : ∀ T, IsInvariantMatch C rep ρ T)
    (hlft : LocallyOfFiniteType Y.hom) :
    ∃ Z : Over (Spec (CommRingCat.of k)),
      Nonempty ((picEt C).RepresentableBy Z) ∧
        LocallyOfFiniteType Z.hom ∧ IsSeparated Z.hom :=
  seamClauseOne_of_representableBy_locallyOfFiniteType C
    ⟨Y, nonempty_representableBy_picEt_of_isGaloisQuotient rep ρ hq hcov hmatch, hlft⟩