# Recommendations — after iter-026 (for the next plan iter)

## HIGH — must-fix (lean-auditor must-fix; review cannot edit `.lean`)
1. **Wire `AbsoluteCohomology.lean` into the build root.** The file compiles standalone
   (`lake env lean … → EXIT 0`, all 10 decls axiom-clean) but is **NOT imported** anywhere, so it is
   orphaned from the `AlgebraicJacobian.lean` umbrella build target. Add to `AlgebraicJacobian.lean`:
   ```
   import AlgebraicJacobian.Cohomology.AbsoluteCohomology
   ```
   Assign this to the next prover that opens any Cohomology file (a one-line edit). Until then the P5b
   absolute-cohomology output is invisible to the umbrella build and to anything that imports the root.

## HIGH — carried bookkeeping (persists from iter-025, still live)
2. **`\leanok` still missing on `lem:ses_cech_h1` and `lem:injective_cech_acyclic`.** Both are
   axiom-clean and compiling (`CechBridge.lean`), but neither carries `\leanok` after this iter's
   sync (sync added only the 4 new abscohom blocks). Almost certainly the same **build-timeout in the
   sync window** as iter-025 (CechBridge's heaviest decl needs `maxHeartbeats 2000000`). Fix is a sync
   re-run with a raised heartbeat/time budget, or pinning the heavy decl. Do NOT treat these targets as
   un-proved or re-dispatch them. (Documented in PROJECT_STATUS Known Blockers.)

## MEDIUM — blueprint coverage debt (planner authors prose; review does not)
3. **6 unmatched `lean_aux` helpers in `AbsoluteCohomology.lean`** need blueprint `\lean{}` entries
   (bundle into existing blocks or add thin blocks) so `archon dag-query unmatched` returns to 0:
   - `AlgebraicGeometry.sheafificationHomAddEquiv` — relies on
     `PresheafOfModules.sheafificationAdjunction`, `Adjunction.homEquiv_unit`, `Functor.map_add`
     (additive `forget ⋙ restrictScalars`). → bundle under `lem:jshriek_corepr`.
   - `AlgebraicGeometry.absoluteCohomologyZeroAddEquiv` (H⁰≅Γ) — relies on `Ext.homEquiv₀`,
     `Ext.mk₀_add`, `Ext.mk₀_homEquiv₀_apply`, `jShriekOU_homEquiv`. → bundle under
     `def:absolute_cohomology` (degree-zero clause) or a new `lem:abs_cohomology_zero`.
   - `AlgebraicGeometry.absoluteCohomology_eq_zero_of_injective` — relies on `Ext.eq_zero_of_injective`.
     → bundle under `def:absolute_cohomology` (injective-vanishing clause).
   - `AlgebraicGeometry.absoluteCohomology_covariant_exact₁/₂/₃` — relies on
     `Ext.covariant_sequence_exact₁/₂/₃`. → bundle under `def:absolute_cohomology` (LES clause) or
     a new `lem:abs_cohomology_les`.
   (`jShriekOU`, `jShriekOU_homEquiv`, `absoluteCohomology` are already pinned and matched.)

## MEDIUM — stale `.lean` comments (carried; needs a prover when CechBridge is next opened)
4. **`CechBridge.lean` stale comments** (lean-auditor majors, carried since iter-024/025):
   - Strategy block ~L77–119 names `HomologicalComplex.Hom.isoOfComponents` as the combinator for
     `cechComplex_hom_identification`, but the shipped impl uses `(alternatingCofaceMapComplex Ab).mapIso`.
   - "gated on Lane-1" language ~L272–283 is stale — `injective_cech_acyclic` is proved.
   Have the prover that wires in the import (rec. 1) also fix these while CechBridge is open.

## LOW — optional simplification / robustness
5. `absoluteCohomologyZeroAddEquiv` reconstructs additivity manually via `AddEquiv.mk' Ext.homEquiv₀`;
   Mathlib ships `Ext.addEquiv₀ : Ext X Y 0 ≃+ (X ⟶ Y)`. A future golf could use it directly.
6. The `erw [Functor.map_add, Preadditive.comp_add]; rfl` in `sheafificationHomAddEquiv` is genuine
   but Mathlib-refactor-fragile (flag if a Mathlib bump breaks it).

## Next frontier (genuine ready lane)
- **01EO `cech_to_cohomology_on_basis`** is now the live frontier: it consumes the new covariant-LES
  wrappers + `absoluteCohomology_eq_zero_of_injective` + `absoluteCohomologyZeroAddEquiv` together with
  the completed P3b bridge (`injective_cech_acyclic`, `ses_cech_h1`, `cechFreeComplex_quasiIso`). It is
  a sizeable dimension-shift lane — **effort-break it first** (per its blueprint sketch) before
  dispatching a prover. After 01EO comes 02KG (`affine_serre_vanishing`), which re-enables the frozen
  P5b `cech_computes_higherDirectImage`.

## Reusable proof patterns landed this iter (added to PROJECT_STATUS Knowledge Base)
- `HasExt`-as-Prop three-universe pin (`HasExt.{u+1, u, u+1}`), `local instance` to dodge
  `HasSmallLocalizedHom` TC-search.
- `AddCommGrpCat` (not `AddCommGrp`) is the Mathlib category name.
- `erw [...]; rfl` for adjunction-`homEquiv` additivity (defeq-carrier `Preadditive` mismatch).
- `Ext.comp` degree proofs need `add_zero`/explicit terms, not `by omega`; `∃ x.comp` binders need
  explicit type annotations for field-notation resolution.

## Do NOT re-assign
- The 10 `AbsoluteCohomology.lean` decls — all solved, axiom-clean.
- `ses_cech_h1`, `injective_cech_acyclic`, `cechFreeComplex_quasiIso` — solved (the missing `\leanok`
  is a sync bookkeeping artifact, NOT un-proved work; see rec. 2).
