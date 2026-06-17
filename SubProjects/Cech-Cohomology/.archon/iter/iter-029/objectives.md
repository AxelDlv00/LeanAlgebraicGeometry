# Iter-029 objectives

## Lane 1 — `AffineSerreVanishing.lean` (NEW, mathlib-build, scaffold + build cover-system infra)
Build in dependency order (blueprint `Cohomology_CechHigherDirectImage.tex`, 8-block 02KG chain):
1. `affine_faces_mem` (`lem:affine_faces_mem`) — D(f)∩D(g)=D(fg); standard-cover faces are standard.
2. `standard_cover_cofinal` (`lem:standard_cover_cofinal`) — standard covers cofinal among open covers
   (Schemes `lemma-standard-open` + Sheaves Tag 009L).
3. `coverDatum_bridge` (`lem:cover_datum_bridge`) — `CovDatum` Čech ↔ `X.OpenCover`/`coverOpen 𝒰`.
4. `affine_surj_of_vanishing` (`lem:affine_surj_of_vanishing`) — `ses_cech_h1` + cofinality.
5. `affine_injective_acyclic` (`lem:affine_injective_acyclic`) — `injective_cech_acyclic` + cover bridge.
6. `affineCoverSystem` (`def:affine_cover_system`) — bundle the affine `BasisCovSystem`.
Hand off `affine_cech_vanishing_qcoh` + top `affine_serre_vanishing` to next iter (need Lane 2). Do NOT
import `QcohTildeSections.lean` this iter.

## Lane 2 — `QcohTildeSections.lean` (NEW, mathlib-build, scaffold + build the tilde globalisation)
- `qcoh_iso_tilde_sections` (`lem:qcoh_iso_tilde_sections`) — `F ≅ ~(Γ F)` on affine, `Γ(D(f),F)=M_f`
  (Stacks 01HV `lemma-spec-sheaves` + 01I8). Entry [expected]:
  `AlgebraicGeometry.Modules.Tilde.isIso_fromTildeΓ_of_presentation`. If blocked → Mathlib-gradient handoff.

## Gates / status
- HARD GATE: blueprint-reviewer `iter029` CLEARS the chapter for both files (9 new 02KG decls FORMALIZE-READY).
- progress-critic: skipped (01EO route just completed; 02KG fresh) — rationale in plan.md `## Subagent skips`.
- strategy-critic: SOUND-with-CHALLENGE (EnoughInjectives connector — addressed in STRATEGY/plan.md D2).

## Deferred (not lanes this iter)
- Delete dead `CechAcyclic.affine` sorry (orphaned, not in cone) — refactor cleanup.
- EnoughInjectives connector instance — build at P5b assembly.
