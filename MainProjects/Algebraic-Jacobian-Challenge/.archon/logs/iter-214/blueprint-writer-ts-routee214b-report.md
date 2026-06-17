# Blueprint Writer Report

## Slug
ts-routee214b

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Summary
Pivoted the associator/group-law realization from the hand-assembled
absorb→associate→absorb 3-step composite to **route (e)** — instantiating
Mathlib's `Localization.Monoidal.LocalizedMonoidal` on the already-monoidal
`PresheafOfModules O_X` and the sheafification localizer `J.W`, so the
associator/unitors/braiding/all coherence are API-derived. Cleared all four
iter-213 lean-vs-blueprint must-fix items. No `\leanok`/`\mathlibok` markers were
added or removed.

## Changes Made
- **Revised motivation paragraph** (`sec:tensorobj_motivation`) — replaced the
  prose that built requirement (3) as the bespoke 3-step composite with the
  route-(e) story: the full monoidal scaffolding is already in Mathlib; the sole
  new obligation is the instance `J.W.IsMonoidal`, whose load-bearing half is the
  flatness-free stalkwise local-injectivity lemma (now named the sole open
  obligation).
- **Rewrote the API survey** (`sec:tensorobj_api_survey`) — replaced the
  Layer-1/Layer-2/gap framing with the four verified route-(e) Mathlib facts:
  (i) `PresheafOfModules.monoidalCategory`, (ii)
  `MorphismProperty.IsMonoidal` + `Localization.Monoidal.LocalizedMonoidal`,
  (iii) `Sites/Point/IsMonoidalW` as the proof template, and the
  Mathlib-absent gap (no monoidal `SheafOfModules`, no `PresheafOfModules`
  stalk infra). Added verbatim `% SOURCE` / `% SOURCE QUOTE` comments quoting the
  on-disk Mathlib source for (i),(ii),(iii).
- **Reframed `rem:scheme_modules_monoidal_off_path`** — the full monoidal
  category is now documented as *cheap* (the output of `LocalizedMonoidal`, no
  `MonoidalClosed`), the earlier "needs MonoidalClosed" reading explicitly called
  the wrong altitude; the group law still consumes only existence-of-iso
  propositions. `\uses` now includes `lem:whisker_of_W`.
- **Updated `lem:flat_whisker_localizer` prose** — flat whisker variants kept as
  closed standalone results, documented as **superseded on the critical path** by
  the flatness-free `_of_W` variants (`lem:whisker_of_W`).
- **ADDED `\section{Route~(e)...}`** (`sec:tensorobj_route_e`) with three new
  blocks:
  - `lem:islocallyinjective_whisker_of_W` —
    `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}`. Documents the
    load-bearing residual (a `sorry`): stalkwise `(F◁g)_x = id⊗g_x` iso, with d.1
    (module-level `J.W`↔stalk-iso) and d.2 (stalk commutes with relative tensor)
    named as the Mathlib-absent residual. Marked THE sole open obligation.
  - `lem:whisker_of_W` —
    `\lean{PresheafOfModules.W_whiskerLeft_of_W, PresheafOfModules.W_whiskerRight_of_W}`.
    The closed flatness-free whisker lemmas (surjectivity free, injectivity via
    the residual); the `whiskerLeft`/`whiskerRight` data of `MorphismProperty.IsMonoidal (J.W)`.
  - `lem:jw_ismonoidal` — **unpinned** (no Lean decl yet), stated-but-unformalized:
    the `(J.W).IsMonoidal` instance + `LocalizedMonoidal` instantiation as the
    route-(e) target giving `MonoidalCategory (SheafOfModules X.ringCatSheaf)`.
- **Rewrote `lem:tensorobj_assoc_iso`** — kept the `\lean{}` pin; statement/proof
  now obtain the associator as the API-derived component of `lem:jw_ismonoidal`,
  NOT a 3-step composite. `IsLocallyTrivial` hypotheses documented as vestigial.
  `\uses` → `{def:scheme_modules_tensorobj, lem:jw_ismonoidal}`. Removed the dead
  flatness/cover-route prose.
- **Fixed `lem:tensorobj_lift_onproduct`** (must-fix) — carrier corrected to the
  `IsLocallyTrivial` subtype `LineBundle.OnProduct` (not `IsInvertible`); proof
  now uses `tensorObj_isLocallyTrivial` directly, matching the Lean body. `\uses`
  dropped `def:scheme_modules_isinvertible` and `lem:tensorobj_isoclass_commgroup`,
  now `{def:scheme_modules_tensorobj, lem:tensorobj_preserves_locally_trivial}`.
- **Reframed `lem:tensorobj_isoclass_commgroup`** — kept the
  `tensorObjIsoclassCommMonoid` carrier pinned; the commutative monoid + its
  units now follow from the route-(e) `MonoidalCategory` via
  `Pic(X) = Units(Skeleton(Scheme.Modules X))`, mirroring `CommRing.Pic`. Removed
  the `IsInvertible⇒IsLocallyTrivial` bridge clause (no longer needed: the
  route-(e) associator is natural in arbitrary objects). `\uses` gained
  `lem:jw_ismonoidal`.
- **Updated minor cross-references** — the `lem:isiso_sheafification_map_of_W`
  bridge re-documented as a retained closed supplement (no longer the
  associator's load-bearing step); the `tensorObj_unit_iso` proof's "as with the
  associator" phrasing fixed; the `sec:tensorobj_onproduct_lift` intro and the
  `sec:tensorobj_consistency_check` itemization rewritten to the route-(e) chain.

## Cross-references introduced
- `\uses{lem:jw_ismonoidal}` added in `lem:tensorobj_assoc_iso`,
  `lem:tensorobj_isoclass_commgroup`, `rem:scheme_modules_monoidal_off_path`
  (via `lem:whisker_of_W`) — all three new labels are defined in this chapter
  (`sec:tensorobj_route_e`).
- `\uses{lem:islocallyinjective_whisker_of_W}` in `lem:whisker_of_W`; defined in
  this chapter.
- `\uses{lem:tensorobj_preserves_locally_trivial}` in
  `lem:tensorobj_lift_onproduct` — defined earlier in this chapter.
- LaTeX environment balance verified (non-comment): lemma 16/16, proof 17/17,
  definition 2/2, theorem 1/1, remark 1/1, enumerate 2/2.

## References consulted
- `.lake/packages/mathlib/Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean`
  (L104, L125) — verbatim `monoidalCategoryStruct`/`monoidalCategory` instance for
  the `% SOURCE QUOTE` in survey paragraph (i).
- `.lake/packages/mathlib/Mathlib/CategoryTheory/Localization/Monoidal/Basic.lean`
  (L44, L86, L440) — verbatim `IsMonoidal` class, `LocalizedMonoidal` def, and the
  `MonoidalCategory (LocalizedMonoidal …)` instance for survey paragraph (ii).
- `.lake/packages/mathlib/Mathlib/CategoryTheory/Sites/Point/IsMonoidalW.lean`
  (L48, L57) — verbatim `isMonoidal_W` lemma + instance for survey paragraph (iii).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (L382–478 `WhiskerOfW`
  section) — confirmed the three pinned Lean decl names and that `WhiskerOfW` is a
  `section` (so names are `PresheafOfModules.*`, not `*.WhiskerOfW.*`).
- `.archon/task_results/lean-vs-blueprint-checker-ts213.md` — the four must-fix
  items addressed.

Note on citation discipline: the new `% SOURCE`/`% SOURCE QUOTE` blocks cite the
on-disk Mathlib `.lean` source (the route-(e) formalization vehicle), as the
directive explicitly authorized; the parenthetical points to the exact
`.lake/packages/mathlib/...` file read this session. The pre-existing
Stacks/Kleiman citation blocks (`def:scheme_modules_isinvertible`,
`lem:tensorobj_inverse_invertible`, `lem:tensorobj_isoclass_commgroup`,
`thm:rel_pic_addcommgroup_via_tensorobj`) were left untouched.

## Macros needed (if any)
None. (I initially used a nonexistent `\fcomp`; replaced both occurrences with
`\circ`. All other commands — `\MonoidalCategory`, `\Scheme`, `\Pic`,
`\AddCommGroup`, `\triangleleft`, `\triangleright` — are pre-existing.)

## Reference-retriever dispatches (if any)
None — no new external source was needed (route (e) is a Mathlib-API construction;
the underlying "Pic = Units of the monoidal Skeleton" math is standard and already
cited from Stacks 01CR / Kleiman in the retained blocks).

## Notes for Plan Agent
- `lem:jw_ismonoidal` is intentionally **unpinned** (stated-but-unformalized):
  there is no Lean declaration realizing the `(J.W).IsMonoidal` instance or the
  `LocalizedMonoidal` `MonoidalCategory (SheafOfModules X.ringCatSheaf)` yet. If a
  prover/scaffolder produces those decls, `lem:jw_ismonoidal` should get a
  `\lean{}` pin (e.g. the `J.W.IsMonoidal` instance + the localized monoidal
  instance), and the vestigial `IsLocallyTrivial` hypotheses on
  `tensorObj_assoc_iso` can then be dropped from the Lean signature.
- The chapter now declares `isLocallyInjective_whiskerLeft_of_W` (a `sorry`) as
  THE single remaining open obligation for the whole group-law engine, with the
  two Mathlib-absent ingredients d.1/d.2 named — this is the natural next prover
  target, requiring a `PresheafOfModules`-level stalk/point port that Mathlib does
  not yet have.

## Strategy-modifying findings
None. The pivot is an API-realization change at the altitude the strategy already
anticipated (route (e)); the substrate definition `def:scheme_modules_tensorobj`
is unchanged and the consumer chain is unaffected.
