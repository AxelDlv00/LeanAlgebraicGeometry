# Blueprint Writer Directive

## Slug
render-cohomology-mayervietoris

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Strategy context
Mayer--Vietoris long exact sequence for sheaf cohomology valued in k-modules and the Cech-acyclicity machinery.
This dispatch is a **pure rendering / cross-reference repair pass**. The mathematical
content of the chapter is already reviewed and certified correct; you are NOT changing
any mathematics. The blueprint-doctor flagged the chapter for malformed references and
delimiters that shred the rendered (`leanblueprint web`) output. Your job is to repair
exactly those defects, leaving every statement, proof, `\lean{}`, `\label{}`, and the
SEMANTIC content of every `\uses{}` unchanged.

## Required content
This chapter has the following blueprint-doctor findings to repair:
  - literal-ref: 29 occurrence(s)

Repair each occurrence, by class:

1. **literal-ref** — every literal placeholder token of the form `Definition~REF`,
   `Theorem~REF`, `Lemma~REF`, `Proposition~REF`, `Corollary~REF`, `Chapter~REF`,
   `Section~REF`, `Remark~REF`, `Exercise~REF`, `S~REF`, `Sections~REF`, `Theorems~REF`,
   etc. (grep the chapter for `REF`). Replace each with the correct `\cref{<label>}`
   pointing at the **intended** declaration. Determine the intended target by reading
   the surrounding prose and matching it to a `\label{}` in this chapter: phrases like
   "in the setting of Definition~REF", "the short complex of Definition~REF", "by
   Theorem~REF" almost always refer to a specific labelled block defined earlier in the
   same chapter (or named in the nearby proof's `\uses{}`). When a `Chapter~REF` /
   `Section~REF` points at another chapter, use `\cref{chap:...}`/`\cref{sec:...}` if
   such a label exists, otherwise name the chapter/section in prose (e.g. "the
   cohomology chapter") and drop the REF token. NEVER leave a literal `REF` in the file.
   If a target genuinely cannot be identified, rewrite the sentence to refer to the
   block descriptively by its mathematical name ("the short complex constructed above")
   and record it under Notes for Plan Agent.

2. **math-delim** — fix every interleaved or unbalanced math-delimiter site: never
   `$ ... \( ... \) ... $`, never a `\)` without a matching `\(`, never a `\(` opened
   inside `$...$`. Pick ONE delimiter style per formula. Use `\( ... \)` consistently.
   (Grep for lines mixing `$` with `\(`/`\)`.)

3. **bare-label** — a raw label id pasted into prose (e.g. `lem:depth_drops_by_one`,
   `th:main`, or a Kleiman-paper internal label) is not a reference. For a PROJECT label
   defined in the blueprint, replace it with `\cref{<label>}`. For an EXTERNAL
   paper-internal label (Kleiman "The Picard scheme" labels, etc.), replace it with the
   source's human-readable number ("Kleiman, Thm. 5.4" / "[Kleiman], Prop. 4.18") read
   from `references/kleiman-picard.md` (or the pdf/src), NOT the raw internal id.

4. **undefined-macro** — if the chapter uses a macro defined nowhere, either rewrite the
   prose to avoid it (preferred when it is Lean-ish leakage, e.g. `R.\obj X` should be
   ordinary math notation for the value of the functor R at X) or add a chapter-local
   `\providecommand{\foo}{...}` near the top of the chapter. Report any macro you think
   belongs in the shared `macros/common.tex` under Macros needed.

## Out of scope
- Do NOT alter any mathematical statement, proof argument, definition, or numeric claim.
- Do NOT add, remove, or re-target any `\uses{}` EDGE for dependency reasons — only fix a
  `\uses{}` if it literally points at a non-existent label (broken ref); the semantic
  dependency set must stay the same.
- Do NOT add `\leanok`. Do NOT add `\mathlibok` (no Mathlib anchors this round).
- Do NOT touch any block whose declaration is protected by the mathematician.
- Do NOT add new declaration blocks. This is a cleanup pass only.

## References
- `references/kleiman-picard.md` (and `references/kleiman-picard.pdf` / `-src/*.tex`) — ONLY
  needed if this chapter has `bare-label` findings citing Kleiman paper labels; use it to
  recover the human-readable theorem/proposition numbers.

## Expected outcome
The chapter renders cleanly: zero literal `REF` tokens, every cross-reference a proper
`\cref{}` (or descriptive prose), all math delimiters balanced and single-style, no bare
label ids in prose, no undefined macros. `leandag build --json` still reports
`unknown_uses: 0` (you introduced no broken refs). The mathematics is untouched.
