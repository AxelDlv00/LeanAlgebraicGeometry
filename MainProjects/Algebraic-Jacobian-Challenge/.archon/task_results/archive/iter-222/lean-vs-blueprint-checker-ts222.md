# Lean ↔ Blueprint Check Report

## Slug
ts222

## Iteration
222

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1938 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2813 lines)

---

## Per-declaration (iter-222 primary target)

### `\lean{PresheafOfModules.internalHomEval}` (chapter: `lem:internal_hom_eval`)
- **Lean target exists**: yes — `PresheafOfModules.internalHomEval` at Lean line 1449.
- **Signature matches**: yes. Type is `PresheafOfModules.Monoidal.tensorObj M (dual M) ⟶ 𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))`, matching the blueprint's `ev_M : M ⊗_R M^∨ ⟶ R`.
- **Proof follows sketch**: partial. The `app` field (open-by-open contraction `internalHomEvalApp`) is complete and axiom-clean. The `naturality` field contains a typed `sorry` with a detailed docstring explaining the exact obstacle: a `whnf` heartbeat bomb (times out at `maxHeartbeats 3200000`) on the concrete unit-`𝟙_` instantiation of `restr_map_homMk`. The docstring records three specific whnf-free fixes in `task_results`.
- **Blueprint `\leanok` status**: statement block has `\leanok` (accurate: ≥ 1 sorry present = formalized at statement level per vocabulary). Proof block has NO `\leanok` (accurate: proof not closed). The chapter does **not** present this as a completed/closed result.
- **Blueprint `% NOTE:` comment**: accurately records that `internalHomEvalApp` is the "already-built" building block and `internalHomEval` is the "correct future target name" with the remaining obligation being the naturality step.

### Supporting lemma: `internalHomEvalApp_tmul` (Lean line 1421)
- **Blueprint counterpart**: none. The `% NOTE:` comment on `lem:internal_hom_eval` references `internalHomEvalApp` generally but does not enumerate this `@[simp]` helper.
- **Assessment**: Lean-internal helper (a `@[simp]` lemma for the value of `internalHomEvalApp` on a simple tensor `s ⊗ φ ↦ evalLin M X φ s`). No dedicated blueprint block needed; this is acceptable per the checker's helper-only policy.

### Supporting lemma: `restr_map_homMk` (Lean line 1434)
- **Blueprint counterpart**: none. Declared `private`.
- **Assessment**: Purely an implementation detail — a `private lemma` extracted to bound `whnf` within its own heartbeat budget (docstring explicitly says so). No blueprint counterpart needed.

---

## Per-declaration (iter-222 broader context — full file scan)

### Previously-closed declarations whose `\leanok` status was already established
The following `\lean{...}`-pinned declarations are confirmed present in the Lean file without new sorries:

| Blueprint label | `\lean{...}` pin | Lean declaration exists | Sorry | Blueprint `\leanok` |
|---|---|---|---|---|
| `def:scheme_modules_tensorobj` | `Scheme.Modules.tensorObj` | yes | no | yes |
| `lem:scheme_modules_tensorobj_functoriality` | `Scheme.Modules.tensorObj_functoriality` | yes | no | yes |
| `lem:restrictscalars_laxmonoidal` | `PresheafOfModules.restrictScalarsLaxMonoidal` | yes | no | yes |
| `lem:tensorobj_restrict_iso` | `Scheme.Modules.tensorObj_restrict_iso` | yes | no | yes |
| `lem:restrictscalars_ringiso_tensorequiv` | `restrictScalarsRingIsoTensorEquiv` | yes | no | yes |
| `lem:restrictscalars_ringiso_strongmonoidal` (5 decls) | all 5 | yes | no | (no `\leanok`) |
| `lem:tensorobj_preserves_locally_trivial` | `Scheme.Modules.tensorObj_isLocallyTrivial` | yes | no | yes |
| `def:presheaf_internal_hom_value` | `InternalHom.homModule` | yes | no | yes |
| `def:presheaf_internal_hom_slice_value` | `InternalHom.internalHomObjModule` | yes | no | yes |
| `def:presheaf_internal_hom` | `InternalHom.internalHom` | yes | no | yes |
| `lem:presheaf_internal_hom_restriction` | `InternalHom.restrictionMap` | yes | no | yes |
| `def:presheaf_dual` | `PresheafOfModules.dual` | yes | no | yes |
| `def:scheme_modules_isinvertible` | `Scheme.Modules.IsInvertible` | yes | no | yes |
| `lem:tensorobj_assoc_iso` | `Scheme.Modules.tensorObj_assoc_iso` | yes | transitively via `isLocallyInjective_whiskerLeft_of_W` | yes |
| `lem:tensorobj_comm_iso` | `Scheme.Modules.tensorObj_braiding` | yes | no | yes |
| `lem:tensorobj_lift_onproduct` | `Scheme.Modules.tensorObjOnProduct` | yes | no | yes |
| `thm:rel_pic_addcommgroup_via_tensorobj` | `PicSharp.addCommGroup_via_tensorObj` | yes | body sorry | yes |
| `lem:tensorobj_inverse_invertible` | `Scheme.Modules.exists_tensorObj_inverse` | yes | body sorry | yes |

### Blueprint-pinned declarations absent from the Lean file
- **`AlgebraicGeometry.Scheme.Modules.dual`** (`lem:internal_hom_isSheaf`) — absent. Blueprint has NO `\leanok`. Consistent.
- **`AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial`** (`lem:dual_isLocallyTrivial`) — absent. Blueprint has NO `\leanok`. Consistent.
- **`AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid`** (`lem:tensorobj_isoclass_commgroup`) — absent. Blueprint has NO `\leanok`. Consistent.
- **`AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`** (`lem:pullback_compatible_with_tensorobj`) — not found in this file; may reside in `LineBundlePullback.lean`. Blueprint has NO `\leanok`. Outside scope of this file pair.

---

## Red flags

### Placeholder / suspect bodies
- **`PresheafOfModules.internalHomEval`** (line 1449): naturality field is `sorry`. This is NOT a must-fix: (a) the declaration is correctly identified in the blueprint with `\leanok` on the statement block, (b) the proof block lacks `\leanok`, (c) the `% NOTE:` and Lean docstring both explicitly acknowledge the open obligation. The sorry is a typed structural placeholder, not a weakened statement.
- **`Scheme.Modules.exists_tensorObj_inverse`** (line 1878): body is `sorry`. Infrastructure-blocked as described in docstring. Blueprint's `lem:tensorobj_inverse_invertible` has `\leanok` on statement (correct) but not on proof. Not a new this-iter finding.
- **`PicSharp.addCommGroup_via_tensorObj`** (line 1931): body is `sorry`. Consumer-level; blocked on upstream obligations. Blueprint `\leanok` on statement only. Not a new this-iter finding.
- **`isLocallyInjective_whiskerLeft_of_W`** (line 602): body is `sorry`. Blueprint `lem:islocallyinjective_whisker_of_W` has `\leanok` on statement. Consistent.

### Missing `\lean{...}` pins for declarations present in the Lean file
These blueprint blocks have Lean implementations but lack `\lean{...}` tags:
- **`lem:islocallyinjective_whisker_of_W`** — has `\leanok` on statement but NO `\lean{...}`. The Lean declaration is `isLocallyInjective_whiskerLeft_of_W`. A `\leanok` without a `\lean{...}` pin is inconsistent (how does `sync_leanok` track it?).
- **`lem:isiso_sheafification_map_of_W`** — has `\leanok` on statement but NO `\lean{...}`. The Lean declaration is `isIso_sheafification_map_of_W` (line 679).
- **`lem:stalk_linear_map`** — NO `\lean{...}` and NO `\leanok`, but four axiom-clean Lean declarations exist: `stalkLinearMap`, `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso` (lines 726-806).
- **`lem:flat_whisker_localizer`** — NO `\lean{...}` and NO `\leanok`, but `W_whiskerLeft_of_flat` and `W_whiskerRight_of_flat` (plus `isLocallyInjective_whiskerLeft_of_flat`, `isLocallySurjective_whiskerLeft`) exist and are axiom-clean (lines 413-554).
- **`lem:whisker_of_W`** — NO `\lean{...}` and NO `\leanok`, but `W_whiskerLeft_of_W` and `W_whiskerRight_of_W` exist and are axiom-clean (lines 642-668).

### Missing `\leanok` on statement blocks despite axiom-clean Lean declarations
- **`lem:tensorobj_unit_iso`**: `\lean{..., tensorObj_left_unitor, ..., tensorObj_right_unitor}` both exist without sorries (lines 1568, 1578) but the statement block lacks `\leanok`. `sync_leanok` should have added this; possible that the comma-separated multi-pin form is not handled by the tool.
- **`lem:presheaf_pushforward_adj_substrate`**: all 5 declarations (`pushforwardNatTrans`, `pushforwardCongr`, `pushforwardPushforwardAdj`, `isIso_of_isIso_app`, `restrictScalarsMonoidalOfBijective`) exist axiom-clean but the statement lacks `\leanok`. Same sync issue as above.
- **`lem:restrictscalars_ringiso_strongmonoidal`**: 5 declarations exist axiom-clean, no `\leanok` on statement block.

---

## Unreferenced declarations (informational)

The following substantive Lean declarations have no `\lean{...}` reference in the chapter (beyond those already flagged above):
- `restrictScalarsRingIsoTensorEquiv_apply_tmul` (line 199) — `@[simp]` lemma for `restrictScalarsRingIsoTensorEquiv`, a pure helper, acceptable.
- `restrictScalarsLaxε`, `restrictScalarsLaxμ` (lines 305, 321) — named sub-pieces of `restrictScalarsLaxMonoidal`, helpers, acceptable.
- `toPresheaf_whiskerLeft_app_tmul`, `toPresheaf_whiskerLeft_app_apply` (lines 392, 401) — helpers for whiskering lemmas, acceptable.
- `InternalHom.termRingMap`, `termRingMap_naturality`, `globalSMul`, `globalSMul_*` (lines 1012-1072) — assembly infrastructure for `homModule`, acceptable as sub-building-blocks.
- `InternalHom.restr`, `restrictionMap`, `restrictionMap_*`, `hom_app_heq`, `restrictionMapAddHom`, `internalHomPresheaf`, `restrictionMap_smul` (lines 1114-1272) — assembly pieces for `internalHom`, acceptable.
- `InternalHom.termRingMap_terminal`, `evalLin`, `evalLin_add`, `evalLin_smul`, `internalHomEvalApp` (lines 1317-1416) — eval building blocks. `internalHomEvalApp` is specifically called out in the `% NOTE:` comment for `lem:internal_hom_eval`.
- `restrictIsoUnitOfLE`, `tensorObjIsoOfIso`, `tensorObj_unit_iso` (lines 1682-1561) — substrate helpers; `tensorObj_unit_iso` feeds `lem:tensorobj_assoc_iso` proof but is itself only referenced in the `lem:tensorobj_unit_iso` `\lean{...}` pin via the unitors.
- `stalkLinearEquivOfIsIso` (line 801) — fourth d.1-done declaration, no dedicated pin.
- `pushforwardNatTrans_app_app_apply`, `pushforwardCongr_{hom,inv}_app_app` (lines 856-887) — `@[simp]` helpers for the presheaf pushforward, acceptable.

---

## Blueprint adequacy for this file

### Primary iter-222 focus: `lem:internal_hom_eval`

- **Coverage of `internalHomEval`**: adequate. `\lean{PresheafOfModules.internalHomEval}` is correct. The `% NOTE:` comment accurately describes the iter-221/222 state (per-open `internalHomEvalApp` built, naturality remaining).
- **Coverage of `internalHomEvalApp_tmul` and `restr_map_homMk`**: these are Lean-internal helpers with no blueprint counterpart, which is acceptable. The `% NOTE:` comment covers the role of `internalHomEvalApp` generally.
- **Proof-sketch depth for closing the naturality sorry**: **under-specified** for the next prover round. The blueprint proof (tex lines 2651-2673) says the naturality reduces to the evaluate/restrict-commutation identity `φ(s)|_V = (φ|_V)(s|_V)`, which is mathematically correct. However, the Lean docstring identifies a concrete technical obstacle — a `whnf` heartbeat bomb at the `𝟙_` instantiation of `restr_map_homMk` — and records three specific fixes:
  1. generalize the unit (don't instantiate to `𝟙_` early);
  2. use `pushforward_obj_map_apply'`;
  3. close elementwise.
  These are recorded in `task_results` (outside the blueprint), not in the proof sketch. The blueprint cannot guide a prover to the correct tactic approach from prose alone. A prover relying solely on the blueprint would know WHAT to prove but not HOW to avoid the heartbeat failure.

### Broader adequacy issues

- **Hint precision**: `lem:islocallyinjective_whisker_of_W` has `\leanok` without `\lean{...}` — `sync_leanok` cannot verify this automatically and the hint is imprecise for that block. Loose.
- **Proof-sketch depth (broader)**: adequate for the formalized declarations. The superseded-route blocks are clearly marked "not to be formalized."
- **Generality**: matches need.

### Recommended chapter-side actions
1. Add `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` to `lem:islocallyinjective_whisker_of_W` so `sync_leanok` can track it.
2. Add `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` to `lem:isiso_sheafification_map_of_W`.
3. Add `\lean{...}` pins (even if superseded) to `lem:stalk_linear_map`, `lem:flat_whisker_localizer`, `lem:whisker_of_W` for the Lean declarations that implement them.
4. **For the next prover round on `lem:internal_hom_eval`**: expand the proof sketch to mention the `whnf` obstacle and the three concrete fixes (generalize the unit, use `pushforward_obj_map_apply'`, or close elementwise) so the blueprint can serve as a tactical guide, not just a mathematical one.
5. Investigate why `lem:tensorobj_unit_iso`, `lem:presheaf_pushforward_adj_substrate`, and `lem:restrictscalars_ringiso_strongmonoidal` lack `\leanok` despite axiom-clean declarations — likely the comma-separated multi-pin form in `\lean{..., ...}` is not being parsed correctly by `sync_leanok`.

---

## Severity summary

### must-fix-this-iter
None. The `internalHomEval` sorry is correctly acknowledged in both the Lean docstring and the blueprint. The chapter does not present the declaration as closed. No fake/weakened statement, no signature mismatch, no excuse-comments on claims the blueprint calls real.

### major
1. **Blueprint proof of `lem:internal_hom_eval` under-specified for the whnf fix**: the naturality argument is mathematically correct but omits the three concrete tactic-level solutions to the heartbeat-bomb obstacle. A prover in round 223 will need the `task_results` information, not just the blueprint.
2. **`\leanok` without `\lean{...}` on `lem:islocallyinjective_whisker_of_W` and `lem:isiso_sheafification_map_of_W`**: `sync_leanok` cannot correctly track these blocks; the pins are missing.
3. **Missing `\leanok` on axiom-clean statement blocks** (`lem:tensorobj_unit_iso`, `lem:presheaf_pushforward_adj_substrate`, `lem:restrictscalars_ringiso_strongmonoidal`): likely a `sync_leanok` parsing failure on multi-pin `\lean{..., ...}` syntax. Stale blueprint state.

### minor
1. `internalHomEvalApp_tmul` not separately named in the blueprint (acceptable — helper for a `\lean{...}`-pinned block).
2. `restr_map_homMk` is `private` — correctly absent from blueprint.
3. `lem:stalk_linear_map`, `lem:flat_whisker_localizer`, `lem:whisker_of_W` have no `\lean{...}` pins despite their Lean implementations being present (superseded-route blocks — low priority but worth pinning for `sync_leanok` coverage).

**Overall verdict**: The blueprint-Lean correspondence for `lem:internal_hom_eval` is accurate and honest — the sorry state is correctly reflected, the `\lean{...}` pin is correct, and the chapter does not overclaim. The main gap is that the blueprint proof sketch does not capture the specific technical fix needed to close the naturality sorry, which is a guidance deficit for the next prover round rather than a correctness failure. 12 declarations checked, 0 must-fix red flags, 3 major findings, 3 minor findings.
