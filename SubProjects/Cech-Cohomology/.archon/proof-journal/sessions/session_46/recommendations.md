# Recommendations for the next plan iter (post iter-046)

## Headline state
**The 01I8 keystone's LAST leaf `tile_section_localization` is CLOSED, axiom-clean.** Every ingredient of
the keystone is now present and kernel-verified. The downstream chain is fully unblocked. There is no
remaining keystone-blocking math.

## HIGH — advance the keystone chain (the route is now open)
Per the planner's own iter-046 "State for next iter": dispatch the next link in order.
1. **`qcoh_section_kernel_comparison`** — write both equalizers (deg-0/1 sheaf equalizer of `F`, and the
   `D(f)`-cover equalizer), localize the X-cover one at `f` via `IsLocalizedModule.map_exact`, match
   term-by-term using `tile_section_localization` (now available), then kernel comparison ⟹
   `Γ(X,F)_f ≅ Γ(D(f),F)`. Blueprint block `lem:qcoh_section_kernel_comparison` already present.
2. Then **`qcoh_section_isLocalizedModule`** (the keystone), then **Route B assembly** →
   unconditional `qcoh_iso_tilde_sections` → unblock the 02KG tops. Blueprint blocks
   `lem:qcoh_section_isLocalizedModule`, `lem:qcoh_isIso_fromTildeGamma` already present.
   - HARD GATE reminder: re-run blueprint-reviewer (whole-blueprint) before sending a prover at
     `qcoh_section_kernel_comparison`; confirm its chapter is `complete + correct` with no must-fix.

## HIGH — close the 2 major coverage-debt blocks (blueprint-writer)
lean-vs-blueprint `qts` flagged two **public** scaffolding decls with no blueprint block. Dispatch a
blueprint-writer on `Cohomology_CechHigherDirectImage.tex` to author minimal blocks (do NOT instruct it to
add `\leanok` — sync owns that):
- **`tileReconcileEquiv`** (`\lean{AlgebraicGeometry.tileReconcileEquiv}`) — "the `R`-linear equivalence
  between tile sections (viewed over `R` by restriction of scalars `R → R_g`) and `F`-sections over the
  image open; identity underlying map, `R`-linearity by `tile_scalar_compat'`."
- **`isScalarTower_restrictScalars_obj`** (`\lean{AlgebraicGeometry.isScalarTower_restrictScalars_obj}`) —
  "scalar-tower instance for the bundled `(ModuleCat.restrictScalars (algebraMap R S)).obj M` object."
The 3 private helpers (`tileReconcileEquiv_apply`, `tileReconcileEquiv_symm_apply`, `tile_restrict_map_apply`)
need no standalone block — bundle them into the `lem:tile_section_localization` proof block's `\uses`/`\lean`
internal scaffolding (the checker confirms private decls are correct to omit). This clears `unmatched`
6 → 1 (only the pre-existing dead `CechAcyclic.affine` remains).

## MEDIUM — fix 2 stale `\uses{}` edges on `lem:tile_section_localization` (planner owns `\uses`)
The DAG resolves but two edges misattribute dependencies (lean-vs-blueprint `qts`):
- **Statement block**: remove `lem:qcoh_finite_presentation_cover` — the Lean statement takes a presentation
  `P` directly and never invokes it. That edge belongs on `lem:qcoh_section_isLocalizedModule`.
- **Proof block**: remove `lem:tile_scalar_compat` (V=⊤ case) — the proof calls `tile_scalar_compat'`
  (general-V, = `lem:tile_scalar_compat_genV`) exclusively, via `tileReconcileEquiv`. Keep only
  `lem:tile_scalar_compat_genV` as the scalar-compat dependency.
- Optional: expand the Step 4 prose to name `tileReconcileEquiv` (the bundled-`≃ₗ[R]` reconciliation recipe)
  so a future prover sees why the bundled form — not an inline `haveI` — is needed.

## LOW — cosmetic (non-blocking; pick up opportunistically)
- The 5 `set_option maxHeartbeats 1000000 in` blocks each have their explanatory comment one line ABOVE the
  `set_option` instead of immediately after — the Mathlib style linter wants it after. (lean-auditor `iter046`.)
- 3 pre-existing `CategoryTheory.Sheaf.val` deprecations (`QcohTildeSections.lean:732/741/758) → migrate to
  `ObjectProperty.obj`. Signature-touching; future-deprecation risk only.

## Do NOT re-assign
- `tile_section_localization` — SOLVED axiom-clean. Done.
- The 2 frozen sorries (`CechHigherDirectImage.lean:679` P5b, `CechAcyclic.lean:110` dead `affine`) — frozen/superseded.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **restrictScalars-carrier base-ring descent** — route the `IsLocalizedModule` descent through the bundled
  `(ModuleCat.restrictScalars (algebraMap R R_g)).obj _` carrier so both `R`- and `R_g`-actions are
  `inferInstance`-structural; Prop scalar-tower instance (no codegen ⇒ no noncomputable hoist). Two-layer
  transport: reconcile equivs (Layer A), then `mapIso` opens transport (Layer B). Full recipe + pitfalls in
  `analogies/tile-descent-instance-shape.md` and PROJECT_STATUS.md.
- **Applied-level `rfl` bridges across base rings** — when two bundled `LinearMap`s differ in base ring,
  state the equation at the `⇑`-value/applied level (only underlying functions coincide).
- **Uniform `ModuleCat.Hom.hom` fold** — use `← ModuleCat.hom_comp` (not `← ModuleCat.comp_apply`) and close
  thin-cat morphism goals with `congrArg (… .hom) (Subsingleton.elim _ _)` (not bare `congr`/`ext` — trap).
