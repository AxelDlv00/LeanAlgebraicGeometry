# Blueprint Doctor

## Axiom declarations

Archon's stance is **no new axioms**. The declarations below appear as `axiom <name> : ...` under the project's `.lean` files. Resolve each one before the next iter — either remove the axiom (and supply a real proof), or, if the axiom is the mathematician's explicit boundary marker, mark it protected in `archon-protected.yaml` and document the rationale.

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` :: `gmScalingP1_chart_data_temp`
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` :: `gmScalingP1_collapse_at_zero_temp`

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- `\uses{\leanok
        thm:codim_one_extension}` — no matching `\label`

