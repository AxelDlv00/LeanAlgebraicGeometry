# Strategy-critic — iter 011

Fresh-eyes audit of the project strategy. Judge the strategy as a mathematician
seeing it cold — challenge sunk cost.

## What to read (and ONLY this)
- `STRATEGY.md` (verbatim — the current strategy).
- `references/summary.md` (the reference index).
- The blueprint chapter list below (titles + one-line topics) for coverage.
You MUST NOT read: iter sidecars (`.archon/iter/**`), `PROGRESS.md`,
`task_pending.md`/`task_done.md`, prover task results, or any recent
review/plan narrative. Your value is the uninvested view.

## Project goal (one paragraph)
Close the seven `sorry`-bearing nodes of the Čech-cohomology-independent leg of the
parent project's `thm:fga_pic_representability` cone (Kleiman, "The Picard scheme",
FGA §4): flat base change in degree i=0 (FBC), generic flatness with its algebraic
core (GF), and the Quot/Grassmannian foundations (QUOT — Hilbert polynomial, Quot
functor, Grassmannian scheme + its representability). End-state: zero project `sorry`
and zero project axioms in the dependency closure, names/labels matching the parent
so finished work merges back.

## Blueprint chapters (title — one-line topic)
- `Cohomology_FlatBaseChange.tex` — i=0 flat base change, direct-on-sections (Stacks 02KH).
- `Cohomology_RegroupHelper.tex` — the regrouping linear equiv via `Algebra.IsPushout.cancelBaseChange`.
- `Picard_FlatteningStratification.tex` — generic flatness algebraic core (Nitsure §4 dévissage).
- `Picard_GrassmannianCells.tex` — Grassmannian affine charts + Cramer-inverse transition maps + cocycle (Nitsure §1).
- `Picard_QuotScheme.tex` — Hilbert polynomial via graded Hilbert–Serre, Quot functor, Grassmannian scheme, representability.
- `Picard_RelativeSpec.tex` — relative spectrum functor (foundational for QUOT-repr).

## Specific questions
1. STRATEGY.md was rewritten at iter-009 to resolve a prior FBC internal contradiction
   (the prose said "drop the adjoint-mate tower / prove the single section identity
   `Γ(θ) = lTensor R' η_M`" while the phases/gaps still retained the mate tower). Confirm
   the current FBC route description is now internally consistent and matches the chapter,
   or flag any remaining contradiction.
2. Is the FBC i=0 globalization plan (H⁰ as the degree-0/1 Čech equalizer + flat `−⊗B`
   preserving the finite equalizer — NOT cohomology) genuinely Čech-cohomology-free, and
   are the named Mathlib pieces the right ones?
3. GF route: is generalizing the base domain `A` in the `Nat.strong_induction_on d`
   (so the IH applies at `A_g` after the reindex) the correct induction motive, with no
   hidden circularity? Is the effort-break decomposition of the polynomial core sound?
4. QUOT Hilbert-polynomial encoding: is it sound to route polynomiality through the
   project graded Hilbert–Serre rationality lemma (Mathlib-absent) + the Mathlib
   extraction `existsUnique_hilbertPoly`, staying inside the Čech-independent leg, rather
   than via Euler characteristic / cohomology? Any hidden cohomology dependency?
5. Any phase whose iters-left / LOC estimate looks materially wrong, any missing
   prerequisite, any route that should be pivoted or merged.

Return SOUND / CHALLENGE / REJECT per route with reasons. Write your report to
`task_results/strategy-critic-iter011.md`.
