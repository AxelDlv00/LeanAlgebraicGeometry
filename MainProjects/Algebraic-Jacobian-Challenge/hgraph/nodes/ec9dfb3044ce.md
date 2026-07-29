---
author: sync
content_type: theorem
created: '2026-07-30T07:02:16'
decl: AlgebraicGeometry.seamClauseOne_of_representableBy_locallyOfFiniteType
docstring: '**Clause (1) of the seam is a TWO-field obligation**: a representing scheme

  that is locally of finite type suffices, and separatedness comes for free.


  This is the form a lane closing the descent step should aim at. It removes an

  obligation that was never on any board row, and it forecloses the dead end: do

  **not** budget a separatedness-descent argument, because (module docstring) the

  `DescendsAlong` instance it would cite does not exist in Mathlib `v4.31`.


  **Not a discount on the seam.** The hypothesis is still the campaign''s

  undischarged output — a `k`-scheme representing `picEt C` — and this theorem

  supplies no witness for it at any curve. What it changes is the *shape* of what

  must be produced: two fields, not three. Field 2 stays a genuine obligation and

  is not absorbed here: `LocallyOfFiniteType X.hom` does not follow from the

  representation (`exact?` fails), which is why it is a hypothesis. At the real

  cover it *does* descend freely, unlike field 3 — the two are free for opposite

  reasons.'
file: AlgebraicJacobian/Picard/PicEtSeparated.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.seamClauseOne_of_representableBy_locallyOfFiniteType
type: lean
updated: '2026-07-30T07:16:15'
---
theorem seamClauseOne_of_representableBy_locallyOfFiniteType {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (h : ∃ X : Over (Spec (.of k)),
      Nonempty ((Scheme.PicScheme.picEt C).RepresentableBy X) ∧
        LocallyOfFiniteType X.hom) :
    ∃ X : Over (Spec (.of k)),
      Nonempty ((Scheme.PicScheme.picEt C).RepresentableBy X) ∧
        LocallyOfFiniteType X.hom ∧ IsSeparated X.hom := by
  obtain ⟨X, ⟨rep⟩, hlft⟩ := h
  exact ⟨X, ⟨rep⟩, hlft, isSeparated_of_representableBy_picEt C rep⟩