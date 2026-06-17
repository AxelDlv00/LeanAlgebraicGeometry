# Iter-010 plan — caught + repaired a circular blueprint; strategy corrected; no prover (transition iter)

## Context entering the iter

P4 (the abstract acyclic-resolution engine, `AcyclicResolution.lean`) closed iter-009, axiom-clean
(lean-vs-blueprint-checker 0 must-fix; auditor confirmed the two new decls sound). With P4 done the
project pivots entirely to the Čech-geometry side (P3 long pole + P5). The frontier injected this iter
was 3 Čech nodes, all under the consolidated chapter `Cohomology_CechHigherDirectImage.tex`, which the
iter-009 blueprint-writer had de-spectral-sequenced but which had NOT been re-reviewed. So iter-010's
job: gate the rewritten chapter, validate the strategy at this inflection, and set up the P3/P5 build.

## Subagents dispatched

1. **blueprint-reviewer** (`iter010`, whole blueprint) → **`Cohomology_CechHigherDirectImage.tex` FAILS
   the HARD GATE**, 5 must-fix: (1) `lem:cech_to_cohomology_on_basis` proof is **circular**
   (term-acyclicity needs `affine_serre_vanishing`, which depends on this lemma — adding the missing
   `\uses` edge makes a DAG cycle); (2) statement↔proof mismatch (general 01EO statement, affine-only
   proof); (3) missing `def:standard_affine_cover` for the P3 signature narrowing; (4)
   `lem:higher_direct_image_presheaf` missing `[HasInjectiveResolutions]` + from-scratch caveat; (5)
   citation placement. Other two chapters clean.
2. **strategy-critic** (`iter010`) → **CHALLENGE**, independently confirming the SAME circularity by
   tracing Stacks: affine vanishing (02KG) is NOT proved from the homotopy but by feeding standard-cover
   Čech vanishing into the basis lemma (01EO), whose proof irreducibly needs `lemma-injective-trivial-cech`.
   Key positive: the goal remains achievable; the FULL 01EO/torsor bootstrap is avoidable, but the
   minimal Čech↔derived bridge is not. Format DRIFTED (5 iter-NNN prose refs).
3. **mathlib-analogist** (`p3-localisation`, api-alignment) → cover-type ALIGNS to
   `affineOpenCoverOfSpanRangeEqTop` (spanning bundle `(s,hs)`); local-to-global ALIGNS to
   `exact_of_isLocalized_span` (localise at spanning elements, not primes); the assembled complex
   exactness + localised homotopy are the genuine from-scratch gap (L1 + L3), bracketed by the two
   native idioms. Persistent: `.archon/analogies/p3-localisation.md`.
4. **blueprint-writer** (`cech-bridge`) → repaired the chapter exactly to spec: added
   `lem:injective_cech_acyclic` + `lem:ses_cech_h1`, rewrote `lem:cech_to_cohomology_on_basis` to the
   torsor-free dimension-shift (01EO), added `def:standard_affine_cover` (`\mathlibok`), fixed the
   presheaf lemma + citations. No strategy-modifying findings. DAG acyclic.
5. **blueprint-clean** (`cech-bridge`) → validated all 7 source quotes verbatim against
   `references/stacks-cohomology.tex`; stripped Mathlib-state/prover-facing prose to timeless math;
   preserved every `\lean`/`\uses`/`\mathlibok`/bridge block.

## Decision made

### D1 — Build the minimal torsor-free Čech↔derived bridge (the critics' fix); do NOT shortcut it.
- **What**: accept both critics' finding that affine Serre vanishing cannot come from the P3 contracting
  homotopy alone, and fold the minimal bridge (`injective_cech_acyclic` + `ses_cech_h1` + the
  dimension-shift `cech_vanish_basis`) into the strategy as a new phase **P3b**. Repaired the blueprint
  this iter; broke the DAG cycle (`\uses` no longer routes `affine_serre_vanishing` back into the basis
  lemma).
- **Why**: the math is unambiguous — term `G`-acyclicity ≠ complex exactness; the homotopy gives a
  resolution, not acyclic terms; grounding acyclicity in the injective-resolution-defined `rightDerived`
  must cross "injectives are Čech-acyclic." Two independent fresh-context critics agree, with exact
  Stacks tag traces (01EN/01EO, `lemma-ses-cech-h1`, `lemma-cech-vanish-basis`). I read the Stacks proofs
  directly (`stacks-cohomology.tex` L1287–1773) and confirmed the dimension-shift route needs ONLY
  `injective_cech_acyclic` + `ses_cech_h1` — the torsor sub-theory (`lemma-cech-h1`,
  `lemma-kill-cohomology-class`) is genuinely avoidable. So the bridge is real but bounded.
- **Scope honesty**: this enlarges the project (P3b is new from-scratch presheaf-Čech homological
  algebra for `O_X`-modules, ~4–7 iters). That is the honest cost the iter-009 plan hid. Estimates
  updated in STRATEGY.md.
- **Reversal signal**: if P3b's presheaf-Čech δ-functor machinery proves intractable, the fallback is
  Route B's identical brick (no escape) — i.e. there is no cheaper route; the bridge must be built.
  (Confirmed: Route B rests on the same `injective_cech_acyclic`.)

### D2 — No prover dispatch this iter (mechanical gate).
- The chapter was substantially restructured THIS iter; HARD GATE requires a fresh review before any
  prover. The repair is DAG-clean but the new bridge blocks need effort-breaking, and the P3 lane needs
  a signature refactor first. A prover now would work a freshly-restructured, under-decomposed blueprint.
  Deferring one iter is the sanctioned action. iter-011 plan written into PROGRESS.md (gate → effort-break
  → file-split scaffold → parallel provers).

### D3 — P3 design locked to Mathlib idioms (analogist).
- Cover-type = `affineOpenCoverOfSpanRangeEqTop` bundle `(s, hs)`; exactness via `exact_of_isLocalized_span`
  at spanning elements. One datum drives both geometry and algebra (zero bridge lemmas). Narrow only the
  non-protected `CechAcyclic.affine`; the protected goal + `CechComplex` stay general. Captured in the
  blueprint (`def:standard_affine_cover`) + `analogies/p3-localisation.md`.

## Rebuttals to critics
None — both mandatory critics' must-fixes were ACCEPTED and acted on (circularity repaired; format DRIFT
stripped; strategy estimates corrected; P3b added). The strategy-critic's "addressed" prior-iter tags
(P5a effort-honesty, Route-A SS-freeness) stand, but its NEW finding (the circularity) superseded the
earlier "P5a basis lemma scoped" resolution — the iter-009 reduced-scope route was itself the circular
one. Recorded so the next planner doesn't reinstate it.

## Subagent skips

- progress-critic: the only active route (P4) completed in the prior iter — sorry count went to zero and
  the route closed out; there is no trajectory to extrapolate, and the new route (P3/P3b/P5) has no prover
  data yet. (Matches the descriptor's "only active route just completed in the prior iter" skip condition.)

## Tool substitutions
None.

## Files touched this iter (plan agent + write-subagents)
- `STRATEGY.md` (restructured: +P3b phase, corrected bridge subsection, format DRIFT stripped, Mathlib
  gaps updated). 106 lines / 10.5 KB (within budget).
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (writer + clean: bridge repair).
- `.archon/analogies/p3-localisation.md` (analogist, new).
- PROGRESS.md, task_pending.md, task_done.md, this sidecar.
