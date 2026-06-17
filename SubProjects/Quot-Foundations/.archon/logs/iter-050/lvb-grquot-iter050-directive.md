# Lean-vs-blueprint check

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

NEW FILE this iter. Axiom-clean: `globalUnitSection`, `scalarEnd`, `chartQuotientMap`
(`def:gr_chart_quotient`). Scaffolds (sorry): `Scheme.Modules.glue`, `Grassmannian.universalQuotient`,
`Grassmannian.tautologicalQuotient`, `Grassmannian.functor`, `Grassmannian.represents`.

Verify bidirectionally:
- Lean→blueprint: do `chartQuotientMap` + the 5 scaffold signatures match the blueprint statements
  (`\lean{}` names, the transition-iso form `f_{ij}^* M_i ≅ (t_{ij}∘f_{ji})^* M_j` of `glue`,
  `represents` being `RepresentableBy` = data not Prop ⇒ `noncomputable def`)?
- blueprint→Lean: is the chapter detailed enough to guide these; are `globalUnitSection`/`scalarEnd`
  (scalar-endomorphism plumbing) missing blueprint blocks; any placeholder/fake statements.
Report must-fix items.
