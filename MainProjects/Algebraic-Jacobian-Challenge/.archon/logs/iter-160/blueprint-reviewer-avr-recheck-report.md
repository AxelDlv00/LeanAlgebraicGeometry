# Blueprint Review Report

## Slug
avr-recheck

## Iteration
160

## Top-level summaries

### Incomplete parts
- `AbelianVarietyRigidity.tex` / `thm:rigidity_lemma`: the iter-159 laundering must-fix is only **half-closed**. The headline Rigidity Lemma still renders as fully proven (`\leanok`, no `\uses`) while its Lean declaration carries transitive `sorryAx` through `rigidity_core → rigidity_eqOn_dense_open → rigidity_eqOn_saturated_open_to_affine` (`sorry`). The three writer edits de-laundered `lem:rigidity_eqOn_dense_open` only (and even that is graph-parser-dependent — see Cross-chapter notes); `thm:rigidity_lemma` has **no `\uses` edge at all**, so nothing the writer did this round reaches it.

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}`: target is **well-formulated** — the prover target itself is sound (signature matches the prose hypotheses exactly; route-B proof prose is concrete and cohomology-free). No quality finding on the target; the finding above is about marker-graph honesty of the *upstream* `thm:rigidity_lemma`, not about this target.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **MUST-FIX (laundering persists on `thm:rigidity_lemma`).** Dependency-graph dump: `thm:rigidity_lemma => uses [] | leanok True`. It has zero `\uses` edges in *either* its statement (lines 53–72) or its proof (lines 84–133), yet its Lean body transitively depends on the lone chain `sorry` (`rigidity_eqOn_saturated_open_to_affine`). It therefore colors fully-proven — exactly the iter-159 laundering vector, still live for the chain's headline lemma. **Fix:** add `\uses{lem:rigidity_eqOn_dense_open}` to `thm:rigidity_lemma`'s **proof** block (a forward edge), so the not-proven status of the `sorry` leaf propagates up to the headline.
  - **Wrong-direction `\uses` edges + a 2-cycle.** The chain's true Lean dependency is `rigidity_lemma → dense_open → saturated_open`, but the blueprint edges point the *opposite* way: `lem:rigidity_eqOn_dense_open` statement `\uses{thm:rigidity_lemma}` (line 180, pre-existing) and the **new** `lem:rigidity_eqOn_saturated_open_to_affine` `\uses{lem:rigidity_eqOn_dense_open}` (lines 311 + 337). Combined with the new dense_open *proof* edge `\uses{… lem:rigidity_eqOn_saturated_open_to_affine}` (line 238), this introduces a genuine 2-cycle `dense_open ⟷ saturated_open`. **Recommended single fix for both notes:** drop the two backward edges and model the chain forward — `thm:rigidity_lemma` (proof) `\uses{lem:rigidity_eqOn_dense_open}`, `lem:rigidity_eqOn_dense_open` (proof) `\uses{lem:rigidity_eqOn_saturated_open_to_affine}`, and `lem:rigidity_eqOn_saturated_open_to_affine` as a leaf with **no** downward `\uses`. That de-launders both upstream nodes and removes the cycle in one pass.
  - **CONFIRMED applied (the three directive edits, mechanically present):** (1) new block `lem:rigidity_eqOn_saturated_open_to_affine` exists with `\label` + `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` + a `\uses` edge (lines 307–334); (2) `lem:rigidity_eqOn_dense_open`'s proof `\uses` now lists the new label (line 238); (3) `rmk:rigidity_lemma_decomposition` refreshed — no longer says "two residual sorries," now reads "one remaining obligation … lone remaining `sorry`, extracted" (lines 160–172). The edits were made as described; they are simply **insufficient** to close the laundering for `thm:rigidity_lemma`.
  - **CONFIRMED signature match (exact).** Blueprint hypotheses ↔ Lean `rigidity_eqOn_saturated_open_to_affine` (AbelianVarietyRigidity.lean:124–141): `[IsAlgClosed kbar]`, `[IsProper X.hom]`, `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`, `f : X⊗Y ⟶ Z`, `x₀ : 𝟙_ ⟶ X`, saturated open `U` with `(U : Set) = (snd X Y).left.base ⁻¹' Vset`, affine `U₀` (`IsAffineOpen`), `f(U) ⊆ U₀`, conclusion `U.ι ≫ f.left = U.ι ≫ (lift (toUnit (X⊗Y) ≫ x₀) (snd X Y) ≫ f).left`. All antecedents present and load-bearing in the prose.
  - **CONFIRMED route-B proof prose.** Step 1 = per-closed-slice constancy (κ(y)=k̄, `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closedness ⇒ Γ(Xy)=k̄, `ext_of_isAffine`); Step 2 = globalisation over dense closed points (`closure_closedPoints`/Jacobson ⇒ dense probe ⇒ `ext_of_isDominant_of_isSeparated'`). The relative Stein-factorisation / proper-pushforward `f_*𝒪 = 𝒪` framing is explicitly recorded as a deliberately-avoided Mathlib gap (lines 281–305, 341–343). This is the cohomology-free per-slice argument, not Stein. Good.
  - **Stale comment (informational).** The iter-159 TODO comment (lines 101–107) still asserts both `thm:rigidity_lemma` *and* `lem:rigidity_eqOn_dense_open` launder; given the partial fix it is now half-stale. Worth updating when the must-fix above is applied. (It is a `%`-comment, not a graph edge — no coloring impact.)
  - **Citation: clean.** New block is a project-bespoke decomposition ("Bridge 2 … formalization realization"); it carries `% SOURCE:` (mumford-abelian-varieties.pdf, exists on disk), `% SOURCE QUOTE PROOF:` (verbatim Mumford "for each $y\in V$ …" step), and a matching visible `\textit{Source:}` line. No `% SOURCE QUOTE:` for the *statement* is correct here — the statement is the project's formalization slicing, not a verbatim Mumford restatement. No citation finding.

### Rest of the blueprint
All-clear (carried forward from the iter-159 full audit; no chapter other than `AbelianVarietyRigidity.tex` was edited this round). Spot-confirmed: `AbelianVarietyRigidity.tex`'s only cross-chapter `\uses` (`def:genus`) resolves to `Genus.tex` (`\label{def:genus}`, `\lean{AlgebraicGeometry.genus}`), which is present and well-formed.

## Cross-chapter notes
- **Tooling caveat (affects how the plan agent verifies the fix).** The project helper `dependency_graph.py` reports `lem:rigidity_eqOn_dense_open => uses ["thm:rigidity_lemma"]` — i.e. it captured only the **statement** `\uses` (line 180) and dropped the **proof-level** `\uses` edge to `saturated_open` (line 238). If the *rendered* leanblueprint graph shares this statement-only parsing, then the directive's edit 2 had **no effect** and `dense_open` is *also* still laundered. Standard leanblueprint does honor proof `\uses` for proof-coloring, so the rendered graph likely de-launders `dense_open` correctly — but `thm:rigidity_lemma` (zero edges anywhere) is laundered under *either* parser. Recommend the plan agent confirm against the actual `blueprint/web` graph, not the helper script, when re-gating.

## Severity summary

- **must-fix-this-iter (1):** `AbelianVarietyRigidity.tex` is `correct: partial` — `thm:rigidity_lemma` still launders (and the two backward `\uses` edges + 2-cycle are part of the same single fix). Per the HARD GATE, `AlgebraicJacobian/AbelianVarietyRigidity.lean` does **not** clear the gate this iter; the `rigidity_eqOn_saturated_open_to_affine` prover lane stays deferred until a writer adds the forward `\uses` edge and a scoped re-review returns `complete + correct`.
- **soon:** none.
- **informational:** stale iter-159 TODO comment (lines 101–107).

Notes for plan agent: the *prover target itself* (`rigidity_eqOn_saturated_open_to_affine`) is sound and exactly specified — the must-fix is purely a marker-graph (`\uses`) integrity defect on the upstream `thm:rigidity_lemma`, fixable in one tiny writer edit (add `\uses{lem:rigidity_eqOn_dense_open}` to `rigidity_lemma`'s proof; drop the two backward edges). A same-iter writer round + scoped re-review can clear the gate without losing the iter.

Overall verdict: `AbelianVarietyRigidity.tex` is complete but `correct: partial` — the three directive edits are mechanically present and the new Bridge-2 block is sound and signature-faithful, but the iter-159 laundering must-fix is only half-closed: `thm:rigidity_lemma` has no `\uses` edge reaching the chain `sorry` and still renders fully proven, so the HARD GATE does not clear for `AbelianVarietyRigidity.lean` this iter.
