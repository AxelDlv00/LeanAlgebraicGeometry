# Cohomology/BasicOpenCech.lean

## `cechCofaceMap_pi_smul` body L593 trailing sorry (iter-095)

### Iter-095 outcome summary

**Status**: NO substantive progress beyond iter-094. The HOU blocker on
the Čech alternating-sum body is structural (eqToHom-bridged Pi-product /
unfolded carrier type mismatch); ALL THREE planned routes (G), (H), (I)
and several variants are blocked. File compiles, 6 sorries (unchanged
from iter-094). Sorry budget hard cap (6) maintained.

### Single committed tactic (cosmetic cleanup at L592)

```lean
rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl]
```

This converts `ModuleCat.Hom.hom` to `ConcreteCategory.hom` uniformly in
the goal, since they are abbrev-equal (`Hom.hom f := ConcreteCategory.hom
(C := ModuleCat R) f` per `Mathlib.Algebra.Category.ModuleCat.Basic`
L113-115). Cosmetic only — no structural advance. LSP-verified
diagnostics empty.

### Goal at trailing `sorry` (L593) — verbatim from `lean_goal`

```
(ConcreteCategory.hom (Pi.π Z₂ j))
      ((ConcreteCategory.hom
          ((∑ i, (-1) ^ ↑i •
              Pi.lift fun i_1 ↦
                Pi.π (fun i ↦ ModuleCat.of k ↑(...basicOpenCover ↑s₀ ∘ i...))
                    (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))) ≫
                  (toModuleKPresheaf C).map
                    (Pi.lift fun x ↦
                        Pi.π (basicOpenCover ↑s₀ ∘ i_1)
                          ((SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i)) x)).op) ≫
            eqToHom ⋯))
        ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
    r • (ConcreteCategory.hom (Pi.π Z₂ j))
        ((ConcreteCategory.hom (... same expression ...))
         ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm y))
```

Both sides have outer `ConcreteCategory.hom (Pi.π Z₂ j)` applied to inner
`ConcreteCategory.hom ((∑F i) ≫ eqToHom ⋯)` applied to
`e₁.symm (r • y)` (LHS) / `e₁.symm y` (RHS).

### Route attempt log

#### Route (G) — Explicit-type `set F` (PLAN PRIMARY — FAILED)

**Tried**:
```lean
set F : Fin (n + 1) → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶
                       (∏ᶜ (fun i ↦ ModuleCat.of k ↑(...)) : ModuleCat.{u} k)) :=
  fun i => ((-1 : ℤ) ^ (i : ℕ)) • Pi.lift fun i_1 ↦ ... (verbatim body) ...
```

**Outcome**: ELABORATION SUCCEEDS (no error). But the `set` doesn't fold
the goal — i.e., the literal sum body remains in the goal after `set`,
NOT replaced with `∑ i, F i`. **Diagnosis**: `set` only renames upon
EXACT syntactic match. The plan's recipe required `change` first to fold
the inner `Pi.π (fun i ↦ ModuleCat.of k ↑(...))` back to a named `Z₁`-like
form, but the inner family uses `basicOpenCover ↑s₀ ∘ i` (composition
notation) whereas Z₁'s body uses `fun a ↦ basicOpenCover ↑s₀ (i a)`
(applied). These are eta-equivalent but not syntactically identical, so
the `change` fold cannot be expressed with `Z₁` directly.

The plan's recipe (`change` + `set F` + `rw [key₂ F]`) is in principle
sound but requires constructing a `change` target that EXACTLY matches
the goal's literal expression — which itself contains the same HOU
blocker we're trying to break. This is circular.

#### Route (H) — Second `← ModuleCat.hom_comp` to absorb outer `(Pi.π Z₂ j)` (FAILED)

**Tried**: several variants of `rw [← ModuleCat.hom_comp]` after
normalising the outer `Pi.π Z₂ j` to `ModuleCat.Hom.hom` form via
`show (Pi.π Z₂ j).hom _ = r • (Pi.π Z₂ j).hom _` and via the cosmetic
rewrite of `ModuleCat.Hom.hom = ConcreteCategory.hom`.

**Outcome**: `rw [← ModuleCat.hom_comp]` FAILS at the outer because the
pattern is `g.hom ∘ₗ f.hom` (LinearMap composition), but our goal has
`g.hom (f.hom x)` (function application). The natural intermediate
`← LinearMap.comp_apply` (to convert `f (g x)` to `(f ∘ₗ g) x`) ALSO
fails — pattern `?f (?g ?x)` doesn't match because the intermediate
type between the outer `Pi.π Z₂ j` (input `∏ᶜ Z₂`) and the inner
`(∑F i) ≫ eqToHom` (output `ModuleCat.of k (∀ i, ↑(Z₂ i))`, the eqToHom
target) is def-equal but not syntactically equal — `LinearMap.comp_apply`
requires syntactic intermediate-type match.

**Tried `← CategoryTheory.comp_apply`** (the categorical-level analog
in `Mathlib.CategoryTheory.ConcreteCategory.Basic`):
```lean
rw [← CategoryTheory.comp_apply]
```
The pattern is `(ConcreteCategory.hom ?g) ((ConcreteCategory.hom ?f) ?x)`.
The pattern doesn't unify with the goal because reconstructing the
categorical `?f ≫ ?g` requires `?f`'s codomain to syntactically equal
`?g`'s domain — and the eqToHom-bridged Pi-product / unfolded carrier
types are def-equal but not syntactically equal. **This is the
fundamental Route (H) blocker.**

#### Route (I) — `Finset.cons_induction` on `Finset.univ` (FAILED — typeclass synthesis stuck)

**Tried**:
```lean
induction Finset.univ using Finset.cons_induction with
| empty => simp
| cons i s hi ih => sorry
```

**Outcome**: FAILED with `typeclass instance problem is stuck: Fintype ?m.1151`
(also `AddCommMonoid ?m.1153` for `Finset.sum_induction`). Lean cannot
determine the carrier type for `Finset.univ` because the sum's
underlying carrier is implicit and the body has `i` in non-Miller
positions.

To make Route (I) work, the WHOLE goal would need to be rephrased
without the implicit `Finset.univ`, e.g., by generalising to an
arbitrary `s : Finset (Fin (n+1))` outside the goal. But this requires
abstracting the sum body — which itself has the HOU blocker we're
trying to break.

#### Route (X) — `Preadditive.sum_comp` variants via `conv_lhs => arg N; rw [...]` (FAILED)

**Tried**: `conv_lhs => arg 1; arg 1; rw [Preadditive.sum_comp]`,
`conv => rw [Preadditive.sum_comp]`, etc.

**Outcome**: FAILED — `conv` navigates correctly but at each focus point,
the pattern `(∑ j ∈ ?s, ?f j) ≫ ?g` doesn't match because the summand
body has `i` in non-Miller positions (HOU pre-filter rejection),
identical to the direct `rw` failure mode.

#### Route (Y) — direct `simp only [Pi.lift_π_apply]` and similar (FAILED)

**Tried**: `simp only [Pi.lift_π_apply]`, `simp only [Pi.lift_π]`,
ensemble simps.

**Outcome**: ALL "no progress" — the outer `(Pi.π Z₂ j)` and the inner
`Pi.lift` are separated by the eqToHom and the categorical composition,
so `Pi.lift_π` cannot fire (it needs `Pi.lift ≫ Pi.π = ...` shape,
not `Pi.π (Pi.lift ≫ ... ≫ eqToHom)` shape).

### Concrete next step (for iter-096)

The HOU blocker is fundamentally STRUCTURAL: the goal's summand body
references `i` in nested positions (`(-1)^↑i`, `SimplexCategory.δ i`
appearing TWICE: in the inner `Pi.π` and in the outer `.op`-wrapped
`Pi.lift`), making the summand NOT Miller-abstractable. Combined with
the eqToHom bridge between `∏ᶜ Z₂` and the unfolded
`ModuleCat.of k (∀ i, ↑(Z₂ i))` carrier, no `rw`-style or `simp`-style
distribution can fire.

**Recommended iter-096 escalation**: refactor subagent. Concretely:

1. **Bypass `Pi.lift`-of-`Pi.π`-composition.** Reformulate `scK₀.f`
   coordinate-wise from the start: define
   `scK₀.f.hom : (∀ i, Z₁ i) →ₗ[k] (∀ j, Z₂ j)`
   directly as a sum `(s • y) j := Σᵢ (-1)^i (presheaf-restriction)(y (j ∘ δᵢ))`
   in coordinates, BYPASSING the categorical Pi.lift / eqToHom
   construction entirely. R-linearity then follows from per-summand
   R-linearity of each presheaf-restriction.

2. **Strategy for the refactor**: extract `cechCofaceMap_pi_smul` to a
   reformulation that quantifies over a **fresh, abstract**
   `F : Fin (n+1) → ((∀ i, Z₁ i) →ₗ[k] (∀ j, Z₂ j))` family with
   per-`i` R-linearity hypotheses, then prove the alternating sum's
   R-linearity from those hypotheses. The actual Čech sum can then be
   plugged in at the call site, after the alternating-sum lemma is
   factored out.

3. **Why this works**: the abstract version `F : Fin(n+1) → R-linear-map`
   has no nested `i` references in non-Miller positions (the `i` is
   only the binder for `F`), so the structural lemma's proof goes
   through with standard HOU. The plug-in at the call site then closes
   the goal modulo a coordinate-wise R-linearity hypothesis per `Fᵢ`,
   which the `presheaf-restriction`-R-linearity supplies directly.

This requires REFACTORING the signature of `cechCofaceMap_pi_smul` (or
adding a new top-level helper). It is a 1-2 iteration refactor; the
mathematical content is unchanged.

### Sorry budget tracking (iter-095)

- Hard cap: 6.
- Actual iter-095: 6 (preserved; no regression).
- Substantive progress: 0 new committed tactic lines beyond iter-094;
  cosmetic `ModuleCat.Hom.hom → ConcreteCategory.hom` normalisation only.
- Iter-094 BREAKTHROUGH preserved: `rw [← ModuleCat.hom_comp]` at L570,
  `have key₂` at L580-L588 (proved, ready to apply once HOU bypassed).

### Final `lean_diagnostic_messages` output (mandatory)

```
{"result": {"success": true, "items": [], "failed_dependencies": []}}
```

**FILE COMPILES.** 0 errors. 6 sorries (L593, L685, L1009, L1037, L1227,
L1256) — unchanged from iter-094 in count (L589 → L593 due to 4 added
lines of cosmetic rewrite). No new axioms.

### Preserved iter-092/093/094 state (byte-for-byte)

- L551-L555: `have hom_sum_dist` (iter-092 Mathlib bind).
- L557-L564: `have key₁` (iter-093 per-application form, proved).
- L570: `rw [← ModuleCat.hom_comp]` (iter-094 eqToHom BREAKTHROUGH).
- L580-L588: `have key₂` (iter-094 categorical distribution, proved).

### Iter-095 inline addition

- L589-L592: 3-line comment + 1 tactic line normalising
  `ModuleCat.Hom.hom` to `ConcreteCategory.hom`. Cosmetic; preserves
  semantic state.

### Blueprint

`cechCofaceMap_pi_smul` is a project-local helper without its own
`\lean{...}` entry — no blueprint edits this iter.
