# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Iter-083 Lane 1 summary

- **Status**: IN PROGRESS — `h_diff_pi_smul_f` (sorry at L1240, shifted to L1323
  after this iter's comment-block expansion) not closed; iter-082's S5 prelude
  preserved byte-for-byte; iter-080 `letI` block and iter-081 S2+S3+S4 chain
  also preserved byte-for-byte; file compiles cleanly with **6 sorries** (no
  regression, no closure).
- **Sorry locations after iter-083**: L502, L826, L854, **L1323** (`h_diff_pi_smul_f`),
  L1368 (`g_R.map_smul'`), L1397 (`h_loc_exact`). Shift: L1240 → L1323, L1285 →
  L1368, L1314 → L1397 due to the ~80-line documentation block added at L1198+.
- **Net sorry change**: 6 → 6 (no regression, no closure).

## h_diff_pi_smul_f (L1323)

### Attempt 1 — direct `LinearMap.comp_apply` (iter-082 dead-end confirmed)
- **Approach**: `simp only [LinearMap.comp_apply, LinearMap.coe_comp, Function.comp_apply]`
  to split `(eqToHom_hom ∘ₗ Σ_hom) z = eqToHom_hom (Σ_hom z)`.
- **Result**: FAILED — `simp made no progress`.
- **Dead-end**: Mathlib's `LinearMap.comp_apply` has signature `(?f ∘ₛₗ ?g) ?x`
  (semilinear); the homogeneous `∘ₗ` in our goal has the heterogeneous
  underlying form but unifier won't bridge.

### Attempt 2 — direct `rw [LinearMap.comp_apply]`
- **Approach**: `rw [LinearMap.comp_apply, LinearMap.comp_apply]`.
- **Result**: FAILED — `Did not find an occurrence of the pattern (?f ∘ₛₗ ?g) ?x
  in the target expression`.
- **Dead-end**: Same root cause as Attempt 1.

### Attempt 3 — `show` with `LinearMap` form
- **Approach**: `show (...) ((... ∘ₗ ...) _) = _ • _` with explicit `Σ` form
  via `∑ i, (-1)^(↑i : ℤ) • _`.
- **Result**: FAILED — `failed to synthesize instance of type class Fintype ℤ`.
- **Dead-end**: The `∑ i` indexing requires `Fin (prev n + 2)` not `ℤ`; the
  syntactic instantiation needs the full Fin index to avoid this synthesis
  attempt.

### Attempt 4 — `subst hRel` to eliminate the eqToHom cast
- **Approach**: `subst hRel` to make `prev n + 1 = n` definitionally true so
  the eqToHom collapses to `𝟙 _`.
- **Result**: FAILED — `Tactic 'subst' failed: 'n' occurs at (ComplexShape.up
  ℕ).prev n + 1`. The substitution direction is wrong because `n` is the
  REFERENCED variable inside `prev n`, not the SUBSTITUTABLE one.

### Attempt 5 — `rw [hRel] at *` (creates duplicate variables)
- **Approach**: Force rewrite hRel everywhere in the goal context.
- **Result**: PARTIAL — rewrite succeeds but creates `Z₁✝, Z₂✝, Z₃✝, hn✝, ...`
  duplicates that break subsequent context references.
- **Dead-end**: Without `clear` of the duplicates (which fails due to
  dependencies), the context becomes unmanageable.

### Attempt 6 (iter-083 NEW) — `letI` to surface R-action + `rfl` smul commutation
- **Approach**: Add `letI := h_mod_X₁; letI := h_mod_X₂` to surface the
  R-module instances on `↑scK₀.X₁` / `↑scK₀.X₂`, then try
  `have : ((e₁.symm (r • y)) : ↑scK₀.X₁) = (r • (e₁.symm y : ↑scK₀.X₁) : ↑scK₀.X₁) := rfl`.
- **Result**: FAILED with TWO new diagnostic findings (see below).

**NEW FINDING (1)** — typeclass barrier persists despite `letI`. Even after
`letI := h_mod_X₁` / `letI := h_mod_X₂`, the ascription `(r • e₁.symm y :
↑scK₀.X₁)` fails to elaborate with `failed to synthesize instance of type
class HSMul ↑R ↑(∏ᶜ Z₁) ?m`. The reason: the outer type-ascription `:
↑scK₀.X₁` propagates *inward* during elaboration, and Lean tries to find
`HSMul ↑R ↑(∏ᶜ Z₁) ↑scK₀.X₁` (since `e₁.symm y : ↑(∏ᶜ Z₁)`). But `h_mod_X₁ :
Module ↑R ↑scK₀.X₁` provides `HSMul ↑R ↑scK₀.X₁ ↑scK₀.X₁`, NOT the
`↑(∏ᶜ Z₁)`-source-side variant. Verified via `lean_multi_attempt`: `(↑(∏ᶜ Z₁) :
Type _) = ↑scK₀.X₁ := rfl` succeeds (so the carriers ARE definitionally
equal), but instance unification does NOT propagate defeq through this
equality automatically.

**NEW FINDING (2)** — `e₁.symm (r • y) = r •_{h_mod_X₁} e₁.symm y` is NOT rfl.
Despite `h_mod_X₁ = e₁.toAddEquiv.module R` defining `r •_{X₁} z := e₁.symm
(r •_{Pi.module} e₁ z)`, the identity `e₁.symm (r • y) = r •_{X₁} e₁.symm y`
requires `e₁.apply_symm_apply` collapse on the inner argument, which is a
lemma not `rfl`. Verified diagnostic: `rfl`-proof for `r • e₁.symm y = e₁.symm
(r • y)` (with explicit `@HSMul.hSMul (α := ↑R) (β := ↑scK₀.X₁) r (e₁.symm y)`)
fails with `type mismatch: rfl has type ?m = ?m but is expected to have type
r • e₁.symm y = e₁.symm (r • y)`.

## Structural advance landed iter-083

Two `letI` statements added before the L1323 sorry:
```lean
letI := h_mod_X₁
letI := h_mod_X₂
```
These surface the R-module instances `h_mod_X₁`, `h_mod_X₂` (defined via
`AddEquiv.module R e_i.toAddEquiv`) into the proof context's typeclass cache,
so subsequent rewrite attempts can refer to `r • z` for `z : ↑scK₀.X₁` /
`↑scK₀.X₂`. This is a no-op for closure but enables iter-084+ to write goals
involving the transported R-action without re-deriving the instance.

A ~80-line documentation block records the two new findings above (typeclass
barrier persistence; non-rfl smul commutation through `e₁`).

## Iter-084 path forward (revised by this iter's findings)

The path (a) named-comp recipe from iter-083 PROGRESS.md needs revision:

1. **Introduce `let M_h : ↑scK₀.X₁ →ₗ[k] ↑scK₀.X₂ := scK₀.f.hom`** BEFORE the
   iter-081 simp chain at L1144. Defeq `↑scK₀.X₁ = ↑(∏ᶜ Z₁)` means the type
   unifies, and `simp` does NOT unfold local `let`s by default.

2. **After the iter-081 simp chain + iter-082 S5 prelude**, the goal should
   contain `M_h` (since simp didn't unfold it). Verify via `lean_goal`.

3. **`M_h.map_smul'` directly applies BUT is k-linear, not R-linear**, so
   `r : R` (not `k`) doesn't immediately work.

4. **ACTUAL closure route**: package per-summand R-linearity as a genuine
   `Φ_j : (∀ i, Z₁ i) →ₗ[R] ↑(Z₂ j)`, constructed via `LinearMap.mk` with
   explicit `map_smul'` proved by `Finset.sum_apply` + `Pi.smul_apply` (perI₁)
   + `RingHom.map_mul` + `presheaf.map_comp` + `algebraMap_naturality` (from
   `StructureSheafModuleK.lean` L161). Each summand at fixed `(i, j)` is
   R-linear because the restriction map `Γ(V_{j∘δ_i}) → Γ(V_j)` is an R-algebra
   hom (chain `R = Γ(U) → Γ(V_{j∘δ_i}) → Γ(V_j)` via presheaf functoriality).

5. **Then `Φ_j.map_smul r y` directly gives the desired equation**, and
   `congr 1` (matching `(Pi.π Z₂ j).hom` on both sides) closes it after
   unfolding `Φ_j`'s definition.

**Estimate revision**: the ~30 LOC estimate from iter-082 is optimistic; the
construction of `Φ_j` in step (4) is closer to 50–80 LOC because each summand
needs its own R-linearity proof (5 sub-steps each). The full Phase B closure
for `h_diff_pi_smul_f` is a multi-iteration project.

## Mathlib references confirmed

- `ModuleCat.piIsoPi_hom_ker_subtype` (already used in iter-082 S5 prelude).
- `ModuleCat.hom_comp`, `ModuleCat.hom_add`, `ModuleCat.hom_ofHom`,
  `ModuleCat.hom_id` — bundled-vs-unbundled hom conversions.
- `LinearMap.coe_comp : ⇑(f ∘ₛₗ g) = ⇑f ∘ ⇑g` — `∘ₛₗ` signature; does NOT
  unify with `∘ₗ` in our goal even though `∘ₗ` IS `∘ₛₗ` specialized to
  `RingHom.id k`.

## Approaches confirmed dead-end iter-083 (DO NOT re-attempt verbatim)

In addition to iter-082's documented dead-ends:
- **`subst hRel`** — fails because `n` occurs inside `prev n + 1` as a
  reference, not a fresh substitutable.
- **`rw [hRel] at *`** — creates duplicate variables that break the proof
  context.
- **`have ... = ... := rfl`** on the smul commutation `r • e₁.symm y =
  e₁.symm (r • y)` — fails despite `h_mod_X₁`'s `AddEquiv.module` definition,
  due to the non-rfl `apply_symm_apply` collapse.
- **`(... : ↑scK₀.X₁)` ascription** to bridge `HSMul ↑R ↑(∏ᶜ Z₁)` —
  fails because type-ascription propagates inward through `HSMul.hSMul`,
  triggering the `↑(∏ᶜ Z₁)`-side instance synthesis attempt.

## Blueprint markers

- L1323 `h_diff_pi_smul_f` is an INTERNAL claim inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. No standalone `\lean{}`
  hint. The enclosing theorem still has sorries — no `\leanok` to add
  (deterministic `sync_leanok` script will handle this).

## Blueprint chapter

The prompt referenced `blueprint/src/chapters/AlgebraicJacobian_Cohomology_BasicOpenCech.tex`
but no chapter file by that exact name exists. The relevant content (Stacks
01ED Čech acyclicity) lives in `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
§ "Čech acyclicity for the structure sheaf on affine basic-open covers", per
the iter-083 PROGRESS.md note. No blueprint edits made this iter (prover
agents do not edit blueprint).

## Hard constraints — all satisfied

- ✅ Preserved iter-080 `letI` refactor at L920–949 byte-for-byte (both
  `letI perI_n` AND `letI h_mod_pi_n := Pi.module _ _ _` for n = 1, 2, 3).
- ✅ Preserved `set_option maxHeartbeats 800000 in` at L418.
- ✅ Preserved iter-081's S2+S3+S4 chain at L1102–1153 (`intro r y; funext j;
  simp only [Pi.smul_apply]; have hRel; dsimp + full simp`).
- ✅ Preserved iter-082's S5 prelude at L1161–1170 (`rw [show ... from rfl]`
  re-fold + double `piIsoPi_hom_ker_subtype_apply`).
- ✅ No new project-local helper lemmas introduced.
- ✅ No new axioms.
- ✅ Sorry count: 6 → 6 (no regression, no closure).
