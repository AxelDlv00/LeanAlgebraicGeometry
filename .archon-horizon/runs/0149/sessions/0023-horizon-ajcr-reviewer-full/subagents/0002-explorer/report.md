Read-only audit complete. No files changed.

The AJCR bridge is already structurally ready:

- [`PicRepDatum`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:89) has `J`, an étale `pic0TypeFunctor` representation, and `lft`, at `Type (u+1)`.
- [`PicRepDatum.toJacobianData`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:83) takes only `d : PicRepDatum k k C` and `QuasiCompact d.J.hom`; its `rep` assignment is definitional. `#print axioms` reports only `propext`, `Classical.choice`, `Quot.sound`, not `sorryAx`.
- A raw `pic0_representableBy : Σ J, (pic0TypeFunctor C).RepresentableBy J` is insufficient alone: it still needs `LocallyOfFiniteType J.hom` and `QuasiCompact J.hom`. [`JacobianData.ofRepresentableBy`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:71) is the direct three-input constructor; a `PicRepDatum` supplies the first two fields, leaving only QC.
- The exact generic assembly is already recorded as [`PicRepDatum.toJacobianDataOfAbelLifts`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:140).

For the five frozen Challenge obligations, a kernel-clean arbitrary-field producer must have the shape:

```lean
noncomputable def jacobianData (C : Over (Spec (.of k))) [...] :
    JacobianData C :=
  (picRepDatum C).toJacobianData (quasiCompact_picRep C)
```

No rational-point assumption belongs in this signature. A finite-level `PicRepDatum k k' C'` cannot directly close it: it must first descend to `PicRepDatum k k C`.

Minimal Challenge rewiring after that producer exists:

1. Import its pre-`Challenge` Picard module and set `Jacobian C := (jacobianData C).J` at [`Challenge.lean:96`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:96).
2. Set `Jacobian.instGrpObj := (jacobianData C).grpObj` at [line 107]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:107). This is definitionally compatible with the Abel map helpers.
3. Representation alone does not close the remaining three AV fields:
   - relative dimension needs `SmoothOfRelativeDimension (genus C) d.J.hom`, explicitly isolated at [`JacobianAbelianVariety.lean:117`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/AbelianVariety/JacobianAbelianVariety.lean:117);
   - properness and geometric irreducibility need `AbelSourceData d`, via [`isAbelianVariety_of_abelSource_of_relativeDimension`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/AbelianVariety/JacobianAbelianVariety.lean:130).
4. Then the first five `sorry`s at Challenge lines 99, 108, 113, 120, 127 are direct projections/theorems from the single datum plus those two honest geometric certificates.

Downstream headline pieces are also prepared but not discharged by representability alone:

- `Jacobian.ofCurve` and its pointing identity follow from [`JacobianData.ofCurve` and `.comp_ofCurve`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataAbel.lean:62).
- Functoriality is supplied datum-wise by [`pullbackHom`, `_id`, `_comp`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0PullbackGrp.lean:77).
- Base-change representation and group isomorphism are supplied by [`JacobianData.baseChange`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataBaseChange.lean:59) and [`baseChangeIsoOfData`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataBaseChange.lean:227). The Abel compatibility still needs the named Cech core hypothesis at [`JacobianDataBaseChangeAbelCore.lean:173`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataBaseChangeAbelCore.lean:173).

The current Challenge’s direct axiom footprint remains `sorryAx` for `Jacobian`, `instGrpObj`, and the dimension instance. Its other frozen `sorry`s include Abel-Jacobi, Albanese universality, functor laws, and base-change/coherence at [Challenge lines 131-170 and 256-296]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:131); they are not implied merely by `PicRepDatum`.

Import feasibility: AJCR’s `JacobianData` does not import `Challenge`, and the direct import probe succeeded, so a pre-Challenge producer module is viable. The sibling AJC project is a separate Lake library with the same library name and no cross-package dependency in either `lakefile.toml`; it cannot consume AJCR declarations by adding an ordinary import. Port the AJCR implementation into AJCR’s own `Challenge`, rather than attempting a cross-project import.

The old AJC `picardJacobianWitness` is independent and still `sorryAx`-reachable; its stated five upstream étale obligations are documented at [`AJC/Jacobian.lean:848`]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean:848). It is not the AJCR `JacobianData` route.
