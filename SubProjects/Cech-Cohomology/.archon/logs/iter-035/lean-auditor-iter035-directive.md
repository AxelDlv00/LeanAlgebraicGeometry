# lean-auditor directive — iter-035

Audit the two `.lean` files edited this iteration. Read them in full and report your
per-file checklist plus a flagged-issues block.

## Files (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean (NEW file this iter)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/TildeExactness.lean (4 new decls appended this iter)

## Focus areas
- Are the new declarations genuine (non-vacuous statements, real proofs), or do any
  smuggle triviality (e.g. a `def`/`theorem` whose type is degenerate, a proof that
  closes by `rfl` on something defeq-but-not-meaningful)?
- `QcohRestrictBasicOpen.lean`: check `modulesRestrictBasicOpen`, `modulesRestrictBasicOpenIso`,
  `specAwayToSpec`, `specAwayToSpec_eq`, `specBasicOpen`. Do the iso/restriction constructions
  actually express "restrict F to D(f) viewed over Spec R_f", or is the comparison iso vacuous?
- `TildeExactness.lean`: check `tilde_germ_algebraMap_smul`, `stalkMapₗ` (its `map_smul'` field is
  the claimed new content — verify it is a real R-linearity proof, not circular), `stalkMapₗ_eq`,
  `stalkMapₗ_injective`. Confirm `stalkMapₗ_eq` genuinely identifies the stalk map with the
  localised module map and is not a tautology.
- Check the module docstrings / comments in both files for any claim that contradicts the actual
  code (outdated obstruction lists, "will fix later" excuse comments, claims that a target is done
  when it is absent).
- Note any `erw`/`change`/`rfl`-bridging that is fragile or any `noncomputable`/`opaque` that hides
  a gap. (The file's three `opaque` source-scan hits in prior iters were the word inside docstrings —
  verify whether that is still the case or whether a real `opaque` was introduced.)

Report CRITICAL / MAJOR / MINOR severities. Do not assume what the strategy wants — audit the Lean
as Lean.
