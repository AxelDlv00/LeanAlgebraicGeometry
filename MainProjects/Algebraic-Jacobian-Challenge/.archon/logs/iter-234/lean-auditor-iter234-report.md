# Lean Audit Report

## Slug
iter234

## Iteration
234

## Scope
- files audited: 2 (as directed)
- files skipped per directive: all other project `.lean` files (narrow-scope directive)

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor — redundant simp alias)
- **excuse-comments**: 0 flagged

**LSP diagnostics**: zero errors, zero warnings, zero sorries.

**Axiom checks** (all 4 new declarations):
- `PresheafOfModules.stalkTensorDescU_smul`: `{propext, Classical.choice, Quot.sound}` — axiom-clean.
- `PresheafOfModules.stalkTensorDesc_germ`: `{propext, Classical.choice, Quot.sound}` — axiom-clean.
- `PresheafOfModules.stalkTensorLinearMap`: `{propext, Classical.choice, Quot.sound}` — axiom-clean.
- `PresheafOfModules.stalkTensorLinearMap_germ_tmul`: `{propext, Classical.choice, Quot.sound}` — axiom-clean.

**Notes:**

- **`stalkTensorDescU_smul` (lines 109–129) — genuine, non-vacuous.** The proof induction on `TensorProduct.induction_on` with three cases is the correct strategy for proving a ring-action compatibility at the section level. The `erw` at lines 123–124 (`stalkTensorDescU_tmul` × 2) and line 127 (`smul_add`) are explained by the CommRingCat/RingCat carrier duality: the module structure on `A(U) ⊗_{R(U)} B(U)` lives over the `RingCat` carrier of `R(U)`, while `r : R.obj (op U)` is a `CommRingCat` element. The `erw` works around a syntactic mismatch without hiding a wrong mathematical fact. Statement is correct: section-level tensor-product descent commutes with scalar multiplication.

- **`stalkTensorDesc_germ` (lines 175–180) — genuine.** A one-liner (`rw [← CategoryTheory.comp_apply, germ_stalkTensorDesc]`), direct consequence of `germ_stalkTensorDesc` (= `colimit.ι_desc`). Not trivially true in the degenerate sense — it relates two distinct maps (the colimit's composite and the per-neighbourhood descent). Correct.

- **`stalkTensorLinearMap` (lines 188–213) — genuine, most substantial new declaration.** The `toFun`/`map_add'` fields are immediate; `map_smul'` is the real content. The proof lifts `r` and `ξ` to sections over opens `U`, `V`, takes a common neighbourhood `W = U ⊓ V` via `inf_le_left`/`inf_le_right`, uses `germ_res_apply` to coherently rewrite both, then applies `← germ_smul` → `stalkTensorDesc_germ` → `stalkTensorDescU_smul` → `← stalkTensorDesc_germ` in sequence. Each rewrite step is mathematically justified. The pattern (common-neighbourhood argument for stalk-level linearity) is standard and correct.

- **`stalkTensorLinearMap_germ_tmul` (lines 218–225) — genuine but essentially a renamed alias of `stalkTensorDesc_germ_tmul`.** The body is exactly `stalkTensorDesc_germ_tmul A B x U hx a b`. Both carry `@[simp]`. The two have different syntactic heads (`stalkTensorLinearMap` vs. `ConcreteCategory.hom (stalkTensorDesc ...)`) so they do not conflict as simp lemmas; the alias serves downstream code that calls the `LinearMap` form. However, the near-duplication is a mild code smell (see Minor section).

- **`erw` vs `rw` asymmetry in `stalkTensorBilin_balanced` (lines 82–83).** `rw` is used for the A-side `germ_smul` (the expression sits on the left of the tensor), `erw` for the B-side (expression sits on the right). This asymmetry is a natural consequence of the direction in which the carrier mismatch manifests at the two tensor positions. Not suspicious.

- **File header** (lines 8–39): honest about remaining work ("the reverse map, and their mutual inversion on germs"). Not an excuse-comment.

---

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **outdated comments**: 1 flagged (minor — iteration-tagged STATUS block)
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged

**LSP diagnostics**: 2 `sorry` warnings, both at declaration start:
- Line 213: `affineBaseChange_pushforward_iso`
- Line 246: `flatBaseChange_pushforward_isIso`
(Note: the directive quoted "lines ~237 and ~259" — those are the `sorry` keyword positions within the proofs; the theorem declarations start at 213 and 246 respectively.)

**Axiom checks:**
- `AlgebraicGeometry.pushforwardBaseChangeMap`: axiom-clean (not separately verified; body is complete and has no sorry).
- `AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map`: `{propext, Classical.choice, Quot.sound}` — axiom-clean.
- `AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens`: `{propext, Classical.choice, Quot.sound}` — axiom-clean.
- `AlgebraicGeometry.affineBaseChange_pushforward_iso`: `{propext, sorryAx, Classical.choice, Quot.sound}` — sorry-bearing.
- `AlgebraicGeometry.flatBaseChange_pushforward_isIso`: `{propext, sorryAx, Classical.choice, Quot.sound}` — sorry-bearing.

**Notes:**

- **`pushforwardBaseChangeMap` (lines 76–83) — well-formed.** The construction via `pullbackPushforwardAdjunction` + the composite of unit, `pushforwardComp` hom, `pushforwardCongr`, and `pushforwardComp` inv is the standard categorical construction. The docstring matches the body.

- **Locality criteria (lines 99–166) — all axiom-clean.** `Modules.isIso_iff_isIso_stalkFunctor_map`, `Modules.isIso_of_isIso_app_of_isBasis`, and `Modules.isIso_iff_isIso_app_affineOpens` are complete proofs with no sorry. The stalkwise criterion correctly packages `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` via `TopCat.Sheaf.forget`; the basis criterion correctly uses `germ_exist_of_isBasis` for surjectivity; the affine-opens criterion correctly applies the basis criterion with `Subtype.val : X.affineOpens → X.Opens`.

- **`affineBaseChange_pushforward_iso` sorry (line 237) — honestly scoped.** The body does the correct first reduction:
  ```
  rw [Modules.isIso_iff_isIso_app_affineOpens]; intro U; sorry
  ```
  The remaining goal after the reduction is `IsIso (Hom.app (pushforwardBaseChangeMap ...) U)` for `U : S'.affineOpens`. This is the honest affine-local residual, not a vacuous simplification. The comment above the sorry (lines 219–236) correctly identifies what is missing: the affine tilde dictionary translating `Scheme.Modules.pushforward`/`pullback` of tilde-modules on `Spec` into restriction-of-scalars/base-change. The sorry is not masking a false statement.

- **`flatBaseChange_pushforward_isIso` sorry (line 259) — honestly scoped but pure.** The body is `sorry` with no reduction steps. The proof-strategy comment (lines 249–258) is plausible and consistent with standard algebraic geometry (Čech-cohomology / flat base change argument), but no progress has been made in the proof. **Transitive sorry:** this theorem depends on `affineBaseChange_pushforward_iso` in its strategy; if the affine case remains sorry'd, this theorem remains sorry'd even if the Čech infrastructure were built.

- **STATUS block comment (lines 181–205) — iteration-tagged, will stale.** The block contains `STATUS (iter-234):`, a reference to a specific API key failure (`MOONSHOT_API_KEY → HTTP 401; no other provider key set`), and explicit references to `task_results`. These details are environment- and iteration-specific and will be misleading in iter-235+. The documented iso construction is NOT in the file (it was a failed attempt); the comment is a progress note, not an excuse-comment on a landed declaration. However, environment references (`HTTP 401`) belong in `task_results`, not in `.lean` source. Minor.

---

## Must-fix-this-iter

- `AlgebraicGeometry/Cohomology/FlatBaseChange.lean:237` — `affineBaseChange_pushforward_iso` carries `sorryAx`; the theorem is a stated main result (load-bearing) with an incomplete proof. **Why must-fix:** `:= sorry` on a load-bearing claim per the must-fix criteria.

- `AlgebraicGeometry/Cohomology/FlatBaseChange.lean:259` — `flatBaseChange_pushforward_isIso` carries `sorryAx`; the theorem is a stated main result (load-bearing) with a pure `sorry` body and no proof progress. Additionally transitively sorry on the `affineBaseChange_pushforward_iso` above. **Why must-fix:** `:= sorry` on a load-bearing claim per the must-fix criteria.

---

## Major

*(none)*

---

## Minor

- `StalkTensor.lean:218` — `stalkTensorLinearMap_germ_tmul` is a `@[simp]` alias whose body is exactly `stalkTensorDesc_germ_tmul A B x U hx a b`. The lemma is needed for downstream code that calls the `LinearMap` form (`stalkTensorLinearMap`), so its existence is justified, but the docstring description ("The `R.stalk x`-linear repackaging `stalkTensorLinearMap` agrees with `stalkTensorDesc` on germs") could note this relationship more explicitly to avoid confusion about whether the two lemmas are interchangeable.

- `FlatBaseChange.lean:181` — STATUS block in a `/-! ... -/` section comment is iteration-tagged (`STATUS (iter-234):`) and contains environment-specific failure details (`MOONSHOT_API_KEY → HTTP 401; no other provider key set`). These will become misleading noise in subsequent iterations. The mathematical description of the blocker is worth preserving but the iteration marker and API failure details belong in `task_results`, not in `.lean` source.

---

## Excuse-comments (always called out separately)

*(none)* — The STATUS block (lines 181–205) documents a failed attempt and an honest blocker; it is a progress note, not an excuse-comment on a declaration claiming to be proved. No declaration in either file carries a comment of the form "temporary / placeholder / wrong but works / will fix later".

---

## Severity summary

- **must-fix-this-iter**: 2 — the two sorry-bearing theorems in `FlatBaseChange.lean`; they block downstream work that depends on flat base change.
- **major**: 0
- **minor**: 2 — one near-redundant simp alias in `StalkTensor.lean`; one iteration-tagged STATUS comment in `FlatBaseChange.lean`.
- **excuse-comments**: 0

**Overall verdict:** `StalkTensor.lean` is axiom-clean and all 4 new declarations are genuine, non-vacuous, and correctly proved; `FlatBaseChange.lean` carries 2 load-bearing sorry'd theorems (both with honest documentation of what is missing) plus 3 complete locality-criterion proofs that are axiom-clean.
