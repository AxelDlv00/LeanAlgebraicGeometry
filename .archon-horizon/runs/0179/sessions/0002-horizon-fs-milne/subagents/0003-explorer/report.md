Read-only reconnaissance complete. Current graph stats: 302 nodes, 37 Lean declarations, 5 linked blueprint nodes, 259 empty; `horizon check MilneLib` currently fails because the parallel Milne run has uncommitted changes in `MilneLib/Sheaf.lean`.

Highest-value feasible next targets:

1. `MilneLib/Sheaf.lean:37-43`, `schemeSheafEvaluationAt_naturality`
   - This is already drafted by the parallel run and is the direct missing naturality clause for blueprint `MI:ch1:5.10` (`blueprint/src/ch01-geometry.tex:~650`, node `0ab61c0d43f5`).
   - Proof is exactly `(schemeSheafEvaluation f).naturality g`.
   - Current declaration appears sound, but the same file has a separate compile error in the newly added coevaluation definition at lines 45-49.

2. Extend `MilneLib/Sheaf.lean` with the adjunction triangle identities after repairing coevaluation:
   - `schemeSheafCoevaluation_evaluation` (draft lines 72-79), using
     `pullbackPushforwardAdjunction f).left_triangle_components`.
   - The other triangle identity should use `.right_triangle_components`.
   - These are high-value completion of the sheaf evaluation API for `MI:ch1:5.10`, with no new mathematical infrastructure.

3. `MilneLib/Nakayama.lean:20-25` is the only realistic bridge toward blueprint `MI:ch1:5.11` (`blueprint/src/ch01-geometry.tex:~650+`, node `8206e8e8e5b5`):
   - The local finite-target residue-surjectivity theorem is verified.
   - Next feasible declaration is a module-level “surjective iff after localization at every maximal ideal” wrapper, if Mathlib’s localization API is acceptable; the coherent-sheaf global statement remains substantially harder and should not be attempted as a small unit.

The graph’s nominal top frontier (`Descent of varieties and coherent sheaves`, `Symmetric power`, Jacobian representability) is not feasible as a short sorry-free unit; it needs major new scheme/descent infrastructure. `Isogeny` is already linked and verified (`MilneLib/Isogeny.lean:30-49`), but no degree or composition API exists yet.
