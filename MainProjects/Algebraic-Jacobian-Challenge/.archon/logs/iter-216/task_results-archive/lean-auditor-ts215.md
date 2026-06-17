# Lean Audit Report

## Slug
ts215

## Iteration
215

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 5 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: 0 flagged
- **notes**:
  - L739–742: `tensorObj` docstring says "the body is a typed `sorry`; the iter-203+ body lifts..." — the actual body is a real definition (the sheafification lift). Stale historical note.
  - L755–758: `tensorObj_functoriality` docstring says "scaffold: the body is a typed `sorry`; the iter-203+ body inherits..." — the actual body is a real definition (`sheafification.map` of `tensorHom`). Stale.
  - L866–867: `tensorObj_assoc_iso` docstring says "iter-212 status (typed `sorry`; **go/no-go bridge CLEARED, a NEW residual located**)" — the actual body at L903–946 is a complete real proof ending with `exact (@asIso _ _ _ _ _ hi1).symm ≪≫ e2 ≪≫ (@asIso _ _ _ _ _ hi3)`. Stale.
  - L1132: `tensorObjOnProduct` docstring says "iter-202 Lane TS scaffold: typed `sorry`" — the actual body at L1134–1136 is a real constructor `⟨tensorObj L.carrier L'.carrier, ...⟩`. Stale.
  - L38–41: Module-level status section states "each of the 4 pinned declarations carries the *intended* substantive type signature... with a `sorry` body" — two of the four (`tensorObj`, `tensorObj_functoriality`) are now real definitions; the monoidal-category instance was intentionally dropped (§2 pivot); only `addCommGroup_via_tensorObj` is still a sorry. The blanket "all 4 are sorry" claim misleads readers.
  - L519: Comment inside `isLocallyInjective_whiskerLeft_of_W`'s sorry body reads "-- ROUTE (e) residual:" while the enclosing section (L469), the lemma's own docstring (L497), and all tactic comments (L907, L910, L922) consistently call this construction ROUTE (d). Minor terminology inconsistency; the iter-214 correction block in the same comment (L522–545) provides the accurate picture.
  - L1160: `@[implicit_reducible]` attribute on `addCommGroup_via_tensorObj` — this is not a standard Lean 4 / Mathlib attribute name (standard options are `@[reducible]`, `@[semireducible]`, `@[irreducible]`). If unrecognized, Lean silently ignores or warns. Minor: confirm the attribute is registered and intentional; with a `sorry` body, any reducibility attribute has no semantic effect until the body lands.

---

## Focus-area audit results

### New definition: `restrictScalarsRingIsoTensorEquiv` (L115–193)

**Verdict: Genuine, complete, axiom-clean. No hidden `sorry` or `admit`.**

Detailed trace:

- **Signature** (L115–120): Takes `e : R ≃+* S`, bare `AddCommGroup`/`Module S` instances on `A, B`, introduces `letI` R-module structures via `Module.compHom _ e.toRingHom`, and produces `TensorProduct R A B ≃ₗ[R] TensorProduct S A B`. Statement is non-vacuous and mathematically correct.

- **Forward map `fwd`** (L125–140): Built via `TensorProduct.lift`. Inner `map_add'` uses `TensorProduct.tmul_add`; inner `map_smul'` uses a `change` asserting `a ⊗ₜ[S] (e r • b) = e r • (a ⊗ₜ[S] b)` (correct: R acts on the S-tensor via e) then `TensorProduct.tmul_smul`. Outer `map_add'` uses `simp [TensorProduct.add_tmul]`. Outer `map_smul'` uses a `change` asserting `(e r • a) ⊗ₜ[S] b = e r • (a ⊗ₜ[S] b)` then `rw [smul_tmul', smul_tmul]`. All `change` steps are honest definitional assertions under `Module.compHom`.

- **Backward additive map `bwdAdd`** (L144–159): Built via `TensorProduct.liftAddHom`. Maps `a ⊗ₜ[S] b ↦ a ⊗ₜ[R] b`. Scalar-swap proof (L152–159): `hsa` and `hsb` rewrite the S-scalar `s • a` as `(e.symm s : R) • a` using `e.apply_symm_apply`, then `TensorProduct.smul_tmul` closes `(s • a) ⊗ₜ[R] b = a ⊗ₜ[R] (s • b)`. Correct.

- **Backward as R-linear map `bwd`** (L160–175): `map_smul'` is proved by `TensorProduct.induction_on`. In the `tmul` case: `rw [TensorProduct.smul_tmul']` moves the S-tensor scalar to the left factor; the `change` exploits `r • a = e r • a` (definitional under `compHom`); a second `rw [TensorProduct.smul_tmul']` and `rfl` close it. The `add` case uses `rw [smul_add, map_add, map_add, hx, hy, smul_add]`. No tactic is masking a `sorry`.

- **Right inverse `fwd ∘ bwd = id`** (L177–187): `LinearMap.ext` + `induction_on`. `zero` case: `simp`. `tmul` case: two consecutive `change` steps reduce to `fwd (a ⊗ₜ[R] b) = a ⊗ₜ[S] b` (the first uses definitional unfolding of `liftAddHom` on a basic tensor; the second uses `TensorProduct.lift.tmul`). `simp only [fwd, TensorProduct.lift.tmul, ...]` closes it. `add` case: `rw [map_add bwd, map_add fwd, hx, hy]` closes with `rfl`. Honest.

- **Left inverse `bwd ∘ fwd = id`** (L188–193): `TensorProduct.ext'` + two `change` steps. Final `rfl` relies on `liftAddHom (a ⊗ₜ[S] b) = a ⊗ₜ[R] b` being definitional, which follows from `TensorProduct.liftAddHom`'s reduction on basic tensors. Legitimate `rfl`.

- **`LinearEquiv.ofLinear` discharge**: Both sides of the round-trip are explicitly proved; `LinearEquiv.ofLinear` at L176 is given the two proofs directly. No deferred `?_`.

### Pre-existing `sorry` bodies — confirmed genuine (not laundered)

| Declaration | Line | Status |
|---|---|---|
| `isLocallyInjective_whiskerLeft_of_W` | 546 | genuine typed `sorry`; substantive signature at L514–518 |
| `tensorObj_restrict_iso` | 1082 | genuine typed `sorry`; substantive signature at L1004–1006 |
| `exists_tensorObj_inverse` | 1125 | genuine typed `sorry`; substantive signature at L1121–1124 |
| `addCommGroup_via_tensorObj` | 1164 | genuine typed `sorry`; substantive signature at L1161–1163 |

None of these are `:= True`, `:= rfl` on a non-trivial statement, or any other laundering pattern. Each has a detailed docstring explaining the genuine Mathlib-absence obstacles.

### Known false-positive `opaque` scan (~L1037)

Comment at L1037–1038 reads "the OPAQUE abstract left adjoint". Not flagged — this is a docstring word, not a declaration keyword, per directive.

---

## Must-fix-this-iter

None.

No weakened-wrong definitions, no laundered sorries, no axioms on non-trivial claims, no excuse-comments, and no parallel-API anti-patterns were found. The four pre-existing `sorry` bodies are all genuine with substantive types and detailed documentation of their mathematical residuals.

---

## Major

- `TensorObjSubstrate.lean:739` — `tensorObj` docstring states "the body is a typed `sorry`; the iter-203+ body lifts..." but the definition at L743–746 is a real, complete definition (`sheafification.obj (tensorObj M.val N.val)`). Misleads a reader into treating a completed definition as outstanding work.

- `TensorObjSubstrate.lean:755` — `tensorObj_functoriality` docstring states "scaffold: the body is a typed `sorry`; the iter-203+ body inherits..." but the definition at L761–763 is complete (`sheafification.map (tensorHom f.val g.val)`). Same misleading-reader issue.

- `TensorObjSubstrate.lean:866` — `tensorObj_assoc_iso` docstring states "iter-212 status (typed `sorry`; **go/no-go bridge CLEARED, a NEW residual located**)" but the body at L907–946 is a real proof. The proof is non-trivial (three-step ROUTE (d) composite using `W_whiskerRight_of_W`/`W_whiskerLeft_of_W` + `isIso_sheafification_map_of_W`). Status claim is completely stale.

- `TensorObjSubstrate.lean:1132` — `tensorObjOnProduct` docstring states "iter-202 Lane TS scaffold: typed `sorry`" but the body at L1134–1136 is a real constructor. Stale.

- `TensorObjSubstrate.lean:38` — Module-level status section states "each of the 4 pinned declarations carries... a `sorry` body". Of the four pinned declarations, `tensorObj` and `tensorObj_functoriality` are now real definitions; the monoidal instance (`monoidalCategory`) was intentionally removed in the iter-206 pivot (§2); only `addCommGroup_via_tensorObj` remains a sorry. The blanket claim is factually wrong for at least two of the four items.

---

## Minor

- `TensorObjSubstrate.lean:519` — Comment "-- ROUTE (e) residual:" inside `isLocallyInjective_whiskerLeft_of_W`'s body is inconsistent with the enclosing section (L469: "ROUTE (d)") and the lemma's own docstring (L497: "ROUTE (d)"). The iter-214 correction block at L522–545 is internally coherent ("d.1", "d.2"); the discrepancy is only in the old L519 label. Low confusion risk given the correction block immediately follows.

- `TensorObjSubstrate.lean:1160` — `@[implicit_reducible]` is not a standard Lean 4 or Mathlib attribute name. If this is a project-local registered attribute, it should be documented; if it is silently ignored by Lean, it has no effect and is noise. Worth verifying the attribute's registration. (With a `sorry` body the reducibility setting has no semantic impact until the body is filled.)

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 — all stale docstrings claiming sorry/scaffold status for declarations that are now real definitions (or whose status has materially changed)
- **minor**: 2 — ROUTE labeling inconsistency; unrecognized attribute
- **excuse-comments**: 0

Overall verdict: The new `restrictScalarsRingIsoTensorEquiv` is a genuine, complete, axiom-clean construction with all round-trips discharged; the four pre-existing `sorry` bodies are genuine typed sorries; the primary finding is a cluster of stale docstrings that misrepresent several completed definitions as still-outstanding scaffolds.
