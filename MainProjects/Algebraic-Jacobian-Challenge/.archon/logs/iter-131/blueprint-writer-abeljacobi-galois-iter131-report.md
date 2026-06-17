# Blueprint Writer Report

## Slug
abeljacobi-galois-iter131

## Status
COMPLETE — three prose realignments applied in `blueprint/src/chapters/AbelJacobi.tex`. The "Classical description" half of the proof of `thm:exists_unique_ofCurve_comp` and the two paragraphs of the "Implementation route" section now describe the genus-$0$ sub-case as routing through `\cref{thm:rigidity_over_kbar}` directly over $k$ (per the iter-127 over-k commitment), without invoking Galois descent.

## Target chapter
`blueprint/src/chapters/AbelJacobi.tex`

## Changes Made

- **Revised** proof of `thm:exists_unique_ofCurve_comp`, "Classical description" half (formerly line ~82). Replaced the over-$\bar k$ rigidity + Galois descent narrative with the over-$k$ route:
  - Genus-$0$ now reduces to `\cref{thm:rigidity_over_kbar}` of `\cref{chap:RigidityKbar}` "established directly over $k$", flagged $k$-agnostic per the iter-127 over-k commitment (with explicit citation `analogies/cotangent-vanishing-pile-over-k.md`) and gated on shared cotangent-vanishing pile pieces (i)+(ii)+(iii) "over an arbitrary base field with no algebraic-closure, perfect-base, or Galois-descent hypothesis".
  - Added explicit `\textbf{DROPPED}` note for sub-step C.2.f (Galois descent of morphism equality back to $k$), with the rationale "no base-change-and-descent step appears anywhere in the M2 critical path".
  - Rewrote the $C(k) = \emptyset$ vs $C(k) \neq \emptyset$ branching to match the over-$k$ flow:
    - $C(k) \neq \emptyset$ branch: the supplied $P \in C(k)$ feeds the pointing hypothesis of `\cref{thm:rigidity_over_kbar}` directly; no $C \cong \mathbb P^1_k$ identification is required; the Brauer–Severi obstruction is therefore sidestepped (Brauer–Severi conics over $\mathbb Q$ retained as the named counterexample).
    - $C(k) = \emptyset$ branch: `isAlbaneseFor` field of the genus-$0$ witness (`\cref{def:genusZeroWitness}`) is vacuously true at the Lean type level because the universal quantifier $\forall\,(P \colon \mathbf 1 \to C)$ ranges over the empty type.
  - Preserved the closing sentence "None of this classical content is replayed in the Lean formalisation: it is bundled into the deferred existence hypothesis Theorem~`\ref{thm:nonempty_jacobianWitness}`...".

- **Revised** "Implementation route via the Albanese framework" first paragraph (formerly line ~87). Changed the trailing enumeration of route options from "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ together with Galois descent (genus-$0$ sub-case, base-change-and-descent argument of \S~C.2)" to "rigidity for $C \to A$ established \emph{directly over $k$} (genus-$0$ sub-case, via `\cref{thm:rigidity_over_kbar}` per the iter-127 over-k commitment; no base-change to $\bar k$ and no Galois descent of morphism equality enter, and sub-step C.2.f of \S~C.2 is correspondingly DROPPED)".

- **Revised** "Implementation route via the Albanese framework" second paragraph (formerly line ~89). Rewrote the parenthetical genus-$0$ classical-comparison clause from "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ followed by Galois descent" to "rigidity for $C \to A$ established directly over $k$ via `\cref{thm:rigidity_over_kbar}` (per the iter-127 over-k commitment; no base-change to $\bar k$ and no Galois descent of morphism equality enter)". The surrounding "classical proof via line bundles" framing was preserved verbatim (the line-bundle / $\Pic^0_{C/k}$ / dual-abelian-variety route remains the comparison being drawn against the Albanese-framework choice — that part of the section's narrative was not stale).

## Cross-references introduced

- `\cref{thm:rigidity_over_kbar}` — added in three places (one in the "Classical description" prose, two in the "Implementation route" paragraphs). Target exists in `blueprint/src/chapters/RigidityKbar.tex` (named project declaration; signature already $k$-agnostic per its own iter-127 commitment, per the chapter's "Iter-127 over-k commitment" paragraph).
- `\cref{chap:RigidityKbar}` — added once in the "Classical description" prose to point readers to the chapter housing the rigidity declaration. Target exists (chapter label at `blueprint/src/chapters/RigidityKbar.tex` line 1).
- `\cref{def:genusZeroWitness}` — added once in the "Classical description" prose to anchor the $C(k) = \emptyset$ vacuity argument. Target exists in `blueprint/src/chapters/Jacobian.tex` (referenced from the M2.b row of the iter-127 RigidityKbar roadmap and from `Jacobian.tex` § C.1 / Layer I).
- No `\uses{...}` blocks were added/modified — the three edits are inside an existing `\begin{proof}` block (whose `\uses{...}` already covers the cross-chapter dependencies via `thm:nonempty_jacobianWitness`) and in non-block "Implementation route" prose (which does not carry a `\uses{...}` list of its own).

## Markers

- Did NOT add/remove `\leanok`, `\mathlibok`, or `\notready` (managed deterministically by the `sync_leanok` phase and the review agent, per directive and project rules).
- Did NOT modify any `\lean{...}` hints. The three protected names (`AlgebraicGeometry.Jacobian.ofCurve`, `AlgebraicGeometry.Jacobian.comp_ofCurve`, `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp`) remain unchanged.

## Macros needed (if any)

None. All commands used (`\cref`, `\texttt`, `\emph`, `\textbf`, `\mathbf`) are standard; `\cref` is already used throughout the project's blueprint (e.g. `Jacobian.tex`, `RigidityKbar.tex`).

## Reference-retriever dispatches (if any)

None. The three references the directive cited are all in-project files (already-formalised blueprint chapters and one project analogy file), no external source retrieval was needed.

## Validation

- Verified no remaining `$\mathbb P^1_{\bar k} \to A_{\bar k}$` formulations in `AbelJacobi.tex` (grep confirmed).
- Verified no remaining "over the algebraic closure" phrasing in `AbelJacobi.tex` (grep confirmed).
- Verified remaining "Galois descent" / "base-change-and-descent" occurrences in `AbelJacobi.tex` are all in the documented-as-DROPPED form (saying we do NOT use it / sub-step C.2.f is DROPPED), mirroring the canonical phrasing in `Jacobian.tex` § C.2.f.
- Verified `\begin{...}` / `\end{...}` count balance for theorem-like environments: 7 = 7.
- Verified the chapter-wide structure (`\chapter`, `\section`, `\definition`, `\lemma`, `\theorem`, `\remark` blocks) was untouched outside the three edited paragraphs.

## Notes for Plan Agent

- The "Implementation route" section's enumeration of three viable routes (Route~A Pic-scheme / Route~B Sym^d-quotient / genus-$0$ rigidity) still leads off with Route~A and Route~B as live options. Both `Jacobian.tex` Layer~I and `RigidityKbar.tex` already treat the genus-$0$ over-$k$ rigidity route as the load-bearing route for the M2 critical path (and Pic-scheme / Sym^d-quotient as Mathlib-blocked deferrals). The `AbelJacobi.tex` prose now correctly removes the Galois-descent qualifier from the third route but does not re-prioritise the enumeration — i.e., the chapter still presents Route~A / Route~B / genus-$0$ rigidity as parallel options rather than calling out the genus-$0$-rigidity route as the canonical project route. If you'd prefer a strategic re-ordering or an explicit "Route~C is the project's chosen path" call-out, that would be a separate writer pass (out of scope for the present directive, which scoped to the three Galois-descent prose stalenesses only).
- Remark `rem:ofCurve_classical` and remark `rem:comp_ofCurve_classical` (lines 20–29 and 47–56) still describe the classical line-bundle / Pic-scheme description; they were not flagged by the iter-131 reviewer and they don't mention $\bar k$-rigidity or Galois descent, so they were not touched.

## Strategy-modifying findings

None. The three edits are pure prose realignments that bring `AbelJacobi.tex` into sync with the iter-127 over-k commitment already encoded in `Jacobian.tex` § C.2.f and the "Iter-127 over-k commitment" section of `RigidityKbar.tex`. No strategy-level issue surfaced during the rewrite.
