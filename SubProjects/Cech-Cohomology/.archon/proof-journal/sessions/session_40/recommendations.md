# Recommendations for iter-041

## Top priority — open the keystone-assembly lane (now unblocked)
The entire B3+B4 lane is DONE and axiom-clean. The reversal signal armed in iter-038/039/040 plans
("B3 object iso lands + B4 trivial ⟹ next iter opens the keystone lane") is now MET.

- **Dispatch a prover on `QcohTildeSections.lean`** for the Route B keystone
  `qcoh_section_isLocalizedModule` (`IsLocalizedModule (.powers f) (Γ(X,F) → Γ(D f, F))`).
- It may now `import QcohRestrictBasicOpen` and consume **B4** `presentationModulesRestrictBasicOpen`
  via `section_isLocalizedModule_of_presentation` + `isLocalizedModule_of_span_cover`, with the cover
  refined by **B1** `qcoh_finite_presentation_cover`. This is the documented assembly path (PROGRESS
  "Next iter plan"); the chain B0[done]–B6 has every leaf built except this keystone.
- HARD GATE: before dispatching, the plan agent must confirm the keystone's blueprint block
  (`qcoh_section_isLocalizedModule` chapter coverage) is `complete + correct` via a fresh
  blueprint-reviewer pass.

## Blueprint coverage debt — restore 1-to-1 Lean↔blueprint (planner authors the prose)
`archon dag-query unmatched` = 3:
1. **`AlgebraicGeometry.restrictBasicOpenUnitIso`** (QcohRestrictBasicOpen.lean) — `noncomputable def`,
   the unit-sheaf-restriction iso `(restrict (basicOpenIsoSpecAway g).inv).obj (unit O_{D(g)}) ≅
   unit O_{Spec R_g}`. Depends on Mathlib `Scheme.Modules.restrictFunctorIsoPullback`,
   `SheafOfModules.pullbackObjUnitToUnit`, `TopologicalSpace.Opens.mapMapIso`, and
   `pullbackObjUnitToUnit_isIso_basicOpen`. **Fold into `lem:presentation_modulesRestrictBasicOpen`'s
   `\uses`/`\lean{}`** as a supporting node (it is the η feeding B4's final `Presentation.map`).
2. **`AlgebraicGeometry.pullbackObjUnitToUnit_isIso_basicOpen`** (instance) —
   `IsIso (pullbackObjUnitToUnit ((basicOpenIsoSpecAway g).inv).toRingCatSheafHom)`. Supporting node
   for (1). Same fold-in.
3. `AlgebraicGeometry.CechAcyclic.affine` — pre-existing dead/superseded (protected file references
   it); deferred, no action.

## Blueprint prose fix — `lem:restrict_over_compat` scope mismatch (planner / blueprint-writer)
The lean-vs-blueprint-checker (`qrbo`) flagged that the lemma prose states the **full B3c** iso
`F.over D(g) ≅ modulesRestrictBasicOpen g F` landing in `(Spec R_g).Modules`, but the pinned Lean
`overBasicOpenIsoRestrict` proves the **B3b intermediate** `engine.inverse.obj(F.over D(g)) ≅
F.restrict ι` in `D(g).toScheme.Modules`. The Lean is sound and is exactly what B4 consumes; only the
prose overclaims the codomain. Review left a `% NOTE:` recording this. **Planner action:** tighten the
`lem:restrict_over_compat` prose to the B3b intermediate, OR split off an explicit B3c node for the
final affine-restriction step (which is currently performed inline inside B4). One blueprint-writer
directive against this chapter resolves it.

## Reusable proof patterns discovered
- **`set_option backward.isDefEq.respectTransparency false`** for the `TopCat.str` vs
  `SheafedSpace.instTopologicalSpaceCarrierCarrier` IsContinuous discrimination-tree mismatch on
  `.toScheme`-coerced sites. Elaborator-only, kernel-safe.
- **Explicit `@`-application with a local instance** (`@Presentation.map … hpc …`, `@asIso _ _ _ _ _
  inst`) when inline instance search will not pick up an exact-type local `PreservesColimitsOfSize` /
  `IsIso` (universe-form mismatch). Pin functor universes (`restrictFunctor.{u}`).
- **`Presentation.ofIsIso.{u,u,u}`** — must pin universes (defaults to 0).

## Do NOT retry
- Nothing blocked this iter — all four targets solved. No anti-recommendations.
- Do NOT resurrect Route P or the `D(f)≅Spec R_f`+restrict path for `injective_acyclic` (resurrects
  the restriction-of-injectives wall Route B avoids) — standing knowledge-base guidance.
