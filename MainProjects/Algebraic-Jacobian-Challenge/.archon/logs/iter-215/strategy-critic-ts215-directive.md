# Strategy-critic directive — iter-215

Read the strategy below as a fresh mathematician with no investment in the project's momentum.
Challenge sunk cost. Your job: is the long-arc plan sound, or is a route being pursued past the
point where the evidence supports it?

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected Lean declarations giving an
Albanese/Jacobian object `J := Pic⁰_{C/k}` for a smooth proper geometrically irreducible curve
`C/k` over an arbitrary field `k` (no rational point assumed, no characteristic-zero assumption);
`isAlbaneseFor` is quantified over the `k`-rational pointing. End-state: zero inline sorry in the
cone of each protected decl, 0 project axioms.

## STRATEGY.md (verbatim)

<<<
(see /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md — read it directly; it is the current cleaned version)
>>>

Read `STRATEGY.md` directly from disk now.

## Reference index (references/summary.md)

Kleiman "The Picard scheme" (FGA Explained) — Route A source, §4 existence, §5 Pic⁰/Jacobian, §6
Pic^τ. Nitsure "Construction of Hilbert and Quot Schemes" — Quot/Hilbert engine. Milne "Abelian
Varieties" — rigidity Thm 1.1, Thm 3.2/Prop 3.10 (rational→AV constant, RR-free), Albanese UP Prop
6.1/6.4. Mumford "Abelian Varieties". Stacks Project chapters (Varieties, Fields, Algebra, Coherent,
Constructions). Hartshorne. Full table in references/summary.md (read if needed).

## Blueprint chapter index (one line each)

Picard_TensorObjSubstrate (⊗-group law via monoidal SheafOfModules, route e — ACTIVE),
Picard_RelPicFunctor, Picard_FGAPicRepresentability, Picard_QuotScheme,
Picard_FlatteningStratification, Picard_RelativeSpec, Picard_LineBundlePullback,
Picard_IdentityComponent, Albanese_AlbaneseUP, Albanese_* (Route-1 cone, excised),
RiemannRoch_* (paused), AbelianVarietyRigidity, RigidityKbar, Genus0BaseObjects/*.

## Specific questions

1. Route (e) (instantiate Mathlib `LocalizedMonoidal` for the group law) is now one iter past its
   pivot, with the d.1-core landed and the residual scoped to d.1-bridge + d.2 (varying-ring stalk-⊗
   commutation, genuinely Mathlib-absent). This is the 4th distinct realization of the same group-law
   substrate (flat-exactness, route c, route d, route e). Is the substrate (`tensorObj =
   sheafification(presheaf tensor)`, Pic = Units of Skeleton) itself sound, or is the repeated
   re-realization a symptom of a wrong substrate choice? Is there a materially simpler path to the
   line-bundle group law that the project has not considered?
2. The whole Route A rests on a held A.2.c representability with a ~3400–5500 LOC RR-free Quot engine
   OR a ~600–1000 LOC RR route gated behind the USER ROUTE C PAUSE. Is the option-(c) posture
   (forward the Picard substrate while RR is frozen) defensible, given that A.2.c — the PRIMARY GOAL
   per USER directive — cannot close without one of those two?
3. Any structural error, hallucinated route, or missing prerequisite in the A.1.c.SubT → A.1.c →
   A.2.c critical path?

Verdict: SOUND / CHALLENGE / REJECT, with specifics.
