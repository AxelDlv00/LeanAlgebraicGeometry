# Lean ↔ blueprint check — FlatBaseChange.lean (iter-002)

Verify bidirectionally one Lean file against its blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Report (a) whether the Lean follows the blueprint — fake/placeholder statements,
signature mismatches with `\lean{...}` pins, missing declarations; and (b) whether the
blueprint is adequate to guide the formalization (too thin, missing detail the Lean
clearly needed).

Specific points to check:
- The decls `base_change_map_affine_local` and `pushforward_base_change_mate_cancelBaseChange`
  vs their pinned blocks `lem:base_change_map_affine_local` and
  `lem:pushforward_base_change_mate_cancelBaseChange`.
- The known divergence: the blueprint states `lem:pushforward_base_change_mate_cancelBaseChange`
  as an *equality* (Γ(α) = cancelBaseChange⁻¹) but the Lean decl formalizes the
  `IsIso (Γ(α))` corollary. A `% NOTE:` reconciling this was added to the chapter — confirm
  the note is accurate and the divergence is acceptable (faithful), or flag if it masks a
  weaker statement.
- `affineBaseChange_pushforward_iso` vs `lem:affine_base_change_pushforward` — whether the
  residual sorry matches the blueprint's described affine-reduction step.
