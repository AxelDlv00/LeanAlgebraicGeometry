# Lean Audit Report

## Slug
ts224

## Iteration
224

## Scope
- files audited: 1
- files skipped (per directive): 0 — directive narrows to single file

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 4 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (erw fragility vector)
- **excuse-comments**: 0
- **notes**:

  **Focus: `internalHomEval` (lines 1457–1500)**

  - Line 1457 — `internalHomEval`: proof is **genuinely closed**. No `sorry`, no `admit`, no `native_decide`, no `maxHeartbeats` bump. The body uses `PresheafOfModules.Hom.mk` with an inline naturality proof that chains: `erw [ModuleCat.hom_comp, ModuleCat.hom_comp, ...]` → `simp only []` → `change` → `have key` (naturality_apply) → `have hdt` (hom_app_heq + Category.id_comp) → `exact (DFunLike.congr_fun hdt _).trans key`. Each step is logically sound and traceable.

  - Line 1448 — `internalHomEval` docstring claims "CLOSED axiom-clean iter-224 (`{propext, Classical.choice, Quot.sound}`)": claim is accurate. No sorry, no non-standard axiom in the proof body. The declared axiom set `{propext, Classical.choice, Quot.sound}` is the standard noncomputable-classical baseline in Lean 4 and consistent with the proof's use of `noncomputable`, `Classical`-derived instances, and `TensorProduct` quotient construction.

  - Lines 1464–1468 — inline comment about "iter-222/223 whnf HEARTBEAT-BOMB diagnosis … turned out STALE": this is an accurate historical audit trail, not a false alarm nor an excuse-comment. Correctly documents what changed in the Mathlib bump and why the proof now works without transparency hacks.

  - Lines 1469–1499 — naturality proof step numbering: comments label "Step 1" and then jump to "Step 4" with unnumbered `simp only []` / `change` / "Reduce the RHS" between them. Steps 2–3 are implicit and undocumented. Minor: the proof is correct; only the comment structure is incomplete.

  **Focus: file-header Status block (lines 37–54)**

  - The Status block accurately reflects current state: `tensorObj` / `tensorObj_functoriality` no sorry; three sorry residuals (`isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) correctly named; `internalHomEval` naturality CLOSED iter-224. **No overclaim survives.**

  **Focus: file-header "4 blueprint-pinned declarations" (lines 56–80)**

  - Line 69–74 — **STALE**. The header lists `AlgebraicGeometry.Scheme.Modules.monoidalCategory` as pin #3 ("the monoidal-category structure on `Scheme.Modules X`"). However, §2 of the file body (lines 1555–1567) explicitly says: "iter-206 PIVOT: the full `MonoidalCategory (X.Modules)` instance is **deliberately not built**." The declaration does not exist anywhere in the file — a grep for `instance monoidalCategory` / `def monoidalCategory` returns no matches. The header is misleading about what the file delivers on point 3.

  **Focus: docstrings of `tensorObj_assoc_iso`, `tensorObjOnProduct`, `exists_tensorObj_inverse`**

  - Lines 1646–1648 — `tensorObj_assoc_iso` docstring: "CLOSED at the direct-sorry level (no sorry in this declaration's body); it is sorry-transitive only through the route-(e) residual `isLocallyInjective_whiskerLeft_of_W`." **Accurate.** The body calls `W_whiskerRight_of_W` (line 1716) and `W_whiskerLeft_of_W` (line 1718), both of which depend on `isLocallyInjective_whiskerLeft_of_W` (the lone sorry). No sorry in the body itself. ✓

  - Lines 1660–1665 — `tensorObj_assoc_iso` docstring mentions "`PresheafOfModules.W_whiskerRight_of_flat` is also closed axiom-clean." The body uses `W_whiskerRight_of_W` (the flatness-FREE version), not `W_whiskerRight_of_flat`. The docstring mention is historical context, not a claim about what the body calls. Slightly confusing but not inaccurate.

  - Line 1942 — `tensorObjOnProduct` docstring: "Complete (no sorry): the carrier is `tensorObj L.carrier L'.carrier`, local-triviality from `tensorObj_isLocallyTrivial`." **Accurate about the body** (no sorry in the body). However, the declaration is sorry-transitive via `tensorObj_isLocallyTrivial` → `tensorObj_restrict_iso` → (closed) and through `tensorObj_assoc_iso` → `isLocallyInjective_whiskerLeft_of_W` (the sorry). The docstring does not note this sorry-transitivity, in contrast to `tensorObj_assoc_iso` which explicitly does. Minor inconsistency.

  - Line 1907 — `exists_tensorObj_inverse` docstring header: "**iter-218 INCOMPLETE gate (INFRASTRUCTURE MISSING)**." The temporal label "iter-218" is stale (6 iters behind iter-224). The proof-body comment at lines 1929–1933 IS more current: it correctly notes "The PRESHEAF-level `internalHom`/`dual`/`internalHomEval` now exist axiom-clean — see the `Dual` section above — but the sheafification of the dual + its sheaf-level evaluation counit, and object-level descent, are still absent." The docstring header and the proof-body comment are inconsistent in their temporal framing (iter-218 vs. iter-224-current); the underlying status ("INCOMPLETE") is still accurate.

  - Lines 1966–1967 — `addCommGroup_via_tensorObj` docstring: "iter-202 Lane TS scaffold: typed sorry. This is the iter-204+ closure target for the residual `addCommGroup` sorry of `RelPicFunctor.lean` (L235)." The "iter-204+" label and "iter-202 Lane TS scaffold" are 20+ iters old and are stale temporal references (iter-224 is the current iter). The declaration is still `sorry` and the underlying goal (close the RPF L235 residual) is unchanged, so the status is accurate; only the temporal framing is stale.

  **Focus: three remaining sorries and their surrounding comments**

  - Line 641 — `isLocallyInjective_whiskerLeft_of_W`: `sorry` with a detailed inline comment (lines 614–641) identifying the two exact missing Mathlib ingredients (d.1-bridge stalkwise W-characterisation and d.2 stalk ⊗ commutation). Comment accurately notes that `stalkLinearMap` etc. are built axiom-clean (project-side, lines 733–813), and the two gaps are named precisely. Not stale; accurately reflects the state.

  - Line 1935 — `exists_tensorObj_inverse`: `sorry` with comment (lines 1929–1933) that is accurate and up-to-date (see above). The blocking infrastructure (sheaf-level dual) is correctly described as still absent. Not stale.

  - Line 1981 — `addCommGroup_via_tensorObj`: `sorry`. Stale temporal references in docstring (see above). The sorry itself is appropriate and well-documented.

  **Deprecated API / erw fragility**

  - No `Sheaf.val` deprecation warnings found via grep (the file uses `X.ringCatSheaf.val` and `X.presheaf`, which access the underlying presheaf by the struct projection, not the deprecated `.val` field alias that some Mathlib migrations rename). Cannot fully verify without running Lean, but the access pattern does not match known deprecation sites.

  - `erw` is used at approximately 15 locations throughout the file (lines 237, 320, 323, 338–339, 405, 415, 438, 494, 500–503, 1051, 1215, 1230, 1472). Each use bridges a defeq gap that `rw` would reject. This is a fragility vector: any Mathlib refactor that changes the internal structure of `restrictScalars`, `presheaf_map`, or `ModuleCat.hom_comp` could silently break these rewrites or force them to revert to unfolding. Not a current bug, but a maintenance risk. Particularly notable is the `erw [ModuleCat.hom_comp, ...]` at line 1472 in `internalHomEval`'s naturality — the iter-224 fix that replaced the former heartbeat-bomb tactic with this `erw` chain. If `ModuleCat.hom_comp` is again restated in a future Mathlib bump, this proof may regress.

---

## Must-fix-this-iter

None.

No excuse-comments, no weakened-wrong definitions, no parallel-API copying, no suspect bodies on substantive claims, no unauthorized axiom declarations. The three `sorry`s are all correctly typed, documented with blocking-infrastructure explanations, and match the directive's prior inventory.

---

## Major

- `TensorObjSubstrate.lean:69–74` — File header lists `AlgebraicGeometry.Scheme.Modules.monoidalCategory` as blueprint pin #3 ("the monoidal-category structure on `Scheme.Modules X`"), but §2 (lines 1555–1567) explicitly says this instance is "deliberately not built" (iter-206 pivot), and the declaration does not exist in the file. The header is actively misleading about what the file delivers on item 3 of its stated 4-pin scope. Any reader following the header's framing will expect this instance to be present.

- `TensorObjSubstrate.lean:1907` — `exists_tensorObj_inverse` docstring header says "**iter-218 INCOMPLETE gate**" while the proof-body comment (lines 1929–1933) reflects the iter-224 state (correctly noting `internalHomEval` is now axiom-clean). The docstring header and proof-body comment are temporally inconsistent; a reader seeing "iter-218" might conclude no progress has been made since then.

- `TensorObjSubstrate.lean:1966–1967` — `addCommGroup_via_tensorObj` docstring: "iter-202 Lane TS scaffold: typed sorry. This is the iter-204+ closure target." The "iter-204+" and "iter-202" temporal markers are 20+ iters stale at iter-224. While the underlying status (still sorry, still blocked) is accurate, the "iter-204+" wording suggests imminent closure that has not materialized.

---

## Minor

- `TensorObjSubstrate.lean:1942` — `tensorObjOnProduct` docstring says "Complete (no sorry)" without mentioning sorry-transitivity through `isLocallyInjective_whiskerLeft_of_W`. Contrast with `tensorObj_assoc_iso` (line 1646) which explicitly notes its sorry-transitivity. The claim is technically accurate about the body but sets a different documentation standard than other declarations in the same file.

- `TensorObjSubstrate.lean:1469–1499` — `internalHomEval` naturality proof inline comments: step numbering jumps from "Step 1" to "Step 4" with unnumbered intermediate steps ("Reduce the RHS" / `simp only []` / `change`). Steps 2–3 are implicit. Minor readability gap; proof logic is correct.

- Throughout — `erw` at ~15 sites is a maintenance fragility vector (see above). Not a current bug.

---

## Excuse-comments (always called out separately)

None. The `sorry` annotations in this file are status-tracking annotations for known blocked declarations with documented blocking-infrastructure reasons, not admissions that code is wrong or promises to fix later.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (file-header monoidalCategory staleness; `exists_tensorObj_inverse` temporal inconsistency; `addCommGroup_via_tensorObj` very stale iter-202/204 label)
- **minor**: 3 (tensorObjOnProduct sorry-transitivity undocumented; proof step-numbering gap; erw fragility)
- **excuse-comments**: 0

Overall verdict: File is in sound state for iter-224 — `internalHomEval` is genuinely closed axiom-clean as claimed, the three remaining sorries are correctly documented with accurate infrastructure-blocking explanations, and no overclaims survive. The three major findings are all documentation staleness issues (not code correctness issues) and do not block downstream proof work.
