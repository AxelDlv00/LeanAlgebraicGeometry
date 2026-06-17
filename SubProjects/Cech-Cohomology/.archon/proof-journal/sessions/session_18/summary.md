# Session 18 (iter-018) — review summary

## Metadata
- **Iteration**: 018. **Model**: claude-opus-4-8.
- **Sorry count**: 2 → 2 (no regression). The two are both intentional/known:
  `CechAcyclic.lean:74/109` (superseded relative-form `CechAcyclic.affine`, left in place per Q4) +
  `CechHigherDirectImage.lean:771` (frozen P5b assembly).
- **Build**: GREEN — `lake build` of all four touched modules succeeds (8323 jobs). The
  FreePresheafComplex breakage that blocked the CechBridge lane *mid-session* is resolved (the
  FreePresheafComplex prover repaired the broken-on-entry proof; file now compiles in 5.8s).
- **Net code**: **+36 axiom-clean declarations** across 4 parallel lanes, **0 new sorries**, 1
  broken-on-entry proof repaired. **0 named lane targets landed** — every lane handed off its named
  target with a precise decomposition, having built substantial sub-infrastructure.
- **Targets attempted** (all `partial`): `sectionCech_affine_vanishing` (CechAcyclic),
  `cechFreeComplex_quasiIso` (FreePresheafComplex), `cechComplex_hom_identification` (CechBridge),
  `higherDirectImage_isSheafify_presheafCohomology` (HigherDirectImagePresheaf).

## Per-target

### Lane 3 — `CechAcyclic.lean` L1 bridge (+22 decls, axiom-clean)
Built the two namespaces that are the **hardest, most-uncertain sub-task** the L1 analysis identified:
- `AwayComparison` (11): the reusable away-localisation comparison algebra. Canonical map `M_a → Mb`
  whenever `a` acts invertibly on `Mb` (`Inverts a Mb := IsUnit (algebraMap R (End R Mb) a)`), built
  via `IsLocalizedModule.lift`, characterised by `comparison_unique`, with identity/composition laws.
- `CechLocalized` (11): the concrete `δ` (`cechCoface`), `c` (`cechPrepend`) maps + the three
  compatibilities `cech_hu`/`cech_hsh`/`cech_hcomm`, culminating in `cechLocalized_exact` which feeds
  `CombinatorialCech.Dependent.depDiff_exact` the concrete maps → positive-degree exactness of the
  section Čech complex localised at a spanning element.

Key learnings (see milestones for code):
- `comparison` MUST be parameterised by the general `Inverts` hypothesis, NOT divisibility `a∣b` — the
  `c`-map source `s r²·s_σ` does not divide the target `s r·s_σ`, only its factors are invertible.
- The transport-heavy `hu`/`hsh`/`hcomm` became provable via `cechCoeff_transport_eq_comparison`
  (`subst` + `comparison_self`): `s_σ` depends only on the function `σ`, so the `▸` collapses.

**Did NOT build** the section-form target. Remaining chain: un-localised complex `D•` + `Function.Exact`
via `exact_of_isLocalized_span` (needs `IsLocalizedModule.pi` + transitivity-of-localisations) →
`def:qcoh_sections_localized` (build for `tilde M` first to dodge the Stacks-01I8 gap) →
`sectionCech_homology_exact`. The `import PresheafCech` was NOT added (deferred to the consumer step).

### Lane 1 — `FreePresheafComplex.lean` augmentation (+3 decls +1 repair, axiom-clean)
- **Repaired** the broken-on-entry proof of `cechFree_d_comp_aug` (root cause: `.X 0` carrier vs
  `.obj (op [0])` — defeq-not-syntactic, breaks `add_comp`/`zsmul_comp`/`δ_comp_aug` matching after
  `rw[hd]`). Fix: prove the simplicial-level identity as a FRESH-elaborated standalone `have`.
- Built `cechFreeComplexAug` — **the augmentation chain map** `K(𝒰)_• ⟶ O_𝒰[0]` (via
  `ChainComplex.toSingle₀Equiv` + `factorThruImage`), so the quasi-iso target is now phraseable as
  `QuasiIso (cechFreeComplexAug 𝒰)`.
- **Did NOT build** `cechFreeComplex_quasiIso` (the ~250–450 LOC sectionwise contracting homotopy +
  objectwise-homology reduction). Building blocks all verified present (`evaluation.PreservesHomology`
  by `inferInstance`). DEAD END recorded: do NOT route through `ExtraDegeneracy`.

### Lane 2 — `CechBridge.lean` hom-identification core (+5 decls, axiom-clean)
Built the entire **mathematical core** of the hom-identification: `homCechCosimplicial`
(`.rightOp ⋙ preadditiveYoneda.obj F`, making the differential literally `∑(-1)ⁱHom(faceᵢ,F)`),
`homCechSectionIsoApp` (per-degree iso via `opCoproductIsoProduct` + `piComparison` +
`freeYonedaHomAddEquiv`), and the projection-characterisation + naturality lemmas.
- **Did NOT build** `cechComplex_hom_identification` — held back **operationally, not mathematically**:
  the imported FreePresheafComplex.lean was broken for most of the session, denying live goal states
  for a 15-step `erw`/term-mode-sensitive naturality proof. Full assembly recipe is recorded in the
  task result. Now unblocked (FreePresheafComplex compiles).
- Learning: `∏ᶜ` projections / `op` compositions / `Functor.map` are defeq-but-not-syntactic — use
  `erw` for projection lemmas and term-mode `exact`/`congrArg` for functor-map combines.

### Lane 4 — `HigherDirectImagePresheaf.lean` 01XJ engine (NEW file, +6 decls, axiom-clean)
- Built `PresheafOfModules.homologyIsoSheafify` — the **reusable Stacks-01XJ engine** ("cohomology
  sheaf = sheafify of objectwise cohomology", general over any `HasSheafify` site), plus the
  resolution form `higherDirectImage_iso_sheafify_presheafHomology`:
  `Rⁿ f_* G ≅ sheafify(V ↦ Hⁿ((f_* I^•)(V)))`.
- **Did NOT build** the named absolute-cohomology-presheaf target — it needs a standalone
  module-valued `Hⁿ(open,F)` object (Decision-1 fork, "zero lemmas", deliberately avoided). Resolves
  to a **planner re-sign** to the resolution form (mirroring Q4).

## Key findings / patterns
- **Defeq-not-syntactic is the recurring tactical theme this iter** (in 3 of 4 lanes): `.X n` vs
  `.obj (op [n])` (FreePresheafComplex), `∏ᶜ`/`op`/`Functor.map` (CechBridge), `sc`/`mapHomologicalComplex`
  (HigherDirectImagePresheaf). Idioms that worked: fresh-elaborated standalone `have`; `erw` for
  projection lemmas; term-mode `exact`/`congrArg` for functor-map combines; lifting an SC-level iso
  to HC-level along a defeq.
- **"Named target not built" was the dominant outcome but it does NOT mean churn**: each lane built
  axiom-clean sub-infrastructure that strictly shrinks the residual and rephrases the target. See
  recommendations for the closest-to-completion ordering.

## Subagent reports (full reports linked, not duplicated)
- `lean-auditor iter018` — 0 must-fix, 5 major, 5 minor. Headline: HigherDirectImagePresheaf.lean is
  **orphaned** (not imported by root), and 4 stale planning comments in AcyclicResolution.lean /
  CechHigherDirectImage.lean describe ALREADY-PROVED decls as open (misleading future provers).
  → `task_results/lean-auditor-iter018.md`.
- `lvb-checker` ×4 — all four files: Lean is axiom-clean and faithful; the gaps are **blueprint-side**
  (coverage debt + under-specified proof sketches for the new infra) + the design-fork stale `\lean{}`
  hint on `lem:higher_direct_image_presheaf`. The two "must-fix" entries on CechAcyclic are both the
  pre-known superseded-sorry / not-yet-built-section-target state, not new defects.
  → `task_results/lean-vs-blueprint-checker-{CechAcyclic,FreePresheafComplex,CechBridge,HigherDirectImagePresheaf}.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:higher_direct_image_presheaf`: added `% NOTE`
  documenting the design fork — the `\lean{}` target `higherDirectImage_isSheafify_presheafCohomology`
  does not exist; the resolution form `higherDirectImage_iso_sheafify_presheafHomology` + engine
  `homologyIsoSheafify` were built instead; planner re-sign pending.
- No `\mathlibok` added (no new decl is a pure Mathlib re-export). No `\leanok` touched. No stale
  `\notready` found.

## Blueprint-doctor (structural)
- **Broken cross-ref**: `\uses{AlgebraicGeometry.CombinatorialCech.depDiff_exact}` in
  `Cohomology_CechHigherDirectImage.tex` points at a raw Lean name with no matching `\label` — draws a
  missing dependency edge. Flagged to the planner (a `\uses` should reference a blueprint label, or a
  matching anchor/label must be added). Not a review-agent fix (structural `\uses`, plan domain).

## Notes
- Sync_leanok ran for this tree (`iter: 18`, +1/−2, `Cohomology_CechHigherDirectImage.tex`) — any
  remaining `\leanok` is the deterministic verdict.
- Coverage debt: `archon dag-query unmatched` = **44** uncovered Lean decls (listed in
  `recommendations.md` for the planner to bundle).
