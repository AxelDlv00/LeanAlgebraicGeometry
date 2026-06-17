# Recommendations for the next plan iteration (post iter-043)

## HIGH — refine the `lem:tile_section_comparison` blueprint sketch BEFORE re-dispatch (HARD-GATE risk)
lean-vs-blueprint-checker `qts` (major) found the `lem:tile_section_comparison` proof note is now
**inaccurate**: it claims "~100–150 LOC construction" and "genuinely non-definitional," but iter-043
reduced the obstruction to **one structure-sheaf ring identity** (~30–50 LOC) after two axiom-clean
`rfl` bridges. A prover working from the current sketch alone would build an unnecessary 100–150 LOC
cross-ring transport. Review added a `% NOTE (review iter-043)` flagging this at the proof block, but
the prose itself still misleads.
- **Action:** dispatch a **blueprint-writer** on `Cohomology_CechHigherDirectImage.tex` to (a) rewrite
  the `lem:tile_section_comparison` sketch to the accurate decomposition (two `rfl` sub-lemmas already
  landed + one residual ring identity), naming the residual identity and the two closure routes
  (Route A: `specAwayToSpec_eq` + `Scheme.Hom.comp_appIso` + `ΓSpecIso` naturality; Route B:
  `StructureSheaf.IsLocalization.to_basicOpen` / `IsLocalization.Away` uniqueness); and (b) add
  blueprint blocks for the two new sub-lemmas (see Coverage debt below).
- Then re-run blueprint-reviewer (scoped fast-path) to re-clear the HARD GATE before the prover lane.

## HIGH — the closer is a focused ~30–50 LOC ring identity (closest-to-completion target)
After the sketch is refined, dispatch the prover to close `tile_section_comparison`'s residual:
```
(ringCatSheaf.map (homOfLE ⋯).op).hom (algebraMap R Γ(W,𝒪) r)
  = ((basicOpenIsoSpecAway g).inv.appIso ⊤).inv.hom (algebraMap R_g Γ(⊤,𝒪_{R_g}) (algebraMap R R_g r))
```
- **DO NOT retry** the naive single `rfl`/`simp` close of the *full* compat — kernel-confirmed dead end
  this iter (the cross-ring residual is genuine structure-sheaf naturality, not unfolding). Several
  `simp` variants already failed (`Scheme.Hom.comp_appIso`+`specAwayToSpec_eq`; `Scheme.Opens.ι_appIso`;
  `ΓSpecIso_inv_naturality`+`toSpecΓ_appTop`).
- **DO** close the residual at the morphism level via Route A or Route B above. If it stalls on a
  concrete term-mode wall, THIS is the point the iter-043 planner pre-armed for a mathlib-analogist
  (api-alignment) consult with the actual error state attached.
- Then assemble `tile_section_localization` (gated on this) using `qcoh_finite_presentation_cover`,
  `section_isLocalizedModule_of_presentation`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`.

## MEDIUM — coverage debt (leandag unmatched = 3)
`archon dag-query unmatched` lists three `lean_aux` nodes:
- `AlgebraicGeometry.modulesSpecToSheaf_smul_eq` (QcohTildeSections.lean, proved) — NEW; needs a
  blueprint block. Relies on `ModuleCat.restrictScalars.smul_def`, `forgetToPresheafModuleCatObjObj`
  defeq, `modulesSpecToSheaf` def. Suggested label `lem:modulesSpecToSheaf_smul_eq`; natural `\uses`
  neighbour `lem:tile_section_comparison`.
- `AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq` (QcohTildeSections.lean, proved) — NEW; needs a
  blueprint block. Relies on `SheafOfModules.pushforward`/`restrict` action, `Scheme.Hom.appIso`.
  Suggested label `lem:modulesRestrictBasicOpen_smul_eq`; `\uses{lem:tile_image_opens_identities}`.
  Fold both into `lem:tile_section_comparison`'s `\uses{}` (they are its Sub-lemma B ingredients).
- `AlgebraicGeometry.CechAcyclic.affine` — pre-existing dead/superseded (sorry-bodied; protected
  `CechHigherDirectImage.lean` design comments reference it). Remove at the P5b assembly rework.

## LOW — `.lean` comment / hygiene items (for the prover next iter, not blocking)
From lean-auditor `iter043` (`task_results/lean-auditor-iter043.md`):
- Reword the in-file "PROVEN tactic prefix" comment for `tile_scalar_compat` → "tested but not yet
  compiled" (the lemma is never compiled; only the comment exists). Over-claim, not wrong code.
- Replace the two deprecated `CategoryTheory.Sheaf.val` (`.val.obj`) uses in the new lemmas' `show`
  ascriptions with the canonical `ObjectProperty.obj` accessor before the alias is removed upstream
  (currently a warning, build is green).
- Add a one-line comment on each new `rfl` lemma documenting why the `rfl` is valid despite the
  section header's "does NOT commute definitionally" framing (carrier-defeq + scalar-formula vs the
  section-comparison *map* not being rfl). Reduces fragility/confusion.

## Process note (no churn; route converging)
The keystone route has landed axiom-clean decls every prover iter (040:+4, 041:+3, 042:+1, 043:+2) on
a shrinking leaf-set. iter-043 was NOT a stall: it reduced the last hard ingredient from a ~150-LOC
wall to a single ring identity. Do NOT treat the "named targets not built" as a blocked route — it is
a genuine reduction. The single live critical path remains the keystone; no honest off-keystone
parallel lane exists (confirmed iter-043, `cechAugmented_exact` is 01I8-gated).
