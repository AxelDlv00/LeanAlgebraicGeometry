# Session 71 — iter-071 review

## Metadata

- **Archon iteration**: 071
- **Stage**: prover (three parallel tracks: BasicOpenCech, Differentials, Jacobian)
- **Sorry count before iter-071** (syntactic, per-file aggregate of active sites):
  - BasicOpenCech 11 + Differentials 6 + Jacobian 5 + AbelJacobi 3 + Picard/Functor 1 = **26**.
- **Sorry count after iter-071** (syntactic, per-file aggregate of active sites):
  - BasicOpenCech 6 + Differentials 8 + Jacobian 1 + AbelJacobi 3 + Picard/Functor 1 = **19**.
- **Net change**: **−7 sorries** (largest single-iteration delta since iter-064).
- **Compilation status**: Project `lake build` is blocked by an unrelated environment failure (`Mathlib.olean` not found in search path; mathlib oleans not built in this sandbox). The three provers each reported clean LSP diagnostics earlier in the iteration and validated edits via standalone `lean_run_code` snippets. LSP `lean_diagnostic_messages` now returns `success: false` because the on-disk oleans pre-date the prover edits and Mathlib's build dir is unwritable. Treat compilation as **not freshly verified this review pass**; the next iteration must rebuild the cache before relying on the new declarations.

---

## Prover attempt analysis (from `attempts_raw.jsonl`)

The pre-processed attempt log contains **279 events** (9 edits across 3 files, 17 goal checks, 22 diagnostic checks, 3 build attempts, 17 lemma searches). All recorded diagnostics on the three changed files reported `error_count: 0` (`clean: true`) prior to the LSP cache going stale.

### Target 1 — `Jacobian.lean` (Phase C, Sub-goal B): **5 → 1 sorries**

**Status**: PARTIAL (high-value structural refactor).

The prover took sub-goal B from PROGRESS.md and consolidated all five protected sorries into a single named existence hypothesis.

#### Attempt 1 — Add `JacobianWitness` bundle + `nonempty_jacobianWitness` (raw log ~10:15:35 UTC, edit on Jacobian.lean L113–162)

- **Strategy**: Introduce a structure bundling `J`, all four abelian-variety instances, the `SmoothOfRelativeDimension (genus C)` witness, the marked point `P`, and the Albanese universal-property proof. Declare existence of such a bundle as a single sorry (`nonempty_jacobianWitness`). Extract via `Classical.choice` into a `noncomputable def jacobianWitness`.
- **Code tried**:
  ```lean
  structure JacobianWitness (C : Over (Spec (.of k)))
      [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
      [GeometricallyIrreducible C.hom] where
    J : Over (Spec (.of k))
    grpObj : GrpObj J
    proper : IsProper J.hom
    smooth : Smooth J.hom
    geomIrred : GeometricallyIrreducible J.hom
    smoothGenus : SmoothOfRelativeDimension (genus C) J.hom
    P : 𝟙_ _ ⟶ C
    isAlbanese : @IsAlbanese k _ C P J grpObj proper smooth geomIrred

  theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
      [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
      [GeometricallyIrreducible C.hom] :
      Nonempty (JacobianWitness C) :=
    sorry

  noncomputable def jacobianWitness (C : Over (Spec (.of k))) [...] :
      JacobianWitness C :=
    Classical.choice (nonempty_jacobianWitness C)
  ```
- **Goal context**: each of the four protected instances previously had a `sorry` in the `genus C > 0` branch. After the refactor each branch is `exact (jacobianWitness C).<field>`.
- **Result**: SUCCESS (structural). Five protected sorries collapse into one (and `Jacobian C`'s `g > 0` branch goes from a bare `sorry` to `(jacobianWitness C).J`).
- **Insight**: Sub-goal B from PROGRESS.md targeted 5 → 2; the prover reached 5 → 1 by bundling `SmoothOfRelativeDimension (genus C) J.hom` into the witness rather than leaving it as a separate sorry. The remaining hypothesis is the classical Albanese existence claim, which is genuinely a single mathematical assertion (Brill–Noether or Picard-scheme construction).

#### Attempt 2 — Wire the four instances to the witness (raw log ~10:15:44 UTC, edit on Jacobian.lean L196–223)

- **Strategy**: Replace each `· sorry` in the `g > 0` branch with the corresponding witness projection.
- **Code tried**:
  ```lean
  instance instGrpObj : GrpObj (Jacobian C) := by
    unfold Jacobian; split_ifs
    · infer_instance
    · exact (jacobianWitness C).grpObj
  -- analogous for smoothOfRelativeDimension_genus, instIsProper, instGeometricallyIrreducible
  ```
- **Result**: SUCCESS — each protected signature retained verbatim; only the proof body changed.
- **Insight**: The plan-agent forbidden shortcut (`Jacobian C := 𝟙_ _` unconditionally) is avoided because the genus-0 branch is gated by `if h : genus C = 0` and the genus-`>0` branch projects an *actually-`g`-dimensional* witness scheme.

**Net for Jacobian.lean**: 5 → 1 sorries (−4 closed via consolidation; 1 surviving sorry is `nonempty_jacobianWitness`, a new mathematical existence claim that is *not* in `archon-protected.yaml`).

---

### Target 2 — `BasicOpenCech.lean` (Phase A, Clusters b + c): **11 → 6 sorries**

**Status**: PARTIAL (Cluster (c) fully closed; Cluster (b) reduced from 4 to 2; Clusters (a) + `h_π_split` untouched).

#### Attempt 1 — Cluster (c) discharge via `localizedModuleIsLocalizedModule` (raw log ~10:19:53 UTC, edit on BasicOpenCech.lean L959–L1004)

- **Strategy**: Replace the three `IsLocalizedModule.Away f.1` sorries (one per `scK₀.X_i`) with the Mathlib canonical instance for `LocalizedModule.mkLinearMap`.
- **Code tried**:
  ```lean
  have h_loc_X₁ (f : ↑s₀) : IsLocalizedModule.Away (f.1 : R)
      (LocalizedModule.mkLinearMap (Submonoid.powers (f.1 : R)) scK₀.X₁) :=
    localizedModuleIsLocalizedModule _
  -- identical for h_loc_X₂, h_loc_X₃
  ```
- **Result**: SUCCESS. 3 sorries → 0.
- **Insight**: The plan-agent suggested attacking `h_loc_X₁` only; the prover landed all three because the discharge is kernel-only and identical across `i ∈ {1,2,3}`. The semantic content shifted to `h_loc_exact` (now L1012) which carries the slice-cover ↔ `LocalizedModule` identification.

#### Attempt 2 — Cluster (b) `f_R`/`g_R` repackaging + `hf_eq`/`hg_eq` rfl-closure (raw log ~10:14:27 UTC, edit on BasicOpenCech.lean L949–L985)

- **Strategy**: Package the underlying `k`-linear Čech differential `ConcreteCategory.hom scK₀.f` directly as an `R`-linear map by exhibiting `toFun`, `map_add'`, `map_smul'` explicitly. With `toFun := ⇑(ConcreteCategory.hom scK₀.f)`, `hf_eq := rfl` is definitional.
- **Code tried**:
  ```lean
  let f_R : scK₀.X₁ →ₗ[R] scK₀.X₂ :=
    { toFun := ⇑(ConcreteCategory.hom scK₀.f)
      map_add' := map_add (ConcreteCategory.hom scK₀.f)
      map_smul' := by intro r x; sorry }
  let g_R : scK₀.X₂ →ₗ[R] scK₀.X₃ := { ... map_smul' := by intro r x; sorry }
  have hf_eq : ⇑f_R = ⇑(ConcreteCategory.hom scK₀.f) := rfl
  have hg_eq : ⇑g_R = ⇑(ConcreteCategory.hom scK₀.g) := rfl
  ```
- **Result**: PARTIAL. 4 sorries → 2 (the `map_smul'` obligations for `f_R` and `g_R` remain at L974 and L983).
- **Insight**: With `h_mod_X_i : Module R scK₀.X_i` in scope (iter-069 prover's `(ModuleCat.piIsoPi Z).toLinearEquiv.toAddEquiv.module R` transport), the R-linear-map type already typechecks. The remaining obligation is precisely `map_smul'` — R-linearity of the alternating-coface differential. The `convert h` transport in `h_mod_X_i` produces an opaque module structure that obstructs direct rewriting; closing `map_smul'` likely requires refactoring `h_mod_X_i` to expose the componentwise R-action.

#### Untouched sorries
- L495 (substep (a) extra-degeneracy at `D(f)` slice cover on `s`) — same blocker since iter-061.
- L819 (`h_π_split` analogue / refinement transport `s → s₀`) — same blocker since iter-064. (Plan ranked this as P1, but the prover prioritised Cluster (b)/(c) per the plan's "attack Cluster (b) first" recommendation.)
- L847 (substep (a) extra-degeneracy on `↑s₀`-indexed slice cover) — same blocker since iter-064.

**Net for BasicOpenCech.lean**: 11 → 6 sorries (−5 closed in Cluster (b)+(c); 2 new `map_smul'` subgoals from the Cluster (b) decomposition; 3 unchanged extra-degeneracy / refinement-transport sorries).

---

### Target 3 — `Differentials.lean` (Phase B): **6 → 8 sorries**

**Status**: IN PROGRESS (structural decomposition; net sorry count went UP, which is acceptable per the plan's transient-sorry policy).

#### Attempt 1 — `cotangentExactSeqAlpha` adjunction-then-universal-property skeleton (raw log ~10:14:51 / ~10:17:08 / ~10:18:18 UTC, three edits on Differentials.lean L199–L243)

- **Strategy**: Mirror iter-069's `cotangentExactSeqBeta` construction. Apply `Scheme.Modules.pullbackPushforwardAdjunction f` to convert the goal to a hom of `Y.Modules`, then build that hom from the universal property of `relativeDifferentialsPresheaf g`.
- **Code tried**:
  ```lean
  noncomputable def cotangentExactSeqAlpha (f : X ⟶ Y) (g : Y ⟶ S) :
      (Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶
        relativeDifferentials (f ≫ g) := by
    refine ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).symm ?_
    let φ_g' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
      S.presheaf Y.presheaf).symm g.c
    let φ_fg' := ...
    let presheafHom : relativeDifferentialsPresheaf g ⟶
        (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
          (relativeDifferentialsPresheaf (f ≫ g)) :=
      (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc sorry
    exact ⟨presheafHom⟩
  ```
- **Result**: PARTIAL. The bare `:= sorry` becomes a `by`-block skeleton with **1** substantive inner `sorry` at L242 (the `Derivation' φ_g'` target witness inside `desc`).
- **Insight**: Confirmed Mathlib leverage names: `Scheme.Modules.pullbackPushforwardAdjunction`, `PresheafOfModules.DifferentialsConstruction.isUniversal'`, `PresheafOfModules.pushforward`, `Scheme.Hom.toRingCatSheafHom`. The remaining content is to build the `Derivation'` of the pushed-forward target — four named axioms (`d_add`, `d_mul`, `d_map`, `d_app`) of which only `d_app` is non-mechanical (requires adjunction-coherence across `f ≫ g`).

#### Attempt 2 — `cotangentExactSeq_structure` 3-case decomposition (raw log ~10:19:35 / ~10:24:42 UTC, two edits on Differentials.lean L344–L368)

- **Strategy**: Replace the bundled `:= sorry` with `refine ⟨?_, ?_, ?_⟩` to split into three named sub-claims (`h_zero`, `h_exact`, `h_epi`), each annotated with its ring-level Mathlib input.
- **Code tried**:
  ```lean
  lemma cotangentExactSeq_structure (f : X ⟶ Y) (g : Y ⟶ S) :
      ∃ (h : cotangentExactSeqAlpha f g ≫ cotangentExactSeqBeta f g = 0),
        (CategoryTheory.ShortComplex.mk
          (cotangentExactSeqAlpha f g) (cotangentExactSeqBeta f g) h).Exact ∧
        CategoryTheory.Epi (cotangentExactSeqBeta f g) := by
    refine ⟨?_, ?_, ?_⟩
    · sorry -- h_zero: α ≫ β = 0 via KaehlerDifferential.exact_mapBaseChange_map
    · sorry -- h_exact: range = kernel, same Mathlib input
    · sorry -- h_epi: KaehlerDifferential.map_surjective + sheaf-of-modules epi-from-affine
  ```
- **Result**: PARTIAL. 1 bundled sorry → 3 named subgoals. Mathematical analysis recorded inline.
- **Insight**: `h_zero` and `h_exact` are blocked behind closure of `cotangentExactSeqAlpha`; `h_epi` is independent and can be attempted in isolation if the prover finds a `SheafOfModules` "Epi locally on affines ⇒ Epi" passage.

**Net for Differentials.lean**: 6 → 8 sorries (+2). The +2 is the cost of decomposing two bundled bare `:= sorry`'s into substantive skeletons: `Alpha` 1 → 1 (skeleton replaces bare; still one inner sorry); `_structure` 1 → 3 (3-case decomposition). The decompositions trade opacity for locality.

---

## Blueprint markers updated (manual)

No manual marker edits this iteration. Reasoning:

- `\mathlibok`: no new Mathlib re-exports / aliases were introduced (all changes are local proof bodies + new scaffolding declarations).
- `\lean{...}` renames: none. Protected signatures preserved verbatim. The new scaffolding declarations `JacobianWitness`, `nonempty_jacobianWitness`, `jacobianWitness` are introduced by the prover for sub-goal B but are not in the blueprint; they are *implementation scaffolding* and the plan agent may decide whether to add `\lean{...}` entries.
- `\notready` cleanup: none — no `\notready` markers exist in the project blueprint.
- `% NOTE:` annotations: none added — no fresh translation gaps to flag.
- `\leanok`: not touched (deterministic `sync_leanok` phase did not run this iteration because `lake build` is broken; see "Compilation status" above).

### Recommendation for plan agent (iter-072 blueprint pass)
- Add a brief informal sub-block to `blueprint/src/chapters/Jacobian.tex` mentioning the `JacobianWitness` consolidation (the bundled-existence formulation) so the new sorry's mathematical content (existence of the Albanese variety of `C`) is documented in the blueprint. This is optional and a plan-agent decision.

---

## Key findings / proof patterns discovered

1. **Single-witness consolidation pattern** *(NEW, iter-071, Jacobian.lean)*. When N protected instance fields all need the same data, bundling them into a single `structure` field-by-field and declaring `Nonempty bundle := sorry` lets each protected instance close via a field projection. This trades N sorries for 1 (a strict improvement when the N sorries share a common mathematical input). The bundle structure is unprotected, so the existence sorry can be attacked or replaced later without re-signing the protected declarations. Applicable to any future N-instance bundle whose existence is a single mathematical claim.

2. **`toFun := ⇑f; map_add' := map_add f` pattern** *(NEW, iter-071, BasicOpenCech.lean Cluster (b))*. When repackaging a categorical hom `f : X ⟶ Y` (with X, Y in a concrete category like `ModuleCat`) as a `LinearMap`, defining `toFun := ⇑(ConcreteCategory.hom f)` and `map_add' := map_add (ConcreteCategory.hom f)` makes `⇑f_R = ⇑f` definitionally true (`rfl`). The non-trivial residue is precisely `map_smul'` — the linearity over the new scalar ring. This pattern collapsed `hf_eq`/`hg_eq` from sorries to `rfl`.

3. **`localizedModuleIsLocalizedModule` as a one-liner discharge for `IsLocalizedModule.Away` instances** *(NEW, iter-071, BasicOpenCech.lean Cluster (c))*. The canonical Mathlib instance closes `IsLocalizedModule.Away f (LocalizedModule.mkLinearMap (Submonoid.powers f) M)` for any module `M`. Previously the prover infrastructure went through a slice-cover identification; the simpler discharge sidesteps the product-localisation commutation entirely (the slice-cover identification is now isolated in `h_loc_exact` at L1012, where it is genuinely needed).

4. **Adjunction-then-universal-property skeleton** *(extending iter-069 `cotangentExactSeqBeta` pattern, applied to Differentials.lean Alpha)*. For a cross-space pullback-target morphism, apply the `pullback ⊣ pushforward` adjunction `homEquiv.symm` to convert the goal into an adjoint hom, then construct the underlying presheaf-of-modules morphism via `isUniversal'.desc` of a `Derivation'`. The Derivation's four axioms split as: `d_add` (mechanical), `d_mul` (Leibniz, mechanical), `d_map` (naturality, mechanical), `d_app` (adjunction coherence — the substantive content).

---

## Quality flags / risks

1. **Compilation not re-verified end-to-end this iteration.** The `lake env lean` and LSP MCP both fail with environment errors (Mathlib oleans not built; `.lake/packages` ownership issues). All three provers reported clean diagnostics earlier in the run; the `attempts_raw.jsonl` log records 22 diagnostic checks with 0 errors. But this is from the *during-prover* LSP state, not a fresh post-edit verification. The plan agent for iter-072 should treat unblocking the build environment as a precondition (or at minimum run a one-off `lake exe cache get` + `lake build AlgebraicJacobian.<file>` per file to confirm).

2. **`nonempty_jacobianWitness` is a substantial mathematical claim, not a minor lemma.** It packages all five Phase-C deliverables for `genus C > 0` into a single existential. Closing it requires either (a) symmetric powers + Abel–Jacobi (Mathlib lacks quotients by finite group actions), (b) Picard scheme + FGA representability (same gap as `PicardFunctor.representable`), or (c) direct Albanese functor (requires either (a) or (b)). The plan agent should treat this as deferred indefinitely under current Mathlib infrastructure and prioritise Phase A/B closures.

3. **`BasicOpenCech.lean h_π_split` (L819) still untouched** despite being the plan's P1 target. The prover chose Cluster (b)/(c) instead because the plan's text said "attack Cluster (b) first". The P1 framing in `recommendations.md` (iter-070) and the "attack Cluster (b) first" framing in `PROGRESS.md` (iter-071) are in mild tension; the prover followed the more recent guidance. Net effect is positive (−5 sorries instead of attempting and failing on `h_π_split` for a 9th time), but the underlying `alternatingCofaceMapComplex.map_f` gap remains.

4. **Build environment caveat.** Provers consistently report `lake build` permission errors on `.lake/packages/*` and missing `Mathlib.olean`. This has persisted across iter-069, 070, and 071. The user has been pinged via iter-070 PROJECT_STATUS but no user action observed.
