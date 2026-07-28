---
author: sync
content_type: theorem
created: '2026-07-28T13:22:16'
decl: AlgebraicGeometry.Scheme.fgaPicardRepresentability
docstring: '**THE PROJECT''S CENTRAL OPEN OBLIGATION — expected to stay open.**


  Kleiman §4 Thm `th:main` + Cor `cor:algsch`: for a smooth proper geometrically

  integral curve `C` over an *arbitrary* field `k`, the **étale-sheafified**

  relative Picard functor `Pic_{(C/k)ét}` (`PicScheme.picEt`,

  `Picard/PicEtSheaf.lean`) is representable by a `k`-scheme that is separated

  and locally of finite type — a disjoint union of open quasi-projective

  `k`-subschemes. All three conjuncts are parts of that one theorem, which is

  why they are bundled.


  **There is no hypothesis on `C(k)`, and that is the point.** This statement is

  the one the challenge asks for: `AlgebraicJacobian/Challenge.lean` binds

  `Jacobian C` for a curve with no rational point, so a representability input

  carrying `[HasRationalPoint C]` answers a different question. The conditional

  form survives beside this one as `picSchemeOfHasRationalPoint` below, clearly

  labelled as strictly weaker.


  **Why sheafifying is what makes an unconditional statement possible.** The

  unsheafified functor `picSharp C = T ↦ Pic(C ×_k T)/π_T^* Pic(T)` is *not*

  representable over a general field — it is not even a Zariski sheaf (Kleiman §2

  L1292–L1302), and a representable functor is a sheaf for any subcanonical

  topology. So an unconditional `RepresentableBy` against `picSharp` would be a

  FALSE statement, not merely an unproved one. Against `picEt` it is Kleiman''s own

  theorem. `PicScheme.picEt_isSheaf_forget` records the sheaf property that makes

  the difference, and it is proved rather than assumed.


  **Expected to stay open, and that is the honest state rather than a defect.**

  Discharging it means formalising the Kleiman §4 existence proof: the Abel-map

  slice `Div^d_{C/k} → Pic^d_{C/k}` is a smooth proper equivalence relation whose

  quotient is a scheme (`smoothProperQuotient`, itself gated on

  `HasSmoothProperQuotient` because Mathlib `v4.31` has no quasi-projectivity

  vocabulary), together with `Div` representability (Kleiman §3 Thm `th:repDiv`,

  which needs the Quot scheme). Neither input is available; the project reaches

  this statement rather than proving it, and it is the single named `sorry` that

  the whole Jacobian headline rests on. Do not replace it with a weaker

  conditional statement to make a count go down.


  This is the **sole** `sorry` of the seam: everything else below — the

  representing scheme `PicSchemeEt`, its representability, local finiteness,

  separatedness and group-scheme structure, the comparison class

  `PicEtComparisonIso` and the conditional `picSchemeOfHasRationalPoint` — is

  derived from it.


  **Why the second conjunct is bundled here rather than given its own `sorry`.**

  Clause (1) is Kleiman §4; clause (2) is Kleiman §2 Thm 2.5 (`th:comp`): given a

  section, the comparison `picSharp C → Pic_{(C/k)ét}` is an isomorphism. Both are

  theorems of the same paper and neither is formalised. They are stated as one

  named obligation on purpose: the `picSharp`-shaped consumer interface

  (`HasPicScheme`, and through it the tangent-space chain and the `k̄` Albanese

  witness) needs clause (2) to exist at all, and splitting it out would report the

  Jacobian headline as resting on *six* open obligations where the mathematics has

  five. The bundling adds no strength — clause (2) is conditional on a section, so

  it says nothing about a pointless curve — and it keeps the frontier count honest

  in both directions. `scripts/axiom-frontier.lean` measures the result rather

  than asserting it.'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.fgaPicardRepresentability
type: lean
updated: '2026-07-28T13:22:16'
---
theorem fgaPicardRepresentability {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    (∃ (X : Over (Spec (.of k))),
        Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom)
      ∧ (HasRationalPoint C → IsIso (PicScheme.picEtComparison C)) :=
  sorry