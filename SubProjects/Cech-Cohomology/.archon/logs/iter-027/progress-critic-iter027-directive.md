# Progress-critic directive — iter-027

Assess convergence of the single active route below. Fresh-context read; do NOT
assume the planner's framing is correct.

## Active route: P3b absolute cohomology → 01EO comparison

Files in flight: `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` (Ext-based
absolute cohomology, Form B), and a NEW file `CechToCohomology.lean` (the Stacks-01EO
Čech↔cohomology comparison chain) proposed for this iter.

Strategy estimate for this phase: **Iters left ~3–5**; the phase (P3b absolute cohomology
+ 01EO/02KG) has been ACTIVE since iter-024.

### Signals — last 4 iters (sorry count is project-wide; both sorries are frozen/superseded, not this route's)

| Iter | sorry | axiom-clean decls added | prover status | named targets landed | recurring blocker phrases |
|---|---|---|---|---|---|
| 024 | 2→2 | +21 (CechBridge + FreePresheafComplex) | COMPLETE ×2 | `cechFreeComplex_quasiIso`, `ses_cech_h1` | none |
| 025 | 2→2 | +1 (CechBridge) | COMPLETE (first try) | `injective_cech_acyclic` | none |
| 026 | 2→2 | +10 (AbsoluteCohomology, new file) | COMPLETE (all 6 objectives) | Form-B scaffold (`jShriekOU`, `absoluteCohomology`, H⁰≅Γ, injective-vanishing, covariant-LES) | none (1 must-fix: file orphaned from build root — fixed by a 1-line refactor this iter) |
| 027 (plan) | 2→2 | (planning) | — | — | — |

No helper-churn (each iter added distinct, named, axiom-clean content — not bridge-lemmas
multiplying around one residual). No sorry-stall (the 2 project sorries are both intentional:
a superseded relative-form lemma and the frozen protected P5b target — neither is this route's
work). No repeated PARTIAL/INCOMPLETE. Every iter closed its dispatched objective in full.

### This iter's proposed objectives (for dispatch-sanity)

- `AbsoluteCohomology.lean` — add ONE decl: `absoluteCohomologyZeroAddEquiv_naturality`
  (naturality of the landed H⁰≅Γ iso in the sheaf argument; flagged by strategy-critic as a
  silent prerequisite of 01EO's surjectivity step). Blueprint block exists, FORMALIZE-READY.
- `CechToCohomology.lean` (NEW) — scaffold + build the 01EO chain: `cechComplex_shortExact_of_basis`
  (L1), `quotient_cech_vanishing_of_basis` (L2), `absoluteCohomology_one_eq_zero_of_basis` (L3),
  `absoluteCohomology_eq_zero_of_basis` (L4), `cech_eq_cohomology_of_basis` (top). L1/L2 need no
  naturality; L3 consumes the new naturality decl. mathlib-build mode (no sorry; build as far as
  possible, hand off a decomposition at the genuine block).

## What I want from you

A per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the one-line evidence, plus
a dispatch-sanity check on the two proposed objectives: is the two-lane split sound given that
L3 in the new file depends on the naturality decl being added to the OTHER file in the SAME iter
(provers run in parallel from one commit, so the new naturality decl is not visible cross-lane
this iter)? Flag if that cross-lane dependency makes the L3+ portion of lane B un-closeable this
iter and whether that is acceptable (mathlib-build hands off rather than sorry-pinning).
