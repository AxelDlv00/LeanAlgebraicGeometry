# Blueprint Writer Directive

## Slug
abeljacobi-galois-iter131

## Chapter
`blueprint/src/chapters/AbelJacobi.tex` (single chapter — three small prose fixes)

## Strategy context

The project's iter-127 over-k commitment dropped Galois descent (M2.c) and `geomIrred.exists_kalg_pt` (M2.c.aux) from the M2 critical path. The over-k cotangent-vanishing rigidity pile (pieces (i)+(ii)+(iii) in `RigidityKbar.tex`) builds directly over an arbitrary base field `k`; there is NO base-change-and-descent step in the genus-0 sub-case of the universal-property proof. `Jacobian.tex` § C.2.f cleanly marks Galois descent as DROPPED. `AbelJacobi.tex`'s parallel "Classical description" prose was NOT realigned in iter-127, and the blueprint-reviewer iter-131 audit flagged this as `correct: partial` (must-fix-this-iter).

## Required edits

Make THREE prose realignments in `blueprint/src/chapters/AbelJacobi.tex`:

1. **Line ~82** (proof of `thm:exists_unique_ofCurve_comp`, "Classical description" half): currently reads (paraphrase) "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ over the algebraic closure ...together with Galois descent of morphism equality back to $k$". Rewrite to describe the over-k path: rigidity for $C \to A$ directly over $k$ via `\cref{thm:rigidity_over_kbar}` (the named declaration is k-agnostic per the iter-127 over-k commitment). Drop the "Galois descent" phrase. The genus-0 sub-case factors directly through the over-k rigidity argument on the $C(k) \neq \emptyset$ branch (marked point pickoff) + vacuity on the $C(k) = \emptyset$ branch (Brauer–Severi-like obstruction; `isAlbaneseFor` field is vacuously true).

2. **Line ~87** (closing "Implementation route via the Albanese framework" section): currently "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ together with Galois descent (genus-0 sub-case)". Rewrite to "rigidity for $C \to A$ directly over $k$ (genus-0 sub-case, via `\cref{thm:rigidity_over_kbar}` post the iter-127 over-k commitment)".

3. **Line ~89** (same section as #2): currently "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ followed by Galois descent". Rewrite as in #2 — drop the "$\mathbb P^1_{\bar k} \to A_{\bar k}$" framing and the "Galois descent" phrase, replace with the direct over-k path.

The line numbers are approximate (the chapter has ~94 lines; the affected prose is in the back half). Read the chapter, find the three "Galois descent" mentions in the "Classical description" + "Implementation route" sections, and rewrite each.

## Out of scope

- Do NOT modify any other chapter.
- Do NOT touch `\lean{...}` hints (the three protected `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp` Lean names remain unchanged).
- Do NOT modify the parts of the chapter not flagged as stale — the rest of `AbelJacobi.tex` is `complete: true, correct: true` per blueprint-reviewer-iter131.
- Do NOT add `\leanok` / `\notready` / `\mathlibok` markers (those are deterministically managed).
- Do NOT modify any `\uses{...}` cross-references (the dependency graph for `AbelJacobi.tex` is correct).

## References

- `analogies/cotangent-vanishing-pile-over-k.md` — iter-127 over-k commitment rationale (pieces (i)+(ii)+(iii) build directly over k; no base-change-and-descent step).
- `blueprint/src/chapters/Jacobian.tex` § C.2.f — the canonical "Galois descent DROPPED" prose to match against.
- `blueprint/src/chapters/RigidityKbar.tex` § "Iter-127 over-k commitment" — the over-k commitment's authoritative blueprint statement.

## Severity / sequencing

Must-fix-this-iter per blueprint-reviewer-iter131 (`AbelJacobi.tex` is `correct: partial`). No prover lane this iter touches `AbelJacobi.lean`, so this is purely a prose-alignment fix; the Lean declarations are unchanged.

Estimated edit volume: ~3 paragraphs of prose (15–30 lines total).
