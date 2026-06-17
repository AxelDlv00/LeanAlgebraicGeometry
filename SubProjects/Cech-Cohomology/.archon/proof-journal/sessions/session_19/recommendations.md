# Recommendations for the next plan iteration (post iter-019)

## CRITICAL / must-fix-this-iter (blocks a lane)

### 1. Expand `lem:cech_free_complex_quasi_iso` proof sketch BEFORE re-dispatching the quasi-iso lane
**Source**: lean-vs-blueprint-checker freepresheafcomplex (must-fix, blueprint adequacy) —
`.archon/logs/iter-019/lean-vs-blueprint-checker-freepresheafcomplex-report.md`.
The current sketch gives the correct *mathematical* content (homotopy formula, sectionwise split,
`dh+hd=id`) but **omits the Lean packaging pathway entirely**. A prover reading only the blueprint
cannot assemble the remaining Lean argument. Dispatch a **blueprint-writer** for
`Cohomology_CechHigherDirectImage.tex` to add, to `lem:cech_free_complex_quasi_iso`:
- the `quasiIso_of_evaluation` objectwise-reduction bridge (now built — anchor it);
- the per-`V` `I₁ = {i : V ≤ U_i}` case split (`I₁ = ∅` ⟹ both sides `0`; `I₁ ≠ ∅` ⟹ extra-degeneracy
  homotopy);
- the Lean packaging: `HomologicalComplex.Homotopy` → `HomotopyEquiv` → `HomotopyEquiv.quasiIso_hom`
  (`HomotopyEquiv.toQuasiIso`), and the Mathlib-blessed `AugmentedCechNerve.extraDegeneracy` /
  `Rep.standardComplex.εToSingle₀` template;
- how to evaluate `K(𝒰)_p(W)` (`(evaluation V).obj (freeYoneda.obj W)` = free `O_X(V)`-module on
  `Hom(V,W)`, i.e. `O_X(V)` if `V ≤ W` else `0`).
Only after this (and the HARD-GATE scoped re-review clears) re-dispatch the FreePresheafComplex
quasi-iso prover. **Route (b)** (reuse `AugmentedCechNerve.extraDegeneracy`) is the Mathlib-blessed
path; **route (a)** (port `CombinatorialCech.combHomotopy` to ModuleCat) is the fallback. This is a
large build (~20+ decls), comparable to the whole `CombinatorialCech.*` development — consider an
`effort-breaker` on `lem:cech_free_complex_quasi_iso` to split it into the case-split + homotopy +
packaging sub-lemmas.

## HIGH

### 2. Closest-to-completion: P3 L1 continues with the sheaf-section sub-build (steps b–d)
`dDiff_exact` (step a, the module-algebra core) is DONE. The remaining `lem:cech_acyclic_affine`
(section form) work is a **distinct sheaf-section sub-build**, independent of the P3b lanes:
- **(b)** `def:qcoh_sections_localized` (`qcohSectionsAwayLocalized`) — tilde-`M` case via
  `tilde.toOpen` (`IsLocalizedModule (.powers g)`) + `tilde.toOpen_res`; then bolt on
  arbitrary-quasicoherent `F ≅ tilde(ΓF)` (Stacks 01I8) separately.
- **(c)** `lem:section_cech_homology_exact` (`sectionCech_homology_exact`) — **add
  `import AlgebraicJacobian.Cohomology.PresheafCech`**; identify `sectionCechComplex` degreewise with
  this iter's `D•` (`dCoeff`/`dDiff`); then `exactAt_iff_isZero_homology` +
  `ShortComplex.moduleCat_exact_iff` turn **`dDiff_exact`** (the `Function.Exact` input) into
  `IsZero (homology p)`.
- **(d)** `sectionCech_affine_vanishing` — assemble (a)–(c).
This is dispatchable as a mathlib-build lane (CechAcyclic already carries a sorry, so no noop risk).

### 3. P3b bridge: hold `injective_cech_acyclic` until the quasi-iso lands
`cechComplex_hom_identification` (the transport bridge) is now built, so `injective_cech_acyclic`
needs only `cechFreeComplex_quasiIso` + injectivity (`injective_toPresheafOfModules`) + a bridging
lemma. **Do NOT dispatch `injective_cech_acyclic` until rec #1's quasi-iso lands** — building against a
non-existent lemma would force a `sorry`. (This is the same cross-lane gate the prover correctly
respected this iter.)

## MEDIUM

### 4. Coverage debt: bundle 28 unmatched helpers into `\lean{}` lists (planner — prose)
`archon dag-query unmatched` = **28** `lean_aux` nodes, all this iter's new helpers, all
`proved:true, has_sorry:false`. Bundle into the relevant blueprint blocks' `\lean{...}` lists:
- **CechAcyclic / `SectionCechModule.*` + `AwayComparison.*`** (24): `Inverts.smul_pow_cancel`,
  `comparison_isLocalizedModule`, `dCoeff`, `dCoface`, `dDiff`, `dDiff_apply`, `dToCech`,
  `dToCech_isLocalizedModule`, `cechCoface_dToCech`, `dToCech_comm`, `cechCofaceLin`,
  `cechCoface_apply`, `locDiff`, `locDiff_apply`, `locDiff_eq_depDiff`, `locDiff_exact`, `fLoc`,
  `fLoc_apply`, `fLoc_isLocalizedModule`, `locDiff_fLoc`, `map_dDiff_eq_locDiff`, `dDiff_exact`.
  lvb-cechacyclic specifically flags `Inverts.smul_pow_cancel` + `comparison_isLocalizedModule` as
  **substantive (major)** — add them to `lem:section_cech_homology_exact`'s `\lean{}`. (`spanIdx`,
  `spanIdx_spec` are private — bundle to keep `unmatched` at 0, not standalone.)
- **CechBridge** (1): `homCechSectionCosimplicialIso` → bundle into `lem:cech_complex_hom_identification`.
- **FreePresheafComplex** (3): `quasiIso_of_evaluation` (+ private `isIso_Fmap_homologyMap`,
  `isIso_of_evaluation`) → a sub-block under `lem:cech_free_complex_quasi_iso`, e.g.
  `lem:quasiIso_of_evaluation` ("a morphism of complexes of presheaves of modules is a quasi-iso iff
  each evaluation is").

### 5. Refactor: fix 4 stale module-docstring comments (review agent cannot edit .lean)
**Source**: lean-auditor iter019 (`.archon/logs/iter-019/lean-auditor-iter019-report.md`).
All major, no wrong code — but actively misleading:
- `CechHigherDirectImage.lean:347–387` — **most dangerous**: says `pushPullMap_comp` is "not yet
  closed / dead-ends" but it IS proved at line 564 (contradicts line 168 in the same file).
- `CechBridge.lean:29–44` — labels `cechComplex_hom_identification` as `(planned)` despite being
  implemented this iter.
- `FreePresheafComplex.lean:19–22` — lists `cechFreeComplex_quasiIso` as an owned declaration but it
  is not in the file (still a comment-referenced target).
- `AcyclicResolution.lean:26–35` — "will be constructed" for all three main declarations that ARE
  constructed.
Dispatch a **refactor** subagent to update these docstrings (no proof changes).

### 6. Blueprint accuracy: 3 private helpers listed by full external namespace (CechBridge)
**Source**: lvb cechbridge (minor). The chapter lists `pi_mapIso_hom_eq`,
`homCechSectionIsoApp_hom_π`, `freeYonedaHomAddEquiv_naturality` by full external namespace, but
`private` makes those names inaccessible externally. A blueprint-writer pass should reconcile (drop or
re-anchor) when next editing that chapter.

## Do NOT retry without a structural change
- **`cechFreeComplex_quasiIso` as a one-shot prover fill** — the per-`V` homotopy is a ~20-decl build;
  it needs the blueprint expansion (rec #1) + likely an effort-breaker decomposition first. The prover
  correctly declined to pin it with a `sorry` this iter.
- **`injective_cech_acyclic`** — blocked on the quasi-iso (rec #3); not a tactic problem.
- **`CechAcyclic.affine` (relative form, line 109 sorry)** — superseded by the section form (Q4,
  iter-017). Do NOT re-dispatch the relative form; it is unprovable via localisation
  (`pushforward f` preserves kernels, not homology; affine-pushforward exactness absent from Mathlib).

## Reusable proof patterns discovered this iter (also in PROJECT_STATUS.md KB)
- **Opaque-index for `exact_of_isLocalized_span`**: wrap the per-`ρ` `Exists.choose` in a
  `private def spanIdx` so the `↑ρ = s i` rewrite motive is type-correct; supply the
  `[∀ ρ, IsLocalizedModule.Away ↑ρ (f ρ)]` instances via `haveI` BEFORE the `refine`.
- **`erw`-everywhere + upfront `dsimp` for cosimplicial/Yoneda naturality** (carrier defeq mismatch).
- **Joint-conservativity objectwise reduction** of a `PresheafOfModules` quasi-iso to per-`V`
  (`toPresheaf` reflects isos + `PreservesHomology (evaluation R V)`); the single-functor
  `quasiIso_map_iff_of_preservesHomology` is unusable (evaluation is not conservative).
- **Localisation transitivity** `M_a[1/b] = M_{ab}` via `IsLocalizedModule.mk`
  (`comparison_isLocalizedModule`).
