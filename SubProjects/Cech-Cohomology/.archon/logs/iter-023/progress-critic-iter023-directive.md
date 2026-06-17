# Progress-critic directive — iter-023

Assess convergence per active route for the iter-023 prover assignment. Verdict per route.

## Route 2 — P3b free side: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`

Named target: `cechFreeComplex_quasiIso` (the free-presheaf complex is a quasi-isomorphism /
resolution of `O_𝒰`). Strategy `Iters left` for P3b: ~4–7. The file entered its current
sub-bottleneck (the evaluated-engine identification) at iter-019.

Signals, last 4 iters (sorry count is 0→0 every iter — the named target is an all-or-nothing
`def`, never pinned with `sorry`, so "0 sorries" does NOT mean closed):

- **iter-019**: built `cechFreeSimplicial` backbone + `quasiIso_of_evaluation` (joint-conservativity
  reduction to per-`V`). Named target ABSENT. Status PARTIAL.
- **iter-020**: +10 decls — the `FreeCechEngine.*` combinatorial engine + the empty-case quasi-iso
  + per-summand evaluation bricks. Named target ABSENT; blocked on the nonempty differential match.
  Status PARTIAL.
- **iter-021**: NOOP — the lane was dropped by plan-validate (scaffold keyword on the wrong physical
  line). No prover ran. No new data.
- **iter-022**: +14 decls — the ENTIRE engine target complex `cechEngineComplex` (`cechEngineD`,
  `d²=0` `cechEngineD_comp`, contracting homotopy `cechEnginePrepend_spec` closed first try,
  positive-degree exactness `cechEngineD_exact`) PLUS the object half of the engine iso
  (`cechFreeEvalEngine_X`, `survivingEquiv`, `cechFreeEvalDropZeros`). Named target
  `cechFreeEvalEngineIso` ABSENT — the residual is now ONE comm-square lemma (the chain-vs-cochain
  differential variance match on coproduct injections), with all inputs in-file and a documented
  60–120-line route. Status PARTIAL.

Recurring blocker phrase across iters: "differential variance match / comm-square on `Sigma.ι`"
(the free chain differential lowers Fin-arity via `σ↦σ∘succAbove i`; `combDifferential` raises it).

This iter's proposed corrective (already in motion): blueprint-writer expands the
`lem:cech_free_eval_engine_iso` proof sketch with the `survivingEquiv`/drop-zeros naturality step
(the lean-vs-blueprint-checker flagged it as the under-specified piece), then the prover is
dispatched SCOPED to the comm-square + downstream glue only (mathlib-build).

## Route 3 — P3b bridge (fresh lane): `AlgebraicJacobian/Cohomology/CechBridge.lean`

Candidate fresh lane: `ses_cech_h1` (Stacks `lemma-ses-cech-h1`: for a SES of `O_X`-modules and a
cofinal system of covers with `Ȟ¹(𝒰,F)=0`, `G(U)→H(U)` is surjective). It is on the leandag
frontier, `\uses{def:cech_complex}` only (takes the Ȟ¹ vanishing as a HYPOTHESIS, so genuinely
independent of `injective_cech_acyclic` and of Route 2's `cechFreeComplex_quasiIso`). Blueprint
block is complete (full statement + source quote + detailed proof). No trajectory data — fresh.

## This iter's PROGRESS `## Current Objectives` proposal (2 lanes, file count 2)

1. `FreePresheafComplex.lean` — `cechFreeEvalEngineIso` (comm-square) + nonempty glue →
   `cechFreeComplex_quasiIso`. [mathlib-build]
2. `CechBridge.lean` — scaffold + build `ses_cech_h1`. [mathlib-build]

## What I need from you

- Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR).
- For Route 2 specifically: is the residual genuinely collapsing (one comm-square left, inputs
  in-file) — i.e. CONVERGING — or is the 4-iters-absent named target CHURNING that demands a
  structural corrective NOW rather than one more scoped attempt? If CHURNING, name the corrective
  TYPE.
- A dispatch-sanity check on the 2-lane proposal.
