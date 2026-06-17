# Blueprint Writer Directive — `Cohomology_MayerVietoris.tex` iter-135 ref cleanup

## Slug

mayervietoris-iter135

## Target chapter

`blueprint/src/chapters/Cohomology_MayerVietoris.tex`

## Strategy context

This chapter holds the Mayer–Vietoris machinery for cohomology of
presheaves of modules on a curve $C$ — Phase A scaffolding consumed by
the Stein-finiteness chain for $H^0$ / `IsHModuleHomFinite`
(`Cohomology_StructureSheafModuleK.tex`). The chapter is mathematically
complete and detailed, but the iter-135 blueprint-reviewer flagged
**three broken `\ref{...}` cross-references** that corrupt the
dependency graph. Your job is to fix them.

## Required content / changes

### Change A — fix the broken `\ref{sec:basic_open_infrastructure}` and `\ref{sec:basic_open_acyclicity}` at line 769

Line 769 (inside the section-introduction prose of
`\section{\v{C}ech acyclicity and vanishing on affines}` /
`\label{sec:cech_acyclicity}`) currently reads:

```latex
This section builds the instance-driven pipeline that converts Čech
acyclicity of a cover into the vanishing of $H^{\prime n}(U, \mathcal F)$
on affine opens. The engine is the extra-degeneracy contraction for
basic-open covers, developed in
Sections~\ref{sec:basic_open_infrastructure}--\ref{sec:basic_open_acyclicity}.
```

Neither `sec:basic_open_infrastructure` nor `sec:basic_open_acyclicity`
exists anywhere in the current blueprint sources (the iter-135
blueprint-reviewer confirmed via grep). The iter-135 blueprint-reviewer
notes that earlier pre-refactor versions of this chapter may have had
those `\label{sec:...}` blocks, but they are absent in the current TeX.
The current chapter has these `\label{sec:...}` blocks:

- `sec:hmodule_prime_cohomologyPresheaf`
- `sec:hmodule_prime_mayer_vietoris`
- `sec:scheme_affineCoverMVSquare`
- `sec:cover_totality`
- `sec:cech_acyclicity` (the section that contains line 769 itself)
- `sec:mv_use_in_project`

**Fix**: REWRITE the sentence at line 769 to remove the broken `\ref`s.
The cleanest fix is to drop the reference and rephrase descriptively:

```latex
This section builds the instance-driven pipeline that converts Čech
acyclicity of a cover into the vanishing of $H^{\prime n}(U, \mathcal F)$
on affine opens. The engine is the extra-degeneracy contraction for
basic-open covers (developed inline in the lemmas below).
```

If you are confident that the relevant material lives in some existing
labelled section of this chapter or another (you may consult the
chapter's other `\label{sec:...}` blocks and other chapters'
`\label{}`s), feel free to `\cref{...}` to the correct existing label
instead. But do NOT add new `\label{sec:basic_open_*}` blocks —
that would be inventing the missing structure rather than acknowledging
its absence.

### Change B — fix the broken `\ref{def:Scheme_IsAffineHModuleVanishing}` at line 917

Line 917 (inside the subsection
`\subsection{Affine Čech-acyclic cover carrier}`) currently reads:

```latex
The predicate $\IsAffineHModuleVanishing$
(Definition~\ref{def:Scheme_IsAffineHModuleVanishing}) requires
vanishing on every affine open. To instantiate it from Čech data, we
introduce a carrier class that bundles the existence of a suitable
cover per affine open.
```

The actual label in `Cohomology_StructureSheafModuleK.tex:358` is
`\label{thm:Scheme_IsAffineHModuleVanishing}` (the iter-135 blueprint-
reviewer flagged a label-prefix asymmetry in `Cohomology_StructureSheafModuleK.tex`:
three `\begin{definition}` blocks at lines 358 / 386 / 440 use
`\label{thm:...}` prefix while every other definition block in that
chapter uses `def:`).

Per the iter-135 blueprint-reviewer's cross-chapter recommendation
(option (b), smaller blast radius), the fix is to UPDATE the `\ref` in
`MayerVietoris.tex` to use the actual `thm:` prefix:

```latex
The predicate $\IsAffineHModuleVanishing$
(Definition~\ref{thm:Scheme_IsAffineHModuleVanishing}) requires
vanishing on every affine open. ...
```

Equivalently, prefer `\cref{thm:Scheme_IsAffineHModuleVanishing}` if the
chapter convention is `\cref` (check the chapter's other uses).
Whichever you pick, ensure the rendered target resolves.

Do NOT modify `Cohomology_StructureSheafModuleK.tex` — that is another
chapter, out of scope for this writer (and the smaller-blast-radius
option (b) explicitly leaves the ModuleK chapter's `thm:` labels in
place).

### Change C (optional, only if you notice it)

If during your sanity-check pass you discover any other `\ref{...}` in
this chapter that does not resolve to an existing `\label{}` (in this
chapter or another), fix it the same way (rephrase or point to the
correct existing label). DO NOT add new `\label{}` blocks just to
satisfy a broken `\ref`.

## Out of scope

- Do NOT touch any other blueprint chapter.
- Do NOT touch any `.lean` file.
- Do NOT add new `\label{sec:...}` blocks to satisfy the broken refs.
- Do NOT restructure or reorganise the chapter's section flow.
- The chapter's mathematical content (Mayer–Vietoris LES, ext-bridge
  lemmas, $X_4$ corner bridge, Čech-acyclicity machinery, conditional
  consumer theorems flagged with the "Producer status" remark at end
  of `sec:mv_use_in_project`) is in good shape per the iter-135
  blueprint-reviewer — do NOT modify any of it.

## References

- `task_results/blueprint-reviewer-iter135.md` § "blueprint/src/chapters/Cohomology_MayerVietoris.tex"
  (the iter-135 blueprint-reviewer's findings for this chapter).

## Expected outcome

- Two `\ref{sec:basic_open_*}` broken refs at line 769 either rephrased
  away or replaced with `\cref{...}` to existing labels.
- One `\ref{def:Scheme_IsAffineHModuleVanishing}` at line 917 fixed to
  `\ref{thm:Scheme_IsAffineHModuleVanishing}` (or `\cref{...}` form
  matching chapter convention).
- All `\ref`s in this chapter now resolve to existing `\label{}`s
  (sanity-check via grep before reporting done).
- LOC delta: roughly 0 to +5 LOC (small prose rewrites only).

Save your report to `.archon/task_results/blueprint-writer-mayervietoris-iter135.md`.
