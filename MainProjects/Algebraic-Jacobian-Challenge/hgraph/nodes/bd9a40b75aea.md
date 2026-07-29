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

  unconditional statement possible") argues *in prose* that an unconditional

  `RepresentableBy` against `picSharp` is FALSE rather than unproved, because

  Kleiman §2 (L1292–L1302) gives a curve whose `picSharp` is not a Zariski sheaf

  while a representable functor is a sheaf for any subcanonical topology. This

  theorem is the second half of that argument, as a Lean statement rather than as

  prose. Its contrapositive therefore says: over an arbitrary field, no scheme

  represents `picSharp C` in general.


  The campaign milestones G3 and G4 conclude exactly that (G3: `J_r := J''_r/Γ`

  represents `picSharpDeg C r` over `k`; G4 assembles `picSharpDeg`), so they are

  targeting a false statement as written and need restating against `picEt`. That

  restatement is the content of the board row `AJC.picrep.etale-rep`, and it is

  what makes the row a *route repair* rather than a missing theorem.


  **Not formalised, and deliberately named as such**: that Kleiman''s non-sheaf

  curve is smooth, proper and geometrically integral — this project''s binders. It

  is quoted from the reference. Without that check the theorem below is a true

  implication whose antecedent has not been *proved* uninhabitable, only reported

  so by Kleiman.'
file: AlgebraicJacobian/Picard/PicEtSubcanonical.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.picSharp_isSheaf_zariski_of_representableBy
type: lean
updated: '2026-07-29T21:18:38'
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