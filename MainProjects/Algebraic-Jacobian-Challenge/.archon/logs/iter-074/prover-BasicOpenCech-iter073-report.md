# Cohomology/BasicOpenCech.lean (iter-073 Lane 2)

## Summary

**Status: IN PROGRESS (no sorry closed; structural analysis added; safe
`try`-wrapped partial reduction tactics inserted).**

Iter-073 targets `h_diff_pi_smul_f` (L996) and `h_diff_pi_smul_g` (L1004): the
per-restriction R-linearity claims that arose from iter-072's structural transport
of `f_R.map_smul'` / `g_R.map_smul'` through `e_i.injective` + `Equiv.smul_def`.

After multi-source analysis of the Mathlib infrastructure (Cech complex stack
+ alternating coface map complex + FormalCoproduct evalOp), I added a detailed
structural reduction recipe in the code as a comment block above the sorry at
L996. The sorry itself was kept intact because:
1. The build environment is broken (`.lake/packages/*` owned by root,
   `lake env lean` fails, LSP `lean_diagnostic_messages` returns
   `success: false`).
2. Per user policy 2026-05-11, I am not pre-running `lean_run_code` to verify
   candidate proof bodies.
3. Any speculative tactic introduction risks breaking the file's compilation,
   which would degrade the work-product visible to the next iteration.

## h_diff_pi_smul_f (line 996) & h_diff_pi_smul_g (line 1004)

### Attempt 1
- **Approach:** Map out the 5-layer functor stack defining `scK₀.f` / `scK₀.g`
  and document the concrete reduction recipe in the source as comments.
- **Result:** IN PROGRESS — sorry retained.
- **Key insight:** The full reduction chain is:
  1. `scK₀ := HomologicalComplex.sc K₀ n` ⇒ `scK₀.f = K₀.d (prev n) n`.
  2. `K₀ := cechCochain C (toModuleKSheaf C) (basicOpenCover ↑s₀)`
        `= (cechComplexFunctor _).obj (sheafToPresheaf.obj (toModuleKSheaf C))`
        `= (FormalCoproduct.cochainComplexFunctor (mk _ basicOpenCover ↑s₀).cech).obj P`
        `= (alternatingCofaceMapComplex (ModuleCat k)).obj X'`
     where `X' := (cosimplicialObjectFunctor (mk _ basicOpenCover ↑s₀).cech).obj P`.
  3. `(alternatingCofaceMapComplex C).obj X` is `CochainComplex.of`, with
     differential `objD X m = ∑ i : Fin (m+2), (-1)^i • X.δ i`.
  4. `X'.δ k = X'.map (SimplexCategory.δ k).op` expands via
     `(evalOp.obj P).map f = Pi.lift (fun j ↦ Pi.π _ (f.unop.f j) ≫ P.map (f.unop.φ j).op)`
     into a `Pi.lift` of `Pi.π ≫ presheaf.map (restriction)`-style terms.
  5. Each `presheaf.map (homOfLE _).op` is a `CommRingCat` morphism, hence
     `.hom` is a ring-hom (R-algebra-hom via `algebraMap_naturality`).
  6. The R-module structure on `(∀ i, Z₁ i)` via `Pi.module` uses
     `RingHom.toModule (presheaf.map (V_i ≤ U).op).hom`; `(r • y) i =
     (presheaf.map (V_i ≤ U).op).hom r * y i`.
- **Mathematical proof of per-summand R-linearity** (recorded for next-iter
  prover): for each output multi-index `j` and coface index `k`, with
  `i = j ∘ δ_k.toOrderHom` and restriction
  `restrict_{i→j} := (presheaf.map (V_j ≤ V_i).op).hom`,
  ```
    restrict_{i→j} ((presheaf.map (V_i ≤ U).op).hom r * y i)
      = restrict_{i→j} ((presheaf.map (V_i ≤ U).op).hom r) * restrict_{i→j} (y i)
                                              [ring-hom property of restrict_{i→j}]
      = (presheaf.map (V_j ≤ U).op).hom r * restrict_{i→j} (y i)
                                              [presheaf functoriality, V_j ≤ V_i ≤ U]
      = r •_j (restrict_{i→j} (y i)).
  ```
- **Concrete tactic recipe** (also embedded in the source):
  ```lean
  dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
    FormalCoproduct.cochainComplexFunctor, FormalCoproduct.cosimplicialObjectFunctor,
    FormalCoproduct.evalOp, AlgebraicTopology.alternatingCofaceMapComplex,
    AlgebraicTopology.AlternatingCofaceMapComplex.obj,
    AlgebraicTopology.AlternatingCofaceMapComplex.objD,
    HomologicalComplex.sc, ShortComplex.f, CochainComplex.of, CochainComplex.ofHom,
    ComplexShape.up]
  funext j
  -- distribute Pi.lift / Pi.smul_apply / Finset.sum_apply / Finset.smul_sum
  -- reduce per summand via algebraMap_naturality
  ```

### Mathlib + project leverage names confirmed
- `AlgebraicTopology.AlternatingCofaceMapComplex.objD`
  (`Mathlib/AlgebraicTopology/AlternatingFaceMapComplex.lean` L300):
  `objD X n = ∑ i : Fin (n + 2), (-1 : ℤ) ^ (i : ℕ) • X.δ i`.
- `AlgebraicTopology.alternatingCofaceMapComplex`
  (`.../AlternatingFaceMapComplex.lean` L338): functor packaging.
- `CategoryTheory.cechComplexFunctor`
  (`Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean` L65):
  `FormalCoproduct.cochainComplexFunctor (mk _ U).cech`.
- `CategoryTheory.Limits.FormalCoproduct.cosimplicialObjectFunctor`
  (`.../SheafCohomology/Cech.lean` L43):
  `evalOp ⋙ (whiskeringLeft _ _ _).obj E.rightOp`.
- `CategoryTheory.Limits.FormalCoproduct.evalOp`
  (`Mathlib/CategoryTheory/Limits/FormalCoproducts/Basic.lean` L383):
  `obj F := {obj X := ∏ᶜ_i F.obj (op X.obj i), map f := Pi.lift ...}`.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality`
  (`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` L161):
  `(presheaf.map f).hom (algebraMap k _ r) = algebraMap k _ r`.

### Dead-end warnings
- **Don't try `simp [..]` without `dsimp only [...]` first** — the simp-set has
  too many lemmas firing on the cochain-complex differential; the proof needs
  surgical unfolding through the functor stack first.
- **Don't extract `h_diff_pi_smul_f` into a top-level helper lemma** — the
  proof requires the `letI := h_mod_pi₁` / `letI := h_mod_pi₂` typeclass
  instances introduced inside the parent proof. The structural reduction must
  stay local (per user policy: no chains of thin helpers).
- **Don't unfold `toModuleKSheaf` / `toModuleKPresheaf` more than necessary** —
  the underlying restriction structure is `(C.left.presheaf.map _).hom`, not
  `(toModuleKPresheaf.map _).hom`. Unfolding `toModuleKSheaf` exposes the wrong
  layer first; reduce the functor-stack outside first.

### Negative search results
- Searched: there is no direct Mathlib lemma giving R-linearity of an
  `alternatingCofaceMapComplex` differential transported through a `piIsoPi` —
  this is genuinely project-side mechanical work.
- `AlgebraicTopology.AlternatingCofaceMapComplex.objD` is `@[simp]` (will fire
  in `simp [AlternatingCofaceMapComplex.objD]`).
- `cechFunctor`/`cosimplicialObjectFunctor` are `@[simps!]` (auto-generated
  simp lemmas: `cechFunctor_obj`, `cechFunctor_map_app`, etc.).
- `evalOp` is `@[simps!]`: `evalOp_obj_obj`, `evalOp_obj_map`,
  `evalOp_map_app`.

## h_loc_exact (line 1083) — stretch, untouched

Not attempted this iteration; the plan-agent objective explicitly marks this
as stretch contingent on `h_diff_pi_smul_{f,g}` closing first. With
`h_diff_pi_smul_f` and `h_diff_pi_smul_g` still sorry, the upstream chain
(`f_R`/`g_R` are LinearMaps via these sorries; `h_loc_X_i` is closed by
`localizedModuleIsLocalizedModule`; the closure of `h_loc_exact` requires
`IsLocalizedModule.pi` + `IsLocalizedModule.map_exact` transport from
`h_a₀_fun`) cannot be cleanly run. Deferred to a future iteration after the
two helper claims close.

## L495, L819, L847 — confirmed dead-ends (untouched per plan-agent directive)

The plan-agent explicitly lists these as confirmed dead-ends across iter-064,
iter-067, iter-070 with the note "do not retry". Not attempted.

## Environment

- **Build env: broken.** `.lake/packages/{mathlib,doc-gen4,checkdecls}` owned
  by root, unwritable. `lake env lean` fails with `unknown module prefix
  'Mathlib'`. LSP `lean_diagnostic_messages` returns
  `{"success": false, "items": []}`. `lean_goal` returns `{"goals": null}`.
- **No new declarations introduced.** Only comment additions and
  `try`-wrapped tactic insertions inside `h_diff_pi_smul_f` (L996) and the
  `g` variant (L1004).
- **No axioms added.** No protected signatures touched.
- **Compilation status:** Unverified (env broken). The live tactic
  additions are wrapped in `try` blocks (`try funext j; try simp only
  [Pi.smul_apply]`), so any failure of these tactics is silently absorbed and
  the proof body remains `... ; sorry` — file compilation is preserved by
  construction. If/when the env is repaired, the next iteration's prover can
  drop the `try` wrappers and inspect via `lean_goal` whether the reductions
  fire as intended.

## Blueprint marker recommendations

No changes from iter-072. `h_diff_pi_smul_{f,g}` remain sorry-bodied;
the parent theorem `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is
still sorry-bodied (5 syntactic sorries inside it, plus the helper-claim
sorries). The blueprint chapter
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Čech acyclicity for
the structure sheaf on affine basic-open covers* remains accurate.

## Next-iteration plan

1. **Repair the build env.** Without LSP feedback, the dsimp/funext/simp chain
   cannot be iterated. This is the prerequisite to all further work in this
   file.
2. **Once LSP is live, follow the embedded tactic recipe** at L996 (S1–S8)
   step by step, using `lean_goal` to inspect the state after each `dsimp`
   layer is unfolded.
3. **Identify which `simps!`-generated lemma names actually fire** —
   `cechFunctor_map_app`, `cosimplicialObjectFunctor_obj`, `evalOp_obj_obj`,
   `evalOp_obj_map`, `AlternatingCofaceMapComplex.objD_apply` (or similar) —
   and bundle them into a single `dsimp only [...]` invocation.
4. **The R-linearity of each summand** reduces to applying
   `(C.left.presheaf.map _).hom_map_smul` or similar; the precise form
   depends on which layer of `toModuleKSheaf` is exposed after dsimp.
