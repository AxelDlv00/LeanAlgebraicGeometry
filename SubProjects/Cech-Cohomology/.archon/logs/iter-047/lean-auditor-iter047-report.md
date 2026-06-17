# Lean Audit Report

## Slug
iter047

## Iteration
047

## Scope
- files audited: 1 (directive-scoped to `QcohTildeSections.lean`; sorry-count pass over remaining 13 project files)
- files skipped (per directive): 13 project source files — directive explicitly lists one file; a sorry-scan of the rest confirms no new issues

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/QcohTildeSections.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (deprecated API; maxHeartbeats linter placement)
- **excuse-comments**: none
- **notes**:

  **Pre-existing declarations (not iter-047)**
  - Lines 733, 742, 759 (`modulesRestrictBasicOpen_smul_eq`, `modulesRestrictBasicOpen_smul_eq'`): use `F.val.obj` which Mathlib has deprecated in favour of `ObjectProperty.obj`. Three LSP warnings: "`CategoryTheory.Sheaf.val` has been deprecated: Use ObjectProperty.obj". Non-breaking but accumulate.
  - Lines 882, 978 (`tile_scalar_compat`, `tile_scalar_compat'`): `set_option maxHeartbeats 1000000 in` with the explanatory comment placed **before** the `set_option` line rather than after it. The Mathlib linter (`linter.style.maxHeartbeats`) requires the `--` comment on the line immediately after the `set_option` directive; comments before it are ignored by the linter. Two linter warnings fire as a result.
  - Lines 1017, 1053 (`tileReconcileEquiv`, `tile_restrict_map_apply`): same placement issue; two more linter warnings.

  **New declarations — iter-047**

  **`isLocalizedModule_of_exact` (lines 1192–1257)** — abstract diagram-chase lemma. All three `IsLocalizedModule` clauses verified:
  - `map_units`: injectivity/surjectivity of `s •` on `A'` follows from the same on `B'` (via `hi'`) and `hbInj`/`hbSurj`. Surjectivity uses exactness `hp'` to produce the pre-image in `A'` from one in `B'`. Proof chain is correct.
  - `surj`: lifts along `hb.surj (i' y)`, uses `hc.exists_of_eq` to clear the `p`-component, then exactness `hp` to find the pre-image in `A`. Final equality checked step-by-step; all rewrites are sound.
  - `exists_of_eq`: descends from `hb.exists_of_eq` using `hi`. Correct.
  - No `sorry`, no `Classical.choice` beyond standard library (`axioms = [propext, Classical.choice, Quot.sound]`). No `convert`, no `congr`, no suspicious closures.

  **`overlap_target_eq` (private, lines 1277–1284)** — `D((a·b)·f) = D(a·f) ⊓ D(b·f)`. The lattice proof by `le_antisymm` is manually verifiable: after `simp [specBasicOpen, PrimeSpectrum.basicOpen_mul]` the goal is `(D a ⊓ D b) ⊓ D f = (D a ⊓ D f) ⊓ (D b ⊓ D f)`, and the eight `inf_le_*` chains correctly witness both inequalities. Genuine equality, not a spurious rfl. ✓

  **`presheaf_map_comp₂_apply` (private, lines 1290–1293)** — three-fold presheaf application equals a single application of the composite. Proof by `← ModuleCat.comp_apply` (twice, folding the nested function applications into `≫`) then `← Q.map_comp` (twice, composing the presheaf maps). Standard and correct; not a spurious rfl. ✓

  **`overlap_section_localization` (private, lines 1301–1342)** — per-overlap version of `tile_section_localization`, obtained by transporting along `D(a·b) = D a ⊓ D b` and `D((a·b)·f) = D(a·f) ⊓ D(b·f)`.
  - The source/target opens transport uses `presheaf.mapIso (eqToIso (congrArg Opposite.op ...))` — the correct category-theoretic transport along an equality of opens objects.
  - The `keyB` proof uses `presheaf_map_comp₂_apply` to fold three presheaf maps, then `Subsingleton.elim _ _` to equate two morphisms in `(Spec R).Opensᵒᵖ` with the same source and target. This is genuinely sound: the hom-type of a thin category is a subsingleton, so any two morphisms `A ⟶ B` in `Opens^op` (which exist iff `B.val ⊆ A.val`) are equal. The `Subsingleton.elim` proof term is accepted by the kernel for the right reason. ✓
  - No `sorry`, standard axioms.

  **`qcoh_section_isLocalizedModule` (lines 1344–1438)** — the Route B keystone.
  - **`set_option maxHeartbeats 1000000`**: the explanatory `--` comment appears on the two lines **immediately after** `set_option maxHeartbeats 1000000 in` (lines 1345–1346), satisfying the Mathlib linter. No linter warning fires for this declaration. The inflation is justified: the comment names the two expensive sub-tasks (the `LinearMap.pi` defeq for `change` and the `IsLocalizedModule.pi` synthesis over `ULift (Fin n)`).
  - **`set_option maxHeartbeats 1000000` on `tile_section_localization` (line 1068)**: the explanatory comment is placed *before* the `set_option` line (lines 1066–1067), not after. The linter fires (line 1068 appears in warnings). Minor: the comment is there but in the wrong position for the linter.
  - **`change` in sq1 (lines 1418–1422)**: reduces the elaborated `LinearMap.pi ∘ ρ_f` application to an explicit pair of section-restriction composites. The target is genuinely defeq: `LinearMap.pi (fun i => f i) s |_i = f i s` by `LinearMap.pi` reduction, and `ρ_f`'s definition as a presheaf map. Both composites fold to the same restriction `Γ(⊤) → Γ(U2 i)` by `res_trans_apply`. The `change` succeeds because the target is definitionally equal, not because of an accidental unification. ✓
  - **`change` in sq2 (lines 1427–1438)**: analogous structure; distributes `map_sub` then folds four restriction composites via `res_trans_apply`. Both composite routes to `Γ(U2 i ⊓ U2 j)` are definitionally equal after `Subsingleton.elim`-style proof-irrelevance of `homOfLE`. ✓
  - **`IsLocalizedModule.pi` for `hb` and `hc`**: `hbtile` and `hctile` are installed as `haveI` (typeclass instances); `IsLocalizedModule.pi` automatically picks them up. No instance gap. ✓
  - No `sorry`, axioms = `[propext, Classical.choice, Quot.sound]`.

  **`qcoh_section_kernel_comparison` (lines 1446–1452)** — packages `qcoh_section_isLocalizedModule` as a linear equivalence.
  - **`@IsLocalizedModule.iso _ _ ... _ (qcoh_section_isLocalizedModule F f)`**: the `@` with 10 underscore arguments is needed because Lean's unifier cannot synthesize the `IsLocalizedModule` instance for the specific term `((modulesSpecToSheaf.obj F).presheaf.map (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom` automatically (the map expression is too complex for typeclass search). Explicitly supplying the proof is sound: it is exactly the proof produced by `qcoh_section_isLocalizedModule`. No instance gap is bypassed — the instance is genuinely provided. ✓
  - Minor robustness concern: if `IsLocalizedModule.iso` gains or loses an implicit argument in a future Mathlib bump, the underscore count would silently fail to compile. This is a maintenance risk, not a correctness risk.
  - Axioms = `[propext, Classical.choice, Quot.sound]`. ✓

---

### Other project files (sorry-scan only; not in directive scope)

- `CechHigherDirectImage.lean`: 1 sorry at line 679 — the protected main theorem `AlgebraicGeometry.cech_computes_higherDirectImage` body. Expected and protected.
- `CechAcyclic.lean`: 1 sorry at line 110 — `CechAcyclic.affine`, a known open proof obligation with detailed planner commentary (L1/L2/L3 route). Not an excuse-comment; the plan commentary is accurate about what's missing (the L1 categorical bridge).
- All remaining files: 0 sorry.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `QcohTildeSections.lean:733,742,759` — `F.val.obj` usage deprecated; Mathlib API requires `F.obj` (via `ObjectProperty.obj`). Three LSP deprecation warnings. Pre-existing issue, not introduced this iter.
- `QcohTildeSections.lean:882,978,1017,1053,1068` — `set_option maxHeartbeats 1000000` blocks whose explanatory comments are positioned *before* the `set_option` line rather than after it, causing Mathlib `linter.style.maxHeartbeats` warnings. The new line 1068 (`tile_section_localization`) is the one introduced this iter; the others are pre-existing. The new `qcoh_section_isLocalizedModule` (line 1344) correctly places the comment after and has no warning.
- `QcohTildeSections.lean:1451` — `@IsLocalizedModule.iso _ _ _ _ _ _ _ _ _ _ (...)` with 10 underscore implicit arguments. Sound but fragile against future changes to `IsLocalizedModule.iso`'s signature in Mathlib.
- `QcohTildeSections.lean:1418–1438` — the two `change` tactics in `qcoh_section_isLocalizedModule` create a coupling to the specific elaboration form of `LinearMap.pi` and the presheaf map composition. Correct now; would need updating if Lean's unfolding strategy for `LinearMap.pi` changes (the proof would fail to compile rather than silently accept a wrong term, so this is a robustness concern, not a soundness concern).

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 4 distinct items (deprecation, maxHeartbeats placement, `@` fragility, `change` coupling)
- **excuse-comments**: 0

Overall verdict: `QcohTildeSections.lean` is mathematically sound and axiom-clean; the six new iter-047 declarations close correctly with no sorry and no suspect proof terms. All `Subsingleton.elim` and `change` usages are genuinely justified. The minor findings are style/robustness issues that do not affect correctness.
