---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.PicScheme.degree
docstring: 'The **degree map** `Pic_{C/k}(k) → ℤ`.


  Sends a `k`-point `λ ∈ Pic_{C/k}(k)` --- a morphism

  `Spec k ⟶ (PicScheme C).left` --- to the leading coefficient of the

  Hilbert polynomial of a representing invertible sheaf `L` on `C` (relative

  to a fixed degree-one polarisation `O_C(1)`). By Riemann--Roch,

  `χ(C, L ⊗ O_C(n)) = n · deg L + 1 - g`, so the degree is the leading

  coefficient of `Φ_L(n)`, well-defined on the isomorphism class `[L]` and on

  the `k`-point `λ` (because `PicScheme C` represents the étale-sheafified

  relative Picard functor).


  The degree map is a group homomorphism from the additive structure on

  `Pic_{C/k}(k)` (tensor product on `L`) to `(ℤ, +)`; only the underlying

  function is stated here, the homomorphism property and the functoriality in

  `k` being left to separate lemmas.


  ROUTE CHANGE (run 0067). The construction is still an open obligation, but it is
  no

  longer the *Quot* obligation the previous docstring described, and the difference
  matters

  because Quot is retained-not-revived in this project. See `ClassDegree` and

  `degreeOfSection` below: representability already transports a `k`-rational point
  to a

  relative Picard class over the base, so the only missing input is a degree homomorphism
  on

  those classes — no Hilbert polynomial and no representing sheaf extraction.


  The body is still `sorry`, and deliberately so: see `degreeOfSection` for the honest

  version, which is total, and for why *this* declaration cannot be closed as stated.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.PicScheme.degree
type: lean
updated: '2026-07-28T16:26:23'
---
noncomputable def degree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ :=
  sorry

/-! ### The degree, factored through the relative Picard group

The route below replaces the Quot/Hilbert-polynomial construction the section header
describes. Two facts make it work, and neither needs Quot:

1. **Representability already does the transport.** `PicScheme.representable C` is a
   bijection `(T ⟶ Pic_{C/k}) ≃ Pic(C ×_k T)/π_T^* Pic(T)` natural in `T`; taking
   `T = Spec k` (the trivial over-object `Over.mk (𝟙 (Spec k))`) sends a `k`-rational point
   of `Pic_{C/k}` to a relative Picard class over the base. This is `classOfSection` below,
   and it is sorry-free.
2. **The degree is a homomorphism on those classes.** ⚠ This was described here as "the one
   remaining input, isolated as the class `ClassDegree`". That is **false** and is corrected at
   `ClassDegree` below: the class is inhabited by the zero homomorphism with no hypothesis, so
   it demands nothing and `degreeOfSection` is not pinned to the degree. What is actually
   missing is a *characterisation* of the homomorphism. The sibling project builds exactly this
   homomorphism sorry-free and without Quot — `Algebraic-Jacobian-Challenge-Rebuild`,
   `RiemannRoch/RelPicDegree.lean`, `relPicDeg : Additive (relPic C (overSpec k K)) →+ ℤ`,
   descended from `classDeg` along the observation that `Spec K` is a one-point space so its
   Čech Picard group is trivial and cannot contribute. Its own input is the closed χ-ledger
   `χ(𝒪(D)) = χ(𝒪_X) + deg D` (`RiemannRoch/ChiLedger.lean`), whose 22-file / 5.5k-line
   closure I measured to be free of `sorry`.

WHY `degree` ABOVE STAYS OPEN, and this is a statement-level defect rather than a missing
proof: it takes an *arbitrary* morphism `Spec k ⟶ (PicScheme C).left`, not a morphism over
`Spec k`. Such a morphism need not be a section of `(PicScheme C).hom` — the goal
`lambda ≫ (PicScheme C).hom = 𝟙 (Spec k)` is not derivable — so it does not name a
`k`-*rational* point and representability says nothing about it. A total function of that
type therefore cannot be built from the Picard functor at all; it would have to invent a
value off the sections. `degreeOfSection` below is the same construction on the correct
domain, and is total. Consumers should migrate; `degree` is retained only because
`kPoints_iff_kerDegree` is pinned against it. -/

/-- An additive integer-valued function on relative Picard classes of `C` over the base field
— the carrier shape of Milne III.1 p.~88.

**⚠ THIS CLASS IS VACUOUS AS STATED, and the docstring that used to sit here — "the one
remaining input to the degree map" — was FALSE.** Corrected run 0067 r2 after inbox issue
I-0534, re-verified by machine rather than accepted on report:

```