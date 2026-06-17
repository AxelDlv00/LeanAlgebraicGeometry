# Blueprint Writer Report

## Slug
rigiditykbar-piecei-realign-iter130

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

- **Revised** `proof of lem:GrpObj_cotangentSpace` (formerly lines 112–120) — replaced the iter-129 proof prose that framed the iter-128 body as the canonical realisation of $\eta_G^* \Omega_{G/k}$ (and `lem:GrpObj_cotangent_bridge` as a tautological identification) with a Replacement-(B)-aligned prose:
  - Explicitly attributes the body to the iter-130 chart-base-change construction.
  - Cites the forward Jacobian criterion `\cref{thm:smooth_locally_free_omega}` (`AlgebraicGeometry.Scheme.smooth_locally_free_omega`) as the source of the affine chart $V \ni \eta_G(\mathrm{pt})$.
  - States the definition $\mathfrak g^\vee := k \otimes_{\Gamma(G, V)} \Omega_{\Gamma(G,V)/\Gamma(\Spec k, U)}$.
  - Cites `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (in `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`) for the algebraic Kähler rank.
  - Adds an *emph "Caveat on canonicity"* paragraph that flags the `Classical.choice` chart dependence, explains why canonicity is not load-bearing for the rigidity-over-$k$ consumer, and forwards the canonical (stalk-side) presentation to `\cref{lem:GrpObj_cotangent_bridge}` as a future bridge (cost 300–600 LOC) deferred until a non-rigidity consumer materialises.

- **Revised** `lem:GrpObj_cotangent_bridge` statement and proof:
  - **Added `\notready`** marker after `\uses{lem:GrpObj_cotangentSpace}` in the lemma block (parallel to `lem:GrpObj_lieAlgebra_finrank`'s `\notready`).
  - **Hedged LHS framing** in the statement: changed "the left-hand side is the iter-128 evaluate-then-extend-scalars Lean body of \cref{lem:GrpObj_cotangentSpace}" → "the left-hand side is the iter-130+ chart-base-changed Kähler Lean body of \cref{lem:GrpObj_cotangentSpace}".
  - **Replaced the "tautological" framing** at the end of the proof body: dropped "the bridge is a tautological identification of two constructions of the same $k$-module, valid for any group scheme with an identity section in $\Over\,(\Spec k)$" and replaced with prose acknowledging the bridge is non-trivial (localisation step + standard $k \otimes_R \Omega_{R/k} \cong \mathfrak m/\mathfrak m^2$ step) and estimated at 300–600 LOC, deferred until a non-rigidity consumer requires canonicity. Steps 1 + 2 of the proof are kept intact (they are the correct chain).

- **Revised** `proof of lem:GrpObj_lieAlgebra_finrank` — appended a new *emph "Iter-130 closure path under Replacement (B)"* paragraph at the end of the proof (after the Mathlib name summary), recording the exact iter-130 body shape `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V)/Γ(Spec k, U)])` and the four verified Mathlib closure-chain names:
  - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  - `Module.finrank_baseChange` (`Mathlib.LinearAlgebra.Dimension.Constructions`)
  - `Algebra.TensorProduct.instFree` (`Mathlib.RingTheory.TensorProduct.Free`)
  - `Algebra.IsStandardSmooth.free_kaehlerDifferential`
  All four flagged as "verified in Mathlib b80f227 by the iter-130 plan agent" per the directive's verified-names list.

## Cross-references introduced
- New citation of `\cref{thm:smooth_locally_free_omega}` in the revised proof of `lem:GrpObj_cotangentSpace` — verified: this label exists in `blueprint/src/chapters/Differentials.tex` (it is referenced verbatim by Step 4 of the same chapter at the existing `\cref{thm:smooth_locally_free_omega}` mention, line 197 of the new file, untouched).
- No new `\uses{...}` directives added or removed; all existing `\uses` dependencies (e.g. `\uses{lem:GrpObj_cotangentSpace}` in the bridge proof) are preserved.

## Macros needed (if any)
- None. The new prose uses only macros already present in the chapter (`\Spec`, `\Over`, `\GrpObj`, `\finrank`, `\cref`, `\texttt`, `\emph`, `\notready`).

## Reference-retriever dispatches (if any)
- None. The directive supplied all the mathematical content (Replacement (B) construction + closure chain + caveat prose) verbatim. The analogy file `analogies/lieAlgebra-rank-bridge.md` (which I read for context) is the load-bearing internal reference and is already in-tree; no external sources required.

## Verification of LaTeX validity (visual)
- All `\begin{lemma}`/`\end{lemma}`, `\begin{proof}`/`\end{proof}`, `\[...\]`, and `\texttt{...}` pairs match in the edited region (re-read after each edit).
- The `\leanok` marker on the proof of `lem:GrpObj_cotangentSpace` is left in place per the project convention that the `sync_leanok` deterministic phase manages those markers; it is now strictly the sync-leanok phase's job to flip it off if the post-iter-130 Lean body breaks. The directive did not instruct me to remove it.
- New iter-130 closure-path paragraph in `lem:GrpObj_lieAlgebra_finrank`'s proof uses math-mode within `\texttt{...}` blocks (e.g. `$\psi_V$`, `$\Gamma(G, V)$`, `$\Omega[\Gamma(G, V)/\Gamma(\Spec k, U)]$`) — standard LaTeX, no compile risk.

## Notes for Plan Agent

1. **Stale `% Lean signature stub` comment in `lem:GrpObj_cotangent_bridge`.** The `% Lean signature stub (iter-130+ build target; bridges the iter-128 body construction to the local-ring cotangent space supplied by Mathlib)` comment (chapter lines 127–135) still says "iter-128 body construction" although the LHS framing in the statement has been hedged. The directive explicitly scoped the LHS hedge to the statement+proof prose only, so I did not touch the comment. The comment is internal documentation only — non-blocking — but if the plan agent wants the chapter to be fully realigned, a one-line tweak to that comment ("iter-130+ chart-base-changed body" instead of "iter-128 body construction") would close the gap.

2. **`% Lean signature stub` in `lem:GrpObj_cotangentSpace`.** The signature stub at chapter lines 96–102 still says "pinned post-iter-129 fixup" — accurate for the *signature* (the iter-129 rename + relax to `{n : ℕ}` parameter still holds), so I left it. The body change is iter-130 but does not affect the signature, so this comment is correct as written.

3. **Iter-128 vs iter-130 body references in Step 4 cross-check of `lem:GrpObj_lieAlgebra_finrank`.** Lines 191 + 197 (within the proof, untouched per directive) still mention "the iter-128 evaluate-then-extend-scalars body" when describing the Step 1 bridge starting point. These are pre-Replacement-(B) phrasings. The Step 4 cross-check now lands on the same target as the iter-130 body (since Replacement (B) *is* the affine-chart Kähler route), so the cross-check is structurally fine — but the prose still refers to "the iter-128 body" as if the bridge had to start there. A future cleanup pass should re-thread the references; out of scope this iter per directive.

4. **No cross-chapter inconsistencies surfaced** in the regions I touched (Piece (i) subsection only). The shared-pile inventory paragraph (§ Shared cotangent-vanishing Mathlib pile, lines 60–79) and the (i.b)/(i.c) lemmas are unchanged and remain Replacement-(B)-compatible.

5. **`kbar` → `k` rename** is out of scope this iter per directive; I left line 14 paragraph untouched.

## Strategy-modifying findings
None. The Replacement (B) decision and its consequences (canonicity caveat, bridge cost shift from "tautological" to 300–600 LOC, four verified Mathlib closure names) are all decisions taken by the iter-129 mathlib-analogist and the iter-130 plan agent *before* this writer pass; the chapter prose now reflects those decisions. No new mathematical surprises while drafting.
