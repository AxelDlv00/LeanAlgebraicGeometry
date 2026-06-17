# Blueprint-writer directive — iter-064: decompose two terminal lemma chains into fine-grained sub-lemmas + correct φ''

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter covering both
`CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`).

## Why (context you need)
Two terminal lemmas in this chapter are each a large monolithic assembly that a prover has repeatedly
built setup for and then declined near budget. The fix is to split each into individually-named
`\uses`-linked sub-lemmas (one mathematical claim per lemma) so a fine-grained prover can close them one at
a time. Two prover handoffs (transcribed below) give the EXACT sub-lemma list, types, and recipes — your job
is to transcribe these into well-formed blueprint blocks, NOT to invent new mathematics. One block also
needs a MATH CORRECTION (φ'' below) — the current statement is provably wrong.

These are Archon-original / project-bespoke results (categorical bookkeeping over Mathlib's scheme-module
API); no external source quote is required for the new sub-lemmas. Keep each block's proof at the level of
detail a prover can formalize (name the Mathlib anchors and the construction; no Lean tactic strings).

Do NOT add `\leanok` to anything (deterministic sync owns it). You MAY add `\mathlibok` ONLY on genuine
Mathlib dependency anchors you introduce (see the anchor lists below).

---

## PART A — decompose `lem:pushPull_coprod_prod` (currently ~lines 8193–8246)

Currently `lem:pushPull_coprod_prod` is a single lemma with an induction proof. Keep the lemma's STATEMENT
(the indexed coproduct→product iso) but replace its monolithic proof with one that cites the new named
sub-lemmas below, and ADD those sub-lemmas as their own `\begin{lemma}` blocks placed BEFORE
`lem:pushPull_coprod_prod` (after `lem:pushPull_binary_coprod_prod`, ~line 8191). All live in
`CechSectionIdentification.lean`. The prover-verified decomposition (≈120 LOC across these pieces):

1. **`lem:sigmaOptionIso`** — `\lean{CategoryTheory.sigmaOptionIso}` — ALREADY BUILT (axiom-clean this iter),
   give it a blueprint block to clear coverage debt. Statement: for `Z : Option α → C` in a category with the
   relevant coproducts, `(∐ Z) ≅ Z none ⨿ (∐ a, Z (some a))`. Proof: build `hom = Sigma.desc (Option.rec …)`,
   `inv = coprod.desc (Sigma.ι Z none) (Sigma.desc …)`; the two coherences via `Sigma.hom_ext`/`coprod.hom_ext`
   + the `_desc`/`ι_desc` universal-property simp lemmas. (Mathlib has `sigmaSigmaIso` for nested coproducts
   but no `Option`-split.) `\uses{}` empty (pure category theory).

2. **`lem:pushPullObjCongr`** — `\lean{AlgebraicGeometry.pushPullObjCongr}` (build target, does not yet exist).
   Statement: an iso `e : Y ≅ Y'` in `Over X` induces `pushPullObj F Y ≅ pushPullObj F Y'`. Proof: from
   `pushPullMap F e.inv` / `pushPullMap F e.hom` (CONTRAVARIANT — `hom` uses `e.inv`) with the coherences from
   `pushPullMap_comp` / `pushPullMap_id`. ~6 LOC. `\uses{def:push_pull_obj}`.

3. **`lem:over_sigmaOptionIso`** — `\lean{AlgebraicGeometry.overSigmaOptionIso}` (build target).
   Statement: the Over-X lift of `sigmaOptionIso` with descent-map compatibility, for a family
   `legs : Option α → Over X`:
   `Over.mk (Sigma.desc (fun o => (legs o).hom)) ≅ Over.mk (coprod.desc (legs none).hom (Sigma.desc (fun a => (legs (some a)).hom)))`,
   built as `Over.isoMk (sigmaOptionIso (fun o => (legs o).left)) (proof the two descent maps agree)`. The
   structure-map proof: both descend to `(legs o).hom` on each component (`Sigma.ι_desc` / `coprod.inl_desc` /
   `coprod.inr_desc`). ~15 LOC. `\uses{lem:sigmaOptionIso}`.

4. **`lem:piOptionIso`** — `\lean{AlgebraicGeometry.piOptionIso}` (build target). Statement: the PRODUCT dual of
   `sigmaOptionIso`: `∏ᶜ W ≅ W none ⨯ (∏ᶜ a, W (some a))` for `W : Option α → C`. Same shape as `sigmaOptionIso`
   with `Pi.lift`/`prod.lift` in place of `Sigma.desc`/`coprod.desc`. ~15 LOC. `\uses{}` empty.

5. **`lem:pushPull_coprod_prod_empty`** — `\lean{AlgebraicGeometry.pushPull_coprod_prod_empty}` (build target).
   Statement: the empty-index base case — for `ι = PEmpty`, `pushPullObj F (Over.mk (Sigma.desc …))` over the
   INITIAL scheme is terminal in `X.Modules`, hence iso to the empty product `∏ᶜ (PEmpty-indexed family)`
   (also terminal). Proof: reflect through `lem:isIso_modules_of_toPresheaf` — sections over every `V` are
   terminal because the preimage in the initial scheme `⊥` is empty (both sides have zero sections). ~20–30 LOC.
   `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf}`.

6. **`lem:pushPull_coprod_prod`** (KEEP the label + statement; REWRITE the proof). The proof is the
   `induction_empty_option` finite-index induction on `ι`:
   - empty base: `lem:pushPull_coprod_prod_empty`;
   - `of_equiv` (reindex along `β ≃ α`): reindex the CANONICAL `Pi.lift`/`Sigma.desc` via `Pi.whiskerEquiv`/
     `Sigma.whiskerEquiv` (must preserve the canonical `Pi.lift` framing — Stub 5 consumes `.hom = Pi.lift (pushPullMap …)`);
   - `h_option` step: chain `pushPullObjCongr (over_sigmaOptionIso)` ▸ `lem:pushPull_binary_coprod_prod`
     ▸ (binary product with the IH) ▸ `(piOptionIso).symm`, checking the composite `.hom` is the canonical
     `Pi.lift`. Keep the CANONICAL framing `asIso (Pi.lift (fun i => pushPullMap F (overι legs i)))` where
     `overι legs i := Over.homMk (Sigma.ι _ i) (Sigma.ι_desc _ i)`.
   `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf, lem:pushPull_binary_coprod_prod,
   lem:pushPullObjCongr, lem:over_sigmaOptionIso, lem:piOptionIso, lem:pushPull_coprod_prod_empty}`.

7. **`lem:pushPull_sigma_iso`** (already exists, ~line 8248 — leave statement; its `\uses` already points at
   `lem:pushPull_coprod_prod`, keep it). Optionally note it specializes via `cech_backbone_left_sigma` +
   `overSigmaDescIso` (the `∐_σ Over.mk j_σ ≅ Over.mk (Sigma.desc j)` reindex) + `pushPullObjCongr`.

Also add a coverage block for the pre-existing aux **`lem:pushPullCoprodLegIso`** —
`\lean{AlgebraicGeometry.pushPullCoprodLegIso}` (a leg-iso aux used by `lem:pushPull_binary_coprod_prod`); a
one-line statement + `\uses{def:push_pull_obj}` suffices to clear its coverage debt. (Inspect its use site in
`lem:pushPull_binary_coprod_prod`'s proof to state it accurately.)

---

## PART B — decompose `lem:pushforward_slice_two_adjunction` (currently ~lines 10012–10063) AND CORRECT φ''

The current block defines `φ'' = sliceStructureSheafHom φ⁻¹ Vᵢ`. **This is WRONG** — the iter-063 prover
verified by type analysis that `sliceStructureSheafHom φ.symm Vᵢ` does NOT fit the required slot (it is along
the bare `Over.post (Opens.map φ.hom.base)` landing in `Over (φ.hom⁻¹ᵁ Vᵢ)`, whereas the slot demands
`eqv.inverse` which carries the `Over.map (unitIso.inv)` correction landing in `Over Uᵢ`; the open identity
`φ.hom⁻¹ᵁ φ.inv⁻¹ᵁ Uᵢ = Uᵢ` is NOT rfl). Correct the φ'' definition and split the lemma into named pieces.

Keep `lem:pushforward_slice_two_adjunction`'s STATEMENT (the adjunction `pushforward φ'' ⊣ pushforward ψ_r`)
but replace `φ''`'s definition and the monolithic proof with citations to the new sub-lemmas below. All live
in `OpenImmersionPushforward.lean`.

**CORRECTED φ'' — prover-verified (KEY INSIGHT):** φ'' is **object-level correction-FREE**. Its required type is
`(Y.ringCatSheaf.over Vᵢ) ⟶ (eqv.inverse.sheafPushforwardContinuous RingCat ((gt Y).over Vᵢ) ((gt X).over Uᵢ)).obj (X.ringCatSheaf.over Uᵢ)`
where `eqv = sliceOversEquiv φ Uᵢ`, `gt _` the over-Grothendieck-topology. Over any `W : (Over Vᵢ)ᵒᵖ`, the
codomain section is `(X.ringCatSheaf.over Uᵢ).obj (op (eqv.inverse.obj W.unop))` and
`(eqv.inverse.obj W').left = φ.hom⁻¹ᵁ W'.left` because `Over.map` leaves `.left` UNCHANGED (it only
post-composes the structure arrow). So at the SECTION level φ'' is exactly the slice restriction of
`φ.hom.toRingCatSheafHom` — NO correction. Concretely:
`φ'' = ((gt Y).overPullback RingCat Vᵢ).map φ.hom.toRingCatSheafHom` transported along the codomain iso
(`Over.map (unitIso.inv)`-pushforward + `X.ringCatSheaf.over` moved along `unitIso.inv : φ.hom⁻¹ᵁ Vᵢ ≅ Uᵢ`) —
pure `eqToHom`/`sheafPushforwardContinuousComp` bookkeeping, not new mathematics. The `Over.map (unitIso.inv)`
correction affects ONLY how `eqv.inverse` acts on MORPHISMS, i.e. only the two compatibility squares H₁/H₂.

New named sub-lemmas (place BEFORE `lem:pushforward_slice_two_adjunction`):

1. **`lem:slice_overs_equiv_continuity`** — a coverage/anchor block bundling the 6 slice-equivalence helpers
   already BUILT this iter (axiom-clean), to clear their coverage debt. Statement (informal): the slice
   equivalence `sliceOversEquiv φ Uᵢ : Over Uᵢ ≌ Over Vᵢ` (= `Over.postEquiv Uᵢ (opensEquivOfIso φ)`) and its
   functor/inverse are both continuous for the over-Grothendieck-topologies. `\lean{}` list (all 6):
   `AlgebraicGeometry.opensMapHomBase_isEquivalence, AlgebraicGeometry.opensEquivOfIso,
   AlgebraicGeometry.sliceOversEquiv, AlgebraicGeometry.sliceOversEquiv_functor_isContinuous,
   AlgebraicGeometry.overPost_slice_inverse_isContinuous, AlgebraicGeometry.sliceOversEquiv_inverse_isContinuous`.
   Proof sketch: `opensEquivOfIso φ = Opens.mapMapIso (Scheme.forgetToTop.mapIso φ).symm` (functor defeq
   `Opens.map φ.inv.base`, inverse defeq `Opens.map φ.hom.base`); forward continuity from the existing
   `overPost_slice_isContinuous`; inverse continuity from `Functor.isContinuous_comp` of
   `Over.post (Opens.map φ.hom.base)` (via `CoverPreserving.overPost` + `coverPreserving_opens_map φ.hom.base`)
   with `Over.map (unitIso.inv)` (always continuous: `GrothendieckTopology.instIsContinuousOverMapOver`), read
   through `Over.postEquiv_inverse`. Add `\mathlibok` ANCHOR blocks for the genuine Mathlib pieces if not
   already present: `TopologicalSpace.Opens.mapMapIso`, `CategoryTheory.Over.postEquiv` (+ its `_inverse`),
   `CategoryTheory.GrothendieckTopology.instIsContinuousOverMapOver`, `CategoryTheory.Functor.isContinuous_comp`,
   `CategoryTheory.CoverPreserving.overPost`. (`lem:over_postEquiv_mathlib` may already exist — reuse it.)

2. **`lem:slice_reverse_ring_map`** — `\lean{AlgebraicGeometry.sliceReverseRingMap}` (build target). Statement:
   the reverse slice ring map φ'' of the CORRECTED type above, object-level correction-free. Proof: the section-
   level construction `((gt Y).overPullback RingCat Vᵢ).map φ.hom.toRingCatSheafHom` transported along the
   codomain iso via `sheafPushforwardContinuousComp` / `eqToHom` (the `Over.map (unitIso.inv)` factor is
   object-trivial as explained). `\uses{lem:slice_structureSheaf_hom, lem:slice_overs_equiv_continuity}`.

3. **`lem:pushforward_slice_adjunction_h1`** — `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH1}` (build
   target). Statement: the counit-naturality square H₁ required by `pushforwardPushforwardAdj`, relating φ'',
   ψ_r and the counit of the slice-equivalence adjunction `adj`, absorbing the `Over.map (unitIso.inv)` factor.
   Proof: reduces, via `toRingCatSheafHom` of `φ.hom`/`φ.inv` being mutually inverse + naturality, to a
   proof-irrelevant `eqToHom = eqToHom` square. `\uses{lem:slice_reverse_ring_map, lem:slice_structureSheaf_hom}`.

4. **`lem:pushforward_slice_adjunction_h2`** — `\lean{AlgebraicGeometry.pushforwardSliceAdjunctionH2}` (build
   target). Statement: the unit-triangle square H₂, same shape, also reducing to `eqToHom = eqToHom`.
   `\uses{lem:slice_reverse_ring_map, lem:slice_structureSheaf_hom}`.

5. **`lem:pushforward_slice_two_adjunction`** (KEEP label + statement; REWRITE proof + φ'' reference). Proof:
   feed the slice-equivalence adjunction `adj = (sliceOversEquiv φ Uᵢ).symm.toAdjunction`, the ring maps φ''
   (`lem:slice_reverse_ring_map`) and ψ_r (`lem:slice_structureSheaf_hom`), and the squares H₁
   (`lem:pushforward_slice_adjunction_h1`) and H₂ (`lem:pushforward_slice_adjunction_h2`) to Mathlib's
   `pushforwardPushforwardAdj` (`lem:pushforwardPushforwardAdj_mathlib`). The continuity inputs are
   `lem:slice_overs_equiv_continuity`. `\uses{lem:slice_structureSheaf_hom, lem:slice_reverse_ring_map,
   lem:pushforward_slice_adjunction_h1, lem:pushforward_slice_adjunction_h2, lem:slice_overs_equiv_continuity,
   lem:pushforwardPushforwardAdj_mathlib, lem:over_postEquiv_mathlib}`.

Then ensure `lem:pushforward_slice_pullback_iso` (~line 10065) still cites `lem:pushforward_slice_two_adjunction`
(it does) and that its φ'' references are consistent with the corrected definition.

---

## Out of scope
- Do NOT touch any other lemma chains in the chapter.
- Do NOT add `\leanok`.
- Do NOT edit the `% NOTE: build target` markers EXCEPT: you MAY remove the now-stale
  `% NOTE: build target ... does not exist yet` on `lem:pushPull_binary_leg_coherence` (the decl
  `AlgebraicGeometry.pushPull_binary_leg_coherence` was built axiom-clean this iter) if you encounter it —
  otherwise leave markers to the review/sync phases.
- Keep all new blocks consistent with the project's existing notation in this chapter.

## Verification you should do
- Every new `\uses{label}` must resolve to a `\label` that exists in the chapter after your edits (the new
  sub-lemmas you add, or pre-existing labels). Do not introduce a broken `\uses`.
- Confirm `lem:pushPull_coprod_prod` and `lem:pushforward_slice_two_adjunction` retain their original
  `\lean{}` targets and STATEMENTS (only proofs + φ'' definition + `\uses` change).
