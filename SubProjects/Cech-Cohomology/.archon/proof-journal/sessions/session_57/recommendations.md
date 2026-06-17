# Recommendations for the next plan iteration (post iter-057)

## MUST-FIX (blocks downstream work — address before / alongside any prover re-dispatch)

### 1. Re-sign CSI Stubs 5/6 to the augmented complex `D'_aug` (refactor, NOT prover)
`CechSectionIdentification.lean:424` (`cechSection_complex_iso`, `D ≅ D'`) and `:481`
(`cechSection_contractible`, `Homotopy (𝟙 D') 0`) carry `sorry` on signatures the prover already
**disproved in iter-056** (non-augmented `D'` has `H⁰ = Γ(V,F) ≠ 0`; `D ≅ D'` is false). The blueprint
was corrected to the augmented `D'_aug := (sectionCechComplex U'·).augment ε hε` in iter-057, but the
**`.lean` signatures were never re-signed** — so the file now carries two provably-unfillable holes plus
a `⚠ PROVER FINDING` excuse-comment block (lines 333–366). Flagged independently by lean-auditor
(must-fix) and lvb-csi (2 must-fix). **Action:** dispatch a `refactor` to re-sign both declarations to
the augmented target (matching the corrected blueprint) and remove the excuse-comment block; only THEN
is a prover dispatch on Stubs 5/6 meaningful. These feed `CechAugmentedResolution.lean:229` — they are
on the critical path for that lane.

## HIGH — closest-to-completion, dispatch next

### 2. Close Need #2 end-to-end (~10 LOC, AffineSerreVanishing.lean)
The `htilde` seed is DONE (`sectionCech_homology_exact_of_affineOpen`, axiom-clean). Add the private
`affine_tildeVanishing_general` mirroring `affine_tildeVanishing`, swapping `_of_localizationAway →
_of_affineOpen` and hypothesis `hcov : D(f) = ⨆ D(gᵢ)` → `IsAffineOpen (⨆ D(gᵢ))`; then
`affine_cech_vanishing_qcoh_general` and `affine_serre_vanishing_general` follow unconditionally. This
closes the dominant residual of the open-immersion-acyclicity route's *vanishing* half. HARD GATE: the
seed block `lem:affine_cech_vanishing_general_seed` is `complete:true/correct:true` — clear to dispatch.

## MEDIUM

### 3. Blueprint coverage debt — 12 new lean_aux nodes (blueprint-writer)
`archon dag-query unmatched` lists 12 new uncovered Lean decls (+ pre-existing dead `CechAcyclic.affine`).
Group for a writer pass on `Cohomology_CechHigherDirectImage.tex`:
- **CechAcyclic route-B1 chain (lvb-cechacyclic MAJOR — asymmetry vs route-B):**
  `isLocalizedModule_baseChange_away` (relies on `Mathlib.RingTheory.Localization.BaseChange`
  `isLocalizedModule_iff_isBaseChange`, `IsBaseChange.comp`, `TensorProduct.isBaseChange`);
  `SectionCechModule.dDiff_exact_of_affineCover` (relies on `isLocalizedModule_baseChange_away`,
  `SectionCechModule.dDiff_exact`, `IsLocalizedModule.iso`, `Function.Exact.of_ladder_addEquiv_of_exact`);
  `sectionCech_homology_exact_of_affineCover` (relies on `sectionCechAbExact_affine` +
  `sectionCech_isZero_homology_of_objD_exact`). Privates `basicOpen_algMap_section`,
  `sectionCechAbExact_affine` can be bundled into a related decl's `\lean{}`.
- **CSI Stub-1 leaf (lvb-csi MAJOR):** `coverArrowOverSigmaIso` (+ helpers `coverArrowOverCofan`,
  `coverArrowOverIsColimit`) — cover arrow is the coproduct of member arrows in `Over X`; suggest
  `lem:coverArrow_over_sigma` under `lem:coproduct_distrib_fibrePower`. (`mem_iInf_opens_of_finite` is
  private, no block needed.)
- **OpenImm Need-1 chain:** `Scheme.Modules.pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`,
  `Scheme.Modules.pushforwardExtAddEquiv` — bundle into `lem:modules_isoSpec_ext_transport`'s `\lean{}` or
  give standalone blocks.

### 4. Blueprint correctness fixes (blueprint-writer, then re-review for HARD GATE)
From lvb-openimm (3 major adequacy failures) + lvb-cechacyclic:
- `lem:modules_isoSpec_ext_transport` **proof body** still describes the absent `Ext.mapExactFunctor`
  composition as the mechanism — rewrite to `mapExt_bijective_of_preservesInjectiveObjects` +
  `AddEquiv.ofBijective` + the `[EnoughInjectives]` source-category requirement. (Statement-block NOTE
  already corrected this review; the proof body still misleads.)
- The same block's proof falsely claims the transport establishes jShriekOU naturality — it is an OPEN
  residual. Add a **standalone blueprint block** for the jShriekOU-naturality-under-scheme-iso gap
  (`Φ(jShriekOU V) ≅ jShriekOU (φ ''ᵁ V)`) so the dag tracks it as the named open hole it is.
- The seed block's `\uses{}` wrongly lists `lem:isoSpec_scheme_mathlib` (route-B1 is purely algebraic,
  `Scheme.isoSpec` is not used) — drop it. Optionally document the `Algebra Γ(V) Γ(D a)`
  non-synthesizability trap in the proof prose.

### 5. Dedup `isZero_of_faithful_preservesZeroMorphisms` (refactor, LOW-MEDIUM)
lean-auditor MAJOR: this helper is duplicated between `OpenImmersionPushforward.lean` and
`CechAugmentedResolution.lean`. Hoist to a shared upstream home (both already import the cohomology core).

## Promising / scoped builds (multi-cycle — do NOT expect one-shot)

### 6. `coproduct_distrib_fibrePower` (CSI Stub 1, ~120–200 LOC, 2–3 cycles)
Product distributes over coproduct in `Over X`: `∏_{k:Fin(p+1)}(∐ᵢAᵢ) ≅ ∐_{σ}∏_k A_{σk}`. Route
(analogist `stub1-scheme-coproduct`): induction on `p`, each step
`CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_map` (binary distributivity) + `Limits.sigmaSigmaIso`
to collapse `∐ᵢ∐ⱼ → ∐_{(i,j)}` and reindex to `σ`. `Scheme` IS `FinitaryPreExtensive`
(`instFinitaryExtensiveScheme`) + `HasPullbacks`. Once it lands, the two mechanical bridges
(`widePullback_overX_eq_prod` ~30–50 LOC; per-σ `widePullback_openImm_inter` already DONE) assemble Stub 1.

### 7. jShriekOU naturality under a scheme iso (OpenImm `_acyclic`, multi-iter)
The deepest remaining piece of Need #1 — see #4. Commute `pushforward φ.hom` with the
free/sheafification adjunction + relate `yoneda.obj V` across the homeomorphism. Do NOT treat as
near-rfl (the prover's own note flags it as the dominant wall). Smaller companions documented for the
consumer: image-open affineness (one-liner, inline), quasi-coherence preservation under `pushforward φ.hom`
(MEDIUM, no off-the-shelf instance).

## Do-NOT-retry / blocked
- **CSI Stubs 5/6 as written** (non-augmented `D'`): provably false — do not re-dispatch a prover until
  #1 (re-sign to `D'_aug`) lands.
- **`CechAcyclic.affine` (line 110):** dead/superseded stub, out of scope (route reparametrised to the
  cover-agnostic `injective_cech_acyclic` per Knowledge Base). Leave untouched.
- **`Ext.mapExactFunctor` functor-composition route for Need #1:** confirmed absent from Mathlib; the
  built route is `mapExt_bijective_of_preservesInjectiveObjects`. Do not re-explore the composition lemma.

## Reusable patterns discovered this iter
- **Base-change composite localization:** `M → M⊗_R S → (M⊗_R S)_f` is `IsLocalizedModule (powers a)`
  over `R` via `IsBaseChange.comp (TensorProduct.isBaseChange R M S) hg` + `isLocalizedModule_iff_isBaseChange`
  (both directions). No `IsScalarTower` diamond for `LocalizedModule` carriers.
- **Ext-iso across a category equivalence:** `mapExt_bijective_of_preservesInjectiveObjects` +
  `AddEquiv.ofBijective` — the canonical vehicle when `Ext.mapExactFunctor` composition is needed but
  absent. Needs `[EnoughInjectives]` on the SOURCE category + a local `HasExt` instance.
- **Section-restriction `Algebra Γ(V) Γ(D a)` is NOT synthesizable** — `letI` the
  `((Spec R).presheaf.map (homOfLE _).op).hom.toAlgebra` that `isLocalization_of_eq_basicOpen` builds,
  + `IsScalarTower … := IsScalarTower.of_algebraMap_eq (fun _ => rfl)`.
- **Coproduct in `Over X`:** build `mkCofanColimit` directly (`desc = Over.homMk (Sigma.desc (t.inj i).left)`);
  do NOT use `isColimitOfReflects (Over.forget X) …` (mapCocone is not syntactically the sigma cofan).
- **TOOLING:** in instance-resolution-sensitive files (CechAcyclic), `lean_run_code`/`lean_multi_attempt`
  can use a STALE `.olean` and report FALSE success — trust only `lake env lean`/`lake build`/
  `lean_diagnostic_messages`.
