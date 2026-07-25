I have enough evidence. Here is the verdict.

## 1. The definitions

**`IsLocallyCertified`** — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyZar.lean:71`: `∃ m (g : Fin m → R), Ideal.span (range g) = ⊤ ∧ ∀ i, ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n, DivEq G.eqns (d.pullback …)`.

**`CertifiedDivisorFamily`** — `.../Picard/DivisorFamily.lean:452`: fields `eqns : LocalEquations`, `adaptation : DivisorAdaptation`, `certified : adaptation.IsCertified n`.

**`IsCertified`** — `.../Picard/DivisorFamily.lean:426`, seven fields: (c1) `finite_colength`, `projective_colength`; (c2) `finite_glued`, `projective_glued`, `rankAtStalk_glued = n`; (c3) `flat_coker_incl`; (c4) `flat_coker_diff`.

## 2. Inhabitation: exactly one unconditional source, and it is field-only

There is **no** `Nonempty`/`Inhabited` instance, no `DivFamZar.zero`, no unit-section/trivial-divisor construction anywhere (grep for `Nonempty (DivFamZar`, `Inhabited (DivFam`, `instance … DivFamZar` returns only docstring hits).

The only unconditional producer of a `CertifiedDivisorFamily` from nothing is over a **field** base:
- `.../Picard/DivisorFamilyFieldSurj.lean:147` `exists_divFam_divFamDivisor_eq`: for `K` a field, every effective `D` with `deg K D = n` gives `F : DivFam C K π n`. It combines `exists_localEquations_presentationDivisor_eq`, the free `exists_divisorAdaptation` (`DivisorFamilyExtraction.lean:54-55`, `Nonempty (DivisorAdaptation …)` for *any* `d`), and `DivisorAdaptation.isCertified_of_deg` (`DivisorFamilyFieldSurj.lean:107`) — over a field every module is free, so (c1)/(c3)/(c4) are instances.
- Everything else is conditional: `DivisorFamilyMapAlg.lean:266` (`mapAlg`, pushes an existing family), `DivSchemeEps.lean:239-243` (`certifiedFamily`, takes `hc : IsCertified` as input), `DivSchemeCertZarSeed.lean:133-145` and `DivSchemeCertZarPointwise.lean:180-191` (both take "a certified family exists over each `Localization.Away`" as a *hypothesis*). None discharges it.

So `DivFamZar C S π g` for a general test ring `S` has **no landed inhabitant at all**; over a field `K` it is inhabited exactly as far as effective degree-`n` divisors on `relCurve C K` are (nothing in the tree produces one for `n = g`; `divFamFieldEquiv`, `DivisorFamilyFieldSurj.lean:162`, only transports the problem).

## 3. The no-go in DivSchemeCertZarConfine.lean

`isClosed_supportLocus_inter_chart_of_isCertified` (`DivSchemeCertZarConfine.lean:192`) forces, from clause (c1) alone and with **no connectivity hypothesis**: both `supportLocus ∩ V₀` and `supportLocus ∩ V₁` are **closed** in `relCurve C R`. Consequences landed in the same file: `not_isCertified_of_not_isClosed_inter_chart₀` (:206), and — crucially for vacuity — `not_isCertified_of_divEq_of_isPreconnected_of_witnesses` (:222) together with `DivEq.supportLocus_eq` (:110ish), which makes the obstruction an invariant of the `DivEq` class, i.e. of `DivFamZar` itself, not of a representative. Combined with `DivSchemeCertZarVerdict.lean:67` (`not_isCertified_of_isPreconnected_of_witnesses`), any connected divisor with a support point off `V₀` and one off `V₁` is excluded **in every degree, over every Zariski shrink of the base**.

## 4. Spec verdict (spec-dd-r.md:487 ADDENDUM 3, :647 CORRIGENDUM; inbox I-0333, I-0346)

- ADDENDUM 3 §1(c): explicit witness `Z(tX² + XY + tY²)` over `k[t]` is irreducible, finite flat of degree 2, fibre `{0,∞}` at `t=0` — **not `IsLocallyCertified`**, and no shrink evades it. CORRIGENDUM C1: the witness is **field-independent** (so enlarging `k` does not help) and remains a *paper* argument — "no Lean declaration instantiates it" (~500 lines of work).
- ADDENDUM 3 §1(d) + C2 (β1): the obstruction survives the `DivEq` quotient and follows from (c1)-finiteness for *any* cover, so `DivFamZar` "is not the relative-divisor functor, and `divRep` stated against it represents the wrong object."
- I-0346 escalates the residual open question: over a small finite field with `|P¹(k)| = q+1 < n+2`, "**what is `DivFamZar` supposed to be?**" — unresolved, roadmap leaf `certificate.field-size`.

**Adversarial bottom line.** `DivFamZar C S π g` is *not* proved empty, but the only landed inhabitation is over a field base with an effective degree-`n` divisor in hand (`DivisorFamilyFieldSurj.lean:147`); over the general test rings that `DivRepClassifyZar.lean` (variable block :60-80, `{S : Type u} [CommRing S] [Algebra k S]`) quantifies over, **zero** inhabitants exist in the tree, and the Confine/Verdict no-go proves whole natural classes of divisors (any connected one meeting both vertical fibres — the generic case in a family) are permanently excluded. So theorems `∀ F₀ : DivFamZar C S π g, …` are not literally vacuous (field bases save them, modulo divisor existence), but they are **provably restricted to chart-confined divisors**, which is why the spec calls the functor the wrong object. Any downstream claim that `divRepClassifyZar` represents `Pic⁰`/the relative-divisor functor is at genuine risk; the risk is documented, not hidden.
