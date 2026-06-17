# Lean Audit Report

## Slug
ts219

## Iteration
219

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 6 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

- **notes**:

  **Pre-existing sorries (noted per directive, not new):**
  - `TensorObjSubstrate.lean:632` — `isLocallyInjective_whiskerLeft_of_W` body is `sorry`; carries a large explanatory comment (d.1/d.2 gaps). Not new this iter.
  - `TensorObjSubstrate.lean:1559` — `exists_tensorObj_inverse` body is `sorry`; carries an explicit BLOCKED explanation. Not new this iter.
  - `TensorObjSubstrate.lean:1603` — `addCommGroup_via_tensorObj` body is `sorry`; carries an explicit INCOMPLETE explanation. Not new this iter.

  **New declarations (lines ~996–1129), all 11 assessed:**

  1. **`termRingMap`** (L1010) — `R.map (hT.from Y.unop).op`. Meaningful: constructs the canonical ring map `R(T) → R(Y)` via terminality. Clean.

  2. **`termRingMap_naturality`** (L1017) — Non-trivial compatibility: restriction along `g` carries `termRingMap X` to `termRingMap Y`. Proof uses `Quiver.Hom.unop_inj` + `hT.hom_ext` to derive the morphism equality, then `Functor.map_comp`; correct.

  3. **`globalSMul`** (L1031) — Genuine `N ⟶ N` morphism (not a scalar automorphism trivially). Assembles sectionwise via `LinearMap.lsmul` with `termRingMap`-transported scalar. Naturality proof uses `PresheafOfModules.map_smul` + `termRingMap_naturality`. Sound.

  4. **`globalSMul_hom_apply`** (L1049) — `: rfl`. The `rfl` is appropriate: it is a definitional unfolding (`hom m = _ • m`), not a shortcut on a non-trivial claim.

  5–8. **`globalSMul_one/zero/add/mul`** (L1053, 1057, 1061, 1067) — Each is a non-trivial identity established by rewriting with the corresponding ring-hom axiom (`map_one`, `map_zero`, `_root_.map_add`, `map_mul`) and the module axiom (`one_smul`, `zero_smul`, `add_smul`, `mul_smul`). `globalSMul_mul` correctly reverses the composition order: `globalSMul (f * g) = globalSMul g ≫ globalSMul f`. This is mathematically required by the action `f • φ := φ ≫ globalSMul f` and `mul_smul` in the target module (applying `g` first, then `f`). Verified correct in a commutative ring.

  9. **`homModule`** (L1082) — **Genuine `Module` instance with no axiom shortcuts.** All six module axioms are proved explicitly:
     - `one_smul`: `rw [globalSMul_one, Category.comp_id]` — correct.
     - `mul_smul`: `rw [globalSMul_mul, Category.assoc]` — correct (uses `globalSMul_mul`'s composition-reversal).
     - `smul_zero`: `rw [Limits.zero_comp]` — `(0 : M ⟶ N) ≫ _ = 0` in preadditive category.
     - `zero_smul`: `rw [globalSMul_zero, Limits.comp_zero]` — correct.
     - `smul_add`: `rw [Preadditive.add_comp]` — correct.
     - `add_smul`: `rw [globalSMul_add, Preadditive.comp_add]` — correct.
     No `rfl` on non-trivial axiom; each proof chain goes through established lemmas. The carrier `M ⟶ N` already has `AddCommGroup` from the preadditive category. Instance complete.

  10. **`restr`** (L1112) — `pushforward₀ (Over.forget U) (...).obj M`. Meaningful: restriction of a presheaf of modules to the over-category `Over U`, yielding a presheaf over `((Over.forget U).op ⋙ R) ⋙ forget₂`. Clean definition.

  11. **`internalHomObjModule`** (L1123) — Applies `homModule` with `T := Over.mk (𝟙 U)` (terminal of `Over U`, via `Over.mkIdTerminal`) and `R := (Over.forget U).op ⋙ R`. The base ring at the terminal is `R.obj (Opposite.op U)` (by functoriality: `((Over.forget U).op ⋙ R).obj (op (Over.mk (𝟙 U))) = R.obj (op U)`), matching the stated return type. Sound.

  **`@[implicit_reducible]` uses:**
  - `homModule` (L1081), `restrictScalarsMonoidalOfRingEquiv` (L252), `restrictScalarsMonoidalOfBijective` (L957), `addCommGroup_via_tensorObj` (L1599): all on class-type `def`s. The pattern is consistent with Lean 4 / Mathlib practice for non-`instance` class defs that need to be discovered by typeclass synthesis. The note at L1596–1598 explicitly justifies the `@[implicit_reducible]` to silence the linter. No misuse detected.

  **Outdated comments:**

  - **L37–85 (block comment header "Status (iter-202 Lane TS — file-skeleton scaffold)")**: Describes the file as a "file-skeleton" in which "each of the 4 pinned declarations carries the intended substantive type signature with a `sorry` body." This was true at iter-202 but is false now: `tensorObj` (L1151) and `tensorObj_functoriality` (L1166) both have complete, non-sorry bodies, and `tensorObjOnProduct` (L1568–1575) is also complete. The claim "The bodies are iter-203+ work" is stale. See MAJOR findings.

  - **L1567 (`tensorObjOnProduct` docstring)**: The docstring ends with "iter-202 Lane TS scaffold: typed `sorry`." The body is NOT a sorry — it is a complete anonymous constructor `⟨tensorObj L.carrier L'.carrier, tensorObj_isLocallyTrivial ...⟩`. The docstring is factually wrong about the implementation state. See MAJOR findings.

  - **L1201 comment**: "scaffold the iter-203+ bodies" — stale; those bodies now exist.

  - **L1271–1309 (`tensorObj_assoc_iso` docstring)**: Says "iter-212 status (typed `sorry`...)" — the iter number is stale (now 219). The declaration does have a real body (route (d) three-step composite), though it depends on the sorry-bodied `isLocallyInjective_whiskerLeft_of_W`. The "typed sorry" claim is misleading: the body itself is not a sorry; the sorry is in a downstream dependency.

  - **L1567**: "iter-202 Lane TS scaffold" — iter stale.

  - **L1588–1590 (`addCommGroup_via_tensorObj` docstring)**: "iter-202 Lane TS scaffold: typed `sorry`. This is the iter-204+ closure target" — iter numbers stale; the declaration is still `sorry`, so the factual content is correct, but iter numbers are outdated.

---

## Must-fix-this-iter

None. The 11 new declarations have no sorry bodies, no weakened-wrong definitions, no vacuous proofs, and no excuse-comments. All module axioms in `homModule` are genuinely proved.

---

## Major

- `TensorObjSubstrate.lean:1567` — Docstring of `tensorObjOnProduct` ends with "iter-202 Lane TS scaffold: typed `sorry`" but the definition body is a complete non-sorry implementation (`⟨tensorObj ..., tensorObj_isLocallyTrivial ...⟩`). Actively wrong: misleads readers (and automated sorry-counters) into believing this declaration is still scaffolded. Should be updated to reflect the closed status.

- `TensorObjSubstrate.lean:37–85` — Block comment "Status (iter-202 Lane TS — file-skeleton scaffold)" claims "each of the 4 pinned declarations carries ... a `sorry` body" and "The bodies are iter-203+ work." At iter-219, declarations 1 (`tensorObj`, L1151) and 2 (`tensorObj_functoriality`, L1166) have complete bodies; declaration 3 (the `monoidalCategory` instance) was deliberately removed (§2 pivot); `tensorObjOnProduct` also has a complete body. The header misrepresents the current file state and should be updated or removed.

---

## Minor

- `TensorObjSubstrate.lean:37` — "iter-202" in the status-block heading. Stale iter number (now 219).

- `TensorObjSubstrate.lean:1201` — Comment "scaffold the iter-203+ bodies" is stale; the bodies in §3 that existed as sorries at iter-203 are now implemented.

- `TensorObjSubstrate.lean:1271` — `tensorObj_assoc_iso` docstring says "iter-212 status (typed `sorry`)." The declaration is not typed `sorry` — it has a real body; the sorry propagates indirectly through `isLocallyInjective_whiskerLeft_of_W`. Stale iter and misleading "typed sorry" language.

- `TensorObjSubstrate.lean:1588` — `addCommGroup_via_tensorObj` docstring: "iter-202 Lane TS scaffold" and "iter-204+ closure target" — both iter numbers stale. The body is still `sorry` (so the scaffold description is partially accurate), but the iter references should be updated.

---

## Excuse-comments (always called out separately)

None. No declaration carries a comment admitting the code is wrong and promising to fix it later.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The 11 new `PresheafOfModules.InternalHom` declarations are mathematically sound, axiom-clean, and introduce no new sorries; the only issues in the file are stale block comments that misrepresent sorry counts and implementation status for older declarations.
