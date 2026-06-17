Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex (NEW chapter — create it).

Strategy context: The glued Grassmannian scheme `Gr(d,r)` over ℤ is DONE
(`Picard_GrassmannianCells.tex`: cells, cocycle, glue, separated, proper). This
new chapter is the NEXT layer: the *tautological rank-`d` quotient* on `Gr(d,r)`
and its *universal property* — the representability skeleton for the Quot functor.
This is the headline long-pole toward `thm:grassmannian_representable`.

Action: Author the chapter covering Nitsure §5 (Construction of Quot Schemes).
Read `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` from L2154
(§5) — and §1 L287 for the Grassmannian/Quot functor definitions — and transcribe
the verbatim source quotes per citation discipline. Provide:
  - `def:tautological_quotient` — on `Gr(d,r)`, the universal rank-`d` locally
    free quotient `O^r ↠ Q` of the trivial rank-`r` sheaf, defined chart-by-chart
    on the big cells and glued via the DONE cocycle.
  - `def:grassmannian_functor` (functor of points) — `T ↦ {rank-d locally free
    quotients of O_T^r}` (Nitsure §1/§5), the Quot-of-trivial-sheaf functor.
  - `thm:grassmannian_universal_property` — `Gr(d,r)` represents
    `def:grassmannian_functor`: a `T`-point ↔ a rank-`d` quotient of `O_T^r`,
    naturally; the tautological quotient is universal.
  - one-line `\uses{}` to the DONE GrassmannianCells nodes (charts/cocycle/glue)
    and any rank-`d` local-freeness predicate.
Each block: statement, `\label{}`, `\lean{...}` hint (predict the Lean names in
namespace `AlgebraicGeometry.Grassmannian`), accurate `\uses{}`, and a textbook
informal proof. Add `\input{chapters/Picard_GrassmannianQuot}` is MY job — do NOT
edit content.tex; just create the chapter file.

Constraints:
  - Citation discipline: `% SOURCE:` + verbatim `% SOURCE QUOTE:` from the Nitsure
    tex you read, `\textit{Source: Nitsure §5.}` visible line. Quote verbatim.
  - Do NOT add `\leanok` (deterministic sync owns it). `\mathlibok` only on genuine
    Mathlib anchors (none expected here).
  - OUT OF SCOPE: the full Quot-functor representability for an arbitrary coherent
    sheaf (that is GR-repr, a later chapter, via the flattening stratification +
    embedding into a Grassmannian); the strengthened `thm:relative_spec_univ`.
    Stay on the *tautological quotient + universal property of Gr(d,r)* only.
  - If §5 needs material not in `references/`, spawn reference-retriever
    (you have `references/**` in your write-domain).
