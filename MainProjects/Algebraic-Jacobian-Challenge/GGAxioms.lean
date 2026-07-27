import AlgebraicJacobian.RiemannRoch.Adelic.GlobalGeneration

open AlgebraicGeometry Adelic

-- §2–§3: global generation core
#print axioms AlgebraicGeometry.Adelic.ell_sub_ell_sub_pointDivisor_eq
#print axioms AlgebraicGeometry.Adelic.evalMap_injective
#print axioms AlgebraicGeometry.Adelic.evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_vanishing

-- §4: thresholds
#print axioms AlgebraicGeometry.Adelic.exists_bound_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt

-- §5: the residue-degree equivalence
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_iff_hasRationalResidues

-- §6: consequences
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_hasRationalResidues

-- §7: the discharge
#print axioms AlgebraicGeometry.Adelic.mem_orderGe_one_iff_mem_maximalIdeal
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed
