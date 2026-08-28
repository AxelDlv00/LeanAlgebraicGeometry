READ-ONLY measurement in /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (Lean 4 project "AJC"). Do NOT edit anything.

CONTEXT: classically, for a smooth proper curve C, the g-th symmetric power Sym^g C is isomorphic to the Hilbert scheme / scheme of effective divisors of degree g, Div^g(C). The AJC project has a lot of Quot-scheme and divisor-functor machinery in AlgebraicJacobian/Picard/. I want to know whether Sym^g C could be obtained as a REPRESENTING SCHEME of an already-representable functor in this tree, instead of via Milne's affine-and-glue quotient.

Measure and report with exact names, file:line, full signatures, and sorry-status:

1. `AlgebraicJacobian/Picard/DivFunctorDef.lean` — what exactly is `divFunctor`? Give its definition, its value on a test object T (what is a T-point?), and its degree-graded variants (`DivDegree.lean`). Is there a `DivFamily` structure? What is its definition?

2. IS `divFunctor` (or a degree-d piece of it) REPRESENTABLE in this tree? Search for: `divFunctor` + `RepresentableBy` / `Representable`, `DivScheme`, `HilbScheme`, `Hilb`, `divRepresentability`. Report the exact declaration if any, its hypotheses, and CRUCIALLY whether it is sorry-free or rests on a sorry (report the sorry-status of the file and of the specific declaration — you can grep for `sorry` as a term, ignoring occurrences inside docstrings/comments).

3. `QuotScheme.lean` / `QuotRepresentability.lean` / `QuotFunctorDef.lean`: what is proved? Is Quot representability landed sorry-free, or is it an open obligation / retained-not-revived? Look for docstrings saying "retained" or "not revived" — a team note said "Quot stays retained-not-revived". Report the actual state: which declarations exist, which are sorry-bodied.

4. Is there ANY declaration in AJC of the form "the scheme of degree-d effective divisors on C exists" or "C^{(d)} exists"? Also check the sibling project /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (task lanes ajcr-divrep suggests a "divrep" = divisor representability effort there!) — search that project for divisor-scheme representability, `DivRep`, `divRep`, `Div^d`, symmetric power. Report what exists there and its sorry state. There is a roadmap; you can run:
   cd /home/axel/LeanAlgebraicGeometry-Horizon && /home/axel/.archon-env/bin/horizon roadmap list
   and look for divrep-related nodes, and
   /home/axel/.archon-env/bin/horizon search "<query>" --json
   for declaration search across all projects + mathlib.

5. Separately, measure the OTHER route's key algebra input: does mathlib at this pin have "invariants commute with localization at an invariant element", i.e. for a finite group G acting on a commutative ring A and b ∈ A^G, is (A_b)^G = (A^G)_b? Search for `IsLocalization` + invariant / fixed points, `FixedPoints` + `Localization`, `Algebra.IsInvariant` + `Localization`, `IsInvariant.localization`. Also: is there anything about `Spec A → Spec A^G` being a quotient map of topological spaces, or `PrimeSpectrum` + `MulAction` + orbit / `PrimeSpectrum.comap` quotient? Report EXISTS/DOES NOT EXIST with names.

Report as 5 numbered sections with hard evidence, then a 6-sentence "VERDICT" comparing the two routes to Sym^g C: (i) via an already-representable divisor/Hilbert functor in-tree, (ii) via affine invariants + gluing. Say which is closer to landable today and name the concrete first lemma to prove for the better one. Do not speculate beyond measurements.
