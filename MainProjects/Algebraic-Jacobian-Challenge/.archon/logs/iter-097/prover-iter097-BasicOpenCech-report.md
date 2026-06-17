# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-097 prover report

**Result:** PARTIAL PROGRESS. Step 1 fully closed (L478 → no sorry).
Step 2 partial (B1 bridge committed; full L657 closure deferred).
File compiles. Sorry budget: 7 → 6 (matches "Acceptable" iter-097 outcome).

## Step 1 — `alternating_sum_pi_smul_aux` body (was L478) — RESOLVED

### Attempt 1 (PRIMARY, COMMITTED)
- **Approach:** Plan-recipe `Finset.cons_induction` after `revert hF`.
  Empty case via `simp [Finset.sum_empty, ModuleCat.hom_zero, ...]`. Cons
  step uses `simp only [Finset.sum_cons, ModuleCat.hom_add, LinearMap.add_apply, map_add]`
  to distribute on BOTH sides simultaneously, then `rw [hF, ih, smul_add]`.
- **Result:** RESOLVED. LSP-verified `goals: []`, `diagnostics: []` via
  `lean_multi_attempt`. Final committed body L478–L494 (~16 lines).
- **Discovery:** First `rw`-only chain failed because `rw` only fires on
  matched LHS pattern instances; the second `Finset.sum_cons` chain ran
  out of patterns. Switching to `simp only` on the same lemma list fired
  on both LHS/RHS in one pass — clean closure.
- **Key insight:** `ModuleCat.hom_zero` (NOT `ModuleCat.zero_hom` as
  plan suggested) is the correct Mathlib lemma at
  `Mathlib.Algebra.Category.ModuleCat.Basic` for `(0 : M ⟶ N).hom = 0`.

## Step 2 — `cechCofaceMap_pi_smul` L657 trailing sorry — PARTIAL (B1 only)

### Attempt 1 (B1 BRIDGE, COMMITTED)
- **Approach:** `simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]`
  rewrites both `(Pi.π Z₂ j).hom z` occurrences to
  `(piIsoPi Z₂).hom.hom z j` form.
- **Result:** PARTIAL — committed at L656; goal advanced one step but the
  `(piIsoPi Z₂).hom.hom z j` form still has the OUTER `j`-eval and the
  INNER `((∑G) ≫ eqToHom).hom z` shape. The structural lemma's conclusion
  `e₂ ((∑F).hom z) = r • e₂ ((∑F).hom z')` is family-level (no `j`) and
  expects `(∑F).hom z` directly (no `≫ eqToHom`).

### Attempt 2 (suffices + congrFun + Pi.smul_apply, REVERTED)
- **Approach:** Hand-typed family-level `suffices h_fam : ... := by ...`
  with the literal alternating-sum body in the LHS/RHS of the family
  statement; then `simpa [Pi.smul_apply] using congrFun h_fam j`.
- **Result:** FAILED — `whnf` deterministic timeout (1.6M heartbeats) at
  L497 elaboration when the hand-typed literal triggered an instance-search
  cascade through `dif_pos hRel` / `ComplexShape.prev` reduction. Reverted.
- **Dead-end warning:** Hand-typing the alternating-sum literal in a
  `suffices` body re-introduces the iter-096 `whnf` timeout that defeated
  the refactor's `cechCofaceMap_pi_smul_summand` companion helper.

### Attempt 3 (refine alternating_sum_pi_smul_aux directly, FAILED)
- **Approach:** `refine congrFun (alternating_sum_pi_smul_aux Z₁ Z₂ Finset.univ ?F e₁ e₂ ?hF r y) j`
  to lift to family-level via `congrFun` and let Lean infer `?F` via
  Miller-pattern unification.
- **Result:** FAILED with two distinct errors:
  - First pass: `typeclass instance problem is stuck: Fintype ?m` —
    Lean cannot infer `Finset.univ`'s index type without an annotation.
  - Annotated as `(Finset.univ : Finset (Fin (n+1)))`: Type mismatch — the
    lemma's conclusion is `e₂ ((∑ i ∈ Finset.univ, ?F i).hom (e₁.symm (r•y))) j = (r • e₂ (...)) j`,
    but the goal's LHS is `(piIsoPi Z₂).hom.hom (((∑G_lit) ≫ eqToHom).hom z) j`.
    The `(∑F).hom z` vs `((∑G_lit) ≫ eqToHom).hom z` mismatch is not
    Miller-resolvable.

### Attempt 4 (rw [Preadditive.sum_comp] / rw [key₂] to push eqToHom inside, FAILED)
- **Approach:** Try `rw [Preadditive.sum_comp]` to convert `(∑G) ≫ E` to
  `∑(G_i ≫ E)`, putting the goal in the form the structural lemma expects.
- **Result:** FAILED on HOU. Pattern `(∑ j ∈ ?s, ?f j) ≫ ?g` does not
  match goal's `(∑ i, (-1)^↑i • Pi.lift (fun i_1 => ...uses i...)) ≫ eqToHom`
  because `?f i` cannot abstract the body's nested `i` references in
  non-Miller positions (`(-1)^↑i`, `(SimplexCategory.δ i).toOrderHom`,
  multiple uses).
- Same HOU on `rw [key₂]` and `simp only [key₂]` — confirmed iter-094/095's
  HOU diagnosis transfers verbatim to `Preadditive.sum_comp`.

### Attempt 5 (refine with explicit F including eqToHom, FAILED)
- **Approach:** `have h_struct := alternating_sum_pi_smul_aux Z₁ Z₂ Finset.univ
  (fun i => (-1)^↑i • Pi.lift (...) ≫ eqToHom (...)) e₁ e₂`
  with literal `Pi.π Z₁ (...)` body.
- **Result:** FAILED with deep type mismatch:
  ```
  Pi.π (basicOpenCover ?m ∘ ?m_1) (...)  has type
    ∏ᶜ basicOpenCover ?m ∘ ?m_1 ⟶ ...
  but is expected to have type
    (∏ᶜ fun a ↦ basicOpenCover (↑s₀) (i_1 a)) ⟶ ...
  ```
  Even with eta-expanded form `fun a => basicOpenCover ↑s₀ (i_1 a)`, the
  inner index-type of the secondary `Pi.lift` (over
  `Fin ((ComplexShape.up ℕ).prev n + 1)` vs `Fin (n+1)`) doesn't unify.
- **Dead-end warning:** The eqToHom in the goal comes from `dif_pos hRel`
  bridging `(prev n + 1) → ↥s₀` and `n → ↥s₀` index types. Hand-providing
  F with eqToHom baked in re-triggers this bridge as a unification problem
  outside tactic state where `dif_pos hRel` cannot fire.

### Attempt 6 (rw [← ConcreteCategory.comp_apply], FAILED)
- **Approach:** Absorb outer `(piIsoPi Z₂).hom` into a categorical
  composition `(((∑G) ≫ eqToHom) ≫ piIsoPi Z₂.hom).hom z`.
- **Result:** FAILED — `(ConcreteCategory.hom ?g) ((ConcreteCategory.hom ?f) ?x)`
  pattern not found. Both outer and inner are in `ConcreteCategory.hom`
  form post-iter-095 cosmetic; the lemma matches only when `g.hom` and
  `f.hom` compose, not when both are in the unified form.

## Final state (verified)

- **Sorries:** 6 (down from 7). Active: L657 (cechCofaceMap_pi_smul Step 2
  bridging — partial B1 progress added), L749 (substep a), L1073 (outer
  scaffolding), L1101 (s₀-extra-degeneracy), L1291 (g_R.map_smul'), L1320
  (h_loc_exact). NB: `sorry`-token count includes prose/comment occurrences;
  actual unfilled `by` slots are 6.
- **L478 (alternating_sum_pi_smul_aux):** CLOSED with full proof body
  L478–L494.
- **L657 (cechCofaceMap_pi_smul trailing):** SORRY remains, with iter-097
  Step 2 (B1) bridging committed at L653–L656 (`simp_rw [← piIsoPi_hom_ker_subtype_apply Z₂ j]`).
- **File compiles:** `lean_diagnostic_messages` severity=error returns `[]`.
- **No new axioms.**
- **No `first | ... | sorry` wraps.**
- **Per-step LSP-verified.**

## Concrete next step for iter-098 (recommendation)

The plan-agent's iter-098 contingency was: **"escalate to focused follow-up
refactor adding `alternating_sum_pi_smul_aux_pi_proj` (specialisation of
`alternating_sum_pi_smul_aux` whose conclusion bakes in the outer `Pi.π Z₂ j`
projection AND the `eqToHom`-codomain bridge, matching L657's goal shape
directly)."** This iter-097 prover report fully confirms that recommendation.

The structural problem: the bridging chain
`(piIsoPi Z₂).hom.hom (((∑G_lit) ≫ eqToHom).hom z) j → e₂ ((∑F).hom z)`
requires either
(a) `Preadditive.sum_comp` HOU-rewrite (DEFEATED by iter-094/095/097), or
(b) explicit-F type ascription with literal Čech body (DEFEATED by
    `whnf` timeout / type-mismatch through `dif_pos hRel`).

The refactor approach: add a SECOND structural lemma whose conclusion
already bakes in `(Pi.π Z₂ j).hom (...) = r • (Pi.π Z₂ j).hom (...)` and
the `(∑G) ≫ eqToHom` composition. Then iter-099 prover's call site
reduces to per-summand R-linearity discharge (well-trodden iter-090/091
template using `Pi.lift_π_apply`, `Pi.smul_apply`, `map_mul`,
`presheafMap_restrict_collapse`).

Concrete suggested signature for iter-098 refactor:
```lean
theorem alternating_sum_pi_smul_aux_pi_proj
    {k : Type u} [Field k]
    {R : Type*} [Ring R]
    {ι₁ : Type u} {ι₂ : Type u} (Z₁ : ι₁ → ModuleCat.{u} k)
    (Z_intermediate : ι₂ → ModuleCat.{u} k)
    (Z₂ : ι₂ → ModuleCat.{u} k)
    [_mZ1 : Module R ((∀ i, Z₁ i))] [_mZ2 : Module R ((∀ j, Z₂ j))]
    {ι' : Type*} (s : Finset ι')
    (G : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z_intermediate : ModuleCat.{u} k)))
    (E : (∏ᶜ Z_intermediate : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] ∀ j, Z₂ j)
    (hG : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((G i ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ ((G i ≫ E).hom (e₁.symm y))) (j : ι₂) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      (Pi.π Z₂ j).hom (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm (r • y))) =
        r • (Pi.π Z₂ j).hom (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm y))
```

Body: `Preadditive.sum_comp _ G E` rewrite + apply `alternating_sum_pi_smul_aux`
on `fun i => G i ≫ E`. Both rewrites are HOU-free at signature level
because G is a binder, not a literal. Iter-099 prover fills L657 with one
`exact` invocation.

## Markers

- `alternating_sum_pi_smul_aux` (L462): no `\lean{...}` blueprint entry
  (project-local helper). No marker needed.
- `cechCofaceMap_pi_smul` (L500): no blueprint entry. No marker needed.
- `presheafMap_restrict_collapse` (L425): no blueprint entry.
- No blueprint chapter edits this iter.
