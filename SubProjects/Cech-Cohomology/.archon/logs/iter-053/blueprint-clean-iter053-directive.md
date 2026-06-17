# Directive: blueprint-clean (iter-053)

The chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` received substantial edits
this iter:
- A blueprint-writer pass: new `lem:sheafify_kills_locally_zero` block (3 site lemmas), refreshed
  `lem:cech_augmented_resolution`, folded a private helper, fixed a `def:`→`lem:` label, extended the
  `% archon:covers` list with two new files.
- A planner pass: rewrote Steps 3–4 of the `lem:cech_augmented_resolution` proof to the
  prepend-\(i_{\mathrm{fix}}\) contracting-homotopy discharger (cover-agnostic, coefficient-agnostic),
  replacing the earlier tilde/standard-cover discharger, and updated both the statement- and
  proof-level `\uses{}` accordingly.

Clean this chapter: strip any Lean tactic syntax / Lean leakage, project-history verbosity, and
iteration narrative from the PROSE (the `\operatorname{combHomotopy}`-style names for formal objects
are an accepted project convention and may stay; `% SOURCE`/`% NOTE` comments stay). Validate that
`\label{}`/`\lean{}`/`\uses{}`/`\ref{}` are well-formed and that every `\uses{}` target label exists
in the chapter set. Confirm the source quotes (`% SOURCE QUOTE`, `% SOURCE QUOTE PROOF`) are present
for the cited Stacks lemmas. Do NOT add `\leanok`. Do NOT alter the mathematical content of the
prepend-homotopy proof — only purity/formatting.
