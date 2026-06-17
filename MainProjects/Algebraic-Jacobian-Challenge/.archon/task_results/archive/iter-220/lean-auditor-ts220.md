# Lean Audit Report

## Slug
ts220

## Iteration
220

## Scope
- files audited: 1 (directive-scoped to `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, focus area lines ~996–1305)
- files skipped: 0 per directive

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 3 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (missing `@[implicit_reducible]` on a class-type def)
- **excuse-comments**: 0
- **notes**:
  - **Line 1117**: `internalHomObjModule` is a `def` of class type `Module (…) (…)` without `@[reducible]` or `@[implicit_reducible]`. The companion `homModule` (line 1082) carries `@[implicit_reducible]`; `internalHomObjModule` simply wraps it but the attribute is not forwarded. The Lean compiler emits a warning: *"Definition `PresheafOfModules.InternalHom.internalHomObjModule` of class type must be marked with `@[reducible]` or `@[implicit_reducible]`"*. Because `internalHom` passes `internalHomObjModule` to `PresheafOfModules.ofPresheaf`, downstream elaboration of `r • m` under a `letI := internalHomObjModule …` binding may fail to find the `SMul` instance if Lean cannot see through the definition. The fix is to add `@[implicit_reducible]` matching `homModule`.
  - **Lines 37–45 (module-level status block)**: Status comment reads *"each of the 4 pinned declarations carries the *intended* substantive type signature … with a `sorry` body"*. By iter-220, at least two of the four (`tensorObj` at line 1325, `tensorObj_functoriality` at line 1340) have closed, sorry-free bodies — their own inline comments explicitly say "fully defined, no sorry". The status block actively misrepresents the current file state.
  - **Line 1122 (`internalHomObjModule` docstring)**: Sentence *"The full presheaf `internalHom` (the assembly of these values over the restriction maps `V ⟶ U`) is the remaining downstream build."* is stale: `internalHom` is assembled in the `section Assembly` block at lines 1283–1303, in the same iteration.
  - **Lines 1042, 1205, 1220 (`erw` uses in the focus block)**: Three `erw` calls in the new declarations. The mixed `rw` / `erw` at lines 1204–1205 in `restrictionMap_globalSMul` — where `rw [globalSMul_hom_apply]` suffices for the left-hand occurrence but `erw [globalSMul_hom_apply]` is needed for the right — signals an `Over`-category coercion or universe mismatch that resists plain rewriting. The `erw [← CommRingCat.comp_apply, ← R.map_comp]` at line 1220 is a standard but fragile pattern. These do not prevent compilation but are fragility sites.
  - **No `sorry` / `admit` / `native_decide` / unauthorised axioms in the focus block**: Verified. `lean_verify` for `internalHom`, `internalHomPresheaf`, `restrictionMap_smul`, `restrictionMap_globalSMul`, and `homModule` all return axioms `{propext, Classical.choice, Quot.sound}` only — standard Lean/Mathlib axiom set.
  - **Pre-existing sorries (outside focus block)**: Three sorry-bearing declarations outside the focus block — `isLocallyInjective_whiskerLeft_of_W` (line 600), `exists_tensorObj_inverse` (line 1724), `addCommGroup_via_tensorObj` (line 1774). All carry detailed gap-documenting comments and are pre-existing; not newly introduced this iter.
  - **Deprecated API warnings (outside focus block)**: 14 occurrences of `CategoryTheory.Sheaf.val` deprecated in favour of `ObjectProperty.obj` (lines 1326–1523). Pre-existing; unrelated to the focus block.

---

## Must-fix-this-iter

None. The new block contains no `sorry`, no axiom-backed claims, no weakened-wrong definitions, and no excuse-comments.

---

## Major

- `TensorObjSubstrate.lean:1117` — `internalHomObjModule` is a class-type `def` lacking `@[implicit_reducible]`. The Lean compiler emits a warning; without the attribute, instance-search for the `Module`/`SMul` structure produced by `internalHomObjModule` may silently fail in downstream elaboration (e.g., when `internalHom` is used and `r • m` must resolve). The parallel definition `homModule` at line 1082 has the attribute — this is a straightforward omission.
- `TensorObjSubstrate.lean:37–45` — Module-level status block claims all 4 blueprint-pinned declarations carry `sorry` bodies ("iter-202 Lane TS scaffold"), but `tensorObj` and `tensorObj_functoriality` have been closed sorry-free in subsequent iters. This is not an excuse-comment (it documents the original scaffold state), but it is actively misleading about the current file state and should be updated to reflect current sorry counts.
- `TensorObjSubstrate.lean:1122` — `internalHomObjModule` docstring says `internalHom` "is the remaining downstream build", but `internalHom` was assembled in the same block that contains `internalHomObjModule`. Stale within the same iteration.

---

## Minor

- `TensorObjSubstrate.lean:1042` — `erw [PresheafOfModules.map_smul]` in `globalSMul` body. `erw` used instead of `rw`; fragility site if `map_smul`'s universe or coercion structure shifts.
- `TensorObjSubstrate.lean:1205` — `erw [globalSMul_hom_apply]` after a preceding `rw [globalSMul_hom_apply]` on the same lemma. The asymmetry suggests a universe or `Over`-category coercion that only affects the second occurrence; fragility site.
- `TensorObjSubstrate.lean:1220` — `erw [← CommRingCat.comp_apply, ← R.map_comp]`; established pattern in this file but sensitive to future CommRingCat API changes.
- `TensorObjSubstrate.lean:1326–1523` — 14 `CategoryTheory.Sheaf.val` deprecated-API warnings (pre-existing, outside focus block, not introduced this iter).

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 4 (3 erw fragility sites + 1 deprecated-API cluster)
- **excuse-comments**: 0

Overall verdict: The `PresheafOfModules.InternalHom` assembly block (12 new declarations, lines 996–1305) is axiom-clean and sorry-free; the only actionable issue in the focus block is the missing `@[implicit_reducible]` on `internalHomObjModule` (compiler warning; potential downstream instance-search failure) plus two stale docstring sentences. No must-fix findings.
