# Refactor directive — iter-019 cleanup (orphan import + stale comments)

Two mechanical, non-proof changes. You do NOT fill or modify any proof body, and you must NOT touch
the frozen protected signature `AlgebraicGeometry.cech_computes_higherDirectImage` in
`CechHigherDirectImage.lean` (you only edit COMMENT text in that file, never code). No `sorry`
should be introduced anywhere — these are comment/import edits only. After the changes, run
`lake build` and confirm it stays green.

## Change 1 — Wire the orphaned P5a file into the root barrel

`AlgebraicJacobian.lean` (the root barrel) imports every Cohomology file EXCEPT the new
`HigherDirectImagePresheaf.lean`, so that file is currently outside the project build. Add the line

    import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf

to `AlgebraicJacobian.lean`, alphabetically/sensibly grouped with the other
`import AlgebraicJacobian.Cohomology.*` lines. (The file compiles standalone — confirmed iter-018 —
so the root build stays green.)

## Change 2 — Remove/correct four actively-misleading stale comments

Each of these comment blocks describes an already-proved declaration as still open, which misleads
future provers. Update each to reflect reality (proved), or delete the stale block. Do NOT change any
code, only the comment text.

1. `AlgebraicJacobian/Cohomology/AcyclicResolution.lean:924–964` — the `/-! ### Status (iter-006) -/`
   block claims "TARGET 3 (the acyclic-resolution staircase) remains" and lists
   `rightDerivedIsoOfAcyclicResolution` under REMAINING. That decl is fully proved at lines 893–922
   (immediately above). Delete the stale status block (or replace with a one-line "P4 complete" note).

2. `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:161–183` — block comment says
   `pushPullMap_comp` is "left for a focused follow-up pass" and that `pushPullFunctor` cannot be
   assembled without it. Both false: `pushPullMap_comp` is proved (~line 627) and `pushPullFunctor`
   is assembled (~line 640). Correct or remove the stale claim. (Comment text only — do not touch the
   protected decl or any proof.)

3. `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:245–293` — the block titled "Composition
   law `pushPullMap_comp` — ... not yet closed" with a "Why it is not yet closed" subsection. It is
   closed (proved ~line 627 via `rawPushPullMap_comp`). Delete this stale block (it is the most
   misleading comment in the project).

4. `AlgebraicJacobian/Cohomology/PresheafCech.lean:17–23` — the module docstring claims this file "is
   the home of the presheaf-level Čech machinery" and lists 5 declarations, 4 of which have moved
   (`cechFreePresheafComplex`/`cechFreeComplex_quasiIso` → `FreePresheafComplex.lean`;
   `cechComplex_hom_identification`/`injective_cech_acyclic` → `CechBridge.lean`). Update the
   docstring to describe what PresheafCech.lean actually now contains (the section Čech complex
   `sectionCechComplex`, `freeYonedaHomEquiv`/`freeYonedaHomAddEquiv`, `injective_toPresheafOfModules`)
   and point to the sibling files for the moved machinery.

Do NOT edit `CechBridge.lean`, `FreePresheafComplex.lean`, or `CechAcyclic.lean` — those are active
prover lanes this iter; their comments will be refreshed by the prover work.
