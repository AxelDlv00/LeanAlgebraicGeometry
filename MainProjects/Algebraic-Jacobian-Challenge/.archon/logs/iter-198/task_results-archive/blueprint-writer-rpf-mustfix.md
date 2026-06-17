# Blueprint Writer Report

## Slug
rpf-mustfix

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_RelPicFunctor.tex

## Changes Made

- **Revised** `thm:rel_pic_etale_sheaf_group_structure` — added the
  missing `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure}`
  pin (clearing the iter-198 HARD GATE DEFER: the 6th of 6 prover-gate
  sorries now has both a declaration name and a referenced proof
  sketch). Extended the verbatim `% SOURCE QUOTE:` block to include
  the associated-sheaf paragraph (Kleiman L1320--L1328), bridging
  Kleiman's df:Pfs to the universal-property characterisation of the
  étale sheafification, and updated the `\textit{Source: ...}` prose
  line accordingly.

- **Revised** Lean-encoding bullet for
  `AlgebraicGeometry.Scheme.PicSharp.etSheaf` — replaced the stale
  "Verification flag" with **Verification flag (resolved, iter-198)**,
  now naming the confirmed Mathlib APIs:
    - `AlgebraicGeometry.Scheme.etaleTopology`
      (`Mathlib.AlgebraicGeometry.Sites.Etale`) — big étale
      Grothendieck topology on `Scheme`.
    - `CategoryTheory.presheafToSheaf`
      (`Mathlib.CategoryTheory.Sites.Sheafification`) — sheafification
      entry point with abelian-group target under a `HasWeakSheafify`
      instance.
    - Fallback chain: `CategoryTheory.GrothendieckTopology.sheafify` +
      `plusPlusSheaf` (in
      `Mathlib.CategoryTheory.Sites.ConcreteSheafification`) for the
      set-valued plus-construction transported back via the
      `ConcreteCategory` instance on `AddCommGrpCat`.
  Also documents that the slice `(Sch/k)` is captured on the Lean side
  via `Over (Spec k)` + Mathlib's `CategoryTheory.Sites.Over`
  / `GrothendieckTopology` pullback construction.

- **Added** Lean-encoding bullet for
  `AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure` —
  proof-sketch identifies `etSheaf` (set-valued plus-construction)
  with `presheafToSheaf etaleTopology AddCommGrpCat PicSharp.presheaf`
  through `GrothendieckTopology.sheafification_obj` and the
  ConcreteCategory forgetful functor's preservation of the
  multiequalizer / filtered-colimit data feeding `plusPlusSheaf`.

- **Added** `\paragraph{Gate annotation (iter-198 refresh).}` —
  replaces the stale 10-iter-old `LineBundle.OnProduct` gate
  annotation with the correct residual gate:
    1. The `LineBundle.OnProduct` typed sorry was closed in
       `LineBundlePullback.lean` during iter-188 (subtype
       concretisation; `pullbackAlongProjection` /
       `pullback_pullback_eq` filled axiom-cleanly).
    2. The genuine residual gate is the abelian-group instance on
       `Quotient (preimage_subgroup πC πT)` at
       `RelPicFunctor.lean` L205--L235 (the `addCommGroup` scaffold).
    3. That gate reduces to a tensor-product `AddCommGroup`
       structure on `LineBundle.OnProduct`, which depends on the
       monoidal-category structure on `Scheme.Modules` — the explicit
       gap flagged at `LineBundlePullback.lean` L344--L346 (the
       `Scheme.Modules` monoidal-structure gap at Mathlib b80f227,
       which ships only `PresheafOfModules.Monoidal.tensorObj`).
    4. The five other prover-gate sorries at L287--L482 (`PicSharp`,
       `PicSharp.functorial`, `PicSharp.presheaf`, `PicSharp.etSheaf`,
       `PicSharp.etSheaf_group_structure`) close axiom-cleanly modulo
       the file-local `addCommGroup` instance; once it lands, the
       file collapses from 6 sorries to 1, and the surviving sorry is
       an upstream Mathlib-build-mode task (not an A.1.c
       mathematical gap).

- **Revised** internal-consistency-check intro line — "five declaration
  blocks" → "six declaration blocks" (the bullet list already
  enumerated six items, including
  `thm:rel_pic_etale_sheaf_group_structure`; the intro count was
  stale).

## Cross-references introduced

No new `\uses{...}` directives. The new prose references
`\cref{thm:rel_pic_etale_sheaf_group_structure}` (already declared in
this chapter) and refers to file paths inside
`AlgebraicJacobian/Picard/` by name in text only (not as `\uses`
targets, since `.lean` files are not blueprint nodes).

## References consulted

- `references/kleiman-picard-src/kleiman-picard.tex` (L1281--L1340) —
  verified the verbatim text of Kleiman §2's `df:Pfs` definition, the
  associated-sheaf paragraph immediately following (L1320--L1328), and
  the surrounding motivation (L1281--L1304) explaining why
  `Pic_{X/S}` is never a separated Zariski presheaf and therefore must
  be replaced by its étale-sheaf associate
  `Pic_{(X/S)\et}`. Used to extend the `% SOURCE QUOTE:` block of the
  theorem to span both halves of Kleiman's df:Pfs ecosystem.

No new reference-retriever dispatches were needed; the
`kleiman-picard-src` directory already contains the relevant verbatim
material at the cited line range, and the Mathlib API names were
confirmed live via `lean_leansearch` (no external citation required
for in-Mathlib declaration pointers, which are recorded in `% Lean:`
prose comments per directive).

## Mathlib API confirmation (via `lean_leansearch`)

- `AlgebraicGeometry.Scheme.etaleTopology`
  : `CategoryTheory.GrothendieckTopology AlgebraicGeometry.Scheme`
  — `abbrev` in `Mathlib.AlgebraicGeometry.Sites.Etale`, generated by
  `Scheme.etalePretopology`. ✓ confirmed.
- `AlgebraicGeometry.Scheme.smallEtaleTopology`
  : `(X : Scheme) → CategoryTheory.GrothendieckTopology X.Etale`
  — the small étale site (per-object), not what we want for the
  global relative Picard functor. Documented for completeness.
- `CategoryTheory.GrothendieckTopology.sheafification`
  : `(J : GrothendieckTopology C) → (D : Type) → [HasMultiequalizer]
     → [HasColimitsOfShape (J.Cover X)ᵒᵖ D]
     → Functor (Cᵒᵖ ⥤ D) (Sheaf J D)`
  — concrete plus-construction (in
  `Mathlib.CategoryTheory.Sites.ConcreteSheafification`).
- `CategoryTheory.GrothendieckTopology.sheafify`
  : `(J : GrothendieckTopology C) → (Cᵒᵖ ⥤ D) → (Cᵒᵖ ⥤ D)`
  — underlying presheaf-level version.
- `CategoryTheory.presheafToSheaf`
  : `(J : GrothendieckTopology C) → (A : Type) → [HasWeakSheafify J A]
     → Functor (Cᵒᵖ ⥤ A) (Sheaf J A)`
  — abstract sheafification, valid under a `HasWeakSheafify` instance
  (in `Mathlib.CategoryTheory.Sites.Sheafification`). This is the
  preferred entry point for the A.1.c chapter once
  `HasWeakSheafify Scheme.etaleTopology AddCommGrpCat` is available.
- `CategoryTheory.GrothendieckTopology.sheafification_obj`
  : `J.sheafification D ▸ obj P = J.sheafify P`
  — the bridge lemma identifying the concrete plus-construction with
  the abstract sheafification, used in the proof sketch for
  `etSheaf_group_structure`.
- `AddCommGrpCat`
  — category of abelian groups, `Type (u+1)` (in
  `Mathlib.Algebra.Category.Grp.Basic`), with
  `hasColimitsOfShape J AddCommGrpCat` for any small `J` (in
  `Mathlib.Algebra.Category.Grp.Colimits`), satisfying the
  filtered-colimit requirement of the plus-construction.

## Macros needed (if any)

None. Existing chapter macros (`\Pic`, `\AddCommGroup`, `\Sch`,
`\Spec`, `\et`, etc.) already cover the new prose.

## Reference-retriever dispatches (if any)

None.

## Notes for Plan Agent

- **Mathlib `HasWeakSheafify` instance for big-étale + AddCommGrpCat.**
  The chapter now names the precise Mathlib API names but does not
  unilaterally assert that
  `HasWeakSheafify Scheme.etaleTopology AddCommGrpCat` is registered
  at the project's pinned Mathlib commit (b80f227). The fallback path
  is documented (concrete `sheafify` + `plusPlusSheaf` via the
  `ConcreteCategory` instance, since `AddCommGrpCat` is a
  `ConcreteCategory` with `forget` preserving the relevant filtered
  colimits and multiequalizers). The prover for `RelPicFunctor.lean`
  should test the abstract path first and fall back to the concrete
  one if the `HasWeakSheafify` instance is missing; if missing, the
  Mathlib-build-mode follow-up is the natural place to add it.

- **Slice-vs-absolute site.** The chapter's prose throughout uses
  `(Sch/k)^{op}` (Kleiman's convention with `S = Spec k`); Mathlib's
  `etaleTopology` is the absolute big étale site on `Scheme`. The
  chapter now documents (in the new etSheaf bullet) that the slice
  is captured via `Over (Spec k)` + `CategoryTheory.Sites.Over`. If
  the prover discovers that the slice formulation requires the
  `GrothendieckTopology.over` construction to be wired specifically
  for the étale pretopology (not just the abstract topology), that
  may be a small additional Mathlib-build-mode item — but the
  mathematical content (sheafification preserves the abelian-group
  target on any Grothendieck site under `HasWeakSheafify`) is
  unaffected.

- **No re-architecture.** Per the directive's out-of-scope rules, no
  re-architecture of the carrier abstraction was proposed and no
  other chapter / `.lean` file was touched.

## Strategy-modifying findings

None. The chapter accurately reflects Kleiman §2 + §3 and the
project's iter-188+ state of `LineBundlePullback.lean`; the gate
annotation update is a refresh of stale prose, not a strategic
re-route. The residual gate (tensor-product `AddCommGroup` on
`LineBundle.OnProduct` reducing to the `Scheme.Modules`
monoidal-structure Mathlib gap) is consistent with the existing
A.1.c strategy and with the iter-197 progress-critic finding.
