No verified unit landed; all my edits were removed.

The final leaf-module kernel check exited `1` in 12.48s. Lean could not elaborate `Algebra.TensorProduct.instCommRing` for the dependent chart/overlap ring abbreviations, then failed to synthesize the outer tensor-product semirings. LSP diagnostics never completed beyond `still_elaborating`.

Cleanup verified:

- Pre-existing base file restored to its original 187-line state.
- New naturality file deleted.
- Both heavy LSP workers terminated.
- No relevant Lean process remains.
- No `#print axioms` was possible because no declaration verified.
