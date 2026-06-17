# Iter-028 plan — 01EO L1/L2 + H⁰≅Γ naturality landed; reconcile the chapter to the cover-local form and drive L3→L4→top

## Entering state (verified)
The iter-027 two-lane dispatch **landed in full: +17 axiom-clean decls, 0 new sorries, build green.**
- **Lane 1 (`AbsoluteCohomology.lean`, +5)**: `absoluteCohomologyZeroAddEquiv_naturality` (H⁰≅Γ natural in
  the coefficient sheaf) + 4 private naturality helpers. The L3 surjectivity-transfer hinge.
- **Lane 2 (`CechToCohomology.lean` NEW, +12)**: 01EO **L1 `cechComplex_shortExact_of_basis` + L2
  `quotient_cech_vanishing_of_basis`** in the **cover-local, presheaf-level, hypothesis-driven** form
  (more general than the effort-breaker sketch), plus section-Čech functoriality, the AB4* keystone
  `shortExact_piMap`, and the homology-LES core `cechHomology_quotient_vanishing`.

Audits: lean-auditor `iter027` 0 must-fix (3 minor, both focus targets genuine). lvb `cechtocohom` raised
**2 must-fix (blueprint prose) + 2 major (missing helper blocks)** — all blueprint-side, the Lean is correct
and more general. Project sorry = 2 (both frozen/superseded). Coverage debt = 14 unmatched helpers.

## What I did this iter (plan phase)
1. Processed both lane results (task_done += the 17 decls; task_pending: AbsoluteCohomology DONE,
   CechToCohomology L1/L2 DONE, L3/L4/top + per-face-SES promoted to the open lane).
2. **refactor `root-import`**: added `import …CechToCohomology` to the build root (`lake build` exit 0) —
   the file was orphaned after landing standalone.
3. **blueprint-writer `01eo-reconcile`** (the iter's heavy lift, one consolidated chapter): cleared the lvb
   must-fix + major + the 14-helper coverage debt AND scaffolded the next targets in one pass —
   (a) rewrote L1/L2 statement prose to the landed cover-local presheaf form; (b) added blocks for
   `shortExact_piMap`, `cechHomology_quotient_vanishing`, `cechCohomology`, `sectionCechComplexShortComplex`,
   the functoriality helpers, and bundled the 4 AbsoluteCohomology naturality helpers; (c) scaffolded
   `lem:face_ses_of_sheaf_ses` (per-face SES bridge), `def:basis_cov_system`, `def:has_vanishing_higher_cech`,
   and reconciled L3/L4/top to the effort-breaker signatures. `unmatched` 14→0, no broken `\uses`, acyclic.
4. **blueprint-clean `01eo`**: purity pass — chapter already clean, no edits needed; all 13 source quotes intact.
5. **blueprint-reviewer `iter028`** (whole blueprint, HARD GATE + fast path): **CLEARS
   `Cohomology_CechHigherDirectImage.tex`** (`complete:true · correct:true`, 0 must-fix). All six scaffold
   targets formalize-ready; L1/L2 prose now faithful; `HasVanishingHigherCech` correctly abstract. One
   `MUST_FIX_SOON` (a `\leanok` sync-miss on `def:cohomology_sheaf_is_sheafify_homology` — sync's domain, will
   self-resolve) + one cosmetic (`def:`-prefixed label on a `lemma` env). Neither blocks the prover.
6. **progress-critic `iter028`: CONVERGING** — 3 consecutive COMPLETE first-attempt iters, no churn, on
   schedule (elapsed iter 3 of est. 3–4). Endorsed single-lane loading with the explicit hedge (below).
7. PROGRESS.md (ONE lane, scaffold keywords on the path line), task ledgers, this sidecar, objectives.md.

## Decision made

### D1 — Drive the whole remaining 01EO chain in ONE mathlib-build lane (per-face SES → L3 → L4 → top), with a hard hedge.
**Chosen** over splitting L3 and L4 into separate iters. **Why:** (i) the naturality dep that gated L3 landed
iter-027, so L3 is now genuinely ready; (ii) L3, the per-face SES, and L4 all live in the same file and share
warm context — splitting adds an artificial iter; (iii) mathlib-build's no-sorry invariant means the lane
either closes a step or hands off a precise decomposition, so over-scoping costs nothing — the prover stops at
the real seam. **Hedge (progress-critic-endorsed):** if L4's `BasisCovSystem` induction proves heavy, the lane
closes at axiom-clean L3 + the `BasisCovSystem`/`HasVanishingHigherCech`/per-face-SES definitions and hands off
L4/top to iter-029 — NOT a sorry-pin. **Reversal signal:** if the prover reports the per-face SES needs
absent section-left-exactness Mathlib infra (PreservesFiniteLimits of eval-at-`op V`), that becomes its own
mathlib-build sub-lane next iter.

## Why no other subagents
- **strategy-critic — skipped** (see `## Subagent skips`): STRATEGY.md unchanged; prior verdict SOUND, no live
  challenge. The 01EO chain is progressing exactly as the strategy's ACTIVE row anticipates; no route change.
- effort-breaker not re-dispatched: the L3/L4/top decomposition from iter-027 is still the live recipe and the
  blueprint-reviewer confirmed each piece is formalize-ready (no still-too-big node). If L4's induction comes
  back heavy, the iter-029 planner re-breaks the closure-under-quotient step (the flagged heavy piece).

## Risks / watch
- The per-face SES derivation depends on `toPresheafOfModules` being a right adjoint with eval-at-`op V`
  preserving finite limits — the prover's iter-027 handoff asserts this is available; if not, it is a clean
  mathlib-build sub-target, not a dead end.
- The cosmetic `def:`-on-`lemma` label flagged by the reviewer is left for the review agent's marker domain.

## Subagent skips
- strategy-critic: STRATEGY.md SHA-unchanged from iter-027 and prior verdict was SOUND with no live CHALLENGE
  (the Form-B challenge was resolved iter-027); the 01EO chain is intra-phase progress, not a strategy change.
