# Directive — effort-breaker, slug `tq-rectangular` (iter-065)

## Target
`def:tautological_quotient` in `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (~L1371) — specifically its ONE remaining formalization gap: the **overlap-compatibility condition** of the `glueLift` assembly (Lean: `AlgebraicGeometry.Grassmannian.tautologicalQuotient`, single sorry at GrassmannianQuot.lean:1973). Everything else in the block (glueLift primitive, per-chart components `tautologicalQuotientComponent`, the universal sheaf `universalQuotient`) is DONE axiom-clean.

## Granularity
One level — split along the proof's main seams (4 pieces below). The prover left a precise recipe; cut along it.

## Proof structure (from the iter-064 prover's task result — cut along these seams)
1. **Rectangular matrixEnd** (def + pullback lemma): the existing `def:gr_matrixEnd` / `lem:gr_matrixEnd_pullback` are SQUARE (`Matrix (Fin d) (Fin d)`). The chart quotient `chartQuotientMap` is the morphism `free (Fin r) ⟶ free (Fin d)` of a RECTANGULAR `d × r` matrix. Needed: a rectangular analogue `matrixEndRect` (or state directly for the hom induced by a `Matrix (Fin d) (Fin r)`) and its pullback-naturality lemma — same proof skeleton as `lem:gr_matrixEnd_pullback`: extensionality over the free-module coproduct injections (`ιFree`), one `scalarEnd_pullback` application per matrix entry.
2. **Rectangular composition law**: square ∘ rectangular — `matrixEnd N ≫ matrixEndRect M = matrixEndRect (M * N)` (mind the order convention used by the existing `lem:gr_matrixEnd_comp`). Same biproduct-extensionality proof.
3. **Adjunction transposition of the overlap condition**: the `glueLift` condition for the pair (I,J) transposes, under the pullback–pushforward adjunction of the overlap immersion, to the pullback-level identity `bundleTransition.hom ∘ f_IJ^* u^I = (t_IJ ≫ f_JI)^* u^J` (after free-pullback comparisons). The adjunction toolkit (`homEquiv_conjugateEquiv_app`, `conjugateEquiv_pullbackComp_inv`) is in-file and proven — \uses the existing blocks (`lem:gr_homEquiv_conjugateEquiv_app` exists in this chapter and is currently an ISOLATED node — wiring it into this piece's \uses is required).
4. **Matrix core**: after pieces 1–3 the identity reduces to the d×r matrix identity `g_{I,J} X^I = (X^I_J)^{-1} X^I = X^J` on the overlap — already the content of the block's own prose, and ALREADY PROVEN on the Cells side as `universalMatrix_map_transitionPreMap` / `imageMatrix` (public, chapter Picard_GrassmannianCells.tex). This piece is the assembly lemma consuming 1+2+3 and the Cells facts.

## Constraints
- The mathematical core is already cited in the target block (Nitsure §1, source quote present). The sub-lemmas are project-bespoke transport infrastructure — no new external source quotes required; \uses the cited parents instead.
- All `\uses{}` must resolve (cross-chapter Cells refs allowed). Do NOT touch `\leanok`/`\mathlibok` markers.
- Suggested forward `\lean{}` pins in namespace `AlgebraicGeometry.Grassmannian` (e.g. `matrixEndRect`, `matrixEndRect_pullback`, `matrixEndRect_comp`, `tautologicalQuotient_overlap`); keep names consistent with the existing square API.
