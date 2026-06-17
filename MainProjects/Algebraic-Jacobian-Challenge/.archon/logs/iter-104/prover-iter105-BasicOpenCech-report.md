# Cohomology/BasicOpenCech.lean — iter-105 prover report

## Summary

- **Sorries**: 6 (same as iter-104). File compiles end-to-end.
- **L1147 (was L988) `cechCofaceMap_pi_smul` trailing sorry**: **PARTIAL** — wrapper
  infrastructure added (Helper 1 + Helper 2 fully proved), partial proof attempt at
  the sorry exposes the per-summand R-linearity gap with the wrapper. The remaining
  gap is the per-coordinate eqToHom-vs-Pi.π transport identification.
- **Iter-104 closures preserved byte-for-byte**: `cechCofaceMap_summand_family`
  L454-L477, `cechCofaceMap_summand_family_R_linear` L494-L595 untouched.

## Step 1 — wrapper helpers (DONE, both compile, fully closed)

### Helper 1 — `cechCofaceMap_summand_family'` (wrapper def, L605–L633)

Defined as a direct `Pi.lift` over `Fin (n + 1) → ↑s₀` with `Fin.cast` applied to
the inner-index translation. The body matches the named family's structure at
each coordinate via `(j_new ∘ Fin.cast hRel) ∘ δ_(Fin.cast hRel.symm i).toOrderHom`.

```lean
noncomputable def cechCofaceMap_summand_family'
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s₀ : Finset Γ(C.left, U)) (n : ℕ) (hn : 0 < n) (i : Fin (n + 1)) :
    (∏ᶜ fun j : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀ => ...) ⟶
    (∏ᶜ fun j : Fin (n + 1) → ↑s₀ => ...) :=
  have hRel : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by
    rcases n with _ | k
    · omega
    · simp [ComplexShape.prev, ComplexShape.up_Rel]
  Pi.lift fun j_new : Fin (n + 1) → ↑s₀ =>
    Pi.π (...) ((j_new ∘ Fin.cast hRel) ∘ (SimplexCategory.δ (Fin.cast hRel.symm i)).toOrderHom) ≫
      (toModuleKPresheaf C).map (Pi.lift fun x => Pi.π (...) (Fin.cast hRel ((SimplexCategory.δ (Fin.cast hRel.symm i)).toOrderHom x))).op
```

### Helper 2 — `cechCofaceMap_summand_family'_R_linear` (R-linearity, L639–L728)

Mirrors the iter-104 proof structure of `cechCofaceMap_summand_family_R_linear`,
but with Fin (n + 1) outer index and Fin.cast on the inner δ-composition. Key
steps:
1. Reconstruct letI module instances (perI₁, h_mod_pi₁, perI₂, h_mod_pi₂).
2. `intro r y; funext j_new`.
3. `simp only [Pi.smul_apply]`, `show` pivot to `(Pi.π Z₂ j_new).hom`.
4. `unfold cechCofaceMap_summand_family'`, then `simp [Pi.lift_π_apply, ConcreteCategory.comp_apply]`.
5. Apply `ModuleCat.piIsoPi_inv_kernel_ι_apply` twice to peel off `e₁.symm`.
6. `simp [Pi.smul_apply, RingHom.toModule_smul]`.
7. `set Pl := Pi.lift fun x => Pi.π _ (Fin.cast hRel (δ x))` with `hPl_def`.
8. `exact (map_mul _).trans (congrArg (· * ...) (presheafMap_restrict_collapse _ _ _ r))`.

The proof closes fully (zero sorries in the wrapper R-linearity body).

## Step 1 closure on L1147 — PARTIAL (sorry retained)

At L1133–L1147 a structured partial proof is in place:

```lean
have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega
have h_wrap := cechCofaceMap_summand_family'_R_linear hU s₀ n hn (Fin.cast hRel' i)
have h_wrap_pt := congrFun (h_wrap r' y') j'
simp only [Pi.smul_apply] at h_wrap_pt
-- h_wrap_pt now has:
--   (e₂ (wrapper.hom (e₁.symm (r' • y')))) j' = r' • (e₂ (wrapper.hom (e₁.symm y'))) j'
sorry
```

### Remaining gap (precise)

The wrapper R-linearity equation `h_wrap_pt` provides:
```
(Pi.π Z₂ j').hom ((wrapper at (Fin.cast hRel' i)).hom (e₁.symm (r' • y'))) =
  r' • (Pi.π Z₂ j').hom ((wrapper at (Fin.cast hRel' i)).hom (e₁.symm y'))
```
(after `ModuleCat.piIsoPi_hom_ker_subtype_apply` unfolds `e₂ X j' = (Pi.π Z₂ j').hom X`).

The L1147 goal involves
`(Pi.π Z₂ j').hom (eqToHom.hom (((-1)^↑i • F_at_i).hom z))` where F_at_i is the
literal Pi.lift (definitionally `cechCofaceMap_summand_family s₀ n i`). The gap
is reducing the goal LHS to h_wrap_pt's LHS:

1. **Pull `(-1)^↑i •` out**: `((-1)^↑i • F).hom z = (-1)^↑i • F.hom z` (via
   `ModuleCat.hom_zsmul` + `LinearMap.smul_apply`). Then push through eqToHom
   and Pi.π Z₂ j' (both k-linear, hence ℤ-linear, via `map_zsmul`).

2. **Commute `(-1)^↑i •` past `r' •`** via `smul_comm` on Z₂ j' (R-module
   with ℤ acting as iterated addition).

3. **CORE GAP**: identify
   `(Pi.π Z₂ j').hom (eqToHom.hom (F_at_i.hom z))`
   with
   `(Pi.π Z₂ j').hom ((wrapper at (Fin.cast hRel' i)).hom z)`.

   This is morphism-level equality `F_at_i ≫ eqToHom_outer = wrapper at (Fin.cast hRel' i)`
   (or equivalently, their evaluations at coordinate j' are equal). Both are
   Pi.lifts into ∏ᶜ Z₂ — for the wrapper, by construction; for `F ≫ eqToHom`,
   via the eqToHom transport. Per-coord both give `(presheaf.map _.op).hom (z (some_index))`
   where `some_index` is `j_int ∘ δ_i.toOrderHom` for the named family vs
   `(j' ∘ Fin.cast hRel) ∘ δ_(Fin.cast hRel.symm (Fin.cast hRel i)).toOrderHom`
   for the wrapper at `Fin.cast hRel' i`. Modulo `Fin.cast_cast` round-trip
   (`Fin.cast hRel.symm (Fin.cast hRel i) = i`) and the choice `j_int = j' ∘ Fin.cast hRel`,
   these indices coincide.

   Mathlib does **not** directly expose eqToHom-vs-Pi.π transport for **object**
   equality eqToHom (only `Pi.π_comp_eqToHom` for index equality). Therefore the
   transport requires either:
   - explicit `convert` + `congr` on the eqToHom proof object (3-deep), or
   - a custom morphism-equality lemma proved by Pi.lift_ext + per-coord match.

   `convert h_wrap_pt using 2/3` was probed and produces 2 sub-goals of the
   form (LHS-of-goal) = (LHS-of-h_wrap_pt) and similarly for RHS — these are
   exactly the per-coord eqToHom transport identifications.

## Recommendations for iter-106

The wrapper infrastructure (Helper 1 + Helper 2) is in place and proved. The
remaining gap is purely the eqToHom-vs-Pi.π transport identification at
coordinate j'. Three concrete routes:

1. **Add a morphism-equality lemma** `cechCofaceMap_summand_family_comp_eqToHom_eq`
   stating `F_at_i ≫ eqToHom_outer = cechCofaceMap_summand_family' s₀ n hn (Fin.cast hRel' i)`,
   proved by `Pi.lift_ext` (or `Limits.limit_ext` from Mathlib) + per-coord match
   using `Pi.lift_π_apply` on both sides. The per-coord goal reduces to a
   `presheafMap` equality that follows from `Fin.cast_cast` + `funext`.

2. **rcases-on-n approach inside the per-summand discharge**: do
   `rcases n with _ | m` AFTER intro at L1096 (`intro i _ r' y'`). In the
   `m + 1` case, after `simp [ComplexShape.prev, ComplexShape.up_Rel] at *`,
   the eqToHom should collapse (Fin types align, eqToHom of refl = identity).
   Then `cechCofaceMap_summand_family_R_linear` applies directly. Was probed
   but the simp at * sometimes fails because (prev (m+1)) doesn't auto-simplify
   in all term positions.

3. **Use `convert h_wrap_pt using 3` + handle eqToHom sub-goals**: The two
   resulting sub-goals are exactly the per-coord transport. Each can be closed
   by `Pi.lift_π_apply` + `Fin.cast_cast` (round-trip) + `funext` + `rfl`.

Route 1 is the cleanest; Route 3 is the most direct from the current state.

## File state verification (iter-105)

| Metric | Before (iter-104) | After (iter-105) |
|---|---|---|
| Sorry count | 6 | 6 |
| Compiles? | ✅ | ✅ |
| Errors | none | none |
| New helpers | — | 2 (wrapper def + R-linearity, ~160 LOC) |
| L988→L1147 sorry | bare | structured partial proof |
| New axioms | 0 | 0 |
| `cechCofaceMap_summand_family` body | unchanged | unchanged |
| `cechCofaceMap_summand_family_R_linear` body | unchanged | unchanged |

Sorries (post-iter-105): **L1147** (cechCofaceMap_pi_smul trailing — partial),
L1239 (substep a extra-degeneracy, off-limits), L1563 (was L1404), L1591 (was
L1432), L1781 (was L1622), L1810 (was L1651). All non-target sorries are
unchanged from iter-104 (offset +159 lines from helper additions).

## Final `lean_diagnostic_messages` output

`severity=error`: `[]` (no errors). Only style/linter warnings remain
(show→change, long-line, unused-variable, flexible-tactic — all pre-existing
in the iter-104 baseline).
