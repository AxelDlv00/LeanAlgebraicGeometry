# lean-vs-blueprint-checker directive — iter-214

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Its blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (context for your diff)

The prover (route (e), mathlib-build mode) added a new `StalkLinearMap` section
with four declarations — `stalkLinearMap`, `stalkLinearMap_germ`,
`stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso` — packaging the
`R.stalk x`-linear stalk map of a `PresheafOfModules` morphism. These are
project-local supplements (Mathlib supplies the stalk *module* structure via
`Mathlib.Algebra.Category.ModuleCat.Stalk` but not the linearity of the induced
stalk map). The target lemma `isLocallyInjective_whiskerLeft_of_W`
(`\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}`,
`\label{lem:islocallyinjective_whisker_of_W}`) remains a typed `sorry`.

## What to report (bidirectional)

1. **Lean → blueprint**: Are the four new `stalkLinearMap*` declarations
   represented in the chapter at all? If not, is that a gap the chapter should
   fill (they are the d.1 ingredients of the route-(e) stalkwise argument), or
   acceptable as below-blueprint-altitude scaffolding? State which.
2. **Blueprint → Lean**: Does the chapter's statement of
   `lem:islocallyinjective_whisker_of_W` match the Lean signature of
   `isLocallyInjective_whiskerLeft_of_W` (hypotheses, the `J.W` condition, the
   `F ◁ g` conclusion)? Is the chapter's informal proof sketch detailed enough
   to actually formalize the residual (does it name the d.1-bridge
   site-`W`↔stalkwise-iso step and the d.2 stalk-⊗ commutation), or is it too
   thin to guide the next prover?
3. Any fake/placeholder statement, signature mismatch, or `\lean{...}` pointing
   at a non-existent / renamed declaration.

Report only on this file and this chapter. No global/strategy context.
