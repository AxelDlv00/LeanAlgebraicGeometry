# Blueprint-clean directive — iter-222 — chapter `Picard_TensorObjSubstrate.tex`

## Scope

The blueprint-writer ts222 just made a small, surgical edit to ONE block of
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`: the lemma `lem:internal_hom_eval`
(currently lines ~2608–2655). It added (a) a `% NOTE:` comment after the
`\lean{PresheafOfModules.internalHomEval}` line, (b) two sentences of assembly prose at the
end of the proof body, and (c) a `\uses{lem:presheaf_internal_hom_restriction}` cross-ref in
the proof.

## Task

Run the standard post-writer purity pass, focused on the `lem:internal_hom_eval` block (but
do a normal whole-chapter scan for any leakage the edit may have introduced):

- Strip any Lean tactic syntax / Lean leakage that may have crept into the new prose (there
  should be none — the writer reported math-only prose with only `\mathtt{...}` object names
  and a `% NOTE:` cross-reference; verify).
- Remove project-history / iteration-narrative verbosity if any was added.
- Confirm the `% SOURCE` / `% SOURCE QUOTE` citation block on `lem:internal_hom_eval` is intact
  and unchanged (Stacks "Modules on Ringed Spaces", §Internal Hom, tag area 01CM). Do NOT
  fabricate or alter quotes; if a quote is missing/broken, flag it — do not invent one.
- Confirm the new `\uses{lem:presheaf_internal_hom_restriction}` resolves to an existing label
  in this chapter (it does — `lem:presheaf_internal_hom_restriction` is at ~line 2533).

## Out of scope / DO NOT

- Do NOT add or remove `\leanok` / `\mathlibok` markers.
- Do NOT change the lemma statement or the `\lean{}` pin.
- Do NOT touch any other block (`def:presheaf_dual`, `lem:internal_hom_isSheaf`,
  `lem:dual_isLocallyTrivial`, the remarks, or the earlier presheaf-internal-hom blocks).
- references/** authorized only as a safety net if a missing source quote must be retrieved;
  none is expected.
