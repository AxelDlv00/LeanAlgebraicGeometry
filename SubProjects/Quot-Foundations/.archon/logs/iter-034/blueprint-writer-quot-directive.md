# blueprint-writer directive — Picard_QuotScheme.tex (iter-034)

Chapter: `blueprint/src/chapters/Picard_QuotScheme.tex` (consolidated:
`% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean AlgebraicJacobian/Picard/GradedHilbertSerre.lean`).
You edit ONLY this chapter. Two parts. Do NOT add `\leanok`. `\mathlibok` only on genuine Mathlib anchors.

## Strategy context — gap1 P1
The keystone `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (@~3227, P1 of gap1) and its slice-touching
infrastructure (`def:over_restrict_equiv` @~3027, `lem:over_restrict_pullback_iso` @~3195). iter-033 built
4 new infra decls toward P1; this iter the prover builds the P1 keystone via a 5-step recipe. The chapter
needs coverage blocks for the new infra + the P1 proof refreshed to the 5-step recipe.

## PART A — Coverage blocks for the new infra decls (clear coverage debt)

Add a blueprint block each (statement + `\label` + `\lean{full.Lean.Name}` + accurate `\uses{}` +
≥1-line informal proof), placed near `lem:over_restrict_iso` / `lem:over_restrict_pullback_iso`:

1. `AlgebraicGeometry.isIso_unitToPushforwardObjUnit_of_isIso'` (PRIVATE — `\lean{}` resolves
   project-internally) [`lem:isIso_unitToPushforwardObjUnit_of_isIso`]: for a continuous site functor `F`
   and a ring-sheaf comparison `ψ : S ⟶ (F.sheafPushforwardContinuous …).obj R` with `IsIso ψ`, the
   canonical `SheafOfModules.unitToPushforwardObjUnit ψ` is an iso (reflect through `toSheaf`/`sheafToPresheaf`
   + componentwise `forget₂`-preserves-iso). Note in the block: Mathlib proves this only under `F.Final`;
   this `IsIso ψ`-driven form is the project addition. `\uses{}` the relevant Mathlib pushforward labels.
2. `AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso` (def) [`def:over_restrict_unit_iso`]:
   `(overRestrictEquiv U).functor.obj (unit (X.ringCatSheaf.over U)) ≅ unit U.toScheme.ringCatSheaf`
   (the slice equivalence functor preserves the structure-sheaf module). `\uses{lem:isIso_unitToPushforwardObjUnit_of_isIso, def:over_restrict_equiv}`.
3. `AlgebraicGeometry.Scheme.Modules.overRestrictPresentation` (def) [`def:over_restrict_presentation`]:
   `(M.over U).Presentation → ((pullback U.ι).obj M).Presentation`, via `Presentation.ofIsIso
   (overRestrictPullbackIso U M).hom (Presentation.map P (overRestrictEquiv U).functor (overRestrictUnitIso U))`.
   `\uses{def:over_restrict_unit_iso, lem:over_restrict_pullback_iso, lem:presentation_map_mathlib}`.
4. `AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData` (def)
   [`def:presentation_pullback_iota_of_qcoh_data`]: for `M` with `QuasicoherentData q` and `i : q.I`, a
   `Presentation` of `(pullback (q.X i).ι).obj M`, via `overRestrictPresentation (q.X i) M (q.presentation i)`.
   `\uses{def:over_restrict_presentation}` + the `QuasicoherentData` label.

## PART B — Refresh the `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (P1) proof to the 5-step recipe

Replace/expand the P1 proof body (@~3227) with the verified 5-step recipe (from the QUOT-P1 prover handoff):
1. `N := (pullback (q.X i).ι).obj M` with global presentation `PN := presentationPullbackιOfQuasicoherentData M q i`.
2. `W : Z.Opens` (Z = (q.X i).toScheme) the open corresponding to `D(r)` (`D(r) ≤ q.X i`); produce the
   slice presentation `PNW : (N.over W).Presentation` from the GLOBAL `PN` via `Presentation.map PN
   (pushforward (𝟙 (Z.ringCatSheaf.over W))) (by rfl)` (the `Presentation.quasicoherentData` construction;
   no new unit-iso — comparison is `𝟙`).
3. `PW := overRestrictPresentation W N PNW : ((pullback W.ι).obj N).Presentation`.
4. `W` is affine (`W ≅ D(r)`, a basic open of `Spec R`); transport `PW` across the iso
   `W.toScheme ≅ Spec (Localization.Away r)` (`IsAffineOpen.isoSpec`) via `Presentation.map PW
   (pullback isoSpec.hom) η_iso` with `η_iso := asIso (pullbackObjUnitToUnit _)` — AVAILABLE from Mathlib
   because an iso's `Opens.map` is `Final` (`[F.Final] : IsIso (pullbackObjUnitToUnit φ)`, PullbackFree.lean).
5. Conclude `IsIso ((M|_{D(r)}).fromTildeΓ)` by `isIso_fromTildeΓ_of_presentation` (`lem:isIso_fromTildeΓ_of_presentation_mathlib`).
Add a `% NOTE:` recording the DEAD END (do not retry): the direct geometric open-immersion route
(`pullback j` for open immersion `j : Spec A ⟶ Z`) is blocked — it needs `Functor.Final (Opens.map j.base)`,
which is NOT an instance for open immersions; the `overRestrictPresentation`-then-iso route sidesteps this.
Update `\uses{}` to: `def:presentation_pullback_iota_of_qcoh_data, def:over_restrict_presentation,
lem:isIso_fromTildeΓ_of_presentation_mathlib` + the Mathlib `pullbackObjUnitToUnit` / `IsAffineOpen.isoSpec`
anchors. Add `\mathlibok` anchor blocks for `SheafOfModules.pullbackObjUnitToUnit` (Final instance) and
`AlgebraicGeometry.IsAffineOpen.isoSpec` if not already present.

## PART C — D citation NOTE (no statement change)
`lem:section_localization_descent` (D, @~3273, the keystone sequenced AFTER P1) currently cites
"Stacks 01HA". The strategy-critic flags this tag as uncorroborated against `references/summary.md`.
Add a `% NOTE: citation tag "Stacks 01HA" UNVERIFIED — confirm against the source (candidate: Hartshorne
II.5.3) before this block is dispatched to a prover.` Do NOT change the statement; D is not this iter's target.

## Out of scope
The 4 protected stubs; D's proof; gap1 assembly; SNAP; the annihilator nodes. Do not touch other chapters
or add `\leanok`. Authorize a child reference-retriever only if needed for the D tag check (optional).
