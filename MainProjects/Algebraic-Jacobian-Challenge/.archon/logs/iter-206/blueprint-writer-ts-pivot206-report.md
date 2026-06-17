# Blueprint Writer Report

## Slug
ts-pivot206

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Summary
Rewrote the chapter to move the relative Picard group law off the
over-built full `MonoidalCategory (Scheme.Modules X)` / `MonoidalClosed`
route and onto the flat-scoped line-bundle route described in
`analogies/ts-design206.md`. The group law is now derived from four
existence-of-iso lemmas on line bundles (propositions, no coherence), all
assembled from a single genuinely-hard ingredient — the flat-scoped
restriction-compatibility iso `tensorObj_restrict_iso`, which reduces to
elementary Mathlib flat-exactness. The global monoidal category is demoted
to an explicitly off-critical-path remark.

## Changes Made
- **Revised** `sec:tensorobj_motivation` (the closing "three ingredients"
  paragraph) — reframed: the group law lives on iso-classes, each axiom is a
  `Nonempty(… ≅ …)` proposition insensitive to coherence; the carrier needs
  only (1) `⊗` well-defined on iso-classes, (2) the unit `O_X`, (3) four
  existence-of-iso facts on line bundles, all reducing to the flat-scoped
  `tensorObj_restrict_iso`. Added the `O(1)` vs `O` non-globality remark and
  a forward pointer to `rem:scheme_modules_monoidal_off_path`.
- **Revised** `sec:tensorobj_api_survey` "The gap" paragraph — the recorded
  gap is now the flat-scoped `tensorObj_restrict_iso` (elementary,
  Mathlib-backed), not a global monoidal/`MonoidalClosed` lift. Removed the
  "associator/unitor/braiding data" framing.
- **Demoted** `thm:scheme_modules_monoidal` → **new remark**
  `rem:scheme_modules_monoidal_off_path` (`\begin{remark}`). Removed the
  `\lean{…monoidalCategory}` pin and the entire "Concrete Mathlib
  realisation" proof body (the `IsMonoidal W` / `Localization.Monoidal` /
  implicit `MonoidalClosed` plan). The remark states the full monoidal
  category is NOT required and is off the critical path, with one-sentence
  why (coherence never consumed by a group law on iso-classes), and aligns
  with Mathlib's `CommRing.Pic`.
- **Added lemma** `lem:tensorobj_restrict_iso` (no `\lean` pin; target name
  `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` noted in prose) —
  for line bundles `(L⊗M)|_f ≅ L|_f ⊗ M|_f`, proved via right-exactness +
  `Module.Flat.lTensor_preserves_injective_linearMap`, packaged as
  `Module.Invertible.lTensor_bijective_iff`; flatness automatic via
  `Module.Invertible ⇒ Projective ⇒ Flat`. Explicitly the elementary
  flat-exactness replacement for the deleted `MonoidalClosed`/`IsMonoidal W`
  route.
- **Added lemmas** `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`,
  `lem:tensorobj_comm_iso` (no `\lean` pins) — the associativity, unit
  `O_X⊗L≅L`, and commutativity existence-of-iso statements
  (`Nonempty(… ≅ …)`), each assembled from `tensorobj_restrict_iso` on a
  common trivialising cover. Inverse is the pre-existing
  `lem:tensorobj_inverse_invertible` (kept).
- **Revised** `lem:tensorobj_inverse_invertible` — added
  `lem:tensorobj_restrict_iso` to its `\uses` (gluing of the contraction
  iso). Statement/`\leanok` untouched.
- **Revised** `lem:tensorobj_lift_onproduct` — `\uses` now cites the three
  new iso lemmas; proof's final sentence no longer appeals to
  `thm:scheme_modules_monoidal`, instead to the four iso lemmas restricting
  to the subtype.
- **Revised** `lem:pullback_compatible_with_tensorobj` proof — replaced the
  "same descent argument as in thm:scheme_modules_monoidal" with the
  flat-exactness / restriction-compatibility argument of
  `lem:tensorobj_restrict_iso` (extension of scalars is flat).
- **Revised** `thm:rel_pic_addcommgroup_via_tensorobj` — `\uses` (statement +
  proof) drop `thm:scheme_modules_monoidal` and cite the four iso lemmas;
  statement prose now points at `def:scheme_modules_tensorobj` (not the
  removed theorem). Proof fully rewritten: group axioms derived as the four
  existence-of-iso propositions (assoc/unit/comm/inverse, itemised), with
  explicit "no pentagon/triangle/hexagon consumed", kept `QuotientAddGroup`
  assembly, and added the Mathlib idiom alignment (`CommRing.Pic` /
  `instCommGroupPic` / `Module.Invertible` ↔ `IsLocallyTrivial`; scheme Pic
  absent from Mathlib, supplied lightly).
- **Revised** `sec:tensorobj_loc_estimates` — Piece 2 is now the flat-scoped
  `tensorObj_restrict_iso` + four iso lemmas (not pentagon/triangle/hexagon);
  re-estimated to ~80–150 LOC total (Piece 1 ~30–60, Piece 2 ~30–60, Piece 3
  ~20–40) and updated the sequencing rationale (no monoidal-coherence
  dependency). Renumbered Piece 3e → 3c.
- **Revised** top-of-chapter planner NOTE comment — "monoidal-category axioms
  it has to satisfy" → "four existence-of-isomorphism facts on line bundles".
- **Revised** `sec:tensorobj_consistency_check` `\uses`-graph bullet list to
  reflect the new lemmas, the demoted remark, and the rewired dependencies.

## Cross-references introduced
- `\cref{lem:tensorobj_restrict_iso}` — new, in this chapter (motivation, API
  survey, remark, assoc/unit/comm/inverse lemmas, pullback lemma, LOC).
- `\cref{lem:tensorobj_assoc_iso,lem:tensorobj_unit_iso,lem:tensorobj_comm_iso}`
  — new, in this chapter (lift lemma, consumer theorem, LOC, consistency).
- `\cref{rem:scheme_modules_monoidal_off_path}` — new remark, in this chapter
  (motivation, API survey, LOC).
- All `thm:scheme_modules_monoidal` references removed (label no longer
  exists). Verified zero dangling references via grep.
- Unchanged external refs still valid: `def:pullback_along_projection`,
  `thm:relative_pic_quotient_well_defined`, `lem:rel_pic_sharp_groupoid`
  (Picard_LineBundlePullback / Picard_RelPicFunctor).

## Mathlib names verified (via Lean LSP loogle, this session)
- `Module.Invertible.lTensor_bijective_iff` — `Mathlib.RingTheory.PicardGroup` ✓
- `Module.Flat.lTensor_preserves_injective_linearMap` — `Mathlib.RingTheory.Flat.Basic` ✓
- `CommRing.Pic`, `instCommGroupPic`, `CommRing.Pic.mk` (carries
  `[Module.Invertible R M]`) — `Mathlib.RingTheory.PicardGroup` ✓
- `Module.Invertible` confirmed as the predicate (hypothesis of the above).
- `instProjectiveOfInvertible` (Invertible ⇒ Projective ⇒ Flat) cited per the
  design rationale; not separately loogle-verified by exact name (rate
  limit), attributed in prose to `Mathlib.RingTheory.PicardGroup`.

## References consulted
- `analogies/ts-design206.md` — primary design input; the flat-scoped
  line-bundle route, the four-iso decomposition, and the Mathlib idiom
  alignment all come from here.
- `references/summary.md` — confirmed Stacks 01CR is the Picard-group
  reference already cited inline in the chapter; no new external source
  needed. (No new `% SOURCE:` blocks were added — the new content is
  Mathlib-API-grounded, not textbook-derived; the existing Kleiman df:aPf /
  df:Pfs `% SOURCE` / `% SOURCE QUOTE` blocks were preserved verbatim.)

## Macros needed (if any)
- None. Reused existing `\MonoidalCategory`, `\AddCommGroup`, `\AddCommGrpCat`
  macros (confirmed defined in `macros/common.tex`). Used `\triangleleft`
  (base LaTeX) for `whiskerLeft`, and plain `\mathtt{MonoidalClosed}` /
  `\mathtt{QuotientAddGroup}` text (no macro). `\mathbb{P}^1`, `\mathrm{Nonempty}`,
  `\mathrm{Units}`, `\mathrm{Skeleton}` are standard.

## Reference-retriever dispatches (if any)
- None. The chapter's new content is grounded in `analogies/ts-design206.md`
  and Mathlib (verified via LSP); the only external math source (Stacks 01CR)
  was already cited.

## Notes for Plan Agent
- **Orphaned Lean decl.** Demoting `thm:scheme_modules_monoidal` to a remark
  removed the `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` pin.
  The `:= sorry`-bodied `monoidalCategory` instance in
  `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` is now unreferenced by
  the blueprint. blueprint-doctor may flag it as an orphan. Per the corrected
  strategy that instance is off the critical path — recommend the plan agent
  decide whether to delete/deprecate it via lean-scaffolder, or leave it as a
  dormant non-load-bearing decl. Either way the group law no longer needs it.
- **New unpinned Lean targets.** `lem:tensorobj_restrict_iso` (target
  `…Scheme.Modules.tensorObj_restrict_iso`) and the three iso lemmas
  (`tensorobj_assoc_iso` / `_unit_iso` / `_comm_iso`) have no `\lean{}` pins
  yet, per directive (names not yet final). The plan agent / lean-scaffolder
  should choose the final Lean names and pin them when the Lean file is
  scaffolded. The design rationale notes the Lean substrate already has
  `tensorObj_restrict_iso`, `tensorObj_isLocallyTrivial`,
  `exists_tensorObj_inverse` decls (`TensorObjSubstrate.lean:249–304`), so the
  restrict-iso name likely already exists and can be pinned directly.
- **RelPicFunctor consumer.** The consumer `addCommGroup_via_tensorObj`
  (still pinned, in `RelPicFunctor.lean`) now consumes four iso lemmas +
  `QuotientAddGroup`, not a `MonoidalCategory` instance. Its `\uses` in this
  chapter was updated accordingly; the Lean proof obligation is
  correspondingly lighter (~10–20 LOC bridging instance per the revised LOC
  section).

## Strategy-modifying findings
None. The rewrite implements the strategy decision recorded in
`analogies/ts-design206.md` (ALIGN_WITH_MATHLIB: abandon the all-modules
monoidal-closed route, build the group law on the flat line-bundle
subcategory). It does not surface a new strategy-level issue.
