Findings. All paths absolute; "does not exist" claims verified with `horizon search` (noted per item).

## (1) DAT-G0 β1 / `Pic0PreservesFilteredBaseColimit`

Three files carry the whole β1 story; all three are sorry-free (grep for the term `sorry` in them returns only docstring prose), and every declaration I kernel-checked reports only `[propext, Classical.choice, Quot.sound]`.

- **`Pic0PreservesFilteredBaseColimit` — EXISTS + PROVED-AS-STATEMENT, but it is a `Prop`-valued *definition*, not a theorem, and nothing in the tree inhabits it.**
  `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136`
  ```lean
  def Pic0PreservesFilteredBaseColimit : Prop :=
    ∀ ⦃J : Type u⦄ [SmallCategory J] [IsCofiltered J] (S : J ⥤ Over (Spec (.of k))),
      (∀ ⦃i j : J⦄ (f : i ⟶ j), IsAffineHom (S.map f).left) →
      (∀ i, CompactSpace (S.obj i).left) →
      (∀ i, QuasiSeparatedSpace (S.obj i).left) →
      ∀ [HasLimit S], PreservesColimit S.op (pic0TypeFunctor C)
  ```
  Binders: `{k} [Field k] (C : Over (Spec (.of k)))` with `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (`:104-105`). Grep for `: Pic0PreservesFilteredBaseColimit` across `AlgebraicJacobian/` finds **exactly one** occurrence and it is a hypothesis binder (`PicRepColimitMountain.lean:245`), never a conclusion. So the mountain is open, in the "named hypothesis" sense, not sorried.

- **`pic0TypeFunctor_baseChange_iso` — EXISTS + PROVED** (`PicRepColimitCompat.lean:119`): `pic0TypeFunctor ((baseChange k L).obj C) ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).op ⋙ pic0TypeFunctor C`, body `pic0ThetaType k L C` (landed, axiom-clean).

- **`preservesColimit_pic0TypeFunctor_baseChange` — EXISTS + PROVED** (`PicRepColimitCompat.lean:150`): the β1 reduction; consumes an instance `[PreservesColimit K ((Over.map σ).op ⋙ pic0TypeFunctor C)]` and yields `PreservesColimit K (pic0TypeFunctor ((baseChange k L).obj C))` via `preservesColimit_of_natIso`.

- **δ substrate (DG-G0.δ) — EXISTS + PROVED**, `/home/axel/.../AlgebraicJacobian/Picard/PicRepColimitResidual.lean`: `FinSubext` (`:90`), `instNonemptyFinSubext` (`:99`), `directed_finSubext` (`:105`), `instIsDirectedFinSubext` (`:115`), `instIsCofilteredFinSubextOp` (`:125`), `iSup_finSubext_eq_top` (`:132`), `coe_iSup_finSubext` (`:143`), `isSeparable_finSubext` (`:152`). Namespace `AlgebraicGeometry.DatG0`.

- **δ scheme system + its limit — EXISTS + PROVED**, `/home/axel/.../AlgebraicJacobian/Picard/PicRepColimitMountain.lean`: `deltaRingDiagram` (`:55`), `deltaCocone` (`:69`), `deltaIsColimit` (`:83`, needs `[Algebra.IsAlgebraic k K]`), `deltaSchemeMap` (`:113`), `deltaSchemeDiagram` (`:128`), affine/compact/quasi-separated instances (`:149`, `:154`, `:159`), `deltaScheme_forget_eq` (`:178`, `rfl`), `hasLimit_deltaScheme_forget` (`:185`), `HasLimit deltaSchemeDiagram` (`:195`, via `hasLimit_of_created`).

- **`preservesColimit_deltaScheme_of_residual` — EXISTS + PROVED** (`PicRepColimitMountain.lean:244`): takes `(h : Pic0PreservesFilteredBaseColimit C)` and gives `PreservesColimit (deltaSchemeDiagram (k := k) (K := K)).op (pic0TypeFunctor C)`. This is the only consumer of the residual anywhere. It closes every side condition (affine transitions, compact, quasi-separated) — so the residual's hypotheses cost zero at the δ system; only the residual body is open.

- **β·a / β·b / β·c frozen names from `informal/spec-datg0.md` §1.2 — DO NOT EXIST** (verified by `horizon search`, not just grep): `pic0Subgroup_isColimit_baseField`, `colimitComparison_pic0`, `representableBy_of_colimit_stage`. Searches return only the landed `preservesColimit_pic0TypeFunctor_baseChange` / `pic0TypeFunctor_baseChange_iso` / `DatG0.*` neighbours. The mathlib avatars cited in the docstrings (`CommRingCat.preservesColimit_coyoneda_of_finitePresentation`, `Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation`, `RingHom.EssFiniteType.exists_*_of_isColimit`, `AffineTransitionLimit` spreading lemmas) are **cited only in docstrings — no `.lean` file in `AlgebraicJacobian/` references any of them** (grep: the only `EssFiniteType` hits are unrelated, in `Curve/GeometricallyReduced.lean`, `Algebra/SmoothPrimeRegularity.lean`, `Algebra/DiagonalIdeal.lean`). So the reduction is landed but the analytic core has not been started.

- All four files are imported from the root: `AlgebraicJacobian.lean:244,245,246,247`; oleans present and current (built 2026-07-29 05:26-05:27).

## (2) `PicRepDatum` / 01JJ–DAT-GLUE slice assembly

**Structure** — `/home/axel/.../AlgebraicJacobian/Picard/PicRepDatum.lean:89`, three fields only:
`J : Over (Spec (.of k'))` (`:94`), `rep : (pic0TypeFunctor C').RepresentableBy J` (`:97`), `lft : LocallyOfFiniteType J.hom` (`:100`). Binders `(k k' : Type u) [Field k] [Field k'] [Algebra k k'] (C' : Over (Spec (.of k'))) [IsProper C'.hom] [SmoothOfRelativeDimension 1 C'.hom] [GeometricallyIrreducible C'.hom]`, `Type (u+1)`. `k` explicit is a recorded deviation from worksheet §3.3 (module docstring `:26-36`). No quasi-compactness field by design; no properness.

API on it, all EXISTS + PROVED: `homEquiv` (`:111`), `homEquiv_comp` (`:118`), `uniqueUpToIso` (`:126`), plus the `JacobianData.rep`-defeq `example` (`:144`).

**Complete list of producers/consumers** (`horizon search "PicRepDatum"` returns exactly 10 declarations, all in these two files):
- Consumers: `PicRepDatum.toJacobianData` (`/home/axel/.../Picard/JacobianDataFromPicRepDatum.lean:83`), `toJacobianData_J` (`:91`), `toJacobianData_rep` (`:96`), `homEquiv_toJacobianData` (`:105`), `toJacobianDataOfAbelLifts` (`:132`, packages qc via `quasiCompact_of_forall_residueField_lift_from_divScheme`, `Picard/JacobianDataAbelSurj.lean:118`), `toJacobianDataOfAbelLifts_J` (`:142`).
- **Producers: NONE.** Grep for `: PicRepDatum` in conclusion position returns only argument binders; `horizon search` confirms no declaration whose type is a `PicRepDatum`. The two names the docstrings advertise as its producers **do not exist** (verified by `horizon search`): `picRepDatumKprime` (named at `PicRepDatum.lean:65`) and `datGDatum` (named at `JacobianDataFromPicRepDatum.lean:17,21`). Likewise absent: `datG0Transfer`, `PicRepDatumKs`, `pic0RepKs`, `quasiCompact_jacobian` (all four `horizon search`-verified; `quasiCompact_jacobian` returns only unrelated `quasiCompact_*` lemmas).

**The 01JJ slice stack at the separably closed stage — LANDED, axiom-clean, but never instantiated:**
- `pic0TypeFunctor` (`Picard/Pic0SigmaSheaf.lean:58`), `pic0SigmaFunctor` (`:76`), `pic0SigmaFunctor_isSheaf` (`:90`, real 50-line proof), `pic0SigmaSheaf` (`:147`), and the seam `pic0RepresentableByOfCharts` (`:161`) whose body is `(Scheme.LocalRepresentability.representableBy hf).overSlice`.
- Σ-extension calculus: `Over.sigmaExtension` (`Picard/OverSigmaExtension.lean:125`) and the Σ-descent `Functor.RepresentableBy.overSlice` (`:235`) — both in-tree, not mathlib.
- Glue-side certificates: `chartHom` (`Picard/JacobianDataCharts.lean:114`), `gluedHom` (`:122`), `gluedOfCharts` (`:129`), `toGlued_comp_gluedHom` (`:140`), `locallyOfFiniteType_gluedHom` (`:154`), `quasiCompact_gluedHom` (`:164`, needs `[Finite ι]`), `JacobianData.ofCharts` (`:182`), `JacobianData.ofChartsOfCompactSpace` (`:209`, the shape the infinite atlas needs).
- B-6: `ChartsCoverLocally` (`Picard/Pic0ChartLocalSurjectivity.lean:86`) → `isLocallySurjective_sigmaDesc` (`:105`) → `chartsCoverLocally_of_pointwise` (`Picard/Pic0ChartCoveragePointwise.lean:129`). All proved. **No instance of `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)` is produced anywhere** — it is a `variable` in `JacobianDataCharts.lean:117`, `JacobianDataAbelSurj.lean:183`, `JacobianDataAbelImage.lean:131`, and the chain above bottoms out in the pointwise-coverage hypothesis (B-5).
- `hf` side: `mixedParamRepresentableBy` (`Picard/Pic0ChartAtlasParamFree.lean:126`) shows a heterogeneous atlas is admissible verbatim. `IsChartUniv` (`Picard/Pic0ChartPair.lean:173`) has exactly one producer, `isChartUniv_of_isChartLocusFibre` (`Picard/Pic0ChartUnivReduce.lean:176`), from the hypothesis `IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:154`) which **nothing produces** (grep: only a docstring mention at `Pic0ChartLocusPlusFibre.lean:69`). `chartLocusOpens` (`Pic0ChartUnivReduce.lean:115`) still takes `haff` as an argument; the residue is named `ChartLocusAffineLocal` (`Picard/Pic0ChartCoverageAbel.lean:132`) and reduced to B-4, with `Pic0ChartLocusPlusFibre.lean:128` producing it from a further hypothesis.

**Separably-closed stage: nothing in `Picard/` mentions it.** `grep IsSepClosed` over `AlgebraicJacobian/Picard/` returns **zero** hits; the only `IsSepClosed` code lives in `Curve/SeparablyClosedFibre.lean`, `Curve/SeparablyClosedPoints.lean`, `Curve/SepPointsDense.lean:278`. So the "01JJ application at `K_s`" that `informal/w4-datglue-worksheet.md` §1.2 calls "one line" has not been written — no file instantiates `pic0RepresentableByOfCharts` at a separable closure.

**Speiser / finite-Galois descent (DAT-G): does not exist in this project.** `horizon search "Speiser"` returns `AlgebraicJacobian.GaloisDescent.SemilinearAction.descentMap` etc., all in the *sibling* project `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GaloisDescent/SemilinearModules.lean:265` and `SemilinearAlgebras.lean:144` — not in `Algebraic-Jacobian-Challenge-Rebuild`. In the Rebuild tree "Speiser" appears only as docstring prose (`Picard/PicRepDatum.lean:18`, `Picard/JacobianDataFromPicRepDatum.lean:49`, `Algebra/EtaleCover.lean`).

**`sliceTrick` / `01JJ` / `DAT-6` as identifiers: do not exist** (`horizon search "sliceTrick"` returns only mathlib `_zpow_trick`, `Holor.slice_*`, plus `Functor.RepresentableBy.overSlice`). They are prose tags only; the real carriers are `Over.sigmaExtension` / `overSlice` / `pic0SigmaSheaf`.

**Roadmap agreement:** `AJCR.w4-rep.datum.dat-glue` is `pending` with summary "The 01JJ slice assembly is mechanically prepared at the separably closed stage. The remaining DAT-G0 work is the filtered-colimit compatibility of pic0 and descent of the representing datum to a finite separable stage"; `AJCR.w4-rep.datum.dat-g` is `pending` ("not implemented. Keep pending behind DAT-G0 and divRep"); `AJCR.w4-rep.datum.dat6` is `done`. That matches the tree state above.

**Net picture.** Everything on the β1 route except the residual body is landed and axiom-clean: the rebasing iso, the transport reduction, the δ field/scheme systems, the limit `Spec K_s = lim Spec k''`, and the plug-in lemma that discharges all three side conditions. The single open object is the body of `Pic0PreservesFilteredBaseColimit` (`PicRepColimitCompat.lean:136`) — a `Prop` with no inhabitant, no sorry, and no in-tree consumer of the mathlib finite-presentation machinery its docstring names. On the DAT-GLUE side the slice/01JJ machinery is complete as an *interface* (`pic0RepresentableByOfCharts`, `PicRepDatum`, `toJacobianData`) with zero producers at either end: no `f`/`hf`/local-surjectivity instantiation at a separably closed base, no `PicRepDatum` ever constructed, and the `K_s → k'` transfer and `k' → k` Galois descent both absent by name.
