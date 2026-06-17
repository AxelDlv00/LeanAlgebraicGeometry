# Blueprint-clean directive — iter-019

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (only this one changed this iter).

The blueprint-writer iter-019 made these edits; ensure the result is pure math prose (no Lean syntax
leakage, no project/iteration history, no verbosity), and that any cited source carries a verbatim
`% SOURCE QUOTE`:

1. Re-signed `lem:higher_direct_image_presheaf` to the resolution form (statement + proof rewritten).
2. Added a new engine block `def:cohomology_sheaf_is_sheafify_homology`
   (`\lean{PresheafOfModules.homologyIsoSheafify}`) — verify it is math prose, not a Lean tactic dump,
   and that its Stacks 01XJ citation (if present) has a verbatim source quote or is clearly marked as a
   project-built engine needing no external verbatim anchor.
3. Bundled 44 helper names into four blocks' `\lean{...}` lists — these are fine as-is; do not strip
   `\lean{}` lists. Just confirm no stray prose crept in.

Focus your cleaning on (1) and (2). Do NOT remove `\lean{...}` coverage names, `\uses{}` edges, or
`% SOURCE` citation blocks. Do NOT add or remove `\leanok`. If a source quote is missing for a newly
cited statement and you cannot supply it from `references/`, leave a `% NOTE:` rather than inventing one.
Report what you changed.
