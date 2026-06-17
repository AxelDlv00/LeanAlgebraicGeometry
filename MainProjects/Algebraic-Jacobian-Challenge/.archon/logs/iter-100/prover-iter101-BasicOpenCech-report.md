# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## cechCofaceMap_pi_smul `?hG` discharge sorry at L768 (was L728/L820/...)

### Attempt 1: S1 — `simp only [Pi.smul_apply]`
- **Approach:** Push the outer RHS `r' • _ j'` to `r' • (_ j')` via Pi.smul_apply on the post-funext goal.
- **Result:** RESOLVED. Goal shape changes from `... = (r' • _) j'` to `... = r' • _ j'`.

### Attempt 2: S2 — `show ... (Pi.π Z₂ j').hom _`
- **Approach:** Rewrite `e₂ _ j'` on both sides via `show` to `(ConcreteCategory.hom (Pi.π Z₂ j'))`.
  Direct `rw [ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j']` did NOT fire (the lemma's discrimination pattern `(ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) ?x j'` doesn't match `e₂ x j'` syntactically even though they're def-equal).
- **Result:** RESOLVED via `show` (def-eq pivot).

### Attempt 3: S3 — `← ConcreteCategory.comp_apply` x4
- **Approach:** Normalize `ModuleCat.Hom.hom = ConcreteCategory.hom` then absorb 4 nested applications `(Pi.π Z₂ j') (eqToHom_hom (smul_thing.hom (e₁.symm _)))` into single categorical morphism `((-1)^↑i • Pi.lift_thing) ≫ eqToHom ≫ Pi.π Z₂ j'`.
- **Result:** RESOLVED. Both LHS and RHS now have shape `(ConcreteCategory.hom (((-1)^↑i • Pi.lift_thing) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j')) (e₁.symm _)`. S1-S3 chain COMMITTED to file at L795-L807.

### Attempt 4: S4 — extract `(-1)^↑i •` from composition via `Preadditive.zsmul_comp`
- **Approach:** `rw [Preadditive.zsmul_comp]` (which states `(?n • ?f) ≫ ?g = ?n • ?f ≫ ?g` for `?n : ℤ`).
- **Result:** FAILED. Same discrimination-tree class issue persists POST-S3 just as pre-funext.
  Error: "Did not find an occurrence of the pattern `(?n • ?f) ≫ ?g`". The smul's underlying `f` is `Pi.lift fun i_1 ↦ ...` with anonymous-closure codomain `∏ᶜ (fun i_1 ↦ ModuleCat.of k Γ(...))`, blocking unification.
- **Verification:** `((-1 : ℤ) ^ (↑i : ℕ)) • Pi.lift_thing = same from rfl` succeeds (smul IS ℤ-zsmul). `set h_sgn : ℤ := (-1)^(↑i : ℕ)` substitutes (confirms ℤ). `simp_rw [Preadditive.zsmul_comp]` also fails. The lemma's RHS is in scope, the LHS scalar IS ℤ-typed, but the discrimination tree can't reach into the Pi.lift codomain.

### Attempt 5: body-local `have h_smul_hom (n : ℤ) (f : M ⟶ N) (x) : (n • f).hom x = n • f.hom x := by intros; rfl`
- **Approach:** Per iter-101 plan ESCALATION (E1) option — body-local helper bypassing discrimination tree.
- **Result:** FAILED. The helper TYPECHECKS (rfl proof closes it) but `simp only [h_smul_hom]` and `rw [h_smul_hom]` report "no progress". Same discrimination-tree class — the Pi.lift's anonymous-closure codomain blocks the pattern-match even for the body-local rfl-lemma.

### Attempt 6: `set Pi_lift_thing := Pi.lift fun i_1 ↦ ...`
- **Approach:** Per iter-101 plan ESCALATION (E2) option — name the closure so the smul's RHS has a binder name rather than literal anonymous closure.
- **Result:** PARTIAL FAILURE. `set` syntactically accepts the binding but does NOT substitute the pattern in the goal (`set` substitutes by syntactic match; `(∏ᶜ Z₁) ⟶ _` type ascription doesn't match the actual `∏ᶜ (fun i_1 ↦ ...)` codomain in the goal). Subsequent `rw [Preadditive.zsmul_comp]` still fails for the same reason.

## Iter-101 outcome summary

**Sorries: 6 → 6** (no net reduction). **STRUCTURAL ADVANCE**: S1-S3 of the 6-step recipe LANDED and committed. The post-S3 goal at L811 is now in the clean form `(ConcreteCategory.hom (((-1)^↑i • Pi.lift_thing) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j')) (e₁.symm _) = r' • (same) (e₁.symm _)` — the right shape for S4-S6 closure, but blocked by the same discrimination-tree class that defeated iter-099 + iter-100 pre-funext routes.

**Root cause confirmed**: The `Pi.lift fun i_1 ↦ ...` with anonymous-closure codomain `∏ᶜ (fun i_1 ↦ ModuleCat.of k Γ(C.left, op (∏ᶜ basicOpenCover ↑s₀ ∘ i_1)))` blocks Lean's discrimination tree at the `(?n • ?f) ≫ ?g` / `(n • f).hom` / `f ≫ Pi.π _` / `set f := Pi.lift _` levels — regardless of whether the lemma is a Mathlib `@[simp]` rfl (`ModuleCat.hom_zsmul`, `Preadditive.zsmul_comp`), a body-local rfl helper, or a manual `set` binding. The post-funext frame DOES NOT dissolve this class as iter-100 hypothesized.

**File compiles** (verified `lean_diagnostic_messages` severity=error returns `[]`). No new axioms. S1-S3 chain at L795-L807 is durably committed and serves as the foundation for iter-102's escalation.

## STREAK ESCALATION CRITERION TRIGGERED — iter-102 MANDATE

Per iter-101 plan: "If iter-101 also stalls after 3–4 sub-attempts at LSP, the prover MUST abort and write a SHORT report. The iter-102 plan agent will then MANDATE escalation."

Six sub-attempts at LSP exhausted (S4 raw `rw`, `simp_rw`, body-local `have` rfl, body-local `set`, `Preadditive.zsmul_comp` direct rewrite, `ModuleCat.hom_zsmul` direct simp). The discrimination-tree class is structural, not tactical.

### Recommended iter-102 escalation: option E2 (refactor lane)

Both E1 (body-local helper) and the in-place `set` approach FAIL because the discrimination tree cannot pattern-match through the anonymous-closure Pi.lift codomain — this is **not** a "body-local vs top-level" issue. The class fails at ANY level when the closure has nested `i`-references.

**Concrete iter-102 refactor directive**: introduce a top-level helper that takes the Čech summand morphism family as a **single named binder** of an explicit (named-codomain) Pi-product type. Specifically:

```lean
-- Top-level helper for iter-102
theorem cechCofaceMap_pi_smul_summand_via_named
    {k : Type u} [Field k] {R : Type*} [Ring R]
    {ι₁ : Type u} (Z₁ : ι₁ → ModuleCat.{u} k)
    {ι₂ : Type u} (Z₂ : ι₂ → ModuleCat.{u} k)
    [Module R (∀ i, Z₁ i)] [Module R (∀ j, Z₂ j)]
    (h : ι₂ → ι₁)  -- index re-mapping per coordinate
    (T : ∀ j, Z₁ (h j) ⟶ Z₂ j)  -- per-coordinate morphism
    (e₁ : (∏ᶜ Z₁) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂) ≃ₗ[k] ∀ j, Z₂ j)
    (hT : ∀ j (r : R) (y_j : Z₁ (h j)),
      e₂ ((T j).hom (r • y_j)) = r • e₂ ((T j).hom y_j))  -- placeholder: needs proper per-coord shape
    (n : ℤ) (r : R) (y : ∀ i, Z₁ i) :
    -- Per-coord R-linearity statement of `n • (Pi.lift via T) ≫ Pi.π _ j` ...
    sorry
```

The point: the family `T : ∀ j, Z₁ (h j) ⟶ Z₂ j` has a NAMED Pi-codomain at each coordinate, eliminating the anonymous-closure issue. The iter-102 prover applies it at the `?hG` discharge site via `congr` / `refine` against `T := fun j ↦ (toModuleKPresheaf C).map (Pi.lift _).op` with `h j := j ∘ δ_i.toOrderHom` peeled into a binder.

The iter-101 plan's E1 option (body-local helper) is now CONFIRMED INSUFFICIENT — six attempts at body-local routes all fail at the same discrimination-tree class. The refactor lane is the durable path.

### Alternative iter-102 escalation: option E3 (direct LinearMap.ext + funext-style)

Lean's discrimination tree fails on `Pi.lift fun i_1 ↦ <anonymous-i-body>`, but `LinearMap.ext`-based applications IGNORE the discrimination tree by lifting the equality to `∀ z, ... z = ... z`. Specifically:
```lean
-- inside the ?hG discharge at L811
apply LinearMap.ext_iff.mpr
intro z
-- goal: LHS z = RHS z, where both sides have explicit `Pi.lift fun i_1 ↦ ...` applied to z
-- now `simp only [Pi.lift]` or `Pi.lift_apply` can unfold the Pi.lift at the value level
```

This requires an additional `LinearMap` re-framing of the goal (since the current shape is at function-application level via `ConcreteCategory.hom`, not LinearMap level), but may be lighter than E2 if it works.

## Diff to file

S1-S3 chain (L795-L807) committed; smaller iter-101 diagnostic comments at L808-L810. Original sorry preserved at L811 with iter-102 escalation options documented inline.
