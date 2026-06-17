# blueprint-clean directive (slug bc-tos261)

Purity gate on `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, which was just edited by a
blueprint-writer (iter-261) to (1) rewrite the `lem:dual_restrict_iso` leg-(A)/`sliceDualTransport`
paragraph from the dead route-(1) to route-(2), (2) remove three stale `\uses` edges, and (3) correct
the Sq2b prose of `lem:pullback_tensor_map_basechange` (drop the overstated extendScalarsComp framing;
remove the now-closed Sq2b from the "missing ingredients" list).

Tasks:
- Strip any Lean tactic syntax / Lean-identifier leakage that reads as code rather than math prose.
- Strip project-history / per-iter narrative ("iter-260", "the prover proved", review NOTE remnants)
  if any survived the writer's edits — the prose must be timeless mathematics.
- Keep all `% SOURCE` / `% SOURCE QUOTE` citation comments intact (esp. the Stacks 01CM
  internal-hom-pullback quote on `lem:dual_restrict_iso`).
- Do NOT add/remove `\leanok`/`\mathlibok`. Do NOT change mathematical content or `\uses` edges.
- Verify the chapter is valid LaTeX and self-consistent.
