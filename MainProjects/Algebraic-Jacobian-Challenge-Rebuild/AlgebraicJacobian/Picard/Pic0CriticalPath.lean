/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepAffChallenge
import AlgebraicJacobian.Picard.Pic0HighDegreeRouteGuard

/-!
# Narrow root for the AJCR-first Picard strategy

This root deliberately imports only the current producers on the reviewed route. Every later
contract endpoint must be checked here before it receives critical-path credit.

The rank-one locus, canonical inverse, separably closed cover, representability, descent, and
`JacobianData` declarations do not yet exist. They are not replaced here by axioms or local
hypotheses.
-/

#check AlgebraicGeometry.divFunctorAff_representableBy_at
#check AlgebraicGeometry.divFunctorAff_genus_representableBy
#check AlgebraicGeometry.divFunctorAff_admissible_representableBy
#check AlgebraicGeometry.not_injective_abelSigmaChart_of_divFamZar
#check AlgebraicGeometry.not_isOpenImmersion_abelSigmaChart_of_not_injective_chartValue
#check AlgebraicGeometry.not_isOpenImmersion_abelSigmaChart_of_genus_lt_degree

#print axioms AlgebraicGeometry.divFunctorAff_representableBy_at
#print axioms AlgebraicGeometry.divFunctorAff_genus_representableBy
#print axioms AlgebraicGeometry.divFunctorAff_admissible_representableBy
#print axioms AlgebraicGeometry.not_isOpenImmersion_abelSigmaChart_of_genus_lt_degree
