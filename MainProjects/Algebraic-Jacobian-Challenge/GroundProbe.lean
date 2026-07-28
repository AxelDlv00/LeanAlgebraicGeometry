import AlgebraicJacobian.Albanese.AlbaneseJacobian

open CategoryTheory AlgebraicGeometry

-- (2) the central measurement
#print axioms AlgebraicGeometry.albanese_universal_property_of_symPowData_generic
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property_of_symPowData

-- (1) the interface and its inhabitant
#print axioms CategoryTheory.symPowDataOne
#print axioms CategoryTheory.SymPowData.symAVMap
#print axioms CategoryTheory.MonObj.basePointShift_comp_powSum
#print axioms CategoryTheory.symAVMap_eq_of_albanese_eq
#print axioms CategoryTheory.albanese_eq_of_symAVMap_eq
#print axioms CategoryTheory.exists_unique_albanese_factorisation
#print axioms AlgebraicGeometry.exists_unique_descent_of_section
#print axioms AlgebraicGeometry.hom_ext_of_dense_open

-- (4) AVSelfProduct
#print axioms AlgebraicGeometry.smooth_tensorObj_self
#print axioms AlgebraicGeometry.locallyOfFiniteType_tensorObj_self
#print axioms AlgebraicGeometry.geometricallyIrreducible_tensorObj_self
#print axioms AlgebraicGeometry.isReduced_tensorObj_self_left
#print axioms AlgebraicGeometry.isCommMonObj_of_isProper_smooth_of_package
#print axioms AlgebraicGeometry.isMonHom_of_pointed

-- controls
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property
#print axioms AlgebraicGeometry.Pic0.abelJacobi
