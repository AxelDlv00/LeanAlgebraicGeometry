# Refactor Directive

## Slug

alt-sum-pi-smul-aux-sum-comp

## Problem

`AlgebraicJacobian/Cohomology/BasicOpenCech.lean` carries a trailing
`sorry` at **L657** inside `cechCofaceMap_pi_smul` (the iter-094
trailing sorry, B1-bridged by iter-097). The iter-097 prover landed
**Step 1** (filled the `alternating_sum_pi_smul_aux` body at L478–L494)
but failed **Step 2** (closing L657 by applying the structural lemma).

Six tactic-level attempts to bridge L657 into `alternating_sum_pi_smul_aux`'s
frame were exhausted (see `.archon/task_results/Cohomology_BasicOpenCech.lean.md`).
Root cause (Attempt 5 of that report): the existing structural lemma's
signature has

```lean
F : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k))
```

— a SINGLE morphism family going directly from `∏ᶜ Z₁` to `∏ᶜ Z₂`. But
the L657 goal's alternating sum is `(∑ i, G_lit i) ≫ eqToHom`, where
`G_lit i : ∏ᶜ Z₁ ⟶ ∏ᶜ Z_intermediate` lands in an INTERMEDIATE Pi
product (indexed over `Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀`)
and `eqToHom : ∏ᶜ Z_intermediate ⟶ ∏ᶜ Z₂` bridges to `Z₂`'s indexing
`Fin (n + 1) → ↑s₀` via `dif_pos hRel`. Instantiating `F := fun i ↦
G_lit i ≫ eqToHom` re-triggers the `Fin ((ComplexShape.up ℕ).prev n +
1) → ↑s₀` vs `Fin (n + 1) → ↑s₀` unification problem outside tactic
state where `dif_pos hRel` cannot fire, producing a deep type mismatch.

The structural fix is to introduce a parallel lemma that SPLITS the
`F` slot into a family `G` plus a single `E`, so that `eqToHom`
occupies the `E` slot at the call site without participating in the
family's index-type unification.

## Mathematical Justification

The new lemma is just the composition of `alternating_sum_pi_smul_aux`
with the categorical `Preadditive.sum_comp` distribution:

```
((∑ i ∈ s, G i) ≫ E).hom z = ((∑ i ∈ s, G i ≫ E)).hom z   -- Preadditive.sum_comp
                            = ∑ i ∈ s, (G i ≫ E).hom z    -- ModuleCat.hom_sum + LinearMap.sum_apply
```

Then the per-summand R-linearity hypothesis for `G i ≫ E` produces
R-linearity of the sum, identical to `alternating_sum_pi_smul_aux`.
Mathematically: a sum of R-linear maps composed on the right with any
R-linear map is R-linear; nothing new is being asserted.

Formal proof sketch (refactor agent leaves body as `sorry`; iter-099
prover fills):

```lean
intro r y
rw [Preadditive.sum_comp s G E]
exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y
```

The lemma `Preadditive.sum_comp` is verified at
`Mathlib.CategoryTheory.Preadditive.Basic` with type
`{C : Type u} [Category C] [Preadditive C] {P Q R : C} {J : Type _} (s : Finset J)
(f : J → (P ⟶ Q)) (g : Q ⟶ R) : (∑ j ∈ s, f j) ≫ g = ∑ j ∈ s, f j ≫ g`.

Reasoning that this avoids the iter-097 HOU and unification blockers:

1. **HOU avoidance:** `G` and `E` are LEMMA BINDERS. When `rw
   [Preadditive.sum_comp]` fires inside the body of the new lemma, the
   pattern `(∑ j ∈ ?s, ?f j) ≫ ?g` unifies trivially with `(∑ i ∈ s, G
   i) ≫ E` via Miller (G is named, not a literal with nested-i
   shadowing). Same for the `alternating_sum_pi_smul_aux` invocation
   — `F := fun i ↦ G i ≫ E` is a named composition, no nested-i
   `Pi.lift` literal to defeat HOU pattern matching.

2. **eqToHom-index unification avoidance:** At the **call site**
   (iter-099 prover at L657), `refine
   alternating_sum_pi_smul_aux_sum_comp Z₁ ?Z_int Z₂ ?G eqToHom e₁ e₂
   ?hG r y` (or `exact` with explicit instantiation) lets Lean
   elaborate `?Z_int` and `?G` against the goal's literal `(∑ i, G_lit
   i)` and `eqToHom`'s known type — these are independent slots, so
   `?Z_int := <intermediate-Z>` and `eqToHom : ∏ᶜ ?Z_int ⟶ ∏ᶜ Z₂` are
   solved by elaboration. There is no longer a single-slot `F :=
   fun i ↦ G_lit i ≫ eqToHom` that would force unifying the
   intermediate Pi-index type with `Z₂`'s.

3. **Universe consistency:** `ι_int : Type u` matches Lean's
   constraint on `Z_int : ι_int → ModuleCat.{u} k`; the call site's
   intermediate index is `Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀`,
   which is in `Type u` (since `↑s₀ : Type u`).

## Changes Requested

### File: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

Add a new top-level theorem `alternating_sum_pi_smul_aux_sum_comp`
**immediately after** `alternating_sum_pi_smul_aux` (i.e., right after
the line ending the body of `alternating_sum_pi_smul_aux` at the
current L494, before the `set_option maxHeartbeats ...` block that
precedes `cechCofaceMap_pi_smul`). The placement keeps the two
structural lemmas adjacent for readability.

**Exact signature to insert** (preserve verbatim, including all
universe annotations, bracketed instances, and binder ordering):

```lean
/-- Iter-098 refactor: sum-through-composition extension of
`alternating_sum_pi_smul_aux`. The existing lemma's single morphism
family `F : ι' → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z₂))` cannot absorb an intermediate
`eqToHom` because instantiating `F := fun i ↦ G i ≫ eqToHom`
re-introduces a `Fin (...) → ↑s₀` vs `Fin (n + 1) → ↑s₀` unification
problem outside tactic state (the iter-097 Attempt 5 dead-end). This
parallel lemma splits the morphism into a family `G : ι' → ((∏ᶜ Z₁) ⟶
(∏ᶜ Z_int))` plus a single `E : (∏ᶜ Z_int) ⟶ (∏ᶜ Z₂)`, so the
`eqToHom` slot at the call site lands in `E` (an independent
elaboration slot) rather than inside the family.

Body left as `sorry` for the iter-099 prover. Proof sketch:
`rw [Preadditive.sum_comp s G E]` to convert
`(∑ G i) ≫ E` to `∑ (G i ≫ E)`, then `exact
alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`.
Both rewrites are HOU-free at the signature level because `G` is a
binder, not a literal with nested-`i` Pi.lift body. -/
theorem alternating_sum_pi_smul_aux_sum_comp
    {k : Type u} [Field k]
    {R : Type*} [Ring R]
    {ι₁ : Type u} {ι_int : Type u} {ι₂ : Type u}
    (Z₁ : ι₁ → ModuleCat.{u} k)
    (Z_int : ι_int → ModuleCat.{u} k)
    (Z₂ : ι₂ → ModuleCat.{u} k)
    [_mZ1 : Module R ((∀ i, Z₁ i))] [_mZ2 : Module R ((∀ j, Z₂ j))]
    {ι' : Type*} (s : Finset ι')
    (G : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z_int : ModuleCat.{u} k)))
    (E : (∏ᶜ Z_int : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] ∀ j, Z₂ j)
    (hG : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((G i ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ ((G i ≫ E).hom (e₁.symm y))) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm y)) := by
  sorry
```

Notes for the refactor agent:

- **Do NOT fill the body.** Leave it as `sorry`. The iter-099 prover
  will fill it; this directive's job is structural only.
- **Do NOT modify `alternating_sum_pi_smul_aux`** (L462–L494). Its body
  was just closed by the iter-097 prover and must be preserved
  verbatim.
- **Do NOT touch `cechCofaceMap_pi_smul`** (L496 onward) or any of
  its inline `have`s, `rw`s, or the trailing `sorry` at L657. The
  iter-099 prover will modify the call site.
- **Verify the file compiles** after insertion (the new lemma's body
  is `sorry`, and that's the only new gap). Confirm via
  `lean_diagnostic_messages` severity=error returning `[]` (excluding
  the `declaration uses 'sorry'` warning, which is severity=warning).

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — one new
  top-level theorem inserted (~25 LOC including docstring). All other
  declarations unchanged. Sorry count: 6 → 7 (matches the directive
  intent: one new structural sorry for iter-099 prover).
- No other files affected; this is a purely additive structural
  change inside one file.
- `archon-protected.yaml` — unaffected (the new lemma is not
  protected; only the nine declarations in that file are protected,
  and none are touched).

## Expected Outcome

After the refactor:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` compiles.
- 7 syntactic sorries: L478-region NOTHING (was filled iter-097);
  the new `alternating_sum_pi_smul_aux_sum_comp` body at roughly
  L495–L520 (one new sorry); preserved L657 inside
  `cechCofaceMap_pi_smul`; preserved L749, L1073, L1101, L1291,
  L1320. Total = 7.
- The iter-099 prover (single substantive lane) has two related
  sorries to fill, both HOU-free at signature level:
  1. Body of `alternating_sum_pi_smul_aux_sum_comp` (~3 lines:
     `intro r y; rw [Preadditive.sum_comp]; exact
     alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG
     r y`).
  2. Closure of `cechCofaceMap_pi_smul`'s L657 trailing sorry by:
     (i) optionally reverting the iter-097 B1 bridge if it interferes
     (the `simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply]` at
     L656); (ii) applying the new lemma via `refine
     alternating_sum_pi_smul_aux_sum_comp Z₁ ?Z_int Z₂ Finset.univ ?G
     ?E e₁ e₂ ?hG r y` (or `exact` with explicit instantiation), with
     `?Z_int := <intermediate index family from goal>`, `?G := <Čech
     summand sans eqToHom>`, `?E := eqToHom`; (iii) discharging `?hG`
     per-summand inline using the iter-090/091 templates
     (`Pi.lift_π_apply`, `Pi.smul_apply`, `map_mul`,
     `presheafMap_restrict_collapse`, `rfl`); (iv) bridging the
     family-level `e₂ ... = r • e₂ ...` conclusion to the post-B1
     goal `(piIsoPi Z₂).hom.hom ... j = r • (piIsoPi Z₂).hom.hom ... j`
     via `congrFun ... j` + `Pi.smul_apply`. If the iter-097 B1
     `simp_rw` interferes with the new application, the iter-099
     prover may revert it (replacing it with a forward `simp_rw` at
     application time, or just removing it entirely so the conclusion
     of the new lemma matches the pre-B1 form modulo `(Pi.π Z₂ j).hom z
     = e₂ z j` definitional equality).
- No new axioms.
- The post-iter-098 line numbers will shift by ~25 lines below the
  insertion point; the iter-099 plan-agent must verify line numbers
  via `sorry_analyzer.py` and `lean_goal` before assigning the
  prover.

## Universe / Type-Class Hygiene Notes

- `ι_int : Type u` (matching `ι₁ : Type u` and `ι₂ : Type u`) ensures
  `Z_int : ι_int → ModuleCat.{u} k` lives in the same universe as `Z₁`
  and `Z₂`. The call site's intermediate index `Fin
  ((ComplexShape.up ℕ).prev n + 1) → ↑s₀` is in `Type u` because
  `↑s₀ : Type u` (subtype of `Γ(C.left, U) : Type u`).
- The `Module R (∀ i, Z₁ i)` and `Module R (∀ j, Z₂ j)` bracketed
  instances are declared identically to the existing
  `alternating_sum_pi_smul_aux`; the new lemma does NOT declare a
  `Module R (∀ k, Z_int k)` instance because it does not need to
  invoke R-linearity through the intermediate carrier — the per-summand
  hypothesis `hG` does all the R-linearity bookkeeping at the
  composed-morphism level `G i ≫ E`.
- The `{ι' : Type*}` and `s : Finset ι'` parameters mirror the
  existing lemma's signature.

## Specifically forbidden

- Do NOT introduce a `Module R (∀ k, Z_int k)` bracketed instance
  unless absolutely required (it isn't). Keep the instance count
  identical to `alternating_sum_pi_smul_aux`.
- Do NOT fill the body. `sorry` only.
- Do NOT modify any other declaration in the file. Pure addition,
  not a refactor of existing code.
- Do NOT introduce universally-false signatures or `axiom`
  declarations.
- Do NOT rename `alternating_sum_pi_smul_aux` to something else as
  part of this refactor. It stays.
