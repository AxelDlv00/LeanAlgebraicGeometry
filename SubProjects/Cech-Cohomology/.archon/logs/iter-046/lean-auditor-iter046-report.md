# Lean Audit Report

## Slug
iter046

## Iteration
046

## Scope
- files audited: 1 (focused audit per directive)
- files skipped per directive: all other project `.lean` files — directive restricts scope to `QcohTildeSections.lean`

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (deprecated API usage)
- **excuse-comments**: none
- **notes**:

  **New declarations (focus area, lines ~1000–1162)**

  - `isScalarTower_restrictScalars_obj` (instance, lines 1008–1012): axiom-clean (`propext`, `Quot.sound` only). Proof is `IsScalarTower.of_algebraMap_smul` with `ModuleCat.restrictScalars.smul_def'`. No trap pattern; sound.

  - `tileReconcileEquiv` (noncomputable def, lines 1024–1036): axiom-clean (`propext`, `Classical.choice`, `Quot.sound`). Identity-on-elements `LinearEquiv`; the mathematical content lives entirely in `map_smul' r x := (tile_scalar_compat' …).symm`. `left_inv`/`right_inv`/`map_add'` are genuine `rfl`s. No trap pattern.

  - `tileReconcileEquiv_apply` / `tileReconcileEquiv_symm_apply` (`@[simp]` private lemmas, lines 1038–1048): both bodies are `:= rfl`. These are genuinely trivial given the `toFun x := x` / `invFun x := x` definition of `tileReconcileEquiv`. No type-mismatch papering.

  - `tile_restrict_map_apply` (private lemma, lines 1056–1063): `:= rfl` stated at the `⇑`-applied level (`.hom y = .hom y`). The `set_option maxHeartbeats 1000000 in` guard confirms the `rfl` is a genuine but expensive `isDefEq` — the tile restriction on `modulesRestrictBasicOpen g F` and `F`'s restriction over the iterated image opens coincide definitionally through the `modulesSpecToSheaf ∘ restrict` tower. LSP reports no error. Axiom check for `tile_section_localization` (which relies on this) passes cleanly. Not a type-mismatch cover.

  - `tile_section_localization` (target lemma, lines 1079–1162): axiom-clean (`propext`, `Classical.choice`, `Quot.sound`). The proof is multi-step and correctly structured:

    - **`key`** (lines 1127–1135): closes with `LinearMap.ext` (sound — standard extensionality, not a subsingleton trap) followed by `tile_restrict_map_apply` at the element level. ✓

    - **`keyB`** (lines 1150–1160): closes with `congrArg (fun m => ((modulesSpecToSheaf.obj F).presheaf.map m).hom) (Subsingleton.elim _ _)`. **This is the documented safe form** for opens-morphism goals. The `Subsingleton.elim` establishes equality of `Opposite.op _` values (thin-category morphisms, which are unique), and `congrArg` lifts it to presheaf values without invoking any morphism subsingleton on the module side. ✓ Not the bare-tactic trap.

    - Final close: `rw [← keyB]; exact h4` — structurally sound.

  **`set_option maxHeartbeats 1000000 in` blocks (5 total)**

  All five are justified by genuine expensive `isDefEq` obligations:

  | Line | Declaration | Justification |
  |------|-------------|---------------|
  | 881  | `tile_scalar_compat`   | `convert … using 2` defeq on tile section carriers |
  | 977  | `tile_scalar_compat'`  | same, general-open form |
  | 1016 | `tileReconcileEquiv`   | `toFun := id` carrier identity through `modulesSpecToSheaf ∘ restrict` tower |
  | 1052 | `tile_restrict_map_apply` | `rfl` carrier identity through same tower |
  | 1067 | `tile_section_localization` | base-ring descent + transport unification |

  **Comment placement**: The explanatory comments for all five blocks appear on the lines BEFORE `set_option maxHeartbeats 1000000 in` (as `-- ...` block-comments preceding the `set_option` line). The Mathlib linter (`linter.style.maxHeartbeats`) fires for all five (lines 881, 977, 1016, 1052, 1067) because it expects the comment to appear **after** the `set_option` line (i.e., as the first line of the declaration body). The explanations are substantively correct and present; the issue is purely the placement order relative to the linter's expected pattern.

  **Deprecated API** (pre-existing, not in focus declarations):

  - Lines 732, 741, 758: `CategoryTheory.Sheaf.val` is deprecated; Mathlib now uses `ObjectProperty.obj`. These appear in `modulesRestrictBasicOpen_smul_eq` / `modulesRestrictBasicOpen_smul_eq'` / `modulesRestrictBasicOpen_smul_eq'`. Not introduced in iter-046 but now actively flagged by the LSP as warnings.

  **Long lines** (style): Multiple lines exceed the 100-char limit throughout the new code (lines 708, 713, 813, 857, 858, 879, 929, 932, 968, 975, 978, 979, 983, 1004, 1006, 1066, 1075, 1094, 1126, 1140). All are in long type signatures or comments — expected for this kind of algebraic-geometry code but not Mathlib-contribution ready.

---

## Must-fix-this-iter

None. No suspect bodies, excuse-comments, weakened-wrong definitions, parallel APIs, or unauthorized axioms found. The five `maxHeartbeats` comment-placement issues are style warnings, not correctness issues.

---

## Major

None.

---

## Minor

- `QcohTildeSections.lean:881,977,1016,1052,1067` — Mathlib linter fires `linter.style.maxHeartbeats` for all five `set_option maxHeartbeats 1000000 in` blocks. The explanatory comments are substantively present and correct, but placed on the line(s) BEFORE `set_option` rather than immediately after it. The linter expects the comment to be the first statement inside the declaration body (i.e., the line right after `set_option maxHeartbeats N in`). Fix: move each `-- reason` comment to the line after the `set_option` line (inside the declaration, not outside it).

- `QcohTildeSections.lean:732,741,758` — `CategoryTheory.Sheaf.val` is deprecated; replace with `ObjectProperty.obj`. Pre-existing, not introduced this iter, but actively flagged. These are in `modulesRestrictBasicOpen_smul_eq` / `modulesRestrictBasicOpen_smul_eq'`.

- Multiple long lines (>100 chars) throughout the new code — low priority style issue, would need fixing before any Mathlib PR.

---

## Excuse-comments

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3 classes (maxHeartbeats comment placement × 5 instances; deprecated `Sheaf.val` × 3 instances; long lines × ~20 instances)
- **excuse-comments**: 0

Overall verdict: The new declarations (iter-046 focus area) are axiom-clean, use sound proof patterns including the explicitly safe `congrArg/Subsingleton.elim` form for opens-morphism goals, and carry no excuse-comments or weakened definitions; the only live warnings are Mathlib style lints (comment placement, deprecated API, long lines) with no correctness impact.
