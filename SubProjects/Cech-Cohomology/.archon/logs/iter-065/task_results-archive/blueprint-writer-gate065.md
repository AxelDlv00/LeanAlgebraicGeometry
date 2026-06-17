# Blueprint Writer Report

## Slug
gate065

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### TASK 1 — dedicated lemma for `coprodToProd_isIso_of_equiv`
- **Added lemma** `\label{lem:coprodToProd_isIso_of_equiv}` / `\lean{AlgebraicGeometry.coprodToProd_isIso_of_equiv}`, placed just before `lem:pushPull_coprod_prod`. Statement: `IsIso (coprodToProdMap F ·)` is stable under reindexing the leg family along an index equivalence `e : α ≃ β` (IH on the reindexed family ⇒ result on `legs`).
  - **Proof sketch added: Y** — full prose route: transport the SOURCE via `Sigma.whiskerEquiv e` + descent-object identification carried across by `pushPullObjCongr`; transport the TARGET via `Pi.whiskerEquiv e` / `Pi.mapIso`; identify `coprodToProdMap F legs` as the conjugate of `coprodToProdMap F (legs∘e)` projection-by-projection using the `coprodToProdMap`-projection law and naturality of `pushPullMap` under reindexing of the inclusions; conjugate of an iso is an iso ⇒ IH closes it. No Lean tactics.
- **Revised** `lem:pushPull_coprod_prod` proof — replaced the thin one-sentence "Reindexing" paragraph (lines ~8374–8376) with the one-line pointer "stable under index equivalence by Lemma~\ref{lem:coprodToProd_isIso_of_equiv}"; added `lem:coprodToProd_isIso_of_equiv` to both statement and proof `\uses`.

### TASK 2 — load-bearing framing definitions + Option-step lemma
- **Added definition** `\label{def:coprodOverIncl}` / `\lean{AlgebraicGeometry.coprodOverIncl}` — the `i`-th coproduct inclusion `legs i ⟶ Over.mk (Sigma.desc (·.hom))` in `Over X`.
- **Added definition** `\label{def:coprodToProdMap}` / `\lean{AlgebraicGeometry.coprodToProdMap}` (`\uses{def:push_pull_obj, def:push_pull_map, def:coprodOverIncl}`) — the `Pi.lift` comparison map with `i`-th component `pushPullMap F (coprodOverIncl … i)`.
- **Added lemma** `\label{lem:coprodToProd_isIso_option}` / `\lean{AlgebraicGeometry.coprodToProd_isIso_option, …pushPullObjCongr_hom, …pushPull_binary_coprod_prod_hom, …piOptionIso_inv_π_none, …piOptionIso_inv_π_some}` with `\uses{def:coprodToProdMap, lem:pushPull_binary_coprod_prod, lem:over_sigmaOptionIso, lem:piOptionIso, lem:pushPullObjCongr}`. One-paragraph informal proof (Option-coproduct splits binary → binary decomposition + IH on `some`-part → reassemble via `piOptionIso` inverse → per-`Option`-case projection chase matches canonical form).
- **Folded helper Lean names into parent `\lean{}` lists** (so the DAG sees them):
  - `coprodToProdMap_comp_π`, `isIso_coprodToProdMap` → into `lem:pushPull_coprod_prod`'s `\lean{}`.
  - `pushPullObjCongr_hom`, `pushPull_binary_coprod_prod_hom`, `piOptionIso_inv_π_none`, `piOptionIso_inv_π_some` → into `lem:coprodToProd_isIso_option`'s `\lean{}`.
- **Revised** `lem:pushPull_coprod_prod` — added `def:coprodOverIncl, def:coprodToProdMap, lem:coprodToProd_isIso_option` to statement+proof `\uses`; replaced the long "Adjoining one index" paragraph with a pointer to `lem:coprodToProd_isIso_option` (matching what the Lean proof actually does via `Finite.induction_empty_option`).
- **Revised** `lem:pushPull_coprod_prod_empty` `\uses` (statement+proof) — added `def:coprodToProdMap` (wires the new def node; see Task 3).

### TASK 3 — `lem:pushPull_coprod_prod_empty` proof realigned to the Lean route
- **Revised** proof prose to match the actual Lean route: empty coproduct = initial scheme `⊥`; every module sheaf over the empty scheme is the zero object (only open is empty, subsingleton structure-sheaf sections); hence `(pullback q).obj F` is zero; the additive pushforward sends zero → zero (terminal); empty product likewise terminal; morphism between terminals is iso. Explicitly states the residual leaf `IsZero ((pullback q).obj F)` (presheaf-of-modules `IsZero` pointwise via faithful `toPresheaf` + subsingleton sections over the empty scheme).
- **Dropped** `lem:isIso_modules_of_toPresheaf` from this lemma's `\uses` (statement+proof) — the prose no longer routes through it (it now routes through additive-pushforward-preserves-zero / terminality); replaced with `def:coprodToProdMap` and an in-prose pointer to the additive-pushforward-preserves-zero fact.

### TASK 4 — OpenImm housekeeping
- (a) **No edit needed / verified.** The three `% NOTE` comments at `lem:pushforward_slice_two_adjunction` (~10333), `lem:pushforward_slice_pullback_iso` (~10391), `lem:pushforward_iso_preserves_qcoh` (~10457) were already rewritten (iter-064) to accurate `% NOTE (review iter-064): BUILT — …` text describing the real residuals. A repo-wide grep for "does not exist yet" / "build target" found NO stale "does not exist yet" note attached to these lemmas, so there was nothing false to remove. Left the accurate BUILT notes in place.
- (b) **Revised** `lem:slice_reverse_ring_map` (φ'') proof — kept the correct object-level-correction-free explanation but expanded the under-specified "pure equality-transport bookkeeping" sentence into two concrete parts: **(a)** the functor decomposition `eqv.inverse = Over.post (Opens.map φ.hom.base) ⋙ Over.map (unitIso.inv_{Uᵢ})` and its `Functor.sheafPushforwardContinuousComp'` codomain identification (continuity = `lem:slice_overs_equiv_continuity`); **(b)** the explicit object-relabel isomorphism `X.ringCatSheaf.over (φ.hom⁻¹ Vᵢ) ≅ (sheafPushforwardContinuous (Over.map (unitIso.inv_{Uᵢ}))).obj (X.ringCatSheaf.over Uᵢ)`, with φ'' stated as the over-pullback of `φ.hom.toRingCatSheafHom` post-composed with this codomain bridge. Rigorous prose, project `Functor.`/`Over.` notation, no Lean tactics.

## Cross-references introduced
- `lem:coprodToProd_isIso_of_equiv` `\uses{def:push_pull_obj, def:coprodOverIncl, def:coprodToProdMap, lem:pushPullObjCongr}` — all resolve in this chapter.
- `lem:coprodToProd_isIso_option` `\uses{def:coprodToProdMap, lem:pushPull_binary_coprod_prod, lem:over_sigmaOptionIso, lem:piOptionIso, lem:pushPullObjCongr}` — all resolve.
- `def:coprodToProdMap` `\uses{def:push_pull_obj, def:push_pull_map, def:coprodOverIncl}` — all resolve.
- Added `def:coprodOverIncl, def:coprodToProdMap, lem:coprodToProd_isIso_of_equiv, lem:coprodToProd_isIso_option` to `lem:pushPull_coprod_prod` (statement+proof); `def:coprodToProdMap` to `lem:pushPull_coprod_prod_empty`.

## Verification (leandag)
`leandag build --json`: `unknown_uses: []` (every new `\uses` resolves). All four new nodes (`def:coprodOverIncl`, `def:coprodToProdMap`, `lem:coprodToProd_isIso_of_equiv`, `lem:coprodToProd_isIso_option`) **matched** their Lean declarations and **none are isolated**. The 2 remaining project-wide isolated nodes (`lem:pullbackObjUnitToUnit_mathlib`, one `lean_aux`) are pre-existing and untouched by this round — `pullbackObjUnitToUnit` is the unit-only comparison the `pushforward_slice_pullback_iso` proof explicitly notes it does NOT use.

## References consulted
None — all blocks edited/added this round are Archon-original push–pull / slice constructions with no external source (the chapter already follows the no-`% SOURCE` convention for this material). No citation blocks were written.

## Macros needed (if any)
None. `\iota`/`\pi` inside `\operatorname` matches the chapter's existing convention (`\operatorname{cechEngineD\_\iota}`); `\operatorname{Sigma.desc}`, `\operatorname{Sigma.whiskerEquiv}`, `\operatorname{Pi.mapIso}` etc. are already used elsewhere in this chapter.

## Notes for Plan Agent
- Both keystone leaves now have faithful, formalizable blocks: `lem:coprodToProd_isIso_of_equiv` (the `sorry` at `CechSectionIdentification.lean:999`) and `lem:pushPull_coprod_prod_empty` (the `sorry` at `:983`). The empty-base residual is now stated precisely in prose as `IsZero ((pullback q).obj F)` over the empty scheme.
- `lem:coprodToProd_isIso_option` is already CLOSED in Lean; its block + folded helper `\lean{}` names exist only to give the DAG the dependency edges.
- The `% NOTE (review iter-064): BUILT …` annotations on the three OpenImm lemmas are review-agent territory; they are currently accurate, so I left them. If the keystone φ'' (`lem:slice_reverse_ring_map`) gets a sorry-free body next round, those residual descriptions will need a refresh by the review agent.

## Strategy-modifying findings
None.
