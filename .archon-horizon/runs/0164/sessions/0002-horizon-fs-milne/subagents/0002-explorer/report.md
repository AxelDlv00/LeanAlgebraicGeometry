Reconnaissance complete; no files were edited.

The three sibling `FormalizedSources` libraries are currently placeholders:

- [MilneLib/Basic.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/Basic.lean)
- [MumfordLib/Basic.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Mumford/MumfordLib/Basic.lean)
- [HartshorneLib/Basic.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Basic.lean)

The strongest reusable conventions are in AJCR:

- [Curve/P1Aut.lean:383](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/P1Aut.lean:383): `Set.Finite` to `Finset` via `hS.toFinset`; `Finset.set_ncard_biUnion_le`; `Set.ncard_le_one`; `Set.ncard_eq_toFinset_card`; finite-field and infinite-field finite-subset constructions around lines 421–460.
- [Algebra/TwoLattice.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Algebra/TwoLattice.lean): finite-window arguments using `Finset.sup`, `Finset.exists_le`, `Finset.mem_image`, `Finset.mem_product`, `Module.finite_def`; generic induction helper `pow_smul_mem`.
- [Algebra/FlatDirectLimit.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Algebra/FlatDirectLimit.lean): finite-stage synchronization with `Finset.exists_le (Finset.univ.image stage)`.
- [Algebra/DiagonalIdeal.lean:257](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Algebra/DiagonalIdeal.lean:257): explicit singleton ideal style using `Ideal.span_le`, `Set.singleton_subset_iff`, `SetLike.mem_coe`, and `RingHom.mem_ker`.
- [Tangent/DualNumberFstKernel.lean:72](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Tangent/DualNumberFstKernel.lean:72): concise explicit `Function.Surjective` witness and `Ideal.mem_span_singleton`.

Recommended starting import is `Mathlib`; add `Mathlib.Data.Finset.Order` or finite-set-specific imports only if needed. I also recorded these findings in the `fs-milne` inbox.
