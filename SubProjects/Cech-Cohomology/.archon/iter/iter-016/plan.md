# Iter-016 plan — fill the L1 blueprint gap, split P3b for parallelism, dispatch 3 gate-cleared lanes

## Entering state (verified)
iter-015 was the first genuine prover trajectory (011–014 were externally killed / interrupted).
Outputs, both PARTIAL, both axiom-clean, reviews 0 must-fix:
- **P3 `CechAcyclic.lean`**: +9 axiom-clean private `CombinatorialCech.*` decls = the **L3**
  combinatorial contracting homotopy (`combHomotopy_spec` = `d∘h+h∘d=id`, `combDifferential_comp` =
  `d²=0`, `combDifferential_exact` = `Function.Exact`). Target `CechAcyclic.affine` still 1 sorry
  (line 93), blocked on **L1** (identify abstract `CechComplex` with concrete `∏_σ M_{s_σ}`).
- **P3b `PresheafCech.lean`**: +2 axiom-clean decls (`injective_toPresheafOfModules`,
  `freeYonedaHomEquiv`); 3 of 5 bricks handed off with precise recipes.

`lake build` green (8324 jobs after the file split). The frozen `cech_computes_higherDirectImage`
sorry (P5b) untouched.

## What I did this iter
1. **Cleared coverage debt** (11 unmatched `lean_aux` helpers). Bundled into 3 `\lean{...}` lists
   per the established bundling pattern: `lem:cech_acyclic_affine` (+9 `CombinatorialCech.*`),
   `lem:cech_complex_hom_identification` (+`freeYonedaHomEquiv`), `lem:injective_cech_acyclic`
   (+`injective_toPresheafOfModules`). (Private decls DO surface in `unmatched` despite the iter-015
   prover's claim that they wouldn't — the injected graph state listed all 11.)
2. **blueprint-writer `l1bridge`** — filled the L1 gap (the lvb-checker's flagged major proof-sketch
   hole) in the proof of `lem:cech_acyclic_affine`: term id `Γ(D(s_σ),F)=M_{s_σ}`, differential
   compatibility, iso of cochain complexes reducing positive-degree vanishing to L2+L3. Verbatim
   source = Stacks Schemes Tag 01HV(4)–(5); a reference-retriever child fetched
   `references/stacks-schemes.tex`.
3. **refactor `split-freecomplex`** — created `FreePresheafComplex.lean` (imports + namespace +
   strategy comment, no decls), wired the root import. Build green. Updated `% archon:covers`.
4. **blueprint-reviewer `iter016`** (whole blueprint, the gate) — HARD GATE clears all 3 target
   files; one must-fix (missing covers line) fixed by me. L1 bridge judged "sound and adequate for
   formalization."
5. **progress-critic `iter016`** — both routes UNCLEAR (one genuine data point), no CHURNING/STUCK.

## Decision made
**Dispatch 3 parallel lanes this iter (P3 close + P3b split into section/free sides), all critical-path.**

- *Why split P3b into two files* (`PresheafCech` = section side; new `FreePresheafComplex` = free
  side): the two complexes `sectionCechComplex` and `cechFreePresheafComplex` are mutually independent
  (one cosimplicial→`alternatingCofaceMapComplex`, one simplicial→`AlternatingFaceMapComplex`); the
  iter-015 prover explicitly couldn't fit `sectionCechComplex` alongside other work in one lane. Two
  focused lanes double completion odds on the bottleneck and honor the standing parallelism directive.
  Low-risk: an empty imported skeleton keeps the build green.
- *Why dispatch P3 THIS iter rather than defer to 017* (progress-critic's stated minimum): L1 is now
  blueprinted and the reviewer judged it adequate; L3 is done. Dispatching now avoids the
  "another deferral = avoidance" risk the critic flagged, and the same-iter fast path (writer →
  scoped gate clear → prover) is explicitly sanctioned. P3 uses `prove` mode (L3 infra exists; the
  work is transporting the abstract↔concrete identification + the dependent-coefficient L3 port).
- *Why DEFER P5a one more iter* (despite the parallelism directive): the only P3/P3b-independent P5a
  leaf, `higher_direct_image_presheaf` (01XJ), needs a new file plus "sheafification preserves
  kernels/cokernels for SheafOfModules" infra whose Mathlib support is unconfirmed (strategy notes
  flag `Scheme.Modules` sheaf cohomology as ABSENT). Opening it blind risks a wasted lane. Cheapest
  reversal signal: a mathlib-analogist confirms the (co)limit-preservation route — queued for iter-017.
  The three critical-path lanes already saturate useful parallelism this iter.

## Subagent skips
- strategy-critic: STRATEGY.md route unchanged since iter-011 (verdict SOUND for all routes — Route A,
  B, the bridge) and unchanged in content this iter (no route/phase/estimation edit; the P3b file-split
  is a PROGRESS-level decomposition refinement under the already-recorded standing parallelism
  directive, not a strategy change). No live CHALLENGE outstanding.

## Mode selection
- `CechAcyclic.lean` → `prove` (L3 infra built; close the existing sorry by transporting the now-
  blueprinted L1 identification — not new-infrastructure-from-scratch).
- `PresheafCech.lean`, `FreePresheafComplex.lean` → `mathlib-build` (build new complexes bottom-up,
  axiom-clean, no sorry pins).
