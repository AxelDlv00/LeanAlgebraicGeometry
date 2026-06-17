Target: AlgebraicJacobian/Picard/SectionGradedRing.lean
Action: Carrier redesign (Handle (1) from the in-file handoff note ~L544-549) so the presheaf-promotion's left/right action natural transformations can be proved. This is a STRUCTURAL change, not a proof fill.

## Problem (root-caused iter-056, ~12 routes ruled out)
`relTensorDomainPresheaf`/`relTensorTriplePresheaf` (L450-502) build restriction maps from
`(P.presheaf.map f).hom.toIntLinearMap`, whose domain is `↥((P.presheaf).obj U)`. But the
`TensorProduct.induction_on` element `m` lives in `↥(P.obj U)`. These are rfl-defeq but
SYNTACTICALLY distinct, so `TensorProduct.map_tmul` cannot unify element vs map domain — blocking
naturality of the action nat-trans `relTensorActL`.

## Required change
1. Introduce a DISTINCT ℤ-linear (or AddMonoidHom) restriction term with SYNTACTIC `↥(P.obj U) → ↥(P.obj V)`
   carriers — derived from the ModuleCat restriction `P.map f` via `ModuleCat.Hom.hom` (+ a
   `restrictScalars` carrier identity) rather than from `P.presheaf.map f`. Name it e.g.
   `objRestrict` (a private helper or a `def`). Its domain/codomain must print as `↥(P.obj U)`/`↥(P.obj V)`.
2. Rewire BOTH `relTensorDomainPresheaf` and `relTensorTriplePresheaf` to use `objRestrict` (for the
   P and Q factors; keep the middle `𝒪_X` ring-restriction factor as is) so the `obj`-carrier and the
   restriction-map domain agree by construction.
3. Add the new declaration `relTensorActL : relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`,
   component `app U := AddCommGrpCat.ofHom (RelativeTensorCoequalizer.actLmap (X.sheaf.obj.obj U)
   (P.obj U) (Q.obj U)).toAddMonoidHom` (carriers now agree). Add the sibling `relTensorActR` likewise.

## Constraints
- You introduce structure + signatures; where `map_id`/`map_comp` or the nat-trans `naturality`
  obligations do not close trivially after the rewire, leave a typed `sorry` (a iter-059 prover fills
  them on this clean architecture). Do NOT grind proofs.
- Keep all EXISTING axiom-clean decls intact (`RelativeTensorCoequalizer.*`, `relativeTensorDomainPresheaf`
  name preserved). Do not touch the parked `tensorPowAdd` section.
- File must still elaborate (sorries allowed; no hard errors). Verify with
  `lake build AlgebraicJacobian.Picard.SectionGradedRing`.
- Update/trim the L504-557 handoff comment to reflect the new architecture (note the carrier gap is
  resolved by `objRestrict`; remaining sorries are the naturality fills).
