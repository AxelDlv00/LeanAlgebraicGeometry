# Blueprint-reviewer directive (iter-120)

Perform a whole-blueprint audit. Read every chapter in
`blueprint/src/chapters/` and produce a per-chapter checklist
(complete / correct / has must-fix-this-iter findings).

## User directive (verbatim, from `.archon/USER_HINTS.md`)

> I would like you to write complete blueprints for all the components
> that you will need to build to achieve the end state. This should
> allow you to ensure that there is no component that may be blocking
> and that you did not think of.

The user wants COMPLETE blueprints for all components needed for the
end state. Your audit must reflect this directive: a chapter that
hand-waves a sub-step that the prover will then have to invent on the
spot does not satisfy the user's criterion. Be strict.

## Chapters in scope (9 active per content.tex)

```
\input{chapters/Cohomology_SheafCompose}
\input{chapters/Cohomology_StructureSheafAb}
\input{chapters/Cohomology_StructureSheafModuleK}
\input{chapters/Cohomology_MayerVietoris}
\input{chapters/Differentials}
\input{chapters/Genus}
\input{chapters/Jacobian}
\input{chapters/Rigidity}
\input{chapters/AbelJacobi}
```

There are 4 orphan chapter files NOT in content.tex
(`Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`,
`Picard_LineBundle.tex`) — these correspond to Lean files deleted at
iter-117 trim and SHOULD remain orphans. Flag if you find them being
referenced from active chapters (broken \uses or \input chains).

## Special attention items this iter

1. **Differentials.tex Step 5 of `thm:smooth_locally_free_omega`** —
   the iter-119 prover finding (and `% NOTE:` already in the chapter
   at L92-104) revealed that the "definitionally equal to $\Omega_{B/A}$"
   claim is wrong at the Lean level. The chapter currently has a
   `% NOTE:` comment marking this defect but the prose itself has NOT
   been rewritten. Is the chapter still adequate to guide an iter-120
   prover lane? Mark CLEARLY whether this is must-fix-this-iter or
   advisory.

2. **`relativeDifferentialsPresheaf_iso_kaehler_appLE` is a NEW project-
   local helper** the iter-119 prover proposed. Is its blueprint coverage
   needed in Differentials.tex? If yes, the chapter is "incomplete" by
   the user's criterion until this lemma is blueprinted with a proper
   proof sketch (not just a label).

3. **`Jacobian.tex` `nonempty_jacobianWitness` is the single foundational
   hypothesis.** Per the user's hint, the blueprint should cover *all*
   components for the end state. The end-state includes
   `nonempty_jacobianWitness` as an explicit hypothesis (NOT closed).
   Is the blueprint's documentation of the 3 closure routes (A, B, C)
   itself "complete" in the user's sense — each Mathlib gap clearly
   named, each route's sub-step list rigorous — or is more detail
   warranted? The 3-route documentation is at L255-340.

4. **Are there any latent components** — definitions or lemmas the
   blueprint claims will follow "by standard arguments" but in fact
   require Mathlib pieces or proof effort that are not enumerated?
   This is the user's specific request: find latent gaps.

5. **Stale `% NOTE:` annotations** or orphan `\uses{...}` that point at
   deleted iter-117 trim content (`BasicOpenCech`, `Picard_*`,
   `Modules/Monoidal`). Flag any such.

## Per-chapter checklist format

For each of the 9 active chapters, report:

```
- {Chapter_name}
  - complete: {true | partial | false}
  - correct: {true | partial | false}
  - must-fix-this-iter: {none | list with specific line refs}
  - advisory ("soon"): {none | list}
```

## Cross-cutting findings

List any cross-chapter inconsistencies, broken `\uses` references,
missing `\lean{...}` hints, or wrong cross-references. Be specific
about line numbers.

## Hard-gate guidance for iter-120 plan agent

For each file F where iter-120 may schedule a prover lane, recommend
whether the chapter F → C maps to is gating-ready (complete + correct +
no must-fix), or whether the prover lane on F should be deferred this
iter pending a blueprint-writer dispatch. The two F's the plan agent is
considering this iter:

- `Differentials.lean` (for the bridge helper, or for re-attempting
  `smooth_locally_free_omega`).
- No other prover lane is currently planned (the other 8 active files
  have 0 sorries).

## Output

Write a single `task_results/blueprint-reviewer-iter120.md` report.
