# Session 52 (iter-052) — recommendations for the next plan iter

## TOP PRIORITY — RELOCATE `cechAugmented_exact` (lvb `chdi` must-fix; Known Blocker)

`cechAugmented_exact` is **file-placement-blocked**, not math-blocked. Do NOT re-dispatch it as a
plain `mathlib-build` objective on `CechHigherDirectImage.lean` — it provably cannot be proved there
(every sections/sheafification ingredient is downstream ⇒ import cycle).

**Action (planner routing decision):**
1. **Relocate** the exactness theorem to a downstream file. Recommended: a NEW file
   (e.g. `Cohomology/CechAugmentedResolution.lean`) importing `CechAcyclic`,
   `HigherDirectImagePresheaf`, `AffineSerreVanishing`, `QcohTildeSections` — OR reuse
   `AffineSerreVanishing.lean` (already transitively imports all of them). Use the `refactor`
   subagent if a clean new-file split is preferred. The frozen `\lean{}` name stays
   `AlgebraicGeometry.cechAugmented_exact`; only the file moves. The object layer
   (`cechAugmentedComplex` et al.) stays upstream and is visible downstream.
2. In the relocated file, build the **one remaining bridge**: reflect module-sheafification `IsZero`
   through the faithful additive `SheafOfModules.toSheaf`, matching `toSheaf ∘ sheafification` with
   `presheafToSheaf ∘ forget` (the `sheafificationCompToSheaf` square; `analogies/tosheaf-epi.md`).
   The 3 upstream Step-2 site lemmas (`isZero_presheafToSheaf_obj_of_W` /`…_of_W_isZero`/
   `…_of_isLocallyBijective`, already landed axiom-clean) are importable and discharge the
   site-theory half. This bridge is module-specific + diamond-prone — consider a mathlib-analogist
   (api-alignment) consult on `SheafOfModules.toSheaf` faithfulness/additivity + the sheafification
   square BEFORE the prover, given the keystone-diamond history (`keystone-tile-reconciliation-not-rfl`).
3. Before the prover runs on the relocated file, dispatch a **blueprint-writer** on
   `lem:cech_augmented_resolution` to (a) record the file-placement constraint (a `% NOTE` is in
   place but the proof prose should name the relocation + the `toSheaf` reflection step), and (b)
   add `\lean{}` blocks for the 3 site lemmas (see coverage debt). Then the HARD GATE re-clear.

## Closest-to-completion / ready next lanes

- **02KG TOPS ARE DONE.** `affine_cech_vanishing_qcoh` + `affine_serre_vanishing` are unconditional
  axiom-clean. The next consumers (per task_result + PROGRESS "Next iter plan") live in other files:
  `higherDirectImage_openImmersion_comp`, `cechTerm_pushforward_acyclic` — verify their `\uses`
  closures are complete (dag-query) before dispatch.
- After `cechAugmented_exact` lands: the P5a Ext-bridges → P5b assembly arc (the frozen
  `cech_computes_higherDirectImage` at `CechHigherDirectImage.lean:780`).

## Blueprint coverage debt (`archon dag-query unmatched` = 5) — planner authors blocks

Every Lean decl needs a tex entry. New this iter (4) + pre-existing (1):
- `AlgebraicGeometry.affine_tildeVanishing` (private, AffineSerreVanishing.lean) — thin reshaper of
  `sectionCech_homology_exact_of_localizationAway` into the `ULift (Fin n)` `htilde` shape. Being
  private, fold its name into the `\lean{...}` of `lem:affine_cech_vanishing_qcoh` or
  `lem:affine_cech_vanishing_tilde_subcover` (no standalone block needed).
- `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W` (CechHigherDirectImage.lean)
  — relies on `GrothendieckTopology.W_iff`, `Limits.IsZero.of_iso`, `asIso`.
- `…isZero_presheafToSheaf_obj_of_W_isZero` — relies on `presheafToSheaf_additive`, `Functor.map_isZero`,
  and the lemma above.
- `…isZero_presheafToSheaf_obj_of_isLocallyBijective` — relies on `GrothendieckTopology.W_of_isLocallyBijective`
  and the lemma above.
  → These 3 form one coherent Step-2 unit; a single small block (e.g. `lem:sheafify_kills_locally_zero`)
    referenced from `lem:cech_augmented_resolution`'s Step-2 is the cleanest.
- `AlgebraicGeometry.CechAcyclic.affine` (CechAcyclic.lean:110) — DEAD sorry-bodied stub, pre-existing.
  **Recommend deleting it** to drop sorry 2→1 and clear the stale unmatched node (it has been dead
  since the route reorganization; nothing depends on it).

## Do-NOT-retry (blocked, needs structural change first)
- `cechAugmented_exact` IN `CechHigherDirectImage.lean` — see TOP PRIORITY; relocate, do not retry in place.
- The stalk-at-prime route for `cechAugmented_exact` — documented dead end (no `SheafOfModules.stalk`,
  no exact-iff-stalkwise in Mathlib); the sections route supersedes it.

## Reusable proof patterns discovered (in PROJECT_STATUS.md Knowledge Base)
- 02KG-tops mechanical discharge (private reshaper + `_of_tildeVanishing` specialization; the
  `cechCohomology`/`homology` defeq + `0 < p`↔`1 ≤ p` defeq one-liner).
- Sheafification-kills-locally-zero site lemmas (`W_iff`/`presheafToSheaf_additive`/
  `W_of_isLocallyBijective`) — build pure-site sub-steps UPSTREAM even when the route heart is downstream.

## Blueprint prose to update (writer, low priority)
- The trailing prose paragraph of `lem:affine_serre_vanishing` still says "currently formalized in
  the reduced `_of_tildeVanishing` form pending the residual" — now stale (both are closed). A `% NOTE`
  flags it; a blueprint-writer should rewrite the paragraph next iter.
