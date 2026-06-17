# blueprint-writer directive — bw259-lbc

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Picard_LineBundleCoherence.tex`

## Task
Replace the stale `% NOTE (review iter-257):` comment block inside the proof of
`\label{lem:lbc_chart_presentation}` (`\lean{...IsLocallyTrivial.chartPresentation}`). The NOTE
currently claims the over↔restrict categorical bridge `chartOverIso` is "the SOLE remaining sorry of
this file" and that "Blueprint-writer must add a block for the bridge". Both are FALSE as of iter-258:
the local `chartOverIso` is now a redirect to the shared-root construction
`Scheme.Modules.chartOverIso` (in `AlgebraicJacobian.Picard.SheafOverEquivalence`), and the file is
locally sorry-free. The bridge is blueprinted in the `Picard_SheafOverEquivalence` chapter, not here.

## What to write
Replace the stale `% NOTE (review iter-257): ...` comment block with a short, accurate comment, e.g.:

```
% NOTE (updated iter-259): the over<->restrict categorical bridge is provided by the
% shared-root construction `Scheme.Modules.chartOverIso` (chapter
% Picard_SheafOverEquivalence, lem:chart_over_iso). The local chartOverIso def in
% LineBundleCoherence.lean is a redirect to it and carries no sorry; this file is
% locally sorry-free. No bridge block is needed in this chapter.
```

Keep the surrounding mathematical proof prose intact (the `Presentation.ofIsIso` transport sketch is
correct and stays). Only the stale NOTE comment is replaced.

## Out of scope
- Do NOT change any statement block, any other proof block, or any `\lean{...}`/`\uses{...}` list.
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT edit any other chapter.
