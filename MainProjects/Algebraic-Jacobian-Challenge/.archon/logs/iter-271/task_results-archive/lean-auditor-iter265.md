# Lean Audit Report

## Slug
iter265

## Iteration
265

## Scope
- files audited: 3 (per directive — focused audit of the three edited files)
- files skipped (per directive): all others — focus scope specified

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L289–302 — comment references removed decls by name in description text.** The block describing the `pushPullMap_comp` note mentions the "augmentation-naturality warm-up `pushPullMap_unit`" and the removed `pushforward_unit_eqToHom` private helper. These are described as removed/abandoned, not as existing declarations. Grep confirms no dangling code references to either name; the text is purely historical context. The language "the warm-up `pushPullMap_unit`... reduces — via `pushPull_unit_mate`..." reads slightly as if `pushPullMap_unit` still exists; a reader would need to reach "but the final `eqToHom` step hits a kernel `whnf` blow-up" to understand it was abandoned. **Minor** — no code hazard; a short "removed" clarifier would help.
  - **L36–54 — header "six main declarations" list omits `pushPull_unit_mate`.** The listed declarations are the six blueprint-pinned ones; the infrastructure helpers (`coverArrow`, `coverCechNerve`, `pushPullObj`, `pushPullMap`, `pushPullMap_id`, `pushPull_unit_mate`, `relativeCechComplexOfNerve`) are not listed. The omission is consistent with the header's design (only blueprint-declared items) but leaves the new axiom-clean `pushPull_unit_mate` unmentioned. **Minor** — no semantic problem.
  - **Four honest `sorry`s** (lines 97, 404, 441, 503) in `CechNerve`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`. Each has a detailed comment explaining the Mathlib-absent ingredient. None are excuse-comments.
  - **`pushPull_unit_mate` (lines 313–331) — axiom-clean, statement matches description.** LHS = η_p ≫ (pushforward p).map η_f ≫ pushforwardComp f p; RHS = η_{f≫p} ≫ (pushforward (f≫p)).map (pullbackComp f p).inv. Proof routes through `unit_conjugateEquiv`, `conjugateEquiv_pullbackComp_inv`, and `Adjunction.comp_unit_app`, then closes with `simpa`. Semantically correct; name "mate" is appropriate (standard project usage for adjunction-mate identity).
  - **`pushPullMap` definition (lines 175–187) — carries two `eqToHom` transports** along `Over.w g`. This is by design (the known kernel whnf obstacle for `pushPullMap_comp`). Not a definition error; documented in the comment.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L43–50 — header sorry-tracking comment: wrong declaration name for residual (b).** The header says "THREE tracked typed-`sorry` residuals (iter-262): ... (b) the D3′ Sq1 sub-lemma `sheafificationCompPullback_comp`". But `sheafificationCompPullback_comp` (L2651–2748) now has NO sorry: the remaining sorry was EXTRACTED to the new helper `sheafificationCompPullback_comp_tail` (L2636, line 2638). A prover reading the header and searching `sheafificationCompPullback_comp` for the sorry will not find it. The actual sorry count (3) is correct. The iter-262 label and the name in (b) are both stale. **Major** — wrong file:decl pointer for an active sorry.
  - **L43 — "iter-262" label for the THREE-sorry tracking block.** This was set when the three sorries were first established; they remain 3 (lines 720, 2638, 2866). The count is still valid but the epoch label makes it look like the description is frozen in iter-262 state, when in fact (b)'s sorry has migrated to a new helper in subsequent iters. Covered by the finding above.
  - **`forget_map_pushforward_map` (L2511–2519) — `private lemma`, proven by `rfl`.** Docstring correctly states the equality is definitional. Appropriately private. Clean.
  - **`sheafificationCompPullback_comp_tail` (L2536–2638) — extracted sorry-carrying helper.** Docstring and extensive in-proof comments accurately describe the residual. The proof contains valid structural steps: `rw [restrictScalarsId_map]`, `conv_rhs => rw [Functor.map_comp]`, `erw [forget_map_pushforward_map]`, `rw [Functor.map_comp]`, then `sorry`. The comment at L2609–2612 (the `erw`-vs-`rw` contamination note, "verified iter-265 contamination") is fresh and accurate. The sorry is the genuine `hinner`/`hcomp'`-twin residual. No excuse-comment — the todo is precisely described.
  - **Three `sorry`s in the file** (lines 720 `exists_tensorObj_inverse`, 2638 `sheafificationCompPullback_comp_tail`, 2866 `pullbackTensorMap_restrict`). All three are honestly documented.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L408–428 — in-body "BLOCKER" comment for `map_smul'` is stale.** Lines 425–428 say "BLOCKER: the RHS `(toFun-section).hom z` is a `{app := …}.app W` PROJECTION... closing (ii) needs a `conv`/`change` that survives the projection (next fine-grained pass)." But the ACTUAL code immediately following (line 448: `conv_rhs => arg 2; change ...`) IS that `conv`/`change`. The `map_smul'` field is CLOSED (iter-264, as the header correctly records). The in-body BLOCKER description was written in iter-263 and not updated when the solution was found in iter-264. A reader will encounter the "BLOCKER: ... next fine-grained pass" language followed by working code, which is confusing. **Minor** — misleading but the code is correct.
  - **File header (L22–40) is well-updated.** Correctly records: leg-B closed (iter-262), map_add' closed (iter-263), map_smul' closed (iter-264), 4 remaining sorries (naturality, invFun, left_inv, right_inv). The "PARTIAL (iter-262)" label for `sliceDualTransport` records the start of construction, not a claim about the current state; subsequent progress is listed. No semantic inaccuracy.
  - **Five `sorry`s** in DualInverse.lean: lines 393 (naturality), 483 (invFun), 486 (left_inv), 488 (right_inv) inside `sliceDualTransport`, and line 619 inside `dual_restrict_iso` (the `isoMk` naturality square). All are honestly documented.
  - **`dualUnitRingSwapInv` (L208–213) — semantically correct.** Returns `Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (f.appIso W').inv.hom)`, which is the morphism that `dualUnitRingSwap` (= `inv ε`) inverts. Types check: domain is `𝟙_(ModuleCat 𝒪_Y(W'))`, codomain is the `restrictScalars (…inv.hom)` image of `𝟙_(ModuleCat 𝒪_X(fW'))`. Correct direction for a section of `dualUnitRingSwap`.
  - **`dualUnitRingSwapInv_comp_dualUnitRingSwap` and `dualUnitRingSwap_comp_dualUnitRingSwapInv` (L217–229) — correct cancellation pair.** Both `@[simp]`-tagged. Proofs instantiate `isIso_ε_restrictScalars_appIso f W'` and invoke `simp [dualUnitRingSwapInv, dualUnitRingSwap]`, which unfolds to `ε ≫ inv ε = 𝟙` and `inv ε ≫ ε = 𝟙` respectively, both dischargeable by `IsIso.inv_hom_id` / `IsIso.hom_inv_id`. Correct.
  - **`isIso_ε_restrictScalars_appIso_hom` (L237–242) — correctly distinguished from the `.inv` variant.** Applies `restrictScalars_isIso_ε_of_bijective` with `(f.appIso W').hom.hom` and `bijective_of_isIso (f.appIso W').hom`. The `.hom` here refers to the `.hom` leg of the appIso (vs `.inv` in the existing `isIso_ε_restrictScalars_appIso`). Semantically sound.
  - **`dualUnitRingSwapHom` (L249–256) — type checks for the `invFun` recipe.** Returns `inv (ε (restrictScalars (f.appIso W').hom.hom))`, mapping `(restrictScalars (f.appIso W').hom.hom).obj 𝟙_Y(W') ⟶ 𝟙_X(fW')`. Matches the invFun component recipe at L463–478 (the "SHARPENED RECIPE iter-265" block). Correctly named: "Hom" distinguishes the `.hom`-direction from `dualUnitRingSwap` which uses `.inv`.
  - **`sliceDualTransport` invFun comment (L463–482) — updated this iter, accurate.** Documents the `eqToHom`-transport assembly for invFun, references the new helpers. The "direction fix, supersedes the prior 'ε itself not inv ε' gloss" note is accurate. The sorry at line 483 is genuine (the eqToHom-telescope + image_preimage_of_le assembly not yet executed).

---

## Must-fix-this-iter

None.

(None of the new declarations are vacuous, mis-typed, wrong-definition, or excuse-commented. The sorry placements are honest and documented. No axioms on substantive claims beyond already-authorized sorries.)

---

## Major

- `TensorObjSubstrate.lean:43–50` — Header sorry-tracking description (b) names `sheafificationCompPullback_comp` as the location of the sorry, but that declaration is now sorry-free; the sorry lives in the extracted helper `sheafificationCompPullback_comp_tail` (L2638). A prover acting on the header description would look in the wrong declaration. The sorry count (THREE) is correct; the declaration name in (b) needs updating to `sheafificationCompPullback_comp_tail`.

---

## Minor

- `CechHigherDirectImage.lean:293–297` — Comment mentions removed declarations `pushPullMap_unit` and `pushforward_unit_eqToHom` as part of historical context without flagging them as removed in-text. No code hazard; a short clarifier "(removed)" would prevent misreading.
- `DualInverse.lean:425–428` — In-body BLOCKER comment for `map_smul'` ("needs a `conv`/`change` ... next fine-grained pass") is stale: the `conv_rhs => arg 2; change` solution was found and applied in iter-264; `map_smul'` is closed. Reader sees "BLOCKER" followed by working code.

---

## Excuse-comments (always called out separately)

None found. All `sorry`s have honest explanatory comments describing the missing Mathlib ingredient or the remaining mate-calculus step, rather than placeholder or "will fix later" language.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: Three files are in good shape — all new declarations are axiom-clean, types and docstrings match, and the sorry placements are honest. One major stale comment (the header in TensorObjSubstrate.lean misidentifies which declaration holds the Sq1 sorry) and two minor stale-comment issues; no wrong definitions or excuse-comments.
