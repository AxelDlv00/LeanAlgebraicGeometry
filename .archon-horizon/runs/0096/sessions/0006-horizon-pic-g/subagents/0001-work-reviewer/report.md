You are auditing the work of horizon lane `pic-g` in run 0096 round 2, in the workspace /home/axel/LeanAlgebraicGeometry-Horizon, project MainProjects/Algebraic-Jacobian-Challenge-Rebuild.

THE TWO FILES TO AUDIT (both at HEAD, both verified building):
- MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0VanishingRoute.lean
- MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Albanese/Genus0VanishingDatum.lean

Relevant commits: f9f885abbd, dc63ffdbf7, and pic-d's sweep adf289ba79 which banked part of it.
Use the ledger git via: git --git-dir /home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git --work-tree /home/axel/LeanAlgebraicGeometry-Horizon <args>

THE CLAIM I MADE, which is what you should try hardest to refute:
"Every JacobianData producer in this tree consumes the same chart family, so the three
antecedents the board tracks (rep, IsChartUniv, coverage) are antecedents of ONE ROUTE and not
of the goal. jacobianData_of_subsingleton is a second route with none of them."

WHAT I WANT YOU TO CHECK, in this order of value:

1. IS THE ENUMERATION TRUE? The header names seven producers (JacobianData.ofCharts,
   ofChartsOfCompactSpace, ofAbelImage, ofChartsOfAbelImage, jacobianDataOfMixedParamCharts,
   jacobianDataOfCompactFromClass, jacobianDataOfFiniteMixedParamCharts) and asserts they all
   consume the same chart family. Census EVERY declaration in the project whose type is or
   returns `JacobianData C` (grep is fine here, plus check JacobianDataFromPicRepDatum.lean and
   JacobianData.ofRepresentableBy) and tell me if ANY producer already existed that does not go
   through the atlas. If one does, my headline is an overclaim and I need to know now. Note
   JacobianData.ofRepresentableBy is the general constructor -- decide whether its existence
   makes my "second route" claim trivial or not, and say which.

2. IS ANY DOCSTRING CLAIM FALSE OR UNVERIFIABLE? In particular:
   - I claim both finiteness fields are free "because the structure morphism IS an identity".
     Check locallyOfFiniteType_terminal and quasiCompact_terminal actually prove that.
   - I claim `subsingleton_picEtAff_of_forall` is a genuine CONVERSE of
     `subsingleton_picEt_of_affine`. Check whether the two really are converse (note one is
     stated at picEt and one at PicEtAff -- is the round trip honest, or is there a
     quantifier/carrier mismatch that makes "converse" wrong?).
   - I claim `subsingleton_pic0_of_affine`'s inheritance runs only one way (picEt vanishing =>
     pic0 vanishing, never the reverse). Is that right?
   - EVERY declaration name cited in either file's prose: verify it EXISTS and is in that
     file's import closure. A name in the source tree but outside the closure is still a
     phantom citation. Check especially the names in Genus0VanishingDatum's header
     (JacobianData.isTerminal_of_pic0Subgroup_eq_bot,
     JacobianData.existsUnique_ofCurve_comp_of_pic0Subgroup_eq_bot,
     subsingleton_of_pic0Subgroup_eq_bot) and the seven producer names in Pic0VanishingRoute's
     header.

3. IS THE VANISHING ROUTE VACUOUS IN A WAY I MISSED? The hypothesis
   `forall T, Subsingleton (pic0Subgroup C T)` -- is it SATISFIABLE for any curve at all in
   this tree's binder setup (SmoothOfRelativeDimension 1, IsProper, GeometricallyIrreducible)?
   If it is satisfiable only vacuously, or if some standing instance makes it outright false
   for every C, my "produces a datum for degenerate curves" sentence is wrong and the whole
   file is about nothing. Also check: does anything in the tree already PROVE this hypothesis
   or its negation?

4. THE GENUS0 CLAIM. I assert in Genus0VanishingDatum that the AJCR.w6-albanese.genus0 row is
   NOT gated behind divRep, and that "the datum binder and the vanishing hypothesis were never
   independent". Read the actual row summary (.archon-horizon/roadmap/items/
   AJCR.w6-albanese.genus0.yaml) and Genus0Terminal.lean, then tell me whether my sentence is
   accurate or whether I am overstating what the binder removal buys.

Report concrete defects with file:line. If a claim is fine, say so briefly rather than
elaborating. Be adversarial: this lane has a documented history of self-critical overclaims
that read as audited, and of citing declarations that do not exist in the citing file's closure.
