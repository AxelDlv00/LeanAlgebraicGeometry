# Blueprint Review Report

## Slug
iter050

## Iteration
050

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_augmented_resolution` proof block: the proof prose at line ~7040 cites `\ref{lem:qcoh_isIso_fromTildeGamma}` explicitly ("By the affine tilde isomorphism (Lemmas~\ref{lem:qcoh_iso_tilde_sections} and \ref{lem:qcoh_isIso_fromTildeGamma})...") but the proof `\uses{}` at line ~7030 lists only `def:cech_nerve, lem:cech_acyclic_affine, lem:qcoh_iso_tilde_sections` — `lem:qcoh_isIso_fromTildeGamma` is absent. **wire-up** — add `lem:qcoh_isIso_fromTildeGamma` to the proof `\uses{}`. Not a must-fix (the dependency is already proven and captured transitively through `lem:qcoh_iso_tilde_sections`'s own DAG, so no out-of-order prover dispatch risk); classified **soon**.

- One isolated node in `leandag show isolated`: a single `lean_aux` node (`lean:Alg…`) with `isolated_blueprint: 0`. This is an uncovered Lean helper, not a blueprint node. **keep** (informational — no blueprint entry obligation until the prover surfaces it as a named API point).

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Route-A block deletions — no dangling refs.** `leandag build --json` reports `unknown_uses: []`. The deleted route-A blocks `lem:tilde_section_changeOfBase` and `lem:section_cech_changeOfBase_iso` leave zero lingering `\uses{}` references. The writer's claim of `unknown_uses: 0` is confirmed.
  - **`lem:affine_cech_vanishing_tilde_subcover` (CechAcyclic.lean PROVER TARGET) — complete + correct.** Statement well-formed: `R`, `M`, `f ∈ R`, `g : {1,...,n} → R` with `D(f) = ⊔_i D(g_i)`, `p > 0` ⟹ `Ȟ^p({D(g_i)}, ~M) = 0`. `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway}` correctly identifies the new public theorem to build in `CechAcyclic.lean`. Proof sketch (route-B argument) evaluated:
    - *Step 1 (R_f-side exact):* Instantiate `SectionCechModule.dDiff_exact` (= `lem:section_cech_module_exact`, `\leanok`) over `R_f = Localization.Away f`, module `M_f`, family `g/1 : ι → R_f`. This family spans the unit ideal of `R_f` by `lem:affine_cover_span_localizationAway` (proved: `D(f) = ⊔_i D(g_i)` pulls back to `Spec R_f` as `⊔_i D(g_i/1) = Spec R_f`). Spanning hypothesis met ⟹ `D_{R_f}^•` is exact in positive degrees. **Correct** — `dDiff_exact` is polymorphic in the base ring (no whole-space spanning required; only over the ring it is invoked on).
    - *Step 2 (degreewise AddEquiv ladder):* For each multi-index tuple σ: `D(g_σ) ⊆ D(f)` ⟹ `g_σ ∈ √(f)` ⟹ `f` is invertible in `M_{g_σ}`. Transitivity `lem:away_comparison_isLocalizedModule` (`AlgebraicGeometry.AwayComparison.comparison_isLocalizedModule`, already in `CechAcyclic.lean` line ~608) gives `M_{g_σ} ≅ (M_f)_{g_σ}`. These per-tuple AddEquivs form a ladder between the R-side and R_f-side complexes, commuting with the alternating-sum differentials (naturality of the comparison maps in the localisation base). Exactness transfers across the ladder. **Correct** — the invertibility witness `g_σ ∈ √(f)` is standard topology (`V(g_σ) ⊆ V(f)` iff `g_σ ∈ √(f)`); the naturality square is exactly `lem:away_comparison_isLocalizedModule`'s naturality claim.
    - *Step 3 (exactness → IsZero homology):* Wrap function exactness of the R-side complex into `IsZero(Ȟ^p) = 0` for `p > 0` via the homology reduction in the spirit of `lem:section_cech_homology_exact`. **Correct** — the direction "positive-degree function exactness ⟹ IsZero(homology)" is a general algebraic fact; the proof sketch correctly identifies this as the closing wrap.
  - **`\uses{}` of `lem:affine_cech_vanishing_tilde_subcover` — all resolve.** `lem:section_cech_module_exact` (`\leanok`), `lem:section_cech_homology_exact` (proven infrastructure), `lem:affine_cover_span_localizationAway` (new project-local lemma, blueprinted below), `lem:away_comparison_isLocalizedModule` (in `CechAcyclic.lean`, line ~608, confirmed via grep), `def:cech_cohomology_accessor` (`\leanok`). All valid.
  - **`lem:affine_cech_vanishing_qcoh` proof — correct.** Step 1 (reduction to tilde via `lem:qcoh_iso_tilde_sections` + transport `lem:cechCohomology_isZero_of_iso`) + Step 2 (subcover tilde residual = `lem:affine_cech_vanishing_tilde_subcover`). The argument that a *proper* `D(f)` subcover does not satisfy `span{g_i} = R` and therefore requires the change-of-base strategy is mathematically correct and clearly stated.
  - **`lem:cechCohomology_isZero_of_iso` — complete + correct.** New transport lemma: `e : F ≅ G` + `Ȟ^p(U,F)=0` ⟹ `Ȟ^p(U,G)=0`. Proof: section Čech complex is functorial (`def:section_cech_functoriality`), so `e` induces an iso of complexes ⟹ iso of homologies ⟹ zero. `\uses{def:cech_cohomology_accessor, def:section_cech_functoriality}` both present.
  - **`lem:iSup_basicOpen_eq_top_iff_span` (`\mathlibok` anchor) — verified valid.** `\lean{PrimeSpectrum.iSup_basicOpen_eq_top_iff}`. Declaration confirmed to exist in Mathlib: used at `AffineSerreVanishing.lean:407` and `QcohTildeSections.lean:181,1375` in the project. Statement ("⊔_i D(s_i) = Spec R iff span{s_i} = R") matches standard Mathlib content. No faithfulness issue.
  - **`lem:affine_cover_span_localizationAway` — complete + correct.** Statement: images `g_i/1` span the unit ideal of `R_f` given `D(f) = ⊔_i D(g_i)`. Proof: pull the open-cover equality back along `Spec(R_f) ≅ D(f) ↪ Spec R` (the comap of `algebraMap R R_f`); comap commutes with D(-) and ⊔; pullback of `D(f)` is all of `Spec R_f` (since `f` is a unit in `R_f`); so `⊔_i D(g_i/1) = Spec R_f`; apply `lem:iSup_basicOpen_eq_top_iff_span`. **Correct** and self-contained.
  - **`lem:away_comparison_isLocalizedModule` — complete + correct.** Statement: `M_a[1/b] = M_{ab}` via the canonical transitivity comparison. Already a project declaration (`CechAcyclic.lean` line ~608 `AwayComparison.comparison_isLocalizedModule`). The blueprint block's derivation note ("when `g_σ ∈ √(f)`, localising `M` away from `g_σ` and localising `M_f` away from `g_σ` present the same module") is correct.
  - **`lem:cech_augmented_resolution` (CechHigherDirectImage.lean PROVER TARGET) — complete + correct.** Statement: the augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` is exact (a resolution of F in QCoh(X)). `\lean{AlgebraicGeometry.cechAugmented_exact}`. Proof sketch:
    - Exactness of a sheaf complex is a local (stalk-wise) condition ✓
    - On each affine `U = Spec A`, `F|_U ≅ ~M` via `qcoh_iso_tilde_sections` (unconditional, `\leanok`) ✓
    - At each prime `𝔭 ∈ Spec A`: some `f_i ∉ 𝔭` (since `{f_i}` cover); the standard prepend-`i_fix` contracting homotopy `h(s)_{i₀...i_p} = s_{i_fix i₀...i_p}` witnesses `dh + hd = id` on the localized extended complex ✓ (this is exactly `lem:cech_acyclic_affine` / `SectionCechModule.depDiff_exact` applied locally)
    - Stalk-exactness at every prime ⟹ exactness on X ✓
  - **`\uses{}` of `lem:cech_augmented_resolution` — all resolve.** `def:cech_nerve` (`\leanok`), `lem:cech_acyclic_affine` (`\leanok`, supplies the homotopy), `lem:qcoh_iso_tilde_sections` (`\leanok`, unconditional as of iter-048). No broken edges. Minor **soon** finding: the proof text also cites `lem:qcoh_isIso_fromTildeGamma` but it is absent from the proof `\uses{}` (see Dependency & isolation findings above).
  - **`lem:affine_serre_vanishing` `\uses{}`** includes `lem:affine_cech_vanishing_tilde_subcover` (line 3212) — this is correct per the dependency chain: the unconditional Serre vanishing is only available once the tilde subcover residual is closed. No issue.
  - **Rendering integrity**: `archon blueprint-doctor --json` reports `malformed_refs: []`, no orphan chapters, no broken `\ref`/`\uses`, no undefined macros, no math-delim issues.

## Severity summary

**must-fix-this-iter**: 0

**soon** (1 item):
- `Cohomology_CechHigherDirectImage.tex` / proof of `lem:cech_augmented_resolution` (~line 7030): the proof `\uses{}` is missing `lem:qcoh_isIso_fromTildeGamma` even though the proof text cites it. **wire-up** — add `\uses{lem:qcoh_isIso_fromTildeGamma}` to the proof block. Not a dispatch blocker (the dependency is already proven and captured transitively).

**informational** (1 item):
- One isolated `lean_aux` node (`lean:Alg…`). No blueprint entry obligation; appears to be an uncovered Lean helper. Keep.

Overall verdict: HARD GATE CLEARS for both prover lanes — `Cohomology_CechHigherDirectImage.tex` is complete + correct with 0 must-fix findings; route-A deletions left no dangling `\uses{}`; `lem:affine_cech_vanishing_tilde_subcover` (CechAcyclic.lean) and `lem:cech_augmented_resolution` (CechHigherDirectImage.lean) both have complete, correct, and sufficient proof sketches for prover dispatch; all active `\mathlibok` claims verified.
