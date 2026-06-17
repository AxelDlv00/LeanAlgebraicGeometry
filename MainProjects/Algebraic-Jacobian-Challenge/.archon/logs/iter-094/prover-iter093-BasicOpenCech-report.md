# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## cechCofaceMap_pi_smul — step (b) [iter-093]

### Attempt 1 — Route (A) `simp_rw [hom_sum_dist]`
- **Approach:** Use `simp_rw` (HOU-tolerant) with `hom_sum_dist` from L555.
- **Result:** FAILED — `simp made no progress`. Also tried `simp_rw [ModuleCat.hom_sum]` directly; same.
- **Dead end:** `simp_rw` does NOT help for this goal — its HOU is no better than `simp only` here.

### Attempt 2 — Specialise `ModuleCat.hom_sum` via `have key₁`
- **Approach:** `have key₁ : ∀ F, ((∑ i, F i) : ((∏ᶜ Z₁) ⟶ (∏ᶜ Z₂))).hom = ∑ i, (F i).hom`. The `have` itself proves cleanly via `exact ModuleCat.hom_sum F Finset.univ`.
- **Result:** FAILED at `rw [key₁]` — same HOU pattern `ModuleCat.Hom.hom (∑ i, ?F i)` not found.
- **Dead end:** Specialising the bound type / index in the helper still produces the same discrimination-tree LHS shape. The HOU isn't about index polymorphism — it's about `rw`'s pattern matcher refusing to abstract a closure that captures the summation index.

### Attempt 3 — Per-application form `key₁ : ∀ F z, (∑F).hom z = ∑ (F i).hom z`
- **Approach:** Use `ModuleCat.hom_sum` to get `(∑F).hom = ∑ (F i).hom`, then `LinearMap.sum_apply` to push application inside. This produces a 2-argument form keyed on `F` AND `z`, eliminating any per-rewrite ambiguity.
- **Result:** PARTIAL — `have key₁` builds (file compiles, empty diagnostics). But `rw [key₁]` still FAILS with `(ModuleCat.Hom.hom (∑ i, ?F i)) ?z` not found. The goal has the sum INSIDE a `∘ₗ` composition: `(eqToHom_hom ∘ₗ (∑F).hom) z`. To match `key₁`'s LHS, `rw` would need to first unfold `∘ₗ`-application, which it doesn't do automatically.
- **Key insight:** **`key₁` is mathematically correct and proves cleanly.** The blocker is structural — the sum is wrapped inside `LinearMap.comp`.

### Attempt 4 — Unfold `∘ₗ`-application via `simp only [LinearMap.comp_apply]`
- **Approach:** Unfold `(eqToHom_hom ∘ₗ (∑F).hom) z = eqToHom_hom ((∑F).hom z)` so that `(∑F).hom z` is directly visible for `key₁` to match.
- **Result:** FAILED — `simp only [LinearMap.comp_apply]` reports "no progress". Also tried `simp only [LinearMap.coe_comp, Function.comp_apply]`, `rw [LinearMap.comp_apply]`, `rw [show (?g ∘ₗ ?h) ?x = g (h x) from fun _ _ _ => rfl]`. All fail with either "no progress" or "pattern not found `(?g ∘ₗ ?h) ?x`".
- **Diagnosis:** `set_option pp.notation false in show True` reveals the goal contains `((ModuleCat.Hom.hom (eqToHom ⋯)).comp (ModuleCat.Hom.hom (Finset.univ.sum fun i ↦ ...)))`. The `.comp` IS `LinearMap.comp`. But the `eqToHom` here has an implicit source ModuleCat (`?M`) that is NOT syntactically `∏ᶜ Z₂` — it's some def-equal but distinct unfolding (likely `ModuleCat.of k ((i : Fin (n+1) → ↥s₀) → ↑(Z₂ i))` from the `piIsoPi`-related context). So the `LinearMap.comp` LHS-pattern `(?f ∘ₗ ?g) ?x` fails to unify because its implicit ModuleCat-types don't match the goal's syntactic shape.

### Attempt 5 — `show` / `change` with explicit eqToHom source
- **Approach:** Force the goal into a syntactic form where the eqToHom source is named, then unfold.
- **Result:** FAILED — `show` reports `Application type mismatch: argument has type ?m ⟶ ?m' but is expected to have type ModuleCat.Hom ?m'' (∏ᶜ Z₂)` because the eqToHom term cannot be reconstructed from local `Z₁, Z₂` data alone (the source ModuleCat lives in a metavariable context fed by `dif_pos hRel` at L535).

### Attempt 6 — Categorical `Preadditive.sum_comp`
- **Approach:** Switch from LinearMap-level distribution to categorical-level `(∑ F) ≫ Pi.π Z₂ j = ∑ (F i ≫ Pi.π Z₂ j)` via `Preadditive.sum_comp` (verified to exist at `Mathlib/CategoryTheory/Preadditive/Basic.lean` L185). Then `.hom`-apply once and use `LinearMap.sum_apply`.
- **Result:** NOT REACHED — would require restructuring the proof BEFORE the iter-088 dsimp at L526–535, since dsimp unfolded the categorical structure into LinearMap form. Out of scope for iter-093.

## State at end of iter-093

- **Sorries:** 6 (L568, L660, L984, L1012, L1202, L1231). Hard cap respected (no regression from iter-092).
- **Compile status:** ✅ `lean_diagnostic_messages` returns `[]` for severity=error on full file.
- **Substantive iter-093 progress:** `have key₁` at L560–L567 — body-local per-application form of `ModuleCat.hom_sum`, fully proved with no sorries. This is real progress: it commits the (a)+(b)+(c) joint distribution into a single named helper that compiles, and pins down WHERE the next blocker lives (`∘ₗ`-unfolding before `rw [key₁]`).

## Goal at trailing sorry (L568)

After `have key₁`, the goal is unchanged from iter-092 entry:
```
(ConcreteCategory.hom (Pi.π Z₂ j))
  ((ModuleCat.Hom.hom (eqToHom ⋯) ∘ₗ
    ModuleCat.Hom.hom (∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ ...)
   ) ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
r • (ConcreteCategory.hom (Pi.π Z₂ j))
  ((ModuleCat.Hom.hom (eqToHom ⋯) ∘ₗ
    ModuleCat.Hom.hom (∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ ...)
   ) ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm y))
```

## Concrete failure mode & next-step route (iter-094 plan)

**Failure:** `LinearMap.comp_apply` (rfl-lemma) does NOT unfold `(eqToHom_hom ∘ₗ (∑F).hom) z`. Cause: the eqToHom's source ModuleCat is metavariable-driven (from the `dif_pos hRel` rewrite at L535) and the discrimination-tree LHS pattern `(?f ∘ₗ ?g) ?x` cannot bind `?g`'s codomain to it.

**Three concrete routes for iter-094:**

1. **Route (D) — `LinearMap.ext` then per-summand-`Pi.π Z₂ j ∘ (eqToHom ∘ F i)`-collapse.** Drop down a level: show `((Pi.π Z₂ j).hom ∘ₗ eqToHom_hom ∘ₗ (∑F).hom) = ∑ ((Pi.π Z₂ j).hom ∘ₗ eqToHom_hom ∘ₗ (F i).hom)` via `LinearMap.ext` and then use `key₁`. Then per-summand collapse Pi.π ≫ Pi.lift via Pi.lift_π.

2. **Route (E) — Generalize the eqToHom away.** The eqToHom comes from `dif_pos hRel`. Reverse-engineer the simp at L526–535 to bypass the `dif_pos` step (replace with an explicit `Eq.mpr`-cast that the prover controls), so the resulting goal uses syntactic `∏ᶜ Z₂` directly on both sides of `∘ₗ`. Then `LinearMap.comp_apply` should fire.

3. **Route (F) — Pre-dsimp Preadditive.sum_comp.** Reorder the iter-088 simp prefix: BEFORE applying `dif_pos hRel`, apply `Preadditive.sum_comp` to push `Pi.π Z₂ j` inside the sum at categorical level. This avoids the entire `(∑F).hom`-distribution dance because each summand is already projection-evaluated.

**Recommendation for iter-094 plan agent:** Route (D) is the most direct continuation of `key₁`. Routes (E) and (F) require restructuring the iter-088 simp prefix and are more invasive.

## Mathlib lemmas verified this iter

- `ModuleCat.hom_sum` (Basic.lean L359) — used directly in `key₁`'s proof.
- `LinearMap.sum_apply` (Submodule/LinearMap.lean L259) — used directly in `key₁`'s proof.
- `Preadditive.sum_comp` / `Preadditive.comp_sum` (CategoryTheory/Preadditive/Basic.lean L180–186) — verified to exist; reserved for Route (F) escalation.
- `ModuleCat.hom_add`, `ModuleCat.hom_zero` (Basic.lean) — verified.

## Files modified

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — replaced `sorry` at L570 with the `have key₁` block + trailing `sorry` at L568. File compiles. 6 sorries unchanged from iter-092.

## Blueprint impact

None this iter. `cechCofaceMap_pi_smul` is a project-local helper without a `\lean{...}` entry in `Cohomology_MayerVietoris.tex`; no blueprint edits expected.

## Final compile verification

`lean_diagnostic_messages` (severity=error, whole file): `[]`. File compiles. No new axioms.
