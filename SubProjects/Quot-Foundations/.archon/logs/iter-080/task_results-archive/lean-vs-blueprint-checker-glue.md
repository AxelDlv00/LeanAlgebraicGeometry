# Lean ↔ Blueprint Check Report

## Slug
glue

## Iteration
079

## Files audited
- Lean: `AlgebraicJacobian/Picard/GlueDescent.lean` (2802 lines)
- Blueprint: `blueprint/src/chapters/Picard_GlueDescent.tex` (842 lines)

---

## Per-declaration

All 28 blueprint `\lean{...}` references were checked. Lean declarations are present and
signatures match unless noted below.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueProd}` (def:gr_glue_equalizer)
- **Lean target exists**: yes (line 938)
- **Signature matches**: partial — the blueprint block conceptually covers the full descent
  datum (P, Q, legs a/b), but only `glueProd` (P alone) is `\lean{}`-pinned. The companion
  declarations `glueOverlapProd`, `glueLegA`, `glueLegB` (lines 943–978) have no blueprint
  reference of their own.
- **Proof follows sketch**: N/A (definition)
- **notes**: 3 of the 4 sub-components of the equalizer datum are unblocked from blueprint
  coverage. See Unreferenced Declarations.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso}` (lem:glueOverlapBaseChangeIso)
- **Lean target exists**: yes (line 1169)
- **Signature matches**: yes — blueprint prescribes site-level `restrictFunctor` form (not
  geometric pullback), and Lean uses `restrictFunctor` exactly.
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom}` (lem:glueRestrictionHom)
- **Lean target exists**: yes (line 1039)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_glueRestrictionHom}` (thm:isIso_glueRestrictionHom)
- **Lean target exists**: yes (line 2722/2740)
- **Signature matches**: yes
- **Proof follows sketch**: partial — proof body at line 2740 assembles from sub-lemmas, all
  of which are clean except the dependency chain through `glueChartFamily_equalizes` →
  `glueChartComponent_leg_compat` which carries the residual sorry. The sorry propagates
  upward to this theorem.
- **notes**: effectively not closed; blocked by `glueChartComponent_leg_compat` sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.appLE_congr_mor}` (lem:gr_appLE_congr_mor)
- **Lean target exists**: yes (line 1143)
- **Signature matches**: yes
- **Proof follows sketch**: yes (subst proof)
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_overlap_appIso_compat}` (lem:gr_overlap_appIso_compat)
- **Lean target exists**: yes (line 1155)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso_inv_app_app}` (lem:gr_overlapBaseChange_inv_app)
- **Lean target exists**: yes (line 1256)
- **Signature matches**: yes (concrete section map as presheaf.map eqToHom)
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso_hom_app_app}` (lem:gr_overlapBaseChange_hom_app)
- **Lean target exists**: yes (line 1265)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictAdjunction_unit_app_iso}` (lem:gr_restrictAdjunction_unit_iso)
- **Lean target exists**: yes (line 1443)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback_hom_app_counit}` (lem:gr_restrictIsoPullback_counit)
- **Lean target exists**: yes (line 1453)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackCongr_hom_app_eqToHom}` (lem:gr_pullbackCongr_hom_eqToHom)
- **Lean target exists**: yes (line 1463)
- **Signature matches**: yes
- **Proof follows sketch**: yes (subst)
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorCongr_rfl_hom_app}` (lem:gr_restrictFunctorCongr_rfl)
- **Lean target exists**: yes (line 1471)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback_congr}` (lem:gr_restrictIsoPullback_congr)
- **Lean target exists**: yes (line 1483)
- **Signature matches**: yes
- **Proof follows sketch**: yes (subst collapses both congruence casts to identities)
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapFactorIso}` (def:gr_glueOverlapFactorIso)
- **Lean target exists**: yes (line 1870)
- **Signature matches**: yes — geometric-form iso `ι_i^* ∘ (ι_j)_* M_j ≅ (f_ij)_* ∘ (t_ij ∘ f_ji)^* M_j`
- **Proof follows sketch**: N/A (definition)
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent}` (def:gr_glueChartComponent)
- **Lean target exists**: yes (line 1888)
- **Signature matches**: yes — `M i ⟶ pullback(ι_i) ∘ pushforward(ι_j) (M j)`
- **Proof follows sketch**: N/A (definition)
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartFamily}` (def:gr_glueChartFamily)
- **Lean target exists**: yes (line 1899)
- **Signature matches**: yes — `M i ⟶ pullback(ι_i)(glueProd D M)`
- **Proof follows sketch**: N/A (definition)
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartFamily_equalizes}` (lem:gr_glueChartFamily_equalizes)
- **Lean target exists**: yes (line 2088)
- **Signature matches**: yes
- **Proof follows sketch**: partial — the structural setup (componentwise detection,
  preservation-comparison cancel, leg fold) follows the blueprint outline. But the proof
  body at line 2143 calls `glueChartComponent_leg_compat` which has a `sorry` at line 2081.
  The full proof is therefore **not closed**.
- **notes**: effectively one sorry away; `glueChartComponent_leg_compat` is the precise gap.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionInv}` (def:gr_glueRestrictionInv)
- **Lean target exists**: yes (line 2149/2152)
- **Signature matches**: yes — `M i ⟶ pullback(ι_i)(glue ...)`
- **Proof follows sketch**: N/A (definition); body depends on `glueChartFamily_equalizes`
  (which carries the sorry), so `glueRestrictionInv` is also effectively not closed.
- **notes**: downstream of the sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrict_proj_compat}` (lem:gr_glueRestrict_proj_compat)
- **Lean target exists**: yes (line 2162)
- **Signature matches**: yes
- **Proof follows sketch**: yes (limit bookkeeping)
- **notes**: clean (does not depend on the sorry).

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionInv_pullback_map_glueProj}` (lem:gr_glueRestrictionInv_proj)
- **Lean target exists**: yes (line 2191)
- **Signature matches**: yes
- **Proof follows sketch**: yes — equalizer lift unfold + projection identity
- **notes**: clean modulo `glueRestrictionInv` sorry dependency.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrict_hom_ext}` (lem:gr_glueRestrict_hom_ext)
- **Lean target exists**: yes (line 2205)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent_self_counit}` (lem:gr_glueChartComponent_self_counit)
- **Lean target exists**: yes (line 2226)
- **Signature matches**: yes — `glueChartComponent D M g i i ≫ counit = 𝟙`
- **Proof follows sketch**: yes
- **notes**: clean, no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapFactor_transpose}` (lem:gr_glueOverlapFactor_transpose)
- **Lean target exists**: yes (line 2325) — **newly closed this iteration**
- **Signature matches**: yes — states the four-factor canonical composite equals the homEquiv
  of `glueOverlapFactorIso.hom`, matching the blueprint's explicit formula
- **Proof follows sketch**: yes
- **notes**: clean, no sorry. The blueprint proof outline (expand γ_{ij} adjoint transpose,
  cancel left-adjoint comparisons, rewrite via site-level β, close on sections by
  proof-irrelevance of opens identities) is faithfully reflected.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapFactor_mate}` (lem:gr_glueOverlapFactor_mate)
- **Lean target exists**: yes (line 2469)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean, no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestriction_overlap_compat}` (lem:gr_glueRestriction_overlap_compat)
- **Lean target exists**: yes (line 2573)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom_glueChartComponent}` (lem:gr_glueRestrictionHom_glueChartComponent)
- **Lean target exists**: yes (line 2653)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_map_jointly_faithful}` (lem:gr_pullback_jointly_faithful)
- **Lean target exists**: yes (line 1210)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` (def:glueRestrictionIso)
- **Lean target exists**: yes (line 2776)
- **Signature matches**: yes — `pullback(ι_i)(glue ...) ≅ M i`
- **Proof follows sketch**: N/A (definition, packages `isIso_glueRestrictionHom` as an Iso)
- **notes**: downstream of the sorry (body calls `glueRestrictionHom` + `isIso_glueRestrictionHom`).

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.Scheme.Modules.glueChartComponent_leg_compat` at **line 2081**: body
  is `:= sorry`. The REDUCTION steps (lines 2047–2070, blueprint items (1)–(2)) are
  complete — `glueTripleFactorIso` is cancelled, the mate `glueTripleFactor_mate` is fired
  on both sides, and the leg transposes `glueLegA_component_transpose` /
  `glueLegB_component_transpose` are substituted. The remaining CORE (blueprint item (3))
  is the cocycle multiplicativity `hC2 i p q` applied at the triple `(i,p,q)` after
  expanding `glueChartComponent` and cancelling unit/counit pairs; the Lean comment at
  lines 2071–2081 describes the steps precisely. The sorry is the last algebraic
  manipulation, not infrastructure.

### Excuse-comments
- None.

### Axioms / Classical.choice on non-trivial claims
- None. (The file uses `sorry` at exactly one location; no `axiom` declarations.)

---

## Unreferenced declarations (informational)

The file contains approximately 50 declarations not pinned by any `\lean{...}` block in this
chapter. The directive asked specifically about **1-to-1 blueprint debt** — declarations
whose name or docstring implies a blueprint obligation. The list below is broken into
severity tiers.

### Tier A — labeled in docstrings / referenced in \uses{} but missing from blueprint

| Lean name | Lines | Docstring label | Blueprint gap |
|---|---|---|---|
| `glueData_bridge_src/mid/tgt` | 66–98 | — | Referenced as `lem:gr_glueData_bridges` in the \uses{} of `lem:gr_glueChartFamily_equalizes` proof, but no `\begin{lemma}\label{lem:gr_glueData_bridges}` exists in this chapter. |
| `pullbackBaseChangeTransport` | 48–64 | `lem:modules_pullback_basechange_transport` | Referenced in `\uses{def:scheme_modules_glue}` and `\uses{lem:gr_glueChartFamily_equalizes}` — may live in QuotScheme chapter; verify. |
| `glueChartComponent_leg_compat` | 2023 | — | The blueprint proves `lem:gr_glueChartFamily_equalizes` as a whole and relies on this component sub-lemma internally. It is not separately named in the blueprint, leaving the sorry without a direct blueprint obligation target to close against. |

### Tier B — triple-overlap toolkit (13 new helpers this iter, all infrastructure)

These lack individual `\lean{...}` blocks. All are proof-complete with no sorry.

`glueData_triple_square`, `glueData_preimage_image_eq₃`, `glueData_triple_opensFunctor_eq`,
`glueData_triple_appIso_compat`, `glueTripleBaseChangeIso`,
`glueTripleBaseChangeIso_inv_app_app`, `glueTripleBaseChangeIso_hom_app_app`,
`glueTripleFactorIso`, `glueTripleFactor_transpose`, `glueTripleFactor_mate`,
`glueLegA_component_transpose`, `glueLegB_component_transpose`,
`glueChartFamily_pullback_map_π`.

These are exactly the "~13 new helpers" the directive mentions. Their blueprint debt is
collectively the single label `lem:gr_glueData_bridges` (the three bridge lemmas) and the
triple-overlap base change / factor machinery, which the blueprint names only in passing
within the `lem:gr_glueChartFamily_equalizes` proof sketch.

### Tier C — internal plumbing / free-sheaf coherence (no blueprint obligation expected)

`opensMap_final`, `pullbackFreeIso`, `pullbackFreeIso_eqToHom`,
`pullbackFreeIso_trans_symm_eqToIso`, `pullback_isLocallyFreeOfRank`,
`pullbackObjUnitToUnit_id`, `pullbackFreeIso_id`, `homEquiv_conjugateEquiv_app`,
`pullbackObjUnitToUnit_comp`, `pullbackFreeIso_comp`, `pullbackFreeIso_inv_congr_hom`,
`pullbackCongr_hom_app_free`, `pullbackFreeIso_inv_congr`, `pullbackCongr_inv_app_free`,
`pullbackComp_inv_app_free_map`, `homEquiv_comp_unit_pushforwardComp`,
`homEquiv_comp_pushforwardCongr`, `glueLift_cond_iff`, `restrictFunctor_isRightAdjoint`,
`restrictFunctor_preservesLimits`, `pullback_preservesLimits_of_isOpenImmersion`,
`glueOverlapProd`, `glueLegA`, `glueLegB`, `glueIsoEqualizer`, `glueProj`,
`glueLift_glueProj`, `pullback_map_glueLift_glueRestrictionHom`, `glueRestrictEqualizerIso`,
`glueRestrictProdIso`, `glueData_preimage_image_eq`, `glueData_overlap_opensFunctor_eq`,
`glue`, `glueLift`.

These are helpers that the blueprint tacitly assumes without naming individually; no
separate `\lean{...}` debt arises, but the planner may wish to document `glueLegA`/`glueLegB`
as co-inhabitants of `def:gr_glue_equalizer`.

---

## Blueprint adequacy for this file

- **Coverage**: 28/28 blueprinted `\lean{...}` targets exist in the Lean file. ✓
  Unreferenced declarations: ~50 (≈36 purely internal plumbing; ~13 Tier-B helpers;
  3 Tier-A debt items).
- **Proof-sketch depth**: **under-specified for the residual core**.
  - `lem:gr_glueChartFamily_equalizes` proof outline item (3) says the transposed component
    equation "is the cocycle multiplicativity (C2)...conjugated by base-change transports;
    the geometric bridges were chosen so that the endpoints line up on the nose." This
    correctly identifies the DESTINATION but omits the algebraic path: which unit/counit
    pairs cancel, how the endpoint alignments from `glueData_bridge_src/mid/tgt` are fed
    in, and how the degenerate pairs `p = i` / `q = i` are handled via `hC1` +
    `pullbackCongr_hom_app_eqToHom`. The Lean code's "REMAINING CORE" comment (lines
    2071–2081) is more specific than the blueprint.
  - All other proof sketches are adequate.
- **Hint precision**: **precise** for all 28 blueprinted blocks. Site-level vs.
  geometric-pullback distinction is handled correctly.
- **Generality**: **matches need** — all definitions are stated at the right level for
  downstream use.
- **Label gap**: `lem:gr_glueData_bridges` is referenced in `\uses{}` of
  `lem:gr_glueChartFamily_equalizes`'s proof block but is not defined anywhere in this
  chapter. The three Lean declarations `glueData_bridge_src`, `glueData_bridge_mid`,
  `glueData_bridge_tgt` collectively discharge this obligation, but no blueprint block
  formally states them.

### Recommended chapter-side actions

1. **Add** a lemma block `\label{lem:gr_glueData_bridges}` stating the three bridge
   identities (pullback condition, `t_fac`/`cocycle` consequence) as
   `\lean{glueData_bridge_src}` / `\lean{glueData_bridge_mid}` / `\lean{glueData_bridge_tgt}`.
   Currently referenced in `\uses{}` but absent from the chapter.

2. **Expand** the proof sketch of `lem:gr_glueChartFamily_equalizes`, item (3), to
   describe the unit/counit cancellation and the degenerate-pair handling (C1 via
   `pullbackCongr_hom_app_eqToHom`). The current prose guides the PROVER to the right
   idea but not to the formal steps needed to close the sorry.

3. **Add** a brief `\lean{glueChartComponent_leg_compat}` remark or sub-lemma block (within
   the proof environment of `lem:gr_glueChartFamily_equalizes`) so the residual sorry has an
   explicit blueprint address — currently the sorry is "inside" a proof step with no named
   target to close against.

4. (Optional) Add `\lean{glueLegA}`, `\lean{glueLegB}` and `\lean{glueProj}` annotations
   within `def:gr_glue_equalizer`, or as minor sub-items, to fill the partial-mismatch gap
   in that block.

---

## Severity summary

### must-fix-this-iter

1. **`glueChartComponent_leg_compat` sorry (line 2081)** — the statement is substantive
   (pair component of the C2 equalizing condition, the last piece blocking
   `glueChartFamily_equalizes`), its body is `:= sorry`, and the blueprint claims
   `lem:gr_glueChartFamily_equalizes` is closed. Everything upstream (`glueRestrictionInv`,
   `isIso_glueRestrictionHom`, `glueRestrictionIso`) is therefore also effectively open.

### major

2. **`lem:gr_glueData_bridges` blueprint label missing** — the chapter references it in
   `\uses{}` but provides no block; three Lean declarations cover the content. The
   blueprint-doctor should flag an orphan `\uses{}` reference.

3. **Triple-overlap toolkit (Tier-B, ~13 helpers)** — entirely unblueprinted. Collectively
   these implement the infrastructure that the blueprint's item (2) describes in one
   sentence ("assembled by the same four-factor recipe … with the section-level
   compatibility proved by the appLE-calculus"). The gap means a future prover reading
   only the blueprint cannot reconstruct these declarations without significant independent
   work.

### minor

4. `def:gr_glue_equalizer` covers only `glueProd`; `glueOverlapProd`, `glueLegA`,
   `glueLegB` are unnamed in the blueprint.

---

**Overall verdict**: The Lean file is structurally sound with correct signatures on all 28
blueprinted targets and all ~48 proof-complete declarations; the single blocker is the
`sorry` in `glueChartComponent_leg_compat` (line 2081), which is the last algebraic step
of the C2 cocycle application and must be closed to release `glueChartFamily_equalizes`,
`glueRestrictionInv`, `isIso_glueRestrictionHom`, and `glueRestrictionIso`.
