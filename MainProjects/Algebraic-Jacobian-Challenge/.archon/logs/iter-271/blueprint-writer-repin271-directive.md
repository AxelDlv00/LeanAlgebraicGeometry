# Blueprint-writer directive — iter-271: repin Picard_TensorObjSubstrate.tex

## Scope
Edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. This is a `\lean{}`-pin
correctness pass: the blueprint-reviewer (iter-270) flagged this chapter `correct: partial`
SOLELY because ~9 `\lean{}` pins point at OLD Lean declaration names that were since renamed in
the Lean source. The math prose is sound; only the pins are stale. Fixing them clears the gate that
currently blocks both active Picard prover lanes (TensorObjSubstrate.lean and DualInverse.lean,
both covered by this chapter).

## Task
For each stale pin below, open the named Lean file, confirm the REAL current declaration name (grep
the Lean source — do NOT guess), and update the chapter's `\lean{...}` to the real name. Also fix any
`\uses{}`/`\cref{}` that referenced the old label. Reviewer-named stale pins:
- `lem:pullback_compatible_with_tensorobj` → real: `AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`
- `lem:pullback_tensor_iso` → real: `Scheme.Modules.pullbackTensorIso`
- `lem:isinvertible_implies_locallytrivial` → real: `Scheme.Modules.IsInvertible.isLocallyTrivial`
- `lem:isinvertible_pullback` → real: `Scheme.Modules.IsInvertible.pullback`
- `thm:rel_pic_addcommgroup_via_tensorobj` → real: `PicSharp.addCommGroup_via_tensorObj`
- `lem:pullback0_tensor_iso`, `lem:pullback_tensor_iso_loctriv`, `lem:jw_ismonoidal`,
  `lem:stalk_tensor_commutation_naturality_right` — locate each block, grep the Lean source for the
  current name, repin. If any block's target no longer exists in Lean at all, leave the pin as-is and
  add a `% NOTE: pin target not found in Lean source as of iter-271` comment (do NOT delete the block).

## Constraints
- Do NOT add or remove `\leanok` (managed by deterministic sync_leanok).
- Do NOT change any mathematical statement or proof prose — pins/refs only.
- Do NOT touch the `% SOURCE`/`% SOURCE QUOTE` citation comments.
- Verify each new pin name actually exists in the Lean source before writing it.

## Out of scope
Every other chapter; any Lean file; any `\leanok` marker; the route-(e) off-path section.
