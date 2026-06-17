# Directive: audit CechBridge.lean

## Files to read
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean`

## Focus areas
- The newly-added theorem near the end of the file
  (`AlgebraicGeometry.injective_cech_acyclic`, ~lines 853–909) and its
  `set_option maxHeartbeats 2000000 in` block: is the heartbeat bump justified
  and accompanied by an explanatory comment, or is it masking a fragile proof?
- The module docstring header bullets: this iter they were edited to mark
  `ses_cech_h1` and `injective_cech_acyclic` as "proved" (previously "planned"/
  "gated"). Confirm the docstring now matches the actual file contents (no stale
  "(planned)"/"gated on Lane-1" wording remains, no over-claiming).
- General Lean hygiene: dead code, excuse-comments, `sorry`/`admit`, suspicious
  definitions, outdated comments elsewhere in the file.

Audit the Lean as Lean. Report a per-file checklist plus any flagged issues with
severity. Do NOT assume what the strategy claims should be true.
