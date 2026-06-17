# Refactor Directive

## Slug

cechcoface-summand-extract

## Problem

The theorem `cechCofaceMap_pi_smul` in
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (L456–L593) has resisted
closure for four iterations (iter-092 → iter-095). Iter-092 repaired the
foundation (`letI` zeta-reduction; doc-comment placement). Iters 093–094 landed
two body-local helpers (`have key₁` at L557–L564 and `have key₂` at L580–L588)
and broke the eqToHom-syntactic blocker via `rw [← ModuleCat.hom_comp]` at L570.

After all that progress, the file compiles, the body still has the trailing
`sorry` at L593, and the active blocker is now **structural HOU**: applying
`key₂` (or the underlying `Preadditive.sum_comp`) to the post-(b') goal
HOU-fails because the summand body of the Čech alternating sum

```
(-1)^↑i • Pi.lift fun i_1 ↦
    Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom) ≫
    (toModuleKPresheaf C).map
        (Pi.lift fun x ↦ Pi.π (basicOpenCover ↑s₀ ∘ i_1)
            ((SimplexCategory.δ i).toOrderHom x)).op
```

references the outer summation index `i` in **non-Miller positions**:
- inside the cast `(-1)^↑i`;
- inside `SimplexCategory.δ i` (which appears TWICE: once in the inner
  `Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom)` and once in the
  outer `.op`-wrapped `Pi.lift fun x ↦ ... ((SimplexCategory.δ i).toOrderHom x)`).

The discrimination tree cannot abstract `?G i` over this body when applying any
`(∑ i, ?G i) ≫ ?E`-style rewrite. The iter-095 prover exhausted **all three**
of the planned tactic-level routes (G) explicit-type `set F` with `change`-fold;
(H) second `← ModuleCat.hom_comp` to absorb outer `Pi.π Z₂ j`;
(I) `Finset.cons_induction` manual unfold. Each failed for a distinct structural
reason (see `task_results/Cohomology_BasicOpenCech.lean.md` from iter-095).

The blocker is **not** a missing Mathlib lemma — Mathlib has every distribution
lemma we need (`Preadditive.sum_comp`, `ModuleCat.hom_sum`, `LinearMap.sum_apply`,
`map_sum`, `Finset.smul_sum`, etc.) and they're all individually verified
existent and well-typed. The blocker is that **at the application site, the
summand's `i`-dependency cannot be reified as a single `F i` Miller pattern**
because of the nested `i`-references in the body.

The fix is **structural**: extract a per-summand R-linearity statement to the
top level where `i` is an **explicit hypothesis** (not a summation binder),
so the per-summand obligation has no HOU at the application site. Then the
outer alternating-sum R-linearity reduces to a sum-of-R-linear-maps argument
plus per-summand discharge, both of which are HOU-free because the summand
family is bound to a single named symbol.

## Mathematical Justification

The Čech alternating coface map at degree `n` is, by construction, a finite
alternating sum:

$$\partial^n = \sum_{i = 0}^{n} (-1)^i\, \pi_{i,n} \circ d_i$$

where `d_i` is the simplicial coface (induced by `SimplexCategory.δ i`) and
`π_{i,n}` is the per-i presheaf restriction along the inclusion of the
corresponding intersection. Each summand is an `R`-linear map of finite
products of presheaf sections (because each summand factors through a fixed
presheaf restriction; `R` acts on both `Z₁` and `Z₂` via the same restriction
algebra structure via `presheafMap_restrict_collapse` at L412). A finite sum
of `R`-linear maps is `R`-linear. Therefore the alternating sum `∂^n` is
`R`-linear, which is exactly the statement of `cechCofaceMap_pi_smul`.

The mathematical content per summand is:
- (M1) `(toModuleKPresheaf C).map φ_i.op` is a ring homomorphism, hence
  `R`-linear with respect to the restriction algebra structure
  (`presheafMap_restrict_collapse`, fully proved at L412).
- (M2) `Pi.lift (fun i_1 ↦ ... ≫ map ...)` is `R`-linear when each
  component is.
- (M3) Scaling by `(-1)^↑i : ℤ` (the integer-graded sign) commutes with
  `R`-scalar multiplication.

These three are *independently provable per fixed `i`*. The HOU issue at
the alternating-sum stage is **purely syntactic**: it disappears the moment
`i` is a hypothesis (not a binder).

The structural sum-distribution lemma (sum of `R`-linear maps is `R`-linear)
is **also independent of the specific summand body**: it states, for any
named family `F : ι → Hom`, that R-linearity of each `F i` implies R-linearity
of `∑ i, F i`. This lemma is HOU-friendly because at the application site,
`F` is unified with `fun i ↦ <literal summand>` as a single first-order
metavariable (Miller pattern with one binder).

## Changes Requested

### File: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

**Change 1: Add new top-level helper `cechCofaceMap_pi_smul_summand`.**

Insert immediately after `presheafMap_restrict_collapse` (currently at L412–L434)
and BEFORE `cechCofaceMap_pi_smul` (currently at L456). The new lemma states
per-summand R-linearity with the index `i` as an explicit hypothesis.

Suggested signature (the refactor agent may adapt for clean elaboration; the
goal shape must match what `cechCofaceMap_pi_smul` needs at the call site):

```lean
set_option maxHeartbeats 800000 in
/-- Iter-096 (refactor extraction): per-summand R-linearity of the Čech coface
    map. Specialized to the `cechCofaceMap_pi_smul` call context, with the
    summation index `i` as an **explicit hypothesis** so the summand body has
    no nested non-Miller `i`-references at the application site.

    The proof body is left as `sorry` for the iter-097 prover. Mathematically:
    the summand `(-1)^↑i • Pi.lift fun i_1 ↦ Pi.π Z₁ (...) ≫ (...).op` is
    R-linear because it factors as a composition of R-linear maps (the integer
    scalar `(-1)^↑i • _` is R-linear; `Pi.lift` is R-linear when each
    component is; the per-component `(toModuleKPresheaf C).map (...).op` is
    R-linear via `presheafMap_restrict_collapse`). -/
theorem cechCofaceMap_pi_smul_summand
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s₀ : Finset Γ(C.left, U)) {n : ℕ} (hn : 0 < n)
    (i : Fin (n + 1)) :
    let R := Γ(C.left, U)
    let Z₁ := fun (i : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) =>
      ModuleCat.of k (C.left.presheaf.obj
        (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
    let Z₂ := fun (i : Fin (n + 1) → ↑s₀) =>
      ModuleCat.of k (C.left.presheaf.obj
        (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
    let e₁ := (ModuleCat.piIsoPi Z₁).toLinearEquiv
    let e₂ := (ModuleCat.piIsoPi Z₂).toLinearEquiv
    letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
      apply RingHom.toModule
      refine (C.left.presheaf.map (homOfLE ?_).op).hom
      let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
      have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
        basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
      have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
        basicOpen_le C.left (i a0 : Γ(C.left, U))
      exact h1.trans h2
    letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
    letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
      apply RingHom.toModule
      refine (C.left.presheaf.map (homOfLE ?_).op).hom
      let a0 : Fin (n + 1) := ⟨0, by omega⟩
      have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
        basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
      have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
        basicOpen_le C.left (i a0 : Γ(C.left, U))
      exact h1.trans h2
    letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
    -- The fixed summand for this index i:
    let φ_i : (∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k) :=
      ((-1 : ℤ))^(i : ℕ) • Pi.lift (fun i_1 =>
        Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))) ≫
        (toModuleKPresheaf C).map (Pi.lift (fun x =>
          Pi.π (basicOpenCover (C := C) (U := U) ↑s₀ ∘ i_1)
            ((SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i)) x))).op)
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ (φ_i.hom (e₁.symm (r • y))) =
        r • e₂ (φ_i.hom (e₁.symm y)) := by
  intro R Z₁ Z₂ e₁ e₂ perI₁ h_mod_pi₁ perI₂ h_mod_pi₂ φ_i r y
  sorry
```

The refactor agent should:
1. Write the signature verbatim (adapting cosmetically if Lean's elaborator
   requires).
2. Provide a `sorry` body.
3. Confirm the lemma elaborates with `lean_diagnostic_messages` returning
   no errors at that file scope (only the `sorry` warning at the new line).

**Change 2: Add a top-level structural lemma `alternating_sum_pi_smul_aux`.**

This is the abstract sum-of-R-linear-maps lemma. Insert directly after
`cechCofaceMap_pi_smul_summand`. Signature is fully abstract over the
summand family `F`, so at the application site, `F` unifies as a single
binder (Miller-pattern HOU-friendly).

```lean
set_option maxHeartbeats 800000 in
/-- Iter-096 (refactor extraction): structural lemma — if each summand
    `F i` is R-linear (with respect to the LinearEquivs `e₁`, `e₂`), then
    so is `∑ i ∈ s, F i`. The summand family `F : ι → (M ⟶ N)` is named
    abstractly, so applying this lemma to the Čech alternating sum
    `∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ ...` only requires Miller-pattern
    unification `F := fun i ↦ <literal summand>` — no HOU on the
    nested-i body.

    Body left as `sorry` for the iter-097 prover. Proof sketch:
    induct on the finset `s` via `Finset.cons_induction`. Base case is
    the empty sum = 0, which is trivially R-linear via the `ModuleCat`
    zero morphism. Cons step: `F i + ∑ j ∈ s', F j` is R-linear because
    R-linearity is preserved under addition (`ModuleCat.hom_add` plus
    R-linearity of each summand). -/
theorem alternating_sum_pi_smul_aux
    {k : Type u} [Field k]
    {R : Type*} [Ring R]
    {ι₁ ι₂ : Type u} (Z₁ : ι₁ → ModuleCat.{u} k) (Z₂ : ι₂ → ModuleCat.{u} k)
    [Module R (∏ᶜ Z₁ : ModuleCat.{u} k).carrier]
    [Module R (∏ᶜ Z₂ : ModuleCat.{u} k).carrier]
    [Module R (∀ i, Z₁ i)] [Module R (∀ j, Z₂ j)]
    {ι' : Type*} (s : Finset ι')
    (F : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k)))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k).carrier ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k).carrier ≃ₗ[k] ∀ j, Z₂ j)
    (hF : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((F i).hom (e₁.symm (r • y))) =
        r • e₂ ((F i).hom (e₁.symm y))) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((∑ i ∈ s, F i).hom (e₁.symm (r • y))) =
        r • e₂ ((∑ i ∈ s, F i).hom (e₁.symm y)) := by
  sorry
```

The refactor agent should:
1. Write the signature, adapting cosmetically for elaboration if the
   `[Module R ...]` synthesis needs different bracket structure or
   explicit instance hints.
2. If the instance bracketing causes elaboration friction, switch to
   explicit `(_ : Module R _)`-style hypotheses (the prover can later
   adjust).
3. Provide `sorry` body.
4. Verify elaboration.

If the refactor agent finds that the LHS/RHS shape doesn't match what
`cechCofaceMap_pi_smul`'s post-(b') goal looks like (especially the
`eqToHom`-wrapping and the outer `(Pi.π Z₂ j).hom`), it should adapt the
signature so the lemma's conclusion DOES match the goal at L593 — that's
the whole point.

**Change 3: Re-shape the body of `cechCofaceMap_pi_smul` to apply the new helpers.**

Replace the body from L589 onward (the current trailing-sorry block) with
an application of the new structural lemma. The refactor agent is **explicitly
permitted** to insert sorries at the places where the structural application
chain fails to typecheck — but the chain should be DESIGNED so that the
HOU-blocked `rw [key₂]` is REPLACED by an `apply`/`refine` of the new
abstract structural lemma (which uses first-order unification, not
discrimination-tree HOU).

Suggested chain (the refactor agent may adapt):

```lean
-- (c) iter-096 refactor: apply the abstract structural lemma. Lean's
-- elaborator unifies F := fun i ↦ <literal summand> as a Miller pattern
-- (single binder, no nested non-Miller positions), so HOU is replaced by
-- first-order unification.
funext j
-- Note: the `funext j` may or may not be needed depending on iter-094/095
-- shape post-eqToHom-fuse. Keep iter-092..095 prefix verbatim through L588
-- and replace only the L589–L593 tail.
refine alternating_sum_pi_smul_aux Z₁ Z₂ Finset.univ ?_ e₁ e₂ ?_ r y
intro i _ r y
-- The per-summand obligation: this is exactly `cechCofaceMap_pi_smul_summand i`
-- specialized to the same letI/let scaffold.
exact cechCofaceMap_pi_smul_summand hU s₀ hn i r y
```

If the chain doesn't typecheck, the refactor agent should:
1. Adjust the new lemma signatures to match the goal at L593 more precisely
   (the refactor agent has the freedom to do so as part of structural change).
2. Insert a `sorry` at the body of `cechCofaceMap_pi_smul` if the chain
   cannot be made to close even with adjusted signatures.

**The refactor agent must not delete the iter-092/093/094 work at L495–L588.**
The body's prefix `intro R K₀ scK₀ Z₁ Z₂ e₁ e₂ r y` + `letI` reconstruction +
S1–S5 dsimp chain + `have hom_sum_dist` + `have key₁` + `rw [← ModuleCat.hom_comp]`
+ `have key₂` is preserved byte-for-byte; only L589–L593 is replaced.

Specifically, the refactor agent should:
1. Keep L456–L588 unchanged (signature + iter-092/093/094 body prefix).
2. Replace L589–L593 (the iter-095 cosmetic + trailing `sorry`) with the
   new application chain.
3. If the chain cannot close cleanly, leave a single `sorry` at the deepest
   step the chain reaches.

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (primary). Three new
  declarations: `cechCofaceMap_pi_smul_summand`, `alternating_sum_pi_smul_aux`,
  and an updated body of `cechCofaceMap_pi_smul`.

No other files in the project depend on the body of `cechCofaceMap_pi_smul`
(its sole consumer is `g_R.map_smul'` and `h_loc_exact` at L1223 / L1252,
both of which take `cechCofaceMap_pi_smul` as a black box via its statement,
not its body). The new top-level helpers may be referenced as needed by
future iterations, but their introduction does not break any existing
import or signature.

## Expected Outcome

After the refactor, `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` should:

1. **Compile end-to-end** (no errors, only the existing sorry-warnings and the
   two new sorry-warnings at the new lemma bodies).
2. Contain **2 new top-level lemmas with `sorry` bodies**:
   - `cechCofaceMap_pi_smul_summand` (per-summand R-linearity, `i` explicit).
   - `alternating_sum_pi_smul_aux` (structural sum of R-linear maps is R-linear).
3. **Either** close the L589–L593 tail of `cechCofaceMap_pi_smul` with the
   application chain (preferred: sorry count net change +1 — was 6, becomes 7
   counting the two new helpers minus the closed L593), **OR** leave a
   single `sorry` at the deepest step the new chain reaches (sorry count
   net change +2 — was 6, becomes 8).

The net effect: 6 → 7 or 8 sorries in `BasicOpenCech.lean`. The iter-097
prover then fills the two new helpers' bodies; per-summand R-linearity
is a clean ~30-line proof (template at PROGRESS.md § "Step 2 — (c-finish)..(closure)"),
and the structural alternating-sum lemma is a ~15-line `Finset.cons_induction`
with `ModuleCat.hom_add` distribution at the cons step. Both are
HOU-free because their proofs operate on named binders.

## Notes for the Refactor Agent

- **Goal shape diagnostic**: at L593 (the iter-095 trailing sorry), use
  `lean_goal` to see the exact current goal shape after the iter-095
  `ModuleCat.Hom.hom → ConcreteCategory.hom` cosmetic. Adjust the new
  lemma's conclusion to match if needed.

- **Universe levels**: keep everything in `Type u` to match the existing
  `universe u` opening at L31. The new lemmas should be `{k : Type u}
  [Field k]`-quantified, mirroring `cechCofaceMap_pi_smul`.

- **`set_option maxHeartbeats`**: copy from the `cechCofaceMap_pi_smul`
  attribute at L436. The new lemmas may need similar heartbeat budgets.

- **Instance synthesis**: the four `letI`-bound module instances (perI₁,
  h_mod_pi₁, perI₂, h_mod_pi₂) are baked into the `r • _` SMul actions in
  the conclusion of `cechCofaceMap_pi_smul`. When extracting the per-summand
  lemma, replicate the `letI` block verbatim from the body (L500–L519) so
  the per-summand R-linearity statement typechecks with the same SMul.

- **`Pi.lift` body**: the precise lambda form `(fun i_1 ↦ Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))) ≫ ...)`
  must match what the `dsimp` chain at L526–L545 lands on. If your new lemma's
  `φ_i` definition diverges syntactically from the chain's output, the
  application at L593 will fail to typecheck. Verify by inspecting `lean_goal`
  at L593 BEFORE writing `φ_i`'s definition.

- **`Pi.π Z₁` vs `Pi.π (fun i ↦ ModuleCat.of k ↑(...))`**: the dsimp chain
  unfolds `Z₁` into its lambda body. If the goal at L593 shows the unfolded
  form, write `φ_i` using the SAME unfolded form (not the let-bound `Z₁`).
  The let-binding is only used in the lemma's overall statement; the `φ_i`
  definition inside should be syntactically identical to what the goal shows.

- **If `alternating_sum_pi_smul_aux`'s signature is hard to make match the
  goal shape**, an alternative is to bundle the entire iter-092..095 chain
  (dsimp + key₁ + ← ModuleCat.hom_comp + key₂) into a single bridging lemma
  whose conclusion is the structural-lemma's hypothesis shape. Decide based
  on what's cleanest after inspecting `lean_goal` at L588 and L593.

- **Compilation check**: after each change, run `lean_diagnostic_messages`
  on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`. The file must
  continue to compile (with only sorry-warnings). Do not commit a change
  that introduces a compilation error elsewhere.

- **Do not edit other files** in this iteration. The new helpers live in
  `BasicOpenCech.lean`. No imports change.

- **Do not edit `archon-protected.yaml`**. None of the new helpers are
  protected.

- **Sorry budget after refactor: target 7 (one new helper closes L593;
  two new helpers themselves are sorries); acceptable 8 (the body still
  has its trailing sorry but at a structurally HOU-free position).**
