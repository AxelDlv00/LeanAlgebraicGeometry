# Blueprint Writer Report

## Slug
pic0-identity-component-chapter

## Status
COMPLETE

The chapter `blueprint/src/chapters/Picard_IdentityComponent.tex` was
created from scratch with all five required declarations + four proof
blocks (declaration 1 is a structural definition without proof; the
identity-component existence theorem 2, the Pic-zero abelian-variety
theorem 5, and the two definitions 3 & 4 are the four substantive
blocks; theorem 5 carries the assembled proof). Citation discipline
was followed for every block; no fabricated quotes.

## Target chapter
blueprint/src/chapters/Picard_IdentityComponent.tex

## Changes Made
- **Added definition** `\definition`/`\label{def:identity_component_group_scheme}`/`\lean{AlgebraicGeometry.GroupScheme.IdentityComponent}` — abstract identity component of a $k$-group scheme l.f.t.; substrate matches Kleiman §5 Lem. lem:agps.
- **Added theorem** `\theorem`/`\label{thm:identity_component_open_subgroup}` — the identity component is an open and closed subgroup scheme of finite type, geometrically irreducible, and formation commutes with extending $k$.
  - Proof sketch added: Y; reproduces Kleiman's proof of lem:agps part (3), explicit step-by-step (closedness via closure of connected subspace; openness via EGA I 6.1.9; subgroup via $\alpha(G^0 \times G^0)$ landing in $G^0$; geometric irreducibility via translation by $U \cdot g^{-1}$; quasi-compactness via $U \times U$ affine).
- **Added definition** `\definition`/`\label{def:pic_zero_subscheme}`/`\lean{AlgebraicGeometry.Scheme.Pic0Scheme}` — $\Pic^0_{C/k} := (\Pic_{C/k})^0$ via the abstract substrate; relays the four properties of lem:agps to Pic.
- **Added definition** `\definition`/`\label{def:divisor_degree_pic}`/`\lean{AlgebraicGeometry.Scheme.PicScheme.degree}` — degree map $\Pic_{C/k}(k) \to \mathbb Z$ as the leading coefficient of the Hilbert polynomial $\chi(C, \mathcal L^n) = n \cdot \deg \mathcal L + 1 - g$; identified with the index of the connected component under the Hilbert-polynomial decomposition.
- **Added theorem** `\theorem`/`\label{thm:pic_zero_is_abelian_variety}`/`\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}` — $\Pic^0_{C/k}$ is an abelian variety of dimension $g$; $\Pic^0_{C/k}(k) = \ker(\deg)$.
  - Proof sketch added: Y; assembled from four inputs — (a) open-and-closed + finite-type + geom-irreducible from `\cref{thm:identity_component_open_subgroup}`; (b) quasi-projective from Kleiman §5 Thm. th:qpp&p (geometrically integral case); (c) projective via the geometrically-normal upgrade in th:qpp&p (smooth curve $\Rightarrow$ geometrically normal); (d) smoothness + dim = $g$ via Kleiman §5 Cor. cor:sm and Ex. ex:jac (the smooth-proper-curve specialisation of the generalised-Jacobian smoothness).

## Cross-references introduced
All cross-chapter `\uses` labels were verified against the on-disk
sibling chapters at writing time:

- `def:pic_scheme` — exists in `Picard_FGAPicRepresentability.tex:493`.
- `thm:fga_pic_representability` — exists in `Picard_FGAPicRepresentability.tex:170`.
- `thm:pic_is_group_scheme` — exists in `Picard_FGAPicRepresentability.tex:408`.
- `def:hilbert_polynomial` — exists in `Picard_QuotScheme.tex:62`.
- `def:genus` — exists in `Genus.tex:16`.
- `chap:Albanese_AlbaneseUP` — referenced only in the "Out of scope"
  section to point at the A.4.d.ii Albanese-UP chapter; label exists in
  `Albanese_AlbaneseUP.tex:2`.

Internal labels added (defined in this chapter):

- `chap:Picard_IdentityComponent`, `sec:pic0_setup`,
  `sec:identity_component_abstract`, `sec:pic0_definition`,
  `sec:pic_degree`, `sec:pic0_abelian_variety`,
  `sec:pic0_lean_encoding`, `sec:pic0_out_of_scope`,
  `sec:pic0_consistency_check`.
- `def:identity_component_group_scheme`,
  `thm:identity_component_open_subgroup`, `def:pic_zero_subscheme`,
  `def:divisor_degree_pic`, `thm:pic_zero_is_abelian_variety`.

## References consulted

- `references/abelian-varieties.md` — index file for Milne; used to
  locate §III.6 (Albanese), §III.1 (degree map + dim = genus), and
  §I.1 (definition of abelian variety) with correct PDF page offset.
- `references/abelian-varieties.pdf` pages 110–112 — Milne §III.6
  Prop 6.1, Prop 6.4, Rmk 6.5 (read but not directly quoted — these
  blocks are the Albanese-UP material, which is `\input` by the
  sibling A.4.d.ii chapter, not this chapter; consulted to confirm
  the boundary between A.3 and A.4.d.ii is in the right place).
- `references/abelian-varieties.pdf` pages 91–94 — Milne §III.1
  ("Overview and definitions" + "Definitions and main statements"):
  verbatim quote for `def:divisor_degree_pic` ("the degree of a
  divisor $D = n_i P_i$ on $C$ is $n_i [k(P_i):k]$… $\deg(\mathcal L)$
  is the leading coefficient"), and Rmk 1.4(e) on p.86 ("The dimension
  of $J$ is the genus of $C$") quoted in `% SOURCE QUOTE PROOF` for
  `thm:pic_zero_is_abelian_variety`.
- `references/abelian-varieties.pdf` pages 13–15 — Milne §I.1
  ("Definitions; Basic Properties"): verbatim source for the
  definition of an abelian variety ("A complete connected group
  variety is called an abelian variety. As we shall see, they are
  projective, and (fortunately) commutative.") quoted in the
  `thm:pic_zero_is_abelian_variety` prose via `\textit{Source: …
  Milne §I.1 …}`.
- `references/kleiman-picard.md` — index file for Kleiman; used to
  locate §5 (identity-component construction) results (lem:agps,
  prp:pic0, th:qpp&p, cor:sm, cor:ch0, ex:jac, rmk:Jac) at the
  exact source-line positions.
- `references/kleiman-picard-src/kleiman-picard.tex` L2836–L2911 —
  the §5 opening + Lem. lem:agps + its proof: verbatim source for
  `def:identity_component_group_scheme` and
  `thm:identity_component_open_subgroup` (statement) and for the
  proof of `thm:identity_component_open_subgroup` (the parts
  reproduced in `% SOURCE QUOTE PROOF`).
- `references/kleiman-picard-src/kleiman-picard.tex` L2921–L2929 —
  Prp. prp:pic0: verbatim source for `def:pic_zero_subscheme`.
- `references/kleiman-picard-src/kleiman-picard.tex` L2935–L2939 —
  Thm. th:qpp&p (quasi-projectivity / projectivity of
  $\Pic^0_{X/k}$): quoted inside `% SOURCE QUOTE PROOF` for
  `thm:pic_zero_is_abelian_variety`.
- `references/kleiman-picard-src/kleiman-picard.tex` L3260–L3451 —
  Thm. thm:tgtsp + Cor. cor:sm + Cor. cor:ch0 (tangent space at 0
  and the dimension bound): inspected to verify that the Cor.~cor:sm
  smoothness/dimension statement was being faithfully transmitted to
  `thm:pic_zero_is_abelian_variety` (the dimension is $g$ once we
  know smoothness at 0, which ex:jac provides for smooth curves).
- `references/kleiman-picard-src/kleiman-picard.tex` L3910–L4016 —
  Ex. ex:jac + Rmk. rmk:Jac: verbatim source for the smoothness +
  dim = $g$ specialisation in `thm:pic_zero_is_abelian_variety`
  (quoted in `% SOURCE QUOTE`).
- `references/summary.md` — index; confirmed the slugs and the local
  filename layout (kleiman-picard.md → kleiman-picard.pdf →
  kleiman-picard-src/kleiman-picard.tex).

Citation count per source file (counts `% SOURCE: …` block headers):

| Source file | Citation blocks |
|---|---|
| `references/kleiman-picard-src/kleiman-picard.tex` | 3 (def:identity_component_group_scheme, thm:identity_component_open_subgroup, def:pic_zero_subscheme) |
| `references/kleiman-picard-src/kleiman-picard.tex` (`% SOURCE QUOTE PROOF` for `thm:pic_zero_is_abelian_variety`) | 2 (th:qpp&p + cor:sm) |
| `references/kleiman-picard-src/kleiman-picard.tex` (`% SOURCE QUOTE` for `thm:pic_zero_is_abelian_variety`) | 2 (ex:jac + rmk:Jac) |
| `references/abelian-varieties.pdf` | 2 (def:divisor_degree_pic, thm:pic_zero_is_abelian_variety — `\textit{Source}` line names Milne §I.1 + Rmk III.1.4(e)) |
| `references/abelian-varieties.pdf` (`% SOURCE QUOTE PROOF` for `thm:pic_zero_is_abelian_variety`) | 1 (Rmk III.1.4(e)) |

## Macros needed (if any)
None. The chapter uses only macros already declared in
`blueprint/src/macros/common.tex` (\Spec, \Pic, \Sch, \Sym, \Jac,
\struct, \genus). The `\Pic^0_{C/k}` notation for the identity
component is written literally as `\Pic^0_{C/k}` (matching the
existing convention in `Jacobian.tex` line 19 and elsewhere); no
`\Picz` macro is introduced.

## Reference-retriever dispatches (if any)
None. The directive flagged Stacks tags 0B7R / 0B7T as a likely
need for the abstract group-scheme identity-component construction.
On inspection, Kleiman §5 Lem. lem:agps (already on disk at
`references/kleiman-picard-src/kleiman-picard.tex` L2851–L2911) is
*exactly* the abstract identity-component construction for a group
scheme l.f.t. over a field, with a full verbatim proof. It supplies
all the verbatim quotes I need for `def:identity_component_group_scheme`
and `thm:identity_component_open_subgroup`. Retrieving the Stacks
tags would therefore have been redundant — and Stacks tag 0B7T is
itself a Kleiman-style statement (Lem. agps essentially \emph{is}
0B7T at the group-scheme-l.f.t. level). I therefore decided not to
dispatch the retriever for this chapter. If a later writer or
reviewer prefers a Stacks-tag citation as well, the retriever can be
dispatched in a follow-up iter; it does not affect this chapter's
correctness or completeness.

## Notes for Plan Agent

- **`\input` registration**: per the directive's explicit "Out-of-scope:
  `\input` registration" item, I have NOT added
  `\input{chapters/Picard_IdentityComponent}` to `content.tex`. The
  planner needs to add it manually after this chapter lands.
- **Lean skeleton owed**: the directive notes that
  `AlgebraicJacobian/Picard/IdentityComponent.lean` does not yet
  exist; the chapter is authoritative as a specification, and the
  prover lane is owed in iter-185+ (per the directive's strategy
  context). The `\lean{...}` hints in the five declaration blocks
  pre-name the future Lean targets:
  `AlgebraicGeometry.GroupScheme.IdentityComponent`,
  `AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme`,
  `AlgebraicGeometry.Scheme.Pic0Scheme`,
  `AlgebraicGeometry.Scheme.PicScheme.degree`,
  `AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety`.
- **Sibling-chapter labels**: I rely on
  `thm:pic_is_group_scheme` (in `Picard_FGAPicRepresentability.tex`)
  via the `\cref` in the proof of
  `thm:pic_zero_is_abelian_variety`; if a downstream rewrite of the
  FGA chapter renames that label, the `\cref` here will need to be
  updated in lockstep. (At writing, the label exists at
  `Picard_FGAPicRepresentability.tex:408`.)
- **`% NOTE: future split candidate`**: per the iter-183 reviewer
  rationale, the abstract identity-component substrate is kept in
  this chapter rather than split off into a sibling
  `GroupScheme_IdentityComponent.tex`. A `% NOTE: future split
  candidate when a second consumer materialises` marker is recorded
  in the chapter's STRATEGY NOTE header, matching the directive.

## Strategy-modifying findings

None. No declaration as written required a property the strategy
assumes is automatic but is not, no theorem sketch turned out to
contradict a downstream consumer's needs, and no reference cited
required a different setup than the strategy assumes. The chapter
specification matches the iter-183 reviewer's Choice A faithfully:
$\Pic^0_{C/k}$ is built as the open-and-closed identity-component
subgroup scheme of the abstract group scheme $\Pic_{C/k}$, via the
abstract `GroupScheme.IdentityComponent` substrate, and the degree
map is added as a separate definition rather than coupled to the
$\Pic^0$ construction.
