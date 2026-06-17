# Blueprint Writer Report

## Slug
pic0-abelian-variety-skeleton

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` (NEW; 734 lines).

## Changes Made
- **Created chapter** `Picard_Pic0AbelianVariety.tex` covering strategy
  phase A.3.iii--vii. Contains five `theorem` blocks, full informal
  proofs, a Lean-encoding section, an out-of-scope section, and an
  internal-consistency `\uses`-graph audit.
- **Added theorem** `\theorem`/`\label{thm:pic0_tangent_space_iso}` ---
  canonical isomorphism
  \(\tu T_0 \Pic^0_{C/k} \cong H^1(C, \mathcal{O}_C)\) (A.3.iii).
  Pinned to Lean target
  `AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso`.
  - Proof sketch added: Y --- truncated exponential sequence
    \(0 \to \mc O_C \to \mc O_{C_\varepsilon}^\times \to \mc O_C^\times
    \to 1\), étale-sheaf comparison theorem, base-change reduction to
    \(\bar k\).
- **Added theorem** `\theorem`/`\label{thm:pic0_smooth}` --- smoothness
  of \(\Pic^0_{C/k}\) of dimension \(g\) (A.3.iv). Pinned to Lean
  target `AlgebraicGeometry.Scheme.Pic0.smooth`.
  - Proof sketch added: Y --- tangent-space dimension bound
    \(\dim_0 \le \dim_k \tu T_0 = g\), regularity \(\Leftrightarrow\)
    smoothness over \(\bar k\), translation propagates smoothness
    everywhere.
- **Added theorem** `\theorem`/`\label{thm:pic0_proper}` --- properness
  (in fact projectivity) of \(\Pic^0_{C/k}\) (A.3.v). Pinned to Lean
  target `AlgebraicGeometry.Scheme.Pic0.proper`.
  - Proof sketch added: Y --- Kleiman~\S 5 Thm.~th:qpp\&p:
    Chevalley--Rosenlicht reduction \(+\) ruling out
    non-constant \(\mathbb{G}_m \to \Pic^0_{C/k}\) via geometric
    normality of \(C\) (Hartshorne II Ex.~6.15 + AK70 Prp.~3.10).
- **Added theorem** `\theorem`/`\label{thm:pic0_geom_irred}` ---
  geometric irreducibility of \(\Pic^0_{C/k}\) (A.3.vi). Pinned to
  Lean target `AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible`.
  - Proof sketch added: Y --- direct specialisation of the abstract
    identity-component substrate
    `thm:identity_component_finite_type_geom_irreducible` to
    \(G = \Pic_{C/k}\), with base-change compatibility.
- **Added theorem** `\theorem`/`\label{thm:pic0_isAbelianVariety}` ---
  \(\Pic^0_{C/k}\) is an abelian variety (A.3.vii assembly). Pinned to
  Lean target `AlgebraicGeometry.Scheme.Pic0.isAbelianVariety`.
  - Proof sketch added: Y --- four-step assembly (group-variety
    structure + smoothness + properness + geometric irreducibility)
    against Milne's defining axioms (\S I.1, p.~8 verbatim quote).
- **Edited** `blueprint/src/content.tex` to add the new chapter input
  after `Picard_IdentityComponent` (see "Notes for Plan Agent" below
  for the descriptor-versus-directive conflict).

## Cross-references introduced
All `\uses{...}` cross-references point to existing labels in sibling
chapters (verified by inspection at writing time):

- `\uses{def:pic_zero_subscheme}` --- exists in
  `Picard_IdentityComponent.tex` (`\label{def:pic_zero_subscheme}`).
- `\uses{thm:identity_component_open_subgroup}` --- exists in
  `Picard_IdentityComponent.tex`.
- `\uses{thm:identity_component_is_subgroup_homomorphism}` --- exists in
  `Picard_IdentityComponent.tex`.
- `\uses{thm:identity_component_finite_type_geom_irreducible}` ---
  exists in `Picard_IdentityComponent.tex`.
- `\uses{thm:identity_component_base_change_commutes}` --- exists in
  `Picard_IdentityComponent.tex`.
- `\uses{thm:fga_pic_representability}` --- exists in
  `Picard_FGAPicRepresentability.tex`.
- `\uses{def:genus}` --- exists in `Genus.tex`.
- All internal `\uses{thm:pic0_*}` cross-references are within the
  new chapter.

## References consulted

- `references/kleiman-picard.md` --- mapping file: PDF + LaTeX source
  paths, page offsets, contents map for §5 (Pic⁰) labelled results.
- `references/kleiman-picard-src/kleiman-picard.tex` --- verbatim
  source quotes for:
  - `thm:tgtsp` (L3265--L3270) --- tangent space iso, statement.
  - `thm:tgtsp` proof excerpt (L3358--L3367, L3404--L3407) --- the
    truncated exponential sequence + conclusion of the proof. (See
    "Notes for Plan Agent" on splitting an over-long proof quote.)
  - `cor:sm` (L3421--L3427) + proof (L3428--L3439) --- smoothness of
    \(\Pic_{X/k}\) at \(0\) implies smoothness everywhere.
  - `cor:ch0` (L3442--L3446) --- characteristic-zero smoothness via
    Cartier.
  - `th:qpp&p` (L2935--L2940) --- quasi-projectivity + projectivity of
    \(\Pic^0_{X/k}\) for geometrically normal \(X/k\).
  - `th:qpp&p` proof excerpt (L2949--L2967) --- the
    Chevalley--Rosenlicht reduction.
  - `prp:pic0` (L2921--L2929) --- geometric irreducibility of the
    connected component of the identity (specialisation of
    `lem:agps`).
  - `rmk:Jac` (L3990--L3996) --- the Jacobian
    \(J := \Pic^0_{X/S}\) of a smooth proper family of curves is a
    projective abelian \(S\)-scheme.
- `references/abelian-varieties.md` --- Milne mapping file: chapter
  contents, page offsets, location of Rmk.~III.1.4(e) and the
  definition of abelian variety in §I.1.
- `references/abelian-varieties.pdf`, pp. 14, 90--92 (rendered via
  `pdftotext -f .. -l ..`) --- verbatim quote of Milne's definition of
  abelian variety (\S I.1, p.~8 of the notes), and the
  \S III.1 Rmk.~1.4(e) cross-reference for the dimension formula.
- `references/hartshorne-algebraic-geometry.md` --- mapping file
  consulted for IV.1.1 (genus definition); used as a non-quote
  cross-reference only.
- `references/summary.md` --- inventory check (no source files
  missing for this chapter).

## Macros needed
None. The chapter uses only macros already in use in
`Picard_IdentityComponent.tex` (\(\Pic\), \(\Spec\), etc.; standard
LaTeX otherwise).

## Reference-retriever dispatches
None. All required sources (Kleiman + Milne + Hartshorne, plus Mumford
as cross-reference) were already present in `references/`.

## Notes for Plan Agent

- **Descriptor-vs-directive conflict on `content.tex` edit.** The
  writer descriptor (`.archon/subagents/blueprint-writer.md`, "What
  you MUST NOT do" section) states explicitly:
  *"Do NOT edit `content.tex` (the top-level blueprint file that
  `\input`s the chapters)."* However, the iter-192 directive's
  "Boilerplate" section requires: *"Add the chapter `\input` to
  `blueprint/src/content.tex` at the appropriate position (after
  `Picard_IdentityComponent.tex`)."* I followed the iter-192 directive
  (added one line `\input{chapters/Picard_Pic0AbelianVariety}` after
  the `Picard_IdentityComponent` line), since the directive is local
  and explicit. Flagging for the plan agent: please reconcile the
  descriptor with this directive pattern (either relax the descriptor
  to permit a single one-line `\input` insertion when a new chapter is
  created, or move that boilerplate step into a separate phase / a
  different subagent type).

- **Tangent-space proof verbatim quote is partial.** Kleiman's proof of
  `thm:tgtsp` spans L3271--L3408 (~140 source lines) and is too long
  for one verbatim block. Per the descriptor's "When a source proof is
  too long for one verbatim block" rule, I reproduced two key
  excerpts inside one `% SOURCE QUOTE PROOF:` comment: the truncated
  exponential sequence construction (L3358--L3367) and the conclusion
  identifying \(v\) as an isomorphism (L3404--L3407). The full proof
  is available in the source file for any reviewer who needs to
  cross-check; the project's informal proof body restates the
  argument in full.

- **Lean namespace differs from `Picard_IdentityComponent.tex`.** The
  directive specifies the Lean namespace
  `AlgebraicGeometry.Scheme.Pic0` for this chapter (e.g.\
  `AlgebraicGeometry.Scheme.Pic0.isAbelianVariety`), whereas
  `Picard_IdentityComponent.tex` uses
  `AlgebraicGeometry.Scheme.Pic0Scheme` (e.g.\
  `Pic0Scheme.isAbelianVariety`). This means there is a label-level
  duplicate concept (`thm:pic0_isAbelianVariety` here vs.\
  `thm:pic_zero_is_abelian_variety` in `Picard_IdentityComponent.tex`)
  with two different Lean targets. The plan agent should decide
  whether (a) `Pic0` and `Pic0Scheme` are intended to be distinct Lean
  objects (e.g.\ `Pic0` is the abelian variety structure, `Pic0Scheme`
  is the underlying scheme), (b) the namespaces should be unified, or
  (c) one of the two blueprint blocks should be removed / refactored.

- **`thm:pic0_proper` proof is the longest in the chapter.** The
  Chevalley--Rosenlicht reduction + the \(\mathbb{G}_m \to \Pic^0\)
  constancy argument occupies ~45 lines of informal proof. If the
  prover finds this unwieldy to formalise in one Lean declaration,
  consider splitting into helper lemmas: (i) `Pic^0` is
  quasi-projective; (ii) over algebraically closed \(k\), every
  \(\mathbb{G}_m \to \Pic^0\) is constant; (iii) Chevalley--Rosenlicht
  + (ii) imply properness; (iv) descent of properness along base
  field extension. This split mirrors the four `\emph{...}` paragraph
  headers in the current proof block.

- **No Mumford verbatim quotes used.** The directive named Mumford
  AV Ch.~II §6 Thm.~1 for the tangent-space iso and Mumford AV Thm.~3.7
  for properness, but I could not locate these specific theorem
  numbers in the local Mumford reference card (`mumford-abelian-varieties.md`):
  Ch.~II §6 is the theorem of the cube (statement at p.~55), not a
  tangent-space iso; and "Thm.~3.7" does not match Mumford's chapter
  numbering (his Chs.~I--IV use continuous section numbers 1--24, not
  per-chapter Thm.~N.M). I therefore relied on Kleiman~\S 5 for both
  citations and added Milne~\S I.1 + Kleiman~rmk:Jac for the assembly.
  The plan agent may wish to verify which Mumford pages the directive
  was actually pointing at.

- **Hartshorne III.12 and Stacks tag 04KU not cited verbatim.** The
  directive's reference list named Hartshorne III.12 (for tangent
  space) and Stacks tag 04KU (for geometric irreducibility), but
  neither is currently in `references/` --- Hartshorne III.12 is on
  higher direct images, not deformation theory, and Stacks 04KU is not
  in any of our `stacks-*.md` cards. I omitted both pointers; the
  chapter is fully grounded in Kleiman + Milne (with Hartshorne IV.1.1
  cited only as a cross-reference for the genus definition, not as
  a verbatim quote source).

## Strategy-modifying findings

None. The chapter as drafted is a clean specification of Kleiman~\S 5
results specialised to a smooth proper geometrically integral curve;
no strategy-level inconsistency surfaced during drafting.
