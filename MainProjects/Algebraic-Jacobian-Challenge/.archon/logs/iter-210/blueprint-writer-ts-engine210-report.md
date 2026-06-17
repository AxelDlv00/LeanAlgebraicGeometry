# Blueprint Writer Report

## Slug
ts-engine210

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Revised** `lem:tensorobj_assoc_iso` (statement, ~L531) — re-scoped from
  "arbitrary `M,N,P`" to "`M,N,P` ⊗-invertible (`def:scheme_modules_isinvertible`,
  i.e. locally free of rank one)". Kept the `\lean{...tensorObj_assoc_iso}` target
  name. Added `\uses{def:scheme_modules_isinvertible}` alongside the existing
  `\uses{def:scheme_modules_tensorobj}`. Title changed to "Associator for $\otimes_X$
  on invertible objects". Added an explicit clause that this is an *objectwise*
  existence-of-iso for the three fixed objects — not a natural associator on a
  category — and that it is exactly the datum `lem:tensorobj_isoclass_commgroup`
  consumes (`Nonempty(... ≅ ...)`).
- **Replaced** the proof of `lem:tensorobj_assoc_iso` (~L547) — removed the
  `% NOTE` absorption-iso / `MonoidalClosed` / "Strategy-modifying findings"
  paragraph and the old `sheafification.mapIso(α)` + iterated-tensor-comparison
  argument. New proof is the local-trivialisation glue mirroring
  `lem:tensorobj_preserves_locally_trivial`: pick a common affine cover trivialising
  `M,N,P`; on each affine both bracketings are free rank-one; the module associator
  `Module.TensorProduct.assoc` gives the local iso; transition data are
  `O_X^×`-valued and tensoring is functorial, so the local isos agree on overlaps
  and glue. Closes with the objectwise / no-`MonoidalClosed` / no-absorption-iso /
  no-`restrict_iso` emphasis.
- **Revised** `lem:tensorobj_isoclass_commgroup` (statement + proof, ~L859/L922) —
  re-scoped the commutative monoid from "iso-classes of *all* objects (units =
  invertibles)" to "iso-classes of *⊗-invertible* objects, in which every element
  is a unit — i.e. an abelian group = Pic(X)". This removes the implicit claim that
  the associator holds for arbitrary modules (the old framing needed associativity
  on all objects). Added closure (tensor of invertibles is invertible) and the
  inverse-carried-by-predicate clause; kept the Mathlib `Units(Skeleton(...))`
  template analogy and the Stacks SOURCE block untouched; noted the global
  all-objects monoid is deliberately not built. Proof rewritten to discharge the
  group axioms via the invertible-scoped coherence isos on the objects in play.
- **Revised** the "gap" paragraph in the Mathlib API survey (~L146) — the associator
  is no longer described as `sheafification.mapIso`; it is now "obtained by local
  trivialisation on a common affine cover, restricted to the ⊗-invertible objects
  the group law multiplies", while unitors/braiding remain `sheafification.mapIso`.
  Added that neither route uses `pullback`, `MonoidalClosed`, or an absorption iso.
- **Revised** the motivation paragraph (~L93) — same correction: associator obtained
  by local trivialisation (only needed on invertibles), unitors/braiding by
  `sheafification.mapIso`.
- **Revised** `rem:scheme_modules_monoidal_off_path` (~L295) — replaced the stale
  "four existence-of-iso lemmas each assembled from the restriction-compatibility
  isomorphism `lem:tensorobj_restrict_iso`" with the accurate enumeration: associator
  by local trivialisation, unitors/braiding by `sheafification.mapIso`, inverse by
  the predicate; none routes through `restrict_iso`.
- **Revised** the section intro of `sec:tensorobj_onproduct_lift` (~L315) — dropped
  the framing that `restrict_iso` is "the one genuinely-hard ingredient" the four
  facts are assembled from; replaced with the objectwise construction of each fact
  and an explicit "`restrict_iso` is not consumed; optional supplement" note.
- **Revised** the LOC estimate, Piece 2 (`sec:tensorobj_loc_estimates`, ~L1109) —
  the associator is now described as a cheap local-trivialisation-glue lemma
  comparable to `lem:tensorobj_preserves_locally_trivial`, needing no absorption iso
  and no `MonoidalClosed`; noted the absorption iso was an artefact of the abandoned
  arbitrary-module associator. Revised the Piece-2 bullet and total (≈45–60 LOC).

## Consumers checked (directive item 5)
- `lem:tensorobj_isoclass_commgroup` — re-scoped to invertibles (see above); now
  coherent with the invertible-scoped associator.
- `lem:tensorobj_lift_onproduct` — already operates on the ⊗-invertible subtype
  (`IsInvertible`); references the units group of `lem:tensorobj_isoclass_commgroup`.
  No arbitrary-associator implication; left unchanged.
- `thm:rel_pic_addcommgroup_via_tensorobj` — operates on line bundles on `C ×_k T`
  (elements of `LineBundle.OnProduct`, all ⊗-invertible), so its use of
  `assoc_iso`/`unit_iso`/`comm_iso` is on invertible objects and remains valid. Left
  unchanged.

## Out-of-scope items confirmed untouched
- `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso` — unchanged (still the cheap
  `sheafification.mapIso` pattern; still stated for arbitrary modules, which is
  correct and intended).
- `def:scheme_modules_tensorobj`, `def:scheme_modules_isinvertible`,
  `lem:tensorobj_restrict_iso`, `lem:restrictscalars_laxmonoidal` — unchanged.
- No `MonoidalCategory` / `J.W.IsMonoidal` framing introduced.
- No `\leanok` / `\mathlibok` markers added or removed.

## Cross-references introduced
- `\uses{def:scheme_modules_isinvertible}` added to `lem:tensorobj_assoc_iso`
  (statement and proof) — `def:scheme_modules_isinvertible` exists in this same
  chapter (~L794).
- Prose `\cref{lem:tensorobj_isoclass_commgroup}` added in the associator statement —
  exists in this chapter.

## References consulted
- `analogies/ts-assoc-gate210.md` — the consult authorizing the local-trivialisation
  realization. NOTE: this file (4239 bytes on disk) could not be displayed in this
  session — every `Read`/`cat`/`base64` of it (and of a `/tmp` copy) returned blank
  output, while `stat` confirmed it exists and `find` located it. I relied on the
  directive's verbatim reproduction of its conclusion (associator on invertibles
  buildable by local trivialization; NO `MonoidalClosed`, NO sheafification
  absorption iso). As a project-internal `analogies/` note (not a `references/`
  source) it carries no verbatim-quote obligation, and no citation block in the
  chapter depends on it.
- No `references/` files were opened: all edits revise existing prose/proofs; the
  one new Lean name cited in prose (`Module.TensorProduct.assoc`) is a Mathlib target
  named in prose only, per directive ("no external quote needed").

## Macros needed
- None. All commands used (`\Scheme`, `\otimes_X`, `\mathtt`, `\cref`, `\MonoidalCategory`,
  `\Pic`) already appear in the chapter.

## Notes for Plan Agent
- The re-scope of `lem:tensorobj_isoclass_commgroup` from a CommMonoid-on-all-objects
  to a CommGroup-on-invertibles is the deeper structural consequence of the associator
  change: a Lean `CommMonoid` instance on *all* iso-classes is not provable from an
  invertible-only associator, so the chapter now builds the group directly on the
  ⊗-invertible iso-classes (every element a unit). The `\lean{...tensorObjIsoclassCommMonoid}`
  target name was kept, but the structure it should carry is effectively a `CommGroup`
  on the invertible subtype (or a `CommMonoid` on that subtype in which every element
  is a unit). Consider whether the Lean scaffolder should retarget/rename this
  declaration to a `CommGroup` on `{ M // IsInvertible M }`-iso-classes to match.
- `thm:rel_pic_addcommgroup_via_tensorobj`'s proof phrase "the units group of the
  commutative monoid of ⊗-iso-classes (`lem:tensorobj_isoclass_commgroup`)" is still
  literally correct (the group equals its own units group, all elements being
  invertible) but is now slightly redundant; not changed to avoid scope creep.

## Strategy-modifying findings
None. This round *removed* the previous strategy-modifying flag (the
`MonoidalClosed`/absorption-iso wall), which applied only to the now-abandoned
arbitrary-module associator. The chapter no longer claims an arbitrary-module
associator and is internally consistent: every coherence iso the group law consumes
is an objectwise existence-of-iso on invertible objects.
