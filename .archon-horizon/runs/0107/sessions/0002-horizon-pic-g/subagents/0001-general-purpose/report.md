I have everything needed. Compiling the report.

## Findings

All file/line references are absolute-project-relative to `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`. No files were edited.

### 1. `PicEtAff.unit_injective` (C1) — EXISTS, real theorem, sorry-free

There are TWO relevant declarations. The docstring stub is NOT where the proof lives:

- `AlgebraicJacobian/Picard/EtaleSeparatedness.lean:16` — only a module-docstring stub. This file is "the future home of" the theorem; it contains only ζ1 seed lemmas (`cechPicMap_tensorInl_eq_tensorInr`), NOT the theorem itself.

- The real theorem is at `AlgebraicJacobian/Picard/CechKernelLemma.lean:361`:
```lean
theorem PicEtAff.unit_injective
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (A : Type u) [CommRing A] [Algebra k A] :
    Function.Injective (PicEtAff.unit C A) :=
  PicEtAff.unit_injective_of_ker C A fun _ _ _ _ _ _ E hE =>
    Over.exists_cechPic_map_snd_of_ker_whiskerLeft C E hE
```
Here `C : Over (Spec (.of k))`, `k` a field. It is a complete term proof, no sorry. It discharges the kernel hypothesis of the unfold lemma at `AlgebraicJacobian/Picard/EtaleSeparatednessClose.lean:193`:
```lean
theorem PicEtAff.unit_injective_of_ker
    (hker : ∀ (B : Type u) [CommRing B] [Algebra k B] [Algebra A B]
      [IsScalarTower k A B] [Module.FaithfullyFlat A B],
      ∀ E : (XA).CechPic,
        CechPic.map (C ◁ Over.overSpecMap
          ((Algebra.ofId A B).restrictScalars k)).left E = 1
        → ∃ M₁ : (SA).CechPic, CechPic.map (pA) M₁ = E) :
    Function.Injective (PicEtAff.unit C A)
```
(also sorry-free). **C1 is genuinely LANDED as claimed**, unconditional on every affine test algebra, given the proper/geom-irreducible/geom-reduced curve instances.

### 2. `PicEtAff.unit_surjective_of_section` (C2) — EXISTS, real theorem, sorry-free (NOT a gap)

`AlgebraicJacobian/Picard/EffectivityClose.lean:141`:
```lean
theorem PicEtAff.unit_surjective_of_section (σ : overSpec k K ⟶ C) :
    Function.Surjective (PicEtAff.unit C K)
```
with section `variable (K : Type u) [Field K] [Algebra k K]` and `C` proper/geom-irreducible/geom-reduced over `k`. This is a full ~40-line tactic proof (field-cofinality refinement → rigidified Čech rep → effectivity theorem `Over.exists_cechPic_map_whiskerLeft_eq` → `mk`-calculus close). **No sorry.** It even assembles into a bijection at `EffectivityClose.lean:186`:
```lean
noncomputable def PicEtAff.unitEquiv_of_section (σ : overSpec k K ⟶ C) :
    relPic C (overSpec k K) ≃* PicEtAff C K :=
  MulEquiv.ofBijective (PicEtAff.unit C K)
    ⟨PicEtAff.unit_injective C K, PicEtAff.unit_surjective_of_section C K σ⟩
```

Important correction to the premise: the `PicEtUnit.lean` docstring calling C2 "the GAP" is stale. C2 is landed as a theorem, but note its hypothesis is restricted: it is only surjectivity over a **field** test `K` that **admits a section** `σ : Spec K ⟶ C` (a `K`-point). It is not surjectivity over arbitrary affine tests.

### 3. The five files

Sorry census across all five (and PicEtAff/PicEtUnit): every `grep` hit for `sorry`/`admit` is the English word "admit"/"admitting" inside docstrings. **Zero proof-sorries in all five files.**

- **PicEtAffZariskiSep.lean** — 224 lines, 0 proof-sorries (one "admit refinement maps" in docstring at line 45). Purpose: "Zariski separation of the étale plus construction" — two plus classes over `A` agreeing on every member of a finite basic-open cover of `Spec A` agree. Top-level decls: `exists_relPicAlgMap_eq_of_mapAlg_eq` (48), `exists_etaleCover_pi` (98), `eq_of_away_eq` (137).

- **PicEtAffZariskiGlue.lean** — 452 lines, 0 sorries. Purpose: "Zariski gluing of the étale plus construction" — a family of plus classes on a finite basic-open cover, compatible on overlaps, glues; this is where Layer-2 functoriality consumes C1 via `relPicAlgMap_injective_of_etaleCover`. Decls: `relPicAlgMap_tensor_eq_of_compat` (67), `relPicAlgMap_algEquiv_injective` (274), `mapAlg_mk_eq_mk` (287), `exists_mapAlg_eq_of_compat` (337).

- **CechKernelLemma.lean** — 370 lines, 0 sorries. Purpose: "The Čech kernel lemma and étale separatedness (ζ3 bricks K and the close)" — every Čech Picard class on `X_A` killed by base-change pullback is pulled back from `Spec A`; then the C1 close. Decls: `Over.exists_cechPic_map_snd_of_ker_whiskerLeft` (259), `PicEtAff.unit_injective` (361). Also non-top-level: `tensorInl`/`tensorInr`/`tensorInl_comp_ofId` (ζ1) and `Over.cechPicMap_tensorInl_eq_tensorInr` (125).

- **CechKernelGlue.lean** — 493 lines, 0 sorries. Purpose: "The glued cobounding units of the Čech kernel lemma (ζ3 brick G)" — glues local units `gluePiece` over a cover and descends through `cg`. Decls: `unitsAppLE_congr_hom` (86), `pullback_pair_trans` (93), `cg_comp_pA` (142), `preimage_le_pB_gS` (147), `gluePiece` (154), `Over.exists_kernelCobounding` (443).

- **KernelDescentUnit.lean** — 499 lines, 0 sorries. Purpose: "The descent unit of a Čech class killed by the base change (ζ3 brick W)" — builds the global unit `w` on `Spec(B⊗_A B)` satisfying the Amitsur cocycle identity (`Module.IsDescentCocycle`). Decls: `unitsAppLE_div_pullback` (47), `whiskerLeft_mul_inl` (135), `whiskerLeft_mul_inr` (141), `Over.exists_kernelDescentUnit` (407).

### 4. picEt ↔ pic0 connection — the étale route is a PARALLEL substrate; it does NOT reach `rep`

The étale layer and the representability producer are two disjoint tracks that only meet at the shared symbol `pic0TypeFunctor`, not at a proof:

- **The étale/picEt track**: `picEt` (`PicEt.lean:105`), `picEtFunctor` (`PicEtMap.lean:314`, `CommGrpCat`-valued). On top of it `Pic0Functor.lean` builds `degAt` (degree at a field point, via `PicEtAff.degAff` from `DegreeZero.lean:263` and `picEtAffineEquiv`), the subgroup `pic0Subgroup` (line 107), the functorial map `pic0Map` (134), the group-valued `pic0Functor` (`Pic0Functor.lean:151`), and the inclusion `pic0Inclusion : pic0Functor C ⟶ picEtFunctor C` (176). `PicEtUnit.lean` connects `relPic` to this via `relPicToPicEt`/`picEtUnit` and has **zero** references to `pic0TypeFunctor`, `RepresentableBy`, or `pic0RepresentableByOfCharts`.

- **The representability producer track**: `pic0TypeFunctor` (`Pic0SigmaSheaf.lean:58`) is a `Type u`-valued abbrev whose obj is `pic0Subgroup C T.unop` — so it shares the SAME carrier as the étale-built `pic0Functor` (`pic0TypeFunctor_obj` is `rfl`). The only producer of `(pic0TypeFunctor C).RepresentableBy` is `pic0RepresentableByOfCharts` (`Pic0SigmaSheaf.lean:161`), which takes a chart family `f`, open-immersion witnesses `hf`, and a `[Presheaf.IsLocallySurjective … (Sigma.desc f)]` instance — i.e. the DAT-glue seam. Its charts come from the **DivFamily/divFunctor/abelSigmaChart** route (`Pic0AtlasFromDivRep.lean`, `Pic0ChartAtlasParamFree.lean:125 mixedParamRepresentableBy`, `Pic0ChartVMonotone.lean:323 pic0RepresentableBy_of_nested`), all of which take `rep : (divFunctor C π n).RepresentableBy D` as a HYPOTHESIS.

So: the picEt route defines the functor whose representability is sought, but the path to `rep` runs entirely through the divisor-family/Σ-sheaf charts — it never uses `PicEtAff.unit_injective`/`unit_surjective_of_section`, `picEtUnit`, or `pic0Inclusion` to produce a `RepresentableBy`. **The étale-sheafification substrate is currently parallel and unconnected to the `rep` producer.** The `RepresentableBy` still bottoms out on the (unproduced, hypothesis-level) `divFunctor…RepresentableBy` seam. The only bridge symbol is the shared carrier `pic0Subgroup`.

### 5. Čech / degree / H¹ around PicEtAff

No "H1"/"H¹"/"unit-group cohomology" comparison anywhere in `PicEtAff*.lean` or `PicEtUnit.lean`. What exists:

- **Degree map**: `PicEtAff.degAff : PicEtAff C K → ℤ` at `AlgebraicJacobian/Picard/DegreeZero.lean:263` (NOT in a PicEtAff-named file; built from `degAffFun` over the Σ of étale covers). Consumed by `Pic0Functor.degAt`.
- **Čech description**: `PicEtAff` classes are presented as `relPicMk` of `CechPic` (Čech Picard) classes throughout. Relevant: `PicEtAffFieldCollapse.lean:96` `..._cech` "shared plus-class field collapse, Čech form" giving `∃ M : (C ⊗ overSpec k L).left.CechPic, …`; `PicEtAffTransport.lean` (transport of `CechPic` classes along a family, `relPicHom_mk`); `PicEtAffBaseFieldShuffle.lean` (degree seam `relPicDeg_relPicCrossBase` lifted to plus level); `PicEtAffCurveMap.lean` (pullback of Čech classes along curve maps).
- No H¹/unit-group computation comparing `PicEtAff C A` to a cohomology group — the "kernel/cobounding-unit" H¹-flavored content is the Čech kernel lemma machinery in `CechKernelGlue.lean`/`KernelDescentUnit.lean` (`Scheme.unitsEvInf`, cobounding 0-cochains), not a stated H¹ isomorphism.

### Bottom line for "what to prove next"

Both C1 and C2 are landed, sorry-free theorems (the premise's "C2 is the GAP" is stale). The real open seam is item 4: nothing wires the étale `pic0Functor`/`PicEtAff.unit` layer into a `(pic0TypeFunctor C).RepresentableBy` producer. The sole producer `pic0RepresentableByOfCharts` still depends on the divisor-family `rep` hypothesis, which no landed declaration discharges. Caveat: I verified sorry-freeness by source reading + grep, not by a clean build — the root build is currently broken elsewhere (kernel timeout in `Pic0ThetaProjectionCoherence.lean`, per open inbox blocker I-1632), so I did not run `lean_verify` on the axiom closure.
