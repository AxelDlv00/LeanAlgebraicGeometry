I have everything measured. Here is the report.

## 1. THE RIGID ENGINE — what it concludes

The engine ships in two instantiations. The one that matters for you is the **datum** version (m-chart, arbitrary basic-open cover), not the two-chart twist version.

**Abstract core** — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/RigidEngine4Assembly.lean:414`

```lean
theorem Scheme.TwoCoverPairData.rigidEngine [IsNoetherianRing R]
    [Module.Finite R[X] (Module.AEval' (dat.pair hU₀ hU₁).t₀)]
    [Module.Finite R[X] (Module.AEval' (dat.pair hU₀ hU₁).t₁)]
    [Module.Flat R ((F.obj.obj (op U₀)) × (F.obj.obj (op U₁)))]
    [Module.Projective R (F.obj.obj (op (U₀ ⊓ U₁)))]
    (hfib : ∀ p : PrimeSpectrum R,
      Subsingleton ((dat.pair hU₀ hU₁).H1 ⊗[R] p.asIdeal.ResidueField)) :
    Subsingleton (Sheaf.HModule F 1) ∧ Module.Finite R (Sheaf.HModule F 0) ∧
      Module.Projective R (Sheaf.HModule F 0)
```

**Datum instantiation** — `AlgebraicJacobian/Cohomology/GluedSheafEngine.lean:198`, with `variable {k}[Field k]{C : Over (Spec (.of k))} {B}[CommRing B][Algebra k B] {π : C.left ⟶ P1 k} [IsFinite π]`:

```lean
theorem datumRigidEngine [IsNoetherianRing B]
    (hfib : ∀ p : PrimeSpectrum B,
      Subsingleton ((datumPair D).H1 ⊗[B] p.asIdeal.ResidueField)) :
    Subsingleton (Sheaf.HModule D.sheaf 1) ∧
      Module.Finite B (Sheaf.HModule D.sheaf 0) ∧
      Module.Projective B (Sheaf.HModule D.sheaf 0)
-- (D : BasicOpenCocycleDatum C B π) (hπ : π ≫ P1.structureMap k = C.hom)
```

Also there: `datumRigidEngine_isOpen_vanishing` (:221, Noetherian-free), `datumH0TensorEquiv` (:233), `datumH0BaseChangeEquiv` (:247), `datum_subsingleton_pairH1` (:262). The twist-sheaf mirrors are `relTwistRigidEngine` etc. in `RigidEngine4Engine.lean:174`.

Answering (a)/(b)/(c) plainly:

- **(a) H¹ = 0 from a hypothesis — YES, and the hypothesis is dischargeable.** `datumRigidEngine`'s first conjunct. Its `hfib` input is not a dead end: `BasicOpenCocycleDatum.subsingleton_h1_tensor_iff_exists_witness` (`AlgebraicJacobian/Picard/DivisorFamilyH1Locus.lean:205`) is a **two-way** dictionary turning it into "the fibre class has a witness divisor with `H¹(𝒪(W)) = 0`":
  ```lean
  theorem BasicOpenCocycleDatum.subsingleton_h1_tensor_iff_exists_witness
      (D : BasicOpenCocycleDatum C S π) (L : Type u) [Field L] [Algebra k L]
      [Algebra S L] [IsScalarTower k S L] :
      Subsingleton ((datumPair D).H1 ⊗[S] L) ↔
        ∃ W : ((C ⊗ overSpec k L).left).CurveDivisor,
          Scheme.CurveDivisor.picClass L W
              = Scheme.CechPic.map (relCurveMap C S L) D.cechPicClass
            ∧ Subsingleton (Sheaf.HModule
                ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)
  ```
  (one-directional predecessor: `subsingleton_h1_residueField_tensor_of_witness`, `Cohomology/GluedSheafDatumFibre.lean:169`.)

- **(b) H⁰ finite/projective — YES; rank 1 — NO.** The engine gives `Module.Finite B` + `Module.Projective B` of `Sheaf.HModule D.sheaf 0`. There is **no** rank-1 statement over a general base. The only rank-1 facts are field-level: `h0_eq_deg_add_chi_of_subsingleton_hModule_one` (`RiemannRoch/FLVClass.lean:412`) giving `h⁰ = deg + χ`, and `Pic0ChartLocusH0One`/`Pic0ChartLocusH0Rank.lean:44` (`h⁰ = n + 1 - g`). Nothing converts `Module.Projective B M` + fibrewise-rank-1 into `Module.Invertible B M` or `Module.Free B M` of rank 1.

- **(c) Evaluation / counit π^*M → L, or "sheaf ≅ pullback from base" — DOES NOT EXIST.** Queries run: `grep -rn "counit\|evaluation\|evalHom"` over the whole project (hits are all unrelated: `DescentSectionEval`, `thetaGluedEval`, `StalksDVR` germ evaluation); `grep -rn "pullbackSheaf\|Modules.pullback\|pushforward\|adjunction"` (only `RigidEngine3Rigidity`'s docstring calling its complex "the two-term pushforward complex", plus `Over.map` pushforwards of test objects — no sheaf-level `f^*`/`f_*`); `grep -rn "constModuleSheafHomEquiv"` (the constant-sheaf adjunction exists at `Cohomology/ModuleKSheaf.lean:137`, but only for the **constant** sheaf on one site, not for `π_*`/`π^*` across the projection `relCurve C B ⟶ Spec B`). **There is no pushforward or pullback functor on sheaves of modules anywhere in AJCR, and no evaluation morphism.** The entire cohomology layer is Čech-complex-of-modules, not derived-functor.

## 2. THE EXTRACTION at P^1

`AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean:301`, in `variable {k}[Field k]{C : Over (Spec (.of k))} {B}[CommRing B][Algebra k B] {π : C.left ⟶ P1 k} [IsAffineHom π]`:

```lean
theorem BasicOpenCocycleDatum.exists_cechPicClass_eq (c : (relCurve C B).CechPic) :
    ∃ D : BasicOpenCocycleDatum C B π, D.cechPicClass = c
```
Note: `[IsAffineHom π]` only — **not** `[IsFinite π]`, and no geometric binders on `C`. Fully general in `B`.

`cechPicClass` (`GluedSheafClass.lean:269`):
```lean
noncomputable def cechPicClass : (relCurve C B).CechPic :=
  Scheme.CechPic.mk D.pointedCover
    (gluedSubordCocycle D.isGluingCocycle D.pointedCover D.pieceIndex (fun _ => le_rfl)).class
```

`BasicOpenCocycleDatum` (`GluedSheafDatum.lean:143`) extends `BasicOpenCoverData` (:55): finite `J₀, J₁`, generators `h₀ : J₀ → Γ(relCurve C B, V₀ᴮ)`, `h₁`, partition coefficients `a₀, a₁` with `∑ a₀ j * h₀ j = 1` (ditto chart 1), plus `unit : ∀ i j, Γ(relCurve C B, pieces i ⊓ pieces j)ˣ` and `isGluingCocycle`. Getting one requires **nothing** beyond a class — the extraction produces it.

**`P1.asOver k` and π = 𝟙 — VERIFIED (`lean_run_code`):**
- `(P1.asOver k).left = P1 k` by `rfl` (`P1.asOver := Over.mk (structureMap k)`, `Curve/P1.lean:184`).
- `IsAffineHom (𝟙 (P1 k))` **is** available: `#synth` returns `(IsFinite.instOfIsClosedImmersion (𝟙 (P1 k))).toIsAffineHom`. `IsFinite (𝟙 (P1 k))` likewise.
- `hπ : 𝟙 (P1 k) ≫ P1.structureMap k = (P1.asOver k).hom` is `Category.id_comp _`.
- The three curve binders fire at `P1.asOver k` by `inferInstance`.

**But there is a real instance-elaboration trap.** Writing `BasicOpenCocycleDatum (P1.asOver k) B (𝟙 (P1 k))` fails with `failed to synthesize IsAffineHom (𝟙 (P1 k))` even though the standalone `example : IsAffineHom (𝟙 (P1 k)) := inferInstance` succeeds in the same file. Reason (visible under `pp.explicit`): the structure's binder is at the source type `(P1.asOver k).left`, and synthesis in that position does not unfold `Over.left`. Six spellings failed (`@`-application, `by exact inferInstance`, local `instance`, `attribute [instance]`, raised `maxSynthPendingDepth`/`synthInstance.maxSize`, a `def pi1` wrapper). The fix that works is a **top-level instance declared at the `Over.left` spelling explicitly**:
```lean
noncomputable instance p1IdAff2 (k : Type u) [Field k] :
    @IsAffineHom ((P1.asOver k).left) (P1 k) (𝟙 (P1 k)) :=
  inferInstanceAs (IsAffineHom (𝟙 (P1 k)))
noncomputable instance p1IdFin2 (k : Type u) [Field k] :
    @IsFinite ((P1.asOver k).left) (P1 k) (𝟙 (P1 k)) :=
  inferInstanceAs (IsFinite (𝟙 (P1 k)))
```
With those two lines, `exists_cechPicClass_eq` and `datumRigidEngine` both elaborate at `(P1.asOver k, 𝟙 (P1 k))` — verified compiling.

## 3. FIBREWISE MACHINERY — a class-to-fibre dictionary exists; a *degree at a point* does not

What exists:
- `BasicOpenCocycleDatum.cechPicClass_baseChange` (`GluedSheafClass.lean:358`): `(D.baseChange B').cechPicClass = CechPic.map (relCurveMap C B B') D.cechPicClass`. This is the fibre-class law.
- `datumH1Equiv` / `subsingleton_datumPair_h1_iff` (`GluedSheafFibre.lean`, ~:100–120) and `datum_subsingleton_h1_residueField_tensor_iff` (:~130) — right-exactness half.
- `subsingleton_h1_tensor_of_baseChange(_sheaf)` (`GluedSheafDatumFibre.lean:78, :105`), `presentationSheafIso` (:126), `subsingleton_sheaf_h1_of_picClass_eq` (:142), `subsingleton_h1_residueField_tensor_of_witness` (:169).
- `DivFamZar.IsH1VanishingAt` and its openness `DivFamZar.isOpen_setOf_isH1VanishingAt` (`Picard/DivisorFamilyH1Locus.lean:116, :386`) — **affine test only**.
- `cechWitnessLocus` + `isOpen_cechWitnessLocus` (`Picard/Pic0ChartLocusClass.lean:82, :123`) — class-indexed, affine base.

What does **not** exist: **no notion of "the degree of a CechPic class on `relCurve C B` at a point of Spec B."** `classDeg` (`RiemannRoch/Degree.lean:~150`) is defined only over a **field** and requires `[IsIntegral X] [SmoothOfRelativeDimension 1] [Module.Finite K (HModule (moduleKSheaf K) 0)] [Module.Finite K … 1]`. `degAt` (`Picard/DegreeSeam.lean`) is on `picEt` classes via `testPoint`, and `relPicDeg` (`RiemannRoch/RelPicDegree.lean:61`) on `relPic C (overSpec k K)` for a **field** `K`. Composing `classDeg κ(p) ∘ CechPic.map (relCurveMap C B κ(p))` is the missing definition; I verified it does not elaborate without hand-routing six instances (`instIsIntegralBaseChange`, `instSmoothOfRelativeDimensionBaseChange`, `instQuasiCompactBaseChange`, `LocallyOfFiniteType` via `SmoothOfRelativeDimension.smooth`, `instModuleFiniteHModuleZeroBaseChange`, `instModuleFiniteHModuleOneBaseChange` — all landed in `Curve/BaseChangeInstances.lean`).

## 4. TRIVIALITY CRITERION — none. This is the wall.

Queries run and their results:
- `grep -rn "picFromBase"` across the project: **every** producer is either the trivial-base case or a monotonicity/naturality lemma. The complete list of `theorem/lemma`-level facts: `mem_picFromBase_iff` (`Picard/RelPic.lean:57`, definitional), `picFromBase_le_comap` (:95), `picFromBase_le_comap_whiskerRight` (:160), `picFromBase_le_comap_crossBaseAffineIso(_inv)` (`Pic0Theta.lean:134,152`), `picFromBase_le_comap_hom` (`PicEtAffTransport.lean:103`), `cechPicMap_toUnit_whiskerRight_mem_picFromBase` (`RelPicCurveMap.lean:105`, about the terminal-curve map), `classDeg_eq_zero_of_mem_picFromBase` (`RelPicDegree.lean:46`, the *converse* direction), and `picFromBase_eq_bot_of_subsingleton` (`Tangent/RelPicPointTest.lean:77`, requires `[Subsingleton T.left]`). **No lemma anywhere concludes `∈ picFromBase` or `relPicMk … = 1` from a cohomological hypothesis.**
- `grep -rn "Subsingleton (relPic"`: zero hits. `Subsingleton (pic0Subgroup C T)` appears only as a *hypothesis* (e.g. `Pic0VanishingRoute`, `Genus0Terminal`, `Genus0VanishingDatum`). `Albanese/Genus0VanishingDatum.lean`'s header states outright: "`genus C = 0 → pic0Subgroup C T = ⊥` is real curve theory and no declaration in this tree proves it… What it needs at that instance is the relative statement `Pic(ℙ¹_T) ≅ Pic(T) × ℤ`."
- `find -name "*Collapse*"`: the seven files are all about *other* collapses. **`Cohomology/RelCurveCollapse.lean` is not about your question at all** — it packages the relative theta cocycle `t₀ᵃ` as a whole-chart `BasicOpenCocycleDatum` and proves `thetaChartDatumSheafIso` (:357, datum sheaf ≅ relThetaTwistSheaf), `subsingleton_datumPair_h1_thetaChartDatum` (:382), and `cechPicClass_thetaChartDatum` (:668, the class is the pullback of `fiberTwist π a` along the `B = k` collapse). "Collapse" there means the `k → k` base-field identification, not Picard triviality.
- The only class-triviality producers in the tree: `Opens.cechPicClass_basicOpen_eq_one_of_free` (`Picard/EffectivityMoving.lean:159`, an *affine-restriction* class in `CommRing.Pic Γ(Z,O)`, from `Module.Free`), `Scheme.CechPic.eq_one_of_subsingleton` (one-point space), `CechPic.mk_eq_one_iff` (`RefinementInjectivity.lean:195`, cocycle-level), and `cechPicClass_thetaChartDatum_zero` (`DivisorDatumInverse.lean:178`, exponent 0). None is cohomological.

## 5. mathlib

Mathlib version pinned at `v4.31.0` (`.lake-packages/mathlib`, rev `fabf563a`).

- **Pic of P¹ over a ring: absent.** `lean_leansearch "Picard group of the projective line over a ring is isomorphic to the integers"` → returns `CommRing.Pic` (affine only). `lean_loogle "CommRing.Pic"` → the whole API is `Mathlib.RingTheory.PicardGroup`, rings only. There is **no Pic of a scheme** in mathlib: `grep -rn "def Pic\b" Mathlib/AlgebraicGeometry/` → nothing.
- **`H¹(P¹_A, 𝒪) = 0` relatively: absent.** `ls Mathlib/AlgebraicGeometry/` shows no cohomology directory; the only sheaf-cohomology is `Mathlib/CategoryTheory/Sites/SheafCohomology/{Basic,Cech,MayerVietoris}.lean`, purely site-theoretic. AJCR proves the absolute base-field case itself (`Curve/P1H1Vanishing.lean:170` `P1.subsingleton_hModule_one`, `:187` `genus_asOver_eq_zero`).
- **Cohomology and base change: absent.** `grep -rln "cohomology and base change\|CohomologyAndBaseChange" Mathlib` → nothing. `lean_leansearch "cohomology and base change for a proper flat morphism, pushforward of a line bundle"` returns only `Modules.pushforward` (an open-immersion-fullness statement) and `IsProper.isStableUnderBaseChange`. `horizon search "cohomology and base change"` returns only project-internal declarations.
- **`Proj` line bundles `𝒪(n)` and pushforwards: absent from mathlib.** `grep -rln "Serre twist\|tautological\|twistingSheaf" Mathlib/AlgebraicGeometry/` → zero. `Mathlib/AlgebraicGeometry/Modules/` is three files (`Presheaf`, `Sheaf`, `Tilde`). What `Proj` has is the affine-chart machinery: `Proj.basicOpen`, `Proj.isAffineOpen_basicOpen`, `Proj.basicOpenIsoSpec`, `Proj.fromOfGlobalSections`. Notably, `horizon search "Serre twisting sheaf O(n) on Proj"` finds `ProjTwist.serreTwist` and `ProjTwist.twistingSheaf_isInvertibleGr` — but those are in the **sibling project** `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/SerreTwist{,Sections}.lean`, not in AJCR and not in mathlib. AJCR has no `Serre*` file (`ls AlgebraicJacobian/Picard/ | grep -i serre` → empty).
- **"Fibrewise-trivial + projective pushforward ⟹ pullback": absent** (follows from the two above — there is no pushforward to state it with).

## 6. BOTTOM LINE — what must be built

Good news first: **step (1) below I closed as a compiling probe during this audit**, so the fibrewise half is genuinely free. The wall is entirely at step (4).

1. **Fibrewise `hfib` from fibrewise degree 0 at genus 0.** `Subsingleton ((datumPair D).H1 ⊗[B] L)` from a degree-0 witness over `L`. **Inputs all present, and I verified the proof compiles** (sorry-free, ~35 lines) using: `subsingleton_h1_tensor_iff_exists_witness`, `CurveDivisor.exists_picClass_eq`, `riemann_inequality` (`ChiLedger.lean:~136`), `exists_effective_of_h0_pos` (`SectionBound.lean:175`), `CurveDivisor.eq_zero_of_deg_le_zero` (`SectionSpaces.lean:174`), `classDeg_picClass` (`Degree.lean:157`), `subsingleton_hModule_one_of_picClass_eq` (`ClassCohomology.lean:111`), `divisorSheafZeroIso` (`DivisorSheafZero.lean:285`), `chi_relCurve_baseField` + `h0_relCurve_baseField` (`Picard/DivSchemeSeedUnivAssembleKappa.lean:68, :57`). Six fibre-curve instances must be carried as explicit binders (the `haveI` form fails because the *statement* needs them). **Size: half a day, mostly instance plumbing.**

2. **A fibrewise-degree definition and its "= 0 at every p" form.** `classDeg κ(p) (CechPic.map (relCurveMap C B κ(p)) c)`, plus a wrapper producing the degree-0 witness divisor step (1) consumes. Inputs present (all six base-change instances land in `Curve/BaseChangeInstances.lean`); this is definitional bookkeeping. **Size: small, ~100 lines, no mathematics.**

3. **The P¹ instance bridge.** Two `@`-spelled instances at `(P1.asOver k).left` (given verbatim in §2) plus `genus_asOver_eq_zero`/`P1.subsingleton_hModule_one` routed into `Sheaf.chi (…moduleKSheaf k) = 1`. Verified working. **Size: trivial, ~20 lines.**

   At this point you have, at P¹ over any Noetherian `B`, for any class `c` of fibrewise degree 0: a datum `D` with `D.cechPicClass = c`, `H¹(C_B, F_D) = 0`, and `H⁰(C_B, F_D)` finite projective over `B`. That is the whole of what the project's machinery yields.

4. **The wall: `H¹ = 0` + `H⁰` finite projective ⟹ `c ∈ picFromBase C (overSpec k B)`.** Nothing in the project or mathlib bridges this, and the bridge cannot be assembled from what is there, because **there is no `π_*`, no `π^*`, and no evaluation morphism of sheaves anywhere** (§1(c) queries). Concretely missing, as a chain nobody has any link of:
   - (4a) `Module.Invertible B (Sheaf.HModule D.sheaf 0)` — i.e. rank 1. `datumRigidEngine` gives finite + projective; upgrading needs fibrewise rank 1 (available only over fields, `FLVClass.lean:412`) plus a rank-constancy-to-invertibility lemma that does not exist. Note `Descent/InvertibleModule.lean` and `GluedSheafAffineProjective.lean:74` (`nonempty_affineSectionsModel`) give invertibility of sections over an **affine open of the curve** as a `Γ(relCurve C B, V)`-module — the wrong ring; you need it over `B`.
   - (4b) A morphism `π^*(H⁰) → F_D` of sheaves on `relCurve C B`. Requires inventing a pullback-of-a-`B`-module-to-a-sheaf functor. `constModuleSheafHomEquiv` (`ModuleKSheaf.lean:137`) is the closest object but is for the *constant* sheaf on one site — it does not cross the projection to `Spec B`.
   - (4c) That morphism being an isomorphism (Nakayama fibrewise + `RigidEngine2Nakayama` would help, but only after 4b exists).
   - (4d) Translating "F_D ≅ pullback of a line bundle on Spec B" into `∃ N : (overSpec k B).left.CechPic, CechPic.map (snd C (overSpec k B)).left N = c`, i.e. back into `CechPic` cocycle language.

   **Size: this is the project's own named open problem, not plumbing.** `Albanese/Genus0VanishingDatum.lean` names exactly this — "it needs the relative statement `Pic(ℙ¹_T) ≅ Pic(T) × ℤ`; a base-field-only computation would not discharge the `∀ T` binder" — and `Curve/P1H1Vanishing.lean` lists it as the one remaining input to a `JacobianData` at ℙ¹.

**A cheaper route worth pricing before building 4a–4d.** Your classical proof is the derived-functor one, and this project has no derived functors. But at ℙ¹ specifically, step (1)'s argument already shows the *fibre* class is trivial at every point, and the glued sheaf is presented by an explicit finite cocycle with all pieces basic-open. Trivializing the class over `B` means exhibiting a 0-cochain `c_j ∈ Γ(D(h_j))ˣ` with `unit i j = c_i / c_j` — a statement about units in localizations of `Γ(V₀ᴮ), Γ(V₁ᴮ)`, reachable through `Descent/UnitDescent.lean` (`IsDescentCocycle.picClass_eq_one_iff`, :435) and `Algebra/LocalizationCocycle*.lean`. That stays inside the cocycle/algebra layer the project is actually equipped for, and sidesteps (4b) entirely. I did not price it further — it needs one more measurement pass over `Descent/` and `Algebra/LocalizationCocycle*` — but it is where I would look before committing to build a pullback functor.
