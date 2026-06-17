# Lean Audit Report

## Slug
ts245

## Iteration
245

## Scope
- files audited: 1 (directive-specified)
- files skipped: 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 3 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (axiom-clean but off the active route)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:

  **Focus area 1 — new `section LocTrivPullbackTensor` (≈ L1306–L1372)**

  - L1312–L1323 (`isIso_sheafify_tensorHom_pullbackValIso`, private): **genuine proof**. No `sorry`, no `admit`. The proof constructs a `Functor.mapIso` of a `tensorIso` (both isomorphisms by construction) and closes with `.isIso_hom`. Sound.

  - L1335–L1352 (`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`): **genuine proof**. No `sorry`. The proof `unfold pullbackTensorMap` + `extract_lets` + `IsIso.comp_isIso'` chain correctly handles the four-factor composite: factors 1, 3, 4 are closed unconditionally (`inferInstance` on `Iso.hom` + the private helper for factor 4), and factor 2 (the sheafified δ) is supplied by `h`. The hypothesis `h` is a **real obligation** — it faithfully isolates the sole remaining content. It is not a disguised escape hatch: the other three factors are genuinely covered by the proof, not just assumed away.

  - L1354–L1371 (handoff comment block `/-! D2' onward — handoff -/`): **accurate but forward-looking**. The comment correctly characterises what remains (D2' = η-bridge, D3' = δ-commutativity with open-immersion base-change, D4' = chart-chase). It is honest about what is NOT yet built ("that identification is a sheafification-mate bridge ... NOT yet built"; "the sole genuinely-new mate calculus"). One speculative sub-claim: "`(SheafOfModules.unit _).val = 𝟙_`, `rfl`" — this definitional equality is asserted without verification in the comment; if false, D2' would not reduce as described. Minor.

  **Focus area 2 — pre-existing `sorry` bodies**

  - L672–L694 (`exists_tensorObj_inverse := sorry`): The surrounding docstring (L647–L671) and body comment (L676–L693) are **honest**. The comment names the two missing bridges (C: `dual_isLocallyTrivial`; A: `homOfLocalCompat`), correctly marks the FORBIDDEN shortcut as a dead end, and makes no "temporary" or "will-fix" claim. No excuse-comment. This is a load-bearing claim (`:= sorry` on a substantive lemma) — must-fix per policy.

  - L1403–L1406 (`addCommGroup_via_tensorObj := sorry`): The docstring (L1381–L1401) is honest — "iter-202 Lane TS scaffold: typed `sorry`", "iter-204+ closure target", "once this body lands, the RPF instance closes against it." No excuse language. This is the main closure target for the whole consumer chain — must-fix per policy.

  **Focus area 3 — stale comments referencing the abandoned general strong-monoidal pullback build**

  - L1232–L1235 (section header of `PullbackLanDecomposition`): **Stale.** Describes D1 as "the first, most self-contained brick of the committed general strong-monoidal pullback build (`sec:tensorobj_pullback_monoidality`)" and says `extendScalars`/`pullback₀` are "the carriers on which D2 (scalar half strong) and D3 (topological half, the filtered-colimit/⊗ interchange) are stated." Per the iter-245 pivot, the general strong-monoidal pullback build is **unnecessary** — the active route is the loc-triv chart-chase (D2'/D3'/D4', new section `LocTrivPullbackTensor`). The D2/D3 carriers are no longer on the critical path. This header actively misleads a reader into continuing the abandoned general route.

  - L1167–L1173 (Phase 2 status comment, conclusion): **Stale.** The concluding sentence "iso-ness is genuine geometric content requiring the concrete model" was accurate before the iter-245 pivot. With the loc-triv chart-chase route (D3'/D4'), iso-ness on line bundles is obtained **without** the concrete inverse-image model, by pulling back to trivialising charts where δ = identity or reduces to the unit comparison. The sentence now actively misleads about what is geometrically required.

  **Focus area 4 — general: dead-end proofs, suspect defs, bad practices**

  - L861–L988 (`pullbackObjUnitToUnit_comp`): Axiom-clean genuine proof of a correct lemma. However, it is **not consumed anywhere in this file** (the section note at L990–1013 explicitly says it was declared unnecessary for `pullbackUnitIso`; it is retained "for the harder Phase-2 tensor comparison"). With the iter-245 loc-triv pivot abandoning Phase-2 (general `f`), this lemma is potentially dead-end within the active route. The D2' handoff comment refers to "the sole genuinely-new mate calculus, *analog* of `pullbackObjUnitToUnit_comp`" — meaning D3' needs a NEW lemma of the same style, not `pullbackObjUnitToUnit_comp` itself. Retaining it is low-risk (axiom-clean, valid math) but the section note at L990–1013 should be updated to reflect the iter-245 status.

  - L1237–L1298 (declarations `pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction`, `pullbackLanDecomposition`): All axiom-clean and mathematically correct. With the iter-245 pivot, however, none of these are on the D2'/D3'/D4' critical path (the loc-triv chart-chase uses `isIso_of_isIso_restrict` + naturality of δ, not the Lan decomposition). These declarations were committed iter-244 for the now-abandoned general route. They are not harmful (no sorry, no wrong def) but may accumulate as dead-end code.

  - L100–L113 (sub-module layout comment, "iter-232 split"): Claims the monolith was split into "three files." The actual imports (L6–L9) include a fourth file `AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor`, not listed in the comment. Minor stale comment.

  - L1354–L1371 (handoff comment, D2' sub-claim): The comment states `(SheafOfModules.unit _).val = 𝟙_` reduces by `rfl`. This is a load-bearing definitional equality for the D2' reduction to `IsIso (a_Y.map (η (pullback φ')))`. It is asserted in a comment without being proven in code. If this `rfl` does not hold, the entire D2' sketch is wrong. Minor but worth noting.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:694` — `exists_tensorObj_inverse := sorry`. Load-bearing claim (existence of tensor inverse for every line bundle); the surrounding comment is honestly documenting two named missing bridges (C, A), no excuse language, but `:= sorry` on a substantive claim is must-fix per policy regardless of commentary quality.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1406` — `addCommGroup_via_tensorObj := sorry`. The main consumer closure target for the whole A.1.c.SubT chain; downstream `RelPicFunctor.lean:L235` depends on it. No excuse-comments; but `:= sorry` on the load-bearing claim is must-fix per policy.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1232–1235` — `PullbackLanDecomposition` section header calls D1 "the first, most self-contained brick of the **committed** general strong-monoidal pullback build" and identifies D2/D3 carriers. Stale per iter-245 pivot to loc-triv chart-chase; the general build is no longer on the critical path. A reader or agent following this comment would pursue D2/D3 (old route) instead of D2'/D3'/D4' (active route). Should be updated to say the D1 declarations are axiom-clean but the general build is superseded by the loc-triv route.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1167–1173` — Phase 2 comment concludes "iso-ness is genuine geometric content requiring the concrete model." Stale per iter-245 loc-triv pivot; for line bundles, D3'/D4' obtain iso-ness via chart-chase without the concrete inverse-image model. This sentence actively contradicts the active strategy.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:861–988` — `pullbackObjUnitToUnit_comp` is defined but not consumed in this file. The retaining comment ("of independent use for the harder Phase-2 tensor comparison") is now stale with the iter-245 loc-triv pivot. The proof is valid; the issue is the section note at L990–L1013 needs updating.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1237–1298` — `pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction`, `pullbackLanDecomposition` are axiom-clean and valid but appear dead-end with respect to the current D2'/D3'/D4' route. No corrective action needed if the loc-triv pivot comment above (major) is fixed; flagged for awareness.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:100–113` — Sub-module layout comment says "three files" in the iter-232 split, but imports include a fourth (`StalkTensor`). Stale header.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1361` — Handoff comment asserts `(SheafOfModules.unit _).val = 𝟙_` reduces by `rfl` as a step in the D2' sketch. This is unverified in code; if false, the D2' sketch is incorrect.

---

## Excuse-comments (always called out separately)

None. Both pre-existing `sorry` bodies are accompanied by honest, detailed status comments that accurately name the missing pieces and flag dead ends. No "temporary," "will fix," "placeholder," or "TODO replace" language found anywhere in the file.

---

## Severity summary

- **must-fix-this-iter**: 2 — both pre-existing `sorry` bodies on load-bearing claims (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`); honestly documented, no excuse-comments, but policy mandates must-fix classification.
- **major**: 2 — stale route comments actively misleading about the current active strategy (D1 section header, Phase 2 "concrete model required" conclusion).
- **minor**: 4 — `pullbackObjUnitToUnit_comp` dead-end; D1 declarations off active path; sub-module layout comment counts wrong; handoff D2' `rfl` claim unverified.
- **excuse-comments**: 0

**Overall verdict**: The two new declarations in `LocTrivPullbackTensor` are genuine axiom-clean proofs and the handoff comment is honest; the two pre-existing `sorry` bodies are honestly documented; the file's main weaknesses are two major stale comment blocks that actively describe the abandoned general strong-monoidal build as the current route, contradicting the iter-245 loc-triv pivot.
