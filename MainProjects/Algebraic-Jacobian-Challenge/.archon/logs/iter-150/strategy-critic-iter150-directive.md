# Strategy Critic Directive — iter-150

Fresh context. **Do NOT read** `task_pending.md`, `task_done.md`, iter sidecars, prover task results, or review summaries. Operate only on the four inputs below.

## STRATEGY.md (verbatim)

[the current STRATEGY.md content lives at `.archon/STRATEGY.md`]

Read it from disk: `.archon/STRATEGY.md`.

## References summary (verbatim)

[the current `references/summary.md` content lives at `references/summary.md`]

Read it from disk: `references/summary.md`. Note: the user has flagged that a prior file `references/literature-crosscheck-iter149.md` was fabricated by the iter-149 plan-agent (no API key for `archon-informal-agent`); it has been deleted. A `reference-retriever` dispatch is in flight this iter to populate proper sources. The summary may therefore be sparse at the moment.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: the existence of an Albanese / Jacobian object over an arbitrary smooth proper geometrically irreducible curve `C/k`, with no `C(k) ≠ ∅` hypothesis on the protected signature. Nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness`. The end-state is zero inline `sorry`, kernel-only axioms. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of the original challenge file `references/challenge.lean`.

## Blueprint summary (titles + one-line topic, no chapter bodies)

- `AbelJacobi.tex` — Abel–Jacobi morphism from a pointed curve to its Jacobian.
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` — pointer chapter; content lives in `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" for the four (S3.*) sub-claims.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — pointer chapter for `Cotangent/GrpObj.lean`; `cotangentSpaceAtIdentity` trio.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris long exact sequence for sheaf cohomology + Čech-acyclicity machinery.
- `Cohomology_SheafCompose.tex` — sheaf composition with `forget` (CommRing → AddCommGrp).
- `Cohomology_StructureSheafAb.tex` — abelian-group structure sheaf + sheafify / Ext / HasSheafCompose.
- `Cohomology_StructureSheafModuleK.tex` — k-module structure sheaf + HModule / HModule' carriers, `cechCohomology_OC`, biproducts, short complexes.
- `Differentials.tex` — `Algebra.IsStandardSmooth` + `KaehlerDifferential`; the false-converse caveat for local-freeness of Ω.
- `Genus.tex` — `genus C := finrank_k H^1(C, O_C)` and supporting carriers.
- `Jacobian.tex` — top-level Jacobian existence; Route A (FGA via Picard scheme) vs Route B (Sym^n + Stein, historical).
- `Rigidity.tex` — `Scheme.Over.ext_of_eqOnOpen` (dominant-source + separated-target).
- `RigidityKbar.tex` — `rigidity_over_kbar` (k-agnostic signature) + the 5-piece chart-algebra envelope (α / β-core / lift / KDM / constants substep 3) + (S3.*) sub-decomposition.

## What I am still under critique on

The iter-149 strategy-critic dispatch returned CHALLENGE + DRIFTED with four sub-items, all absorbed in the current STRATEGY.md:
1. LOC reconciliation (342→419 + trigger arithmetic).
2. Path (b) "bypass" framing rewritten as "re-packages flat-base-change content".
3. `Differential.ContainConstants` typeclass-bridge spelled out as project material.
4. Iters-left widened 4–7 → 5–9 + DRIFT phrases excised.

A new open strategic question was added: H1Cotangent-vanishing alternative.

## Verdict requested

Per `dispatcher_notes`:
- SOUND / CHALLENGE / REJECT verdict.
- Format-audit (canonical skeleton compliance, LOC bound).
- Sunk-cost smells in the chart-algebra pivot framing.
- Re-evaluation of the H1Cotangent-vanishing alternative as a genuine path or a distraction.
- Spot-check the `Algebra.IsStandardSmooth.free_kaehlerDifferential` and `IsPurelyInseparable.surjective_algebraMap_of_isSeparable` Mathlib names if you suspect phantom infra.

Write report to `.archon/task_results/strategy-critic-iter150.md`.
