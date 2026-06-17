# Iter 035 — Plan (Quot-Foundations)

## TL;DR

Resumed a multiply-interrupted iter-035 plan phase. Prior partial runs had already dispatched both
mandatory critics (`progress-critic`, `strategy-critic`), the `effort-breaker` on `_legs`, the three
coverage writers (`fbc-cov`/`quot-cov`/`gr-cov`), and `blueprint-clean` (which completed its 20 edits but
was killed before writing its report). This resume consumed all of that, edited STRATEGY.md to address
both critic CHALLENGEs, dispatched the decisive `blueprint-reviewer` (whole-blueprint HARD GATE) — **all
3 high-stakes chapters PASS, no must-fix** — and dispatched **3 parallel import-independent prover lanes**:

1. **FBC-A** [fine-grained] — the **last authorized conjugate round** on `_legs`, now atomized by the
   effort-breaker into a `\uses`-linked chain (conj-1a/1b → conj-2b/2c/2d → conj-2a → thin wrapper).
2. **QUOT-D** [mathlib-build] — build the gap1 keystone `isLocalizedModule_basicOpen_descent`
   (finite sheaf equalizer + flatness; Stacks `lemma-invert-f-sections` / Hartshorne II.5.3).
3. **GR-proper** [mathlib-build] — scaffold + build `Grassmannian.isProper` via the valuative criterion
   (Nitsure §1 "Properness").

The progress-critic's must-fix (pre-schedule the FBC iter-036 refactor) is satisfied: PROGRESS.md
`## Iter-036 ramp` carries the explicit-inverse + element-`ext` refactor as a *scheduled* task, not a note.

## Decision made

### FBC-A: one more conjugate round (atomized) + pre-scheduled refactor — NOT a pivot-now

- **Option chosen:** dispatch the effort-breaker's atomized conjugate chain this iter (fine-grained), and
  pre-schedule the strategy-critic's explicit-inverse refactor as the iter-036 task that fires iff this
  round closes neither `_legs` nor `gstar_transpose`.
- **Why (over pivoting to explicit-inverse now):** the progress-critic STUCK verdict explicitly sanctions
  this as the correct iter-035 structure — "the effort-breaker pairing is adequate for iter-035
  specifically … doing a full comparison-object refactor before testing conj-1/conj-2 with this structure
  would waste the conjugate machinery already built." conj-0 landed axiom-clean iter-034; every Mathlib
  anchor the chain needs is verified present (strategy-critic Prerequisite verification: all PASS); and
  this is the *first* full closure attempt on the decomposed chain (iter-034 was foundation-only). The
  decomposition is exactly what was missing — atomic granularity, not more helpers.
- **LOC/risk:** ~60–150 LOC; the heaviest node is conj-2a (`conjugateEquiv.injective` lift + reassoc simp
  set, effort ≈1351) with all three legs pre-proven. Risk: the cross-layer `gammaPushforwardIso` transport
  (conj-2d) — but it is now a named single-claim lemma with `unit_conjugateEquiv_symm` + `conjugateEquiv_comp`.
- **Cheapest reversal signal:** if this round closes nothing, the conjugate encoding is exhausted (it would
  be the route's 6th iter at sorry=4) → iter-036 refactor fires automatically.

### Rebuttals / dispositions of the two CHALLENGE verdicts

- **strategy-critic FBC CHALLENGE** ("re-encoding treadmill + missing trip-wire + optimistic estimate"):
  ADDRESSED, not rebutted. STRATEGY.md now (a) states the concrete fallback trigger (explicit-inverse +
  element-`ext`, the critic's own Alternative), (b) re-estimates honestly (route-level OVER_BUDGET marked;
  conjugate sub-phase 1 elapsed of 1–2), (c) moves the inline dead-route narrative out of STRATEGY into
  this sidecar. The critic also asked to show the coherence *closes* not *relocates*: the honest answer is
  that the conjugate expression is discharge-able by **proven Mathlib mate lemmas** (all verified) whereas
  the section expression bottomed at a term-mode-less coherence — so the round will demonstrate closure or
  trigger the refactor. No silent override.
- **strategy-critic GR CHALLENGE** (bookkeeping): ADDRESSED. GR-glue + GR-sep moved to `## Completed`;
  active table now carries a single `GR-proper — isProper via valuative criterion` row with the
  existence-part chart-selection named as the real work.
- **strategy-critic QUOT minor** (D Stacks tag): already resolved — `references/summary.md` line 13 pins
  `lemma-invert-f-sections` (L2153 of stacks-properties.tex); the D block cites it with the verbatim
  quote. The leftover "01HA" is on a *downstream gated* block (G1-core), cosmetic, flagged for review.
- **progress-critic FBC-A STUCK must-fix** (pre-write the iter-036 refactor): DONE in PROGRESS.md
  `## Iter-036 ramp` as a scheduled deliverable.

## Soundness check (disprove pass)

Not warranted this iter: the two new build targets are cited theorems with verbatim source quotes —
QUOT-D is Stacks `lemma-invert-f-sections` (qcqs `Γ(X,ℱ)_f ≅ Γ(X_f,ℱ)`, restricted here to the affine
`Spec R` / `D(f)` case, hypotheses hold) and GR-proper is the valuative criterion over `Spec ℤ`
(Noetherian, separated DONE). FBC-A is an `IsIso` whose iso-ness is *already free* (`conjugateIsoEquiv` of
`gammaPushforwardNatIso`); only the coherence identifying it with the canonical map is open — there is no
statement to disprove, only a coherence to discharge.

## Prior critique status

- strategy-critic `iter035`: FBC CHALLENGE → addressed (fallback + estimate + narrative move); GR
  CHALLENGE → addressed (table restructure); QUOT minor → already pinned; Format DRIFTED → trimmed
  14.8KB→13.3KB (sunk-cost inline narrative removed, GR rows moved to Completed). No live CHALLENGE.
- progress-critic `iter035`: FBC-A STUCK → corrective taken (atomized chain this iter + scheduled refactor
  iter-036); QUOT/GR-proper UNCLEAR → dispatch correct.

## Subagent skips

- strategy-auditor: not dispatched — the strategy-critic (fresh-context, mandatory) already audited every
  route this iter and verified all prerequisites against the pinned tree (zero phantoms); a second deep
  gatekeeper would be redundant when no new route is being opened (all 3 lanes are continuations of
  reference-anchored phases).
- mathlib-analogist: not dispatched — the FBC conjugate API was already consulted (iter-034
  `analogies/fbc-mate-reencode.md`) and every anchor re-verified by the strategy-critic this iter; no
  new design-shape question this iter.
- dag-walker: not dispatched — leandag reports the 3 target frontier nodes ready with satisfiable `\uses`,
  and the blueprint-reviewer confirmed the cones complete + correct; no untrusted-readiness cone to walk.
- lean-scaffolder: not dispatched — the GR-proper / QUOT-D recipes are full blueprint proof sketches
  (long content lives in the chapter, the proper home), not medium implementation hints; mathlib-build
  provers read the chapter directly.
- reference-retriever: not dispatched — both sourced targets (QUOT-D, GR-proper) already have their
  source files in `references/` (stacks-properties.tex, the Nitsure source) with verbatim quotes in-block.

## Build / gate state at dispatch

- All modules GREEN. FBC 4 sorries, QUOT 4 protected stubs, GR/FBCGlobal/GHS 0, GF 6 (gated).
- blueprint-reviewer `iter035`: all 3 high-stakes chapters complete + correct, no must-fix → HARD GATE
  clear for all 3 lanes. blueprint-clean `iter035`: 20 purity edits applied (report lost to interruption,
  edits on disk).
