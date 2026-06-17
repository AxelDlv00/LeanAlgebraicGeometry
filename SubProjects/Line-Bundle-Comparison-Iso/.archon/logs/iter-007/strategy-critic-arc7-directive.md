# Strategy-critic directive — iter-007

Read ONLY these (do NOT read iter sidecars, task_pending/task_done, prover task_results, or any
per-iter narrative):
- `/home/archon/proj/Line-Bundle-Comparison-Iso/.archon/STRATEGY.md` (verbatim — the strategy to critique)
- `/home/archon/proj/Line-Bundle-Comparison-Iso/references/summary.md` (reference index)
- Chapter titles + one-line topic each: `blueprint/src/chapters/Picard_LineBundlePullback.tex`,
  `Picard_TensorObjSubstrate.tex`, `Picard_RelPicFunctor.tex` (read just the `\chapter{}`/`\section{}`
  headers, not the bodies).

## Project goal (the destination)
Formalize, with zero inline `sorry`, three seed declarations + their dependency cone for the
Line-Bundle Comparison Iso subproject (A.1.c.sub of the Algebraic-Jacobian-Challenge):
`lem:pullback_tensor_iso_loctriv` (loc-triv comparison iso f*(M⊗N)≅f*M⊗f*N), `lem:dual_isLocallyTrivial`
(dual of loc-triv is loc-triv), `thm:rel_pic_addcommgroup_via_tensorobj` (AddCommGroup on the relative
Picard sheaf).

## What changed this iter (for your verdict)
The DUAL phase was reframed: a multi-iter RED deadlock on `sliceDualTransport` naturality was broken by
GREENing the file (typed sorry at broken sites) and splitting `sliceDualTransport` into its own file;
the morphism-level recipe (`IsIso.inv_comp_eq` → forward ε-square, never `inv ε` pointwise) is now the
active corrective. A `Coverage + file-split cleanup` phase was added. Assess whether the route structure,
phase ordering, and estimations are sound, and whether the two-route + consumer decomposition still
matches the goal. Challenge any route you find unsound; give a SOUND/CHALLENGE/REJECT verdict per route.
