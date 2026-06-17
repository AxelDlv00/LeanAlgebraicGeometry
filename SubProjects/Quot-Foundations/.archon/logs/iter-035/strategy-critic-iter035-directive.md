# Strategy-critic directive — iter-035 (Quot-Foundations)

Fresh-mathematician review of the project strategy. You see ONLY the strategy + sources below; no
iter history, no prover narrative. Read these files verbatim:

- `STRATEGY.md` (the current strategy — read the whole file).
- `references/summary.md` (the source index).

## Blueprint chapters (title · one-line topic)
- `Cohomology_FlatBaseChange.tex` — Flat base change for pushforward of a quasi-coherent sheaf (i=0);
  consolidated, also covers `FlatBaseChangeGlobal.lean` (H⁰-as-equalizer globalization).
- `Cohomology_RegroupHelper.tex` — Regrouping iso for the affine base-change tensor tower.
- `Picard_FlatteningStratification.tex` — Flattening stratification / generic flatness of a coherent sheaf.
- `Picard_GrassmannianCells.tex` — Grassmannian Gr(r,d): big-cell charts, transitions, gluing, separated, proper.
- `Picard_QuotScheme.tex` — The Quot scheme; consolidated, also covers `GradedHilbertSerre.lean`
  (graded Hilbert–Serre rationality) and the gap1 QCoh≃Mod affine-descent chain.
- `Picard_RelativeSpec.tex` — Relative Spec.

## Project goal (one paragraph)
Close the sorry-bearing nodes of the Čech-independent leg of the parent's `thm:fga_pic_representability`
cone (Kleiman FGA "The Picard scheme" §4): FBC (i=0 flat base change, Stacks 02KH), GF (generic flatness,
Nitsure §4), QUOT (Hilbert polynomial, Quot functor, Grassmannian scheme + representability). End-state:
zero project sorry in the closure, kernel-only axioms.

## Specific questions for this review
1. The **FBC-A** route (conjugate-side re-encoding of the `_legs` mate-coherence via `leftAdjointCompIso`
   + `conjugateEquiv.injective`) is the central, long-running blocker. Is the route sound, and is the
   estimate (2–4 iters left) credible? If it stalls again, what is the best NON-user-escalation fallback
   (the project operates under a standing directive forbidding user escalation — refactor of the
   comparison-object encoding is on the table)? Is there a structurally simpler route to
   `IsIso(pushforwardBaseChangeMap)` that the strategy is missing?
2. **GR**: separated is done; the strategy should move GR-glue/separated to `## Completed` and surface
   `gr_proper` (valuative criterion of properness, Nitsure §1) as the live GR target. Is the valuative-
   criterion route the right one, and does the phase table reflect reality?
3. **QUOT gap1**: the keystone is now `lem:section_localization_descent` (Stacks `lemma-invert-f-sections`)
   feeding the in-file QCoh≃Mod iff. Is this decomposition (C bridge → P1 local-tilde → D descent →
   assembly) sound and faithful to the cited sources?
4. Any phase-table drift, dead route, or missing Mathlib gap.

Return SOUND / CHALLENGE / REJECT per concern. If you CHALLENGE a route, name the alternative concretely.
