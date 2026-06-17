# Blueprint-clean directive — iter-235 (FlatBaseChange chapter)

## Scope
One chapter reframed this iter by blueprint-writer `fbc-reframe`:
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

Changes: (1) added the essential `[F.IsQuasicoherent]` hypothesis to the prose of
`lem:affine_base_change_pushforward` and `thm:flat_base_change_pushforward`; (2) reframed the affine
proof around `tilde` full-faithfulness (`IsIso α ↔ IsIso (moduleSpecΓ α)`, `cancelBaseChange`);
(3) added a NEW Archon-original lemma block `lem:pushforward_spec_tilde_iso` (no `\lean{}` pin —
intended next prover target) for the single Mathlib-absent brick
`pushforward(Spec.map φ)(tilde M) ≅ tilde(restrictScalars φ M)`; (4) refreshed the flat theorem's `% NOTE:`.

## Task
Validate blueprint purity of the edited chapter:
- Strip any Lean tactic syntax / Lean-leakage from the new/edited prose (math, project notation only).
- Confirm ALL pre-existing verbatim Stacks `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` blocks remain
  byte-for-byte intact (this chapter has several long ones — they MUST NOT be reflowed or altered).
- Confirm the new `lem:pushforward_spec_tilde_iso` block carries NO fabricated `% SOURCE QUOTE` (it is
  Archon-original infrastructure; an uncited block is correct) and NO `\leanok`/`\mathlibok` marker.
- Confirm no `\leanok`/`\mathlibok` markers were added/removed on any block.
- LaTeX balanced; `\input` wiring in `content.tex` unaffected (no new file).
- You MAY spawn a reference-retriever only if a citation genuinely needs a source not in references/.

Out of scope: the `def:pushforward_base_change_map` block and the 3 `lem:modules_isIso_*` locality lemmas.
