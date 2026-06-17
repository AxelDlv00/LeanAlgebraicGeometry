# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Iter-106 outcome: PARTIAL (Route 1 signature + transient sorry; L1147→L1179 sorry preserved)

**File compiles**: ✅ (`lean_diagnostic_messages` severity=error returns `[]`).
**Sorry count**: 7 (within hard cap budget of 7; was 6 entering iter-106).
**Net L1147 status**: NOT closed — remained as `sorry` at new line L1179.

## Route 1 lemma — signature committed, body sorry (L728–L751)

Added new top-level lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`:

```
theorem cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s₀ : Finset Γ(C.left, U)) (n : ℕ) (hn : 0 < n) (i : Fin (n + 1))
    (hRel : (ComplexShape.up ℕ).prev n + 2 = n + 1)
    (hCod : (∏ᶜ ...Fin ((prev n) + 2)...) = (∏ᶜ ...Fin (n+1)...)) :
    (cechCofaceMap_summand_family s₀ n (Fin.cast hRel.symm i)) ≫ eqToHom hCod
      = cechCofaceMap_summand_family' s₀ n hn i := by
  rcases n with _ | n'
  · omega
  · have hPrev : (ComplexShape.up ℕ).prev (n' + 1) = n' := by
      simp [ComplexShape.prev, ComplexShape.up_Rel]
    sorry
```

Signature elaborates cleanly. After `rcases n with _ | n'` + `omega` (zero case) +
`hPrev : (prev (n'+1)) = n'`, residual goal is the morphism equality between
`cechCofaceMap_summand_family s₀ (n'+1) (Fin.cast _ i) ≫ eqToHom hCod` and
`cechCofaceMap_summand_family' s₀ (n'+1) hn i`.

**Attempts to close the body** (all failed):
1. `refine Limits.Pi.hom_ext _ _ (fun j_new => ?_); rw [Category.assoc]; unfold ...; rw [Limits.Pi.lift_π]` — after unfold + Pi.lift_π on RHS, LHS still has `Pi.lift ≫ eqToHom hCod ≫ Pi.π Z₂ j_new`, can't apply Pi.lift_π directly past eqToHom.
2. `rw [eqToHom_refl, Category.id_comp]` — fails because `eqToHom_refl` requires literal `rfl` syntactic match, not propositional `hCod`.
3. `have hRfl : hCod = rfl := rfl` — fails: LHS/RHS of hCod have different indexing types `Fin ((prev (n'+1)) + 2) → s₀` vs `Fin (n'+1+1) → s₀` until `hPrev` substitutes.
4. `subst hPrev` — fails: would create infinite recursion on `n'`.
5. `simp only [hPrev] at hCod` — `simp made no progress`; `hPrev` doesn't fire on type annotations in hCod.
6. `aesop_cat` — fails to discharge after safe rules.
7. `ext; simp [cechCofaceMap_summand_family, cechCofaceMap_summand_family']` — reduces to per-coord eqToHom-vs-Pi.lift identification; same fundamental gap.

**Root cause**: identifying `eqToHom hCod ≫ Pi.π Z₂ j_new` with
`Pi.π Z_int (j_new ∘ Fin.cast hPrev) ≫ eqToHom (per-coord)` requires
explicit eqToHom-transport-through-Pi.π reasoning that Mathlib does not directly expose
for object-equality eqToHom between products with **different indexing types**.
The standard `eqToHom_naturality` is for naturality of single morphisms,
not for transporting Pi.π through an eqToHom that arises from index-type equality.

## L1147 → L1179 sorry — preserved (iter-105 partial proof intact)

The L1147 trailing sorry shifted to L1179 due to Route 1 lemma insertion (+~32 lines).
Iter-105's structured partial proof at L1097–L1144 (now L1131–L1178) preserved byte-for-byte.

**Attempts to close L1179** (all failed):
1. `simp only [ModuleCat.piIsoPi_hom_ker_subtype_apply] at h_wrap_pt` — `simp made no progress`
   because h_wrap_pt's `e₂.toLinearEquiv X j'` pattern differs from
   `piIsoPi_hom_ker_subtype_apply`'s `(piIsoPi Z).hom.hom x i` shape.
2. `rw [← ConcreteCategory.comp_apply (×4)]; rw [Preadditive.zsmul_comp]` —
   the `Preadditive.zsmul_comp` rewrite triggers **whnf timeout (>1600000 heartbeats)**
   at the `((-1)^↑i • F_at_i) ≫ eqToHom_outer ≫ Pi.π Z₂ j'` discrimination-tree match.
3. `rw [ModuleCat.hom_zsmul]`, `rw [ModuleCat.hom_nsmul]`, `rw [ModuleCat.hom_smul]`,
   `simp only [ModuleCat.hom_smul]` — none find a match for
   `ModuleCat.Hom.hom ((-1)^↑i • Pi.lift fun i_1 ↦ ...)`. The smul instance
   appears to be elaborated via a different path than the standard `ModuleCat.hom_smul`
   pattern.

## Iter-107 plan-agent recommendations

1. **Lift `cechCofaceMap_pi_smul` head heartbeats**: bump `set_option maxHeartbeats 1600000`
   to `3200000` or `6400000` for the `cechCofaceMap_pi_smul` theorem, then retry the
   `← ConcreteCategory.comp_apply (×4); rw [Preadditive.zsmul_comp]` chain. The whnf
   timeout suggests the unification is solvable with more budget.
2. **Alternative: rework Route 1 lemma without eqToHom**: parameterize by `i : Fin ((prev n) + 2)`
   directly (not `Fin (n+1)`) to eliminate the inner `Fin.cast hRel.symm i` roundtrip.
   Or use HEq + heq_of_eq to bypass the eqToHom-vs-Pi.π transport identification.
3. **Alternative: extra-degeneracy-free route**: completely bypass the wrapper
   (`cechCofaceMap_summand_family'`) approach and prove R-linearity of the unwrapped
   per-summand directly via Pi.hom_ext + per-coord scalar pullback. This would discard
   iter-105's wrapper + Route 1 lemma but may close L1179 in fewer steps.

## State preserved byte-for-byte

- `presheafMap_restrict_collapse` (L425) — iter-087.
- `cechCofaceMap_summand_family` (L454–L477) — iter-104.
- `cechCofaceMap_summand_family_R_linear` (L494–L595) — iter-104 closure.
- `cechCofaceMap_summand_family'` (L604–L629) — iter-105 wrapper.
- `cechCofaceMap_summand_family'_R_linear` (L634–L726) — iter-105 wrapper R-linearity.
- `alternating_sum_pi_smul_aux*` family — iter-097/098/099/102/103.
- `cechCofaceMap_pi_smul` body L1129–L1178 — iter-099 through iter-105 partial-proof
  scaffold preserved.

## New this iter

- `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` (L728–L751) — Route 1
  lemma signature (compiles, body sorry).
- L1129–L1178 inside `cechCofaceMap_pi_smul`: comment block updated with iter-106
  attempt notes + iter-107 plan-agent re-route guidance.

## Blueprint markers

No blueprint edits this iter (helpers are project-local without `\lean{...}` entries).

## Final verification

- `lean_diagnostic_messages` severity=error: `[]` (no errors).
- Sorry count: 7 (L751 Route 1 NEW transient + L1179 L1147→L1179 trailing + L1271 substep (a)
  + L1595 substep (b) + L1623 substep (a) for s₀ + L1813 g_R.map_smul' + L1842 h_loc_exact).
- Hard cap of 7 reached but not exceeded.
- No new axioms.
