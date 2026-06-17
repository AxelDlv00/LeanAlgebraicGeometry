# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-079 prover report

## Status

**IN PROGRESS** — partial structural progress. Sorry count unchanged 6 → 6.
File compiles cleanly (0 errors, 1 warning re heartbeat comment, pre-existing).

## Lane 2 target: `h_diff_pi_smul_f` (now L1093–1145)

### What I did

Added a third structural step on top of iter-078's `intro r y; funext j`:

```
change e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) j =
  h_mod_pi₂.toSMul.smul r
    (e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm y))) j
```

This `change` succeeds — confirming via `lean_multi_attempt` that the
implicit `(r • _) j` smul on the RHS is **definitionally** equal to
the explicit `h_mod_pi₂.toSMul.smul r _ j` form. After the change,
the LSP reduces the RHS automatically to `SMul.smul r _ j`.

This is a genuine advance: the iter-078 prover noted that
`simp [Pi.smul_apply]` and `rw [Pi.smul_apply]` both fail with "did not
find the pattern" because the smul on the RHS is induced by `h_mod_pi₂`'s
`Pi.module` builder with **anonymous** per-i instances, and typeclass
search cannot materialise a `[∀ i, SMul R (Z₂ i)]` family from
`h_mod_pi₂` alone. The `change` sidesteps this by naming the smul
explicitly, so further rewriting can target `h_mod_pi₂.toSMul.smul`
directly.

### Precise blocker for iter-080

After the `change`, the goal is:
```
e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) j =
  SMul.smul r (e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm y))) j
```

The natural next step is to apply `Pi.smul_apply` to evaluate the
RHS componentwise as `(perJ).smul r ((e₂ ...) j)` where
`perJ : Module R (Z₂ j)` is the j-th anonymous per-i Module instance
bound inside `h_mod_pi₂`'s `Pi.module` builder. But this still fails
because `perJ` is **anonymous** — typeclass search cannot find it.

I verified this by trying `letI mod_Z₂_per : ∀ i, Module R (Z₂ i) := …`
with an IDENTICAL constructor to `h_mod_pi₂`'s anonymous per-i builder
inside the proof of `h_diff_pi_smul_f`. Even with this explicit
`letI` in scope, `rw [Pi.smul_apply]` still fails: the smul on the
RHS was elaborated against `h_mod_pi₂.toSMul`, which carries a
**different** (anonymous) per-i SMul than the new `letI`. Lean's
typeclass resolution does not bridge these definitionally-equal
families.

### Recommended path: refactor `h_mod_pi₂` to use named per-i instance

The cleanest fix is at L921–930 in the file. Currently:

```
have h_mod_pi₂ : Module R (∀ i, Z₂ i) :=
  @Pi.module (Fin (n + 1) → ↑s₀) (fun i => Z₂ i) R _ _ (fun i => by
    apply RingHom.toModule
    refine (C.left.presheaf.map (homOfLE ?_).op).hom
    ...
    exact h1.trans h2)
```

Refactor to:

```
letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
  apply RingHom.toModule
  refine (C.left.presheaf.map (homOfLE ?_).op).hom
  ...
  exact h1.trans h2
have h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
```

(or directly `letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := inferInstance`
once `perI₂` is `letI` so typeclass synthesis runs.)

After this refactor, `[∀ i, SMul R (Z₂ i)]` is synthesisable from
`perI₂`, and `Pi.smul_apply` fires directly. Apply the same refactor
to `h_mod_pi₁` (L911) and `h_mod_pi₃` (L931) for symmetry.

This is **not** a "new project-local helper lemma" — it's a literal
expansion of the existing `Pi.module` construction into named pieces,
preserving the same Module structure byte-for-byte. The semantic
content of `h_mod_pi₂` is unchanged; only the typeclass-visibility
of its constituents changes.

### After the refactor: continuation chain

With `Pi.smul_apply` firing on the new RHS:
```
SMul.smul r (e₂ ((scK₀.f).hom (e₁.symm y))) j
  ↦  (perI₂ j).toSMul.smul r ((e₂ ((scK₀.f).hom (e₁.symm y))) j)
  ↦  ((C.left.presheaf.map (homOfLE _).op).hom r) *
       ((e₂ ((scK₀.f).hom (e₁.symm y))) j)
```

The LHS still needs S2–S8 of the iter-073 recipe:
- **S2 (5-layer dsimp):** unfold `scK₀ → K₀ → cechCochain → cechComplexFunctor → FormalCoproduct.cochainComplexFunctor` to reveal
  `scK₀.f.hom = ((alternatingCofaceMapComplex _).obj X) .d (prev n) n`.
- **S3 (objD identification):** use `CochainComplex.of_d_eq_succ` (or
  `(up ℕ).Rel (prev n) n` case-split) to identify
  `K₀.d (prev n) n = objD X (prev n) = ∑ k : Fin ((prev n) + 2), (-1)^k • X.δ k`.
- **S4 (Pi.smul_apply on LHS):** evaluate `(r • y) (j ∘ δ_k.toOrderHom)` —
  with the refactored `perI₁ : ∀ i, Module R (Z₁ i)`, `Pi.smul_apply` now
  fires here too.
- **S5–S7:** distribute `r •` across the alternating sum
  (`Finset.smul_sum`); reduce to per-summand R-linearity
  (`Finset.sum_congr`); per-summand: ring-hom distributivity of the
  restriction `(presheaf.map (V_j ≤ V_{j∘δ_k}).op).hom` over the
  multiplication, plus presheaf functoriality `presheaf.map_comp` on
  the `V_j ≤ V_{j∘δ_k} ≤ U` chain (collapsing two restrictions to one).

### What I tried that did NOT work (iter-079 ruled out)

- `rfl` after the change: LHS and RHS are NOT defeq (the differential
  doesn't simplify without S2 dsimp).
- `simp only [Pi.smul_apply]` after `funext j`: "unused simp argument"
  — pattern doesn't unify.
- `rw [Pi.smul_apply r (e₂ ...)]`: "did not find the pattern" — even
  with explicit arguments, the smul on the RHS isn't matched.
- `letI mod_Z₂_per : ∀ i, Module R (Z₂ i) := fun i => …`
  followed by `letI : ∀ i, SMul R (Z₂ i) := …`: makes the per-i
  instance visible to typeclass search but `Pi.smul_apply` still
  fails because the smul in the goal is from `h_mod_pi₂.toSMul`, not
  the new `letI` instance, and Lean doesn't unify them at the
  Pi-builder level.
- `show … = (Pi.instSMul.smul r _) j`: "pattern not defeq" — Pi.instSMul
  doesn't unify with `h_mod_pi₂.toSMul` because the per-i builders
  differ syntactically.
- `change … = (@HSMul.hSMul _ _ _ Pi.instHSMul …)`: `Pi.instHSMul`
  is not a global identifier.

### What DID work this iteration

- `change … = h_mod_pi₂.toSMul.smul r _ j`: closes by `change` (defeq).
  This is committed at L1115–1118.

### Approaches still worth trying next iteration

After the `h_mod_pi₂` refactor (Option (a) above), or in lieu of it:

- **Option (b):** continue without refactor by adding a second `change`
  step to expand `h_mod_pi₂.toSMul.smul r _ j` to its literal
  per-component form `(C.left.presheaf.map (homOfLE _).op).hom r * _ j`.
  Whether this `change` succeeds depends on how deeply Lean unfolds
  `Pi.module`'s smul field. Worth trying as a one-line probe.

- **Option (c) — bypass `h_diff_pi_smul_f` entirely:** define `f_R`
  (at L1158) via a different construction route — e.g., as a
  composition of named Mathlib-shape R-linear maps that doesn't go
  through `h_diff_pi_smul_f`'s pointwise statement. Specifically,
  the alternating-coface differential `objD X n` is already a
  *finite alternating sum of `X.δ k`*, where each `X.δ k` is induced
  by the morphism `δ_k.op : ⦋n⦌ᵒᵖ ⟶ ⦋n+1⦌ᵒᵖ` via `evalOp.obj P`.
  If `evalOp.obj P` can be lifted to an R-linear bifunctor (using
  the `R = Γ(C.left, U) → Γ(C.left, V)` algebra structure for `V ≤ U`),
  then `X.δ k` is R-linear by naturality and the sum is R-linear by
  closure. This is a more ambitious refactor but would close
  `h_diff_pi_smul_{f, g}` simultaneously and might generalise.

## Sorry-count budget

- Before: 6 syntactic sorries (L502, L826, L854, L1110, L1150, L1179
  per iter-078's labels; renumbered to L502, L826, L854, L1145, L1185,
  L1214 after iter-079's expanded comment block at the `h_diff_pi_smul_f`
  site).
- After: 6 syntactic sorries (same locations, renumbered).
- Target: ≤ 5 (close `h_diff_pi_smul_f`). **Not achieved**, blocker
  documented above.
- Hard cap: 6. **Respected** — no regression.

## Other sorries in BasicOpenCech.lean (unchanged this lane)

- L502 (substep (a)): extra-degeneracy on `s`-indexed slice cover — out of scope.
- L826 (kernel acyclicity / `h_π_split` end-state): out of scope.
- L854 (substep (a) for `s₀`-indexed slice cover): out of scope.
- L1185 (`g_R.map_smul'`): downstream — out of scope (gated on Lane 2 landing).
- L1214 (`h_loc_exact`): needs `IsLocalizedModule.Away f.1` infrastructure
  — iter-080+ per plan.

## Constraints respected

- ✓ No new project-local helper lemmas added.
- ✓ No new axioms.
- ✓ No `lean_run_code` pre-validation of bodies.
- ✓ `set_option maxHeartbeats 800000 in` at L418 preserved.
- ✓ `funext j` at L1094 preserved.
- ✓ Only the assigned file edited.

## Blueprint marker recommendation

No change. `h_diff_pi_smul_f` is internal to
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (no `\lean{...}`
hint of its own). The parent theorem still has sorries so it stays
unmarked.
