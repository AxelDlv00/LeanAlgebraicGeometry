# Blueprint Writer Report

## Slug
jacobian-iter121

## Status
COMPLETE — Sub-step C.2 of the proof of `thm:nonempty_jacobianWitness` is now a multi-paragraph proof skeleton (statement over $\bar k$, reduction to the project's rigidity lemma, image-dimension argument, key classical input, scheme-vs-set promotion, Galois descent, and Mathlib-gap statement). Strategy is unchanged (no findings under "Strategy-modifying findings").

## Target chapter
`blueprint/src/chapters/Jacobian.tex`

## Changes Made

- **Revised** `\item[\textbf{(C.2)}]` inside the genus-$0$ sub-case of the proof of `thm:nonempty_jacobianWitness` — replaced the single one-sentence bullet with a nested-itemize expansion (~110 LOC) containing seven sub-steps:
  - **C.2.a** Statement of the rigidity-for-$\mathbb P^1_{\bar k}$ lemma over the algebraic closure: $f \colon \mathbb P^1_{\bar k} \to A$ with $f(p) = \eta_A$ is constant at $\eta_A$.
  - **C.2.b** Reduction to the project's `thm:GrpObj_eq_of_eqOnOpen`. Notes the source-side group-object hypothesis of the lemma is not met by $\mathbb P^1_{\bar k}$ but is used only to form a difference morphism; the underlying equaliser-closed argument applies verbatim.
  - **C.2.c** Image-dimension argument: image of $f$ is irreducible closed of dimension $\leq 1$; the $g = 0$ case is vacuous; the residual case is the genuine content.
  - **C.2.d** The key classical input (Mumford, *Abelian Varieties*, Ch. II §4): proper rational curves on a positive-dimensional abelian variety are constant. Two proofs sketched: (i) via the dual abelian variety + autoduality + $\Pic^0(\mathbb P^1) = 0$ (Hartshorne II.6 + II.7); (ii) via triviality of $\Omega_{A/\bar k}$ + vanishing $H^0(\mathbb P^1, \Omega_{\mathbb P^1}) = 0$.
  - **C.2.e** Promotion of set-level equality to scheme-morphism equality via reduced-source / separated-target.
  - **C.2.f** Galois descent of morphism equality from $\bar k$ back to $k$ for the sub-case $C(k) \neq \emptyset$ (Brauer–Severi case handled vacuously upstream by C.2.a since the protected `isAlbaneseFor` field is over $P \in C(k)$).
  - **C.2.g** Explicit Mathlib gap statement: the keystone fact of C.2.d is absent from snapshot `b80f227`; project-internal contribution-candidate name `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` (provisional). Also flags descent (C.2.f) as a second Mathlib gap candidate.
- **Revised** the trailing Mathlib-status itemize entry for C.2 (`Mathlib status for the genus-$0$ sub-case`) — updated from the old "rigidity theorem $\Hom(\mathbb P^1_k, A) = A(k)$ not in Mathlib" one-liner to a two-sentence summary pointing at C.2.d / C.2.g for the contribution candidate, and C.2.f for the descent gap.
- **Revised** `\uses{...}` of the proof of `thm:nonempty_jacobianWitness` — added `thm:GrpObj_eq_of_eqOnOpen` to the dependency-graph use-set.

## Cross-references introduced

- `\uses{thm:GrpObj_eq_of_eqOnOpen}` added in proof of `thm:nonempty_jacobianWitness` — label exists in `blueprint/src/chapters/Rigidity.tex` (verified).
- `Chapter~\ref{chap:Rigidity}` cited in the new Mathlib-status entry — label exists in `Rigidity.tex` (verified).
- New labels `(C.2.a)`–`(C.2.g)` are inline item-tags inside an `itemize`, not `\label{...}` declarations; no new graph-level entries.

## Macros needed (if any)

None. All commands used (`\Spec`, `\Pic`, `\Hom`, `\Jac`, etc.) are defined in `blueprint/src/macros/common.tex`; the rest (`\mathbb`, `\bar`, `\mathrm`, `\xrightarrow`, `\mathtt`, `\bigl`, `\bigr`) are standard LaTeX.

## Reference-retriever dispatches (if any)

None. The directive named Mumford's *Abelian Varieties* (Ch. II §4) and Hartshorne's *Algebraic Geometry* (II.6 + II.7) as inline citations only; both are universally accessible textbook references not requiring a `references/<slug>.md` summary for this level of blueprint detail.

## Notes for Plan Agent

- **Stale phrasing elsewhere referencing the old $k$-side rigidity bullet.** Two later lines in the same chapter still use the old phrasing `$\Hom(\mathbb P^1_k, A) = A(k)$`:
  1. Line 376 (within the "Mathlib infrastructure summary" itemize, bullet $(\gamma)$).
  2. Line 387 (within the "Layer I — direct definition" enumerate item).
  Both were left untouched per the directive's out-of-scope rule. A future writer dispatch on `Jacobian.tex` (or a strategy-aligned cleanup pass) could update both to acknowledge the base-change-and-descent framing now in C.2.a–f.
- **C.3 still cites "By Sub-step C.2 every $f \colon C \to A$..."** — that pointer remains valid under the new C.2 expansion (whose conclusion is exactly that constancy), but the wording could be tightened in a future dispatch to point at C.2.f specifically for the $k$-side conclusion and at C.2.a for the $\bar k$-side.
- **Provisional Lean-side declaration name.** I introduced `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` as the candidate name. The directive flagged this as provisional; the plan agent should choose the canonical project-side name (and namespace) when the declaration is introduced into the Lean tree. I used `P1` rather than `ℙ¹` in the typeset identifier so that the LaTeX `\mathtt` block is rendered identically by KaTeX (the dashboard's renderer) and PDF; the plan agent is free to use `ℙ¹` in the actual Lean declaration name as long as the blueprint's `\lean{...}` hint is adjusted accordingly.
- **C.2.b's hypothesis-mismatch hedge.** The project's `thm:GrpObj_eq_of_eqOnOpen` requires the source to be a smooth proper geometrically irreducible *group scheme*; $\mathbb P^1_{\bar k}$ is not. I documented this honestly in C.2.b ("the underlying equaliser-closed argument goes through verbatim with $X = \mathbb P^1_{\bar k}$") and in C.2.g ("a thin variant of the lemma or by inlining its proof template"). The cleanest resolution is a future refactor of `Rigidity.lean` / `Rigidity.tex` to drop the group-object-on-source hypothesis from the statement of `GrpObj.eq_of_eqOnOpen` (the proof doesn't use it), turning it into `Scheme.eq_of_eqOnOpen` or similar. This refactor is **out of scope** for this dispatch (`Rigidity.tex` not in write-domain) but is a candidate for a future refactor-subagent dispatch keyed off M2.a.

## Strategy-modifying findings

None. The expansion stays inside the strategy already encoded in `STRATEGY.md`: it concretises the "base-change to $\bar k$ + Galois descent" tactic the strategy already prescribed for the no-rational-point sub-case, and it surfaces (in C.2.g) the contribution-candidate naming that M2.a's prover dispatch will consume.
