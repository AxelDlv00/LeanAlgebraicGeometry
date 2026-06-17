# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review134

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex
(this is the authoritative blueprint chapter for `Cotangent/GrpObj.lean` per the iter-133 + iter-134 plan-agent mapping; the per-file pointer chapter `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` was created this iter as a pointer-only — review it briefly but it is NOT the source of mathematical content)

## Known issues (do not re-report)
- 3 stale Lean-line-anchors in `Cotangent/GrpObj.lean` docstring at lines 28, 30, 31–32 (carried from iter-133); 2 stale `RigidityKbar.tex` line citations at lines 159 + 493 (also from iter-133). Already known; iter-135 cleanup writer pass scheduled.

## Scope this iter
The iter-134 prover lane added 7 new declarations to the Lean file (296 → 574 LOC):
- `AlgebraicGeometry.GrpObj.shearMulRight` (substantively closed, line ~349; `@[simps]` companion `shearMulRight_hom_fst` + `shearMulRight_hom_snd`)
- `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility` (substantive helper, line ~417; supports `PresheafOfModules.pullback`-flavored helpers)
- `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two` (PLACEHOLDER, line ~476; body `⟨Iso.refl _⟩`; type `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`; intended type per blueprint is the sheaf-level RHS using `PresheafOfModules.pullback`)
- `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section` (PLACEHOLDER, line ~508; same shape)
- `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` (PLACEHOLDER, line ~566; same shape)

Three corresponding blueprint lemma blocks in `RigidityKbar.tex` carry `\notready` markers and use `\lean{...}` macros pointing to the three placeholder declarations:
- `lem:GrpObj_mulRight_globalises` → `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (line ~282)
- `lem:GrpObj_omega_basechange_proj` → `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (line ~372)
- `lem:GrpObj_omega_restrict_to_identity_section` → `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (line ~421)

## Specific questions to answer
1. **Signature match (A) — placeholders**: the blueprint statement of `lem:GrpObj_mulRight_globalises` (informal prose at lines 324–332) and the Lean signature stub embedded in the blueprint at lines 298–305 specify the sheaf-level RHS using `PresheafOfModules.pullback`. The Lean placeholder's actual signature is `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅ Scheme.relativeDifferentialsPresheaf G.hom)`. Is this a SIGNATURE MISMATCH that must-fix-this-iter, or is it adequately disclosed by `\notready` + the iter-134 docstring intended-type prose? Report whether the `\notready` is appropriate for placeholders of this shape.
2. **Signature match (A) — substantive closes**: `shearMulRight`, `shearMulRight_hom_fst`, `shearMulRight_hom_snd`, `schemeHomRingCompatibility`. Are these matched against any blueprint block? They are NEW helper declarations added by the iter-134 prover lane; they should map to Step 1 of the blueprint proof of `lem:GrpObj_mulRight_globalises` (lines 344–352) but are NOT individually `\lean{...}`-referenced. Is this an adequacy gap on the blueprint side?
3. **Proof divergence**: the blueprint proof outline (lines 339–370) names Step 1 (shear iso), Step 2 (base-change), Step 3 (section restriction) and "Compose". The Lean closes Step 1 substantively but ships Steps 2 + 3 + Compose as `⟨Iso.refl _⟩` placeholders. Is the placeholder pattern adequate disclosure, or is this a divergence?
4. **Blueprint adequacy (B)**: the blueprint hardening from iter-133 is detailed (lines 282–500). Is it ADEQUATE for a prover to formalize Steps 2 + 3 in iter-135+? Are the cited Mathlib idioms (`KaehlerDifferential.tensorKaehlerEquiv`, `PresheafOfModules.pullback`, `PresheafOfModules.pullbackComp`, `PresheafOfModules.pullbackId`, `TopCat.Presheaf.pullback`) specific enough? Or does the prover need more help?
5. **New auxiliary chapter `AlgebraicJacobian_Cotangent_GrpObj.tex`** (just created this iter as a pointer): is its content correct? Are the 7 Lean declarations it claims to list accurate?
6. Standard checks: any `:= sorry` / placeholder bodies in non-placeholder declarations; any "TODO" / "temporary" excuse-comments; any axiom uses.
