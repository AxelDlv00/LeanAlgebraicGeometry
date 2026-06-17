# Blueprint Reviewer Report — iter-035

**Audit scope**: All chapters in `blueprint/src/chapters/*.tex`  
**High-stakes focus**: `Cohomology_FlatBaseChange.tex` (conj chain), `Picard_QuotScheme.tex` (keystone D), `Picard_GrassmannianCells.tex` (properness keystone)  
**leandag status**: `unknown_uses: []` (no broken `\uses{}` edges); 5 isolated nodes (1 blueprint lemma + 4 lean_aux)

---

## Hard-Gate Verdicts

| Chapter | Complete | Correct | Must-fix | Gate |
|---------|----------|---------|----------|------|
| `Cohomology_FlatBaseChange.tex` | ✓ | ✓ | 0 | **PASS** |
| `Picard_QuotScheme.tex` | ✓ | ✓ | 0 | **PASS** |
| `Picard_GrassmannianCells.tex` | ✓ | ✓ | 0 | **PASS** |

All three chapters may enter this iter's prover objectives.

---

## Per-Chapter Audit

### `Cohomology_FlatBaseChange.tex`

#### Completeness

The chapter is complete through the main theorem. Declaration inventory:

| Block | `\leanok` | Notes |
|-------|-----------|-------|
| Affine infra (tilde dicts, pullbackSpecIso, etc.) | ✓ | All closed |
| `lem:base_change_mate_fstar_reindex_legs` (thin wrapper) | statement ✓ | Proof open (prover's target) |
| `lem:conjugateEquiv_comp_mathlib` | `\mathlibok` | `CategoryTheory.conjugateEquiv_comp` — correctly declared |
| `lem:conjugateEquiv_symm_comp_mathlib` | `\mathlibok` | `CategoryTheory.conjugateEquiv_symm_comp` — correctly declared |
| conj-1a `lem:base_change_mate_codomain_read_legs_conj` | ✗ | Prover builds |
| conj-1b `lem:base_change_mate_codomain_read_legs_conj_eq` | ✗ | Prover builds |
| conj-2b `lem:base_change_mate_reindex_conj_pullbackLeg` | ✗ | Prover builds |
| conj-2c `lem:base_change_mate_reindex_conj_pushforwardCollapse` | ✗ | Prover builds |
| conj-2d `lem:base_change_mate_reindex_conj_crossLayer` | ✗ | Prover builds |
| conj-2a `lem:base_change_mate_fstar_reindex_legs_conj` | ✗ | Prover builds |
| conj-0 blocks (`pullbackComp_inv_eq_leftAdjointCompIso_inv`, `pullbackComp_eq_leftAdjointCompIso`) | ✗ | Pre-sync; Lean landed (per memory) |
| FBC-B subsection (`def:fbcb_*`, `lem:fbcb_*`) | ✗ | Pre-sync; back already-landed Lean |
| `thm:flat_base_change_pushforward` | ✓ | Closed |

#### Conjugate-Chain Correctness Check

Each sub-lemma is a single, well-formed mathematical claim:

**conj-1a** (`lem:base_change_mate_codomain_read_legs_conj`): Codomain read Θ_tgt♯ rebuilt natively using `leftAdjointCompIso` instead of `pullbackComp`.
- `\uses{pullbackComp_eq_leftAdjointCompIso, leftAdjointCompIso_mathlib, conjugateEquiv_leftAdjointCompIso_inv_mathlib, pullback_spec_tilde_iso, pushforward_spec_tilde_iso}` — all present in the DAG ✓
- Proof: copy the concrete codomain-read assembly, substitute the `pullbackComp_eq_leftAdjointCompIso` identity ✓

**conj-1b** (`lem:base_change_mate_codomain_read_legs_conj_eq`): Θ_tgt♯ = Θ_tgt♭ = Θ_tgt at projection legs.
- `\uses{codomain_read_legs_conj, codomain_read_legs, codomain_read}` — accurate ✓
- Proof: only difference is pullbackComp vs leftAdjointCompIso, equal by conj-0' ✓

**conj-2b** (`lem:base_change_mate_reindex_conj_pullbackLeg`): Pullback-side leg identified as pushforward coherence after conj⁻¹.
- `\uses{conjugateEquiv_pullbackComp_inv_mathlib, conjugateEquiv_leftAdjointCompIso_inv_mathlib, pullbackComp_eq_leftAdjointCompIso}` — accurate ✓

**conj-2c** (`lem:base_change_mate_reindex_conj_pushforwardCollapse`): The three pushforward coherences (`pushforwardComp_hom`, `pushforwardComp_inv`, `pushforwardCongr_hom`) all map to identity under Γ, dropping out.
- `\uses{gammaMap_pushforwardComp_hom_eq_id, gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom}` — accurate ✓

**conj-2d** (`lem:base_change_mate_reindex_conj_crossLayer`): The surviving (Spec ι_A)-unit transports across the pushforward Γ-comparison γ_ψ via `unit_conjugateEquiv_symm_mathlib` + `conjugateEquiv_comp_mathlib` (Seam 1 raised one layer), giving the inner value ρ.
- `\uses{base_change_mate_unit_value, unit_conjugateEquiv_symm_mathlib, conjugateEquiv_comp_mathlib, gammaPushforwardIso}` — accurate ✓

**conj-2a** (`lem:base_change_mate_fstar_reindex_legs_conj`): Assembles conj-2b/2c/2d under conj⁻¹ injectivity to get θ_in = ρ against Θ_tgt♯.
- Statement `\uses` includes `lem:iterated_mateEquiv_conjugateEquiv_mathlib`, `def:base_change_mate_inner_value`; proof `\uses` block omits these two. **Minor**: the proof `\uses` block should include these for blueprint completeness, but it doesn't affect the DAG (they appear in the statement).
- Chain composition: conj-2b + conj-2c + conj-2d close the three legs; reassoc handled by `conjugateEquiv_comp_mathlib` / `conjugateEquiv_symm_comp_mathlib` simp set ✓

**Thin wrapper** (`lem:base_change_mate_fstar_reindex_legs`): Uses conj-2a + conj-1b to instantiate the reindex at explicit composite legs and bridge to the concrete codomain read.
- `\uses{conj, codomain_read_legs_conj_eq, codomain_read_legs, inner_value}` — accurate ✓

**Chain composition soundness**: conj-1a→1b (builds and bridges the conjugate-native codomain read); conj-2b/2c/2d→2a (three atoms feed the assembled conjugate identity); conj-2a + conj-1b → thin wrapper (wrapper is genuinely a one-two-line application). The composition is sound. ✓

**FBC-B subsection** (`lem:fbcb_gammaTopEquivEqLocus`, `lem:fbcb_baseChangeGammaEquiv`, and supporting defs): These 13 blocks (def/lem) are correctly structured:
- Two `\mathlibok` anchors (`lem:sheaf_eq_of_locally_eq_mathlib` → `TopCat.Sheaf.eq_of_locally_eq'`, `lem:sheaf_existsUnique_gluing_mathlib` → `TopCat.Sheaf.existsUnique_gluing'`) — correct Mathlib names ✓
- The element-level globalisation route (gammaModA → gammaResAHom → gammaResA → leftRes/rightRes → toCover → toCoverEqLocus → gammaTopEquivEqLocus → baseChangeGammaEquiv) is logically complete and `\uses`-linked ✓
- No `\leanok` on any block (all pre-sync; Lean decls exist per STRATEGY.md / task results)

#### Findings

| # | Severity | Label | Finding |
|---|----------|-------|---------|
| F1 | minor | `lem:base_change_mate_fstar_reindex_legs_conj` (proof `\uses`) | Proof block drops `lem:iterated_mateEquiv_conjugateEquiv_mathlib` and `def:base_change_mate_inner_value` vs statement `\uses`. DAG unaffected (these appear in statement `\uses`). Not blocking. |
| F2 | info | FBC-B / conj-0 blocks | No `\leanok` on 13 FBC-B blocks and 2 conj-0 blocks — expected, pre-sync. Will be added by `sync_leanok` on next run. |

**Verdict: COMPLETE + CORRECT, no must-fix.**

---

### `Picard_QuotScheme.tex`

#### High-Stakes: `lem:section_localization_descent` (keystone D)

**Label**: `lem:section_localization_descent`  
**Lean decl**: `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent` (does NOT yet exist — prover builds)  
**Source**: Stacks `lemma-invert-f-sections` (stacks-properties.tex L2152–2170, verbatim quoted); cf. Hartshorne II.5.3 ✓

**Statement faithfulness**: The Stacks source quotes "Γ(X,F)_f → Γ(X_f,F) is an isomorphism for quasi-coherent F on quasi-compact quasi-separated X." The blueprint statement matches this exactly on X = Spec R, X_f = D(f), rendering it as `IsLocalizedModule(powers f)` over R. ✓

**Proof sketch**: Detailed, complete, formalizable in 7 logical steps:
1. Refine the quasi-coherence cover to a finite basic-open cover {D(r_j)} with local-tilde data using `lem:exists_finite_basicOpen_cover_le_quasicoherentData` (**leanok** ✓)
2. On each D(r_j), the restricted counit is an iso by `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (**leanok** ✓)
3. From that iso, `lem:isLocalizedModule_tilde_restrict` (**leanok** ✓) supplies the tilde localization on sub-basic-opens
4. Present Γ(M,⊤) as finite equalizer over {D(r_j)} using `lem:isLimitPullbackCone_mathlib` + `lem:existsUnique_gluing_mathlib` (**mathlibok** ✓)
5. Same for Γ(M,D(f)) over {D(fr_j)}
6. Localization is flat → commutes with finite equalizer: `lem:isLocalization_flat_mathlib` (**mathlibok** ✓)
7. On each piece the localized sections equal Γ(M,D(fr_j)) by `lem:isLocalizedModule_tilde_restrict`; conclude IsLocalizedModule

The key proof-internal choice (NOT using the global affine equivalence gap1 — which is itself the downstream consequence) is explicitly noted. This avoids circularity. ✓

**`\uses{}` satisfiability**:
- `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` — `\leanok` ✓
- `lem:exists_finite_basicOpen_cover_le_quasicoherentData` — `\leanok` ✓
- `lem:existsUnique_gluing_mathlib` — `\mathlibok` ✓
- `lem:isLimitPullbackCone_mathlib` — `\mathlibok` ✓
- `lem:isLocalization_flat_mathlib` — `\mathlibok` ✓
- `lem:isLocalizedModule_tilde_restrict` — `\leanok` ✓

All `\uses` satisfiable. ✓

#### Six Scheme.Modules Coverage Blocks

The following coverage blocks added this iteration back already-landed Lean:

| Label | `\leanok` | Status |
|-------|-----------|--------|
| `def:over_restrict_presentation` | ✓ | synced |
| `def:presentation_pullback_iota_of_quasicoherentData` | ✓ | synced |
| `def:presentation_pullback_iota_restrict` | ✗ | pre-sync |
| `def:opens_map_equiv_of_iso` | ✗ | pre-sync |
| `lem:opens_map_final_of_scheme_iso` | ✗ | pre-sync |
| `def:pullback_scheme_iso_unit_iso` | ✗ | pre-sync |
| `def:presentation_pullback_of_scheme_iso` | ✗ | pre-sync |
| `lem:isIso_fromTildeΓ_presentationPullback` | ✗ | pre-sync |
| `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` | ✓ | synced |

No correctness issues found on any coverage block.

#### Isolated Node

`lem:annihilator_localization_eq_map` (`Module.annihilator_isLocalizedModule_eq_map`, **leanok** ✓) is isolated: no blueprint node `\uses` it. The prose says it is "the load-bearing algebra engine for the basic-open coherence of `def:modules_annihilator`," but `def:modules_annihilator` does not `\uses` it in its blueprint block. The Lean proof exists and is closed. Disposition: **wire up** by adding `\uses{lem:annihilator_localization_eq_map}` to the proof block of `def:modules_annihilator` or its downstream user `lem:annihilator_ideal_le`.

#### Stacks-Tag Inconsistency (flagged by directive)

`lem:qcoh_affine_section_localization` (G1-core) cites `\textit{Source: [Stacks Project], tag 01HA; cf.\ [Hartshorne], II.5.2.}` while keystone D cites `lemma-invert-f-sections` + Hartshorne II.5.3. The SOURCE comment on G1-core (line 2712) correctly identifies the underlying source as `references/stacks-properties.tex L2152–2170` (= `lemma-invert-f-sections`), but the visible citation says "01HA" — this tag does not appear in any project reference file. Hartshorne II.5.2 vs II.5.3 is also off. **Verdict: MINOR** (math correct, citation confusing but not blocking). The blueprint-writer should unify to `lemma-invert-f-sections` + II.5.3 on the next pass.

#### Findings

| # | Severity | Label | Finding |
|---|----------|-------|---------|
| F3 | minor | `lem:annihilator_localization_eq_map` | Isolated, proved, un-wired. Add `\uses{}` in `def:modules_annihilator` or `lem:annihilator_ideal_le` proof block. |
| F4 | minor | `lem:qcoh_affine_section_localization` | Visible citation "tag 01HA" / "Hartshorne II.5.2" mismatches keystone D's "lemma-invert-f-sections" / "II.5.3". Both point to stacks-properties.tex L2152–2170. Unify on next blueprint-writer pass. |
| F5 | info | Coverage blocks | 7 of 9 presentation/pullback coverage blocks lack `\leanok` — expected pre-sync. |

**Verdict: COMPLETE + CORRECT, no must-fix.**

---

### `Picard_GrassmannianCells.tex`

#### High-Stakes: `lem:gr_proper` (properness keystone)

**Label**: `lem:gr_proper`  
**Lean decl**: `AlgebraicGeometry.Grassmannian.isProper` (does NOT yet exist — prover builds)  
**Source**: Nitsure §1 "Properness" (read from source, verbatim quoted) ✓  
**`\uses{def:gr_glued_scheme, lem:gr_separated}`** — both `\leanok` ✓

**Proof sketch soundness** (DVR valuative criterion):

*Existence*: Given φ: Spec K → Gr(r,d) landing in chart U^I:
1. Choose index J minimizing ν(f(P^I_J)) over all r×r minors P^I_J of the matrix
2. Define g: Z[X^J] → K via g(X^J) = f((X^I_J)^{-1} · X^I) — sends generators to matrix entries expressed in the J-chart
3. Show all entries have ν ≥ 0: any other r×r minor P^J_K = (cofactor of P^I_J in P^I_K) · (P^I_J)^{-1} P^I_K, and by minimality ν(P^I_K) ≥ ν(P^I_J), so entries of X^J have ν ≥ 0
4. Factor g through R ⊂ K: since all g(X^J_ij) ∈ R, define SpecR → U^J → Gr(r,d)

*Uniqueness*: Two fillers restrict to φ on generic point (Spec K), agree there; by separatedness (`lem:gr_separated`, **leanok** ✓) they agree on SpecR.

The proof sketch is detailed and complete at the level a Lean prover can follow. The cofactor-expansion bound and the minimality argument are spelled out explicitly. The chart selection is concrete (which open to use is determined by the minimal valuation). ✓

**Additionally uses `def:gr_transition`** in proof `\uses` (beyond the statement `\uses`): the proof `\uses{def:gr_glued_scheme, lem:gr_separated, def:gr_transition}` — `def:gr_transition` has `\leanok` ✓.

#### Six Separatedness Coverage Blocks

All six separatedness blocks (`lem:gr_diagonalRingMap`, `lem:gr_diagonal_surjective`, `def:gr_pullbackιIso`, `lem:gr_to_specZ`, `lem:gr_isSeparatedToSpecZ`, `lem:gr_separated`) have `\leanok` ✓.

#### Findings

| # | Severity | Label | Finding |
|---|----------|-------|---------|
| — | none | — | No issues found. |

**Verdict: COMPLETE + CORRECT, no must-fix.**

---

### `Cohomology_RegroupHelper.tex`

One lemma (`lem:base_change_regroup_linearEquiv`), **leanok** ✓. One `\mathlibok` anchor (`lem:isPushout_cancelBaseChange_mathlib`). Clean.

### `Picard_FlatteningStratification.tex`

**Completeness**: 0 `\leanok` markers. The Lean file has 6 remaining sorries (checked). The `NOTE (iter-022): CLOSED` comment on `thm:generic_flatness_algebraic` and many blocks are historically closed in Lean; the 0 blueprint `\leanok` reflects that `sync_leanok` has not yet run against the current (modified) Lean file. On next `sync_leanok` run, markers will be added for the closed blocks. **No must-fix** — this is a sync artifact, not a blueprint error.

**Correctness**: Proof sketches sourced to Nitsure §4 (read from source). No correctness issues found in the prose.

### `Picard_RelativeSpec.tex`

9 `\leanok` markers across the relative-Spec theorem and supporting defs. Clean. No issues.

---

## DAG / Structural Findings

| # | Tool | Finding |
|---|------|---------|
| — | leandag `unknown_uses` | Empty — all `\uses{}` labels resolve ✓ |
| — | leandag `isolated` | 5 isolated: 1 blueprint lemma (`lem:annihilator_localization_eq_map`, flagged as F3 above) + 4 lean_aux nodes (expected) |
| — | blueprint-doctor (iter-034) | Clean. No new structural issues detected this iter (no new unresolved refs or axioms introduced). |

---

## Summary of All Findings

| # | Severity | Chapter | Label | Action |
|---|----------|---------|-------|--------|
| F1 | minor | FlatBaseChange | `lem:base_change_mate_fstar_reindex_legs_conj` proof `\uses` | Add `lem:iterated_mateEquiv_conjugateEquiv_mathlib`, `def:base_change_mate_inner_value` to proof block |
| F2 | info | FlatBaseChange | FBC-B + conj-0 blocks | Pre-sync; no action needed |
| F3 | minor | QuotScheme | `lem:annihilator_localization_eq_map` | Wire up: add `\uses{}` in the consumer's proof block |
| F4 | minor | QuotScheme | `lem:qcoh_affine_section_localization` citation | Unify to `lemma-invert-f-sections` / Hartshorne II.5.3 on next blueprint-writer pass |
| F5 | info | QuotScheme | Presentation/pullback coverage blocks | Pre-sync; no action needed |
| F6 | info | FlatteningStratification | 0 `\leanok` throughout | Pre-sync; 6 remaining sorries in Lean file; `sync_leanok` will add markers when proofs close |

No must-fix findings. The three high-stakes chapters pass the HARD GATE.

---

## Unstarted-Phase Blueprint Proposals

Based on the cross-chapter audit:

### Phase: QUOT-descent-global

**Motivation**: `lem:section_localization_descent` (keystone D, prover target this iter) will close gap1. The downstream `lem:qcoh_affine_isIso_fromTildeΓ` and `lem:qcoh_section_localization_basicOpen` both lack `\lean{}` proofs and will be derived from gap1 via `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`. After gap1 closes, the next unstarted phase is the transport to the general-scheme setting (gap2): `lem:qcoh_section_localization_basicOpen` (arbitrary scheme X, not just Spec R). This requires lifting across U ≅ Spec Γ(X,U).

**Blueprint gap**: `lem:qcoh_section_localization_basicOpen` has a proof sketch (lines 2522–2546) but no `\uses{}` that cite a gap-2 transport lemma (no `lem:over_restrict_iso` used). The proof invokes "identify U with Spec Γ(X,U)" but `lem:over_restrict_iso` (the slice-to-geometric bridge, C) is present in the chapter and has `\leanok`. The `\uses` of `lem:qcoh_section_localization_basicOpen`'s proof block only cites `lem:isLocalization_basicOpen_mathlib`. **Action**: add `\uses{lem:over_restrict_iso}` to the proof block of `lem:qcoh_section_localization_basicOpen`; the prose already invokes it implicitly.

### Phase: FBC-B-global

**Motivation**: `lem:fbcb_baseChangeGammaEquiv` and `lem:fbcb_gammaTopEquivEqLocus` are now blueprinted with element-level proofs. The upstream user `thm:flat_base_change_pushforward` is already closed. The unstarted phase is wiring these FBC-B declarations into a standalone `baseChangeGammaEquiv_iso` theorem that subsumes the separated case via the eqLocus route (bypassing the Mayer–Vietoris induction). Blueprint not yet started.

### Phase: SNAP (S1/S3 numerics)

**Motivation**: No blueprint chapter for SNAP currently exists. STRATEGY.md lists SNAP-S1 (semipositive sheaves) and SNAP-S3 (sections of L^n for large n). Both feed the Hilbert polynomial rationality proved in `Picard_QuotScheme.tex`. Before those results can be used, a blueprint chapter must be written from Nitsure §3.

---

*Report written by blueprint-reviewer, iter-035.*
