# Blueprint Review Report

## Slug
br251

## Iteration
251

---

## Top-level summaries

### Incomplete parts

- `Albanese_Thm32RationalMapExtension.tex` / `thm:rational_map_to_av_extends`: statement
  has `\leanok` (placeholder body); proof sketch gets two paragraphs in but never names
  the full step-by-step Lean route through CodimOneExtension + AuslanderBuchsbaum — prover
  cannot formalize without consulting those chapters directly. Not on this iter's dispatch,
  so informational only.

- `Cohomology_HigherDirectImage.tex`: 4 `\leanok` occurrences, 3 proof blocks. Listed as
  the gating root for A.2.c-engine (`Rⁱf_*`, i≥1). Stub: minimal content for a
  construction that the STRATEGY marks as "Mathlib PR vs project Čech build (~800–1200
  LOC)". Not on active dispatch this iter; but A.2.c-engine is explicitly "HELD".

- `AlgebraicJacobian_Cotangent_GrpObj.tex`: intentional pointer file, no declaration
  blocks; content lives in `RigidityKbar.tex`. Not a real gap — just the per-file
  blueprint convention.

### Proofs lacking detail

- `Albanese_Thm32RationalMapExtension.tex` / `thm:rational_map_to_av_extends` proof:
  "Milne's one-line proof is: combine Theorem 3.1 with Lemma 3.3." Proof prose begins
  identifying Theorem 3.1 (codim-≥2 extension) and Lemma 3.3 (codim-1 structure) as the
  constituents but the proof block ends before supplying the Lean route or citing the
  `CodimOneExtension` output lemma by name. Chapter is not in this iter's dispatch so this
  is **informational** only.

### Multi-route coverage

Single route (Route A, A.1.c.sub critical path). No MISSING routes.
Route C (Riemann–Roch) remains permanently paused per USER; `lem:symmetric_product_to_jacobian`
in `Albanese_AlbaneseUP.tex` correctly flags its birationality proof as "gated on Route C
re-engagement."

---

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - **Iter-251 repairs confirmed — both read cleanly:**
    1. D2′ overview bullet (§"Construction route", item D2′) now correctly says "closed
       iter-250" and cites `lem:pullback_tensor_iso_unit` as the landing; no reference to
       the obsolete `δ_comp_η_tensorHom` route. ✓
    2. Whole-chapter `\uses{\leanok ...}` scan: grep finds **zero** remaining
       `\uses{\leanok}` corruptions. ✓
  - **D2′ closed:** `lem:pullback_tensor_iso_unit` / `pullbackTensorMap_unit_isIso`
    carries `\leanok` on both statement and proof → axiom-clean. All seven sub-lemmas
    of the unit-square telescope (`presheaf_unit_comp_map_eta`, `isiso_sheafifyeta_of_unitsquare`,
    `eta_bridge_unit_square`, `comp_homequiv_factor_sheafify_pullback`,
    `sheafification_comp_pullback_eq_leftadjointuniq`, `leftadjointuniq_app_unit_eta`,
    `epsilon_presheaf_to_sheaf_unit`) all have `\leanok` on statement and proof. ✓
  - **D1′ (`lem:pullback_tensor_map_natural` / `pullbackTensorMap_natural`):**
    - Statement: NO `\leanok`. Lean target well-formed.
    - Proof: complete — naturality from Mathlib `Functor.OplaxMonoidal.δ_natural` + pasting
      of sheafification naturality squares; 2-step, sound.
    - `\uses{lem:pullback_tensor_map, lem:presheaf_pullback_oplaxmonoidal}` — both declared
      in chapter. ✓
    - **HARD GATE: CLEARED for prover dispatch.**
  - **D3′ (`lem:pullback_tensor_map_basechange` / `pullbackTensorMap_restrict`):**
    - Statement: NO `\leanok`. Lean target well-formed.
    - Proof: complete — mate calculus via `Functor.OplaxMonoidal.comp_δ` +
      `conjugateEquiv_pullbackComp_inv`, mirroring the proven
      `lem:pullbackObjUnitToUnit_comp`. Adequate for a prover who can look at that
      analog's proof.
    - `\uses{lem:pullback_tensor_map, lem:pullback_tensor_map_natural,`
      `lem:pullbackObjUnitToUnit_comp, lem:tensorobj_restrict_iso}` — all declared. ✓
    - **HARD GATE: CLEARED for prover dispatch.**
    - Note: D3′ depends on D1′ (already in `\uses{}`). Dispatch order must be D1′→D3′→D4′.
  - **D4′ (`lem:pullback_tensor_iso_loctriv` / `pullbackTensorIsoOfLocallyTrivial`):**
    - Statement: NO `\leanok`. Lean target well-formed.
    - Proof: complete — 4-step chart-chase:
      (D3′) restrict to f⁻¹Uᵢ via base-change coherence;
      (D1′) transport trivialisation through naturality;
      (D2′) unit-pair iso;
      assemble globally via `lem:isiso_of_isiso_restrict`.
      All four steps are cited by name and structurally mirror the proven
      `lem:tensorobj_preserves_locally_trivial` / `lem:IsLocallyTrivial_pullback`.
    - `\uses{def:IsLocallyTrivial, lem:pullback_tensor_map, lem:pullback_tensor_map_natural,`
      `lem:pullback_tensor_iso_unit, lem:pullback_tensor_map_basechange,`
      `lem:isiso_of_isiso_restrict, lem:tensorobj_preserves_locally_trivial,`
      `lem:IsLocallyTrivial_pullback}` — all declared. ✓
    - **HARD GATE: CLEARED for prover dispatch.** Dispatch AFTER D1′ and D3′ land.
  - **TS-inv — `lem:internal_hom_isSheaf`:** `\leanok` on statement AND proof → CLOSED. ✓
  - **TS-inv — `lem:dual_restrict_iso` / `dual_restrict_iso`:**
    - Statement: NO `\leanok`. Lean target named (`AlgebraicGeometry.Scheme.Modules.dual_restrict_iso`).
    - Proof: complete — 3-step: (a) per-V slice equivalence
      `overEquivalence` (open-immersion fully faithful), (b) codomain agreement,
      (c) ring-iso transport via `lem:restrictscalars_ringiso_dualequiv` (the H2′ core).
    - `\uses{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}` — both
      declared with `\leanok`. ✓
    - **HARD GATE: CLEARED.**
  - **TS-inv — `lem:dual_isLocallyTrivial` / `dual_isLocallyTrivial`:**
    - Statement: NO `\leanok`. Lean target named.
    - Proof: complete — 3-step chain: `dual_restrict_iso` → apply trivialisation iso
      `dualIsoOfIso` → `dual_unit_iso`. Adequate.
    - `\uses{lem:internal_hom_isSheaf, lem:dual_restrict_iso, def:scheme_modules_dual_iso_of_iso,`
      `lem:restrictscalars_ringiso_dualequiv}` — all declared (with `\leanok` on
      `internal_hom_isSheaf`, `restrictscalars_ringiso_dualequiv`,
      `def:scheme_modules_dual_iso_of_iso`). ✓
    - **HARD GATE: CLEARED.**
  - **TS-inv — `lem:sheafofmodules_hom_of_local_compat` / `homOfLocalCompat`:**
    - Statement: NO `\leanok`. Lean target named (`AlgebraicGeometry.Scheme.Modules.homOfLocalCompat`).
    - Proof: complete and unusually detailed — identifies the `localSection` naturality
      field as the load-bearing difficulty; routes through `lem:open_immersion_slice_sheaf_equiv`
      (the shared slice bridge, `\leanok` ✓) and `def:scheme_modules_homMk` (`\leanok` ✓).
      The 2-step structure (glue ab-sheaf via `hom into a sheaf is a sheaf`, then promote
      via `homMk`) is correct and actionable.
    - `\uses{def:scheme_modules_homMk, lem:open_immersion_slice_sheaf_equiv}` — both
      declared with `\leanok`. ✓
    - **HARD GATE: CLEARED.**
  - **TS-inv — `lem:tensorobj_inverse_invertible` / `exists_tensorObj_inverse`:**
    - Statement: `\leanok` → formalized (with sorry-or-placeholder). ✓
    - Proof: documented as "Infrastructure-blocked"; the discharge path through
      `dual_isLocallyTrivial`, `sheafofmodules_hom_of_local_compat`,
      `tensorobj_restrict_iso`, and `tensorobj_unit_iso` is correct and named in the proof
      block and in `rem:dual_discharges_inverse`. The gluing route (local contractions via
      unitors, `sheafofmodules_hom_of_local_compat`, `isiso_of_isiso_restrict`) is complete.
    - `\uses{lem:tensorobj_preserves_locally_trivial, lem:tensorobj_restrict_iso}` (statement
      \uses) + `\uses{..., lem:internal_hom_eval, lem:dual_isLocallyTrivial}` (proof \uses)
      — all declared. ✓
    - **Dispatch note:** Can be closed once `dual_isLocallyTrivial` +
      `sheafofmodules_hom_of_local_compat` land.
  - **One concern — `thm:rel_pic_addcommgroup_via_tensorobj`:** NO `\leanok` on statement
    or proof (it is the consumer assembly gated on D4′ and `exists_tensorObj_inverse`).
    This is correct — it is the downstream target, not an ingredient. Not a gate failure.
  - **Chapter overall:** 91 `\leanok` occurrences, 99 declaration blocks (lemma/def/thm/
    remark). All `\uses{}` pointers I verified resolve inside this chapter or in
    `Picard_LineBundlePullback`/`Picard_RelPicFunctor`. No broken cross-refs found.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:rel_pic_sharp_groupoid` proof `\uses{}` correctly includes
    `lem:pullback_tensor_iso_loctriv` (D4′ target) and `lem:tensorobj_inverse_invertible`
    — the two outstanding ingredients being dispatched this iter. ✓
  - Several declaration statements carry `\leanok` with proxy/placeholder Lean bodies
    (gated on the monoidal-structure gap), all correctly annotated with "DO NOT promote
    to \leanok" warnings. ✓
  - `thm:rel_pic_etale_sheaf_unit_canonical` has no `\lean{}` pin — correct, marked as
    forward-looking.

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (see dedicated section above).

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_IdentityComponent.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - 7 sorries in 3 closure-rank tiers correctly documented. Ranks 1–2 (Sorries 1–4)
    closeable once sibling A.1.c/A.2.b chapters commit; Ranks 3 (Sorries 5–7) gated on
    Route C re-engagement. ✓
  - The `\uses{}` forward-references `thm:quot_representable` and
    `def:rel_pic_etale_sheafification` point to sibling chapters on disk. ✓

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Grassmannian scheme sub-build (`def:grassmannian_scheme`) is identified as a missing
    Mathlib construction; marked as a candidate for its own chapter. The prover-note
    acknowledges this. Not a must-fix since A.2.b is gated/HELD.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Full Rigidity Lemma chain axiom-clean (iter-162). Extensive annotation with formalization
    notes; all `\leanok` markers consistent with declared axiom-clean status.
  - `lem:rational_map_to_av_extends` correctly marked "Route-A-only (iter-164)" and
    demoted from genus-0 path. ✓

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Main formula (`thm:auslander_buchsbaum`) and succ-pd step
    (`lem:auslander_buchsbaum_formula_succ_pd`) both closed axiom-clean (iter-202 Path B).
    `lem:depth_drops_by_one` also closed. ✓
  - Historical per-gap analysis (gaps 1–4) correctly recorded as "RESOLVED or OBVIATED". ✓

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` birationality proof correctly flags Route C
    dependency ("gated on Route C re-engagement or a parallel construction that sidesteps
    RR"). This is an expected flag, not a new finding.
  - `def:symmetric_power_curve` correctly notes "Mathlib has no formalised g-th symmetric
    power of a scheme" and routes through the affine-and-glue recipe.
  - Proofs of main sub-lemmas (symmetrisation, descent through birational sigma,
    homomorphism property, uniqueness) are detailed and complete.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Statement `\leanok` (placeholder). Proof sketch references CodimOneExtension and
    AuslanderBuchsbaum as constituents but does not fully spell out the Lean route —
    "Combine Theorem 3.1 with Lemma 3.3" with partial prose. Prover would need to consult
    the two sibling chapters directly.
  - **Not on this iter's dispatch objectives; partial proof sketch is acceptable given
    that the chapter is gated.**
  - Informational: the reconciliation note about `lem:rational_map_to_av_extends` living
    in two places (this chapter and AbelianVarietyRigidity.tex) has been noted previously;
    the Lean name `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` is pinned here.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Intentional pointer file; no declaration blocks. Content lives in `RigidityKbar.tex`
    §"Piece (i)". Zero sorries per the file's own annotation. ✓

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Stub: 4 `\leanok`, 2 proof blocks. Not on active dispatch (genus-0 arm gated on A.3).

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Stub for `Rⁱf_*` (i≥1), the gating root of A.2.c-engine. 4 `\leanok`, 3 proof
    blocks. The STRATEGY correctly marks A.2.c-engine as HELD; this chapter is not on
    active dispatch.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — complete + correct, no notes. (Route C, paused.)

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — complete + correct, no notes. (Route C, paused.)

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — complete + correct, no notes. (Route C, paused.)

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — complete + correct, no notes. (Route C, paused.)

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — complete + correct, no notes. (Route C, paused.)

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` — complete + correct, no notes. (Route C, paused.)

---

## Cross-chapter notes

- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian` uses Riemann-Roch for
  the birationality argument and is correctly flagged as gated on Route C. The chapter
  explicitly notes this at the proof-block level. No cross-chapter consistency issue, but
  the prover for A.4.d should be aware this sub-lemma cannot close until Route C
  re-engages (or an RR-free birational argument is found).

- `Picard_RelPicFunctor.tex` / `lem:rel_pic_sharp_groupoid` proof `\uses{}` cites both
  `lem:pullback_tensor_iso_loctriv` (D4′, TensorObjSubstrate) and
  `lem:tensorobj_inverse_invertible` (exists_tensorObj_inverse, TensorObjSubstrate). These
  are the two pending inputs; the chapter correctly presents itself as authored "in
  parallel" against those deferred targets.

---

## Severity summary

**Must-fix-this-iter:** 0 items blocking the D1′/D3′/D4′ dispatch or the TS-inv dispatch.

**Soon:** 1 item
- `Albanese_Thm32RationalMapExtension.tex`: proof sketch is incomplete (does not spell out
  the full Lean route through CodimOneExtension → AuslanderBuchsbaum). Should be expanded
  before that chapter enters active prover dispatch. Not blocking any current objectives.

**Informational:** 2 items
- `Cohomology_HigherDirectImage.tex`: stub for gating `Rⁱf_*` root of A.2.c-engine.
  Proposal for expansion is not urgent while A.2.c-engine is HELD.
- `Genus0BaseObjects_Cross01Substrate.tex`: partial stub; genus-0 arm gated.

---

## HARD-GATE VERDICT — `Picard_TensorObjSubstrate.tex`

### Lane TS-cmp (D1′/D3′/D4′) — critical path this iter

| Target | Lean decl | complete | correct | \leanok (stmt/proof) | \uses clean | Gate |
|--------|-----------|----------|---------|----------------------|-------------|------|
| D2′ `lem:pullback_tensor_iso_unit` | `pullbackTensorMap_unit_isIso` | ✓ | ✓ | ✓/✓ (CLOSED) | ✓ | **CLOSED iter-250** |
| D1′ `lem:pullback_tensor_map_natural` | `pullbackTensorMap_natural` | ✓ | ✓ | ✗/✗ | ✓ | **CLEARED** |
| D3′ `lem:pullback_tensor_map_basechange` | `pullbackTensorMap_restrict` | ✓ | ✓ | ✗/✗ | ✓ | **CLEARED** |
| D4′ `lem:pullback_tensor_iso_loctriv` | `pullbackTensorIsoOfLocallyTrivial` | ✓ | ✓ | ✗/✗ | ✓ | **CLEARED** |

All three D1′/D3′/D4′ blueprints are complete and correct. Proof sketches are adequate for
a prover to formalize without improvisation. All `\uses{}` cross-references resolve.
**Dispatch order: D1′ → D3′ → D4′** (D3′ depends on D1′; D4′ depends on both).

### Lane TS-inv (dual-inverse chain) — candidate this iter

| Target | Lean decl | complete | correct | \leanok (stmt/proof) | \uses clean | Gate |
|--------|-----------|----------|---------|----------------------|-------------|------|
| `lem:internal_hom_isSheaf` | `dual` (sheaf level) | ✓ | ✓ | ✓/✓ (CLOSED) | ✓ | **CLOSED** |
| `lem:dual_restrict_iso` | `dual_restrict_iso` | ✓ | ✓ | ✗/✗ | ✓ | **CLEARED** |
| `lem:dual_isLocallyTrivial` | `dual_isLocallyTrivial` | ✓ | ✓ | ✗/✗ | ✓ | **CLEARED** |
| `lem:sheafofmodules_hom_of_local_compat` | `homOfLocalCompat` | ✓ | ✓ | ✗/✗ | ✓ | **CLEARED** |
| `lem:tensorobj_inverse_invertible` | `exists_tensorObj_inverse` | ✓ | ✓ | ✓/✗ (stmt only) | ✓ | **CLEARED to close** |

All TS-inv blueprints are complete and correct. `lem:tensorobj_inverse_invertible` is
already statement-formalized (placeholder); its proof closes via the TS-inv chain.
**Dispatch order: `dual_restrict_iso` → `dual_isLocallyTrivial` →
`sheafofmodules_hom_of_local_compat` → `tensorobj_inverse_invertible`.**

**Overall HARD-GATE VERDICT for `Picard_TensorObjSubstrate.tex`:**
`PASS` — both lane TS-cmp (D1′/D3′/D4′) and lane TS-inv are blueprint-ready for prover
dispatch. No must-fix items found in either block.

---

Overall verdict: Blueprint audit passes hard gate for all this-iter prover objectives
(D1′/D3′/D4′/TS-inv in `Picard_TensorObjSubstrate.tex`); 0 must-fix findings, 1
soon-severity item (`Thm32RationalMapExtension` proof sketch), 0 unstarted-phase proposals
(all strategy phases have ≥ stub coverage).
