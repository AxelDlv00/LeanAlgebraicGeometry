# Blueprint Review Report

## Slug
rescope065

## Iteration
065

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:pullbackObjUnitToUnit_mathlib`: isolated blueprint node (`leandag show isolated` confirms 0 in-edges, 0 out-edges). The proof of `lem:pushforward_slice_pullback_iso` at line 10573 explicitly states "The unit/free-module comparison `pullbackObjUnitToUnit` is NOT used: it identifies the pullback only on the unit (rank-one free) module, whereas H.over Ui is an arbitrary module." This anchor was scaffolded for a discarded route; it is now genuinely orphaned. **remove** — authorize a writer to delete this `\mathlibok` block from the chapter.

- `Cohomology_CechHigherDirectImage.tex` / `lem:slice_reverse_ring_map` proof: references `Functor.sheafPushforwardContinuousComp'` (line 10427) by Lean name but there is no `\mathlibok` anchor for this Mathlib lemma in the chapter. The adjacent `lem:sheafPushforwardContinuous_mathlib` covers the definition of `sheafPushforwardContinuous` but not its composition law. **wire-up** — add a `\mathlibok` anchor `\lean{CategoryTheory.Functor.sheafPushforwardContinuousComp'}` (or the correct Mathlib name; verify via lean_hover_info), and add it to the `\uses{}` of `lem:slice_reverse_ring_map`. Low-urgency: a prover can find the lemma by name, but the DAG is incomplete.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 94 blueprint nodes have a `\lean{}` hint but no `\leanok`; 5 have no `\lean{}` hint at all. These represent formalization work still ahead — they are NOT blueprint gaps. Coverage prose exists for every declaration. The `complete: partial` verdict is solely "not-yet-built downstream build-targets" in the directive's sense and does **not** block the gate.
  - **GATE CLEARS** for `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean` — see gate assessment below.
  - `lem:pullbackObjUnitToUnit_mathlib`: 1 isolated blueprint node, explicitly abandoned by the Lean proof; **remove** (see dependency findings, soon severity).
  - Missing `\mathlibok` for `Functor.sheafPushforwardContinuousComp'` used in the `lem:slice_reverse_ring_map` proof body; **wire-up** (soon severity).
  - 5 nodes missing `\lean{}` hints (`lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_engine_iso` area, `lem:tile_section_localization` [proved], `lem:isIso_fromTildeGamma_of_genSections` area, `lem:pushforward_iso_qcoh_of_slice_qcoh`). None are in the gate-critical files. Informational.

## Gate assessment (fast-path HARD GATE)

The directive asks whether `Cohomology_CechHigherDirectImage.tex` is now **complete: true AND correct: true** with **no must-fix-this-iter finding** for the material backing `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`. The answer is **yes — gate clears for both files**. Analysis of each of the 4 changed blocks:

### Block 1 — `lem:coprodToProd_isIso_of_equiv` (new reindexing induction leaf, lines 8388–8441)

The proof is now adequately detailed for formalization:

- **Source transport** is named precisely: `Sigma.whiskerEquiv e (i ↦ Iso.refl)` to get the Over-X slice isomorphism for the reindexed coproduct, then `lem:pushPullObjCongr` to carry the push-pull object across it. Both referenced lemmas have blueprint blocks (`lem:pushPullObjCongr` at line 8244).
- **Target transport** is named: `Pi.whiskerEquiv e (a ↦ Iso.refl)` / `Pi.mapIso` along e, reindexing the product.
- **Matching the canonical form** is explicit: a projection-by-projection check using the defining projection law of `coprodToProdMap` (push-pull map of each coproduct inclusion), and the fact that reindexing carries the i-th inclusion of the β-coproduct to the e⁻¹(i)-th inclusion of the α-coproduct.
- **IH usage** is explicit: "the induction hypothesis yields `IsIso(coprodToProdMap F legs)`."

The conjugation-by-isomorphisms argument is standard and the three named ingredients (source iso, target iso, projection matching) are sufficient for a Lean prover to fill in the rest. **No must-fix.**

### Block 2 — `def:coprodOverIncl`, `def:coprodToProdMap`, `lem:coprodToProd_isIso_option` (new framing definitions + closed Option-step, lines 8348–8469)

- `def:coprodOverIncl` (line 8348): Defines `ῑ_i : legs i → Over.mk(Sigma.desc(...))` with the commutative triangle verified from `Sigma.desc`'s defining property. Self-contained, no gaps.
- `def:coprodToProdMap` (line 8366): Defines the comparison map as `Pi.lift` whose i-th component is `pushPullMap F ῑ_i`. Equivalent characterization via universal property stated. Self-contained.
- `lem:coprodToProd_isIso_option` (line 8443): Proof splits the Option-coproduct via `lem:over_sigmaOptionIso`, transports via `lem:pushPullObjCongr` and binary decomposition (`lem:pushPull_binary_coprod_prod`), applies IH on the proper part, reassembles via `lem:piOptionIso`, closes by projection chase. All referenced lemmas exist (verified in chapter).
- **Wiring into `lem:pushPull_coprod_prod`**: The `\uses{}` block at lines 8483–8485 includes `lem:coprodToProd_isIso_of_equiv`, `lem:coprodToProd_isIso_option`, and `def:coprodOverIncl`/`def:coprodToProdMap`. `leandag build` reports `unknown_uses: []` — no broken edges. **No isolated nodes** from these declarations (all feed into `lem:pushPull_coprod_prod` which is \leanok).

**No must-fix.**

### Block 3 — `lem:pushPull_coprod_prod_empty` realigned to `IsZero` route (lines 8305–8346)

The proof now explicitly states the formal obligation at line 8341–8345:
> "The single remaining formal obligation is that the pulled-back module is zero, namely `IsZero((pullback q).obj F)` for q the map out of the empty scheme."

The route described matches the Lean proof:
1. Coproduct over PEmpty = initial scheme → structure map `q : ⊥ → X` is the unique initial morphism.
2. Every module over the empty scheme is zero (structure sheaf has subsingleton sections over the only open, the empty open → zero module sheaf).
3. `IsZero((pullback q).obj F)` follows.
4. `(pushforward q).obj` of a zero object = zero object (additive functor).
5. Empty product is terminal, pushPullObj is terminal → morphism between terminals is iso.

The `IsZero`-over-initial-scheme route replaces the prior vacuous sketch. **No must-fix.**

### Block 4 — `lem:slice_reverse_ring_map` (φ'') expanded proof (lines 10384–10443)

Previously the keystone leaf had no concrete description. The proof now has two named parts:

- **Part (a) — continuity of the corrected inverse** (line 10421–10427): The inverse `eqv.inverse = Over.post(Opens.map φ.hom.base) ∘ Over.map(unitIso.inv)` decomposes as a composite; its continuity is `lem:slice_overs_equiv_continuity`. The identification of the `sheafPushforwardContinuous` functor along this composite is the composition law `Functor.sheafPushforwardContinuousComp'`. A prover can locate this Mathlib lemma by name and apply it.

- **Part (b) — the object-relabel isomorphism** (lines 10429–10442): An explicit isomorphism
  ```
  X.ringCatSheaf.over(φ.hom⁻¹ Vᵢ) ≅ (sheafPushforwardContinuous(Over.map(unitIso.inv_{Uᵢ}))).obj(X.ringCatSheaf.over Uᵢ)
  ```
  described as "equality-transport along the opens-isomorphism `unitIso.inv_{Uᵢ} : φ.hom⁻¹ Vᵢ ≅ Uᵢ`." The formulation is concrete enough: a prover needs to close this by `eqToHom`/`congr` along the opens identity.

The combined assembly (over-pullback of `φ.hom.toRingCatSheafHom`, post-composed with the codomain bridge above) is sufficiently specified. The "object-level correction-free" observation (that `Over.map(unitIso.inv)` acts trivially on objects) is correctly articulated, which resolves the earlier under-specification.

**No must-fix.** Note: the missing `\mathlibok` for `sheafPushforwardContinuousComp'` is a soon-severity wire-up, not a gate blocker, since the prover can find the lemma by Lean name.

### DAG and rendering checks

- `leandag build --json` → `unknown_uses: []`, `conflicts: []`, isolated count = 2 (1 blueprint, 1 lean_aux). The blueprint isolated node is `lem:pullbackObjUnitToUnit_mathlib` (remove, soon severity). The lean_aux node is an uncovered helper (normal, no action needed).
- `archon blueprint-doctor --json` → `broken_refs: []`, `malformed_refs: []`, `orphan_chapters: []`, `covers_problems: []`. Blueprint is rendering-clean.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**:
  - `Cohomology_CechHigherDirectImage.tex` / `lem:pullbackObjUnitToUnit_mathlib`: **remove** — isolated `\mathlibok` anchor for an approach the Lean proof explicitly abandoned (`pullbackObjUnitToUnit` is not used in `pushforward_slice_pullback_iso`).
  - `Cohomology_CechHigherDirectImage.tex` / `lem:slice_reverse_ring_map` proof: **wire-up** — add `\mathlibok` anchor for `Functor.sheafPushforwardContinuousComp'` (the sheafPushforward composition law) and add it to the `\uses{}` of this lemma.
- **informational**:
  - 5 blueprint nodes missing `\lean{}` hints (none in gate-critical files): `lem:cech_free_eval_sectionwise`, one nearby `cech_free_eval_*` lemma, `lem:tile_section_localization` (already proved — hint just never added), an `isIso_fromTildeGamma_*` helper, `lem:pushforward_iso_qcoh_of_slice_qcoh`. These do not block any active prover route.

**Overall verdict**: `Cohomology_CechHigherDirectImage.tex` is correct: true and the material backing `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean` is complete and correct with no must-fix finding — the HARD GATE clears for both files; 3 chapters audited, 2 soon-severity findings (remove + wire-up), 0 must-fix, 0 unstarted-phase proposals.
