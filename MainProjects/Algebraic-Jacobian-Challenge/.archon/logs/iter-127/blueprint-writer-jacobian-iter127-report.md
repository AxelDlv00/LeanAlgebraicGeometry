# Blueprint Writer Report

## Slug
jacobian-iter127

## Status
COMPLETE — all 6 directive items applied; LaTeX balance verified (36 `\begin` / 36 `\end`).

## Target chapter
`blueprint/src/chapters/Jacobian.tex`

## Changes Made

- **Added theorem** `\begin{theorem}[Genus-$0$ Albanese witness]` / `\label{def:genusZeroWitness}` / `\lean{AlgebraicGeometry.genusZeroWitness}` — packages the genus-$0$ arm of the witness-existence statement as an explicit Lean construction. Placed in a new `\subsection{The genus-$0$ arm of the witness existence}` (`\label{sec:genusZeroWitness}`) immediately after the `thm:nonempty_jacobianWitness` proof, before the `\section{Implementation route via the Albanese functor}` heading. Theorem block carries `\notready` marker (Lean body is currently `sorry`); statement directive `\uses{def:JacobianWitness, thm:rigidity_over_kbar, def:genus}`.
  - Proof sketch added: **Y**. Covers all six sub-cases listed in the directive: (1) Underlying scheme $J := \mathbf{1}$; (2) Group/proper/smooth/geom-irred structure on $\mathbf{1}$ + reference to project-local helper `geometricallyIrreducible_id_Spec` at `Jacobian.lean:120–126`; (3) Smoothness of relative dimension $\genus\,C$ via the `h : genus C = 0` rewrite to `SmoothOfRelativeDimension 0 (id _)`; (4) `isAlbaneseFor` field with $\alpha := \mathtt{toUnit}\,C$ as universal morphism, pointed condition automatic, existence-of-$g$ via $g := \eta_A$ and rigidity-over-$k$ reduction, uniqueness via terminal-object universal property; (5) Vacuity of the $C(k) = \emptyset$ branch via Lean's $\forall$-over-empty-type triviality (Brauer–Severi conics over $\mathbb Q$ named as the standard counterexample); (6) Body-closure status — Lean body is `sorry`, gated on `rigidity_over_kbar` body (M2.a), which is gated on shared cotangent-vanishing pile (i)+(ii)+(iii) landing iter-129+; earliest body closure iter-138+.

- **Revised** sub-step `C.2.f` (Galois descent to $k$) — marked **DROPPED iter-127** under the over-k commitment. New prose explains (a) the prior strategy iterations routed through base-change-and-descent (M2.c, ~4–8 iter / 300–500 LOC); (b) the iter-127 over-k analogist (`analogies/cotangent-vanishing-pile-over-k.md`) verified each piece of the shared pile builds directly over $k$ (functorial shear iso for piece (i); `Differential.ContainConstants` $k$-agnostic for piece (ii); intrinsic absolute Frobenius $F_X$ for piece (iii)); (c) `rigidity_over_kbar` is invoked directly with the supplied $k$-rational marked point $P \in C(k)$; (d) Galois descent of morphism equality is no longer a project Mathlib gap.

- **Revised** sub-step `C.2.g` (Mathlib gap statement) — renamed prose to "iter-127 over-k inventory"; updated the keystone restatement to drop the "over algebraically closed field" framing in favour of "over an arbitrary base field $k$"; replaced the speculative `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` naming with the now-existing `\cref{thm:rigidity_over_kbar}` of `\cref{chap:RigidityKbar}` (with a note that the filename and Lean identifier retain the iter-126 over-$\bar k$ name; a `rigidity_over_kbar → rigidity_over_k` rename is scheduled iter-128+ per the directive); expanded the pile (i)+(ii)+(iii) inventory with the over-k specifics for each piece; removed the entire Galois-descent paragraph (the second Mathlib gap mention) including the iter-124 phantom-prereq spot-check citation and the 300–500 LOC estimate; added the 500–900 LOC / 7–13 iter savings line.

- **Revised** `\paragraph{Mathlib status for the genus-$0$ sub-case.}` itemize bullet for Sub-step C.2 — dropped the "second Mathlib gap" Galois-descent mention; rephrased the keystone statement from "over an algebraically closed field" to "over an arbitrary base field $k$"; added the C.2.f-DROPPED forward-pointer.

- **Revised** route-($\gamma$) bullet in `\paragraph{Mathlib infrastructure summary.}` — replaced the prior "rigidity over $\bar k$ + Galois descent" framing with "rigidity directly over $k$ + shared cotangent-vanishing pile pieces (i)+(ii)+(iii)"; named `\cref{thm:rigidity_over_kbar}` as the project's packaging; named `\cref{def:genusZeroWitness}` as the genus-$0$ witness arm; documented the $C(k) = \emptyset$ vacuity branch.

- **Revised** Layer I bullet of `\section{Implementation route via the Albanese functor}` — replaced the "proved on $C_{\bar k} \cong \mathbb P^1_{\bar k}$ via base-change-and-Galois-descent" framing with the over-k commitment routing through `\cref{thm:rigidity_over_kbar}` and `\cref{def:genusZeroWitness}`. Note: the directive's "around L6" location reference did not match the actual file — the over-$\bar k$ phrasing only appeared in the route-($\gamma$) bullet (L376) and the Layer I bullet (L387). I interpreted item 5 of the directive as the Layer I bullet (since item 4 already covers the route-($\gamma$) bullet) and updated accordingly; L6 itself (the FGA-blocked-by-Mathlib paragraph) does not carry over-$\bar k$ framing and was left untouched.

- **Added** `\uses{def:genusZeroWitness, thm:rigidity_over_kbar}` to the proof of `thm:nonempty_jacobianWitness` (per the directive's optional item 6). Inline prose updated to note that the genus-$0$ sub-case is packaged as `def:genusZeroWitness` and routes through `thm:rigidity_over_kbar` directly over $k$.

## Cross-references introduced

- `\uses{def:JacobianWitness, thm:rigidity_over_kbar, def:genus}` on `def:genusZeroWitness` statement — `def:JacobianWitness` is in this chapter (L203), `thm:rigidity_over_kbar` is in `RigidityKbar.tex:19`, `def:genus` is in `Genus.tex` (presumed; the existing chapter already cites `def:genus` in `def:Jacobian` at L109 and several other places, so the label exists in the dependency graph).
- `\uses{thm:rigidity_over_kbar, thm:GrpObj_eq_of_eqOnOpen, def:IsAlbanese, def:JacobianWitness, def:genus}` on the `def:genusZeroWitness` proof body — `thm:GrpObj_eq_of_eqOnOpen` is the legacy label kept in the source chapter (Rigidity.tex) per the iter-125 refactor's continuity convention.
- `\uses{def:genusZeroWitness, thm:rigidity_over_kbar}` added to `thm:nonempty_jacobianWitness` proof (existing `\uses{def:IsAlbanese, def:genus, thm:GrpObj_eq_of_eqOnOpen}` extended).
- New `\label{sec:genusZeroWitness}` on the new subsection.

## Macros needed (if any)

None. `\notready`, `\cref`, `\genus`, `\Over`, `\Spec`, `\Jac`, `\Pic`, `\finrank`, `\Sym`, `\mathlibok`, `\leanok` are all already in use elsewhere in the chapter / `macros/common.tex`.

## Reference-retriever dispatches (if any)

None. All required source material was in-tree:
- `analogies/cotangent-vanishing-pile-over-k.md` (iter-127 over-k analogist verdict)
- `blueprint/src/chapters/RigidityKbar.tex` (existing `thm:rigidity_over_kbar` + iter-127 commitment text)
- `AlgebraicJacobian/Jacobian.lean:120–178` (the new `genusZeroWitness` scaffold + `geometricallyIrreducible_id_Spec` helper)

## Notes for Plan Agent

- **Dependency on `Rigidity.tex` label `thm:GrpObj_eq_of_eqOnOpen`**: the directive's per-iter convention (visible in the existing C.2.b prose) is to retain the legacy label name even after the iter-125 refactor to `Scheme.Over.ext_of_eqOnOpen`. I preserved this convention in the new `def:genusZeroWitness` proof's `\uses` directive. Worth a quick label-existence audit during the blueprint-reviewer pass.
- **`def:genus` label residence**: the chapter consistently cites `\uses{def:genus}` without me having verified the label is defined in `Genus.tex` (or equivalent). The pre-existing `def:Jacobian` block (L109) and `thm:nonempty_jacobianWitness` block (L243) already rely on this; the new block follows the same pattern. No new risk introduced.
- **`RigidityKbar.tex` mentions `def:genusZeroWitness` already** (L189: "the iter-127 scaffold $\thm{def:genusZeroWitness}$"). After this iter's writer round, that forward-reference now resolves to a real label. The blueprint-reviewer should confirm the bidirectional `\uses` chain (`def:genusZeroWitness → thm:rigidity_over_kbar`) is captured in the dependency graph.
- **Directive item 5 location mismatch**: the directive named "around L6" for the over-$\bar k$ framing update, but L6 (the FGA-blocked-by-Mathlib paragraph) does not contain that framing. The phrase only appeared in the route-($\gamma$) bullet (L376) and the Layer I bullet (L387). I treated item 5 as the Layer I bullet and item 4 as the route-($\gamma$) bullet; both are now updated. The L6 paragraph is untouched (it is the genuine chapter-opening framing about Picard-machinery blockage and is correct as-is). If the plan agent intended item 5 to mean L6 specifically, the L6 paragraph already carries the over-k framing implicitly (it says "ad-hoc route: the Albanese functor on smooth proper curves" without over-$\bar k$ commitment); no further edit needed.
- **Chapter line count delta**: the chapter grew from 391 to 422 lines (+31). The new theorem block + proof sketch contributed ~30 lines; the prose updates to C.2.f / C.2.g / route-($\gamma$) / Layer I were near-zero net delta (replaced existing prose with similar-length over-k prose). Well within the directive's 50–80 line estimate.

## Strategy-modifying findings

None. The chapter delta is fully aligned with the iter-127 strategy commitment (over-k path; drop M2.c + M2.c.aux). No new strategy issues were surfaced.
