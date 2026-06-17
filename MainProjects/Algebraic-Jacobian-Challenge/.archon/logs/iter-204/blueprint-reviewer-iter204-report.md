# Blueprint Review Report

## Slug
iter204

## Iteration
204

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex`: `lem:tensorobj_preserves_locally_trivial`, `lem:tensorobj_inverse_invertible`, `lem:tensorobj_lift_onproduct`, `lem:pullback_compatible_with_tensorobj` — four lemmas with no `\lean{...}` pins. Two of these (`tensorobj_preserves_locally_trivial`, `tensorobj_inverse_invertible`) are exactly the live Lane TS targets (`tensorObj_isLocallyTrivial`, `exists_tensorObj_inverse`); without Lean names, `sync_leanok` cannot track them and the prover has no declaration name to close.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_preserves_locally_trivial`: `\lean{}` hint entirely absent — lane target `tensorObj_isLocallyTrivial` is untrackable. The mathematical content (affine local triviality preserved by tensor product) is adequate for formalisation, but the Lean declaration name is not specified.
- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_inverse_invertible`: `\lean{}` hint entirely absent — lane target `exists_tensorObj_inverse` is untrackable. Same situation.
- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_lift_onproduct`: no `\lean{}` pin.
- `Picard_TensorObjSubstrate.tex` / `lem:pullback_compatible_with_tensorobj`: no `\lean{}` pin.

### Multi-route coverage

Single route (Route A only this iter). No missing routes.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_PicdSubstrate.tex`

**Covers**: `AlgebraicJacobian/Picard/PicdSubstrate.lean` (new file; or absorb into `IdentityComponent.lean`)
**Strategy phase**: A.4.d.0 — Pic^d substrate
**Why now**: A.4.d.0 has zero blueprint coverage today (no chapter, no declaration blocks); writing the chapter now means A.4.d (Albanese UP via divisor map) and the downstream `JacobianWitness` body can be parallelised against a well-specified blueprint once Route C re-engages. Writing it while A.4.d is gated costs nothing and prevents a planning debt.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:picd_scheme}` — The degree-d component `Pic^d_{C/k}` of the Picard scheme: the clopen component of `Pic_{C/k}` (\cref{def:pic_scheme}) indexing line bundles of degree d. `\lean{AlgebraicGeometry.Scheme.PicdScheme}` [expected]. Source: Kleiman, "The Picard scheme", §5, prp:pic0 (the disjoint-union decomposition `Pic_{C/k} = ⊔_{d∈ℤ} Pic^d_{C/k}`; read from `references/kleiman-picard-src/kleiman-picard.tex`).
2. `\lemma` `\label{lem:picd_translation_isomorphism}` — Translation by a `k`-rational point `P` of degree `d` gives an isomorphism `Pic^0_{C/k} ≅ Pic^d_{C/k}`. `\lean{AlgebraicGeometry.Scheme.PicdScheme.translationIso}` [expected]. Source: Kleiman §5, same reference; the translation is `L ↦ L ⊗ O_C(P)`.
3. `\definition` `\label{def:effective_divisor_on_product}` — Relative effective Cartier divisor of degree d on `C × Pic^d` (the universal divisor), with structure morphism `C × Pic^d → Pic^d` flat over `Pic^d`. `\lean{AlgebraicGeometry.Scheme.PicdScheme.universalDivisor}` [expected]. Source: Kleiman §3, Def. dfn:Abel (the Abel map and its divisor-side data; read from `references/kleiman-picard-src/kleiman-picard.tex`).
4. `\lemma` `\label{lem:picd_nonempty_of_genus_pos}` — For `g(C) > 0` and `d ≥ 2g−1`, `Pic^d_{C/k}` is non-empty (Riemann–Roch, `dim H^0(C, L) > 0` for `deg L ≥ 2g−1`). `\lean{AlgebraicGeometry.Scheme.PicdScheme.nonempty_of_large_degree}` [expected]. Source: Kleiman §5 Cor. cor:sm (Riemann–Roch degree bound) + RR chapter `RiemannRoch_RRFormula.tex`; gated on Route C re-engagement.

**`\uses` skeleton**:
- `def:picd_scheme` uses `def:pic_scheme`, `def:divisor_degree_pic`
- `lem:picd_translation_isomorphism` uses `def:picd_scheme`, `def:pic_zero_subscheme`
- `def:effective_divisor_on_product` uses `def:picd_scheme`, `thm:quot_representable`
- `lem:picd_nonempty_of_genus_pos` uses `def:picd_scheme`, `thm:riemannRoch_genus_zero` (Route C gate)

**Main theorem proof strategy**: `Pic^d_{C/k}` is the clopen component of `Pic_{C/k}` representing degree-d classes; its existence and projectivity follow from the FGA representability theorem (A.2.c, `thm:fga_pic_representability`) applied to the degree-d Hilbert-polynomial stratum. Non-emptiness for `d ≥ 2g−1` requires Riemann–Roch. The translation isomorphism `Pic^0 ≅ Pic^d` (for d with a degree-d effective divisor) is the standard tensor-product-by-a-degree-d line bundle map.

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex`, §5 (prp:pic0, th:qpp&p, cor:sm) — Pic^d as degree-d component, translation isomorphism, non-emptiness
- `references/abelian-varieties.md` → `abelian-varieties.pdf`, §III.1 — degree map and Pic^0
- retrieval needed: Kleiman §3 dfn:Abel verbatim for the universal divisor construction — in local file `references/kleiman-picard-src/kleiman-picard.tex` at L1837–1870

**Subphase choices exposed**:
- Bundled vs. unbundled: The chapter could define `Pic^d` as a definition on top of the existing `Pic_{C/k}` decomposition (one `clopen_component_of_degree_eq` lemma + one definition) OR as a separate type alias with its own `\lean{}` pin. Recommendation: thin alias, sharing all structure theorems with `Picard_IdentityComponent.tex`; avoids code duplication and keeps the chapter short (≤8 blocks). Only worth a standalone file if a later iter adds the universal-divisor construction.
- Route C gate: `lem:picd_nonempty_of_genus_pos` is the only Route C-blocked item; all other declarations are Route A-independent. The chapter can be written now without waiting for Route C — just mark that lemma as a typed sorry with a clear annotation.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:projectiveLineBar_isProper` (Lean `projectiveLineBar_isProper`) has no `\leanok` on its statement block, meaning it is untracked by `sync_leanok`. The proof sketch is detailed (≈40 LOC estimate, "already landed axiom-clean"), suggesting this is a missed `\leanok` that should already be there.
  - `prop:rigidity_genus0_curve_to_AV` (the headline of the genus-0 arm) uses `\cref{thm:genus_zero_curve_iso_p1}` which is defined in the PAUSED Route C chapter `RiemannRoch_RationalCurveIso.tex`. The `\uses{}` is structurally correct (the label resolves) but the downstream declaration carries Route C sorries; the genus-0 arm cannot close axiom-clean until Route C re-engages or the `J := Spec k` rigidity route is completed.
  - `lem:rational_map_to_av_extends` appears in this chapter (with Lean name `AlgebraicGeometry.rationalMap_to_av_extends`) AND as the headline theorem of `Albanese_Thm32RationalMapExtension.tex` (with a different Lean name `AlgebraicGeometry.Scheme.RationalMap.extend_to_av`). The two `\lean{}` names differ; a reconciliation pass is owed (noted in the strategy for `Thm32RationalMapExtension.tex`).

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Main theorem `thm:rigidity_over_kbar` has `\leanok` on statement (sorry-bodied decl exists). Proof is unproven (sorry) — correctly lacks proof-block `\leanok`.
  - The chapter is Route (a) fallback, explicitly off the critical path (Candidate (c) operative). Disposition is intentional and well-documented.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Five of six Lean-pinned declarations (`PicSharp`, `PicSharp.functorial`, `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure`) carry placeholder bodies, explicitly gated on the TensorObj substrate gap. Their `\leanok` markers are on statement blocks only; proof blocks correctly lack `\leanok`. This is documented and intentional — not a chapter defect.
  - `lem:rel_pic_sharp_groupoid` proof block has no `\leanok` (correct; body is sorry). Statement block has `\leanok` (correct; sorry-bodied decl exists).
  - Once `Picard_TensorObjSubstrate.tex` lane TS closes, this chapter collapses from 6 sorries to 1 and the single residual gates only on the Mathlib gap (monoidal structure), not on project-side mathematics. Status is appropriate.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **MUST-FIX (blueprint purity violation)**: The proof block of `thm:scheme_modules_monoidal` (line ~293) has a stray `\leanok`. The `% NOTE (review iter-203)` comment inside that block explicitly confirms that `AlgebraicGeometry.Scheme.Modules.monoidalCategory` has a `:= sorry` body (intentional contamination guard), making the proof-block `\leanok` incorrect — a proof-block `\leanok` asserts "proof closed, no sorry", but the proof is not closed. `sync_leanok` at iter-203 failed to remove it. This is a must-fix-this-iter finding: the plan agent must dispatch a blueprint-writer to strip the stray proof-block `\leanok` from `thm:scheme_modules_monoidal`.
  - **MUST-FIX (Lane TS, Lean difficulty quality)**: `lem:tensorobj_preserves_locally_trivial` has no `\lean{...}` hint. The lane TS target `tensorObj_isLocallyTrivial` maps to this lemma. Without a `\lean{}` pin, `sync_leanok` cannot track it, the prover has no Lean declaration name to close, and the blueprint is incomplete for the live lane.
  - **MUST-FIX (Lane TS, Lean difficulty quality)**: `lem:tensorobj_inverse_invertible` has no `\lean{...}` hint. Lane TS target `exists_tensorObj_inverse` maps to this lemma. Same issue.
  - **Soon**: `lem:tensorobj_lift_onproduct` — no `\lean{}` pin. Not a lane target but consumed by `thm:rel_pic_addcommgroup_via_tensorobj`; needs pin to close the consumer.
  - **Soon**: `lem:pullback_compatible_with_tensorobj` — no `\lean{}` pin. Same situation.
  - The proof sketches for all five lemmas are mathematically adequate (affine descent arguments). The deficiency is purely the absence of Lean declaration names and the stray proof-block `\leanok`.
  - **Hard gate status**: Both `complete: partial` and `correct: partial` mean the hard gate does NOT clear for Lane TS. The same-iter fast path is recommended: dispatch a blueprint-writer this iter to (a) strip the stray `\leanok` and (b) add `\lean{}` hints to the four unpinned lemmas; then re-review scoped to this chapter.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Sub-lemmas `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata` have no `\lean{}` hints and no `\leanok` markers. These are inputs to `thm:flattening_stratification_exists` (which HAS `\leanok` on statement). The sub-lemmas appear to be intended as inline proof steps rather than separately tracked declarations. No active prover lane depends on this chapter this iter.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Several sub-lemmas (`lem:flat_locus_open`-equivalent content, `lem:quot_reduction_to_pi_star_W`, `lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion`) have no `\leanok` markers. The main theorem `thm:quot_representable` has `\leanok` on statement. No active prover lane depends on this chapter this iter.
  - `lem:pullback_tildeIso` and `lem:pushforward_isQuasicoherent` are correctly marked as named typed-sorry gaps with `\leanok`.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:geometricallyConnected_of_connected_of_section` (Stacks 037Q iff-direction) has no `\leanok` on either block. The proof sketch is detailed (5+ paragraphs, explicit Mathlib API references), but the Lean declaration apparently has not been closed. This is the iter-194 must-fix that was added as a first-class blueprint obligation; its status should be confirmed.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Stage 6.A (`lem:smooth_algebra_krull_dim_formula`) and Stage 6.B (`lem:cotangent_kahler_over_field`) have no `\leanok` markers, consistent with the Lean closures being incomplete. The Stage 6.A sub-lemmas are axiom-clean private helpers (iter-200 landed); the public-facing lemma is still gated.
  - `lem:stage6_regular_stalk_assembly` has no `\lean{}` pin — deliberately documented as "treat as in-body closure pattern" rather than a standalone declaration. This is intentional.
  - The `subsec:stage6_iib_substrate_iter200` recipe was edited this iter (corrected drifted recipe signature: dropped `(hn : ringKrullDim A = n)` parameter). The corrected content matches the landed `matsumura_isRegular_of_linearIndependent_cotangent` declaration. The iter-203 landing note and the recipe are now consistent — no remaining blueprint–Lean drift on this specific item.
  - The `\subsection` label `\label{subsec:stage6_iib_substrate_iter200}` is referenced by `\ref{}` in the same chapter; this is correct (not a cross-chapter broken label).

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Strategy marks A.4.b as "CLOSED iter-202 (axiom-clean)". Key declarations `def:depth`, `lem:depth_via_ext`, and the main Auslander–Buchsbaum formula should have `\leanok` on both statement and proof blocks if they are axiom-clean. The 150 lines I audited show statement-block `\leanok` on `def:depth` and `lem:depth_via_ext` with detailed proof sketches. Closures confirmed by iter-202 strategy entry.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:rational_map_to_av_extends` has `\leanok` on statement and `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}`. The proof delegates to `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` from CodimOneExtension — correct and consistent.
  - Cross-chapter note: This chapter's `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` differs from `AbelianVarietyRigidity.tex`'s `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` for what appears to be the same mathematical theorem. The plan agent's reconciliation directive (noted in the chapter strategy comment) is still pending.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:albanese_universal_property` has `\leanok` on statement; proof outline is detailed (symmetric-power route ii committed). Gated on A.3 (Picard chain) and A.4.c (Thm32), both of which have blueprint coverage.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:genus_zero_curve_iso_p1` has `\leanok` on statement; this is the Route C declaration consumed by `prop:rigidity_genus0_curve_to_AV` in `AbelianVarietyRigidity.tex` via `\uses{}`. The cross-reference is structurally correct (label resolves); the sorry-bodied status is expected for a PAUSED chapter.

---

## Cross-chapter notes

- `AbelianVarietyRigidity.tex` declares `\label{lem:rational_map_to_av_extends}` with `\lean{AlgebraicGeometry.rationalMap_to_av_extends}`. `Albanese_Thm32RationalMapExtension.tex` declares what appears to be the same theorem as `\label{thm:rational_map_to_av_extends}` with `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}`. Two different Lean names are assigned to the same mathematical content. The `Albanese_Thm32RationalMapExtension.tex` chapter strategy note explicitly says a reconciliation pass is owed; it has not happened yet.

---

## Severity summary

| Finding | Location | Tier |
|---------|----------|------|
| Stray proof-block `\leanok` on `thm:scheme_modules_monoidal` launders sorry — blueprint purity violation | `Picard_TensorObjSubstrate.tex` | **must-fix-this-iter** |
| `lem:tensorobj_preserves_locally_trivial` missing `\lean{}` hint (lane target `tensorObj_isLocallyTrivial`) | `Picard_TensorObjSubstrate.tex` | **must-fix-this-iter** |
| `lem:tensorobj_inverse_invertible` missing `\lean{}` hint (lane target `exists_tensorObj_inverse`) | `Picard_TensorObjSubstrate.tex` | **must-fix-this-iter** |
| **unstarted-phase proposal**: A.4.d.0 has zero blueprint coverage — dispatch blueprint-writer for `Picard_PicdSubstrate.tex` or record deferral | `Picard_PicdSubstrate.tex` (proposed) | **must-act-this-iter** |
| `lem:tensorobj_lift_onproduct` missing `\lean{}` hint | `Picard_TensorObjSubstrate.tex` | soon |
| `lem:pullback_compatible_with_tensorobj` missing `\lean{}` hint | `Picard_TensorObjSubstrate.tex` | soon |
| `lem:rational_map_to_av_extends` has two different Lean names across two chapters | `AbelianVarietyRigidity.tex` + `Albanese_Thm32RationalMapExtension.tex` | soon |
| `lem:projectiveLineBar_isProper` missing statement-block `\leanok` (claimed axiom-clean in prose) | `AbelianVarietyRigidity.tex` | informational |
| `lem:geometricallyConnected_of_connected_of_section` lacks `\leanok` (iter-194 obligation) | `Picard_IdentityComponent.tex` | informational |

**Overall verdict**: HARD GATE for Lane TS (Picard_TensorObjSubstrate) DOES NOT CLEAR due to `correct: partial` (stray proof-block `\leanok`) and `complete: partial` (missing `\lean{}` hints on 2 lane targets). 3 must-fix findings + 1 unstarted-phase proposal (A.4.d.0); same-iter fast path recommended — dispatch blueprint-writer to strip stray `\leanok` and add 4 `\lean{}` hints, then re-review scoped to that chapter.
