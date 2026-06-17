# Blueprint Review Report

## Slug
iter052

## Iteration
052

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_augmented_resolution` — Step 4 (augmentation node): proof says "the same spanning-family argument that gives exactness in positive degrees produces exactness at the augmentation node" without naming the specific lemma providing p = 0 exactness of the local augmented section complex. Neither `lem:affine_cech_vanishing_tilde_subcover` nor `lem:cech_acyclic_affine` explicitly states degree-0 (augmentation injection) exactness; the contracting homotopy in `lem:cech_acyclic_affine`'s underlying `combHomotopy` does cover it, but the proof sketch does not name the lemma the prover should reach for. A prover will need to recognize this refers to the full (augmented) complex exactness from the contracting-homotopy core. Suggest adding a sentence: "Specifically, `lem:cech_acyclic_affine`'s `combDifferential_exact` gives the full augmented-complex exactness locally, covering p = 0 as well."

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:cech_augmented_resolution` / Step 4 proof prose — augmentation-node argument is mathematically correct (the contracting homotopy works at all degrees) but does not name the specific lemma; informational; see "Proofs lacking detail" above.
  - `def:cohomology_sheaf_is_sheafify_homology` — block is a `\begin{lemma}` environment but carries a `def:`-prefix label; no functional or rendering impact (leandag and blueprint-doctor both clean), but the naming inconsistency is mildly confusing. Low-priority writer cleanup.
  - `lem:cech_augmented_resolution` statement `\uses{}` includes `lem:cech_acyclic_affine` — this is a legacy/transitive reference from the old stalk-at-prime framing; the actual proof `\uses` correctly lists `lem:affine_cech_vanishing_tilde_subcover`. Not a wrong edge (the transitive dependency is real), but no longer a direct proof input. Informational.
  - `lem:affine_cech_vanishing_tilde_subcover` statement `\uses{}` does not list `lem:section_cech_module_exact_of_localizationAway` or `lem:isLocalizedModule_comp_away`; the proof `\uses{}` does include both. DAG edges are present and correct; the statement-level omission is cosmetically non-ideal but not a graph gap.

## Detailed focus: HARD GATE targets for iter-052

### `lem:cech_augmented_resolution` — sections/sheafification route

**Route completeness** (Step-by-step against directive checklist):

1. **Reflect through faithful `toSheaf`** — Step 1 invokes the faithful additive forgetful functor from `X.Modules` to abelian sheaves. "A faithful additive functor reflects zero objects" is correct: if F(H^p) = 0 then H^p = 0. Sound and complete.

2. **homology sheaf = sheafification of presheaf homology via `homologyIsoSheafify`** — Step 2 cites `def:cohomology_sheaf_is_sheafify_homology` (`\lean{PresheafOfModules.homologyIsoSheafify, ...}`). Those declarations exist in `HigherDirectImagePresheaf.lean` and are axiom-clean. The argument is correct: sheafification is exact as a left adjoint (preserving all colimits and finite limits), hence commutes with homology. Sound and complete.

3. **Presheaf homology locally zero on affine basis** — Step 3 correctly identifies that for any basic affine D(g) ⊂ U_i (a basis element), F|_{D(g)} ≅ M~ by `lem:qcoh_isIso_fromTildeGamma` (Route-B 01I8 result, proved, axiom-clean), and the section Čech complex of M~ over the induced standard subcover of D(g) is exact in positive degrees by `lem:affine_cech_vanishing_tilde_subcover`. The "locally bijective W-equivalence kills it" language is correct: a map of sheaves that is locally an isomorphism (the 0 → presheaf-homology map is locally an iso on each basic affine) sheafifies to an isomorphism. Sound and complete.

4. **Augmentation node** — Step 4 says "the same spanning-family argument produces exactness at the augmentation node" without naming a lemma. The math is correct (the degree-0 augmentation M → ∏_i M_{g_i} is the injectivity map, and the contracting homotopy covers it), but the proof sketch leaves the prover to identify which declaration to use. This is the sole "lacking detail" finding; see above. Not a blocking error.

**`\uses{}` accuracy** — `leandag build --json` reports `"unknown_uses": []`. All five proof-level `\uses{}` entries (`def:cech_augmented_complex`, `lem:section_cech_homology_exact`, `lem:affine_cech_vanishing_tilde_subcover`, `def:cohomology_sheaf_is_sheafify_homology`, `lem:qcoh_isIso_fromTildeGamma`) are valid resolvable labels. `\lean{AlgebraicGeometry.cechAugmented_exact}` is correctly unmatched (not yet formalized; this is the prover target). HARD GATE passes.

### New coverage-debt blocks

**`lem:isLocalizedModule_comp_away`** (line 6189):
- `\lean{AlgebraicGeometry.AwayComparison.isLocalizedModule_comp_away}` — exists at `CechAcyclic.lean:875` inside `namespace AlgebraicGeometry` → `namespace AwayComparison`. Namespace matches ✓.
- Statement: "the composite g ∘ mk_f : M → N exhibits N as the localisation of M at powers of a, given a lies in the radical of (f)." Well-formed. Proof sketch (verify the three clauses: units invertible, surjectivity via a^{jl} = (fh)^l, cancellation) is sound and formalizer-ready.
- `\uses{}` is empty — correct for a leaf lemma; nothing lists this as a transitive dependency that would require an explicit edge. All consumed by proof `\uses{}` of `lem:section_cech_module_exact_of_localizationAway`. ✓

**`lem:section_cech_module_exact_of_localizationAway`** (line 6217):
- `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact_of_localizationAway}` — exists at `CechAcyclic.lean:1217` inside `namespace AlgebraicGeometry` → `namespace SectionCechModule`. Namespace matches ✓.
- Statement: "if each s_i lies in radical(f) and {s_i/1} span the unit ideal of R_f, then D^•(s, M) is exact in every positive degree." Well-formed.
- `\uses{lem:section_cech_module_exact, lem:isLocalizedModule_comp_away}` — both valid ✓.
- Proof sketch (run computation over R_f via `lem:section_cech_module_exact`, transport back via degreewise `M_{s_σ} ≅ (M_f)_{s_σ}` from `lem:isLocalizedModule_comp_away`) is complete and formalizer-ready. ✓

### 02KG top blocks

**`lem:affine_cech_vanishing_qcoh`** (line 6056):
- Discharge path: Step 1 uses `lem:qcoh_iso_tilde_sections` (F ≅ M~ for M = Γ(X,F)) + `lem:cechCohomology_isZero_of_iso` (transport); Step 2 uses `lem:affine_cech_vanishing_tilde_subcover` (the residual now proved). Correctly described, all named lemmas exist.
- `% NOTE` correctly records that `affine_cech_vanishing_qcoh` is aspirational and `affine_cech_vanishing_qcoh_of_tildeVanishing` is the current Lean declaration. `leandag` confirms the aspirational form is in `unmatched_lean` (expected). ✓

**`lem:affine_serre_vanishing`** (line 3208):
- Discharge path: assemble `def:affine_cover_system`, feed `lem:affine_cech_vanishing_qcoh` as condition (3) into `lem:cech_to_cohomology_on_basis`. Correctly described.
- `% NOTE` correctly records the reduced form. `lem:affine_serre_vanishing` in `unmatched_lean` (expected). ✓

**`lem:affine_cech_vanishing_tilde_subcover`** (line 6247):
- Change-of-ring step detail: (a) each g_i ∈ √(f) from D(g_i) ⊆ D(f); (b) images span unit ideal of R_f via `lem:affine_cover_span_localizationAway`; (c) apply `lem:section_cech_module_exact_of_localizationAway`; (d) use tilde-bridge from `lem:section_cech_homology_exact` to wrap as Čech homology vanishing. All four steps named, all lemmas exist and are proved. **Adequately detailed for a prover.** ✓
- Lean targets `sectionCech_homology_exact_of_localizationAway` (theorem at `CechAcyclic.lean:1868`) and `sectionCechAbExact_loc` (private lemma at `CechAcyclic.lean:1802`) both exist in the correct namespace. ✓

## Dependency & isolation findings

- Only isolated node: `lean_aux` (unnamed Lean helper with no blueprint entry, 0 blueprint nodes isolated). **keep** — an uncovered Lean helper; no blueprint action needed.
- `leandag build --json`: `unknown_uses: []`, no conflicts.
- `archon blueprint-doctor --json`: `broken_refs: []`, `malformed_refs: []`, `covers_problems: []`, `orphan_chapters: []`.

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix findings.

**Informational only:**
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_augmented_resolution` Step 4: proof sketch doesn't name the lemma for local augmentation-node exactness; "same spanning-family argument" works mathematically but requires prover to identify `combDifferential_exact` as the vehicle.
- `Cohomology_CechHigherDirectImage.tex` / `def:cohomology_sheaf_is_sheafify_homology`: `def:` label on a `\begin{lemma}` block. Cosmetic only.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_augmented_resolution` statement `\uses{lem:cech_acyclic_affine}`: transitive/legacy reference; proof `\uses` has the correct direct dependencies.

Overall verdict: Both prover lanes (`AffineSerreVanishing.lean` and `CechHigherDirectImage.lean`) clear the HARD GATE — the consolidated chapter `Cohomology_CechHigherDirectImage.tex` is complete and correct with no must-fix findings, and all strategy phases have adequate blueprint coverage.
