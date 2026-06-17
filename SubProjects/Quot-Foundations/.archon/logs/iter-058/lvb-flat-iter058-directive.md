# lean-vs-blueprint-checker — FlatteningStratification, iter-058

One file, one chapter:
- Lean: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- Blueprint: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

Verify bidirectionally:
- Lean→blueprint: do the 4 new helpers (`flat_of_ringEquiv_semilinear`, `flat_localization_models`,
  `gf_flat_isLocalizedModule_sameBase`, `isLocalizedModule_powers_restrictScalars`) have blueprint
  coverage / `\lean{}` pins? They are currently leandag-unmatched (no tex entry).
- blueprint→Lean: do `\lean{}` pins resolve to existing decls? Is `thm:generic_flatness`'s sketch
  detailed enough to guide closing the single remaining `flatV` STEP-3 semilinearity sorry?
- Flag any signature mismatch or stale pin.
