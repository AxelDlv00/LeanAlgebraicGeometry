# Lean Audit Report

## Slug
ts217

## Iteration
217

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 5 flagged
- **suspect definitions**: 3 flagged (3 remaining sorry bodies)
- **dead-end proofs**: 0 (all new declarations have genuine proofs; `tensorObj_restrict_iso` is axiom-clean)
- **bad practices**: 19 flagged (17× deprecated `Sheaf.val`, `inferInstanceAs` bridge, `set_option backward.isDefEq.respectTransparency false`)
- **excuse-comments**: 2 flagged (on `exists_tensorObj_inverse` and `addCommGroup_via_tensorObj`)
- **notes**:

  **Axiom verification (LSP-confirmed):**
  - `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso`: axioms = `{propext, Classical.choice, Quot.sound}`. No `sorry` in the axiom closure. **Genuinely closed.**
  - `PresheafOfModules.pushforwardPushforwardAdj`: same axiom set — clean.
  - `PresheafOfModules.restrictScalarsMonoidalOfBijective`: same axiom set — clean.
  - File compiles with **0 errors**.

  **Closure proof of `tensorObj_restrict_iso` (L1259–1336) — detailed:**
  - No `sorry`, `admit`, `native_decide`, or axiom-level weakening anywhere in the proof body.
  - The `@[implicit_reducible]` attribute does NOT appear on `tensorObj_restrict_iso` itself.
  - Step 1 (`restrictFunctorIsoPullback`), Step 2 (`sheafificationCompPullback`), Step 3 (`.mapIso`), Step 4 (H1 + H2) all route through genuine Lean/Mathlib terms.
  - H1 (L1309–1313): Uses newly-built `pushforwardPushforwardAdj` (axiom-clean) + `Adjunction.leftAdjointUniq` (Mathlib).
  - H2 (L1322–1336): Uses `restrictScalarsMonoidalOfBijective` (axiom-clean) + `Functor.Monoidal.μIso` (Mathlib).
  - The `let`-binding design (L1302–1307, φR/α/β) is intentional (comment at L1299–1301: prevents `adj.unit` opacity) — not a fragile trick.
  - `lean_verify` flagged the word "opaque" at L1301: this is a **false positive** — the word appears inside a comment describing why `let` is used rather than `have`, not in actual proof code.

  **New declarations (all 5 + 5 simp lemmas) — statements honest, proofs real:**
  - `pushforwardNatTrans` (L840): statement is correct (α : F⟶G induces pushforward nat-trans). Body assembles component sectionwise and checks naturality — real. Simp lemma `_app_app_apply` proven by `rfl` (definitionally true).
  - `pushforwardCongr` (L871): isomorphism between pushforwards along equal morphisms, via `NatIso.ofComponents`. Simp lemmas `_hom_app_app` / `_inv_app_app` proven by `subst e; rfl` — real.
  - `pushforwardPushforwardAdj` (L908): presheaf-level adjunction. Unit/counit assembled from `pushforwardNatTrans` + `pushforwardCongr`. Triangle identities verified (L915–927) by sectionwise computation + `adj.left_triangle_components` / `adj.right_triangle_components`. No sorry.
  - `isIso_of_isIso_app` (L940): sectionwise-iso → global-iso via `isoMk`. Real proof using `PresheafOfModules.hom_ext`. Correct statement.
  - `restrictScalarsMonoidalOfBijective` (L958): strong-monoidal structure on `restrictScalars α` when sectionwise-bijective. Routes through `isIso_of_isIso_app` (above) + `restrictScalars_isIso_{μ,ε}_of_bijective` (L266–279, clean) + `Functor.Monoidal.ofLaxMonoidal`. Real.

  **Three remaining sorries:**
  - L632 (`isLocallyInjective_whiskerLeft_of_W`): Acknowledged residual with detailed mathematical commentary (gaps d.1-bridge and d.2). Comment is accurate and non-misleading. But the sorry body on a substantive claim is still must-fix per rules.
  - L1379 (`exists_tensorObj_inverse`): sorry body. Has excuse-comment "iter-202 Lane TS scaffold: typed `sorry`; the iter-203+ body builds...". We are at iter-217; the iter-203+ fix never arrived. Must-fix.
  - L1418 (`addCommGroup_via_tensorObj`): sorry body. Has excuse-comment "iter-202 Lane TS scaffold: typed `sorry`. This is the iter-204+ closure target...". Same — iter-217 now. Must-fix.

  **Stale docstrings:**
  - L987–991 (`tensorObj`): "the body is a typed `sorry`; the iter-203+ body lifts..." — body is NOT a sorry. The actual body (L992–995) uses real sheafification code. The comment falsely describes the code state.
  - L997–1007 (`tensorObj_functoriality`): "the body is a typed `sorry`; the iter-203+ body inherits..." — body is NOT a sorry. The actual body (L1008–1012) uses real sheafification code. Same false claim.
  - L37–85 (module docstring, Status block): says "iter-202 Lane TS — file-skeleton scaffold" and "each of the 4 pinned declarations carries...a `sorry` body". Now at iter-217: many declarations are closed (tensorObj, tensorObj_functoriality, tensorObj_assoc_iso, tensorObj_restrict_iso, and 5 new presheaf declarations). The status block is grossly outdated.
  - L1115–1116 (`tensorObj_assoc_iso` docstring): "iter-212 status (typed `sorry`; go/no-go bridge CLEARED, a NEW residual located)". This recorded the state at iter-212. The proof is now closed (iter-217). The status language is stale.

  **`@[implicit_reducible]` attribute:**
  - Appears at L252 (`restrictScalarsMonoidalOfRingEquiv`), L957 (`restrictScalarsMonoidalOfBijective`), L1414 (`addCommGroup_via_tensorObj`).
  - Not a standard Lean 4 core attribute (`@[reducible]`, `@[semireducible]`, `@[irreducible]` are the standards); presumably a Mathlib-defined attribute — no compiler warning about it being unknown, so it IS recognized.
  - **Does not appear on `tensorObj_restrict_iso`** — the closure proof is unaffected.
  - On L252 and L957 (genuine proofs): likely needed for the `Functor.Monoidal` instance to be unfolded during the `exact` at the end of `tensorObj_restrict_iso` — intentional, but non-standard and should be documented.
  - On L1414 (`addCommGroup_via_tensorObj`, sorry body): concerning. If `@[implicit_reducible]` makes the definition reducible for typeclass synthesis, a sorry-body `AddCommGroup` could propagate transparently. Since this is a `def` (not `instance`), it cannot be automatically synthesized, but the combination is still alarming and should be investigated.

  **Deprecated API warnings (LSP-confirmed):**
  - `CategoryTheory.Sheaf.val` has been deprecated in favor of `ObjectProperty.obj`. Warnings at: L993, L1010, L1055, L1072, L1074, L1084, L1086, L1094, L1096, L1104, L1162, L1165, L1170, L1189, L1191 — **17 call sites**. This is a systematic bad practice; the deprecated API should be replaced.

  **Unused hypothesis warning:**
  - L1153–1154 (`tensorObj_assoc_iso`): `hM`, `hN`, `hP` (the `IsLocallyTrivial` hypotheses) are unused in the proof (comment at L1158–1159 explains this is intentional — ROUTE (d) holds for arbitrary modules). The hypotheses are in the signature to match the blueprint pin. Not an excuse-comment (the proof is correct and stronger than needed), but the linter warns about unused variables. Minor.

  **Other linter issues:**
  - L309: `ext` did not consume pattern `r` in `restrictScalarsLaxε`. Minor.
  - L1317–1319: Three lines exceed 100-character limit. Minor.

---

## Must-fix-this-iter

- `TensorObjSubstrate.lean:632` — `:= sorry` on `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`. Substantive claim (the stalkwise injectivity argument for the associator). Why must-fix: sorry body on a substantive, non-trivial statement; the comment is mathematically honest about the gaps but the code is still wrong.

- `TensorObjSubstrate.lean:1375–1379` — `:= sorry` on `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`, with excuse-comment "iter-202 Lane TS scaffold: typed `sorry`; the iter-203+ body builds the dual and the contraction isomorphism" (we are at iter-217). Why must-fix: sorry on a substantive claim (existence of tensor inverse for line bundles) + explicit "will fix in iter-203+" that never arrived.

- `TensorObjSubstrate.lean:1415–1418` — `:= sorry` on `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj`, with excuse-comment "iter-202 Lane TS scaffold: typed `sorry`. This is the iter-204+ closure target..." (we are at iter-217). Why must-fix: sorry on the named closure target for the residual `addCommGroup` sorry; also `@[implicit_reducible]` on a sorry body.

---

## Major

- `TensorObjSubstrate.lean:37–85` — Module docstring Status block says "iter-202 Lane TS — file-skeleton scaffold, each of the 4 pinned declarations carries a `sorry` body". At iter-217: `tensorObj`, `tensorObj_functoriality`, `tensorObj_assoc_iso`, `tensorObj_restrict_iso` are all closed, and 5 new presheaf-level declarations were added. The status block actively misdescribes the file's current state.

- `TensorObjSubstrate.lean:987–991` — `tensorObj` docstring says "the body is a typed `sorry`; the iter-203+ body lifts `PresheafOfModules.Monoidal.tensorObj` through the sheafification functor". The actual body (L992–995) IS that sheafification lift — no sorry. The "body is a typed sorry" claim is false and could mislead developers into thinking this declaration is still open.

- `TensorObjSubstrate.lean:997–1007` — `tensorObj_functoriality` docstring says "the body is a typed `sorry`; the iter-203+ body inherits the morphism action from `PresheafOfModules.Monoidal.tensorObj` under sheafification". The actual body (L1008–1012) IS that action — no sorry. Same false claim as above.

- `TensorObjSubstrate.lean:1115–1116` — `tensorObj_assoc_iso` docstring says "iter-212 status (typed `sorry`; ...)". The proof is now closed. The stale "iter-212 status (typed sorry)" language could mislead.

- `TensorObjSubstrate.lean:1414` — `@[implicit_reducible]` on a sorry-body `def`. Non-standard attribute on an unsound definition. Even if the attribute is harmless for the `def` (since `def` ≠ `instance`), the combination creates opacity risk: anyone adding the `def` to an instance resolution chain could propagate the sorry transparently.

- `TensorObjSubstrate.lean:993,1010,1055,1072,1074,1084,1086,1094,1096,1104,1162,1165,1170,1189,1191` — 17 uses of deprecated `CategoryTheory.Sheaf.val` (Mathlib deprecated; should use `ObjectProperty.obj`). LSP-confirmed warnings. Systematic bad practice that will break when Mathlib removes the deprecated alias.

---

## Minor

- `TensorObjSubstrate.lean:252` — `@[implicit_reducible]` on `restrictScalarsMonoidalOfRingEquiv` (genuine proof). Non-standard Lean 4 attribute; appears intentional (needed for `Functor.Monoidal` instance unfolding in synthesis), but not standard and not documented as to which Mathlib module defines it.

- `TensorObjSubstrate.lean:957` — `@[implicit_reducible]` on `restrictScalarsMonoidalOfBijective` (genuine proof). Same concern as above.

- `TensorObjSubstrate.lean:1162` — `inferInstanceAs (MonoidalCategoryStruct ...)` defeq bridge between `Sheaf.val X.ringCatSheaf` and `X.presheaf ⋙ forget₂ CommRingCat RingCat`. The comment documents this as an `rfl`-defeq. Fragile: if either side's definition changes, this bridge silently breaks (kernel still accepts it, but further typing may fail). Acceptable given the comment, but worth noting.

- `TensorObjSubstrate.lean:300,316,901` — `set_option backward.isDefEq.respectTransparency false in` on `restrictScalarsLaxε`, `restrictScalarsLaxμ`, and `pushforwardPushforwardAdj`. Each is locally scoped, so the risk is bounded. Nonetheless, this option bypasses the normal transparency discipline and is a source of proof fragility if Mathlib changes the reducibility of any involved definition.

- `TensorObjSubstrate.lean:1153–1154` — Unused variables `hM`, `hN`, `hP` in `tensorObj_assoc_iso` (linter-warned; intentionally retained to match blueprint signature per comment at L1158–1159).

- `TensorObjSubstrate.lean:309` — `ext` did not consume pattern `r` in `restrictScalarsLaxε`. Linter warning; minor code smell.

- `TensorObjSubstrate.lean:1317–1319` — Three lines exceed the 100-character style limit. Minor.

---

## Excuse-comments (called out separately)

- `TensorObjSubstrate.lean:1367–1374`: "iter-202 Lane TS scaffold: typed `sorry`; the iter-203+ body builds the dual and the contraction isomorphism, which is an isomorphism affine-locally on a trivialising cover." Attached to `exists_tensorObj_inverse`, which is still `sorry` at iter-217. Severity: **major** (also counted above under must-fix for the sorry body).

- `TensorObjSubstrate.lean:1407–1413`: "iter-202 Lane TS scaffold: typed `sorry`. This is the iter-204+ closure target for the residual `addCommGroup` sorry of `RelPicFunctor.lean` (L235); once this body lands, the RPF instance closes against it." Attached to `addCommGroup_via_tensorObj`, still `sorry` at iter-217. Severity: **major** (also counted above under must-fix for the sorry body).

---

## Severity summary

- **must-fix-this-iter**: 3 — block downstream work until addressed.
- **major**: 8 (stale docstrings ×4, `@[implicit_reducible]` on sorry-body, deprecated `Sheaf.val` cluster)
- **minor**: 7
- **excuse-comments**: 2 (also counted under must-fix above; both are "scaffold typed sorry / iter-N+ closure target" patterns on declarations still open at iter-217)

**Overall verdict:** The iter-217 prover work is **genuine**: `tensorObj_restrict_iso` is axiom-clean (`{propext, Classical.choice, Quot.sound}`), the five new presheaf-level declarations are all real proofs with no sorry routing, and the file compiles with 0 errors. However, the file carries significant docstring debt — two declarations (`tensorObj`, `tensorObj_functoriality`) have docstrings that falsely claim sorry bodies, the module-level status block is 15 iterations stale, and two scaffold sorries (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) carry excuse-comments implying fixes that never arrived. Additionally, 17 uses of the deprecated `Sheaf.val` API will accumulate as a breaking-change risk.
