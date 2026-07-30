---
author: sync
content_type: definition
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.Scheme.PicScheme.representableBy_picEt_baseChangeField_of_representableBy
docstring: '**THE NECESSITY THEOREM: field 1 of clause (1) over `k` PRODUCES the descent

  route''s `k''`-side input.**


  Given a `k`-scheme `X` representing `picEt C`, the base change `X_{k''}` represents

  `picEt (C_{k''})` — the Picard functor of the base-changed curve over `k''`, which
  is

  exactly the `rep` hypothesis of

  `Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient` and of every theorem in

  `Picard/PicEtDescentGoal.lean`.


  **What this buys, and it is a statement about the ROUTE, not a discharge.** The

  descent route is not one sufficient strategy among several that a cheaper `k`-side

  argument might bypass: *any* solution of clause (1) field 1 carries a solution of

  `rep` inside it. So `rep`''s 93 consumers and 0 producers is not a sign that the
  route

  is badly chosen — the object it asks for is a consequence of the goal.


  **What it does NOT buy.** Its hypothesis is the seam''s own open obligation, so
  it

  witnesses nothing. It also does not give `hq`: see §4, where clauses 1 and 2 of

  `IsGaloisQuotient` are free at this object and clause 3 is not.


  Two hypotheses it does *not* carry, both of which a reader would expect: no

  finiteness and no separability of `k''/k`. Those are input 1''s price

  (`Scheme.picEt_ext_of_pullback_agrees`), and the same double-count has been corrected

  twice in this cluster already. The proof is §1 plus `picEt_crossBaseIso`, and the

  latter holds for an arbitrary field extension.'
file: AlgebraicJacobian/Picard/PicEtDescentNecessity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.representableBy_picEt_baseChangeField_of_representableBy
type: lean
updated: '2026-07-31T02:29:40'
---
noncomputable def representableBy_picEt_baseChangeField_of_representableBy
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picEt C).RepresentableBy X) :
    (picEt (Scheme.baseChangeField C k')).RepresentableBy
      ((Over.pullback (specMapAlgebra k k')).obj X) :=
  (representableByRestrictTest_of_representableBy (k' := k') C rep).ofIso
    (picEt_crossBaseIso C k').symm

/-! ## §3. FACT 2 — `hlft` is a consequence, not an input

`Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient` carries
`(hlft : LocallyOfFiniteType Y.hom)` as a fourth hypothesis beside `rep`, `hq` and
`hcov`. It need not: the quotient's own isomorphism `e` identifies `Y_{k'}` with
`X'`, and `Picard/PicEtSeparated.lean`'s `locallyOfFiniteType_of_baseChange` descends
the property back to `Y`. So `hlft` is derivable from a condition on the object the
`k'`-side representation already names. -/