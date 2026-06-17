# Lean ↔ blueprint check — QuotScheme

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

## What changed this iter
Two new `IsLocalizedModule`-transport bridges for the gap1-D `Hfr` chain (both axiom-clean, non-private):
- `Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear` — ingredient (I): transport `IsLocalizedModule` across a ring iso + a pair of semilinear `AddEquiv`s.
- `Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap` — ingredient (II): descend a localization at `powers (algebraMap R Rr f)` over `Rr` to `powers f` over `R`.
The downstream `Hfr` assembly / named `isLocalizedModule_basicOpen_descent` / gap1 were NOT attempted this iter (large geometric chain). The prover flags both new decls as `lean_aux` coverage debt — the chapter only mentions them in a NOTE under `lem:pullback_gamma_top_iso`, not as proper lemma blocks.

Note: the file carries 4 long-standing protected `sorry` stubs (`hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`Grassmannian.representable`) — these are frozen scaffold, not regressions.

## Report
(a) Lean → blueprint: fake/placeholder statements, `\lean{...}` mismatches, proof divergence.
(b) Blueprint → Lean: chapter detail adequacy; uncovered new decls (coverage debt).
Flag must-fix-this-iter items explicitly. Read-only.
