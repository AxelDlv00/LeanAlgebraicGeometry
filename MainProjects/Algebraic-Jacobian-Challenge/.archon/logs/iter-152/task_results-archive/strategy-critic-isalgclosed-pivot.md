# Strategy Critic Report

## Slug
isalgclosed-pivot

## Iteration
152

## Routes audited

### Route: Route C — chart-algebra piece (ii), over `[IsAlgClosed kbar]`

- **Goal-alignment**: PASS — the over-`k̄` rigidity + descend-to-`k` plan reaches the
  over-arbitrary-`k` protected goal. `rigidity_over_kbar` is literally the over-`k̄`
  statement and is unprotected; its docstring already assumes `k̄` algebraically
  closed, so adding `[IsAlgClosed kbar]` matches intent, not goal drift.
- **Mathematical soundness**: PASS — the `k̄ → k` descent of morphism *equality* is
  sound and, contrary to the strategy's hedge, has a **direct Mathlib hook**.
  `π : C_{k̄} → C` is flat+surjective (base change of the field extension
  `Spec k̄ → Spec k`), hence an epimorphism of schemes
  (`AlgebraicGeometry.Flat.epi_of_flat_of_surjective`). Base-change-square
  commutativity gives `π ≫ f = f_{k̄} ≫ π_A`, so `f_{k̄} = g_{k̄} ⟹ π ≫ f = π ≫ g`,
  and epi-cancellation yields `f = g`. No separatedness of `A`, no equalizer
  argument, no proper-cohomology base change needed. The corrected KDM signature
  (`[IsAlgClosed k]`+`[CharZero k]`+`[IsDomain B]`+std-smooth) kills both
  counterexamples (CE1 by `[IsDomain B]`, CE2 by `[IsAlgClosed k]`) and is now a
  TRUE statement; its residual "`k` alg-closed in `B`, char-0 ⟹ `ker D ∩ B = k`"
  transfer step is the one genuinely-open math obligation, but it is no longer
  false.
- **Sunk-cost reasoning detected**: yes (mild) — see Sunk-cost flags.
- **Effort honesty**: reasonable, with one over-stated gap in the *honest* direction.
  The "(NEW) faithfully-flat descent of morphism equality" is listed as a Mathlib
  gap to "assess … when `genusZeroWitness` activates", but the assessment is already
  decidable now: `epi_of_flat_of_surjective` exists. The displaced-cost trade
  (`constants` → descent) is therefore *favorable*, not merely lateral. The
  `constants_integral_over_base_field` "~15 LOC" collapse is also genuinely backed:
  `finite_appTop_of_universallyClosed` supplies `Algebra.IsIntegral k Γ` and
  `IsDomain Γ` from integral `C`, so `algebraMap_bijective_of_isIntegral` applies —
  this is NOT resting on a phantom coherent-cohomology-finiteness theorem.
- **Verdict**: SOUND — the pivot is well-grounded; both newly-load-bearing gaps
  (descent, constants finiteness) have verified Mathlib hooks. Proceed.

### Route: Route A — Picard scheme via FGA

- **Verdict**: SOUND — off-critical-path; ~5100 LOC midpoint with A1 (~3775) flagged
  as an irreducible Quot/Hilbert floor. Honesty of the floor was addressed in the
  prior critique. No new concern.

### Route: Alternative — over-`k̄` + Galois descent (DECORATIVE)

- **Verdict**: SOUND but now partially redundant — this alternative's distinguishing
  feature (descend along `Spec k̄ → Spec k`) has been *adopted into Route C*. The
  line between "Route C over `k̄`" and "the over-`k̄` alternative" has collapsed; the
  alternative no longer describes a genuinely separate route. Recommend folding its
  one live idea (now realized) into Route C and deleting the stub (see Accumulation).

### Route: Hybrid pivot (analogist) — (A)/(B)/(C)

- **Verdict**: SOUND content, but this subsection is largely status-bookkeeping
  ("COMMITTED", "moot under part (A)", "DISCARDED") — see Format / Accumulation. The
  mathematical substance (part A committed, part C scaffold reusable) is already
  captured in Route C; the (A)/(B)/(C) ledger duplicates it.

## Format compliance

- **Size**: ~232 lines / ~14 KB — over budget on bytes (~14 KB > 12 KB); within line
  budget. The byte overage is driven by the per-iter narrative and the duplicated
  Hybrid/Alternative ledgers; trimming both fixes size and the narrative violation
  together.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
  (`## References index` / `## Blueprint summary` belong to the critic directive, not
  STRATEGY.md.)
- **Per-iter narrative detected**: yes — pervasive. Representative verbatim phrases:
  "the iter-151 prover lane proved", "reverses the iter-127 over-k commitment",
  "(was user-gated; decided YES at iter-152 after the KDM-false STUCK trigger)",
  "(DECIDED iter-152, YES)". The format rules explicitly bar `iter-NNN` references
  in STRATEGY.md; this history belongs in `iter/iter-152/plan.md`.
- **Accumulation detected**: yes — the "Hybrid pivot (analogist-recommended)"
  subsection (status ledger for (A)/(B)/(C) incl. "moot"/"DISCARDED") and the
  "Alternative — over-`k̄` + Galois descent (DECORATIVE)" stub both track
  considered/rejected/now-absorbed alternatives that duplicate Route C. The
  "DISCARDED direct H1Cotangent-vanishing pivot" with its `analogies/…iter150.md`
  pointer is rejected-alternative history.
- **Table discipline**: PASS on columns (Phase | Status | Iters left | LOC | Key
  Mathlib needs | Risks); cells are verbose (multi-clause Status/Risks) but remain
  tabular.
- **Format verdict**: DRIFTED — core skeleton intact, but the pervasive `iter-NNN`
  narrative and the duplicated Hybrid/Alternative ledgers must be cleaned in-place
  this iter (no full restructure required).

## Sunk-cost flags

- "the (C.a)–(C.c) scaffold is **closed and reusable**" + "Route C still tolerates
  **no sorry-count-inflating re-decomposition** of the KDM lemma" — Why this is
  sunk-cost: the justification for keeping the Kähler/`df=0` machine and patching a
  *just-proven-false* lemma's hypotheses leans on the existing scaffold being done,
  rather than re-asking — now that `[IsAlgClosed kbar]` + morphism-equality descent
  are committed — whether a cleaner over-`k̄` rigidity (e.g. a direct "no nonconstant
  map `ℙ¹_{k̄} → A`" argument) would be cheaper. Recommendation: decide the KDM route
  on its current merits. Its merits-based defense is real and probably wins — the
  chart-Čech route is the project's deliberate **Serre-duality avoidance**
  (`H⁰(C,Ω^⊕n)=0` without the 3000–8000 LOC named theorem), and the cleaner geometric
  alternative is *also* absent from Mathlib — so this is a mild flag, not a REJECT.
  But the strategy should state the merits reason, not the "already closed" reason.

## Prerequisite verification

- `IsAlgClosed.algebraMap_bijective_of_isIntegral`: VERIFIED (`Mathlib.FieldTheory.IsAlgClosed.Basic`; requires `[IsDomain K]`+`[Algebra.IsIntegral k K]`, both supplied for `Γ(C,𝒪)`).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
- `MvPolynomial.mkDerivation` / `MvPolynomial.pderiv`: VERIFIED (`Mathlib.Algebra.MvPolynomial.{Derivation,PDeriv}`).
- `AlgebraicGeometry.Flat.epi_of_flat_of_surjective`: VERIFIED (`Mathlib.AlgebraicGeometry.Morphisms.Flat`) — the descent hook; the strategy did not name it but should.
- `AlgebraicGeometry.finite_appTop_of_universallyClosed` / `isField_of_universallyClosed`: VERIFIED (`Mathlib.AlgebraicGeometry.Morphisms.Proper`) — backs the `Γ` finiteness/integrality the constants collapse assumes.
- `Scheme.Over.ext_of_eqOnOpen` (`Rigidity.lean` `ext_of_eqOnOpen`): project material, not audited here (not a Mathlib name).

## Must-fix-this-iter

- Format: DRIFTED — clean STRATEGY.md in-place this iter. (1) Strip all `iter-NNN`
  references (the four quoted above and any others), moving the decision history to
  `iter/iter-152/plan.md`. (2) Delete or fold the duplicated "Hybrid pivot
  (A)/(B)/(C)" ledger and the now-absorbed "Alternative — over-`k̄`" stub into Route
  C. Both edits also bring bytes back under ~12 KB.
- Route C: not a CHALLENGE, but record the descent-hook finding —
  `epi_of_flat_of_surjective` resolves the "(NEW) faithfully-flat descent" gap in the
  planner's favor; the reversal-trigger worry ("descent needs MORE infra than the
  (S3.pi.1) gap it replaced") can be retired, not left pending.

## Overall verdict

A fresh mathematician would approve the `[IsAlgClosed kbar]` pivot. It is
goal-aligned (the over-`k̄` rigidity descends to the over-arbitrary-`k` protected
statement), and — crucially — both gaps the pivot newly leans on have verified
Mathlib hooks: the `k̄→k` descent of morphism equality is a two-line consequence of
`epi_of_flat_of_surjective` plus base-change-square commutativity, and the
`constants_integral_over_base_field` collapse rests on `finite_appTop_of_universallyClosed`
+ `algebraMap_bijective_of_isIntegral`, not on a phantom finiteness theorem. The
(S3.pi.*) flat-base-change gap is genuinely descoped (not merely relocated): the cost
moves to a descent step that turns out to be cheaper than the gap it replaced. The
KDM signature correction is sound (the corrected lemma is TRUE). Two non-blocking
concerns: a mild sunk-cost framing around the "closed and reusable" KDM scaffold
(decide it on its Serre-duality-avoidance merits, which it likely wins), and a
DRIFTED format — pervasive `iter-NNN` narrative plus duplicated Hybrid/Alternative
ledgers that should be trimmed in-place this iter.
