# Blueprint Writer Directive

## Slug
pointer-iter146

## Target chapter
blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

## Strategy context

This chapter is the **pointer chapter** for the Lean file
`AlgebraicJacobian/Cotangent/GrpObj.lean`. The mathematical content
lives in `RigidityKbar.tex`; this chapter's job is to list the
declarations actually present in the Lean file with one-line
dispositions.

The iter-145 refactor `refactor-chart-algebra-skeleton-bundled-excise-iter145`
DELETED 5 declarations from `Cotangent/GrpObj.lean` (903 → 631 LOC):
* `basechange_along_proj_two_inv_derivation` (was iter-138 main + iter-142 d_map close + iter-143 `have hw` + iter-144 d_app residual; deleted)
* `basechange_along_proj_two_inv` (cascade; deleted)
* `basechange_along_proj_two_inv_app_isIso` (iter-143 named-theorem refactor; deleted)
* `relativeDifferentialsPresheaf_basechange_along_proj_two` (cascade; deleted)
* `mulRight_globalises_cotangent` (iter-135 Compose main lemma; deleted)

The chapter has not been updated to reflect this excise. The
disposition paragraph (L10–L17) says "the file's remaining sorry-bodied
declarations are preserved as auditable record"; this is structurally
wrong — ZERO sorry-bodied bundled-route declarations remain in
`Cotangent/GrpObj.lean`. The `\item` enumeration in § "Lean
declarations in this file" then describes 11 declarations; 5 of those
are the deleted ones.

The iter-145 review-side `lean-vs-blueprint-checker-cotangent-grpobj-review145`
classified this as a must-fix-this-iter manifest-drift issue. The
iter-146 blueprint-reviewer re-confirmed.

The decision per the iter-146 plan agent: REWRITE the disposition
paragraph + handle the 5 stale `\item` bullets. Use git history (per
iter-145 Q7 "auditable record IS git history") for the deleted
declarations' history; the chapter prose should describe ONLY the
surviving in-tree declarations.

## Required content

### A. Disposition paragraph rewrite (L10–L17)

Current text says (paraphrased): "the file's remaining sorry-bodied
declarations are preserved as auditable record of the bundled route".

Replace with prose that articulates honestly:

* What the file currently contains (post-iter-145 excise): piece (i.a)
  trio (`cotangentSpaceAtIdentity` + `cotangentSpaceAtIdentity_eq_extendScalars`
  + `cotangentSpaceAtIdentity_finrank_eq`, all closed iter-128–iter-132)
  plus a small set of orphan helpers from the iter-134 → iter-136
  bundled-route build (`shearMulRight` + companions, `schemeHomRingCompatibility`,
  `relativeDifferentialsPresheaf_restrict_along_identity_section`,
  the private helpers `section_snd_eq_identity_struct` and
  `isIso_of_app_iso_module`).
* What the file no longer contains: the 5 declarations excised iter-145
  per the iter-144 chart-algebra pivot (`basechange_along_proj_two_inv_derivation`,
  `basechange_along_proj_two_inv`, `basechange_along_proj_two_inv_app_isIso`,
  `relativeDifferentialsPresheaf_basechange_along_proj_two`,
  `mulRight_globalises_cotangent`). The full history of these
  declarations' iter-138 → iter-143 build attempts lives in git
  history (the iter-145 Q7 "auditable record IS git history" framing
  in `STRATEGY.md` § Iter-144 chart-algebra pivot).
* Where to find chart-algebra piece (ii) work: the iter-145 NEW
  subsection "Chart-algebra piece (ii) first-class decomposition" in
  `RigidityKbar.tex` (L1773–L1956), with corresponding Lean scaffolds
  in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.

Keep the paragraph compact: 2–3 sentences for the post-excise content
description, 1 sentence pointing at git history for the excised
declarations, 1 sentence pointing at `ChartAlgebra.lean` /
`RigidityKbar.tex` for the active chart-algebra piece (ii) work.

### B. Five stale `\item` bullets — DELETE outright

The current `\item` enumeration in § "Lean declarations in this file"
contains 5 bullets for declarations that no longer exist in tree:
* `relativeDifferentialsPresheaf_basechange_along_proj_two` (lines ~52–58)
* `basechange_along_proj_two_inv_derivation` (lines ~59–79)
* `basechange_along_proj_two_inv` (lines ~80–97)
* `basechange_along_proj_two_inv_app_isIso` (lines ~98–110)
* `mulRight_globalises_cotangent` (lines ~115–125)

DELETE these 5 bullets outright. Per the iter-145 Q7 "auditable record
IS git history" framing, the deleted declarations' decision history
lives in git logs + iter sidecars; carrying stale `\item` bullets in
the pointer chapter perpetuates the iter-141 preservation-of-bundled
pattern at the textual-disposition level.

### C. Six surviving `\item` bullets — light prose touch

The remaining 6 bullets (all in-tree) need a light prose touch to
remove any "consumes [excised decl]" framing left dangling by item B:

* `cotangentSpaceAtIdentity` (currently around L22) — accurate as-is
  per iter-145 review. NO CHANGE.
* `cotangentSpaceAtIdentity_eq_extendScalars` (around L26) — accurate.
  NO CHANGE.
* `cotangentSpaceAtIdentity_finrank_eq` (around L30) — accurate.
  NO CHANGE.
* `shearMulRight` + `_hom_fst`/`_hom_snd` companions (around L33–L42) —
  currently described as "Step 1 of piece (i.b)". After the bundled-
  route excise, these are orphan helpers (no in-tree consumer). UPDATE
  the prose to honestly flag the orphan status: "Closed iter-134;
  consumer (piece (i.b) Step 2 chain) DELETED iter-145 under
  chart-algebra pivot, leaving these as standalone categorical
  helpers. Iter-146+ cleanup candidate; preserved iter-145 per
  refactor directive's `private`-or-`public`-discipline rule."
* `schemeHomRingCompatibility` (around L43–L51) — same orphan situation.
  UPDATE prose: "Closed iter-135; consumer (piece (i.b) Step 2 chain)
  DELETED iter-145 under chart-algebra pivot, leaving this as a
  standalone adjunction-transpose utility. Iter-146+ cleanup candidate."
* `relativeDifferentialsPresheaf_restrict_along_identity_section`
  (around L111–L114; current line numbers after iter-145 edit) —
  same. UPDATE prose: "Closed iter-136; consumer (Compose main lemma
  `mulRight_globalises_cotangent`) DELETED iter-145 under chart-
  algebra pivot, leaving this as a standalone Step 3 section-
  restriction utility. Iter-146+ cleanup candidate."

DO NOT introduce a separate `\item` for the two private helpers
(`section_snd_eq_identity_struct` and `isIso_of_app_iso_module`).
Per the iter-145 lean-vs-blueprint-checker, both are private to
`Cotangent/GrpObj.lean` and not surfaced in the chapter; that's the
right level of detail for a pointer chapter.

## Out of scope

* DO NOT rewrite or remove the chapter's `\chapter{...}` heading or
  the first paragraph identifying it as a pointer to
  `Cotangent/GrpObj.lean`.
* DO NOT touch any `\leanok` or `\mathlibok` markers anywhere.
* DO NOT introduce new declaration blocks (the surviving 6 `\item`s
  cover the in-tree declarations correctly).
* DO NOT touch the chapter cross-references to `RigidityKbar.tex`
  (the pointer-to-RigidityKbar-for-content framing is correct).
* DO NOT add a new chapter file or modify `content.tex`. The chart-
  algebra-content-in-RigidityKbar-subsection routing is
  pedagogically clean per the iter-146 blueprint-reviewer's
  informational verdict.

## References

* iter-146 blueprint-reviewer report at
  `.archon/task_results/blueprint-reviewer-iter146.md` — names the
  manifest drift as must-fix-this-iter at chapter-level.
* iter-145 lean-vs-blueprint-checker report at
  `.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review145.md`
  — per-`\item` audit + recommended chapter-side actions list.
* iter-145 review.md at `.archon/iter/iter-145/review.md` — names the
  iter-145 EXCISE summary + the iter-146 blueprint-writer task #2
  ("pointer chapter manifest reconciliation").

## Expected outcome

After this edit, `AlgebraicJacobian_Cotangent_GrpObj.tex` becomes
`complete: true / correct: true` with:

* Disposition paragraph (L10–L17) rewritten to reflect post-iter-145
  reality: piece (i.a) trio + orphan helpers in-tree; bundled-route
  decls excised; chart-algebra in `RigidityKbar.tex` + `ChartAlgebra.lean`.
* 5 stale `\item` bullets DELETED outright (no `EXCISED iter-145`
  tags carried forward; git history is the audit record).
* 6 surviving `\item` bullets retained; the 3 orphan-helper bullets
  (`shearMulRight`, `schemeHomRingCompatibility`,
  `relativeDifferentialsPresheaf_restrict_along_identity_section`)
  get a sentence honestly flagging orphan status + iter-146+ cleanup
  candidate label.

Expected LOC delta: ~−90 LOC (5 bullet deletions ~−75 LOC + disposition
paragraph rewrite ~−10 LOC + orphan-status sentences ~+3 LOC = ~−82
LOC net). The chapter shrinks from ~135 LOC to ~50 LOC.
