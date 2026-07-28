---
author: sync
content_type: instance
created: '2026-07-28T05:48:19'
decl: anyone
file: scripts/axiom-frontier.lean
generated: lean
lean_status: sorry
stale: true
title: anyone
type: lean
updated: '2026-07-28T18:12:24'
---
instance anyone would use, `¬H`. The theorem is true, axiom-clean, non-vacuous by every probe
in this file, and empty.

Measured instance (2026-07-28, `RiemannRoch/Adelic/LedgerClosure.lean`): `chi_eq_of_bump`
takes `hbump : ∀ P E, χ(1·P + E) = χ(E) + residueDeg P`. Iterating it down the anti-effective
cone forces `χ(-m·P) = χ(0) - m·[κ(P):k]`, and since `χ = ℓ - h¹` with `ℓ ≥ 0`, `h¹` must grow
linearly there. So `hbump` is FALSE on every cover whose `h¹` is bounded — and outright false
at the degenerate cover `U₀ = U₁ = ⊤`, where the Čech `H¹` vanishes identically, as soon as a
single prime divisor exists. That refutation needs no exactness data at all.

THE OFF-CHART REFUTATION, and the two-step history of this paragraph is the most instructive
part of the entry, because the trap caught the audit and then caught the retraction.

Round 1 (the audit, `I-0449`): a second refutation "at each prime outside the overlap", on the
grounds that `A(1·P + E) = A(E)` there makes the local step a subsingleton, so
`ChiLedger.chi_add` gives a χ-jump of `0` against `hbump`'s `residueDeg P ≥ 1`.

Round 2 (my retraction, and it was WRONG): I withdrew that on the grounds that the derivation
runs through `chi_add`, so it measures `chi_add`'s exactness hypotheses rather than `hbump` —
citing `Adelic.bump_iff_chartStep_of_notMem_left`, which makes `hbump` at such a `P` equivalent
to the surviving one-chart step being `[κ(P):k]`, and concluding `hbump` is merely weaker there
rather than false.

Round 3 (`I-0467`, machine-checked, and it reinstates round 1): the one-chart step cannot be
`[κ(P):k]` repeatedly, because the overlap term `A` is FROZEN along the tower `n·P`
(`sectionSub_add_pointDivisor_of_notMem`, iterated) and the coboundary term is trapped beneath
it (`S₁(D) ≤ A(D)`). So in `χ = dim S₀ + dim S₁ − dim A` all three terms are bounded along the
tower while `hbump` forces linear growth. Hence `¬hbump` off the chart, from this file's own
theorems and its own finiteness binders, with **no** `chi_add` and no exactness hypothesis
anywhere. The equivalence I cited is true and does not say what I used it for: its right-hand
side is itself false for large `n`. `Adelic.not_bump_of_notMem_left` and
`Adelic.ledger_refuted_of_notMem_left` are the landed forms (§6f), and `P.point ∉ U₀` is far
weaker than `P.point ∉ U₀ ⊓ U₁`, so the refutation reaches MORE primes than the audit claimed.

Honest status of `hbump`: consistent (`bump_of_isEmpty_primeDivisor`); refutable at
`U₀ = U₁ = ⊤` given one prime divisor; refutable on every bounded-`h¹` cover; refutable
whenever any prime divisor lies off one chart; satisfiable only where `h¹` is unbounded on the
anti-effective cone. The closed ledger itself is refuted on the same covers. None of that
contradicts the vanishing lane, whose results are high-degree only — which is why nobody
noticed.

The generalisable lesson, and note that it cuts BOTH ways, which is what round 2 missed. When a
hypothesis `H` and a lemma `L` are inconsistent together, that does not tell you which is at
fault: establishing that `H` is refutable requires deriving `¬H` from things THEMSELVES
satisfiable. That is why round 1's argument was not yet conclusive. But it equally does not
license concluding `H` is *fine* — round 2 inferred "not refutable" from "not refutable by this
route", which is the same error with the sign flipped, and an ungated derivation existed the
whole time. The correct response to "your refutation measured the wrong thing" is to look for an
ungated derivation, not to withdraw the conclusion. Recorded as I-0449/I-0454/I-0467, with the
durable lessons at I-0451 and I-0468.

What defeats each check, in order: `#print axioms` sees a clean line; a consistency witness
exists (`bump_of_isEmpty_primeDivisor`, on a scheme with no prime divisors); an elaboration
probe synthesises every binder; and non-vacuity in the trap-(c) sense holds, because the
hypothesis is not contradictory — it is merely refutable where it is wanted. The only check
that finds it is reading the PRODUCER's side conditions and asking whether the family the
hypothesis quantifies over contains members where the tree proves the negation.

So the discipline this adds to the other six: for a hypothesis quantified over a family, do
not stop at "is it satisfiable". Ask where the project can derive its negation. Recorded as
I-0449/I-0454 with the machine-checked steps, and as the durable lesson I-0451.

ROUND 4, and it closes this entry by invalidating rounds 1-3 AT A CURVE (task ajc-rr,
2026-07-28, `RiemannRoch/Adelic/ChartFinitenessRefuted.lean`, sorry-free and axiom-clean).
Every refutation above runs on the binder `[∀ D, Module.Finite k (sectionSub k U₀ D)]` at a
NON-TOTAL open. That binder is not merely restrictive: it is UNSATISFIABLE on a curve. One