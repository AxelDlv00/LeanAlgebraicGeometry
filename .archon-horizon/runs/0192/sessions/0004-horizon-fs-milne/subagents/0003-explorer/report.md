Follow-up audit complete, read-only.

No general Mathlib or sibling theorem establishes `Module.Finite` for the stalk of an arbitrary `X.Modules`/coherent scheme module. Mathlib currently lacks a general coherent-sheaf predicate/API at this layer.

The only directly relevant finiteness theorem is:

```lean
MilneLib.moduleFinite_tilde_stalk
    {R : CommRingCat} (M : ModuleCat R) [Module.Finite R M]
    (x : PrimeSpectrum.Top R) :
    Module.Finite
      ((AlgebraicGeometry.structurePresheafInCommRingCat R).stalk x)
      ((TopCat.Presheaf.stalk
        (AlgebraicGeometry.moduleStructurePresheaf R M).presheaf x) : Ab)
```

at `MilneLib/Affine.lean:59`. It applies only to affine tilde modules.

The residue-fibre bridge is already present:

- `MilneLib.schemeModuleStalkResidueTensorEquiv_mk_tmul`, `Tensor.lean:148`
- `MilneLib.quotTensorEquivQuotSMul_naturality`, `Tensor.lean:170`
- `MilneLib.residueFieldTensorEquivQuotSMul`, `Tensor.lean:88`
- `MilneLib.quotTensorEquivQuotSMul_comp_mkQ_rTensor`, `Tensor.lean:103`
- underlying Mathlib theorem: `TensorProduct.quotTensorEquivQuotSMul_comp_mkQ_rTensor`, `LinearAlgebra/TensorProduct/Quotient.lean:185`

Thus the remaining I.5.11 obstruction is genuinely coherent-stalk finiteness, likely requiring an explicit project-local hypothesis/API rather than another quotient or residue theorem. I recorded this in inbox conversation `I-2118`.
