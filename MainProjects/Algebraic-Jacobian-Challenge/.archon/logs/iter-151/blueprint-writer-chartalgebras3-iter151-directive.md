# Blueprint Writer Directive

## Slug
chartalgebras3-iter151

## Target chapter
blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex

## Strategy context
This pointer chapter backs `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`,
the four (S3.*) sub-claims of the chart-algebra "constants" substep (proving
`Γ(X, O_X) ≅ k` for a proper geometrically-irreducible smooth `X/k`). The
iter-151 blueprint review flagged this chapter `correct: partial` for carrying
THREE stale wrong Stacks tag numbers, and noted its `% NOTE` cites
`references/*.md` index files that no longer exist on disk. The genuine Stacks
chapter sources are now bundled in-tree; this round corrects the tags and adds
verbatim source-citation blocks.

## Required content

### 1. Fix the three wrong Stacks tags (must-fix)
In the bullet list (around L41, L46, L52), replace:
- `0334` → `035U`  (geometrically reduced schemes)
- `0BJF` → `0BUG`  (the 8-part `Γ(X,𝒪_X)` lemma; part (4) gives geom-reduced ⇒ separable)
- `05DH` → `030K`  (separable-then-purely-inseparable factorisation, Lemma 9.14.6)
Mirror the corrections already applied in `RigidityKbar.tex` (its `% NOTE`
render-fix blocks).

### 2. Retarget the dangling `% NOTE` reference pointers (around L60–72)
The NOTE cites `references/stacks-0334.md`, `references/stacks-0BJF.md`,
`references/stacks-05DH.md` — these files DO NOT EXIST. Retarget to the bundled
genuine chapter sources that DO exist:
- `references/stacks-varieties.tex` (tags 035U §33.6, 04QM §33.25, 056T Lemma 33.25.4, 0BUG Lemma 33.9.3)
- `references/stacks-fields.tex` (tags 09HD §9.14, 030K Lemma 9.14.6)
- `references/stacks-coherent.tex` (tag 02KH Lemma 30.5.2)

### 3. Add verbatim source-citation blocks for the four (S3.*) lemmas
For each lemma block, add (per the project's citation discipline): a `% SOURCE:`
comment naming the tag + the bundled file it was read from; a `% SOURCE QUOTE:`
comment containing the VERBATIM statement copied from the bundled `.tex` (Stacks
English, original notation, character-for-character — do NOT paraphrase); and a
visible `\textit{Source: Stacks Tag <tag>.}` first line in the prose.
- (S3.sep.1) smooth ⇒ Γ geometrically reduced ← read `references/stacks-varieties.tex`:
  the "Geometrically reduced schemes" section (035U, near L323) and Lemma
  33.25.4 / Tag 056T (smooth ⇒ geom regular/normal/reduced, near L4617).
- (S3.sep.2) geom-reduced finite ext ⇒ separable ← read `references/stacks-varieties.tex`:
  Lemma 33.9.3 / Tag 0BUG (near L1933), specifically **part (4)** (near L1944).
- (S3.pi.1) flat base change of Γ for proper schemes ← read `references/stacks-coherent.tex`:
  Lemma 30.5.2 / Tag 02KH (near L948), specifically the H^0 / part (2) form.
- (S3.pi.2) finite-dim ext, unique min prime after ⊗k̄ ⇒ purely inseparable ←
  read `references/stacks-fields.tex`: §9.14 / Tag 09HD (near L1573) and Lemma
  9.14.6 / Tag 030K (near L1704).

You MUST open each bundled `.tex` and copy the statement verbatim. Quote the
exact `\begin{lemma}...\end{lemma}` (or definition) body. Do not invent text.

## Out of scope
- Do NOT edit `RigidityKbar.tex` or any other chapter (this round is the
  pointer chapter only).
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed elsewhere).
- Do NOT change the Lean `\lean{...}` hints or lemma signatures.
- Do NOT attempt to re-prove or change the deferred-status notes on (S3.pi.*).

## References
- `references/stacks-varieties.tex` — tags 035U, 04QM, 056T, 0BUG.
- `references/stacks-fields.tex` — tags 09HD, 030K.
- `references/stacks-coherent.tex` — tag 02KH.
- `references/summary.md` — the index mapping tags → bundled files.

## Expected outcome
The pointer chapter has correct Stacks tags (035U/0BUG/030K), its `% NOTE`
points at the bundled `.tex` files that actually exist, and each of the four
(S3.*) lemma blocks carries a verbatim `% SOURCE QUOTE:` copied from the
genuine Stacks source plus a visible `\textit{Source: …}` line.
