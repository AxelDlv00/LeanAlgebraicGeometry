# Blueprint Writer Report

## Slug
tensorobj-substrate-chapter

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

Created a NEW blueprint chapter from scratch and wired it into
`blueprint/src/content.tex`. The chapter records the dedicated
`Scheme.Modules.tensorObj` substrate for A.1.c.SubT and pins the
consumer abelian-group instance that closes the residual sorry at
`AlgebraicJacobian/Picard/RelPicFunctor.lean` L235.

Top-level structure:

- **§1 Motivation** — frames the abelian-group-valued relative Picard
  sheaf as the load-bearing object whose construction the chapter
  unblocks; cites Kleiman §2 (df:aPf + df:Pfs) verbatim from
  `references/kleiman-picard-src/kleiman-picard.tex`, L1274–L1318.
- **§2 Mathlib API survey** — describes what
  `Mathlib.CategoryTheory.Monoidal.PresheafOfModules` ships
  (presheaf-level tensor product) vs. what
  `Mathlib.AlgebraicGeometry.Modules` ships (no monoidal structure on
  `Scheme.Modules`); names the gap and the project's project-side
  policy on it.
- **§3 The substrate** — three project-internal blocks (no SOURCE
  lines, per directive):
  - **`\definition`** `def:scheme_modules_tensorobj` →
    `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` — affine-cover
    gluing of the sectionwise tensor product, equivalently the
    sheafified `PresheafOfModules.Monoidal.tensorObj`.
  - **`\lemma`** `lem:scheme_modules_tensorobj_functoriality` →
    `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` —
    bifunctoriality, associator, left/right unitor, braiding inherited
    from the presheaf-level monoidal structure.
  - **`\theorem`** `thm:scheme_modules_monoidal` →
    `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` — the
    pentagon/triangle/hexagon coherence axioms, packaged as a
    `MonoidalCategory` instance on `Scheme.Modules X`.
- **§4 The lift through `LineBundle.OnProduct`** — four
  project-internal blocks bridging the substrate to the concrete
  consumer carrier:
  - `lem:tensorobj_preserves_locally_trivial`,
  - `lem:tensorobj_inverse_invertible` (the dual `L⁻¹`),
  - `lem:tensorobj_lift_onproduct` (restriction to the
    `LineBundle.OnProduct` subtype),
  - `lem:pullback_compatible_with_tensorobj` (`π_T^*` is strong
    monoidal).
- **§5 Consumer instance** — `thm:rel_pic_addcommgroup_via_tensorobj`
  → `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}`
  packages the abelian-group law on the relative Picard quotient that
  closes the L235 sorry; SOURCE-cited against Kleiman §2 df:aPf +
  df:Pfs verbatim.
- **§6 LOC estimates** — Piece 1 ≈80–120 LOC (definition +
  functoriality), Piece 2 ≈60–100 LOC (monoidal-category instance),
  Piece 3 ≈60–100 LOC (lift + consumer); total ≈200–320 LOC. Lane
  sequencing Piece 1 → Piece 2 → Piece 3, with Piece 3e
  (the consumer instance) the only declaration that lands inside
  `RelPicFunctor.lean`.
- **§7 Out of scope** — explicit exclusions: A.1.c sheafification
  consumers (stay in `Picard_RelPicFunctor.tex`), A.2.c
  representability, A.3 identity component, A.4 Albanese, and any
  Mathlib upstream PR (parallel but not on the critical path).
- **§8 Internal-consistency check** — the
  `\uses{...}` graph closure inside this chapter, plus its
  out-of-chapter leaves in `Picard_LineBundlePullback.tex` (A.1.b) and
  `Picard_RelPicFunctor.tex` (A.1.c).

Wired the new chapter into `blueprint/src/content.tex` immediately
after `Picard_RelPicFunctor`, before `Picard_FlatteningStratification`.

## Cross-references introduced

- `\uses{def:scheme_modules_tensorobj}` in
  `lem:scheme_modules_tensorobj_functoriality` and
  `lem:tensorobj_preserves_locally_trivial`.
- `\uses{def:scheme_modules_tensorobj, lem:scheme_modules_tensorobj_functoriality}`
  in `thm:scheme_modules_monoidal`.
- `\uses{def:scheme_modules_tensorobj, lem:tensorobj_preserves_locally_trivial}`
  in `lem:tensorobj_inverse_invertible`.
- `\uses{lem:tensorobj_preserves_locally_trivial, lem:tensorobj_inverse_invertible}`
  in `lem:tensorobj_lift_onproduct`.
- `\uses{lem:tensorobj_lift_onproduct}` in
  `lem:pullback_compatible_with_tensorobj`.
- `\uses{thm:scheme_modules_monoidal, lem:tensorobj_lift_onproduct,
        lem:pullback_compatible_with_tensorobj,
        thm:relative_pic_quotient_well_defined,
        lem:rel_pic_sharp_groupoid}` in
  `thm:rel_pic_addcommgroup_via_tensorobj`.

External `\uses{...}` leaves (resolved in sibling chapters already on
disk): `thm:relative_pic_quotient_well_defined` (in
`Picard_LineBundlePullback.tex`, A.1.b),
`lem:rel_pic_sharp_groupoid` (in `Picard_RelPicFunctor.tex`, A.1.c),
`def:pullback_along_projection` (in `Picard_LineBundlePullback.tex`,
A.1.b, referenced implicitly in
`lem:pullback_compatible_with_tensorobj` prose).

Cross-references to other chapters by `\cref{chap:...}` (prose only,
not `\uses`): `chap:Picard_RelPicFunctor`,
`chap:Picard_LineBundlePullback`, `chap:Picard_FGAPicRepresentability`,
`chap:Picard_IdentityComponent`, `chap:Albanese_AlbaneseUP`.

## References consulted

- `references/kleiman-picard-src/kleiman-picard.tex` — verbatim quote
  of Kleiman §2 df:aPf (L1274–L1279) and df:Pfs (L1311–L1318), used
  twice in the chapter:
  1. in §1 (motivation paragraph, after the
     "abelian-group-valued" framing prose), as a free-floating
     `% SOURCE: / % SOURCE QUOTE: / \textit{Source: ...}` block, and
  2. in §5 (consumer instance `thm:rel_pic_addcommgroup_via_tensorobj`),
     attached to the theorem block.
  Cross-checked that the label `cor:repsh` that the directive named
  does NOT exist in `kleiman-picard.tex` (`grep` for `cor:repsh` and
  for any `\label{cor:...}` in the file returned no match); the
  authoritative cite for "RelPic is abelian-group-valued" in §2 of
  Kleiman is df:aPf + df:Pfs, which is exactly what the existing
  sibling chapter `Picard_RelPicFunctor.tex` uses. See "Notes for Plan
  Agent" below.
- `references/summary.md` — to confirm which references are present
  locally; cross-referenced against the directive's named sources.
- `references/stacks-coherent.tex` — `grep`ed for tag `03DM` to check
  if a local verbatim quote was available; no local copy of 03DM was
  found, so the chapter cites Stacks 03DM by name only in prose
  (not in a `% SOURCE QUOTE:` block). Stacks tag 01CR is similarly
  cited by name only (since the existing sibling
  `Picard_RelPicFunctor.tex` does the same, the project convention
  is that internally well-known Stacks tags are not chased into a
  local-file SOURCE quote unless the chapter rests on the specific
  statement of the tag).

## Macros needed (if any)

None. All macros used (`\Pic`, `\Sch`, `\Scheme`, `\AddCommGrpCat`,
`\AddCommGroup`, `\MonoidalCategory`, `\Module`, `\op`,
`\presheafToSheaf`, `\struct{...}`, etc.) are already defined in
`blueprint/src/macros/common.tex` (verified by reading that file in
this session).

## Reference-retriever dispatches (if any)

None. The chapter's external citations rest entirely on the Kleiman §2
verbatim quotes that the sibling chapter `Picard_RelPicFunctor.tex`
already pinned (read directly from
`references/kleiman-picard-src/kleiman-picard.tex` in this session).
The chapter's project-internal definitions (the substrate, its
functoriality, the monoidal-category instance, the lift through the
`LineBundle.OnProduct` carrier) stand on their proof sketches alone, per
the directive's allowance.

The directive said the writer could dispatch a `reference-retriever`
to download Mathlib's `Mathlib.CategoryTheory.Monoidal.PresheafOfModules`
source if needed for the API survey. I judged this unnecessary: §2
("Mathlib API survey") describes what the surface exposes
(`PresheafOfModules.Monoidal.tensorObj` at the presheaf level; no
monoidal structure on `Scheme.Modules`) at the level needed to
motivate the project-side substrate. The substrate itself, and the
project's policy on it (project-side, not blocking on a Mathlib PR),
do not depend on the exact internal structure of
`Mathlib.CategoryTheory.Monoidal.PresheafOfModules`; the prover lane
that builds the substrate will read that file directly when it lands
on the corresponding Lean code.

## Notes for Plan Agent

1. **The directive named `cor:repsh` in Kleiman §4 as the cite-and-read
   target.** That label does NOT exist in
   `references/kleiman-picard-src/kleiman-picard.tex` (verified by
   `grep -n 'repsh' kleiman-picard.tex` — no matches; and by listing
   every `\label{cor:...}` and `\label{thm:...}` in the file, none of
   which contain `repsh`). The actual authoritative source for the
   claim "the relative Picard functor is abelian-group-valued" is
   Kleiman §2, Defs df:aPf + df:Pfs (lines 1274–1318), which is
   exactly the source the sibling chapter
   `Picard_RelPicFunctor.tex` already uses, verbatim, in three
   different declaration blocks. I substituted Kleiman §2 df:aPf +
   df:Pfs for the directive's missing `cor:repsh` and used the same
   verbatim quote the sibling chapter uses, in the two places this
   chapter needs an external citation (§1 motivation paragraph and §5
   consumer-instance theorem block). The substitution is semantically
   correct (the abelian-group-valued claim is a defining property in
   Kleiman §2, not a corollary of §4), and is recorded here so the
   next planner can correct the directive template for future
   iterations if needed.

2. **No `archon:covers` line.** The chapter is forward-looking: the
   Lean target file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
   does not yet exist (it will be scaffolded by the iter-201+ prover
   lane), and the consumer declaration
   `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj`
   lives back in `RelPicFunctor.lean` (already covered by
   `Picard_RelPicFunctor.tex`). I omitted the `% archon:covers ...`
   line to avoid a doctor warning about a non-existent file. Once
   `TensorObjSubstrate.lean` lands, the planner may want to add
   `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
   to gate that file's prover on this chapter.

3. **Lean pins for declarations whose Lean targets do not yet
   exist.** Per the directive, I pinned three forward-looking Lean
   target names:
   - `AlgebraicGeometry.Scheme.Modules.tensorObj`
   - `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality`
   - `AlgebraicGeometry.Scheme.Modules.monoidalCategory`
   plus the consumer
   - `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj`.
   The first three names follow the existing
   `AlgebraicGeometry.Scheme.Modules` namespace convention used in
   `AlgebraicGeometry/Picard/LineBundlePullback.lean` (for
   `pullback`, `pullbackComp`, `pullbackCongr`). The consumer name
   uses the existing `AlgebraicGeometry.Scheme.PicSharp` namespace
   used in `AlgebraicGeometry/Picard/RelPicFunctor.lean`. The
   deterministic `sync_leanok` phase will leave these unmarked until
   the corresponding Lean declarations exist; that is the intended
   behaviour for a forward-looking chapter.

4. **No `\leanok` or `\mathlibok` markers**, per descriptor rule.

## Strategy-modifying findings

None. The chapter records the substrate the iter-200 plan-agent
committed to: project-side, ~200–400 LOC, three-lane sequencing
Piece 1 → Piece 2 → Piece 3. None of the mathematical content
challenges the strategy; the substrate is exactly what the iter-199
progress-critic verdict (STUCK + OVER BUDGET) called for as the
corrective on Lane RPF.
