# Session 22 (iter-022) — review summary

## Metadata
- **Iteration / session**: iter-022 / session_22
- **Model**: claude-opus-4-8 (both prover lanes, mathlib-build mode)
- **Sorry count**: 2 → 2 (no regression). Both intentional:
  `CechAcyclic.lean:110` (superseded relative-form `affine`, blueprint-authorized via
  `% NOTE`) + `CechHigherDirectImage.lean:679` (frozen P5b).
- **Build**: GREEN. Both touched files diagnostic-clean; both verified `lake env lean … → EXIT 0`.
- **Lanes planned 2, ran 2** — the iter-021 noop trap was FIXED (planner D1). This is the
  first iter since iter-019 that FreePresheafComplex actually received prover work.
- **+30 axiom-clean declarations** (16 CechAcyclic + 14 FreePresheafComplex); **0 new sorries**.
- **2 named blueprint targets landed** (both in CechAcyclic):
  `sectionCech_homology_exact` (`lem:section_cech_homology_exact`) and
  `sectionCech_affine_vanishing` (`lem:cech_acyclic_affine`, section form).

## Targets

### `sectionCech_affine_vanishing` + `sectionCech_homology_exact` (CechAcyclic) — SOLVED
The complete P3 L1 **tilde-bridge** (steps A/B/d): the categorical→module homology bridge
for the tilde sheaf `F = ~M`, closing the section-form affine Čech vanishing.

Built bottom-up (16 decls, all `{propext, Classical.choice, Quot.sound}`):
- `phiL` — per-σ `R`-linear comparison `~M(⨅ₖ D s_{σk}) ≃ₗ M_{s_σ}` via `IsLocalizedModule.iso`.
- `phi` / `phi_eq_phiL` — additive form on the accessor-1 (`Ab`) section group + defeq bridge.
- `restr_bridge` — accessor-1 (`Ab`) vs accessor-2 (`ModuleCat`) restriction agree, by `rfl`
  on an **abstract** inclusion (the same `rfl` on the concrete `homOfLE (le_iInf …)` blows up `whnf`).
- `phiL_naturality` / `phi_naturality` — per-coface naturality `φ_σ ∘ faceRestr = dCoface ∘ φ_{σ∘dᵢ}`.
- `sectionProdAddEquiv`, `sectionToModuleAddEquiv`(+`_apply`), `sectionProdEquiv_symm_apply` —
  degreewise additive comparison `ToType(∏ᶜ_σ ~M(D s_σ)) ≃+ ∏_σ M_{s_σ}` (ladder vertical maps).
- `sectionCechCofaceMatch` (`lem:section_cech_coface_match`), `sectionCechAbExact`
  (`lem:section_cech_ab_exact`) — ladder square + underlying-group exactness via
  `Function.Exact.of_ladder_addEquiv_of_exact` transporting the proven `SectionCechModule.dDiff_exact`.

**Key proof saga — `phiL_naturality` (the bottleneck):**
1. Naive `IsLocalizedModule.ext` over the concrete `modulesSpecToSheaf` section restriction →
   `(deterministic) timeout at whnf` even at **2,000,000 heartbeats** (accessor-2 `~M` section
   types are defeq-intensive).
2. Abstract the restriction map as opaque `g` (`set g := …; clear_value g`) BEFORE `ext`, with
   `hg` recording the `tilde.toOpen_res` compatibility → `ext` no longer whnf's the heavy map.
3. But the goal then carries `↑(iso).symm ∘ₗ g` (a `LinearEquiv` coerced to `LinearMap`):
   `rw`/`simp [LinearMap.comp_apply/coe_comp]` and `LinearMap.comp_assoc` **silently fail to
   match** (semilinear `RingHomCompTriple` instance mismatch).
4. **Resolution**: `change`/`show` to the defeq fully-applied form, then `rw` the *applied*
   (`DFunLike.congr_fun`) versions of `iso_symm_comp` as named local facts; close with
   `comparison_apply`. Closes at **800,000 heartbeats** (documented inline).

Only deferred gap: the general-qcoh reduction `F ≅ ~(ΓF)` (Stacks 01I8). Correctly scoped in
the blueprint (`% NOTE` + no `\leanok`); NOT a blocker for this lane.

### `cechFreeEvalEngineIso` (FreePresheafComplex) — BLOCKED (4th iter), but route fully de-risked
The named Route-2 target (the differential comm-square) was **not built** — left as a documented
comment block, **no sorry, no axiom** (all-or-nothing `def`). BUT this was not a setup-only
return: the prover executed the CHURNING corrective (analogist → prover) and built **14
axiom-clean decls** — the entire engine target complex and its contractibility:
- Object half: `le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`,
  `cechFreeEvalEngine_X` (the degreewise object iso `(eval V)(K_p) ≅ ∐_{τ:Fin(p+1)→I₁(V)} O_X(V)`).
- Engine complex `C•`: `coverSectionModule`, `cechEngineX`, `cechEngineD`(+`_ι`),
  `cechEngineD_comp` (**d²=0**), `cechEngineComplex`.
- Contractibility: `cechEnginePrepend`(+`_ι`), `cechEnginePrepend_spec` (**`d∘s+s∘d=id`**,
  closed first try), `cechEngineD_exact` (**positive-degree `Function.Exact`**).

This resolves the long-standing **variance question**: the chain differential is the alternating
sum of index-dropping reindexings `σ ↦ σ∘Fin.succAbove i` — the chain transpose of
`FreeCechEngine.combDifferential`.

**The only missing fact** is `comm` for `isoOfComponents`: that `cechFreeEvalEngine_X` commutes
with the differentials. The precise route (push the 3-fold composite through
`PreservesCoproduct.iso` naturality + eval of `freeYoneda.map`, with `survivingEquiv` natural in
the face map) is documented in `task_results/FreePresheafComplex.md`; ~60–120 lines, all inputs in-file.

Notable Lean lessons: `Sigma.whiskerEquiv e w : ∐ f ≅ ∐ g` (NOT `∐ g ≅ ∐ f` — the analogist note
was backwards); needed `.symm` + explicit `(g := …)` (HOU failed). Element-level work on `ModuleCat`
hom equalities goes via `congrArg ModuleCat.Hom.hom` + `ModuleCat.hom_{add,comp,id,zero}` +
`LinearMap.{add,comp,zero,id}_apply` + `DFunLike.congr_fun` (`ModuleCat.add_apply`/`zero_apply` do not exist).

## Review-subagent findings (full reports linked; not repeated here)
- **lean-auditor** (`task_results/lean-auditor-iter022.md`): 0 critical, 1 major, 5 minor.
  Both files axiom-clean. Major: FreePresheafComplex module header lists `cechFreeComplex_quasiIso`
  as a decl the file "owns" but it is not defined; the honest "not built" note sits only at the
  end → header misleads. Minors: stale CechAcyclic module docstring; `sectionCech_affine_vanishing`
  is a redundant alias of `sectionCech_homology_exact`; `FreeCechEngine`/`CombinatorialCech`
  duplication (known maintenance debt from `private` visibility).
- **lean-vs-blueprint-checker / CechAcyclic** (`task_results/lean-vs-blueprint-checker-cechacyclic.md`):
  0 must-fix, 3 minor. Named targets faithfully match; deferred qcoh reduction correctly scoped.
- **lean-vs-blueprint-checker / FreePresheafComplex**
  (`task_results/lean-vs-blueprint-checker-freepresheafcomplex.md`): 0 must-fix, 6 major (all
  blueprint-side): the prepend-homotopy `\lean{}` re-leveling (×2), 14 unreferenced engine decls
  needing a new `lem:cech_engine_complex` block, honest unbuilt `cechFreeEvalEngineIso`, and the
  blueprint under-specifying the comm-square's `survivingEquiv`-naturality step.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_free_eval_prepend_homotopy`: added `% NOTE`
  — pinned `\lean{cechFreeEvalPrependHomotopy}` does not exist; prover built the contraction at the
  engine-complex level as `cechEnginePrepend`; planner/writer to re-point `\lean{}` + re-level prose.
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_free_eval_prepend_homotopy_spec`: added `% NOTE`
  — same; built as `cechEnginePrepend_spec` (+ `cechEngineD_exact`).
- (No `\mathlibok` added — no decl this iter is a Mathlib re-export. No stale `\notready` found.
  No `\leanok` touched — owned by `sync_leanok`, which ran for iter 22: added 2, removed 2.)

## Coverage debt
`archon dag-query unmatched` = **26** `lean_aux` nodes (all 16 CechAcyclic helpers + 10 of the 14
FreePresheafComplex engine decls — the other 4 reuse existing labels). Full list + recommended
attachment blocks are in `recommendations.md` for the planner to blueprint.

## Key findings / patterns
- **The noop-trap fix paid off immediately**: putting the scaffold keyword ON the `.lean` path line
  unblocked Route 2 after two lost iters. Both lanes ran; +30 decls.
- **P3 L1 is essentially closed** (tilde case): the affine Čech vanishing — the project's
  longest-running module-algebra route — landed both named targets.
- **Route 2 is convergence-shaped churn**: the named target has been absent 4 iters, but the
  residual is now a single comm-square lemma with every input in-file and a documented route.
  iter-023 is the decision point (see recommendations).
