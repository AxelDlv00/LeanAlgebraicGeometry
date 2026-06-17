# Effort-breaker directive

## Target
`lem:gr_bundleCocycle_transport` in `blueprint/src/chapters/Picard_GrassmannianQuot.tex`
(Lean: `AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport`, currently
NO Lean decl — forward-planning pin).

## Granularity
One level. Split into the two net-new infrastructure pieces the iter-061 prover named
(see `informal/bundleTransition_cocycle_L3_transport.md`), plus keep the residual
assembly as the (now thinner) `lem:gr_bundleCocycle_transport`.

## Proof structure (cut along these seams — verbatim from the prover's roadmap)
The current L3 transport bundles TWO independent net-new lemmas. Split them out:

- **(a) matrixEnd-under-pullback naturality.** New sub-lemma `lem:gr_matrixEnd_pullback`
  (\lean target `AlgebraicGeometry.Grassmannian.matrixEnd_pullback`). For `p : T ⟶ S`
  and `M : Matrix (Fin d) (Fin d) Γ(S,⊤)`:
  `(Scheme.Modules.pullback p).map (matrixEnd M) = (pullbackFreeIso p (Fin d)).hom ≫
  matrixEnd (p.appTop.mapMatrix M) ≫ (pullbackFreeIso p (Fin d)).inv`.
  Proof seam: `matrixEnd M` = coproduct-comparison ∘ `biproduct.matrix (scalarEnd∘M)` ∘
  comparison; `pullback p` is a left adjoint ⇒ additive ⇒ commutes with `biproduct.matrix`
  up to the coproduct comparison; the genuine new atom is the SINGLE-ENTRY statement
  `(pullback p).map (scalarEnd a)` conjugated by the unit-pullback comparison
  (`pullbackObjUnitToUnit`) equals `scalarEnd (p.appTop a)` — i.e. **scalarEnd naturality
  under pullback**. Make that atom its own sub-lemma `lem:gr_scalarEnd_pullback` if it
  helps (\lean `…scalarEnd_pullback`). \uses: def:gr_matrixEnd, def:gr_scalarEnd,
  lem:gr_pullbackFreeIso, def:modules_pullback (and the scalarEnd-naturality atom).

- **(b) base-change bridge.** New sub-lemma `lem:gr_baseChange_bridge`
  (\lean `…baseChange_bridge`). Identify the scheme-pullback base-change maps
  `Γ(U^I_J,⊤) ⟶ Γ(V_IJK,⊤)` (induced by the projections / triple transition `t'`)
  with L1's ring homs `cocycleΘIJ` / `awayInclLeft` / `awayInclRight` over which
  `lem:gr_bundleCocycle_matrix` is stated, via `ΓSpecIso` naturality on the affine
  charts and the way `theGlueData`/`chartTransition` are assembled from `transitionMap`.
  \uses: def:gr_transition, def:gr_glued_scheme, lem:gr_bundleCocycle_matrix, and the
  ΓSpecIso / chartTransition decls already in the chapter.

- **Residual `lem:gr_bundleCocycle_transport`.** Keep, but rewrite its proof to *consume*
  (a) and (b): granting `lem:gr_matrixEnd_pullback` (each transported transition becomes
  `matrixEnd` of a base-changed Cramer inverse) and `lem:gr_baseChange_bridge` (the
  base-changed matrices ARE the `cocycleΘ/awayIncl` forms of L1), the assembly is exactly
  the existing src/mid/tgt-bridge cancellation + `lem:gr_matrixToFreeIso_mul` (L2) +
  `lem:gr_bundleCocycle_matrix` (L1) chain already written. Add (a),(b) to its \uses.

## Constraints
- Project-bespoke infra (no external source); no `% SOURCE` lines needed on the new blocks.
- Do NOT add `\leanok` (sync owns it). The new `\lean{}` pins name decls the prover will
  build this iter — that is expected (forward pins).
- Keep each new block's statement precise enough to formalize; one mathematical claim per
  lemma. Wire `\uses{}` accurately in BOTH the statement block and the proof block.
- Do not touch any other chapter or any block outside the L3 → (a)/(b)/assembly split.
