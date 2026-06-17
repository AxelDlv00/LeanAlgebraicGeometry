# Strategy Critique — iter-182

## Slug
iter182

## Iteration
182

## Context

STRATEGY.md was edited iter-181 plan-phase to address all 3 must-fix
findings from your iter-181 verdict:

1. **A.4.c CHALLENGE** — was split into A.4.c.0 (codim-≥2 standalone
   Lean exposure, ~2–4 iters) + A.4.c.1 (Thm 3.2 assembly, ~8–14 iters);
   total iters preserved within ~10–18 split.
2. **Chart-bridge velocity-anchor CHALLENGE** — replaced single row with
   TWO rows (cross case + collapse-at-zero), each anchored at
   `~30–70 · NOT-YET-MEASURED` (recipe non-transferable confirmed).
3. **Format NON-COMPLIANT** — 13 `iter-NNN` refs excised across 4 sections;
   DEMOTED-replacement block compressed to single line under Open Qs;
   iter-tagged accumulation parenthetical removed. Size 167 → 158 lines
   / ~10.5 KB (within budget).

## Required output

This is a verification dispatch: confirm whether all 3 iter-181
CHALLENGE / format-noncompliant findings are fully retired by the
current `STRATEGY.md`, and surface any NEW strategic concerns that
arose from the iter-181 prover outcomes:

- **Lane C (Points/gm_grpObj)** SUCCESS kernel-clean — 11-iter STUCK
  pattern fully resolved. Route 6 (`gm_grpObj`) can be excised from
  STRATEGY.md if it ever appeared as its own row (it does not — but
  flag if it should appear in a closed-routes ledger anywhere).
- **Lane A (OCofP)** PARTIAL — `globalSections_iff` body remains
  gated on `lineBundleAtClosedPoint` / `toFunctionField` bodies (a
  documented Mathlib gap — Sheaf internal-Hom + ModuleCat forget).
  Should this gap surface in STRATEGY.md as a named blocker (it is
  currently implicit in the RR.3 row)?
- **Lane I (RatCurveIso)** SUCCESS sig refinement only; the
  lean-vs-blueprint-checker iter-181 surfaced a MUST-FIX
  must-fix-this-iter on Pin 2 — `morphism_degree_via_pole_divisor`
  signature is weakened-wrong (discharged by any positive-degree
  divisor on C, does not reference φ). This is a signature-shape
  strategy bug, not an iter-budget bug. Should Pin 2's gap surface in
  STRATEGY.md as an explicit "weakened-wrong file-skeleton" risk?

## Files to read

- `.archon/STRATEGY.md` (verbatim)
- `references/summary.md`
- `blueprint/src/chapters/*.tex` (chapter titles + one-line topic each
  — derive from file head)

## Hard exclusions

Do NOT read:
- `iter/iter-NNN/` sidecars
- `.archon/task_pending.md`, `.archon/task_done.md`
- `.archon/PROGRESS.md`
- per-iter narrative of "what we tried last time"

## Project goal (verbatim from STRATEGY.md `## Goal`)

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean`): nine protected declarations headlined by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` —
existence of an Albanese / Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible
curve `C / k`, with no `C(k) ≠ ∅` hypothesis. End-state: zero inline
`sorry`, kernel-only axioms. Char-general; no `CharZero`.
