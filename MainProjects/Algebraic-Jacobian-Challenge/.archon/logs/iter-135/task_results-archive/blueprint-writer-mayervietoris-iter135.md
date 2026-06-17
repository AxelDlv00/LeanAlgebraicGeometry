# Blueprint Writer Report — `Cohomology_MayerVietoris.tex` iter-135 ref cleanup

## Slug

mayervietoris-iter135

## Summary

Fixed three broken `\ref{...}` cross-references in
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` as directed by
the iter-135 blueprint-reviewer. All `\ref`s in this chapter now
resolve to existing `\label{}`s.

## Changes applied

### Change A — line 769 (broken `\ref{sec:basic_open_infrastructure}` and `\ref{sec:basic_open_acyclicity}`)

Confirmed via grep over `blueprint/src/chapters/*.tex` that neither
`sec:basic_open_infrastructure` nor `sec:basic_open_acyclicity` exists
as a `\label{}` anywhere in the blueprint sources. Replaced the
broken sentence with the directive-suggested rephrase:

Before:

```latex
This section builds the instance-driven pipeline ... The engine is the
extra-degeneracy contraction for basic-open covers, developed in
Sections~\ref{sec:basic_open_infrastructure}--\ref{sec:basic_open_acyclicity}.
```

After:

```latex
This section builds the instance-driven pipeline ... The engine is the
extra-degeneracy contraction for basic-open covers (developed inline in
the lemmas below).
```

No new `\label{sec:basic_open_*}` blocks introduced (per directive: do
not invent missing structure).

### Change B — line 917 (broken `\ref{def:Scheme_IsAffineHModuleVanishing}`)

The actual label in `Cohomology_StructureSheafModuleK.tex:358` is
`\label{thm:Scheme_IsAffineHModuleVanishing}` (the `thm:` prefix is one
of three `\begin{definition}` labels in that chapter that the iter-135
reviewer flagged as prefix-asymmetric but explicitly chose to leave in
place — smaller blast radius). Updated the ref in `MayerVietoris.tex`
to point at the existing label:

Before: `Definition~\ref{def:Scheme_IsAffineHModuleVanishing}`
After:  `Definition~\ref{thm:Scheme_IsAffineHModuleVanishing}`

`Cohomology_StructureSheafModuleK.tex` was not modified (out of scope).

### Change C — no additional broken refs found

Sanity-check pass: extracted every `\ref{...}` in
`Cohomology_MayerVietoris.tex`, extracted every `\label{...}` across
`blueprint/src/chapters/*.tex`, and ran `comm -23` on the two sorted
sets. After applying Changes A and B, the set difference is empty —
every `\ref` in this chapter now resolves.

The chapter uses `\ref{...}` exclusively (no `\cref`), so both fixes
keep the established convention.

## Verification

```
$ grep -oE '\\ref\{[^}]+\}' Cohomology_MayerVietoris.tex \
    | sed -E 's/\\ref\{([^}]+)\}/\1/' | sort -u > /tmp/mv_refnames.txt
$ grep -oE '\\label\{[^}]+\}' blueprint/src/chapters/*.tex \
    | sed -E 's/.*\\label\{([^}]+)\}/\1/' | sort -u > /tmp/all_labelnames.txt
$ comm -23 /tmp/mv_refnames.txt /tmp/all_labelnames.txt
(empty)
```

All 21 unique `\ref` targets in the chapter resolve.

## LOC delta

- Line 769: 1 line edited in place (same line count, prose only).
- Line 917: 1 token edited in place (`def:` → `thm:` prefix).
- Net delta: 0 LOC.

## Out-of-scope items respected

- No other blueprint chapter touched (in particular,
  `Cohomology_StructureSheafModuleK.tex` left untouched).
- No `.lean` files touched.
- No new `\label{sec:...}` or `\label{def:...}` blocks added to
  satisfy broken refs.
- No restructuring of chapter section flow.
- No edits to mathematical content (Mayer–Vietoris LES, ext-bridge,
  $X_4$ corner bridge, Čech-acyclicity machinery, "Producer status"
  remark).

## Status

Done. Ready for blueprint-reviewer re-check at iter-136.
