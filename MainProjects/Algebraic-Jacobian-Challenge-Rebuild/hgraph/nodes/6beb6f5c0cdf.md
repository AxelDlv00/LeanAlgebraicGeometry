---
author: sync
content_type: theorem
created: '2026-07-30T03:07:07'
decl: AlgebraicGeometry.relPicSeparates_of_injective_chartValue
docstring: '**THE CONVERSE, AND IT REFUTES THIS FILE''S OWN "STRICTLY WEAKER" FRAMING.**


  Injectivity of `chartValue` at the affine test `Spec A` gives the residue at `A`.  With

  `injective_chartValue_of_relPicSeparates` this is an **equivalence**, so

  `RelPicSeparatesDivFamZar` is the fork''s injectivity obligation *renamed*, not
  reduced.


  Three docstrings of this file and two commit messages of mine sold the residue as
  "strictly

  weaker — one ring, no test object, no chart, no twist, no representing object".  That
  describes

  the **spelling**, not the strength: fewer binders is a nicer statement to prove
  *about*, never a

  smaller thing to prove.  Found by a fresh-context audit (`I-1149`); landed here
  rather than

  merely cited so the equivalence is compiler-checked and the claim cannot be re-made.


  The two identities the file opens with (`chartValue_eq_iff_abelDiv_eq`,

  `abelDiv_eq_iff_forall_relPicMk_picClass_eq`) are unaffected and remain the useful
  content: they

  say *what* the obligation is, which is worth having even at unchanged price.'
file: AlgebraicJacobian/Picard/Pic0ChartAbelForkReduce.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relPicSeparates_of_injective_chartValue
type: lean
updated: '2026-07-30T15:28:00'
---
theorem relPicSeparates_of_injective_chartValue [GeometricallyReduced C.hom] (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor) (A : Type u) [CommRing A] [Algebra k A]
    (h : Function.Injective (chartValue C π n m Z (overSpec k A))) :
    RelPicSeparatesDivFamZar C π n A := by
  intro F₁ F₂ hcl
  refine (divFamZarAffineEquiv C π n A).symm.injective (h ?_)
  refine (chartValue_eq_iff_forall_relPicMk_picClass_eq C π n m Z _ _ _).mpr fun U => ?_
  rw [divFamZarAffineEquiv_symm_apply_val, divFamZarAffineEquiv_symm_apply_val,
    relPicMk_picClass_mapAlgHom C π n, relPicMk_picClass_mapAlgHom C π n]
  exact congrArg (relPicMap C _) hcl

/-! ## The residue is a Riemann–Roch statement, not plumbing

The section above names the residue.  This one shows what it *is*, at a field, by exhibiting
the two hypotheses of DAT-C GAP-2's field keystone as consequences of class equality alone. -/

set_option linter.overlappingInstances false in
omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] in
variable (n) in