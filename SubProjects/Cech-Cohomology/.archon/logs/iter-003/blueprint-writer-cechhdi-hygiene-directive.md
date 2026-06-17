# Blueprint Writer Directive

## Target chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Strategy context (the slice that matters)
Phases P1 (`pushPullMap_comp`) and P2 (`CechNerve`) are now PROVED in Lean
(`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`). This is a blueprint-hygiene
pass to (a) correct a now-misleading proof sketch and (b) restore the 1-to-1
Lean↔blueprint correspondence for new Lean declarations. NO mathematical content of the
project changes.

## Fix 1 (must-fix) — rewrite the `lem:push_pull_comp` proof body
The `\begin{proof}` of `lem:push_pull_comp` (`\lean{AlgebraicGeometry.pushPullMap_comp}`)
currently describes a route via `conjugateEquiv_comp` / injectivity of `conjugateEquiv`
("reduce to the pullback side by bijection"). **This route was proven INFEASIBLE in Lean
(kernel `whnf` blow-up).** A `% NOTE:` documents the real route. Replace the proof body
prose with the route that was actually used (stated mathematically, no Lean tactics):

  The composition law is proved by reducing `pushPullMap` to its transport-free *raw*
  form (the bridge `pushPullMap = rawPushPullMap …` holds definitionally), so that the
  two over-triangle `eqToHom` coercions can be eliminated by substituting the defining
  equalities of the over-morphisms (making the transports trivial). On the raw form the
  identity is the **pentagon coherence** of the pullback pseudofunctor
  (`pseudofunctor_associativity`, wrapped as the pentagon brick), combined with the
  decomposition of the composite adjunction unit (the mate core
  Lemma~\ref{lem:push_pull_unit_mate} and its solved form) and the naturality of the
  inner pullback–pushforward adjunction unit. The transport coherences are discharged by
  Lemma~\ref{lem:push_pull_transport_cancel}.

Keep the `\uses{}` on statement and proof unchanged (`lem:push_pull_unit_mate`,
`lem:push_pull_transport_cancel` are genuinely used). You MAY remove the now-redundant
`% NOTE:` comment once the body reflects the real route, OR leave it — your call. Do NOT
mention "infeasible", "iter", "whnf", or project history in the rendered prose; the body
should read as a clean mathematical sketch.

## Fix 2 (soon — restore 1-to-1) — add two `\definition` blocks for new Lean decls
Two substantive Lean declarations created in iter-002 have no blueprint block. Add a
`\definition` block for each, in the natural place within
`\section{...}` `\label{sec:cech_three_part}` (the three-part construction section, which
already describes these concepts in prose). These are project-bespoke (no external
source ⇒ no `% SOURCE` lines needed). Give each a `\label`, a `\lean{}`, accurate
`\uses{}`, and a one-paragraph informal description:

1. `\label{def:push_pull_functor}` `\lean{AlgebraicGeometry.pushPullFunctor}`
   `\uses{def:push_pull_obj, def:push_pull_map, lem:push_pull_id, lem:push_pull_comp}`
   — The push–pull functor \(G : (\mathrm{Over}\,X)^{\mathrm{op}} \to X\text{-Mod}\),
   assembling the object map \(p \mapsto p_* p^* F\) (Def~\ref{def:push_pull_obj}) and the
   morphism map (Def~\ref{def:push_pull_map}) into a genuine functor; functoriality is
   exactly the identity law (Lemma~\ref{lem:push_pull_id}) and the composition law
   (Lemma~\ref{lem:push_pull_comp}). Contravariant in the over-category.

2. `\label{def:cech_nerve_cosimplicial}` `\lean{AlgebraicGeometry.cechNerveCosimplicial}`
   `\uses{def:cover_cech_nerve, def:push_pull_functor}`
   — The (non-augmented) cosimplicial \(\mathcal{O}_X\)-module obtained by transporting
   the geometric {\v C}ech backbone in \((\mathrm{Over}\,X)\) through the push–pull
   functor: degreewise, the \(p\)-th term is the product of \(p\!+\!1\)-fold-intersection
   pushforwards. This is the underlying cosimplicial object that
   Def~\ref{def:cech_nerve} (`CechNerve`) augments.

Then update `def:cech_nerve`'s `\uses{}` to include `def:push_pull_functor` (and
optionally `def:cech_nerve_cosimplicial`) so the realised dependency is visible in the DAG.

## Out of scope (do NOT touch)
- **`lem:cech_acyclic_affine` (P3)** — its standard-cover-vs-general-cover statement gap is
  a separate strategic item being handled in a later iter. Leave the block exactly as is.
- Any P5 block (`lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`,
  `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`,
  `lem:cech_computes_cohomology`).
- Do NOT add `\leanok` anywhere.

## Verification
After editing, run `archon dag-query node --node def:push_pull_functor` and
`--node def:cech_nerve_cosimplicial` to confirm both new blocks are matched and that no
`\uses{}` edge is broken.
