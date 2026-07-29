---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient
docstring: '**The smooth-proper quotient lemma — Altman–Kleiman descent of an

  étale-sheaf surjection** (Kleiman §4 Lem. `lm:qt`).


  Let `Z, P : (Sch/k)^op ⥤ Type (u+1)` be presheaves and `α : Z ⟶ P` a natural

  transformation with: (1) `Z` representable by `Y`; (2) `R := Z ×_P Z`

  representable by `R`; (3) the first projection `π : R ⟶ Y` smooth and proper;

  (4) `α` an étale-local surjection (every `T`-point of `P` lifts along some

  test morphism). Then, granting the use-site hypothesis

  `[HasSmoothProperQuotient α]` (which additionally encodes Kleiman''s

  quasi-projectivity of `Y` — see the section header for why it cannot yet be

  stated internally), `P` is representable.


  The Lean body extracts the conclusion from the hypothesis class; the

  mathematical content (Altman–Kleiman effective-equivalence-relation descent

  + EGA IV 8.11.5) lives at the use site supplying the instance.


  **WHAT THIS THEOREM PROVES, stated flatly (`review-ajc`, 2026-07-29), because

  the paragraphs above explain the situation without ever naming it.** Since

  `HasSmoothProperQuotient α` is by definition `P.IsRepresentable`, this theorem

  is `P.IsRepresentable → P.IsRepresentable`. All four numbered hypotheses are

  unused in the body — they are named `_hZ`, `_hR`, `_hα` for exactly that

  reason — as are `Y`, `R`, `π` and both instance binders on `π.left`. The class

  has **zero instances** and this theorem has **zero call sites** in the project.

  It is a blueprint-pinned record of the `lm:qt` interface and nothing more.

  Do not cite it as evidence that a quotient is a scheme, do not write a consumer

  against it, and do not claim its `\leanok` in the blueprint as a proof of

  Kleiman `lm:qt`. The committed Milne–Kollár route does not need it at all

  (finite Galois quotients with an orbit-in-affine hypothesis instead).'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient
type: lean
updated: '2026-07-29T20:27:12'
---
theorem smoothProperQuotient {k : Type u} [Field k]
    {Z P : (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u + 1)}
    (α : Z ⟶ P)
    (Y : Over (Spec (.of k)))
    (_hZ : Z.RepresentableBy Y)
    (R : Over (Spec (.of k)))
    (_hR : (Limits.pullback α α).RepresentableBy R)
    (π : R ⟶ Y)
    [Smooth π.left] [IsProper π.left]
    (_hα : ∀ ⦃T : (Over (Spec (.of k)))ᵒᵖ⦄ (p : P.obj T),
        ∃ (T' : (Over (Spec (.of k)))ᵒᵖ) (e : T ⟶ T') (z : Z.obj T'),
          α.app T' z = P.map e p)
    [HasSmoothProperQuotient α] :
    P.IsRepresentable :=
  HasSmoothProperQuotient.is_representable (_α := α)

/-! ## §4. The FGA representability theorem

Grothendieck's existence theorem for the Picard scheme (Kleiman §4 Thm.
`th:main`, specialised via Cor. `cor:algsch` to `S = Spec k`, `X = C`),
transported through Kleiman §2 Thm 2.5 to the plain relative functor under
the rational-point hypothesis: `picSharp C` is representable by `PicScheme C`.

Blueprint reference: `thm:fga_pic_representability`. -/