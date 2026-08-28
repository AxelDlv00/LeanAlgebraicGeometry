Implemented and committed the canonical tensor evaluation map in [MilneLib/Tensor.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/Tensor.lean) at commit `edf75ce`.

It defines `MilneLib.tensorProductEval` using `TensorProduct.AlgebraTensorModule.lift`, with the `[simp]` pure-tensor theorem `MilneLib.tensorProductEval_tmul`. LSP diagnostics and `lake env lean MilneLib/Tensor.lean` both pass. Root integration only requires adding `import MilneLib.Tensor` to `MilneLib.lean`; that file was intentionally left unchanged.
