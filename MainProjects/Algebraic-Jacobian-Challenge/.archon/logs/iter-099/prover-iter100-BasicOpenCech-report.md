# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## cechCofaceMap_pi_smul L728 `?hG` discharge (iter-100)

**Outcome:** PARTIAL — `funext j'` structural step landed inside the discharge.
Sorry count unchanged (6, hard cap met). File compiles. No new axioms.

### Attempt 1 — recommended chain S1–S6 (per PROGRESS directive)
- **S1 (`set h_sgn : k := (-1) ^ (↑i : ℕ)`)**: FAILED. The goal still shows
  `(-1) ^ ↑i •` post-`set`. **Diagnostic insight**: `set h_sgn : ℤ` DID
  substitute; `set h_sgn : k` did NOT. So the scalar elaborates in ℤ
  (Preadditive ZSMul on `(∏ᶜ Z₁ ⟶ ∏ᶜ Z_inner)`), not k. The recommendation
  to `set : k` was inaccurate; iter-100 plan should have used ℤ.
- **S2 (`rw [Linear.smul_comp]`)**: FAILED — pattern `(?r • ?f) ≫ ?g` not
  found. Same issue as iter-099.

### Attempt 2 — ℤ-scalar variant
- `set h_sgn : ℤ := (-1) ^ (↑i : ℕ)` substitutes successfully (goal shows
  `h_sgn • Pi.lift_thing`). But then **`rw [ModuleCat.hom_zsmul]` FAILS** to
  find the pattern `ModuleCat.Hom.hom (?n • ?f)`. Same for `simp only`,
  `simp_rw`, `dsimp only`, and explicit `rw [h_test]` with locally bound
  `h_test : ∀ M N (n : ℤ) (f : M ⟶ N), (n • f).hom = n • f.hom := rfl`.

### Attempt 3 — diagnostic via `lean_run_code`
Verified that `ModuleCat.hom_zsmul` DOES fire in a closely-matched standalone
test:
```lean
example {ι : Type} {Z : ι → ModuleCat.{0} k} [HasProduct Z] {M : ModuleCat k}
    (n : ℤ) (f : M ⟶ ∏ᶜ Z) (x : M) :
    (n • f).hom x = n • f.hom x := by
  rw [ModuleCat.hom_zsmul]   -- WORKS
```
And with `(-1)^↑i` scalar and `i : Fin (n + 2)`: also works. So the lemma
is genuinely rfl-applicable on similar shapes. The actual goal differs in
that the Pi.lift's codomain is an **anonymous closure**
`∏ᶜ (fun i_1 ↦ Pi.π Z₁_unfolded (i_1 ∘ δ i) ≫ (toModuleKPresheaf C).map ...)`.
The discrimination tree's pattern unification appears to fail through this
closure even though the lemma's instance synth would succeed.

### Attempt 4 — categorical-level extraction
- `rw [Preadditive.zsmul_comp]` (BEFORE the L727 simp): FAILED with pattern
  `(?n • ?f) ≫ ?g` not found.
- `rw [Preadditive.nsmul_comp]`, `rw [CategoryTheory.Preadditive.zsmul_comp]`:
  same failure.
- `rw [Linear.smul_comp]`: same failure.

### Attempt 5 — `set f' := Pi.lift fun i_1 ↦ ...` to abstract the morphism
FAILED at the `set` step — the Pi.lift's body has elaboration-ambiguous
holes (the inner `Pi.lift fun x ↦ Pi.π (...)` can't be expressed without
explicit annotation, and the annotation collides with type-level coercions).

### Attempt 6 — pivot to per-coordinate via `funext j'`
WORKED. After `funext j'`, the goal becomes per-coordinate at `Z₂ j'`:
```
e₂ (eqToHom_hom (smul_thing.hom (e₁.symm (r' • y')))) j' =
  (r' • e₂ (eqToHom_hom (smul_thing.hom (e₁.symm y')))) j'
```

**Committed chain at L726–L768** (L728 → L768 due to documentation comments):
```lean
intro i _ r' y'
simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
-- [extensive iter-100 diagnostic comments]
funext j'
sorry
```

The `funext j'` step is a real structural advance — the per-coordinate
equation is at the `↑(Z₂ j')` level where R-action is concretely via
`RingHom.toModule (presheaf.map _).hom`, and `presheafMap_restrict_collapse`
applies directly without needing to push `(-1)^↑i •` through the chain.

### Result: IN PROGRESS (1 structural step landed, residual is per-coord R-linearity)
- Sorry budget: 6 (hard cap), unchanged from iter-099.
- File compiles (`lake build AlgebraicJacobian.Cohomology.BasicOpenCech` succeeds).
- No new axioms.
- Sorry locations (verified via `grep -nE '^\\s*sorry\\s*$'`):
  - L768 (was L728, iter-100 shift +40 from comment lines)
  - L860 (was L820)
  - L1184 (was L1144)
  - L1212 (was L1172)
  - L1402 (was L1362)
  - L1431 (was L1391)

### Concrete next steps for iter-101+

The per-coordinate equation post-`funext j'` decomposes as follows (iter-101
prover should execute step-by-step at LSP):

1. **Push j' through `r' • _` on RHS**:
   `simp only [Pi.smul_apply]` → `r' • e₂ (...) j'`.
2. **Push j' through `e₂` on both sides** via
   `ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j'`:
   `(Pi.π Z₂ j').hom (eqToHom_hom (...)) = r' • (Pi.π Z₂ j').hom (eqToHom_hom (...))`.
3. **Fuse `Pi.π Z₂ j' ∘ eqToHom_hom` into a single LinearMap** via
   `← ModuleCat.hom_comp` (categorical fuse): converts to
   `((smul_thing ≫ eqToHom ≫ Pi.π Z₂ j')).hom (e₁.symm (r' • y'))`.
4. **eqToHom-naturality on `eqToHom ≫ Pi.π Z₂ j'`**: this equals
   `Pi.π Z₂_unfolded j'` (where Z₂_unfolded is the anonymous closure form).
   At this point the `(-1)^↑i • Pi.lift_thing ≫ Pi.π Z₂_unfolded j'` should
   simplify via `Pi.lift_π_apply` to the j'-th summand of Pi.lift_thing
   (a single morphism, not a Pi.lift any more).
5. **j'-th summand R-linearity** is per-coordinate
   `(presheaf.map _).hom ∘ (Pi.π Z₁ (j' ∘ δ i)).hom`, which
   `presheafMap_restrict_collapse` (L425, fully proved iter-087) handles
   directly.
6. **The `(-1)^↑i •` scalar persists symmetrically through all of these
   steps** (it commutes with k-linear projections and with R-action), so
   `congr 1` (or `mul_smul`/`smul_comm`) factors it out at the end.

### Mathlib lemmas confirmed available for iter-101
- `ModuleCat.hom_zsmul` (rfl, but doesn't pattern-match in this context)
- `ModuleCat.piIsoPi_hom_ker_subtype_apply` (used iter-099)
- `Pi.smul_apply` (used iter-099)
- `Pi.lift_π_apply` (used iter-090)
- `← ModuleCat.hom_comp`, `← ConcreteCategory.comp_apply` (composition fuse)
- `Preadditive.zsmul_comp` (exists, but pattern fails here)
- `Linear.smul_comp` (exists, but pattern fails here)
- `presheafMap_restrict_collapse` (project-local L425, fully proved iter-087)
- `LinearEquiv.injective`, `funext`

### Dead-ends to avoid (carried forward to iter-101+)
- `rw [ModuleCat.hom_zsmul]` on the goal in its current form (post-L727 simp,
  pre-funext). The lemma is rfl but the pattern matcher can't find the
  occurrence through the Pi.lift's anonymous-closure codomain.
- `simp only [ModuleCat.hom_zsmul, LinearMap.smul_apply]`: same.
- `rw [Preadditive.zsmul_comp]`, `rw [Linear.smul_comp]`: pattern unification
  fails on `(?n • ?f) ≫ ?g`.
- `change e₂ ((ModuleCat.Hom.hom (eqToHom _)) ((((-1 : ℤ) ^ ↑i) •
  ModuleCat.Hom.hom (Pi.lift _)) ...)) = _`: the inner `_` placeholders
  can't be filled because the codomain types don't unify across the cast.
- `apply LinearEquiv.injective e₂.symm; funext j'`: doesn't work because
  the types of LHS and RHS of `LinearEquiv.injective`'s conclusion don't
  match through `e₂.symm` — the LHS becomes the unfolded `↑(∏ᶜ Z₂_unfolded)`
  but the RHS remains `e₂.symm (r' • e₂ ...)` which doesn't reduce.

### Suggested iter-101 plan-agent action
Either:
1. **Add `ModuleCat.hom_zsmul`-equivalent at the per-coordinate level** —
   the per-coordinate scalar push-out via `LinearMap.smul_apply` should fire
   when the per-coordinate equation is fully exposed (no Pi.lift wrapping).
2. **Refactor `cechCofaceMap_pi_smul` to use `Pi.lift_thing` as a let-binder
   at the body level**, so the family `G : ι' → (∏ᶜ Z₁ ⟶ ∏ᶜ Z_int)` in the
   iter-098 split-slot lemma is matched against the let-binder rather than
   the literal anonymous-closure. This sidesteps the discrimination-tree
   issue at the call site.
3. **Or insert a body-local `have h_scalar_extract` that explicitly proves
   `(h_sgn • Pi.lift_thing).hom = h_sgn • Pi.lift_thing.hom`** via direct
   case-by-case computation, then use `rw [h_scalar_extract]` instead of
   `ModuleCat.hom_zsmul`.

Iter-101 plan-agent should reassess based on this report.
