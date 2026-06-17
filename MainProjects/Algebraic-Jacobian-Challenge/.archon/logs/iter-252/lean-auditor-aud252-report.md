# Lean Audit Report

## Slug
aud252

## Iteration
252

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged (minor stale historical reference — see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 4 flagged (one non-standard proof option; 3 elevated-heartbeat overrides; erw-heavy chain — all axiom-clean)
- **excuse-comments**: none
- **notes**:
  - **Sorry count (module header claim vs reality):** Header L43 says "THREE tracked typed-`sorry` residuals (iter-252)". Grep finds exactly 3 actual `sorry` keywords at load-bearing positions: L708 (`exists_tensorObj_inverse`), L1993 (`sheafifyTensorUnitIso_hom_natural`), L2022 (`pullbackTensorMap_natural`). ✓ Accurate.
  - **D2′ "CLOSED axiom-clean" claim (L47-50):** Verified. `pullbackTensorMap_unit_isIso` (L1844-1848) is a pure term-mode proof chaining `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` → `isIso_sheafifyEta_of_unitSquare` → `pullbackEtaUnitSquare`. All three are sorry-free. `pullbackEtaUnitSquare` (L1746-1838) ends with `erw [Category.assoc, ← Functor.map_comp, pullbackSheafifyUnitEtaTriangle f, presheafUnit_comp_map_eta f, epsilonPresheafToSheafUnit f]` — no sorry. ✓
  - **`sheafifyTensorUnitIso_hom_natural` sorry (L1993):** The proof makes substantial progress: whisker route confirmed blocked (L1947-1956, instance-group mismatch `monoidalCategoryStruct` vs `monoidalCategory.toMonoidalCategoryStruct` verified live), section route reduces via `simp only [MonoidalCategory.whiskerLeft, ...]` + `erw` (L1963-1974) to a ModuleCat element-level goal after `ModuleCat.hom_ext` + `TensorProduct.ext`. The `sorry` at L1993 is a **genuine typed residual** at the `TensorProduct.induction_on` stage. Surrounding prose ("RESIDUAL (instance-free, mechanical)") matches actual state.
  - **`pullbackTensorMap_natural` sorry (L2022):** Proof strategy comment (L2005-2020) documents the four-square naturality paste (S1–S4) and notes S3 (sheafifyTensorUnitIso_hom_natural) as "the one open sorry, blocked on `.val`-carrier normalisation". `simp only [pullbackTensorMap, tensorObj_functoriality]` runs, then `sorry`. Genuine typed residual, correctly gated on the helper. ✓
  - **"Next iter:" annotation (L1986):** Inside the sorry-guarded element-level residual of `sheafifyTensorUnitIso_hom_natural`. Documents the proof strategy (`TensorProduct.induction_on` route). Honest about incompleteness (sorry IS present). NOT a must-fix excuse comment, but the "Next iter:" label will become stale once the sorry closes — **minor**.
  - **`set_option backward.isDefEq.respectTransparency false in` (L1657):** Used for `epsilonPresheafToSheafUnit`. Scoped to that single declaration via `... in`. Non-standard proof-search option; the proof body relies on it to fire `erw [SheafOfModules.unitToPushforwardObjUnit_val_app_apply, ModuleCat.restrictScalars_η]` without the default `reducible`-transparency gating. Axiom-clean, but fragile with respect to Lean/Mathlib elaboration changes. **Flagged for polish pass.**
  - **Elevated `maxHeartbeats` (L1694, L1736, L1872, L1909):** `1600000` at three sites, `3200000` for `pullbackEtaUnitSquare`. Each has a comment explaining the elaboration cost source (sheafification-unit naturality, mate-calculus telescope). No semantic problem.
  - **`erw`-heavy chain in `pullbackEtaUnitSquare` (L1771, 1789, 1833, 1837-1838):** Used because `SheafOfModules`/`Scheme.Modules` carrier spellings are defeq-but-not-syntactic for `rw`. Comment at L898-900 documents this. Axiom-clean; **flagged for polish pass**.
  - **Stale historical remark (L234):** "The earlier `monoidalCategory := sorry` instance...routed through the verified-absent `MonoidalClosed`...they are removed here." Accurate description of a removed approach; not misleading, purely historical. **Minor.**

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged (stale planner note about `dual_unit_iso`; see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`erw [reassoc_of% hm]` in `homLocalSection.naturality`)
- **excuse-comments**: none
- **notes**:
  - **`dual_isLocallyTrivial` header label (L25):** Now correctly reads `**TRANSITIVELY PARTIAL** (depends on `dual_restrict_iso` Step-4 sorry at ~L254)`. Confirms the prover relabeling from the prior-iter mislabeled "CLOSED". ✓
  - **"Uses" fix at L288-290:** `Uses (dual_restrict_iso is PARTIAL — Step-4 sorry at ~L254; all other deps CLOSED):` — accurately notes the PARTIAL dependency instead of the prior "Uses (all CLOSED):" inconsistency. ✓
  - **`dual_restrict_iso` sorry (L256):** Sorry at the exact identified residual: `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` after Steps 1–3 + H1. Genuine typed residual. Comment at L241-256 is honest. ✓
  - **`dual_isLocallyTrivial` body (L332-341):** No sorry in the body itself — `exact dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`. Transitively sorry-carrying via `dual_restrict_iso`. Module header label TRANSITIVELY PARTIAL is accurate. ✓
  - **`homLocalSection` (L355-404):** **Confirmed as a genuine axiom-clean construction.** The `app` field (L358-365) constructs the section sectionwise via `eqToHom`-conjugation of `f i`. The `naturality` field (L366-404) is fully proved using standard composition lemmas (`hML`, `hNR`, `hm`), `Subsingleton.elim` on thin-poset hom-sets, and `erw [reassoc_of% hm, hNR]`. No sorry anywhere in `homLocalSection`. ✓ Not a laundered placeholder.
  - **`homOfLocalCompat` (L474-510):** Genuine scaffold. The body builds the type-theory ingredients: `H` (the hom-sheaf), `hsup` (cover exhaustion), and `hglue` (the gluing engine set-up). The sorry at L510 is precisely bounded by the residual comment at L501-509 (IsCompatible datum, section conversion, `𝒪_X`-linearity). No sorry is hidden. ✓
  - **`dual_unit_iso` (L274-279):** Axiom-clean definition using `presheafDualUnitIso ≪≫ (asIso sheafificationAdjunction.counit).app 𝒪_Y`. No sorry.
  - **Stale planner note at L322-323:** "The `dual_unit_iso` is a missing sub-lemma; the prover may need to build it inline or as a separate declaration (it is a small sorry if needed, NOT blocked)." This was written during planning when `dual_unit_iso` was missing. It is now built axiom-clean at L274-279. The note incorrectly implies `dual_unit_iso` might still be a sorry — it is NOT. **Minor stale comment** (inside the embedded planner strategy, not in the declaration name/signature; says "if needed" which is vacuously consistent, but could mislead future provers). Should be updated to note it is closed.
  - **`erw [reassoc_of% hm, hNR]` in `homLocalSection.naturality` (L402):** Used to bridge the `PresheafOfModules`-level composition across the pushforward carrier. Axiom-clean but fragile. **Flagged for polish pass.**
  - **Warm-context warning (L200-216):** References "iter-230 C-wiring diagnostic" and "progress-critic pc251" by iteration number — accurate historical navigation aids, not actively misleading.

---

## Must-fix-this-iter

None.

No declaration has: a weakened/wrong definition, an excuse-comment claiming wrong code works, a `sorry` hidden behind an over-claiming `\leanok`-implying header, or an unauthorized axiom on a non-trivial claim.

The two sorry residuals the prover claims to have correctly labeled (`dual_isLocallyTrivial` as TRANSITIVELY PARTIAL, `dual_restrict_iso` as PARTIAL) are verified accurate. D2′ is confirmed sorry-free and axiom-clean as claimed.

---

## Major

None.

---

## Minor

- `TensorObjSubstrate.lean:1657` — `set_option backward.isDefEq.respectTransparency false in` scoped around `epsilonPresheafToSheafUnit`. Non-standard defeq-transparency option; axiom-clean but fragile against future Lean/Mathlib elaboration changes. Polish-pass candidate.
- `TensorObjSubstrate.lean:1771,1789,1833,1837-1838` — `erw`-heavy chain in `pullbackEtaUnitSquare`. Documented as necessary for carrier-spelling defeq gaps. Axiom-clean. Polish-pass candidate.
- `TensorObjSubstrate.lean:1694,1736,1872,1909` — `set_option maxHeartbeats 1600000` / `3200000` at four sites. Performance-tuned, not semantically wrong. Worth monitoring if Mathlib pin changes.
- `TensorObjSubstrate.lean:1986` — "Next iter:" annotation inside the sorry-guarded element-level residual of `sheafifyTensorUnitIso_hom_natural`. Honest strategy documentation (sorry IS present), but will become stale once the sorry closes.
- `DualInverse.lean:322-323` — Planner note "The `dual_unit_iso` is a missing sub-lemma; the prover may need to build it inline or as a separate declaration (it is a small sorry if needed, NOT blocked)." Stale: `dual_unit_iso` is now axiom-clean at L274-279. Should be updated to reflect closure.
- `DualInverse.lean:402` — `erw [reassoc_of% hm, hNR]` in `homLocalSection.naturality`. Documented carrier-friction bridge. Axiom-clean. Polish-pass candidate.

---

## Excuse-comments (always called out separately)

None. No comment in either file claims that wrong/placeholder/temporary code is acceptable or working. The sorry-guarded residuals are all honestly labeled and their docstrings/headers accurately reflect the incomplete state.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: Both files are in an honest state — module headers accurately reflect the sorry count (3 in TensorObjSubstrate.lean, 2 in DualInverse.lean), the D2′ "CLOSED axiom-clean" claim is verified, the two prover-claimed fixes (TRANSITIVELY PARTIAL relabeling and Uses inconsistency at ~L288) are confirmed, `homLocalSection` is a genuine axiom-clean construction, and `homOfLocalCompat` is a genuine (not laundered) scaffold. The six minor findings are polishing items (fragile proof options, stale planning annotation, erw patterns) with no semantic impact on correctness.
