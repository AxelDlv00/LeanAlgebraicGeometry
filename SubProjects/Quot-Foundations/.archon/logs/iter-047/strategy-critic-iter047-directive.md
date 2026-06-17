# Strategy critic — iter-047

Fresh-eyes audit of the project strategy. Read these and nothing else:
- `STRATEGY.md` (verbatim — the current strategy).
- `references/summary.md` (the reference index).
- Blueprint chapter titles (one topic each):
  - Cohomology_FlatBaseChange: flat base change for pushforward of qcoh sheaf (i=0)
  - Cohomology_RegroupHelper: regrouping iso for affine base-change tensor tower
  - Picard_FlatteningStratification: flattening stratification / generic flatness
  - Picard_GrassmannianCells: the Grassmannian over ℤ (charts/glue/sep/proper)
  - Picard_QuotScheme: the Quot scheme (Hilbert poly, Quot functor, predicates, qcoh descent)
  - Picard_RelativeSpec: relative Spec
  - Picard_SectionGradedRing: section graded ring infra (tensor powers, graded sections)

## Project goal (one paragraph)
Close the sorry-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman, FGA "The Picard scheme", §4): flat base change
(i=0) FBC, generic flatness GF, and the Quot foundations QUOT (Hilbert polynomial, Quot functor,
Grassmannian representability), then merge back with the parent's names/labels. End-state: zero
project sorry in the 29-node closure, zero project axioms, kernel-only axioms.

## Questions to challenge
- Is the current phase ordering / parallelism sound now that QUOT gap1+gap2 + annihilator are
  DONE, FBC is PARKED (kill-criterion fired, off critical path), and GF base-case + SNAP are the
  two lanes opening next?
- Is parking FBC (rather than escalating or pivoting its route) the right call given it has no
  QUOT/GF/GR dependency?
- Does the GF base-case route (affine-qcoh exactness of Γ / Stacks 01PB, NOT stalkwise-epi) match
  what the references support? Any missing prerequisite or hidden case split?
- Is the SNAP route (chosen f.g. presentation; `def:sectionGradedRing` tensor-powers sub-build)
  the right primary, or is Open Q1 a real fork that should be decided before scaffolding?

Output SOUND / CHALLENGE / REJECT per concern. Do not read iter sidecars or prover narrative.
