# strategy-critic directive — iter-237

Re-verify the global strategy with fresh eyes. Context: a major milestone landed —
the d.2 stalk–tensor commutation isomorphism (`stalkTensorIso`), the ~19-iter bottleneck
ingredient of the Picard group law, is now COMPLETE and axiom-clean. STRATEGY.md is updated
this iter to reflect that the A.1.c.SubT bottleneck moves from "build d.2" to "wire
stalkTensorIso into the associator's whiskering obligation, then close the by-hand CommGroup".
The route (carrier = tensor-invertibility, inverse free; associator via d.2) is UNCHANGED.

## STRATEGY.md (verbatim)

<see /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md>

## Reference index

<see /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md>

## Blueprint chapter titles (one-line topic each)

<derive from blueprint/src/chapters/*.tex first lines>

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: the nine protected declarations headed by
`AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object
uniform over the k-rational pointing of a smooth proper geometrically irreducible curve C/k
([Field k] only; no C(k)≠∅, no CharZero). J := Pic⁰_{C/k} built unconditionally; only
`isAlbaneseFor` is quantified over the pointing. End-state: zero inline sorry in the dependency
cone of each protected decl, 0 project axioms, kernel-only axioms.

## Questions for you

1. Now that d.2 is done and the group law is within reach, is the critical path
   A.1.c.SubT → A.1.c → A.2.c still the soundest arc to the PRIMARY GOAL (Pic_{C/k}
   representability, A.2.c), or does the milestone change the cost calculus toward any
   alternative?
2. The live strategic risk repeatedly flagged: autoduality `J^∨≅J` RR-freeness (the only
   planned path — Route 2 Albanese UP — to the goal-required `isAlbaneseFor`). It is classically
   RR-dependent (theta divisor). Route C (Riemann–Roch) is under a permanent USER pause. Is the
   strategy carrying an unaddressed dead-end risk here that should be second-verified NOW (before
   more substrate investment), or is deferring it until A.2.c closes still correct?
3. Any structural error, hallucinated route, or missing prerequisite in the post-milestone arc?

Read the actual reference sources where a claim is load-bearing. Challenge sunk cost.
