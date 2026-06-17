# Strategy Critic Directive

## Slug
iter146

## What you read

1. Current `STRATEGY.md` verbatim at
   `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
   (~701 lines; iter-145 left it ~150 lines over the canonical 250-line
   bound — see Q5 below).
2. `references/summary.md` at
   `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`
   (one-line index; the project's only reference is `challenge.lean`).
3. Blueprint chapter titles + one-line topics — read the first 5 lines
   of each `blueprint/src/chapters/*.tex` if needed (11 chapters; titles
   listed in the Blueprint summary section below for convenience).

## What you do NOT read

- `iter/iter-NNN/*.md` for any N (no iter sidecars).
- `task_pending.md`, `task_done.md`, any `task_results/*` other than
  your own report path.
- `proof-journal/`, `PROJECT_STATUS.md`, `PROGRESS.md`.

If you accidentally encounter any of these, ignore them.

## Project stated goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge (`references/challenge.lean`). The non-trivial
residual is the body of `AlgebraicGeometry.nonempty_jacobianWitness`,
signature frozen at `(C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom]
[IsProper C.hom] [GeometricallyIrreducible C.hom] : Nonempty (JacobianWitness C)`.
Strategy decomposes via `by_cases h : genus C = 0` into
`genusZeroWitness` (M2) + `positiveGenusWitness` (M3). The protected
declaration quantifies over an arbitrary curve with no
$k$-rational-point hypothesis, so over-`k̄` paths that assume
`C(k) ≠ ∅` are mathematically false on the protected signature.

## Blueprint summary (titles + one-line topics)

- `Cohomology_SheafCompose.tex` — sheaf-compose for `CommRing → Ring → Ab`.
- `Cohomology_StructureSheafAb.tex` — sheafification + Ext for Ab on opens.
- `Cohomology_StructureSheafModuleK.tex` — sheaves of `k`-modules + Ext-with-`k`.
- `Cohomology_MayerVietoris.tex` — MV LES for sheaf cohomology + Čech-acyclicity.
- `Differentials.tex` — relative cotangent presheaf + `smooth_locally_free_omega`.
- `Genus.tex` — `genus C := finrank_k H^1(C, O_C)`.
- `Jacobian.tex` — Jacobian + M2/M3 decomposition + iter-145 Route A reconciliation.
- `Rigidity.tex` — `Scheme.Over.ext_of_eqOnOpen` (scheme-level Mumford §4).
- `RigidityKbar.tex` — M2.a `rigidity_over_kbar` (k-agnostic) + NEW iter-145 subsection "Chart-algebra piece (ii) first-class decomposition" (L1773–L1944, 5 `\lean{...}` blocks tagging the iter-145 ChartAlgebra.lean placeholders).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — pointer chapter for `Cotangent/GrpObj.lean` (iter-145 EXCISE left 5 stale `\item`s pointing to deleted decls).
- `AbelJacobi.tex` — three protected decls as projections from the Albanese witness.

NOTE: there is NO `AlgebraicJacobian_Cotangent_ChartAlgebra.tex`
chapter file; iter-145 routed the chart-algebra content into a
subsection of `RigidityKbar.tex` rather than a new chapter.
`blueprint/src/content.tex` does NOT `\input` such a file. Iter-146
plan agent is aware; flag if this routing introduces strategic
incoherence.

## Iter-146 plan agent's stated reading

- Active critical-path route: **chart-algebra piece (ii)** in
  `Cotangent/ChartAlgebra.lean` (5 sub-pieces; iter-146 fires the
  first prover lane on 3 of 5 blueprint-adequate sub-pieces).
- Bundled-route piece (i.b)+(i.c)+(iii) DESCOPED + EXCISED iter-145.
- M3 Route A is COMMITTED iter-144 per user-hint; scheduled behind M2.
- The Q5 STRATEGY.md size-compaction (~700 → ~400 LOC target) is live
  for iter-146 OR iter-147; planner intent is one bundled compaction
  relocating iter-127→iter-136 decision blocks + Route B historical
  detail to a `STRATEGY-history.md` archive.

## Prior critique status

Format strictly: `<prior-iter>: <short challenge phrase> — live | addressed`.

- iter-141: REJECT THE PIVOT (over-k → over-`k̄` was wrong corrective; piece (i.b) is base-independent) — addressed
- iter-141: preservation-of-bundled-framing pattern at the artefact-disposition level — addressed (iter-145 excise landed)
- iter-142: pile-pieces operational-convention simplification — addressed
- iter-143: Sorry-must-be-named-declaration soundness rule — addressed
- iter-143: Consecutive-PARTIAL breakeven counter discipline — addressed (counter wired; iter-144 chart-algebra pivot reset the bundled-route counter)
- iter-144: M2.a `df = 0` derivation chain articulated honestly — addressed (with iter-145 Q3 internal-contradiction resolution)
- iter-144: M3 Route A audit refresh required iter-145 — addressed (`mathlib-analogist-m3-route-a-refresh-iter145` AUDIT_STABLE; 6500 → 6070 LOC)
- iter-144: iter-150 over-k vs over-`k̄` sunk-cost guardrail — addressed (iter-145 Q6 reframed to symmetric + rolling mid-iter trigger)
- iter-145: Q2 Mathlib gap inventory re-dated iter-145 + chart-algebra entries added — addressed
- iter-145: Q3 M2.a `df = 0` chain internal contradiction resolved (named-Serre-duality NOT invoked; cohomological content `H^0(C, Ω_{C/k}^{⊕n}) = 0` IS invoked via chart-Čech MV) — addressed
- iter-145: Q4 (mild) M3 Route A dependency completeness (4 prerequisite items bundled into A1/A2/A3 in `analogies/m3-route-a-refresh-iter145.md`) — addressed
- iter-145: Q5 STRATEGY.md size compaction (~700 → ~400 LOC target) — live (deferred to iter-146/147)
- iter-145: Q6 iter-150 over-k symmetric reframe + rolling mid-iter trigger — addressed
- iter-145: Q7 bundled-route excise (artefact-disposition discipline) — addressed (5 declarations excised iter-145; auditable record IS git history per Q7)

Please verify the "addressed" items in the current STRATEGY.md content
and flip back to `live` for any you disagree with. Specifically, please
audit:

A. **Internal coherence between (a) the iter-145 chart-algebra
   commitment in § Iter-144 chart-algebra pivot, (b) the iter-138
   "operationally defaulted" over-k framing under § Sequencing →
   Direct over-k rigidity, (c) the iter-141 base-independence finding
   that supersedes the over-k re-defense.** Does any text still treat
   the over-k commitment as load-bearing on top of the chart-algebra
   pivot?

B. **The iter-145 Q3 framing distinction** ("name-of-theorem Serre
   duality NOT invoked" vs "cohomological content `H^0(C, Ω_C) = 0`
   IS invoked via chart-Čech Mayer–Vietoris"). Does the soundness-rules
   bullet at L441–L446 read internally consistent post the iter-145
   Q3 absorption, or does any residual phrasing still claim "vanishing
   of global sections of `Ω_C` is NOT invoked"?

C. **Q5 STRATEGY.md compaction**: is the planner's intended
   compaction-direction sound (relocate iter-127→iter-136 decision
   blocks + Route B historical detail to a `STRATEGY-history.md`
   archive)? If you have a strong opinion on whether to compact
   iter-146 vs iter-147 (or unbundle into multiple smaller edits),
   surface it.

D. **The non-standard slug mapping for `Cotangent/ChartAlgebra.lean`**
   (chart-algebra content in `RigidityKbar.tex` subsection, no
   dedicated chapter file): is this a strategic incoherence worth
   addressing, or pedagogically clean as the iter-145 planner
   intended?

E. **Anything else** that a fresh reader would call out as a strategic
   red flag — the chart-algebra pivot is freshly landed (iter-145), so
   this iteration is a good moment to verify the new strategy is
   internally coherent.
