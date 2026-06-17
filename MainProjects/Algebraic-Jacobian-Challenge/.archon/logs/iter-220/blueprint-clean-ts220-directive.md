# Blueprint Clean Directive

## Slug
ts220

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Context

A blueprint-writer round (ts220asm) this iter expanded `sec:tensorobj_dual_infra` with three new
named blocks and revised the assembly prose of `def:presheaf_internal_hom`:
- `def:presheaf_internal_hom_value` (`\lean{PresheafOfModules.InternalHom.homModule}`)
- `def:presheaf_internal_hom_slice_value` (`\lean{PresheafOfModules.InternalHom.internalHomObjModule}`)
- `lem:presheaf_internal_hom_restriction` (`\lean{PresheafOfModules.InternalHom.restrictionMap}`)
and extended the `def:presheaf_internal_hom` `\uses{}` list + assembly paragraph; it also removed a
stale `% NOTE (review iter-219)` planner comment.

## Your job

Post-write purity gate on this chapter, focused on the three new blocks and the revised
`def:presheaf_internal_hom` (but scan the whole chapter for regressions):
1. **Strip any Lean/project-history leakage** — no iteration numbers, no "iter-NNN", no session
   narrative, no Lean tactic syntax, no typeclass-wiring notes in the rendered prose. (Lean
   declaration names inside `\lean{...}` pins are fine; Lean idioms named in prose like `Over.map`,
   `pushforward₀`, `ModuleCat.of`, `PresheafOfModules.mk`/`ofPresheaf` should read as mathematical
   constructions, not Lean code — light-touch: keep them if they name a genuine mathematical
   operation, flag only if they are bare Lean tactic/API noise.)
2. **Verify the two new `% SOURCE QUOTE` blocks** (in `def:presheaf_internal_hom_value` and
   `lem:presheaf_internal_hom_restriction`) are present **verbatim** in
   `references/stacks-modules.tex` at the cited line ranges (L3508–L3514 and L3502–L3507). If a quote
   does not match the source character-for-character, fix it to match the source (or flag it).
3. **Confirm LaTeX well-formedness** — balanced `\begin/\end`, balanced braces in
   `\label`/`\lean`/`\uses`, no dangling environments.
4. Confirm the stale `% NOTE (review iter-219)` comment is gone and no other stale planner NOTEs
   remain in the section.

Do NOT add or remove `\leanok`/`\mathlibok` markers. Do NOT alter the mathematical content of the
blocks beyond purity/quote-accuracy fixes. Do NOT touch other chapters.
