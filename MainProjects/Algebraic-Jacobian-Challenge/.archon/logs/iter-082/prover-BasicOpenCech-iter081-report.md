# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-081 report

## File status

- **Sorry count: 6** (unchanged from iter-080 — hard cap preserved; target ≤ 5 NOT hit).
- **File compiles cleanly** (no errors); only pre-existing lint warnings remain.
- The iter-080 named-per-i `letI` refactor at L920–949 is **preserved byte-for-byte**.
- The `set_option maxHeartbeats 800000 in` at L418 is **preserved**.

## Lane 1 target: `h_diff_pi_smul_f` body at L1176 — structural advance, not closed

### Attempt 1 — execute S2+S3+S4 inline (PARTIAL ADVANCE)

- **Approach:** Substantively advance the iter-080 documented recipe.  Establish `hRel : (ComplexShape.up ℕ).prev n + 1 = n` (closes S3 case-split via `rcases n; simp [ComplexShape.prev, ComplexShape.up_Rel]`).  Then execute S2+S3+S4 combined: a 5-layer `dsimp` peels `scK₀ → K₀ → cechCochain → cechComplexFunctor → toModuleKSheaf`; a full `simp` with `[FormalCoproduct.cochainComplexFunctor, ..., AlgebraicTopology.AlternatingCofaceMapComplex.objD, CochainComplex.of, FormalCoproduct.evalOp, e₁, e₂, ModuleCat.piIsoPi, dif_pos hRel]` collapses the `K₀.d` projection through the `CochainComplex.of`-built differential, **exposing the explicit alternating-sum form**.
- **Result:** IN PROGRESS — file compiles; sorry remains at the per-summand R-linearity step (S5–S8).  The goal at the sorry is now (both sides):
  ```
  (piIsoPi Z₂).hom (eqToHom _ ∘ₗ
      (∑ i : Fin (prev n + 2), (-1)^↑i • Pi.lift (fun j' ↦
         Pi.π Z₁ (j' ∘ δ_i.toOrderHom) ≫ (toModuleKPresheaf C).map (Pi.lift _).op)))
    ((piIsoPi Z₁).symm <r • y or y>) j
  ```
  (vs. RHS having an outer `r • ·` at the j-component level).
- **Key insight:** The iter-080 sorry-rationale block guessed that this would require
  `CochainComplex.of_d_eq_succ` (non-existent in Mathlib).  In practice, the `dif_pos hRel` rewrite **inside a full `simp` invocation** flushes `CochainComplex.of_d` automatically — once `CochainComplex.of` is in the simp set, simp unfolds the `d`-projection to its `if h : i + 1 = j then ... else 0` form, and `dif_pos hRel` selects the `then` branch.  This is what bridges S2 to S3 to S4 in one tactic step.
- **Lemmas used / discovered:**
  - `ComplexShape.prev`, `ComplexShape.up_Rel` — for `hRel`.
  - `FormalCoproduct.cochainComplexFunctor`, `cosimplicialObjectFunctor` — fully unfold to `evalOp ⋙ alternatingCofaceMapComplex` (Mathlib defs).
  - `AlgebraicTopology.alternatingCofaceMapComplex`, `AlternatingCofaceMapComplex.obj`, `.objD`, `.map`, `CochainComplex.of` — for S4.
  - `FormalCoproduct.evalOp` — exposes `(evalOp.obj P).obj X = ∏ᶜ (fun i => P.obj (op (X.unop.obj i)))`.
  - `ModuleCat.piIsoPi`, `dif_pos hRel` — collapse the `K₀.d` projection.

### Attempt 2 — close S5–S8 (NOT ATTEMPTED — time budget)

The remaining S5–S8 chain (per the inline rationale block in the body) is:

1. **S5:** Distribute `e₂ = (piIsoPi Z₂).hom` and the alternating sum through `Pi.lift` to surface per-`(i, j')` summands at the j-component.  Need `Pi.π Z₁ k (e₁.symm z) = z k` (from `piIsoPi_inv_kernel_ι`) to reduce the inner argument, and `eqToHom_app` to commute the eqToHom cast through the sum.
2. **S6:** `Finset.smul_sum` distributes `r •` across the RHS sum.
3. **S7:** Per-summand: each summand at fixed `i, j'` is `(toModuleKPresheaf C).map (φ_i).op . hom (z (j' ∘ δ_i.toOrderHom))` where `z = e₁.symm (r • y)`.  For `z = r • y`, the inner is `(presheaf.map (V_{j'∘δ_i} ≤ U).op).hom r * y (j' ∘ δ_i)` by `perI₁`.  Apply `RingHom.map_mul` (the `.hom` of a `presheaf.map (V_{j'} ≤ V_{j'∘δ_i}).op` is a ring-hom), then `← presheaf.map_comp` collapses two restrictions into one.
4. **S8:** Per-summand identity closes by `rfl`/`ring`.

The detailed recipe is now inline in the body (replacing the iter-080 rationale block).  Estimated ~30 LOC for full closure given that S2+S3+S4 are now done.

## Dead-end warnings

- **DO NOT** attempt `simp only` (instead of full `simp`) for the S2+S3+S4 unfold — `simp only` fails to collapse `CochainComplex.of_d` because it requires extra elaboration that only the full simp engine performs.
- **DO NOT** try to use `CochainComplex.of_d_eq_succ` — it does not exist in Mathlib.  Use `dif_pos hRel` inside a full `simp` invocation instead.
- **DO NOT** try `rw [dif_pos hRel]` after a `simp only` chain — the conditional `dite` won't be present in the goal yet, only the (still wrapped) `K₀.d` projection.

## Status: PARTIAL ADVANCE — substantive structural progress on top of iter-080

- **Net sorry count this iter: 6 → 6** (no closure; hard cap preserved).
- **Body advance (substantive):** S2+S3+S4 from the PROGRESS.md recipe are now **executed inline**; the goal at the sorry exposes the explicit alternating-sum form.  This is the deepest the proof has reached across iter-072 to iter-081.
- **Next iteration target:** Close S5–S8 from the now-exposed alternating-sum form.  The remaining work is local per-summand R-linearity using `RingHom.map_mul` + `← presheaf.map_comp`, after distributing through `e₂` and `Pi.lift` (using `piIsoPi_inv_kernel_ι` for the inverse direction).

## Blueprint marker

- The per-summand R-linearity is internal to `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (no top-level `\lean{...}` label).  No marker action needed.
- The top-level `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` retains its 6 sorries; the marker remains as before.

## Other sorries (out of scope this iter, unchanged)

- L502: substep (a) extra-degeneracy (dead-end).
- L826: substep (i) Čech-cohomology refinement transport (dead-end).
- L854: substep (a) for `s₀` (dead-end).
- L1241: `g_R.map_smul'` (gated on `h_diff_pi_smul_g` re-introduction, downstream of this lane).
- L1270: `h_loc_exact` (needs `IsLocalizedModule.Away f.1` infrastructure; iter-082+).
