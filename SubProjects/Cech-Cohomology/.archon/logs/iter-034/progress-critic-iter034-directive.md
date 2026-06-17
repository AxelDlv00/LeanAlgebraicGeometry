# Progress-critic directive — iter-034

Assess convergence for the TWO active routes the planner is about to dispatch this iter.
Verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR) + the corrective TYPE if not CONVERGING.

## Route A — 02KG affine cover-system  (file: `AffineSerreVanishing.lean`)
STRATEGY estimate: `Iters left ~3`; route entered its current (cover-system) phase at iter-031/032.

Last-4-iter signals (this file / route):
- iter-030: not this file (Lane A was a different file — FreePresheafComplex reparam).
- iter-031: supporting infra only (CechBridge family form `injective_cech_acyclicFam`, feeds this route's `injective_acyclic` field). No edits to this file.
- iter-032: **PARTIAL +1** — `standard_cover_cofinal` (Tag 009L) axiom-clean; STOPPED on `toSheaf_preservesEpimorphisms`, discovered to be `PreservesFiniteColimits (SheafOfModules.toSheaf)` (missing Mathlib dual), a bounded ~80–150 LOC build.
- iter-033: **DID NOT RUN** — this lane was dispatched in PROGRESS but the prover phase launched only one prover (dispatch/parallelism shortfall); file byte-unchanged. 0 new decls. The toSheaf blocker was meanwhile resolved to a bounded build (analogist recipe `analogies/tosheaf-epi.md`) and the blueprint gate was cleared.
- sorry count: 0 every iter (mathlib-build, no pins). Helpers added: iter-032 +1; iter-033 +0.
- Recurring blocker phrase: "toSheaf preserves epimorphisms / PreservesFiniteColimits(toSheaf)" — now has a confirmed recipe.

## Route B — 01I8 tilde-exactness (Route P, step P3)  (file: `TildeExactness.lean`)
STRATEGY estimate: 01I8 row `Iters left ~5–8`; route promoted to its own phase at iter-032.

Last-4-iter signals (this route):
- iter-031: P0 `exists_finite_basicOpen_subcover` (QcohTilde file, same 01I8 phase) — axiom-clean.
- iter-032: P1b `isLocalizedModule_of_span_cover` **COMPLETE +7** (QcohTilde file) — axiom-clean.
- iter-033: **NEW FILE +3** axiom-clean (`tilde_preservesFiniteColimits`, `tilde_toStalk_map_injective`, `tilde_preservesFiniteLimits_of_preservesKernels`). Named target `tildePreservesFiniteLimits` left ABSENT (no pin); blocked on ONE remaining build: the Ab-valued-stalk germ-naturality transport to land mono-preservation. (lean-auditor confirmed the file already circumvents the previously-feared second obstruction via a Mathlib kernel-route lemma — only one gap remains.)
- sorry count: 0 every iter. Prover status: iter-032 COMPLETE, iter-033 PARTIAL (genuine new decls, named target absent).

## Planner's proposed objectives this iter (2 files → 2 provers)
1. `AffineSerreVanishing.lean` — RE-DISPATCH the cover-system mathlib-build (didn't run iter-033): `toSheaf_preservesFiniteColimits` → `toSheaf_preservesEpimorphisms` → `affine_surj_of_vanishing` → `affineCoverSystem`. Recipe ready, gate cleared.
2. `TildeExactness.lean` — CONTINUATION mathlib-build: build the Ab-stalk transport → `(tilde.functor R).PreservesMonomorphisms` → assemble `tildePreservesFiniteLimits` via the existing kernel-route reduction.

Dispatch-sanity: 2 distinct files, both independent, both blueprint-gate-cleared iter-033, both mathlib-build. Is re-dispatching Route A (which did not run last iter rather than failing) the right call, or is there a churn signal I'm missing? Is Route B's fresh-lane trajectory genuine progress or premature?
