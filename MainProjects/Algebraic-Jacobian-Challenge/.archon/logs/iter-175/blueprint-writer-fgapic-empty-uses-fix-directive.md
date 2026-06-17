# Blueprint Writer Directive

## Slug
fgapic-empty-uses-fix

## Target chapter
blueprint/src/chapters/Picard_FGAPicRepresentability.tex

## Strategy context

A.2.c (FGA `Pic_{C/k}` representability assembly) wires Quot scheme + RelPic
to get the representable Picard, per Kleiman §5 + Nitsure §5. The chapter
landed in iter-174 plan-phase. After landing, the blueprint-doctor flagged
**2 malformed `\uses{}` annotations with empty arguments** in this chapter.
plastex emits `Label '' could not be resolved` for each, then the
`leanblueprint depgraph` builder enters infinite recursion. **`leanblueprint
web` will keep crashing until every empty `\uses{}` is closed.** This is a
must-fix-this-iter blueprint hygiene issue.

## Required content

This is a NARROW SCOPE edit. Do **NOT** rewrite chapter prose; do **NOT**
add new pins; do **NOT** restructure sections. Your only job is:

1. **Locate each `\uses{}` annotation in
   `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` whose
   argument is empty** (the literal pattern is `\uses{}` with no content
   between the braces, or `\uses{a,,b}` style with an empty list item).
   Use `grep -n '\\uses{}' blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
   or open the file and find both occurrences.

2. **For each, either**:
   - **Fill in the intended label** — read the surrounding declaration
     block (the `\begin{...}\label{...}\lean{...}` it sits inside) and
     the chapter prose to infer which label was meant. Common cases:
     a definition or lemma in the same chapter whose label the writer
     remembered to declare but forgot to reference, or a definition
     in a sibling chapter (e.g., `def:relative_spec`, `def:line_bundle_on_product`,
     `thm:quot_scheme_exists`) that the prose body cites.
   - **OR delete the empty `\uses{}` entry entirely** if you cannot
     reasonably infer an intended target. Prefer deletion to fabricated
     labels.

3. **Verify each fix references an existing label** (use
   `grep -n '\\label{' blueprint/src/chapters/*.tex` to enumerate
   labels, then confirm each filled-in `\uses{label_name}` matches one).

4. **Run** (mentally — you don't have to execute this):
   `grep -n '\\uses{}' blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
   one more time to confirm zero remaining empty-argument matches.

## Out of scope

- Do NOT rewrite chapter prose.
- Do NOT add new declaration blocks.
- Do NOT change `\label{...}` or `\lean{...}` lines.
- Do NOT touch `\leanok` or `\mathlibok` markers.
- Do NOT edit sibling chapters.

## References

- `references/kleiman-picard.md` → `.pdf`/`.tex`: Kleiman, "The Picard
  scheme" — A.2.c source if you need to confirm an intended `\uses` label.
- The other 9 iter-174 chapter files (siblings): when filling in
  cross-chapter labels, ensure the label exists in a sibling — namely
  one of `Picard_RelativeSpec.tex`, `Picard_LineBundlePullback.tex`,
  `Picard_RelPicFunctor.tex`, `Picard_FlatteningStratification.tex`,
  `Picard_QuotScheme.tex`, `Albanese_*.tex`, or `RiemannRoch_*.tex`.

## Expected outcome

The chapter file after your edit has zero `\uses{}` with empty
arguments. Every `\uses{label}` resolves to an existing `\label{label}`
elsewhere in `blueprint/src/chapters/`. `leanblueprint depgraph` no
longer infinite-loops on this chapter. The blueprint-doctor's
`malformed_refs` count drops from 2 to 0 for this file. No other
edits.
