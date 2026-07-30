---
author: sync
content_type: theorem
created: '2026-07-29T21:18:38'
decl: AlgebraicGeometry.Scheme.PicScheme.picSharp_isSheaf_zariski_of_representableBy
docstring: '**A representable `picSharp` is a Zariski sheaf.**


  Immediate from subcanonicity of the *Zariski* topology on `(Sch/k)`

  (`Scheme.subcanonical_zariskiTopology` through

  `GrothendieckTopology.subcanonical_over`) — the étale route of §1 is not even

  needed, though `zariskiTopologyOver_le_etaleTopologyOver` (`Picard/PicEtSheaf.lean`)

  would also transport it from there.


  **What this rules out.** The seam docstring

  (`Picard/FGAPicRepresentability.lean`, "Why sheafifying is what makes an

  unconditional statement possible") argued *in prose* that an unconditional

  `RepresentableBy` against `picSharp` is FALSE rather than unproved, because

  some curve has a `picSharp` that is not a Zariski sheaf, while a representable

  functor is a sheaf for any subcanonical topology. That seam docstring **no longer

  says "FALSE"**: it now reads "unproved with a refutation route mapped out", so the

  sentence being ruled out here is a historical one, retained because the *shape*
  of

  the mistake is what this paragraph is about.


  **That prose argument does not close, and this theorem is only its first half**

  (`I-0970`). Its second half — a curve whose `picSharp` fails Zariski descent —

  is not established by any source in the workspace: the seam''s original citation

  (§2 L1292–L1302) is about the *absolute* functor, its first replacement

  (`ex:Pfs`) compares the two *sheafifications*, and `th:cmp` part 1 in fact gives

  `picSharp ↪ Pic_{(X/S)zar}` on these binders. What IS established, and needs no

  sheaf step, is Kleiman''s own L5105–L5108: for the real conic `u²+v²+w²=0`

  (smooth, proper, geometrically integral, no rational point) `Pic_{X/ℝ}` is not

  representable while `Pic_{(X/ℝ)ét}` is. So the conclusion — over an arbitrary

  field, no scheme represents `picSharp C` in general — stands on that quotation,

  not on this theorem.


  The campaign milestones G3 and G4 conclude exactly that (G3: `J_r := J''_r/Γ`

  represents `picSharpDeg C r` over `k`; G4 assembles `picSharpDeg`), so as written

  they target a statement that is unproved with a refutation route mapped out — and

  they need restating against `picEt` either way, because a milestone whose

  conclusion this project expects to be refutable is not one to spend rounds on. That

  restatement is the content of the board row `AJC.picrep.etale-rep`, and it is

  what makes the row a *route repair* rather than a missing theorem.


  **The binder check, which the earlier text here left open, now closes**: the

  witness is a smooth plane conic over `ℝ`, hence smooth, proper and

  geometrically integral — this file''s exact binders — and it has no `ℝ`-point,

  which is what makes the two functors differ. So the refutation route is not

  blocked on a binder mismatch, which is all the binder check can settle.


  **It does NOT show the antecedent is uninhabitable.** An earlier revision of this

  sentence said "genuinely uninhabitable in general, not merely unproved", and that

  was the strongest and least supported of this file''s four overclaims (`I-1354`):

  whether `¬ IsIso (picEtComparison C)` holds *is* the unformalised residue, quoted

  from Kleiman and not constructed in Lean. Worse, it is self-defeating — if the

  antecedent were uninhabitable then

  `not_representableBy_picSharp_of_not_isIso_picEtComparison` would be *vacuous*

  rather than a refutation route, contradicting the value ascribed to it two

  paragraphs above. A binder census answers "could this witness satisfy the

  hypotheses"; it cannot answer "does the hypothesis hold".


  What remains unformalised is the *counterexample itself* (that `Pic_{X/ℝ}` of

  that conic is not representable); it is quoted from Kleiman rather than

  constructed in Lean. `not_representableBy_picSharp_of_not_isIso_picEtComparison`

  below isolates exactly what a Lean version of it would have to supply.'
file: AlgebraicJacobian/Picard/PicEtSubcanonical.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.picSharp_isSheaf_zariski_of_representableBy
type: lean
updated: '2026-07-30T08:42:03'
---
theorem picSharp_isSheaf_zariski_of_representableBy {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picSharp C).RepresentableBy X) :
    Presieve.IsSheaf (Scheme.zariskiTopology.over (Spec (CommRingCat.of k)))
      (picSharp C) := by
  haveI : (picSharp C).IsRepresentable := ⟨X, ⟨rep⟩⟩
  exact GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable _