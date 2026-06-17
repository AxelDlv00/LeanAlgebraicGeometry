# Iter-027 plan — Form-B absolute-cohomology scaffold landed; open the 01EO comparison chain (general basis criterion)

## Entering state (verified)
The iter-026 dispatch (`AbsoluteCohomology.lean`, mathlib-build) **landed in full**: 10 axiom-clean decls,
0 sorries, the complete Form-B scaffold (`jShriekOU` corepresenting object, `jShriekOU_homEquiv` corepr iso,
`absoluteCohomology = Ext^p(jShriekOU U, -)`, `absoluteCohomologyZeroAddEquiv` H⁰≅Γ,
`absoluteCohomology_eq_zero_of_injective`, the 3 `absoluteCohomology_covariant_exact₁/₂/₃` LES wrappers).
The strategic bet of Form B is validated in the Lean: injective vanishing is the one-liner
`Ext.eq_zero_of_injective e` because the injective sits in the 2nd Ext arg → Form A's
restriction-preserves-injectives obligation is gone, not deferred. Project sorry = 2 (both frozen/superseded).

## What I did this iter (plan phase)
1. Processed the iter-026 prover result (task_done += the 10-decl scaffold; task_pending: AbsoluteCohomology
   SCAFFOLD DONE, 01EO lane opened). lvb `abscohom`: 0 must-fix, 3 pinned decls faithful, 5 `\mathlibok`
   anchors valid; its MAJOR (5 substantive wrappers missing `\lean{}`) was fixed by the blueprint-writer
   (now `lem:absolute_cohomology_zero`/`_injective_vanishing`/`_covariant_les` pinned; `unmatched`=0).
2. **refactor `wire-root`**: added `import AlgebraicJacobian.Cohomology.AbsoluteCohomology` to the build root
   (the iter-026 review's one must-fix — file was orphaned). `lake build` exit 0, 8327 jobs.
3. **effort-breaker `split-01eo`**: decomposed `cech_eq_cohomology_of_basis` (01EO, effort 4641→2788) into a
   4-link `\uses` chain (L1→L2→L3→L4→top) with concrete Lean signatures and the cover-local/`BasisCovSystem`
   encoding. Headline: L1–L3 can be stated cover-locally (no `Cov`); the cofinal-system datum is forced only
   into L4 + the top lemma; the inductive class is NOT QCoh (`Q=I/F` need not be quasi-coherent).
4. **strategy-critic `iter027`**: SOUND + COMPLIANT. Resolved the previously-live Form-B challenge against the
   challenger (Form B landed axiom-clean AND the verbatim 01EO proof consumes exactly the 5 Form-B/done-brick
   facts, never `affine_serre_vanishing`). Two non-blocking refinements acted on below.
5. **blueprint-writer + blueprint-clean `iter027`**: added the 4-link 01EO chain + the naturality block
   `lem:absolute_cohomology_zero_natural`, pinned the 5 wrapper `\lean{}` blocks. Purity pass clean.
6. **blueprint-reviewer `iter027`** (HARD GATE): CLEARS `Cohomology_CechHigherDirectImage.tex`
   (`complete: true · correct: true`, 0 must-fix). 01EO chain + naturality FORMALIZE-READY, `\uses` acyclic,
   inductive predicate abstract. leandag `unknown_uses: []`, `unmatched`=0.
7. **progress-critic `iter027`**: CONVERGING (3 consecutive COMPLETE iters, +32 axiom-clean named decls, zero
   churn). Confirmed the two-lane split is sound and flagged the cross-lane naturality dependency (L3+ of Lane 2
   waits for iter-028; mathlib-build hands off cleanly rather than sorry-pinning).
8. STRATEGY.md: P3b row updated (scaffold landed; 01EO general criterion next); open-question #2 RESOLVED
   (general basis criterion). PROGRESS.md (2 lanes, noop-trap keywords on both path lines), task ledgers,
   TO_USER.md, this sidecar.

## Decisions made

### D1 — 01EO = the GENERAL basis criterion, not an affine specialization (strategy-critic A).
**Chosen:** formalize `cech_eq_cohomology_of_basis` parametrically in `F` and in the per-cover vanishing
hypothesis (the lightweight `BasisCovSystem` + `HasVanishingHigherCech` encoding), instantiating to affines
only at 02KG. **Why:** the verbatim Stacks 01EO proof uses no affine-specific input — affineness enters only
when picking `Cov`=standard covers / `B`=distinguished-open basis. An affine-specialized statement would
still set up `Cov`/`B` and discharge conditions (1)–(3), so it is barely cheaper, while the general form is
reusable for the P5a `Hᵏ(f⁻¹V,G)` comparisons. **Constraint:** the inductive predicate must stay ABSTRACT
(`Q=I/F` is not quasi-coherent) — specializing it to QCoh would be unsound. **Reversal signal:** if the
`BasisCovSystem.cofinal` field proves heavy to discharge at 02KG, fall back to stating L4 directly over
affine standard covers (the L1–L3 bodies are unchanged either way).

### D2 — Budget naturality of H⁰≅Γ as an explicit 01EO sub-target (strategy-critic B).
**Chosen:** add `absoluteCohomologyZeroAddEquiv_naturality` as a first-class lane this iter, rather than let
01EO's surjectivity step (`H⁰(U,I)→H⁰(U,Q)` surjective because `I(U)→Q(U)` is) discover the obligation
mid-proof. The landed `absoluteCohomologyZeroAddEquiv` is a bare `AddEquiv` at fixed `F`; naturality in the
2nd variable is a separate, small, blueprint-ready fact. **Why:** cheap to land now, and it is the precise
hinge of L3.

### D3 — Two parallel lanes, accept the cross-lane gate (split into a NEW file `CechToCohomology.lean`).
**Chosen:** Lane 1 = AbsoluteCohomology naturality; Lane 2 = NEW `CechToCohomology.lean` (L1–L4+top). **Why:**
(a) the standing parallelism directive favours file splitting; (b) L1/L2 are independent of naturality and
land this iter; (c) L3+ legitimately waits for Lane-1's output (invisible cross-lane in a same-commit parallel
run) — mathlib-build mode hands off a clean decomposition at L3, no sorry-pin (progress-critic confirmed).
Net: two lanes both make real axiom-clean progress this iter without a racy dependency forcing a stub.

## Subagent skips
- mathlib-analogist: not needed — the 01EO chain uses only already-shipped Ext API + the landed
  AbsoluteCohomology wrappers; the effort-breaker supplied concrete signatures and the analogist already
  settled the Form-B/Ext alignment in iters 025–026 (`analogies/restriction-preserves-injectives.md`).
- lean-auditor / lean-vs-blueprint-checker (full review pass): deferred to the review phase per role split;
  lvb `abscohom` already ran on the one file with new prover code this transition.

## Risks / watch
- L4's induction (`BasisCovSystem` closure-under-quotient) is the heaviest remaining piece (effort 1718).
  If iter-028's prover stalls on it, effort-break it further (the quotient re-entry into `HasVanishingHigherCech`
  via `ses_cech_h1` + cofinality is the seam).
- `cechCohomology` accessor on `sectionCechComplex`: confirm it exists or add a thin def (effort-breaker flag —
  naming, not a math gap). The prover should surface this in its handoff.
- Standard-cover cofinality (Stacks `schemes-lemma-standard-open`) for the 02KG instantiation: verify Mathlib
  coverage before that lane (separable side-scaffold, independent of L1–L4).
