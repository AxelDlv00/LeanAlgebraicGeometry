# Lean ↔ Blueprint Checker Directive

## Slug
ts248

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
The review agent already knows and does NOT want re-reported:
- `lem:epsilon_presheaf_to_sheaf_unit` / `epsilonPresheafToSheafUnit` is intentionally NOT formalized: the blueprint LHS `Functor.LaxMonoidal.ε (SheafOfModules.pushforward φ)` is ill-typed (no `Functor.LaxMonoidal` instance on the sheaf pushforward at the pinned commit; only the presheaf `presheafPushforwardLaxMonoidal` exists). A `% NOTE:` already flags this; it must be restated at the `.val` level. Confirm the diagnosis if you can, but do not file it as a new finding.
- The linchpin lemma `sheafificationCompPullback_eq_leftAdjointUniq` (closed by `rfl`, axiom-clean) currently has NO `\lean{...}` blueprint block; the review agent has already recommended the plan agent add one. You may CONFIRM it is unreferenced but do not re-derive that recommendation.
- The single file `sorry` at L1672 inside `pullbackEtaUnitSquare` (the (∗∗) residual) and the pre-existing `exists_tensorObj_inverse` sorry at L692 are both known/intentional. `pullbackTensorMap_unit_isIso` correctly carries `sorryAx` transitively. Do not flag these as placeholders.
- The deprecated `Sheaf.val` warnings and the L465 prose-comment "opaque" are known/benign.

## What I most want from you
Focus your value on: (a) do the freshly-landed decls `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `pullbackEtaUnitSquare`, `pullbackTensorMap_unit_isIso` have signatures that match their `\lean{...}` blueprint blocks (`lem:comp_homequiv_factor_sheafify_pullback`, `lem:leftadjointuniq_app_unit_eta`, `lem:eta_bridge_unit_square`, `lem:pullback_tensor_iso_unit`)? (b) Do their proofs/statements match the prose telescope in the "unit square (D2′)" subsection? (c) Is any OTHER `\lean{...}` pin in this chapter pointing at a renamed/absent declaration?
