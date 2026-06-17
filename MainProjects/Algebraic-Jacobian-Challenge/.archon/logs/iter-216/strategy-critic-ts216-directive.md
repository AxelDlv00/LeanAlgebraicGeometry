# Strategy-critic directive — iter-216 (re-verification of still-live challenges)

Fresh-context strategic review. Read ONLY these:
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim — just updated this iter).
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` (reference index).
- The blueprint chapter TITLES + one-line topics: list `blueprint/src/chapters/*.tex` and read only the first `\chapter{}`/`\section{}` line of each (do not deep-read).

Do NOT read PROGRESS.md, task files, iter sidecars, or any prover/review narrative.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: construct `J := Pic⁰_{C/k}` (the Jacobian/Albanese) for a smooth proper geometrically irreducible curve `C/k` over a bare field, and prove the nine protected `AlgebraicGeometry.Jacobian` declarations. Critical path is bottom-up (USER directive): A.1.c.SubT (⊗-group law substrate) → A.1.c (RelPic functor) → A.2.c (Picard representability). Riemann–Roch is PAUSED by USER standing directive.

## Two still-live challenges to re-verify

1. **Restructured A.1.c.SubT route (NEW this iter — validate or refute).** STRATEGY.md now claims the ⊗-group law needs only EXISTENCE of assoc/unit/braiding isos (à la `CommRing.Pic`/`monoidOfSkeletalMonoidal`), so the prior whiskering/sheafification-monoidality/stalk(d.1,d.2) apparatus is VESTIGIAL and being deleted, leaving `tensorObj_restrict_iso` as the single linchpin. Is this restructuring strategically sound, or is there a hidden coherence obligation that re-introduces the deleted machinery? Is the substrate now appropriately minimal, or still over-engineered vs. the goal?

2. **The PRIMARY GOAL (A.2.c representability) discharge fork (still live from iter-215).** STRATEGY.md records that A.2.c has no live discharge lane under the USER RR PAUSE: either build the ~3400–5500 LOC RR-free Quot/Cartier engine, OR lift the RR pause for the ~600–1000 LOC `Sym^n`/Abel–Jacobi route (~5× cheaper). Re-confirm whether this is genuinely the project's dominant cost/risk and whether the strategy should keep grinding the substrate while this fork is unresolved. Is escalating the RR decision to the USER the correct strategic posture?

Render SOUND / CHALLENGE / REJECT per challenge with concrete reasoning. Write to `task_results/`.
