# Blueprint-writer directive — slug `gate065`

## Chapter to edit (ONLY this one)
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter;
`% archon:covers` includes both `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`).

## Why you are being dispatched
The iter-064 per-file Lean↔blueprint check found ONE blueprint-adequacy must-fix that gates the next
prover round on `CechSectionIdentification.lean`, plus coverage debt and stale annotations. Your job is
to close those gaps so the prover has a faithful, sufficiently-detailed chapter. Do NOT touch any
mathematical content that is already correct; these are targeted additions/expansions only.

Strategy context (the slice that matters): both routes in this chapter are CONVERGING on a single
keystone leaf each. The prover next iter does a targeted single-leaf dispatch. The chapter must (a) give
the reindexing induction leaf a real proof, (b) name its load-bearing framing definitions, and (c) be
honest about which declarations now exist.

---

## TASK 1 (MUST-FIX, gates the CSI lane) — dedicated lemma block for `coprodToProd_isIso_of_equiv`

Currently the "Reindexing" step of `lem:pushPull_coprod_prod`'s proof is a single sentence
(chapter lines ~8374–8376: "the canonical product and coproduct framings transport along the
reindexing isomorphisms of products and coproducts while preserving the canonical form"). That is too
thin to formalize — the corresponding Lean declaration `AlgebraicGeometry.coprodToProd_isIso_of_equiv`
is a full `sorry` precisely because of this.

Add a **dedicated `\begin{lemma}...\end{lemma}` + `\begin{proof}...\end{proof}` block** for it,
placed just BEFORE `lem:pushPull_coprod_prod` (since that lemma's induction consumes it). Use:

- `\label{lem:coprodToProd_isIso_of_equiv}`
- `\lean{AlgebraicGeometry.coprodToProd_isIso_of_equiv}`
- `\uses{def:push_pull_obj, lem:pushPullObjCongr}` (plus any of the def blocks you add in Task 2)

Statement (project notation): given an equivalence `e : α ≃ β` of finite index types and a family
`legs : β → Over X`, IF the canonical comparison map `coprodToProdMap F (legs ∘ e)` is an isomorphism
(the induction hypothesis on `α`), THEN `coprodToProdMap F legs` is an isomorphism. I.e. the
`IsIso (coprodToProdMap F ·)` predicate is stable under reindexing the leg family along an index
equivalence.

Proof (the exact route, confirmed by the iter-064 prover's in-file strategy and the lvb checker — write
it as rigorous prose, NO Lean tactics):
- Transport the SOURCE: the coproduct reindexing `Sigma.whiskerEquiv e (fun _ ↦ Iso.refl _)` composed
  with the descent-object identification gives a slice isomorphism
  `Over.mk (Sigma.desc (legs ·).hom) ≅ Over.mk (Sigma.desc ((legs∘e) ·).hom)` in `Over X`; carry the
  push–pull object across it with `pushPullObjCongr` (Lemma~\ref{lem:pushPullObjCongr}).
- Transport the TARGET: the product reindexing `Pi.whiskerEquiv e (fun _ ↦ Iso.refl _)` (equivalently
  `Limits.Pi.mapIso` along `e`) identifies `∏_β pushPullObj F (legs ·)` with
  `∏_α pushPullObj F ((legs∘e) ·)`.
- Identify `coprodToProdMap F legs` with the conjugate of `coprodToProdMap F (legs∘e)` by these two
  reindexing isomorphisms, by checking each `Pi.π` projection: use `coprodToProdMap_comp_π`
  (the projection law `coprodToProdMap F legs ≫ Pi.π _ i = pushPullMap F (coprodOverIncl …)`) and the
  naturality of `pushPullMap` under the reindexing of the coproduct inclusions. Since the conjugate of
  an isomorphism is an isomorphism, the IH gives `IsIso (coprodToProdMap F legs)`.

Keep it faithful to what the Lean proof must do; the point is that a prover reading ONLY this block can
formalize the leaf without re-inventing the framing.

ALSO: in `lem:pushPull_coprod_prod`'s proof, REPLACE the one-sentence "Reindexing" paragraph
(lines ~8374–8376) with a one-line pointer: "the property is stable under index equivalence by
Lemma~\ref{lem:coprodToProd_isIso_of_equiv}", and add `lem:coprodToProd_isIso_of_equiv` to that lemma's
`\uses{}` (both statement and proof `\uses`).

---

## TASK 2 (coverage debt) — name the load-bearing framing definitions

Two project-bespoke definitions carry the entire induction but have no blueprint block, so they are
isolated nodes in the dependency graph:

- `AlgebraicGeometry.coprodOverIncl` — the canonical `i`-th coproduct inclusion viewed as a morphism in
  `Over X` into `Over.mk (Sigma.desc (legs ·).hom)`.
- `AlgebraicGeometry.coprodToProdMap` — the canonical comparison map
  `pushPullObj F (Over.mk (Sigma.desc (legs ·).hom)) ⟶ ∏_i pushPullObj F (legs i)`, defined as the
  `Pi.lift` whose `i`-th component is `pushPullMap F (coprodOverIncl … i)`.

Add a short `\begin{definition}...\end{definition}` block for each (these are Archon-original, so NO
`% SOURCE` lines), with `\label{def:coprodOverIncl}` / `\label{def:coprodToProdMap}` and the matching
`\lean{}`. Then add `def:coprodOverIncl, def:coprodToProdMap` to the `\uses{}` of
`lem:pushPull_coprod_prod`, `lem:coprodToProd_isIso_of_equiv`, and (statement+proof) wherever the
"canonical product of push–pull maps" framing is referenced.

ALSO add a brief `\begin{lemma}` block (statement + one-line proof) for the now-CLOSED Option-adjoining
leaf `AlgebraicGeometry.coprodToProd_isIso_option` with `\label{lem:coprodToProd_isIso_option}`,
`\lean{AlgebraicGeometry.coprodToProd_isIso_option}`, and
`\uses{lem:pushPull_binary_coprod_prod, lem:over_sigmaOptionIso, lem:piOptionIso, lem:pushPullObjCongr}`.
One-line informal proof: the `Option α` coproduct splits binary (`over_sigmaOptionIso`), apply the binary
decomposition + IH on the `some`-part, reassemble via `piOptionIso` (inverse), and a per-`Option`-case
projection chase matches the canonical form. Wire it into `lem:pushPull_coprod_prod`'s `\uses{}`.

The small private projection/coherence helpers (`coprodToProdMap_comp_π`, `pushPullObjCongr_hom`,
`pushPull_binary_coprod_prod_hom`, `piOptionIso_inv_π_none`, `piOptionIso_inv_π_some`,
`isIso_coprodToProdMap`) do NOT each need their own block — bundle their Lean names into the `\lean{}`
list of the most closely related parent lemma (e.g. fold `coprodToProdMap_comp_π` and
`isIso_coprodToProdMap` into `lem:pushPull_coprod_prod`'s `\lean{}`; fold the `_hom`/`_inv_π_*` helpers
into `lem:coprodToProd_isIso_option`'s `\lean{}`) so the graph sees them.

---

## TASK 3 (proof-text alignment) — `lem:pushPull_coprod_prod_empty`

The Lean proof of `pushPull_coprod_prod_empty` does NOT follow the current blueprint text (which argues
"zero sections over every V" via `isIso_modules_of_toPresheaf`). The Lean route instead: both sides are
terminal — it reduces (via `Functor.map_isZero` for the additive pushforward, since pushforward preserves
zero objects) to showing `IsZero ((Scheme.Modules.pullback q).obj F)` where `q : ∐ PEmpty → X` is the
unique map out of the initial (empty) scheme, then concludes by `IsZero.isTerminal`.

Update the proof prose to match this route: state that the coproduct over the empty index is the initial
scheme `⊥`; that every sheaf of modules over the empty scheme is the zero object (its only open is empty,
so all sections are the zero module — the structure sheaf has subsingleton sections over the empty
scheme); hence the pulled-back module `(pullback q).obj F` is zero, the additive pushforward sends it to
a zero (hence terminal) object, and the empty product is likewise terminal, so the comparison is an iso.
Note explicitly that the remaining formal obligation is `IsZero ((pullback q).obj F)` for `q` mapping out
of the empty scheme (this is the prover's residual leaf, ~40–60 LOC: presheaf-of-modules `IsZero`-from-
pointwise via faithfulness of `toPresheaf` + subsingleton sections over the empty scheme). Keep
`lem:isIso_modules_of_toPresheaf` in `\uses{}` only if the final prose still routes through it; if the
prose now routes purely through `Functor.map_isZero`/terminality, drop it from `\uses` and replace with a
pointer to the additive-pushforward-preserves-zero fact.

---

## TASK 4 (OpenImm housekeeping) — remove 3 stale NOTEs + expand φ'' part (b)

(a) Three `% NOTE: build target. The Lean declaration does not exist yet.` comments are now FALSE — the
declarations exist and compile. REMOVE (or rewrite to "BUILT; body residual …") these three, attached to:
- `lem:pushforward_slice_two_adjunction` (~line 10331)
- `lem:pushforward_slice_pullback_iso` (~line 10386)
- `lem:pushforward_iso_preserves_qcoh` (~line 10448)

(b) Expand the proof of `lem:slice_reverse_ring_map` (φ'', ~lines 10271–10286). It currently calls the
codomain transport "pure equality-transport bookkeeping … no new mathematics", which under-specifies the
genuine ~40–80 LOC object-relabel iso. Add concrete pointers WITHOUT removing the (correct) object-level-
correction-free explanation:
- Part (a): the functor decomposition `eqv.inverse = Over.post (Opens.map φ.hom.base) ⋙
  Over.map (unitIso.inv.app Uᵢ)` gives a `Functor.sheafPushforwardContinuousComp'` identification of the
  pushforward-continuous codomain.
- Part (b): the explicit object-relabel isomorphism
  `X.ringCatSheaf.over (φ.hom⁻¹ᵁ Vᵢ) ≅ (sheafPushforwardContinuous (Over.map (unitIso.inv.app Uᵢ))).obj
  (X.ringCatSheaf.over Uᵢ)` — the structure ring sheaf restricted over the smaller open, transported
  along the opens-iso `unitIso.inv : φ.hom⁻¹ᵁ Vᵢ ≅ Uᵢ`. State that φ'' is then the over-pullback of
  `φ.hom.toRingCatSheafHom` post-composed with this codomain bridge.
Keep it as rigorous prose, no Lean tactic syntax (the `Functor.…`/`Over.…` names are acceptable as the
project's notation for the constructions, exactly as the existing chapter already uses them).

---

## Constraints
- Do NOT add or remove `\leanok` (the deterministic `sync_leanok` phase owns it).
- `\mathlibok` ONLY on genuine Mathlib re-export anchors — none of the blocks above are Mathlib
  re-exports, so add NO `\mathlibok` here.
- Do NOT translate; these are Archon-original constructions with no external source, so no `% SOURCE`
  lines are required (the chapter already follows this convention for the push–pull material).
- Touch ONLY the regions named above. Leave all other (correct) content unchanged.
- Verify every new `\uses{}` label resolves to a real `\label{}` in this chapter (or an existing one).
