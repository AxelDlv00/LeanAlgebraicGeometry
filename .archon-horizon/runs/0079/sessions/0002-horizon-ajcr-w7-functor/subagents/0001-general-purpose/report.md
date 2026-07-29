## Audit result: `AJCR.w7-functor`, ten "done" leaves

Global facts that apply to all ten: every deliverable file is directly imported from `AlgebraicJacobian.lean` and has a fresh `.olean` under `.lake/build/lib/lean/` (all rebuilt 2026-07-29 01:18–05:26, all newer than their sources, which have not been touched since 2026-07-18). Zero `sorry`/`axiom`/`native_decide`/`maxHeartbeats` escape hatches in any of the twelve files I read. The only unrooted, never-elaborated file in the cone is `Picard/Pic0ThetaCocycle.lean` (no `.olean`) — that is leaf `.k1`, correctly still open.

---

**b1 — `Curve/CrossBaseSquare.lean`**
HEADLINES: `Over.isPullback_crossBase` (:74), `Over.crossBaseIso` (:84), `Over.crossBaseIso_naturality` (:117), frozen-spelling `crossBaseIso` (:181), `mapOverSpecIso` (:201).
VERDICT: **SOUND**. No restrictive hypotheses at all (any `f : S' ⟶ S`, any `X`, any `T`); the iso is built from a genuine `IsPullback.paste_horiz`. Consumed in real proof text by `Picard/Pic0Theta.lean:69,126` and `Picard/PicEtCrossBaseGraph.lean:65-97`; `mapOverSpecIso` by `Picard/PicEtCrossBase.lean:406-444`. (The general-form `isPullback_crossBase` at the frozen spelling, :169, has no consumer; the abbrev does.)

**b2 — `Picard/PicEtAffBaseFieldShuffle.lean`**
HEADLINE: `PicEtAff.baseFieldShuffle` (:170) `: PicEtAff C A ≃* PicEtAff ((baseChange k L).obj C) A`, plus `crossBaseTransportFamily`/`Inv` (:88,:105).
VERDICT: **SOUND**. The two-sided instance index of `RelPicTransportFamily` (`PicEtAffTransport.lean:64`) is collapsed by a real `Algebra.algebra_ext` argument, and the collapse is *anchored*: `crossBaseTransportFamily_hom` and `..._relPicHom` (:129,:143) are `rfl` against B-4a's `crossBaseAffineIso`/`relPicCrossBase`, so the family is not an unreachable generality. Consumed in code by `Picard/PicEtCrossBase.lean:149,190,208,262,431,448`.

**b3 — `RiemannRoch/ClassDegMapIso.lean`**
HEADLINES: `classDeg_cechPicMap_of_isIso` (:150), `classDeg_map_iso` (:196).
VERDICT: **UNCONSUMED at the named headline**. `classDeg_map_iso` — the row's named lemma — has *zero* references outside its own file (the only hit is a docstring mention in `DegreeIsoTransport.lean:13`). Its scheme-level engine `classDeg_cechPicMap_of_isIso` is genuinely consumed (`Pic0Theta.lean:296`, `RiemannRoch/WindowFieldTransport.lean:260`), so the mathematics is used; the `Over`-form keystone the row names is a wrapper nobody calls. Not vacuous: the hypothesis pack is the standard curve pack, satisfied at `C` and at base-changed curves.

**b4 — `Picard/Pic0Theta.lean` + `Picard/Pic0ThetaAssembly.lean`**
HEADLINES: `relPicDeg_relPicCrossBase` (Pic0Theta:304), `mem_pic0Subgroup_iff_of_degAt_pushFieldPoint_eq` (:470), `degAff_baseFieldShuffle` (Assembly:67), `pic0CrossBaseEquiv` (:151), `pic0Theta` (:203), `pic0ThetaType` (:238).
VERDICT: **SOUND**. θ is stated for arbitrary `[Field L] [Algebra k L]` (no finiteness/separability), the degree-zero restriction routes through a real `degAt` matching, and the `CommGrpCat` naturality is discharged by `picEtMap_picEtCrossBaseInv`, not by a subsingleton collapse. Consumed in code: `pic0ThetaType` by `JacobianDataBaseChange.lean:68` and `PicRepColimitCompat.lean:123,155`; `pic0CrossBaseEquiv` by `JacobianDataBaseChangeAbel.lean:51,108`.

**b56 — `Picard/JacobianDataBaseChange.lean`**
HEADLINES: `JacobianData.baseChange` (:59), `grpObjObj_baseChange_eq` (:204), `baseChangeIsoOfData` (:230).
VERDICT: **SOUND, but unrealized at any object.** The mathematics is real (the `monObjObj_eq_ofRepresentableBy` bridge :130 and `monObj_ofRepresentableBy_eq_of_iso` :170 are honest `hom_ext`/elementwise proofs; `GrpObj.ext` reduces B-6a to `MonObj`). The load-bearing caveat: **`JacobianData C` has no producer anywhere in the tree at any concrete curve.** Every constructor takes the representability datum as an argument (`JacobianData.ofRepresentableBy` `JacobianDataCharts.lean:74`, `PicRepDatum.toJacobianData` `JacobianDataFromPicRepDatum.lean:83`, and `JacobianData.baseChange` itself); `PicRepDatum` has zero producers; `pic0RepresentableByOfCharts` (`Pic0SigmaSheaf.lean:161`) needs `IsChartUniv` + Zariski local surjectivity, for which no instance exists. So this is a conditional-on-DAT-J theorem, correctly framed as such in the docstring. Consumed by `JacobianDataBaseChangeAbel.lean:92,152,161` (real code). `grpObjObj_baseChange_eq` and `JacobianData.baseChange` have no consumers outside the file except through `baseChangeIsoOfData`.
DOCSTRING DRIFT (also in `JacobianData.lean:28` and `Pic0PullbackGrp.lean:41-48`): "consumed (definitionally, since `Jacobian C := (jacobianData C).J`)". That defeq does not exist — `Challenge.lean:99` defines `Jacobian` as `sorry`, and `jacobianData` is not a declaration in the tree (only prose mentions). The claim describes a planned future state, not a checkable identity.

**ev — `RiemannRoch/DegreePullback.lean`** (with `DegreePullbackFiber.lean`, `DegreePullbackDictionary.lean`)
HEADLINES: `classDeg_cechPicMap_eq_finrank_mul` (:267), `classDeg_cechPicMap_of_isFinite` (:320, "EV-main").
VERDICT: **SOUND but consumed only in its degenerate instance.** The proof is a real `Finsupp.induction` ladder closing on the EV-3 fiber identity `sum_ordZ_residueDeg_of_isFinite` (`DegreePullbackFiber.lean:72`), which itself carries substantial chart hypotheses discharged from the pack. Its single consumer is `Pic0Pullback.lean:110`, and there only as `n · 0 = 0` — the finrank multiplier is never used for a nonzero degree anywhere. Also: the row title says "arbitrary curve morphism", but the multiplicativity statement requires `[Surjective h.left] [IsFinite h.left]`; the arbitrary-morphism claim exists only in the degree-zero corollary (`classDeg_cechPicMap_whiskerRight_eq_zero`, `Pic0Pullback.lean:82`). That split was design-ratified (`informal/w7-ev-worksheet.md` §1.1), so it is drift against the row title, not against the plan.

**f1 — `Picard/RelPicCurveMap.lean`**
HEADLINES: `relPicMapCurveApp_id` (:54), `relPicMapCurveApp_comp` (:64), `relPicMap_relPicMapCurveApp` (:79), `relPicAlgMap_relPicMapCurveApp` (:92), `relPicMapCurveApp_toUnit_comp` (:118), `cechPicMap_toUnit_whiskerRight_mem_picFromBase` (:105).
VERDICT: **WEAKER-THAN-CLAIMED (credit) + half UNCONSUMED.** The row title claims "`CechPic`/relPic pullback along a curve morphism". That map is **not** in this file: `relPicMapCurveApp` and `relPicMapCurve` with their functor laws live in `Picard/RelPic.lean:171,185`, mtime 2026-07-12 — five days before the Wave-7 design session. The file's own docstring says so honestly (":11 The carrier maps … live in `Picard/RelPic.lean`"); the roadmap row does not. What f1 actually landed is the pointwise law layer, and three of its six declarations have zero consumers: `relPicMap_relPicMapCurveApp`, `relPicMapCurveApp_toUnit_comp`, and `cechPicMap_toUnit_whiskerRight_mem_picFromBase` — the last two being the intended constant-leg route, which `Pic0Pullback.lean:118` bypassed in favour of `cechPicMap_eq_one_of_range_eq_singleton`. Consumed: `_id`/`_comp` at `PicEtAffCurveMap.lean:148,158`, `relPicAlgMap_...` at `Pic0Pullback.lean:154`.

**f2 — `Picard/PicEtAffCurveMap.lean`**
HEADLINE: `PicEtAff.curveMap` (:112), `curveTransportFamily` (:66).
VERDICT: **SOUND**. Same anchoring discipline as b2 — `curveTransportFamily_hom` (:91) and `_relPicHom` (:98) are `rfl` at a shared `k`-algebra instance, so the collapsed index is reachable. Functor laws proved from f1. Consumed by `PicEtCurveMap.lean` and `Pic0Pullback.lean:143-155`.

**f3 — `Picard/PicEtCurveMap.lean`**
HEADLINE: `picEtPullback` (:63), `picEtPullbackNat` (:141), `picEtMap_picEtPullback` (:126), `degAt_picEtPullback` (:179).
VERDICT: **SOUND**. The componentwise lift is real work (naturality via the `IsPullbackValue` characterization, not by unfolding the limit), and `degAt_picEtPullback` is exactly the reduction f6 consumes (`Pic0Pullback.lean:169`).

**f6 — `Picard/Pic0Pullback.lean` + `Picard/Pic0PullbackGrp.lean`**
HEADLINES: `classDeg_cechPicMap_whiskerRight_eq_zero` (Pullback:82), `pic0Pullback` (:164), `pic0PullbackNat` (:210), `pullbackHom` (Grp:77) with `pullbackHom_id` (:105), `pullbackHom_comp` (:127), `homEquiv_comp_pullbackHom` (:178).
VERDICT: **UNCONSUMED at the terminal deliverable.** `Pic0Pullback.lean` is sound and non-vacuous — the per-field-point dodge is genuine, the dichotomy `curveHom_isFinite_or_constant` (`CurveMorphismDichotomy.lean:235`) is a proved disjunction, and both legs are discharged. But `pullbackHom` and *all four* of its laws (`_id`, `_comp`, `comp_pullbackHom`, `homEquiv_comp_pullbackHom`) have **zero references anywhere in the tree**, and `pic0PullbackNat`'s only rooted consumer is `Pic0PullbackGrp.lean` itself (its other consumer, `Pic0ThetaCocycle.lean:130,207`, is the unrooted never-elaborated file). Like b56, `pullbackHom` is also conditional on a `JacobianData` that has no producer. Expected — `Challenge.lean:156-158` still has `map/map_id/map_comp := sorry` — but it means f6's headline is a terminus with nothing attached at either end.

---

## Rows that should not be trusted as done, worst first

1. **f1** — the row title credits the relPic curve pullback, which predates the wave (`RelPic.lean:171`, 2026-07-12). What landed is a laws layer, half of it dead: the two constant-leg lemmas it built for f6 were bypassed. Retitle or re-scope; do not count the pullback itself as Wave-7 output.
2. **b3** — the row's named lemma `classDeg_map_iso` has no consumer at all; only the engine below it is used. Either the row should name `classDeg_cechPicMap_of_isIso`, or the wrapper needs the consumer the docstring promises ("Consumed by W7-B4a … and W7-B4b" is false as written — B-4a calls the engine directly).
3. **f6** — sound but terminal-dead: `pullbackHom` + its four laws have zero references, and the construct is gated on a `JacobianData` producer that does not exist. Fine as a staged deliverable; not fine as evidence that functoriality is packaged.
4. **b56** — same producer gap, plus a docstring assertion of a definitional identity (`Jacobian C := (jacobianData C).J`) that is contradicted by `Challenge.lean:99` (`Jacobian … := sorry`). The math is real; the "definitionally consumed by the frozen `baseChangeIso`" claim is not checkable today and should be marked as pending, not as a fact.
5. **ev** — real theorem, but its multiplicativity is consumed only as `n · 0 = 0`, and the row title's "arbitrary curve morphism" applies only to the degree-zero corollary. Trust it as EV-main; do not read the row as delivering multiplicativity for arbitrary morphisms.

Trustworthy as done with no reservation: **b1, b2, b4, f2, f3**.
