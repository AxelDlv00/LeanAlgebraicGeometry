# blueprint-writer directive — tensorobj229

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Strategy context (the slice that matters)

The active route builds the ⊗-inverse of a by-hand `CommGroup` on locally-trivial
𝒪_X-module iso-classes (for `Pic X`). Two independent Mathlib-analogist consults this iter
(reports at `.archon/task_results/mathlib-analogist-ts229slice.md` and
`.archon/task_results/mathlib-analogist-ts229glue.md` — READ BOTH before editing) reached a
**convergent reframe** that this chapter must now reflect:

- The C-bridge `lem:dual_isLocallyTrivial` and the A-engine `lem:sheafofmodules_hom_of_local_compat`
  are blocked on the **SAME** Mathlib-absent root: the **open-immersion ↔ slice sheaf-site
  equivalence**. This is a *named, documented Mathlib TODO* at
  `Mathlib/Topology/Sheaves/Over.lean` (lines 19-22): show that `overEquivalence U : Over U ≌
  Opens ↥U` is continuous and induces a sheaf equivalence
  `Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology U) A`.
- The iter-228 "verbatim mirror of the closed tensor restrict-iso" sketch for
  `lem:dual_isLocallyTrivial` is **WRONG past Step 3 / H1** (empirically falsified via
  `lean_goal`): the dual is the SLICE internal-hom, not a sectionwise `restrictScalars`-image, so
  `restrictScalarsRingIsoDualEquiv` does NOT discharge the residual.
- The construction is tractable because `Opens X` is a **thin poset**: the `Over.map` /
  `Over.mapComp` coherence squares commute automatically by `Subsingleton.elim` /
  `Subsingleton.helim`. The genuine residual is the named continuity TODO, dischargeable via
  `Functor.IsDenseSubsite.sheafEquiv` (`Mathlib/CategoryTheory/Sites/DenseSubsite/Basic.lean`)
  + the `Sites/Over.lean` continuity/cocontinuity instances. Estimated ~200–350 LOC; an
  upstream-PR candidate (it completes a documented Mathlib TODO).

## Required edits (5)

### Edit 1 — ADD a new lemma block for the shared slice-site sheaf equivalence (THE iter-229 prover target)

Add a new `\begin{lemma}` block (place it just BEFORE `lem:dual_isLocallyTrivial`, ~L2780, so it
reads as the shared foundation both the dual restrict-iso and the A-engine consume). Suggested:

- `\label{lem:open_immersion_slice_sheaf_equiv}`
- `\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}` (forward pin — declaration not yet
  formalized; this is the iter-229 prover target. Mark NOTHING `\leanok` — the sync phase owns that.)
- `\uses{}` — none required (it is foundational; it rests on Mathlib `Opens.overEquivalence`,
  `Sites/Over.lean`, `Sites/DenseSubsite`).
- Statement prose: for a scheme `X` and an open `U ⊆ X` (open immersion `(U).ι : U ↪ X`), the
  reindexing `overEquivalence U : Over U ≌ Opens ↥U` upgrades to an **equivalence of sheaf
  categories** `Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology
  U) A`, compatible with module-pullback / `restrictFunctorIsoPullback`. State that this is the
  completion of the Mathlib TODO `Topology/Sheaves/Over.lean:19-22`, and that it is the shared root
  underlying BOTH the dual restrict-iso (`lem:dual_isLocallyTrivial`) and the A-engine morphism
  descent (`lem:sheafofmodules_hom_of_local_compat`).
- Proof sketch (mathematical, NOT Lean tactics): `overEquivalence U` is a dense subsite inclusion;
  apply `Functor.IsDenseSubsite.sheafEquiv` to lift it to a sheaf equivalence; the continuity /
  cover-lifting hypotheses come from the `Sites/Over.lean` instances; because `Opens X` is a thin
  poset (subsingleton hom-sets), the over-category coherence (`Over.mapId`, `Over.mapComp`,
  `overMapPullback_assoc`) is automatic by `Subsingleton.elim`. The down-set identification
  `U.isOpenEmbedding.functor.obj ((Opens.map U.inclusion').obj V) = V` for `V ≤ U`
  (`Mathlib/.../TopCat/Opens.lean`) is the sectionwise content.
- This block is project-bespoke infrastructure built on Mathlib (a TODO completion); NO external
  mathematical `% SOURCE:` quote is required. You MAY add a `% SOURCE:` comment naming the Mathlib
  TODO location `Mathlib/Topology/Sheaves/Over.lean:19-22` as the provenance.

### Edit 2 — REWRITE the proof body of `lem:dual_isLocallyTrivial` (~L2822-2877)

The current proof body claims a "verbatim mirror" that closes via `restrictScalarsRingIsoDualEquiv`.
Replace the body with the CORRECT route: Steps 1–3 + H1 mirror the closed tensor restrict-iso
(these DO typecheck), but the residual after H1, `(pushforward β)(dual A) ≅ dual((pushforward β) A)`,
is **NOT** discharged by `restrictScalarsRingIsoDualEquiv` (the dual is the slice internal-hom). It
is discharged by the shared slice-site sheaf equivalence `lem:open_immersion_slice_sheaf_equiv`
(Edit 1): under that equivalence the slice internal-hom over `Over V` (in `Opens X`) corresponds to
the one over `Opens ↥U`, and the comparison is the poset-thin reindexing. Update the `\uses{}` of
both the lemma statement and the proof to include `lem:open_immersion_slice_sheaf_equiv` and DROP
the now-incorrect reliance framing on `lem:restrictscalars_ringiso_dualequiv` (keep it only if it
genuinely appears as the ModuleCat-level shadow; the report says it is NOT the discharging step).
Keep the existing `% NOTE (iter-228 …)` (it is accurate) but update its closing line from "The
writer must correct Steps/H2′ before this lemma is re-dispatched" to reflect that the correction is
now done and the discharging step is `lem:open_immersion_slice_sheaf_equiv`. Preserve the Stacks
01CR `% SOURCE:` / `% SOURCE QUOTE:` block verbatim.

### Edit 3 — REFINE the proof sketch of `lem:sheafofmodules_hom_of_local_compat` (~L2936+)

Add to the proof sketch that the load-bearing `localSection` naturality is the **section-direction
slice of the same comparison** as `lem:open_immersion_slice_sheaf_equiv` (Edit 1), and that the
gluing assembly uses the Mathlib engine confirmed by analogist ts229glue:
`presheafHom (M.val.presheaf) (N.val.presheaf)` is a sheaf via `Presheaf.IsSheaf.hom`; glue local
sections over the cover via `TopCat.Sheaf.existsUnique_gluing`; convert the glued ⊤-section to a
global morphism via `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` (NOT a hand ⊤-unfold);
re-attach 𝒪_X-linearity via the built `homMk` (`def:scheme_modules_homMk`). Add
`lem:open_immersion_slice_sheaf_equiv` to its `\uses{}`. Note the analogist's revised size (~80–150
LOC on top of the gluing assembly; the old ~120–190 total holds only if the slice transport is
clean) — but keep size language qualitative, not a hard LOC number, in the visible prose.

### Edit 4 — ADD blueprint blocks + `\lean{}` pins for the 3 iter-228 dual-iso helpers (lvb ts228 majors #1-3)

Add three small `\begin{lemma}`/`\begin{definition}` blocks (place them near the existing dual
infrastructure, before `lem:dual_isLocallyTrivial`):
- `\lean{PresheafOfModules.dualPrecompEquiv}` — "precomposition `R(U)`-linear equivalence on dual
  sections induced by a presheaf-of-modules isomorphism `e : M ≅ M'`; the section-level core of the
  presheaf dual's contravariant functoriality in isomorphisms."
- `\lean{PresheafOfModules.dualIsoOfIso}` — "an iso `e : M ≅ M'` induces `dual M' ≅ dual M`,
  assembled sectionwise from `dualPrecompEquiv`."
- `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` — "an iso `e : M ≅ M'` in `X.Modules`
  induces `dual M' ≅ dual M`, by sheafifying the presheaf `dualIsoOfIso`; the dual analogue of
  `tensorObjIsoOfIso`." These are project-bespoke (no external source). Do NOT add `\leanok`.

### Edit 5 — (informational alignment, only if quick) the vestigial eval-route `\uses`

If `lem:tensorobj_inverse_invertible`'s proof body still cites `lem:internal_hom_eval` (the excised
eval route), you MAY drop that vestigial `\uses`. Non-blocking; skip if it risks touching unrelated
prose.

## Out of scope (do NOT touch)
- Do NOT add/remove `\leanok` or `\mathlibok` anywhere (the sync phase / review own those).
- Do NOT touch the HELD/paused chapters or any other chapter file.
- Do NOT edit the closed-lemma blocks (`lem:tensorobj_restrict_iso`, `lem:isiso_of_isiso_restrict`,
  `def:scheme_modules_homMk`, `lem:restrictscalars_ringiso_dualequiv`) beyond `\uses{}` adjustments
  that Edits 2/3 require.
- Do NOT invent external citations. The shared-bridge block stands on its construction sketch + the
  Mathlib-TODO provenance pointer; no fabricated `% SOURCE QUOTE:`.

## References you may need
You have `references/**` in your write-domain so you can spawn a reference-retriever if needed, but
this iter's edits are formalization-engineering (Mathlib infrastructure) + a re-stated Stacks 01CR
quote already present — you likely need NO new sources.
