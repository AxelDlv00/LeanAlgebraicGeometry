# Blueprint-writer directive — Picard_IdentityComponent.tex

## Target file
`blueprint/src/chapters/Picard_IdentityComponent.tex`

## Problem (why dispatched)
Five theorems in this chapter are leandag **∞-nodes**: their theorem
environments carry a statement but **no `\begin{proof}` block of their own**,
so leandag computes an empty proof body and the whole dependency closure
through them is ∞. The mathematical content already exists in the chapter as
two *combined* proof blocks that prove several theorems at once; the fix is to
**redistribute that existing content into one `\begin{proof}` block per
theorem**, each with a correct `\uses{}` set. This is a restructuring task —
do **not** invent new mathematics, and do **not** add or change any
`% SOURCE` / `% SOURCE QUOTE` / `\textit{Source:}` citation (every source is
already cited in-chapter).

## The five ∞-source theorems (each needs its own `\begin{proof} ... \end{proof}`)
1. `thm:identity_component_is_subgroup_homomorphism` (≈L124)
2. `thm:identity_component_finite_type_geom_irreducible` (≈L146)
3. `thm:identity_component_base_change_commutes` (≈L168)
4. `thm:pic_zero_is_abelian_variety` (≈L508)
5. `thm:pic_zero_dimension_equals_genus` (≈L548)

(`thm:identity_component_open_subgroup` is already finite — leave it as is, but
it may legitimately keep/share its proof.)

## What to do
- There is a **combined proof** (≈L302) that establishes
  `\crefrange{thm:identity_component_open_subgroup}{thm:identity_component_base_change_commutes}`
  in four labelled paragraphs (clopen subscheme; base-change; subgroup
  homomorphism; finite type + geometric irreducibility). **Split it** so that
  theorems (1),(2),(3) above each get a focused `\begin{proof}` containing the
  matching paragraph(s). Each split proof must `\uses{}` the lemmas it actually
  invokes — in particular `thm:identity_component_open_subgroup`,
  `lem:geometricallyConnected_of_connected_of_section`, and any
  `def:identity_component_group_scheme` it relies on. Keep the Kleiman §5
  Lem.~agps(3) and Stacks 037Q/04KV reasoning verbatim from the existing prose;
  just move it into the right theorem environments.
- There is a second **combined proof** (≈L621) that establishes
  `thm:pic_zero_is_abelian_variety`, `thm:pic_zero_dimension_equals_genus`, and
  `thm:pic_zero_k_points_iff_degree_zero` with clearly-labelled paragraphs
  ("Abelian-variety structure (i)–(iv)", "Dimension equals the genus",
  "Identification with the kernel of the degree map"). **Split** the first two
  paragraphs into per-theorem `\begin{proof}` blocks for (4) and (5). Theorem
  (4)'s proof must `\uses{}` the four identity-component theorems
  (`thm:identity_component_open_subgroup`,
  `thm:identity_component_is_subgroup_homomorphism`,
  `thm:identity_component_finite_type_geom_irreducible`,
  `thm:identity_component_base_change_commutes`), `thm:fga_pic_representability`,
  `thm:pic_is_group_scheme`, and `def:pic_zero_subscheme`. Theorem (5)'s proof
  must `\uses{thm:pic_zero_is_abelian_variety}` and `\uses{def:genus}` (plus the
  Kleiman cor:sm input as prose).
- If `thm:pic_zero_k_points_iff_degree_zero` still needs the residual third
  paragraph, leave that paragraph as that theorem's proof.

## Hard constraints
- Each of the five theorems must end up with a non-empty `\begin{proof}` block
  immediately following its `\end{theorem}` (this is what makes the node
  finite-effort in leandag).
- Purely mathematical prose. No Lean code, no tactic blocks. The only Lean
  reference is the existing `\lean{}` annotation.
- **Do NOT add `\leanok`** anywhere (deterministic sync owns it).
- Do not delete the combined-proof prose's mathematical content — relocate it.
  If a shared paragraph is genuinely needed by two theorems, you may duplicate a
  one-sentence summary and `\cref` the fuller treatment.

## References (already in-chapter; cite verbatim, do not fabricate)
- `references/kleiman-picard-src/kleiman-picard.tex` — §5 Lem.~agps(3) (L2860–2911),
  Thm.~qpp&p, Cor.~cor:sm, Ex.~ex:jac, Rmk.~rmk:Jac.
- `references/abelian-varieties.pdf` (Milne) — §I.1 (abelian variety def, Cor.~1.4),
  §III.1 Rmk.~1.4(e) (dimension = genus).
- `references/stacks-varieties.tex` — tags 037Q, 04KV.

## Out of scope
- Do not touch any other chapter.
- Do not change theorem statements or `\lean{}` targets.
- Do not add new theorems/lemmas beyond what is needed to host the relocated proofs.
