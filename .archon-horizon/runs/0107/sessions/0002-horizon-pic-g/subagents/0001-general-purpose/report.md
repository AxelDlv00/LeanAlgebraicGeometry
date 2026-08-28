Status sent to the coordinator. My investigation is complete. Final report:

## Summary

All references relative to `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`. Read-only; no edits. Verified by source-reading + grep, NOT a clean build (root build is broken elsewhere — kernel timeout in `Pic0ThetaProjectionCoherence.lean`, inbox I-1632).

### 1. `PicEtAff.unit_injective` (C1) — LANDED, sorry-free

`AlgebraicJacobian/Picard/EtaleSeparatedness.lean:16` is only a docstring stub ("future home"). The real theorem is `AlgebraicJacobian/Picard/CechKernelLemma.lean:361`:
```lean
theorem PicEtAff.unit_injective
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (A : Type u) [CommRing A] [Algebra k A] :
    Function.Injective (PicEtAff.unit C A) :=
  PicEtAff.unit_injective_of_ker C A fun _ _ _ _ _ _ E hE =>
    Over.exists_cechPic_map_snd_of_ker_whiskerLeft C E hE
```
Complete term proof, no sorry. Unconditional on every affine test `A`. Backed by `PicEtAff.unit_injective_of_ker` (`EtaleSeparatednessClose.lean:193`, also sorry-free).

### 2. `PicEtAff.unit_surjective_of_section` (C2) — LANDED, sorry-free (NOT the gap)

`AlgebraicJacobian/Picard/EffectivityClose.lean:141`:
```lean
theorem PicEtAff.unit_surjective_of_section (σ : overSpec k K ⟶ C) :
    Function.Surjective (PicEtAff.unit C K)
```
`variable (K : Type u) [Field K] [Algebra k K]`; `C` proper/geom-irred/geom-red over `k`. Full tactic proof, no sorry. Assembled into a bijection at `EffectivityClose.lean:186`:
```lean
noncomputable def PicEtAff.unitEquiv_of_section (σ : overSpec k K ⟶ C) :
    relPic C (overSpec k K) ≃* PicEtAff C K :=
  MulEquiv.ofBijective (PicEtAff.unit C K)
    ⟨PicEtAff.unit_injective C K, PicEtAff.unit_surjective_of_section C K σ⟩
```
The `PicEtUnit.lean` docstring calling C2 "the GAP" is **stale**. C2 is a real theorem — but restricted to a **field** test `K` admitting a **section** `σ : Spec K ⟶ C`, not arbitrary affine tests.

Downstream: `unitEquiv_of_section` has ZERO consumers (only its own docstring); nothing even imports `EffectivityClose.lean`. `unit_surjective_of_section` is used only inside `unitEquiv_of_section` and in prose (`Pic0VanishingFieldTest.lean:42/106` explicitly says surjectivity "is NOT used"). Every real proof-term use of `PicEtAff.unit` in the rep route uses only C1 injectivity.

### 3. The five files (all 0 proof-sorries; every "sorry"/"admit" hit is the English word in a docstring)

- **PicEtAffZariskiSep.lean** — 224 lines. "Zariski separation of the étale plus construction." Decls: `exists_relPicAlgMap_eq_of_mapAlg_eq` (48), `exists_etaleCover_pi` (98), `eq_of_away_eq` (137).
- **PicEtAffZariskiGlue.lean** — 452 lines. "Zariski gluing of the étale plus construction" (only point where Layer-2 functoriality consumes C1). Decls: `relPicAlgMap_tensor_eq_of_compat` (67), `relPicAlgMap_algEquiv_injective` (274), `mapAlg_mk_eq_mk` (287), `exists_mapAlg_eq_of_compat` (337).
- **CechKernelLemma.lean** — 370 lines. "The Čech kernel lemma and étale separatedness (ζ3 bricks K and the close)." Decls: `Over.exists_cechPic_map_snd_of_ker_whiskerLeft` (259), `PicEtAff.unit_injective` (361); plus `tensorInl/tensorInr/tensorInl_comp_ofId` and `Over.cechPicMap_tensorInl_eq_tensorInr` (125).
- **CechKernelGlue.lean** — 493 lines. "The glued cobounding units of the Čech kernel lemma (ζ3 brick G)." Decls: `unitsAppLE_congr_hom` (86), `pullback_pair_trans` (93), `cg_comp_pA` (142), `preimage_le_pB_gS` (147), `gluePiece` (154), `Over.exists_kernelCobounding` (443).
- **KernelDescentUnit.lean** — 499 lines. "The descent unit of a Čech class killed by the base change (ζ3 brick W)." Decls: `unitsAppLE_div_pullback` (47), `whiskerLeft_mul_inl` (135), `whiskerLeft_mul_inr` (141), `Over.exists_kernelDescentUnit` (407).

### 4. picEt ↔ pic0 — PARALLEL, UNCONNECTED

The étale layer defines the functor: `picEtFunctor` (`PicEtMap.lean:314`), `pic0Subgroup`/`pic0Map`/`pic0Functor` (`Pic0Functor.lean:107/134/151`), `pic0Inclusion` (176). `pic0TypeFunctor` (`Pic0SigmaSheaf.lean:58`) shares the carrier `pic0Subgroup` (`pic0TypeFunctor_obj` is `rfl`).

But the ONLY producer of `(pic0TypeFunctor C).RepresentableBy` is `pic0RepresentableByOfCharts` (`Pic0SigmaSheaf.lean:161`), fed by `abelSigmaChart`/`mixedParamRepresentableBy`/`pic0RepresentableBy_of_nested` — all taking `rep : (divFunctor C π n).RepresentableBy D` as an unfilled **hypothesis**. None use `PicEtAff.unit`, `unitEquiv_of_section`, `picEtUnit`, or `pic0Inclusion`. The étale-sheafification substrate never produces a `RepresentableBy`; the sole bridge is the shared carrier.

### 5. Čech / degree / H¹ near PicEtAff

No H¹ / unit-group cohomology comparison exists in `PicEtAff*.lean` or `PicEtUnit.lean`. What exists: degree map `PicEtAff.degAff : PicEtAff C K → ℤ` (`DegreeZero.lean:263`, consumed by `Pic0Functor.degAt`); Čech presentations of plus classes (`PicEtAffFieldCollapse.lean:96` Čech form, `PicEtAffTransport.lean`, `PicEtAffBaseFieldShuffle.lean` degree seam, `PicEtAffCurveMap.lean`). The H¹-flavored kernel/cobounding-unit machinery lives in `CechKernelGlue.lean`/`KernelDescentUnit.lean`, not as a stated H¹ isomorphism.

### Bottom line

C1 and C2 are both landed, sorry-free theorems (premise's "C2 is the gap" is stale). The genuine open seam is item 4: nothing discharges the `divFunctor…RepresentableBy` hypothesis, and the landed C1+C2 étale bijection is not wired into the `rep` producer.
