# blueprint-writer bw259-lbc — report

## Status: DONE

## Task
Replace the stale `% NOTE (review iter-258/257)` comment block inside the proof of
`lem:lbc_chart_presentation` in `blueprint/src/chapters/Picard_LineBundleCoherence.tex`.

## Change made
Single edit, lines 206–217 of `Picard_LineBundleCoherence.tex`. The stale 12-line NOTE
(which claimed the over↔restrict bridge `chartOverIso` was open / "the SOLE remaining sorry"
and that a bridge block must be added here) was replaced with a short 5-line accurate comment:

```
% NOTE (updated iter-259): the over<->restrict categorical bridge is provided
% by the shared-root construction `Scheme.Modules.chartOverIso` (chapter
% Picard_SheafOverEquivalence, lem:chart_over_iso). The local chartOverIso def
% in LineBundleCoherence.lean is a redirect to it and carries no sorry; this
% file is locally sorry-free. No bridge block is needed in this chapter.
```

## Scope adherence
- No statement block, proof block, `\lean{...}`, or `\uses{...}` touched.
- No `\leanok`/`\mathlibok` added or removed.
- No other chapter edited.
- The `Presentation.ofIsIso` transport prose (lines 200–205) left intact, as directed.

## Notes
- Comment-only change; nothing to compile. The NOTE is a LaTeX comment (`%`), so it
  does not affect rendered output or the dependency graph.
- Cross-reference to `Picard_SheafOverEquivalence` / `lem:chart_over_iso` is informational
  prose inside a comment, not a `\cref`/`\uses` link, so no graph edge is created.
