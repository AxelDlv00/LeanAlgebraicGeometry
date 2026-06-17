# Strategy-critic directive — iter-028 (re-verification of still-live iter-024 challenges)

This is a re-verification pass. The strategy is byte-stable since iter-024; the iter-024 verdict was
CHALLENGE-not-REJECT ("the arc is sound and the route decomposition is correct on every leaf"), with four
challenges the loop has since worked into STRATEGY.md. Confirm whether each is now adequately addressed,
or still live. Read the strategy as a fresh mathematician would.

## The iter-024 challenges (verify each against the current STRATEGY.md below)
1. **Re-estimate GF-geo** — was 1-iter wrappers; now estimated 2–4 (G1/G3 are real Mathlib-absent plumbing).
2. **Name G1/G3 in `## Mathlib gaps`** — check they are named with the right content.
3. **Confirm the base-integrality hypothesis** for `genericFlatness` (`[IsIntegral S]` present, else false).
4. **Pin the Serre `m≫0` comparison for QUOT S1** — the "Hartshorne II.5.17" attribution flagged as likely
   wrong; the canonicity-of-Φ question. Check whether the Open-questions treatment is sound and whether it
   blocks anything currently active.

## Current STRATEGY.md

Read `.archon/STRATEGY.md` directly (verbatim — it is the strategy itself, the one state file in your
remit). Do NOT read PROGRESS.md, task_pending.md, iter sidecars, or review reports.

---

## Reference index (references/summary.md topics)
- Nitsure "Construction of Hilbert and Quot Schemes" (FGA): §1 Hilbert poly, §2 Quot functor, §4 generic
  flatness, §5 Grassmannian + Quot construction. PRIMARY source.
- Stacks: 02KH (flat base change of R^i f_*), 01I9/01HA (tilde / QC on affines), 01LL-01LT (relative spec),
  00K1 (graded Hilbert–Serre rationality), 01PB (finite-type module).
- Hartshorne AG: II.5 (QC sheaves), II.7 (Grassmannians/projective morphisms), III.9 (flat families).
- Milne Abelian Varieties; SGA 7.

## Blueprint chapter topics (one line each)
- Cohomology_FlatBaseChange — i=0 flat base change `g* f_* F ≅ f'_* g'^* F` via tilde dictionaries + gstar counit coherence.
- Cohomology_RegroupHelper — `regroupEquiv (A⊗_R R')⊗_A M ≅ R'⊗_R M`.
- Picard_FlatteningStratification — generic flatness (algebraic core done; geometric wrapper).
- Picard_QuotScheme — Quot functor, Hilbert polynomial (graded Hilbert–Serre), Grassmannian representability, QC affine section-localization keystone.
- Picard_GradedHilbertSerre — Stacks 00K1 rationality keystone (done).
- Picard_GrassmannianCells — big-cell charts, transitions, cocycle, glued Grassmannian scheme, separated/proper.

## Project goal (one paragraph)
Close the sorry-bearing nodes of the Čech-independent leg of the parent's `thm:fga_pic_representability`
cone (Kleiman FGA "The Picard scheme" §4): flat base change (i=0), generic flatness, and the Quot/
Grassmannian foundations — zero project sorry, zero project axioms, kernel-only axioms, names/labels
matching the parent so the work merges back.

## What I need
For each of the 4 challenges: ADDRESSED / STILL-LIVE + one line. Plus any NEW structural concern a fresh
read surfaces. Keep it tight — this is a re-verification, not a fresh audit.
