# Iter-262 objectives (per-task detail)

## Lane 1 — `Picard/TensorObjSubstrate.lean` [prove] — D3′ Sq1 (CHURNING corrective)
- Target: `sheafificationCompPullback_comp` (L2480) ONLY. NOT `pullbackTensorMap_restrict` (L2598),
  NOT `exists_tensorObj_inverse` (L715, gated).
- State at iter-262 start (verified): 3 file sorries (L715 gated, L2480 Sq1, L2598 D3′-main).
- Recipe: reduced unit identity already reached iter-261; transport the two `pullbackComp` factors across
  the adjunction units (`conjugateEquiv_pullbackComp_inv`/`unit_conjugateEquiv`, `pushforwardComp=Iso.refl`,
  mirror `pullbackObjUnitToUnit_comp` L920) + `homEquiv_leftAdjointUniq_hom_app` to recover each
  `sheafCompPb _.hom` as a `B_·.unit`, then `comp_unit_app` + `unit_naturality` → `B_{h≫f}.unit`.
- Maintain-compilable (DualInverse imports this file). Fix stale header L39–44.
- Bar: 3→2 axiom-clean, or typed sorry + the blocking transport step.

## Lane 2 — `Picard/TensorObjSubstrate/DualInverse.lean` [fine-grained] — dual (STUCK corrective)
- Target: extract leg-B ε-iso as a NAMED lemma + close it (measurable), then assemble `sliceDualTransport`
  (L184) → `dual_restrict_iso` (L416).
- Recipe (`analogies/ma-legb262.md`, verified): `g := (f.appIso W').inv.hom` (CommRingCat level),
  `restrictScalars_isIso_ε_of_bijective g (ConcreteCategory.bijective_of_isIso (f.appIso W').inv)`,
  `codomainMap := inv (ε (restrictScalars g))`; `show`/`change` unit to `𝟙_ (ModuleCat ↑𝒪_Y(W'))`.
- Remaining sub-holes after leg-B: naturality (`Subsingleton.elim`), invFun (mirror), 4 `≃ₗ` laws, then
  `isoMk` naturality. `dual_unit_iso`/`dual_isLocallyTrivial` untouched (transitive close).
- Update in-file STATUS NOTE (route-1-dead / route-2-leg-B-resolved).
- Bar: ≥ close the extracted leg-B lemma (dissolves STUCK). Full close ⇒ unblocks `exists_tensorObj_inverse`.
- Reversing signal: leg-B lemma won't close WITH the recipe ⇒ deeper obstacle ⇒ planner consults stalk
  Plan-B (do NOT pivot unilaterally).

## Lane 3 — `Cohomology/CechHigherDirectImage.lean` [mathlib-build] — engine `Rⁱf_*` (sc262 must-fix)
- Target: `CechNerve` (`def:cech_nerve`) + `CechComplex` (`def:cech_complex`) real bodies, axiom-clean,
  as far as possible. NOT the downstream theorems.
- Affine-cover model first (`∏ M_{f_{i₀}} → ⋯`); cover API `𝒰.I₀`/`𝒰.X j`/`𝒰.f j`/`[Finite 𝒰.I₀]`.
  `Scheme.Modules` Abelian; `CochainComplex S.Modules ℕ` has `.homology`. Stacks 02KE–02KH.
- Import-independent (race-free). Bar: maximal axiom-clean infrastructure + a precise decomposition handoff.

## HELD
- `Picard/LineBundleCoherence.lean` — DONE, no edits.
- RPF / FGA / Albanese / RR.* / A.3 — per PROGRESS.md Held lanes.
