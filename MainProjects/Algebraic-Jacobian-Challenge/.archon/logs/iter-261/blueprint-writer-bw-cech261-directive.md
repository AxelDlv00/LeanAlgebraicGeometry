# blueprint-writer directive — `Cohomology_CechHigherDirectImage.tex` (slug bw-cech261)

You may edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (+ `references/**` if
you need to re-open a source for a verbatim quote). Do NOT add/remove `\leanok`/`\mathlibok` markers.

## Problem (deterministic blueprint-doctor finding)
The chapter contains many `\ref{lemma-cech-cohomology-quasi-coherent}`,
`\ref{lemma-cech-cohomology-quasi-coherent-trivial}`, `\ref{lemma-flat-base-change-cohomology}`,
`\ref{lemma-quasi-coherence-higher-direct-images-application}`,
`\ref{lemma-quasi-coherent-affine-cohomology-zero}` (and 2 more) which point at **no `\label{}`
anywhere in the blueprint**. These are **Stacks-project internal lemma names**, not local blueprint
labels — the author used the `\ref{}` macro where a plain Stacks tag citation was meant. They break
the blueprint DAG and render as "??" in the visible `\textit{Source: ...}` lines (e.g. ~L121, L177,
L290).

## Fix (citation hygiene only — NO new mathematical content)
Convert every `\ref{lemma-cech-*}` / `\ref{lemma-flat-base-change-cohomology}` /
`\ref{lemma-quasi-coherent-affine-cohomology-zero}` / `\ref{lemma-quasi-coherence-higher-direct-images-application}`
that targets a **Stacks-internal lemma name** into a plain-text Stacks tag citation, e.g.
`Stacks, Tag 02KE (\texttt{lemma-cech-cohomology-quasi-coherent})` in the visible `\textit{Source:}`
lines, and the analogous plain text inside the `% SOURCE QUOTE` / `% Lemma ...` comments. Use the tags
already present in the chapter (02KE, 02KH, etc.) and `references/stacks-coherent.tex` (Tag 02KH) /
the Čech-cohomology Stacks chapter for the correct tag numbers; if you cannot determine a tag with
certainty, cite the lemma by its Stacks label-name in `\texttt{...}` plain text WITHOUT `\ref{}`.

Do NOT convert genuine LOCAL cross-references — the chapter's own labels
(`def:cech_nerve`, `def:cech_complex`, `lem:cech_acyclic_affine`, `lem:cech_computes_cohomology`,
`def:cech_higher_direct_image`, `lem:cech_flat_base_change`) are correct and must keep their `\ref{}`
/ `\cref{}` form.

## Covers-line note
The chapter's `% archon:covers AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` points at a
`.lean` file that does not yet exist — this is intentional forward-spec (the file is scaffolded next
iter). Leave the covers-line as is; do NOT remove it.

## Goal
After this edit the chapter must have **zero broken `\ref{}`** (every `\ref`/`\cref` resolves to a
local `\label`), so the doctor stops flagging it and the chapter is clean for a file-skeleton scaffold
of `Cohomology/CechHigherDirectImage.lean` next iter. If any broken `\ref` genuinely refers to a
lemma that SHOULD be a local blueprint block (not a Stacks citation), report that in your output
rather than inventing the block — I will scope it separately.
