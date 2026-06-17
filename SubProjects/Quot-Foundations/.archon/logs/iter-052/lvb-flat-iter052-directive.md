# lean-vs-blueprint-checker — FlatteningStratification (iter-052)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

Verify bidirectionally for THIS iter's new decls + the open close:
- gf_patch_free_imp_flat (G3.1), gf_flat_base_local_on_source (G3.3), gf_stalk_flat_localBase (G3.4): do Lean signatures match their blueprint blocks (lem:gf_patch_free_imp_flat, lem:gf_flat_base_local_on_source, lem:gf_stalk_flat_localBase)?
- KEY: gf_stalk_flat_localBase blueprint prose is phrased over sheaf-module STALKS; the Lean pin is a stalk-FREE algebraic generalization (localized-base transitivity of flatness). Is the blueprint statement faithful to what Lean proves, or does it need a % NOTE / restatement?
- genericFlatness (~L2856) still sorry: does the blueprint over-promise that the stalk route is formalizable? Prover reports Mathlib has NO SheafOfModules.stalk — flag if blueprint proof relies on absent stalk infra.
Report Lean→blueprint and blueprint→Lean. Mark must-fix-this-iter findings.
