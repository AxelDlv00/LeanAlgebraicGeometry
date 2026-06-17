# Reference Retriever Report

## Slug
stacks-modules-tensor

## Status
COMPLETE

## Sources fetched

- **Stacks Project, Chapter 17 "Sheaves of Modules" (modules.tex)**
  — https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex
  — downloaded `references/stacks-modules.tex` (LaTeX source, 5939 lines, VERIFIED: begins `\input{preamble}`, is valid TeX)
  — pointer file written: `references/stacks-modules.md`

## Exact tag locations (deep map)

### (a) Tensor product definition — §17.16 (tag 01CA, line 2271)

The tensor product is defined via **prose** (no `\begin{definition}` block) at lines 2282–2296:

- **Tensor product presheaf** `F ⊗_{p,O_X} G` — rule `U ↦ F(U) ⊗_{O_X(U)} G(U)` — lines 2284–2290
- **Tensor product sheaf** `F ⊗_{O_X} G = (F ⊗_{p,O_X} G)^#` (sheafification) — lines 2291–2297
- Universal property via bilinear maps — lines 2298–2309

Key lemma tags in §17.16:
| Tag | Label | Line | Content |
|-----|-------|------|---------|
| 01CA | `section-tensor-product` | 2272 | Section label |
| 01CB | `lemma-stalk-tensor-product` | 2333 | `(F⊗G)_x = F_x ⊗ G_x` |
| — | `lemma-tensor-product-sheafification` | 2351 | sheafification commutes |
| 01CC | `lemma-tensor-product-exact` | 2365 | right-exactness of ⊗ |
| 01CD | `lemma-tensor-product-pullback` | 2393 | `f*(F⊗G) = f*F ⊗ f*G` |
| — | `lemma-tensor-commute-colimits` | 2407 | ⊗ commutes with colimits |
| — | `lemma-tensor-product-permanence` | 2440 | fin.type/fin.pres/loc.free under ⊗ |

### (b) Invertible modules + tensor powers + Γ_* — §17.25 (tag 01CR, line 4038)

| Tag | Label | Line | Content |
|-----|-------|------|---------|
| 01CR | `section-invertible` | 4039 | Section label |
| 01CS | `definition-invertible` | 4047 | Definition: invertible O_X-module (tensoring is equivalence); trivial = iso to O_X |
| — | `lemma-invertible` | 4067 | Char: invertible ↔ ∃N with L⊗N≅O_X; SheafHom(L,O_X) is the inverse |
| — | `lemma-pullback-invertible` | 4143 | f* of invertible is invertible |
| — | `lemma-invertible-is-locally-free-rank-1` | 4160 | rank-1 loc.free ↔ invertible (when stalks are local) |
| — | `lemma-constructions-invertible` | 4201 | L⊗N invertible; SheafHom(L,O_X) invertible; evaluation iso |
| 01CU | `definition-powers` | 4220 | **nth tensor power L^{⊗n}** for n∈Z (explicit formula lines 4234–4247) |
| 01CV | `definition-gamma-star` | 4269 | **Γ_*(X,L) = ⊕_{n≥0} Γ(X,L^{⊗n})** (graded ring); **Γ_*(X,L,F) = ⊕_{n∈Z} Γ(X, F⊗L^{⊗n})** (graded module) |
| — | `definition-pic` | 4350 | Picard group Pic(X) |

### (c) Blueprint chapter usage notes

The blueprint chapter `Picard_SectionGradedRing.tex` should cite:
- **Tensor product def**: `Read offset:2281 limit:30` in `stacks-modules.tex` for the verbatim prose
- **definition-powers (01CU)**: `Read offset:4220 limit:70` for both the definition and the explicit case-split formula
- **definition-gamma-star (01CV)**: `Read offset:4269 limit:20` for the graded ring and graded module definitions
- The graded multiplication `s⊗t` construction is at lines 4256–4262 (inline before the definition)

## Index updates
- `references/summary.md` — appended 1 entry: `stacks-modules`

## Notes for Dispatcher
- The tensor product in §17.16 has **no formal `\begin{definition}` tag** — it is introduced in section-opening prose (lines 2282–2296). The tags 01CC and 01CD mentioned in the directive refer to the right-exactness and pullback lemmas that follow, not to a definition block. The section tag 01CA is the correct top-level reference.
- Both the graded **ring** `Γ_*(X,L)` and the graded **module** `Γ_*(X,L,F)` live in a single `\begin{definition}` block at lines 4269–4287 (tag 01CV). This is exactly the R(X_s,L_s) and M constructions the directive names.
- The `modules.tex` chapter treats **ringed spaces** generally (not just schemes). The scheme-specific version in practice just restricts to the scheme structure sheaf.
- Related source already in `references/`: `stacks-properties.tex` already noted tag `01B5 = modules-definition-finite-type` (line 809–817 of modules.tex, `\label{definition-finite-type}`) — this is in the *same* `stacks-modules.tex` file just retrieved, at line 809.
