# T16 session 0002 — reconcile checklist (wave 2)

## Expected agent commits (verify each landed + kernel-green)
- [ ] P1ChartData.lean: instP1HasLaurentChartData live (gate 2 / N11b) — laneA
- [ ] Cohomology/BasicOpenCoboundary.lean (V1 algebra brick) — brickV1
- [ ] Cohomology/HModuleSections.lean (H0 sections equiv + naturality) — brickH0
- [ ] RiemannRoch/Adelic/DegreeOneComparison.lean (MV-LES degree-1 comparison + capstone-from-hvan) — asmC
- [ ] Cohomology/AffineH1Vanishing.lean (degree-1 affine vanishing keystone) — vanA

## My reconcile steps
1. Register new modules in AlgebraicJacobian.lean (agents told NOT to touch it):
   AlgebraicJacobian.Cohomology.BasicOpenCoboundary, .Cohomology.HModuleSections,
   .Cohomology.AffineH1Vanishing, .RiemannRoch.Adelic.DegreeOneComparison (+ capstone file below).
2. Write RiemannRoch/Adelic/GenusUnconditional.lean:
   theorem module_finite_hModule_one (C) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
     [GeometricallyIrreducible C.hom] : Module.Finite k (HModule k (toModuleKSheaf C) 1)
   Proof skeleton: haveI Smooth := SmoothOfRelativeDimension.smooth 1 C.hom;
   haveI GeometricallyReduced := geometricallyReduced_of_smooth C.hom;
   haveI GeometricallyIntegral := .of_geometricallyReduced_of_geometricallyIrreducible C.hom;
   (⟹ instance chain existsNonconstantMapToProjInt_of_ajc → ExistsNonconstantMapToP1 → HasFiniteMapToP1;
    P1HasLaurentChartData from laneA instance — import P1ChartData!)
   exact module_finite_hModule_one_of_pieceVanishing C (affineHModuleOneVanishing C)
   Also: corollary `genus`-honesty statement if a natural form exists (genus C = finrank; Module.Finite makes it meaningful — consider `0 < finrank ↔ ...` NO, just the Finite instance + a doc comment; maybe restate as instance for downstream synthesis).
3. Full `lake build` (foreground, blocking) + recount sorries + axiom audit (lean_verify) on:
   instP1HasLaurentChartData, exists_coboundary lemma, sections equiv, hModuleOneEquivH1CokOfPieceVanishing,
   subsingleton_hModule'_one_of_isAffineOpen, module_finite_hModule_one.
4. Blueprint sync agent (sonnet): new nodes in RiemannRoch_Adelic.tex (+ Cohomology chapter placement),
   mark N11b \leanok, replace gate-4 narrative with the degree-1 route, wave-9 sync leftovers.
5. Commit registration + capstone; task comment T16; memory update (route design + recipes);
   inbox handoff item superseding I-0136 if session ends before Jacobian assembly work.

## Known wrinkles to watch
- Ext.{u} vs Ext.{u+1} universe bridge in asmC (chgUnivLinearEquiv).
- Sign conventions: fromBiprod = desc(map f₁₂, −map f₁₃) vs sectionDiff = fst−snd (ranges negation-stable).
- toModuleKSheaf sections ↔ Γ(X,·) bridge (vanA + brickH0 item 4).
- GeometricallyIntegral needed by existsNonconstantMapToProjInt_of_ajc; bridge via haveI chain (NOT instances).
- HasSheafCompose (forget (ModuleCat k)) + Balanced 𝒮 prerequisites of isLocallySurjective_iff_epi'.
