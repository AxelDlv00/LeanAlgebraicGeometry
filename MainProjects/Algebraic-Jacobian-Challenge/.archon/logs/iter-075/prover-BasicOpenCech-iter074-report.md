# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Iter-074 Lane 2 — close `h_diff_pi_smul_f` (L996)

### Attempt 1 (executed)
- **Approach:** Execute the in-file S1–S8 reduction recipe with defensive
  `try`-wrappers preserving file compilation under the broken build env.
  Concrete chain:
  ```
  intro r y
  try funext j
  try simp only [scK₀, K₀, cechCochain, cechComplexFunctor,
    FormalCoproduct.cochainComplexFunctor,
    FormalCoproduct.cosimplicialObjectFunctor,
    FormalCoproduct.evalOp, AlgebraicTopology.alternatingCofaceMapComplex,
    AlgebraicTopology.AlternatingCofaceMapComplex.obj,
    AlgebraicTopology.AlternatingCofaceMapComplex.objD,
    HomologicalComplex.sc, ShortComplex.f, CochainComplex.of,
    CochainComplex.ofHom, ComplexShape.up]
  try simp only [Pi.smul_apply, Finset.sum_apply, Finset.smul_sum]
  sorry
  ```
- **Result:** IN PROGRESS — chain committed to the file (L1057–L1101); the
  final `sorry` remains because the per-summand R-linearity step
  (S7 in the recipe) requires concrete `Finset.sum_congr rfl` +
  `algebraMap_naturality` rewriting that cannot be validated without LSP.
- **Env state:** build env confirmed broken in this session.
  `lean_diagnostic_messages` returns `success: false`; `lean_goal`
  returns `goals: null`; `lean_multi_attempt` returns empty goals
  uniformly (LSP is not analyzing the file). Per the iter-074 PROGRESS
  note: *"Commit to a credible attempt anyway"* — done.

### Why the residual sorry stayed
Without LSP feedback I cannot:
1. Confirm that the `simp only [...]` 5-layer functor-stack unfolding
   actually exposes the alternating-sum normal form. Some of the
   `@[simp]`-tagged equations in Mathlib's `AlternatingCofaceMapComplex`
   namespace may not commute with this particular order of unfoldings;
   the iter-073 commentary already flagged this as a risk
   (*"the mechanical execution needs `dsimp` through the 5-layer functor
   stack and careful handling of `letI`-introduced module instances"*).
2. Confirm that the `Pi.smul_apply` / `Finset.sum_apply` distribution
   step lands on a goal where the per-summand reduction via
   `algebraMap_naturality` is syntactically applicable. The R-action on
   `∀ i, Z₁ i` is `Pi.module` with each component using a different
   ring-hom `(presheaf.map (V_i ≤ U).op).hom`; the index of the chosen
   ring-hom (`a0 = ⟨0, _⟩` in `h_mod_pi₁`) introduces an arbitrary-choice
   that must be reconciled with the index `j ∘ δ_k.toOrderHom` on the
   output side.

The chain is wrapped in `try` so that if any individual step fails to
elaborate, the file's compilation is preserved (per the iter-073
defensive convention). When the env is repaired, the next prover can
either:
- step through the `try`-wrapped tactics one by one to identify which
  step makes progress, then drop the failed `try` wrappers; or
- replace the `simp only` step with explicit `show ... = ...` / `change`
  reformulations using the names from analogies/cech-koszul-precedent.md
  to expose the alternating-sum directly.

### Mathematical content of the residual obligation (for iter-075)
After the chain executes (assuming it elaborates without failure), the
goal at the final `sorry` is the per-component R-linearity claim:
```
∑ k : Fin (n + 2), ((-1)^k.val •
  ((presheaf.map (V_j ≤ V_{j∘δ_k}).op).hom (((r • y) (j ∘ δ_k.toOrderHom))))) =
r •
∑ k : Fin (n + 2), ((-1)^k.val •
  ((presheaf.map (V_j ≤ V_{j∘δ_k}).op).hom (y (j ∘ δ_k.toOrderHom))))
```
The LHS-`(r • y) i` unfolds via `h_mod_pi₁` to
`(presheaf.map (V_i ≤ U).op).hom r * y i`. The restriction is a ring-hom
so it splits as
`(presheaf.map (V_j ≤ V_i).op).hom ((presheaf.map (V_i ≤ U).op).hom r) *
 (presheaf.map (V_j ≤ V_i).op).hom (y i)`.
By `algebraMap_naturality` (presheaf functoriality `V_j ≤ V_i ≤ U`)
applied to the algebraMap of `R` into the section algebra:
`(presheaf.map (V_j ≤ V_i).op).hom ((presheaf.map (V_i ≤ U).op).hom r)
   = (presheaf.map (V_j ≤ U).op).hom r`.
This collapses to `r •_j (restriction (y i))` where `•_j` is the
`h_mod_pi₂`-induced smul at output index `j`. Then `Finset.smul_sum`
pulls the `r •_j` out of the alternating sum, closing the goal.

The implementation must thread `Finset.sum_congr rfl fun k _ => ?_` to
reduce per-summand; inside each summand handle the `(-1)^k.val • _`
factor and the `algebraMap_naturality` rewrite.

### Mathlib leverage (verified iter-073 + this iteration)
- `AlgebraicTopology.AlternatingCofaceMapComplex.objD` —
  `.lake/packages/mathlib/Mathlib/AlgebraicTopology/AlternatingFaceMapComplex.lean` L300.
- `CategoryTheory.cechComplexFunctor` —
  `.lake/packages/mathlib/Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean` L65.
- `CategoryTheory.Limits.FormalCoproduct.evalOp` —
  `.lake/packages/mathlib/Mathlib/CategoryTheory/Limits/FormalCoproducts/Basic.lean` L383.
- `Scheme.toModuleKSheaf.algebraMap_naturality` —
  `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` L161 (project-local).
- `Pi.smul_apply`, `Finset.sum_apply`, `Finset.smul_sum`, `Pi.module`.
- `ModuleCat.piIsoPi` (which gives the `e₁/e₂/e₃` LinearEquivs) is
  `k`-linear, not `R`-linear, in
  `.lake/packages/mathlib/Mathlib/Algebra/Category/ModuleCat/Products.lean` L53.

### Sorry count delta
6 → 6 (unchanged). The structural chain is committed in-place; the
final sorry remains. Per the iter-074 directive (*"a syntactically
plausible but mathematically correct closure can be inspected manually
and refined later"*) this is the best honest result without LSP.

### Out of scope (per PROGRESS.md off-limits list)
- `h_diff_pi_smul_g` (L1063 after this edit) — iter-075 mechanical copy.
- `h_loc_exact` (L1191 after this edit) — defer to iter-075.
- L495 substep (a) extra-degeneracy `s`-indexed.
- L819 `h_π_split` analogue (refinement transport `s → s₀`).
- L847 substep (a) extra-degeneracy `↑s₀`-indexed.

### Blueprint marker recommendation
No blueprint changes this iteration. The chapter file
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` already documents
the Čech acyclicity argument informally. The `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
theorem retains 6 syntactic sorries, so `\leanok` is NOT yet
appropriate. The `sync_leanok` phase will determine the marker state
authoritatively once the build env is repaired.

### Honest assessment
This iteration moves the file forward by **committing the recipe to
runnable tactic syntax** (rather than leaving it only as commentary).
The net sorry-count is unchanged, but the next prover (with env repaired)
will start from a point where `try`-wrapped tactics can be probed to
determine which step makes progress, rather than starting from scratch.
The substantive obstacle — `algebraMap_naturality` ring-hom transport on
the per-summand reduction — is identified and isolated.
