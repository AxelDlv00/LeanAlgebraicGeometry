# lean-vs-blueprint-checker directive — FlatteningStratification

Compare exactly one Lean file against its blueprint chapter, bidirectionally.

Lean file:
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FlatteningStratification.lean
Blueprint chapter:
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_FlatteningStratification.tex

Focus:
1. `AlgebraicGeometry.genericFlatness` (Lean ~line covering `F : X.Modules`) vs
   blueprint `thm:generic_flatness` (\lean{AlgebraicGeometry.genericFlatness}). The
   blueprint requires `\F` COHERENT and `p` finite-type; the Lean binder `F :
   X.Modules` appears to carry no such hypothesis. Confirm or refute that the Lean
   statement is strictly weaker-hypothesised (hence false / unprovable) than the
   blueprint, and state precisely which hypotheses are missing.
2. The new `GenericFreeness.*` lemmas (exists_free_localizationAway_of_finite,
   exists_flat_localizationAway_of_finite, exists_free_localizationAway_of_moduleFinite)
   — these have NO blueprint entry. Report them as blueprint→Lean coverage gaps and
   say where in the chapter they should be anchored (they underlie
   `thm:generic_flatness_algebraic`).
Report any other signature mismatch or fake/placeholder statement you find.
