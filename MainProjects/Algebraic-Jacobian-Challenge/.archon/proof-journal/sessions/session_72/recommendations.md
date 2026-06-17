# Recommendations for the next plan-agent iteration (iter-073)

## Context

Iter-072 closed 3 active sorries net (19 → 16 syntactic). The Phase-E `AbelJacobi.lean`
chain is **almost fully closed** — `ofCurve` and `comp_ofCurve` are RESOLVED, leaving
only the genus-0 rigidity sorry inside `exists_unique_ofCurve_comp` (mathematically
deferred, on par with `nonempty_jacobianWitness`). `Differentials.cotangentExactSeqAlpha`
is RESOLVED; `BasicOpenCech.lean` got a structural transport (count flat at 6 but
the iter-071 `map_smul'` sorries are now reducible via clean transport to two helper
claims).

The action moves to **`Differentials._structure.{h_zero, h_exact, h_epi}`**
(now attackable post-Alpha) and **`BasicOpenCech.h_diff_pi_smul_{f, g}`** (the
remaining mathematical content of Cluster (b) closure).

## Priority ranking

### P1 — Differentials.lean `_structure.h_zero` and `_structure.h_exact` (L359, L363)

**Why highest**: `cotangentExactSeqAlpha` is now fully closed. The two `_structure`
sub-claims `h_zero` (composition zero: `α ≫ β = 0`) and `h_exact` (kernel-image
match) are exactly the affine-chart identities
`KaehlerDifferential.exact_mapBaseChange_map`. Mathematically straightforward;
the work is presheaf-of-modules extensionality + a ring-level identity.

**Strategy**:
```lean
-- For h_zero
-- α : (pullback f).obj (relativeDifferentials g) ⟶ relativeDifferentials (f ≫ g)
-- β : relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f
-- Need: α ≫ β = 0
-- Reduce to underlying PresheafOfModules; on each U, this is
-- `KaehlerDifferential.map composed with mapBaseChange = 0` on the affine slice.
-- Conclude via `ext` + `KaehlerDifferential.exact_mapBaseChange_map`.
```

**Estimated**: 50–100 LOC. The bulk is the `ext` plumbing through
`SheafOfModules.Hom.ext` → `PresheafOfModules.Hom.ext`.

### P2 — Differentials.lean `_structure.h_epi` (L368)

**Why**: identified in iter-072 as a clean target needing only a project-local
helper `lemma SheafOfModules.epi_of_epi_presheaf`. Once the helper lands,
`h_epi` reduces to pointwise `KaehlerDifferential.map_surjective`.

**Strategy**:
1. Add a project-local lemma:
   ```lean
   lemma SheafOfModules.epi_of_epi_presheaf {R : Cᵒᵖ ⥤ RingCat} [HasSheafify J _]
       {M N : SheafOfModules R} (f : M ⟶ N) :
       CategoryTheory.Epi f.val → CategoryTheory.Epi f
   ```
2. Apply to `cotangentExactSeqBeta f g`; reduce to
   `Epi (cotangentExactSeqBeta f g).val`.
3. Apply `PresheafOfModules.epi_iff_surjective`
   (`Mathlib/Algebra/Category/ModuleCat/Presheaf/EpiMono.lean:59`).
4. Pointwise on `U`, apply `KaehlerDifferential.map_surjective`.

**Estimated**: 30–50 LOC for the helper, then 20–30 LOC for the main proof.

### P3 — BasicOpenCech.lean `h_diff_pi_smul_f` and `h_diff_pi_smul_g` (L996, L1004)

**Why**: the iter-072 transport closed the `LinearMap`-structure `map_smul'`
obligations. The two helper sorries are now the *only* remaining mathematical
content of Cluster (b). Closure unlocks `h_loc_exact` (L1083) which is the last
barrier between us and `exact_of_localized_span` applying.

**Strategy** (from iter-072 task result):
1. Unfold `cechCochain → cechComplexFunctor.obj → alternatingCofaceMapComplex.comp cosimplicialObjectFunctor`
   to expose `scK₀.f` as an alternating sum of `δ_k`-face maps.
2. Each `δ_k` at degree `n` is a `Pi.lift` of presheaf restrictions
   `(C.left.presheaf.map _).hom`.
3. Each restriction is an `R = Γ(C.left, U)`-algebra-hom via the project-local
   `algebraMap_naturality` chain (`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:161`).
4. Hence each `δ_k` is `R`-linear; `Pi.map (R-linear)` is `R`-linear pointwise;
   sums of `R`-linear maps are `R`-linear.

**Estimated**: 100–150 LOC, mostly mechanical unfolding + `LinearMap.pi_apply` shuffling.

### P4 — Polish: marker-sync the closed Differentials sorries

**Why**: `cotangentExactSeqAlpha` is now sorry-free. `sync_leanok` will mark
`def:cotangent_alpha`'s proof block `\leanok` automatically; verify in iter-073's
review that this happened.

**Action**: none for the plan agent — the sync phase handles it.

### P5 — Build environment repair

**Why**: persistent since iter-069. `lake env lean` fails with
`unknown module prefix 'Mathlib'` because `.lake/packages/{doc-gen4,checkdecls,mathlib}`
are root-owned. iter-072's provers all relied on cached LSP oleans and standalone
`lean_run_code` for verification. The next plan agent should ask the user
to repair the permissions before dispatch.

### Do NOT assign (blocked / deferred)

- **`exists_unique_ofCurve_comp` genus-0 existence** (AbelJacobi.lean L111) —
  rigidity sorry. Requires `Hom(ℙ¹_k, A) = A(k)` infrastructure (Brauer-Severi,
  Pic⁰(ℙ¹) = 0, dual abelian varieties). Multi-week mathematical effort, on par
  with `nonempty_jacobianWitness`. Treat as a long-horizon Phase F obligation.
- **`nonempty_jacobianWitness`** (Jacobian.lean L172) — Albanese existence;
  unchanged.
- **`PicardFunctor.representable`** (Picard/Functor.lean L190) — unchanged.
- **`relativeDifferentialsPresheaf_isSheaf`** (Differentials.lean L122) — large
  but tractable; lower priority than `_structure` closure.
- **`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`**
  (Differentials.lean L413/L430/L572) — downstream of `_structure` closure.
- **`h_π_split` / Cluster (a) substeps** (BasicOpenCech.lean L495, L819, L847) —
  three-iteration dead end on the `alternatingCofaceMapComplex.map_f` simp gap.
- **`h_loc_exact`** (BasicOpenCech.lean L1083) — secondary; closes naturally once
  Cluster (b) is fully discharged.

## Reusable patterns to propagate

1. **`unfold ... ; split_ifs with h` for `dite`-shaped definitions**
   *(NEW iter-072)*. When a definition is wrapped in
   `if h : P then ... else ...`, every downstream lemma case-splits on `h`. The
   pattern is robust under `dsimp`-coercion fragility because `unfold` precedes
   `split_ifs`.

2. **Witness uniformity over a marked point: `predicate : ∀ x, P x`**
   *(NEW iter-072)*. Storing a Π-family of predicates inside an existence
   bundle lets every consumer pick its own argument without reshaping the
   existence statement of the underlying object. Strictly better than
   parameterising the bundle on the argument.

3. **`apply e.injective; calc ...; congr 1` for transported smul**
   *(NEW iter-072)*. To prove `f (r • x) = r • f x` between transported
   `Module R` structures, apply target-side `LinearEquiv.injective`, then
   reduce one step via `congr 1` (which works by rfl because the smul is
   literally `e.toEquiv.smul R`).

4. **Adjunction-coherence is `rfl` for composed pullback adjunctions**
   *(NEW iter-072)*. The identity
   `φ_g' ≫ f.c = adj_f.unit ≫ (pushforward f.base).map φ_fg'`
   is definitional. Reusable for derivation/sheafification transport along
   composition.

5. **Helper-claim factorisation for opaque transport sorries**
   *(NEW iter-072)*. Even when the sorry count stays the same, factoring an
   opaque sorry into (mechanical transport calc) + (labelled deep-content
   `have`) is strictly better than a single bare sorry.

6. **Patterns retained from prior iterations** (use as-is): single-witness
   consolidation, `toFun := ⇑(ConcreteCategory.hom f)`, `localizedModuleIsLocalizedModule`
   one-liner, `refine ⟨?_, ?_, ?_⟩` decomposition, `ModuleCat.piIsoPi + e.toAddEquiv.module R`
   transport, adjunction-then-universal-property skeleton, genus-0 terminal-object
   discharge.

## Process notes

- **Build environment caveat persists.** Five iterations in a row now (068 onwards).
  Treat fresh post-edit verification as **unavailable** until the user fixes
  `.lake/packages/*` permissions.
- **No `archon[072/marker-sync]` commit visible** in the inner-git log
  (consistent with the build env failure — `sync_leanok` cannot run
  `sorry_analyzer` if `lake env lean` is broken). Treat `\leanok` placement as
  "stale by one iteration" until the env is fixed.
- **Lane-1/Lane-2 dependency was clean.** The plan agent's PROGRESS.md spelled
  out the post-refactor shape (`isAlbaneseFor : ∀ P, ...`); Lane 2's prover
  wrote against that shape and Lane 1 delivered it. Recommended template for
  future cross-lane refactor + consume dispatches.
- **Blueprint chapter mismatch**: BasicOpenCech prover noted that the prover task
  header references `AlgebraicJacobian_Cohomology_BasicOpenCech.tex` but the
  actual blueprint chapter for that content is `Cohomology_MayerVietoris.tex`.
  The plan agent should reconcile (either rename / split the chapter or update
  the task-prompt header).

## Suggested iter-073 dispatch (3 lanes)

1. **Lane A (Differentials)**: One prover on `_structure.h_zero` + `_structure.h_exact`
   (P1) — paired because they share the affine-chart `KaehlerDifferential.exact_mapBaseChange_map`
   reduction.
2. **Lane B (Differentials)**: One prover on `_structure.h_epi` (P2) — independent
   of Lane A; needs the `SheafOfModules.epi_of_epi_presheaf` helper.
3. **Lane C (BasicOpenCech)**: One prover on `h_diff_pi_smul_f` + `h_diff_pi_smul_g`
   (P3). Cluster (b) closure unlocks `h_loc_exact` (P4 if budget allows).

Net target for iter-073: **−4 to −6 sorries** (from 16 to 10–12), depending on
how cleanly Cluster (b) and `_structure` close.
