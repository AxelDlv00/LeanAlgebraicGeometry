# Blueprint Writer Directive

## Slug
a2c-fga-pic-assembly

## Target chapter
`blueprint/src/chapters/Picard_FGAPicRepresentability.tex` (NEW)

## Lean file
`AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (NEW).

Add `% archon:covers AlgebraicJacobian/Picard/FGAPicRepresentability.lean` at top.

## Strategy context

Route A.2.c — gated on A.2.b (`Picard_QuotScheme.tex`, written this iter) + A.1.c (`Picard_RelPicFunctor.tex`, written this iter). ~600-800 LOC, ~4-7 iters.

This is the small assembly chapter that wires Quot + RelPic into the representable Picard scheme. Per Kleiman §4 (FGA Explained).

## Required content

### Theorem: FGA representability of `Pic_{C/k}`
Statement (Kleiman §4 / Grothendieck FGA 232): for `C/k` smooth proper geometrically irreducible with `k`-rational point (or after étale sheafification for general `k`), the relative Picard presheaf `Pic^♯_{C/k}` (defined in A.1.c) is representable by a `k`-group scheme `Pic_{C/k}` locally of finite type.

### Proof outline (Kleiman §4 verbatim, then project notation)

Quote Kleiman §4 verbatim. Then split into sub-steps:

1. **Connect Pic to Quot**. Recognize that a line bundle `L` on `C × T` corresponds to a rank-1 quotient of the structure sheaf in a suitable Quot scheme — more precisely, parameterizes effective divisors. The connection: `Pic^♯` is built from line bundles modulo `π^*Pic(T)`; a line bundle is the same as a degree-1 quotient of `O_C(n)` for `n` large (twist).

2. **Etale sheafification**. Use the étale-sheafification step (A.1.c) to handle the case `C(k) = ∅`.

3. **Group structure**. The tensor product on line bundles makes `Pic_{C/k}` an abelian group scheme.

4. **Locally of finite type**. The Quot piece is finite type per A.2.b; the projective limit / étale-sheafification preserves finite-type when restricted to each connected component.

### Sub-lemmas

- **`lem:line_bundle_quot_correspondence`** — line bundles on `C × T` correspond to certain Quot-scheme points.
- **`thm:fga_pic_representability`** — the main statement.
- **`thm:pic_is_group_scheme`** — `Pic_{C/k}` is a group scheme.

### Lean signature targets

- `def:pic_scheme` → `AlgebraicGeometry.Scheme.PicScheme` (matches A.1.c's intended name)
- `thm:fga_pic_representability` → `AlgebraicGeometry.Scheme.PicScheme.representable`
- `thm:pic_is_group_scheme` → `AlgebraicGeometry.Scheme.PicScheme.groupSchemeStructure`

## Required citations

Read verbatim from:
- `references/kleiman-picard.pdf` §4 — Construction of the Picard scheme; the relevant theorem is "Theorem 9.4.8" or similar (locate via the TOC in `references/kleiman-picard.md`).
- `references/nitsure-hilbert-quot.pdf` §5 for the line-bundle ↔ Quot translation.

`% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT re-prove Quot representability — `\uses{thm:quot_representable}`.
- Do NOT re-prove ét-sheafification — `\uses{def:rel_pic_etale_sheafification}`.
- Do NOT touch `content.tex`.
- Do NOT scope into the identity component (`Pic⁰` is A.3, a separate chapter).

## Verification

`\input{...}` is the plan agent's job.

## Report format

Standard.
