# Blueprint Writer Report

## Slug
tspivot209b

## Status
COMPLETE — with one **Strategy-modifying finding** (see last section): the
associator coherence iso is NOT the cheap ~15-LOC pattern the directive assumed.

## Target chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Important context: the chapter was concurrently edited during this session
When I first read the chapter it was the old (1148-line) version with the
geometric-local-triviality critical path. While I was preparing the rewrite, the
file was repeatedly modified out from under me by another process (the on-disk
file grew to 1206 then 1303 lines, and `git diff HEAD` was empty at one point) —
some agent applied the bulk of the directive's ⊗-invertibility rewrite in
parallel (IsInvertible predicate, the three coherence-iso blocks, the
monoid/units lemma `lem:tensorobj_isoclass_commgroup`, demoted off-path
`tensorObj_restrict_iso` / `exists_tensorObj_inverse`, rewritten motivation +
API-survey "gap"). I therefore did **not** do a full overwrite (it would have
clobbered that work and lost concurrent improvements). Instead I completed the
items the concurrent editor left unfinished or got wrong, by surgical edits.
**Flag for plan agent:** confirm only one writer was assigned to this chapter —
concurrent edits to one `.tex` are a race hazard.

## Changes Made (my surgical edits)
- **Filled the `IsInvertible` citation** (`def:scheme_modules_isinvertible`):
  the block had a placeholder `% SOURCE: [Stacks], Tag 01HK ... (verbatim text
  not yet retrieved)`. **The tag was wrong** (01HK is "closed immersion of
  locally ringed spaces", nothing to do with invertibility). Replaced with the
  verbatim Stacks **Tag 01CR** text — Definition 01CS (`definition-invertible`)
  + Lemma 0B8K (`lemma-invertible`, the `∃N, L⊗N≅𝒪` characterisation) — copied
  character-for-character from `references/stacks-modules.tex` L4046–L4079, plus
  a visible `\textit{Source: …}` line.
- **Filled the Picard-group / monoid citation** (`lem:tensorobj_isoclass_commgroup`):
  placeholder `% SOURCE: [Stacks], Tag 01CR ... (verbatim text not yet
  retrieved)` replaced with the verbatim **Tag 01CR** text — Definition 01CX
  (`definition-pic`, "Picard group = abelian group of iso-classes under ⊗") +
  Lemma `lemma-constructions-invertible` (⊗ of invertibles is invertible; dual
  is a tensor inverse) — from `references/stacks-modules.tex` L4200–L4213 and
  L4350–L4357, plus a visible `\textit{Source: …}` line.
- **Re-pointed `OnProduct` lift lemma** (`lem:tensorobj_lift_onproduct`,
  directive item 5): the NOTE had already been updated to the IsInvertible
  re-point by the concurrent editor, but the **statement + proof still described
  the `IsLocallyTrivial` subtype** and depended on the off-path
  `exists_tensorObj_inverse`. Re-pointed both to
  `{ M : (pullback πC πT).Modules // IsInvertible M }`, deriving closure from
  `lem:tensorobj_isoclass_commgroup` (units closed under ⊗) and the predicate's
  carried inverse. Updated header + proof `\uses`.
- **Removed the lingering `restrict_iso` cross-refs** on
  `lem:pullback_compatible_with_tensorobj`: its NOTE said "blocked on
  `lem:tensorobj_restrict_iso`" and its proof `\uses`d it. Re-stated as the
  standard pullback–tensor compatibility (Stacks `lemma-tensor-product-pullback`
  / `lemma-pullback-invertible`), not blocked on the open-immersion iso.
- **Aligned the consumer theorem proof `\uses`**
  (`thm:rel_pic_addcommgroup_via_tensorobj`): dropped the off-path
  `lem:tensorobj_inverse_invertible`, added `def:scheme_modules_isinvertible` +
  `lem:tensorobj_isoclass_commgroup` to match the statement and the actual proof
  text (units-of-monoid + QuotientAddGroup, directive item 4).
- **Rewrote the stale internal-consistency section**: it still claimed
  `assoc/unit/comm` use `tensorObj_restrict_iso` and omitted `IsInvertible` and
  `isoclass_commgroup`. Corrected to the actual rewritten dependency graph: the
  coherence isos use only `def:scheme_modules_tensorobj`; the off-path
  supplements are explicitly separated; the engine is `isoclass_commgroup`.
- **Added an honest associator caveat** (`% NOTE` on `lem:tensorobj_assoc_iso`'s
  proof + a sentence in the LOC "Piece 2" estimate): the associator is the one
  coherence iso that is **not** the cheap `sheafification.mapIso` pattern (see
  Strategy-modifying findings).

## Cross-references introduced / corrected
- `lem:tensorobj_lift_onproduct` now `\uses{def:scheme_modules_isinvertible,
  lem:tensorobj_isoclass_commgroup, lem:tensorobj_unit_iso}` (header + proof).
- `lem:pullback_compatible_with_tensorobj` proof `\uses{lem:tensorobj_lift_onproduct}`
  only (dropped `lem:tensorobj_restrict_iso`).
- `thm:rel_pic_addcommgroup_via_tensorobj` proof `\uses` now lists
  `def:scheme_modules_isinvertible` + `lem:tensorobj_isoclass_commgroup`.
- Internal-consistency itemize rewritten to the new graph.
- All `\uses` targets verified to resolve in this chapter,
  `chap:Picard_LineBundlePullback`, or `chap:Picard_RelPicFunctor`. Environments
  balanced (definition 4/4, lemma 13/13, theorem 1/1, remark 1/1, proof 12/12).

## References consulted
- `references/stacks-modules.tex` — verbatim quotes for
  `def:scheme_modules_isinvertible` (Defn 01CS L4046–4059 + Lemma 0B8K
  L4066–4079) and `lem:tensorobj_isoclass_commgroup` (Lemma
  `lemma-constructions-invertible` L4200–4213 + Defn 01CX `definition-pic`
  L4350–4357). Spot-checked verbatim lines against the source.
- `references/kleiman-picard-src/kleiman-picard.tex` — pre-existing Kleiman
  §2 quote (df:aPf/df:Pfs) on the motivation and consumer theorem; also confirmed
  the Picard-group statement at L297–308 ("iso classes of invertible sheaves
  form a group … Picard group").
- `references/summary.md` — reference index (registered `stacks-modules`,
  `stacks-divisors` by my retriever child).

## Reference-retriever dispatches
- slug `stacks-pic-invertible`: requested Stacks tags 01CR (Picard group) +
  01HK (the directive's claimed "invertible modules" tag). Status: **COMPLETE**.
  Downloaded `references/stacks-modules.tex` and `references/stacks-divisors.tex`
  (both verified). **Two directive tag misidentifications corrected by the
  child** (see below). Report:
  `.archon/task_results/reference-retriever-stacks-pic-invertible.md`.

## Notes for Plan Agent
- **The directive's "confirmed on disk" claim was false.** `references/01CR.md`
  and `references/01HK.md` did **not** exist; I dispatched a reference-retriever
  (authorized by the `references/**` write-domain) to fetch the real Stacks TeX.
- **Two directive tag misidentifications** (now corrected in the chapter):
  - Tag **01CR** is in the **Modules on Ringed Spaces** chapter (§17.25
    "Invertible modules"), *not* the Divisors chapter. Its definition is 01CS,
    the `∃N` characterisation is **0B8K**, and the Picard group is **01CX**.
  - Tag **01HK** is *not* about invertible modules at all — it is
    "closed immersion of locally ringed spaces". The directive's instruction to
    "quote 01HK for the IsInvertible predicate" would have produced a wrong
    citation; I used 01CS/0B8K instead.
- The concurrent-editing situation (above) should be resolved before the next
  writer round on this chapter.
- `lem:tensorobj_inverse_invertible` and `lem:tensorobj_preserves_locally_trivial`
  remain as off-path supplements with `\leanok` (green Lean decls). They are no
  longer on the group-law `\uses` chain; left in place per directive (do not
  delete validated helpers).

## Strategy-modifying findings
**The associator coherence iso is NOT the cheap ~15-LOC `sheafification.mapIso`
pattern the directive (item 2) assumed; it relocates — does not eliminate — the
Mathlib gap.**

- `tensorObj M N := sheafification(ptensor(M.val, N.val))`. Hence
  `tensorObj (tensorObj M N) P = sheafification(ptensor(sheafification(ptensor M.val N.val).val, P.val))`
  — the associator nests a sheafification **inside** the presheaf tensor on both
  sides. The unitors and braiding do **not** nest (one factor is the unit, or the
  two sides are the same tensor reordered), so for them the bare
  `sheafification.mapIso(λ/ρ/β)` pattern genuinely works (~15 LOC, as the
  directive says, matching the existing green `tensorObj_unit_iso`).
- To transport the presheaf associator `α`, one additionally needs the
  **sheafification–tensor absorption** iso
  `sheafification(ptensor(sheafification(A).val, B)) ≅ sheafification(ptensor(A,B))`
  (and its mirror): the sheafification unit `η_A` must become an iso after
  whiskering by an arbitrary module `B` and re-sheafifying.
- That is **exactly** the whiskering-stability `W g ⇒ W(F ◁ g)` for arbitrary
  `F` which the chapter's own `rem:scheme_modules_monoidal_off_path` states is
  "provable only through a `MonoidalClosed(PresheafOfModules R)` — absent from
  Mathlib at the pinned commit, and a multi-file build." So the ⊗-invertibility
  pivot removes the `tensorObj_restrict_iso` / `PresheafOfModules.pullback`
  obstruction for the unitors/braiding and the inverse (genuine wins), but the
  **associator still bottoms out in the same absent infrastructure**, because the
  CommMonoid law must hold for *arbitrary* `M,N,P` (it is the monoid on iso-classes
  of ALL of `X.Modules`, units = invertibles, per the directive's
  `CommRing.Pic = Units(Skeleton(ModuleCat R))` template — but `ModuleCat R` has a
  genuine `MonoidalCategory` instance, which `X.Modules` lacks).
- I have written the chapter per the directive's construction (the design is
  sound), with the associator block carrying an explicit `% NOTE` and the LOC
  estimate flagging the absorption iso as the one piece that may need building
  first. **Recommendation:** before pushing a prover at `lem:tensorobj_assoc_iso`
  / the CommMonoid assembly, re-consult the mathlib-analogist on whether the
  absorption iso `sheafification(ptensor(sheafification A, B)) ≅
  sheafification(ptensor(A,B))` is available at `b80f227` as an individual iso
  (e.g. from sheafification being a reflective/⊗-localization) **without** the
  full `MorphismProperty.IsMonoidal W` / `MonoidalClosed` build. If it is not,
  STRATEGY.md should record that the associator (hence the CommMonoid on all
  iso-classes) is a residual gap, and consider building the group law only on the
  invertible (locally-free rank-1) subcategory where local trivialisations may
  give the associator directly.
