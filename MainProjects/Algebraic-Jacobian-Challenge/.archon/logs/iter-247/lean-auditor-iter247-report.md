# Lean Audit Report

## Slug
iter247

## Iteration
247

## Scope
- files audited: 3
- files skipped (per directive): 0 — full file reads on all three

---

## Per-file checklist

### AlgebraicJacobian.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator; 37 imports, no declarations.
  - Import order after iter-247 refactor is correct: `TensorObjSubstrate` (L20) precedes `RelPicFunctor` (L21). No cyclic-looking import pair.
  - No dead imports detected at the structural level (cannot verify all imports compile without running the full build, but all appear to correspond to files known to exist in the project tree).

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (long-line warnings; `Sheaf.val` deprecations are pre-existing and known)
- **excuse-comments**: none
- **notes**:

#### New declarations (L1495–1544) — both genuine

**`presheafUnit_comp_map_eta` (L1495–1510)**
- Hover-verified actual type: `adj.unit.app 𝟙_ ≫ pushforward.map (η (pullback φ')) = ε (pushforward φ')` for `φ' = f.toRingCatSheafHom.hom`.
- `letI φ'` in the statement is a transparent scoped binding (the elaborator expands it fully — confirmed by hover). Does NOT silently change the stated type.
- `haveI : IsRightAdjoint` at L1507 supplies the required instance for `Adjunction.unit_app_unit_comp_map_η`. Standard idiom; does not alter the statement.
- Proof is a single call to the Mathlib mate-identity `Adjunction.unit_app_unit_comp_map_η`. No `sorry`. Non-vacuous.
- LSP diagnostic: 0 errors, 0 warnings.

**`isIso_sheafifyEta_of_unitSquare` (L1518–1544)**
- Hover-verified actual type: hypothesis `hsq` is the commuting-square equation `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η F) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit f`; conclusion is `IsIso (a_Y.map (η F))`.
- `hsq` is non-trivially dischargeable (it is the unit-side analog of `pullbackObjUnitToUnit_comp`, not yet proven in the file — as expected per the D2' roadmap). The hypothesis is GENUINE, not vacuous or circular.
- `letI φ'` appears in both the hypothesis and conclusion scopes; both bind the same expression `f.toRingCatSheafHom.hom`, confirmed identical by hover expansion. No type-change.
- `haveI hfin : Final` and `haveI hpbu : IsIso pbu` are standard local instance introductions; they do not change the stated type.
- Proof: `Iso.inv_comp_eq` transposes `hsq` to `key`; `Iso.eq_comp_inv` rewrites the goal; `IsIso.comp_isIso'` chains three isos (`pullbackValIso.hom`, `pullbackObjUnitToUnit` via `isIso_pbu_of_final`, `sheafifyUnitIso.inv`). Correct.
- LSP diagnostic: 0 errors. 3 `Sheaf.val` deprecation warnings (L1523, L1529, L1534) — known pattern, not must-fix.

#### Stale route comments

- **L78 and L110**: Sub-module layout comment refers to "the `addCommGroup_via_tensorObj` stub" as living in `RelPicFunctor.lean`. No Lean declaration by that name exists anywhere in the project (the actual name is `PicSharp.addCommGroup`). The label is used descriptively, not as a code identifier, but is confusing.
- **L1439–1468 (D2' handoff note)**: Describes the state as of iter-246: "the SOLE remaining content of D2' is the η-bridge `IsIso (a_Y.map (η (pullback φ')))`. This is the commuting square..." Two lemmas (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) that address this state landed in iter-247 but postdate this comment. The comment should be updated to say these lemmas now exist and the sole remaining content is proving `hsq`.

#### No stale route comments claiming abandoned builds as active

- Phase-2 "SUPERSEDED (iter-243 pivot)" note correctly labeled superseded.
- D1 "OFF-PATH (iter-243 pivot)" note correctly labeled.
- iter-206 monoidal-pivot note is historically accurate.

#### `Sheaf.val` deprecations (known)

43 occurrences of `CategoryTheory.Sheaf.val` deprecated in favor of `ObjectProperty.obj`, spread across the file. All pre-existing pattern; not must-fix.

#### Long-line warnings

5 occurrences: L481, L482, L483, L1303, L1320. Minor style issue.

#### `exists_tensorObj_inverse` (L670)

Remains `sorry`, as expected (project-deferred). LSP correctly flags: `declaration uses sorry` at L670.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean

- **outdated comments**: 4 flagged
- **suspect definitions**: 1 flagged (see must-fix)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged (see must-fix)
- **notes**:

#### LSP verification

Zero errors, zero warnings (no `Sheaf.val` deprecations, no sorry-taint warnings, no long-line warnings) in the entire file. The `addCommGroup` instance, all helper private declarations, and all downstream uses compile cleanly.

#### Deleted declarations confirmed gone

The 5 local pure-Mathlib copies (`pTensor`, `pTensorIso`, `pLeftUnitor`, `pRightUnitor`, `pBraiding`) and 4 local typed-`sorry` bridges (`pTensor_isLocallyTrivial`, `pAssoc`, `exists_pTensor_inverse`, `isLocallyTrivial_unit` was kept — correct) appear ONLY in the documentation comment at L261–263 describing their deletion; no Lean declarations by those names remain. ✓

#### No orphaned declarations

All declarations in the file are used: `Modules.tensorObjOnProduct` → `relTensorObj`; `isLocallyTrivial_unit` → `addCommGroup`; `pInverseUnique` → `relNeg`; `relTensorObj` → `relAdd`; `relAdd`/`relNeg` → `addCommGroup`; `addCommGroup` → downstream. `PicSharp`, `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure` are the exported blueprint-pinned declarations.

#### Import cycle comment correctly resolved

L227: "import cycle RESOLVED". L259–276: correctly states the new dependency chain is `LineBundlePullback → TensorObjSubstrate → RelPicFunctor`. No comment still describes the cycle as active. ✓

#### `functorial = 0` stub

`PicSharp.functorial` (L536–541) is the zero `AddMonoidHom`, as expected per the directive ("the `functorial` field is still a `0` stub (expected)"). The type is correct; the value is an acknowledged placeholder. Not flagged as must-fix per directive context.

#### `addCommGroup` construction group-axiom proofs

- `add_assoc`, `zero_add`, `add_zero`, `add_comm`: sorry-free, citing upstream `Modules.tensorObj_assoc_iso`, `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding` respectively. ✓
- `neg_add_cancel`: routes through `Modules.tensorObj_braiding` composed with `(Classical.choose_spec (Modules.exists_tensorObj_inverse …)).2.some`. This is the SINGLE sorry chain, consuming the upstream project-deferred `Modules.exists_tensorObj_inverse` (TensorObjSubstrate.lean:670). No additional local sorries. ✓
- `nsmul := nsmulRec`, `zsmul := zsmulRec`: `letI iZero/iAdd/iNeg` supply instances for elaboration. Standard Lean 4 idiom; does not alter the instance's stated type. ✓

#### Stale status claims (MAJOR / must-fix — see below)

**L32–34 (module status docstring)**: "The single remaining file-local sorry is the `addCommGroup` instance body in §1, which is gated on the Mathlib `Scheme.Modules` monoidal-structure upgrade." Both claims are **FALSE** in iter-247:
- `addCommGroup` has no local sorry (its body is real; the sorry is in the upstream `Modules.exists_tensorObj_inverse` in TensorObjSubstrate.lean, not in RelPicFunctor.lean).
- The bottleneck is no longer the `Scheme.Modules` monoidal-structure upgrade; it is the unproven `exists_tensorObj_inverse` reverse bridge.

**L30**: "`PicSharp.functorial` inherits a `sorryAx` taint via the file-local `addCommGroup` instance (its codomain's `Zero` is sorry-derived)." — The `sorryAx` taint in `functorial` comes from the UPSTREAM `exists_tensorObj_inverse`, not from a file-local source. Partially stale.

**L44–49**: "Once the `addCommGroup` body lands (closing the `Scheme.Modules` monoidal-structure gap), the math-correct construction substitutes…" — `addCommGroup` HAS landed in iter-247, but the substitution in `PicSharp` has NOT happened, because it also requires `functorial` to be real. The upgrade condition is more than what the docstring says.

**L477–490 (`PicSharp` docstring)**: "This is a **sorry-free placeholder** used while the file-local `addCommGroup` sorry in §1 is open." — The word **"placeholder"** is an excuse-comment. The gate condition is now false (`addCommGroup` is real). The declaration is load-bearing (`PicSharp` is consumed by `presheaf`, `etSheaf`, and `etSheaf_group_structure`). See must-fix below.

**L524–535 (`functorial` docstring)**: "This is gated on the same upstream Mathlib upgrade." The "same upgrade" refers to the `Scheme.Modules` monoidal-structure gap (described in the surrounding text), which is no longer the active bottleneck. The real gate is the unresolved `functorial` construction itself (requires the tensor-product functoriality proof for the quotient group law), which depends on ongoing work rather than a Mathlib gap.

#### `PicSharp` body

`PicSharp := (CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` (L491–494) is the constant functor at the trivial group `PUnit`. This is structurally different from the real concept (`T ↦ Quotient (preimage_subgroup _C.hom T.unop.hom)` with varying group structure). See must-fix below.

---

## Must-fix-this-iter

- `RelPicFunctor.lean:32–34` — Module status docstring claims "The single remaining file-local sorry is the `addCommGroup` instance body in §1." `addCommGroup` now has a real body (LSP: 0 sorry-warnings in RelPicFunctor.lean). The sorry is upstream in `TensorObjSubstrate.lean:670`. This statement is factually wrong and will mislead future agents and the plan agent when setting objectives. Why must-fix: incorrect project-state claim actively recorded in the permanent module header.

- `RelPicFunctor.lean:477` — `PicSharp` docstring says **"This is a sorry-free placeholder"** on a load-bearing definition (`PicSharp` is the base of `presheaf`, `etSheaf`, `etSheaf_group_structure`). "Placeholder" is an explicit excuse-comment. Additionally, the body `(Functor.const _).obj (AddCommGrpCat.of PUnit.{u+2})` is a weakened-wrong definition: it is structurally different from the real relative Picard functor `T ↦ Quotient (preimage_subgroup _C.hom T.unop.hom)` (a constant functor at PUnit cannot represent the varying-by-T Picard quotient). The gate condition cited ("while the file-local `addCommGroup` sorry in §1 is open") is now FALSE — `addCommGroup` landed this iteration. Why must-fix: excuse-comment + weakened-wrong definition on a load-bearing declaration whose stated upgrade gate has been met.

---

## Major

- `RelPicFunctor.lean:30, 44–49` — Module header mischaracterizes the source of `sorryAx` taint (`functorial` is described as sorry-tainted "via the file-local `addCommGroup` instance"; the actual source is upstream `Modules.exists_tensorObj_inverse`) and describes an upgrade condition ("once `addCommGroup` body lands") that is incomplete (the upgrade also requires `functorial` to be real, which was not stated).

- `RelPicFunctor.lean:524–535` — `functorial` docstring cites a stale gate: "gated on the same upstream Mathlib upgrade" (referring to the `Scheme.Modules` monoidal-structure gap). In iter-247, `addCommGroup` is real via the direct tensor-product substrate; the monoidal-structure gap is no longer the bottleneck for the `functorial` placeholder. The docstring should state the real gate: proving `map_zero` and `map_add` for the pullback-induced group homomorphism on the concrete quotient.

- `TensorObjSubstrate.lean:1439–1468` — D2' handoff note describes the iter-246 state ("the SOLE remaining content of D2' is the η-bridge `IsIso (a_Y.map (η (pullback φ')))`"). In iter-247, two stepping-stone lemmas for that bridge (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) landed. The comment should be updated to reflect their existence and state that the remaining content is the square hypothesis `hsq` (passed as the parameter of `isIso_sheafifyEta_of_unitSquare`).

---

## Minor

- `TensorObjSubstrate.lean:78, 110` — Sub-module layout note refers to "the `addCommGroup_via_tensorObj` stub" as living in RelPicFunctor.lean. No Lean declaration by that name exists; the actual name is `PicSharp.addCommGroup`. The label is used descriptively, not as a code name, but could confuse a reader searching for the declaration.

- `TensorObjSubstrate.lean` — 43 `Sheaf.val` deprecation warnings (`CategoryTheory.Sheaf.val` → `ObjectProperty.obj`), pre-existing throughout the file. Known; not must-fix per directive. 5 long-line warnings (L481–483, L1303, L1320).

- `TensorObjSubstrate.lean:1518` — The `isIso_sheafifyEta_of_unitSquare` declaration introduces 3 new `Sheaf.val` deprecation warnings (L1523, L1529, L1534), following the file-wide pattern. Not must-fix.

- `RelPicFunctor.lean:536–541` — `functorial = 0` (zero `AddMonoidHom`) is an acknowledged stub. Noted per directive as expected. Not an additional finding.

---

## Excuse-comments (called out separately)

- `RelPicFunctor.lean:477`: "This is a **sorry-free placeholder** used while the file-local `addCommGroup` sorry in §1 is open" (attached to `PicSharp`, the load-bearing relative Picard functor definition). Severity: **critical** — load-bearing declaration, gate condition now false, word "placeholder" explicitly used. The docstring documents the code as wrong and instructs the reader to wait for a substitution that should have happened this iteration.

---

## Severity summary

- **must-fix-this-iter**: 2 — these block correct project-state tracking; the factually wrong module status claim and the excuse-comment + weakened-wrong definition on `PicSharp`.
- **major**: 3
- **minor**: 4 (note: 43 + 3 `Sheaf.val` warnings counted once as 1 finding; 5 long-line warnings counted as 1)
- **excuse-comments**: 1 (also counted under must-fix-this-iter)

Overall verdict: Both audited .lean files compile error-free; the two new iter-247 declarations (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) are genuine, correctly typed, and sorry-free. The critical issue is in RelPicFunctor.lean's module header and `PicSharp` docstring: both now contain factually incorrect state descriptions following the iter-247 `addCommGroup` real-construction landing, with the `PicSharp` docstring additionally constituting a must-fix excuse-comment on a load-bearing placeholder definition.
