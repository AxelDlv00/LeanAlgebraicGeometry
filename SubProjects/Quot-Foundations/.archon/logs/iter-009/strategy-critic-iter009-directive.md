# Strategy Critic Directive

## Slug
iter009

## What to read (and ONLY this)
- `/home/archon/proj/Quot-Foundations/.archon/STRATEGY.md` (verbatim — the strategy under review).
- `/home/archon/proj/Quot-Foundations/references/summary.md` (the reference index).
- Blueprint chapter titles + one-line topics (below).
Do NOT read iter sidecars, PROGRESS.md, task_results, or any per-iter narrative. Judge the strategy as a
fresh mathematician would.

## Project goal (one paragraph)
Formalize the Čech-cohomology-independent leg of the parent project's `thm:fga_pic_representability`
cone (Kleiman, "The Picard scheme", FGA): (a) **flat base change** for the i=0 pushforward of a
quasi-coherent sheaf (`g^* f_* F ≅ f'_* g'^* F`), (b) **generic flatness** (Nitsure §4) with its
algebraic core, and (c) the **Quot-scheme foundations** (Hilbert polynomial via graded Hilbert function,
Quot functor, Grassmannian, representability). End-state: zero project `sorry` in the cone, kernel-only
axioms; names/labels match the parent so finished work merges back.

## Blueprint chapters (title — one-line topic)
- Cohomology_FlatBaseChange — i=0 flat base change; affine lemma direct-on-sections + globalization.
- Cohomology_RegroupHelper — the `(A⊗_R R')⊗_A M ≅ R'⊗_R M` regrouping linear equiv (FBC support).
- Picard_FlatteningStratification — generic flatness / flattening stratification (Nitsure §4 dévissage).
- Picard_GrassmannianCells — Grassmannian over ℤ via affine big cells + Plücker cocycle gluing.
- Picard_QuotScheme — Quot functor, Hilbert polynomial (graded encoding), Grassmannian, representability.
- Picard_RelativeSpec — relative Spec (support infra for the Quot/Grassmannian construction).

## Specific questions I want challenged (in addition to your standard audit)
1. **FBC route coherence.** STRATEGY.md's "FBC route" says to prove the affine lemma DIRECTLY ON GLOBAL
   SECTIONS (drop the abstract adjoint-mate decomposition, reduce via the tilde dictionaries to Mathlib's
   `cancelBaseChange`). But the live Lean/blueprint decomposition reintroduces an adjoint-MATE
   computation (`base_change_mate_regroupEquiv`, `base_change_mate_generator_trace_eq`, and 3 mate
   sub-lemmas: unit-value / pseudofunctor-reindex / transpose-on-elements). This mate path has been the
   recurring blocker for ~6 iters (opaque `Module R'` instance wall; categorically-subtle untyped
   sub-lemmas). Open strategic question #2 already asks whether the direct-on-sections route dissolves
   the coherence wall or still needs a mate computation. **Is the mate-trace decomposition the right
   route, or is there a more direct path (e.g. reduce both sides through the tilde dictionaries to
   `cancelBaseChange` WITHOUT building the adjunction-unit/reindex/transpose tower)?** This is the single
   most important question — a route swap here would save many iters.
2. **GF universe pin.** The L5 polynomial-core induction was re-signed to a shared universe
   `(A N : Type u)` to make the base-domain-generalizing strong induction universe-stable (the reindexed
   module escapes N's universe). Is shared-universe acceptable for merge-back into the `Scheme.{u}`
   parent cone, or does it constrain downstream consumers?
3. Standard audit: hallucinated routes, unnecessary case splits, missing prerequisites, silent
   assumptions, canonical-skeleton mismatch vs Nitsure §4 / Stacks 02KH.
