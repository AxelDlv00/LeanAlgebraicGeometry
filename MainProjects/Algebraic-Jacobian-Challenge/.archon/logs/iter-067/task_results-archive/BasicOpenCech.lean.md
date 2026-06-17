# Cohomology/BasicOpenCech.lean — iter-066 prover round

## Summary

**Mode**: Good. Iter-066 lands the **generic ModuleCat-level SplitEpi helper**
`splitEpi_pi_lift_of_injective`, fully proven (no sorry), capturing the
categorical fact that a product projection induced by an injection of index
sets is a split epi in `ModuleCat k`. This is precisely the structural fact
underlying `h_π_split (i : ℕ) : SplitEpi (π.f i)`: once `π.f i` is identified
with `Pi.lift (fun j' : Fin(i+1) → ↑s₀ => Pi.π M (g_FC.f ∘ j'))`, the helper
closes it.

Additional new scaffolding inside the main theorem:
- `h_inj : Function.Injective g_FC.f` — proved (`fun a b hab => Subtype.ext _`).
- `h_inj' (i : ℕ) : Function.Injective (fun j' => g_FC.f ∘ j')` — proved
  (pointwise from `h_inj`).
- Partial `simp` reduction inside `h_π_split` exposing the cochain-level
  structure of `π.f i`: after simping with `NatTrans.hcomp_app`,
  `Functor.whiskerLeft_app`, `NatTrans.id_app`, `HomologicalComplex.comp_f`,
  `HomologicalComplex.id_f`, the goal reduces to
  `SplitEpi (𝟙 ((alternatingCofaceMapComplex).obj _).X i ≫
              (alternatingCofaceMapComplex.map (whiskerRight g_simp.rightOp _)).f i)`
  which is one `Category.id_comp` + further `evalOp` unfolding away from the
  `Pi.lift` form the helper accepts.

- **Sorry trajectory (file-local)**: `15 → 15` syntactic `sorry`s inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (decomposition mode).
- **No new axioms** introduced.
- **No protected signatures modified**.
- **No other `.lean` file modified**.
- `lake env lean AlgebraicJacobian/Cohomology/BasicOpenCech.lean` succeeds
  with only the expected `declaration uses 'sorry'` warning.
- **File LOC**: 834 → 928 (+94 LOC: +52 for the helper + its docstring; +42 for
  the `h_inj`/`h_inj'`/documentation/simp scaffolding inside `h_π_split`).

## What was done (concrete code-level)

### New top-level helper `splitEpi_pi_lift_of_injective` (lines 342–391)

A fully-proven categorical helper:

```lean
noncomputable def splitEpi_pi_lift_of_injective {k : Type u} [Field k]
    {α β : Type u} (M : α → ModuleCat.{u} k)
    (f : β → α) (hf : Function.Injective f) :
    SplitEpi (Pi.lift (fun b : β => Pi.π M (f b))) where
  section_ := by
    classical
    refine Pi.lift (fun a => ?_)
    by_cases h : ∃ b, f b = a
    · exact h.choose_spec ▸ Pi.π (fun b => M (f b)) h.choose
    · exact 0
  id := by
    classical
    apply Pi.hom_ext
    intro b
    rw [Category.assoc, Pi.lift_π, Category.id_comp, Pi.lift_π]
    have h : ∃ b', f b' = f b := ⟨b, rfl⟩
    rw [dif_pos h]
    have key : ∀ {b b' : β} (heq : f b' = f b),
        heq ▸ (Pi.π (fun b'' => M (f b'')) b' :
            (∏ᶜ fun b'' => M (f b'')) ⟶ M (f b')) =
          (Pi.π (fun b'' => M (f b'')) b :
            (∏ᶜ fun b'' => M (f b'')) ⟶ M (f b)) := by
      intro b b' heq
      have hbb : b' = b := hf heq
      subst hbb
      rfl
    exact key h.choose_spec
```

**Mathematical content.** For `f : β → α` injective and a family of
`ModuleCat k` objects `M : α → ModuleCat k`, the product projection
`Pi.lift (fun b => Pi.π M (f b)) : ∏ᶜ M → ∏ᶜ (M ∘ f)` has a section: the
"extend by zero" map that sends each `b`-coordinate to the corresponding
`f b`-coordinate of the larger product, and zero on the complement of
`image f`. The section is defined via `Pi.lift` with a `by_cases` on whether
each `α`-index lies in `image f`; the splitting property is proved by
unfolding `Pi.lift_π`, using injectivity to identify `h.choose = b`, and
invoking a small auxiliary lemma `key` that collapses the dependent-equality
transport `h.choose_spec ▸ Pi.π _ h.choose = Pi.π _ b`.

**Why this is the right helper.** From the analysis below, `π.f i` is
precisely such a product projection. The cochain factor `K.X i` is
`∏ᶜ_{j : Fin(i+1) → s} F'.obj (op ((mk s).power(Fin(i+1)).obj j))` where
`F' = (sheafToPresheaf _ _).obj (toModuleKSheaf C)`. The map `π.f i` is
induced by precomposition with `g_FC.f` on multi-indices, so it is
`Pi.lift (fun j' : Fin(i+1) → ↑s₀ => Pi.π _ (g_FC.f ∘ j') ≫ F'.map (𝟙).op)`.
Since `F'.map (𝟙).op = 𝟙` (functor identity), this is exactly the form
accepted by `splitEpi_pi_lift_of_injective`.

### Decomposition inside `h_π_split` (lines 779–805)

Added before the `h_π_split` sorry:

```lean
have h_inj : Function.Injective (g_FC.f) := fun a b hab => by
  have : (g_FC.f a).1 = (g_FC.f b).1 := congrArg Subtype.val hab
  exact Subtype.ext this
have h_inj' (i : ℕ) :
    Function.Injective (fun (j' : Fin (i + 1) → ↑s₀) => g_FC.f ∘ j') :=
  fun a b hab => funext (fun x => h_inj (congrFun hab x))
```

These are the inputs the helper needs.

The body of `h_π_split` now contains a partial `simp` reduction:

```lean
have h_π_split (i : ℕ) : SplitEpi (π.f i) := by
  simp only [π, NatTrans.hcomp_app, Functor.whiskerLeft_app,
    NatTrans.id_app,
    HomologicalComplex.comp_f, HomologicalComplex.id_f]
  sorry
```

After this `simp`, the goal becomes:

```
SplitEpi (𝟙 ((alternatingCofaceMapComplex (ModuleCat k)).obj
              (evalOp _ _ ⋙ whiskeringLeft.obj (mk s).cech.rightOp).obj F').X i ≫
          ((alternatingCofaceMapComplex (ModuleCat k)).map
            (whiskeringLeft.map (NatTrans.rightOp g_simp)).app
              (evalOp _ _ .obj F')).f i)
```

which is one `Category.id_comp` + further unfolding away from the `Pi.lift`
form. Attempts at `rw [Category.id_comp]` failed: Lean reports
"Did not find an occurrence of the pattern `𝟙 ?m ≫ ?f`" — likely a motive
issue caused by the dependent-type `.f i` extraction. Workarounds for the next
iteration are listed below.

## Sorry inventory (post iter-066)

The 15 syntactic `sorry`s remain at the same lines as iter-065:

| Line | Sorry | Status |
|------|-------|--------|
| L453 | substep (a) on `s`-indexed slice cover (extra-degeneracy) | unchanged |
| L802 | `h_π_split (i : ℕ) : SplitEpi (π.f i)` | **decomposed**: helper + injection helpers in scope; one `Category.id_comp` away from helper-application |
| L817 | final `sorry` in `h_transport` (kernel argument + LES) | unchanged |
| L845 | substep (a) on `↑s₀`-indexed slice cover | unchanged |
| L887–889 | `h_mod_X₁/X₂/X₃ : Module R scK₀.Xᵢ` | unchanged |
| L896–899 | `f_R/g_R : scK₀.Xᵢ →ₗ[R] scK₀.Xⱼ` plus `hf_eq/hg_eq` | unchanged |
| L906–910 | `h_loc_X₁/X₂/X₃ : IsLocalizedModule.Away f.1 ...` | unchanged |
| L918 | `h_loc_exact (f : ↑s₀) : Function.Exact ...` | unchanged |

## Failed attempts and obstacles

### Attempt 1: direct `rw [Category.id_comp]` after the initial simp

**Approach.** After simping `π` with structural lemmas (`NatTrans.hcomp_app`,
`Functor.whiskerLeft_app`, `NatTrans.id_app`, `HomologicalComplex.comp_f`,
`HomologicalComplex.id_f`), the goal contains `𝟙 X ≫ f.f i`. The natural
next move is `rw [Category.id_comp]` to collapse this.

**Result.** `rw` fails with "Did not find an occurrence of the pattern
`𝟙 ?m.646 ≫ ?f`". The composition `𝟙 ... ≫ (functor.map _).f i` does
*lexically* match, but the rewriter cannot unify the universe-level / motive
of the rewrite. The likely cause: the `.f i` extraction creates a dependent
context that the simple `Category.id_comp` rewrite cannot navigate.

**Workarounds suggested for iter-067**:
- Try `slice_lhs` or `conv` to position the rewrite explicitly.
- Try replacing `rw [Category.id_comp]` with `simp [Category.id_comp]` (the
  simplifier handles the dependent context better).
- Try `change` to reshape the goal to the post-`id_comp` form (would require
  manually typing out the target).
- Try `erw [Category.id_comp]` (the relaxed-elaboration version).

### Attempt 2: bypass the simp reduction entirely via `splitEpi_pi_lift_of_injective`

**Approach.** Apply the helper directly, providing all expected arguments
(M = the cochain factor family, f = the postcomposition `g_FC.f ∘ -`,
hf = h_inj' i).

**Result.** Lean cannot unify the helper's conclusion (`SplitEpi (Pi.lift _)`)
with the goal (`SplitEpi (π.f i)`) because `π.f i` is not yet in the
`Pi.lift _` form — it's still wrapped in the FormalCoproduct evaluator + whisker
+ identity-composition layers. The simp reduction needs to push through these
layers first.

**Workarounds suggested for iter-067**:
- Continue the simp with more lemmas: `Category.id_comp`,
  `AlgebraicTopology.alternatingCofaceMapComplex_map`, and the `evalOp_map`
  simp lemmas to unfold the `Pi.lift`.
- Define an auxiliary equation `π_f_eq : π.f i = Pi.lift (fun j' => Pi.π M (g_FC.f ∘ j'))`
  as a separate `have`, then `rw [π_f_eq]` before applying the helper.

## Mathlib API used (new this iteration)

- `CategoryTheory.Limits.Pi.lift : ((b : β) → P ⟶ F b) → (P ⟶ ∏ᶜ F)` —
  product cone factorisation.
- `CategoryTheory.Limits.Pi.lift_π : Pi.lift f ≫ Pi.π _ b = f b` —
  the projection-after-lift simplification.
- `CategoryTheory.Limits.Pi.hom_ext` — the `ext` lemma for products.
- `CategoryTheory.IsSplitEpi` / `CategoryTheory.SplitEpi` — split epi data.
- `Category.assoc`, `Category.id_comp`, `Category.comp_id` — categorical
  associativity / identity.
- `dif_pos` — `if h : P then a else b = a` when `h` is positive.
- `Function.Injective`, `Subtype.ext`, `funext`, `congrFun` — for the injection
  helpers.

## Iter-067 recommendations

### Closest-to-closure target: `h_π_split` via the helper

The iter-066 helper `splitEpi_pi_lift_of_injective` reduces the obligation to
identifying `π.f i` with `Pi.lift (fun j' => Pi.π M (g_FC.f ∘ j'))`. The
mathematical content is fully laid out in the comments at L759–772. The
remaining technical work is a 5–15 line simp/rw chain that the iter-066 prover
ran out of time/budget for. Sub-routes:

1. **Sub-route A (preferred)**: `change` the goal explicitly to the post-simp,
   post-`id_comp`, post-`evalOp` form, then `exact splitEpi_pi_lift_of_injective _ _ (h_inj' i)`.
2. **Sub-route B**: continue the simp with `Category.id_comp`,
   `AlgebraicTopology.alternatingCofaceMapComplex_map`, and the `evalOp` simp
   lemmas. The goal should reduce to the helper-applicable form.
3. **Sub-route C**: define `π.f i` separately as a `noncomputable def` matching
   the `Pi.lift` form, prove it equals the current `π.f i` (via the simp chain
   from `cechFunctor.map`, `powerMap`, `evalOp_map`), then apply the helper.

### Secondary targets

After `h_π_split` closes, the iter-067 prover should attack the substep (a)
sorries (L453 + L845) via the extra-degeneracy chain
(`FormalCoproduct.extraDegeneracyCech` → `ExtraDegeneracy.homotopyEquiv` →
op-passage). Substep (a) at L453 is the unique sorry decoupled from the
s₀-refinement chain, so closing it doesn't depend on `h_π_split`.

The `h_mod_X` cluster (L887–889) requires unfolding `K₀.X i` as a Pi product
via the `evalOp_obj` simp lemma and installing `Pi.module` instances after
transport along `ModuleCat.piIsoPi`. This is independent of `h_π_split` and
can be pursued in parallel.

## Blueprint markers ready

- The theorem `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` still has
  a body with 15 syntactic sorries, so `\leanok` remains on the **statement**
  block only (no change).
- The new top-level helper `splitEpi_pi_lift_of_injective` is fully proven
  (kernel-only) and ready for a `\leanok` blueprint marker, but the blueprint
  chapter `Cohomology_MayerVietoris.tex` does **not yet have a statement block
  for this helper**. The plan agent should consider adding one in the next
  iteration if the helper sees broader use.

## Verification

- `lean_diagnostic_messages` on the whole file: 1 warning (`declaration uses
  'sorry'`, line 453 = the outer theorem) and 0 errors.
- Protected signatures unchanged.
- Iter-016 → iter-065 declarations untouched.
- File LOC: 834 → 928 (+94 LOC of helper + scaffolding).
- 15 syntactic sorries throughout, unchanged trajectory but **with new
  helper machinery in scope** to close `h_π_split`.
