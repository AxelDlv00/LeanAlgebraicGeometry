I now have a complete verified inventory. Report:

---

# AJCR inventory for the P¹ seesaw (verified by source reading)

All paths absolute under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`. All files cited below have `sorry = 0`. Signatures marked ✔ were additionally confirmed by `#check` through `lake env lean` (see the end for the exact list).

## 0. The ambient objects the engine lives on (needed to read everything else)

| name | file:line | what it is |
|---|---|---|
| `relCurve C R : Scheme.{u}` | `AlgebraicJacobian/Cohomology/RelativeTwoCover.lean:115` | `:= (C ⊗ overSpec k R).left`. `relCurve.instOver : (relCurve C R).Over (Spec (.of R))` via `snd`, line 120. |
| `fiberTwoCover π : Y.AffineTwoCover` | `AlgebraicJacobian/Cohomology/RigidEngine4Relative.lean:75` | needs `[IsAffineHom π]`; `V₀ = π⁻¹D₊(X₀)`, `V₁ = π⁻¹D₊(X₁)`, overlap `π⁻¹D₊(X₀X₁)` affine. |
| `relCover C R D := D.pullbackProd R` | `AlgebraicJacobian/Cohomology/RelativeTwoCover.lean:128` | base change of the curve-level two-cover; `relCover_isAffineOpen₀/₁` (133/137), `relCover_sup` (141), `relCover_inf` (155). |
| `Scheme.AffineTwoCover` | `AlgebraicJacobian/Picard/AffineTwoCover.lean:51` | fields `V₀ V₁ isAffineOpen₀ isAffineOpen₁ sup_eq_top isAffineOpen_inf`. |
| `twistSubmodule k V₀ V₁ g W` | `AlgebraicJacobian/Cohomology/TwistedSheaf.lean:156` | `ker (twistDefect)` = `{(s₀,s₁) ∈ Γ(W⊓V₀)×Γ(W⊓V₁) | s₀ = g·s₁ on W⊓V₀⊓V₁}`. |
| `twistSheaf k V₀ V₁ g` | `AlgebraicJacobian/Cohomology/TwistedSheaf.lean:301` | the sheaf of `k`-modules of those; `twistTriv₀/₁` chart trivializations. |
| `relTwistSheaf C R D g` | `AlgebraicJacobian/Cohomology/TwistedSheaf.lean:478` | `:= twistSheaf R (relCover C R D).V₀ (relCover C R D).V₁ g`. |
| `relUnitCocycle C R D gk` | `AlgebraicJacobian/Cohomology/TwistedSheaf.lean:469` | pullback of a **curve-level** unit `gk : Γ(C.left, D.V₀ ⊓ D.V₁)ˣ` along `fst`. |
| `relCocycleBaseChange C R R' D g` | `AlgebraicJacobian/Cohomology/RelativeH1BaseChange.lean:325` | `Units.map (relSectionsMap …) g`. |
| `picFromBase C T` ✔ | `AlgebraicJacobian/Picard/RelPic.lean:54` | `:= (CechPic.map (snd C T).left).range : Subgroup ((C ⊗ T).left.CechPic)`; `mem_picFromBase_iff` at line 57. |

**What `g` is, precisely (your Q1 sub-question).** `g` is a *unit section on the overlap of the two pinned relative charts*:
```
g : Γ(relCurve C R, (relCover C R (fiberTwoCover π)).V₀ ⊓ (relCover C R (fiberTwoCover π)).V₁)ˣ
```
i.e. an invertible element of the ring of sections over `π⁻¹D₊(X₀X₁) ×_k Spec R`. It is *not* a family indexed by a cover; it is a single unit on a single overlap, and the "cocycle condition" is vacuous for a two-chart cover. The data needed to form `relTwistSheaf C R (fiberTwoCover π) g` is exactly: `C : Over (Spec (.of k))`, `[Field k]`, `R` a commutative `k`-algebra, `π : C.left ⟶ P1 k` with `[IsAffineHom π]` (`[IsFinite π]` at the engine), and that one unit. No smoothness/properness/irreducibility of `C` is required to *build* it.

---

## Q1 — rigid engine signatures

### `relTwistRigidEngine` ✔ — `AlgebraicJacobian/Cohomology/RigidEngine4Engine.lean:174`
```lean
theorem relTwistRigidEngine {k} [Field k] (C : Over (Spec (.of k)))
    (R) [CommRing R] [Algebra k R] (π : C.left ⟶ P1 k) [IsFinite π]
    (g : Γ(relCurve C R, (relCover C R (fiberTwoCover π)).V₀ ⊓
                          (relCover C R (fiberTwoCover π)).V₁)ˣ)
    (hπ : π ≫ P1.structureMap k = C.hom)          -- `include hπ`
    [IsNoetherianRing R]
    (hfib : ∀ p : PrimeSpectrum R,
      Subsingleton ((relTwistPair C R π g).H1 ⊗[R] p.asIdeal.ResidueField)) :
    Subsingleton (Sheaf.HModule (relTwistSheaf C R (fiberTwoCover π) g) 1) ∧
      Module.Finite R (Sheaf.HModule (relTwistSheaf C R (fiberTwoCover π) g) 0) ∧
      Module.Projective R (Sheaf.HModule (relTwistSheaf C R (fiberTwoCover π) g) 0)
```
`relTwistPair C R π g` (line 162) `:= (relTwistPairData C R π g).pair (relCover_isAffineOpen₀ …) (relCover_isAffineOpen₁ …)`, a `TwoLatticePair` with carriers `F_g(V₀ᴿ) × F_g(V₁ᴿ) → F_g(V₀ᴿ ⊓ V₁ᴿ)`.

**`hfib` in its exact form:** `∀ p : PrimeSpectrum R, Subsingleton ((relTwistPair C R π g).H1 ⊗[R] p.asIdeal.ResidueField)`. This is the *complex form* — `H¹` of the two-lattice pair tensored with the residue field, **not** `H¹` of the fibre sheaf. Both file docstrings call the sheaf-level discharge "the W6-full seam, deliberately NOT attempted here". For your seesaw at genus 0 this is the hypothesis you must produce (see Q3/Q5 verdicts).

Neighbours in the same file (all with the same `C R π g` prefix):
- `relTwistRigidEngine_isOpen_vanishing` (line 194, needs `hπ`, **no** Noetherian): `IsOpen {p | Subsingleton ((relTwistPair C R π g).H1 ⊗[R] κ(p))}`.
- `relTwistH0TensorEquiv` ✔ (line 206): `(hH1 : Subsingleton (relTwistPair C R π g).H1) → (P : Type u) → [AddCommGroup P] [Module R P] → Sheaf.HModule (relTwistSheaf …) 0 ⊗[R] P ≃ₗ[R] ↥(ker ((relTwistPair C R π g).diff.rTensor P))`. **No `hπ`, no Noetherian.**
- `relTwistH0BaseChangeEquiv` (line 224): `(hH1) → (R') [CommRing R'] [Algebra R R'] → R' ⊗[R] H⁰ ≃ₗ[R'] ↥(ker (diff.baseChange R'))`. Note: only `Algebra R R'` here, no `k`-tower.
- `relTwist_subsingleton_pairH1` (line 240, needs `hπ`, **no** Noetherian): `hfib → Subsingleton (relTwistPair C R π g).H1`. This is the bridge from `hfib` to the `hH1` the two equivs want.
- `moduleFinite_aeval'_relTwistPair_t₀/t₁` (97/109), `free_relTwistSections₀/₁/Overlap` (122/132/143), `relTwistPairData` (87), and the two `QcohOn` instances (66/73).

### `relTwistH0BaseChange` ✔ — `AlgebraicJacobian/Cohomology/RigidEngine4BaseChange.lean:471`
```lean
noncomputable def relTwistH0BaseChange {k} [Field k] (C : Over (Spec (.of k)))
    (R) [CommRing R] [Algebra k R]
    (R') [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
    (π : C.left ⟶ P1 k) [IsFinite π] (g : …ˣ)
    (hH1 : Subsingleton (relTwistPair C R π g).H1) :
    R' ⊗[R] (Sheaf.HModule (relTwistSheaf C R (fiberTwoCover π) g) 0) ≃ₗ[R']
      Sheaf.HModule (relTwistSheaf C R' (fiberTwoCover π)
        (relCocycleBaseChange C R R' (fiberTwoCover π) g)) 0
```
**No `hπ`, no Noetherian** — the hypothesis is only `hH1`. Note the full `k`-tower `[Algebra k R'] [IsScalarTower k R R']` (so `R'` must be a `k`-algebra, not just an `R`-algebra).

### `relTwist_subsingleton_h1_baseChange` ✔ — same file, line 445
Same binders as above, `(hH1 : Subsingleton (relTwistPair C R π g).H1) → Subsingleton (Sheaf.HModule (relTwistSheaf C R' (fiberTwoCover π) (relCocycleBaseChange …)) 1)`.

Neighbours: `twistTriv₀_pairDiff` (63) — the twisted differential is `(s₀,s₁) ↦ s₀|ov − g·s₁|ov`; `relTwistDomBaseChange` (94); `relTwistDiff` (198); `relTwistDiffBaseChange` (235) and `relTwistPairDiffBaseChange` (412) — the δ-naturality square; `relTwist_surjective_diff_baseChange` (426); `relTwistPair_diff` (406, `rfl`).

### `RigidEngine4Assembly.lean` — the abstract layer
- `Scheme.TwoCoverPairData F U₀ U₁` (line 207): structure with fields `g₀ : Γ(X,U₀)`, `g₁ : Γ(X,U₁)`, `inf_eq_basicOpen₀/₁ : U₀ ⊓ U₁ = X.basicOpen g₀/g₁`, `smul_qsmul₀/₁`, `qsmul₀_qsmul₁`, `qsmul₁_qsmul₀`. Requires `[Scheme.QcohOn F U₀] [Scheme.QcohOn F U₁]`.
- `rigidEngine` (line 414): `[IsNoetherianRing R] [Module.Finite R[X] (Module.AEval' pair.t₀)] [Module.Finite R[X] (Module.AEval' pair.t₁)] [Module.Flat R (F(U₀) × F(U₁))] [Module.Projective R (F(U₀⊓U₁))]` + `hcov : U₀ ⊔ U₁ = ⊤` + `hfib` ⟹ same conclusion triple.
- `h0Equiv`/`h1Equiv` (374/382), `surjective_diff` (396), `rigidEngine_isOpen_vanishing` (441), `h0TensorEquiv` (452), `h0BaseChangeEquiv` (466), `RigidEngine.kerCongr` (84), `surjective_congr` (104), `Scheme.twoCoverH0LinearEquiv` (181).

**Verdict Q1: usable as-is, with one caveat.** The engine is complete and hypothesis-free apart from `hfib` (complex form) and `hπ`/Noetherian for the two clauses noted. For the seesaw you will consume `relTwistH0BaseChange` at `R' = κ(p)` or at a field point.

---

## Q2 — invertibility of `H⁰`, the counit `π*π_*L → L`, generation by one section

This is where AJCR is thinnest relative to what you asked.

### Present and directly relevant

**`BasicOpenCocycleDatum.rankAtStalk_hModule_zero_eq_one`** ✔ — `AlgebraicJacobian/Picard/DivisorDatumRankOne.lean:148`
```lean
theorem …rankAtStalk_hModule_zero_eq_one {k} [Field k] {C} {S} [CommRing S] [Algebra k S]
    {π : C.left ⟶ P1 k} [IsFinite π] {n : ℕ}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (D : BasicOpenCocycleDatum C S π) [IsNoetherianRing S]
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (n : ℤ))
    (hfib : ∀ q : PrimeSpectrum S, Subsingleton ((datumPair D).H1 ⊗[S] q.asIdeal.ResidueField))
    (p : PrimeSpectrum S)
    [IsIntegral (relCurve C κ(p))]
    [SmoothOfRelativeDimension 1 (relCurve C κ(p) ↘ Spec (.of κ(p)))]
    [QuasiCompact (relCurve C κ(p) ↘ Spec (.of κ(p)))]
    [Module.Finite κ(p) (Sheaf.HModule ((relCurve C κ(p)).moduleKSheaf κ(p)) 0)]
    [Module.Finite κ(p) (Sheaf.HModule ((relCurve C κ(p)).moduleKSheaf κ(p)) 1)]
    (hg : classDeg κ(p) (D.baseChange κ(p)).cechPicClass = (n : ℤ)) :
    Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1
```
This is exactly "`π_* L` is rank one at every prime" — for `n = 0` (degree-0 class) and `χ(𝒪_C) = 1` (genus 0), which is your case. Combined with `datumRigidEngine`'s finite+projective, this is **finite projective of constant rank 1**. It stops one step short of `Module.Invertible`: there is **no declaration in AJCR of the form `Module.Invertible _ (Sheaf.HModule _ 0)`** (grepped `"Invertible.*HModule\|HModule.*Invertible"` across `AlgebraicJacobian/` — zero hits).

Support: `BasicOpenCocycleDatum.h0_sheaf_baseChange_eq_one` (same file, line 109) — `h⁰(C_L, F_{D_L}) = 1` at a field `L` from `classDeg = n`, `χ = 1−n`, `Subsingleton H¹`; `chi_relCurve` (line 83).

**`CertifiedDivisorFamily.exists_fibrewise_generator_divisorDatum`** — `AlgebraicJacobian/Picard/DivisorDatumRankOne.lean:248`: a *fibrewise-nonzero global section on a basic open* `D(f) ∋ p`, i.e. a **Zariski-local**, not global, generator. Underlying kit: `Module.exists_fibrewise_tmul_ne_zero_of_projective` at `AlgebraicJacobian/Picard/LocalGenerators.lean:87`.

**Invertibility of section modules of a glued line bundle on an affine open** — `AlgebraicJacobian/Cohomology/GluedSheafAffineProjective.lean`: `BasicOpenCocycleDatum.AffineSectionsModel` (line 54, a structure bundling `qcoh`, `finite`, `projective`, `invertible`) and `nonempty_affineSectionsModel` (line 74): for `V` an affine open of `relCurve C B`, `Nonempty (D.AffineSectionsModel V)`. This is invertibility of `F_D(V)` over `Γ(relCurve C B, V)` — **the sheaf's own sections over an affine open, not the pushforward `H⁰` over the base ring**. Different object.

**Pure-algebra invertibility kit** (usable, base-ring level):
- `Module.Invertible.of_invertible_tensorProduct_of_faithfullyFlat` — `AlgebraicJacobian/Descent/InvertibleModule.lean:229`
- `Module.Invertible.free_of_span_singleton_eq_top` — `AlgebraicJacobian/Picard/EffectivityInvertibleAvoid.lean:92` (**a cyclic invertible module is free** — this is the "generated by one section ⟹ trivial" step, at module level)
- `Module.Invertible.exists_notMem_isUnit_free` — same file, line 161
- `Module.Invertible.rankAtStalk_eq_of_module_finite` — `AlgebraicJacobian/Picard/InvertibleModuleTransfer.lean:266`
- `Module.isUnit_map_rTensor_generator` — `AlgebraicJacobian/Algebra/GeneratorUnit.lean:64`; `Module.descentMulEval` line 111.

### Absent
- **No counit / evaluation map `π^*π_*L → L`.** Searched `counit` (only `Over.mapPullbackAdj`/`Adjunction.counit` bookkeeping in `Picard/JacobianDataBaseChange*.lean`, `Pic0ThetaProjectionCoherence.lean`, and a comonad `counit` field in `Descent/UnitDescent.lean:166` — none is `π^*π_*L → L`), `evalMap`/`evaluationMap`/`evalHom` (zero hits), `pushforward` (only prose and unrelated names). **The counit map does not exist as a declaration in AJCR, in any direction.**
- **No `Module.Invertible` on any `Sheaf.HModule`.**
- **No "nowhere-vanishing / global generator" statement**: `nowhere.vanish`, `nowhere-zero`, `generating section`, `global generator`, `nonvanishing section` — zero hits.

**Verdict Q2: needs work.** You have rank-one-at-every-prime + finite + projective for the *datum* `H⁰` (Q2's first half, under `n=0`, `χ=1`, `hfib`, `[IsNoetherianRing S]` and the six fibre instances). The `Module.Invertible` upgrade is a short step you must state. The counit `π^*π_*L → L` and its iso-ness are **absent** — the classical proof route is not formalized. `Module.Invertible.free_of_span_singleton_eq_top` is the closest replacement for "generated by one global section ⟹ trivial", but it is module-level and does not know about `CechPic`.

---

## Q3 — `CechPic` ⟷ cocycle / glued sheaf bridge

### The `CechPic` → glued-sheaf direction: EXISTS, unconditionally, in the m-chart (datum) world

**`BasicOpenCocycleDatum.exists_cechPicClass_eq`** ✔ — `AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean:301`
```lean
theorem …exists_cechPicClass_eq {k} [Field k] {C} {B} [CommRing B] [Algebra k B]
    {π : C.left ⟶ P1 k} [IsAffineHom π] (c : (relCurve C B).CechPic) :
    ∃ D : BasicOpenCocycleDatum C B π, D.cechPicClass = c
```
Only `[IsAffineHom π]`. This is the surjectivity you need: **every** Čech Picard class on `relCurve C B` is `D.cechPicClass` for some pinned basic-open cocycle datum. Support: `IsAffineOpen.exists_finite_basicOpen_refinement` (line 124), `ofRefinement` (213), `cechPicClass_eq_of_anchor` (242).

**`BasicOpenCocycleDatum.cechPicClass`** ✔ — `AlgebraicJacobian/Cohomology/GluedSheafClass.lean:269` — the class of a datum, on the canonical pointed cover by pieces; `cechPicClass_eq_mk` (277) computes it on *any* subordinated pointed cover; **`cechPicClass_baseChange` (358)**: `(D.baseChange B').cechPicClass = CechPic.map (relCurveMap C B B') D.cechPicClass` — naturality in the test ring.

`BasicOpenCocycleDatum` structure — `AlgebraicJacobian/Cohomology/GluedSheafDatum.lean:143`: extends `BasicOpenCoverData C B π` (finite `J₀, J₁`, generators `h_j`, partitions of unity per pinned chart, `pieces : J₀ ⊕ J₁ → Opens`) with `unit : ∀ i j, Γ(relCurve C B, pieces i ⊓ pieces j)ˣ` and `isGluingCocycle`. `D.sheaf := gluedSheaf B D.pieces D.unit` (line 157); `D.pairData` (line 190); engine keystones in `GluedSheafEngine.lean`: `datumRigidEngine` (198), `datumRigidEngine_isOpen_vanishing` (221), `datumH0TensorEquiv` (233), `datumH0BaseChangeEquiv` (247), `datum_subsingleton_pairH1` (262); `datumH0BaseChange` (`GluedSheafH0BaseChange.lean:229`) and `datum_subsingleton_h1_baseChange` (line 245).

### The two-chart (`relTwistSheaf`) ⟷ `CechPic` bridge: only at the theta cocycle

`AlgebraicJacobian/Cohomology/RelCurveCollapse.lean` connects the two worlds, but **only for the specific cocycle `t₀ᵃ`**:
- `thetaChartCover` (66) / `thetaChartUnit` (103) / `thetaChartDatum` (137): the *whole-chart* datum (each pinned chart is `D(1)` in itself, `J₀ = J₁ = PUnit`) with transition unit the relative theta cocycle.
- `thetaChartDatumSheafIso` (357): `(thetaChartDatum C B π a).sheaf ≅ relThetaTwistSheaf C B π a`. `subsingleton_hModule_thetaChartDatum_iff` (369).
- `cechPicClass_thetaChartDatum` (668): `(thetaChartDatum C k π a).cechPicClass = CechPic.map (fst C (overSpec k k)).left (fiberTwist π a)` — **only at `B = k`**.

**There is no generic version**: grepped for `wholeChart|chartDatumOf|datumOfUnit|twoChartDatum` — zero hits. So for an *arbitrary* overlap unit `g` there is **no** `cechPicClass` of `relTwistSheaf … g`. The `thetaChartCover` construction is trivially generalizable (it only uses `1 · 1 = 1` and `g`), but it is not landed.

### `twoChartClassHom`: exists, on an *abstract* scheme, and is NOT connected to `relCurve`

`AlgebraicJacobian/Tangent/TwoChartCechPic.lean:235`, ambient `{X : Scheme.{u}} {V : Bool → X.Opens}`:
```lean
noncomputable def Scheme.twoChartClassHom (V : Bool → X.Opens) (sel : X → Bool)
    (hmem : ∀ x, x ∈ V (sel x)) : Γ(X, V false ⊓ V true)ˣ →* X.CechPic
```
with `twoChartClassHom_apply` (244), `twoChartClassHom_eq_one_iff`, `twoChartClass` (429), `twoChartClass_injective` (450). Range statements:
- `Scheme.twoChartClassHom_mk_range` — `AlgebraicJacobian/Tangent/TwoChartNormalize.lean:242`: needs `{base : Bool → X} (hbase : ∀ s, sel (base s) = s)`; every class *represented on the two-chart cover* is `twoChartClassHom u`.
- `Scheme.twoChartClassHom_surjOn_of_chartTrivial` — `AlgebraicJacobian/Tangent/TwoChartRepresentable.lean:301`: `(L : X.CechPic) (hL : ∀ s : Bool, CechPic.map (V s).ι L = 1) → ∃ u, twoChartClassHom V sel hmem u = L`. **This is the "a class trivial on each of the two charts is a two-chart cocycle" theorem, with no affineness/curve hypotheses.**
- Naturality: `Scheme.map_twoChartClassHom` — `AlgebraicJacobian/Tangent/TwoChartNaturality.lean:181`.

**But**: I grepped every file mentioning `twoChartClassHom` for `relCover|relCurve` — the only hit is `Tangent/DualNumberCarrierReduction.lean` (dual-number lane). So `twoChartClassHom` is **never instantiated at `X = relCurve C A`, `V = relCover C A (fiberTwoCover π)`**, and there is **no lemma relating `twoChartClassHom u` to `relTwistSheaf … u`** in either direction. Searched `grep -rln twistSheaf … | xargs grep -ln "cechPicClass\|CechPic"` — empty.

**Verdict Q3:**
- `CechPic` → *datum* glued sheaf: **usable as-is** (`exists_cechPicClass_eq`), and the datum world has the full engine + base change + class naturality. This is the route to take.
- `CechPic` → *two-chart* `relTwistSheaf`: **needs two bricks** — (a) generalize `thetaChartDatum`/`thetaChartDatumSheafIso` from `t₀ᵃ` to an arbitrary `g` (mechanical: the construction only needs `g` and `1·1=1`); (b) prove `cechPicClass (wholeChartDatum g) = twoChartClassHom … g` (or, equivalently, instantiate `twoChartClassHom_surjOn_of_chartTrivial` at the relative cover and match). Neither exists.

---

## Q4 — fibre degree of a class on the relative curve

| name | file:line | statement (faithful) |
|---|---|---|
| `classDeg K : Additive X.CechPic →+ ℤ` | `AlgebraicJacobian/RiemannRoch/Degree.lean:150` | needs `X` a curve bundle over `K` with the standing pack. `classDeg_picClass` (156) `= deg D`; `classDeg_mul` (165); `classDeg_one` (172); `classDeg_inv` (176). |
| `relPicDeg K : Additive (relPic C (overSpec k K)) →+ ℤ` | `AlgebraicJacobian/RiemannRoch/RelPicDegree.lean:61` | `[Field K] [Algebra k K]`; anchor `relPicDeg_relPicMk` (75): `relPicDeg K (relPicMk C (overSpec k K) L) = classDeg K L`; `relPicDeg_relPicAlgMap` (84) — invariance under `φ : K₁ →ₐ[k] K₂`. Rests on `classDeg_eq_zero_of_mem_picFromBase` (46). |
| `degAt` | `AlgebraicJacobian/Picard/Pic0Functor.lean:54` | `degAt {T} (lam : picEt C T) {K} [Field K] [Algebra k K] (t : overSpec k K ⟶ T) : ℤ := PicEtAff.degAff K (picEtAffineEquiv C K (picEtMap C t lam))`. Note: on `picEt` (étale-sheafified), not on `CechPic`. |
| `pic0Subgroup C T` | `AlgebraicJacobian/Picard/Pic0Functor.lean:107` | carrier `{lam | ∀ (K) [Field K] [Algebra k K] (t : overSpec k K ⟶ T), degAt lam t = 0}`; `mem_pic0Subgroup_iff` (121). |

**The main bridges (`AlgebraicJacobian/Picard/DegreeSeam.lean`).** Standing binders: `{k} [Field k] {C} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, `{A} [CommRing A] [Algebra k A] {K} [Field K] [Algebra k K]`.
- line 67 `degAt_of_affineEquiv_eq_unit (φ : A →ₐ[k] K) (lam : picEt C (overSpec k A)) (z : relPic C (overSpec k A)) (h : picEtAffineEquiv C A lam = PicEtAff.unit C A z) : degAt lam (Over.overSpecMap φ) = relPicDeg K (relPicAlgMap C φ z)`
- **line 81 (the keystone) `degAt_of_affineEquiv_eq_unit_relPicMk`**: same, with `z = relPicMk C (overSpec k A) L` for `L : (C ⊗ overSpec k A).left.CechPic`, concluding
  ```
  degAt lam (Over.overSpecMap φ) = classDeg K (Scheme.CechPic.map ((C ◁ Over.overSpecMap φ).left) L)
  ```
  **This is exactly your "the fibre restriction of a relative class at a field point equals `classDeg` of the pulled-back class".** The pullback is `CechPic.map ((C ◁ Over.overSpecMap φ).left)`, i.e. base change of the class along `A → K`.
- line 107 `degAt_of_affineEquiv_eq_unit_baseChange`, line 118 `degAt_eq_classDeg_of_affineEquiv_eq_unit_baseChange` (degree of a class pulled back from `C_k` is `classDeg k L₀` at every field point), line 135 `degAt_pow`, line 145 `degAt_pic0_mul_pow`.

**Degree invariance bridges** (both needed to make "degree vanishes on every fibre" well-posed):
- `classDeg_cechPicMap_baseFieldTransition` — `AlgebraicJacobian/RiemannRoch/DegreeBaseFieldInvariance.lean:462` (E-iv-alg: `classDeg K₂ (CechPic.map π L) = classDeg K₁ L` along `φ : K₁ →ₐ[k] K₂`).
- `classDeg_cechPicMap_of_isIso` — `AlgebraicJacobian/RiemannRoch/ClassDegMapIso.lean:150`; `classDeg_map_iso` line 196.
- `classDeg_zpow` — `AlgebraicJacobian/RiemannRoch/DegreeBaseChange.lean:69`.

**`DegreeSeam` is `degAt`-shaped, i.e. via `picEt`.** If your class lives directly in `(C ⊗ overSpec k A).left.CechPic` rather than in `picEt C (overSpec k A)`, the hypothesis `picEtAffineEquiv C A lam = PicEtAff.unit C A (relPicMk C (overSpec k A) L)` is what you must supply.

**`relPicDeg` exists only over a FIELD** (`[Field K]` is a binder of the definition). There is no `relPicDeg` over a ring `A`. The "fibrewise degree zero" condition over `A` is spelled through `degAt`/`pic0Subgroup` at all field points, not through a single degree map on `relPic C (overSpec k A)`.

**Verdict Q4: usable as-is for the degree side.** `degAt_of_affineEquiv_eq_unit_relPicMk` is the bridge you named. Caveat: it is phrased for `picEt` classes and needs the `picEtAffineEquiv`-collapse hypothesis; there is no `relPicDeg` at ring level.

---

## Q5 — `H¹(P¹_A, 𝒪) = 0` and `H⁰(P¹_A, 𝒪) = A` over a **ring**

Measured base generality, per file:

**`AlgebraicJacobian/Curve/P1H1Vanishing.lean` — FIELD only.**
- `P1.subsingleton_hModule_one (k)` (line 170): `Subsingleton (Sheaf.HModule ((P1 k).moduleKSheaf k) 1)`, `{k} [Field k]`. This is `H¹(P¹_k, 𝒪) = 0` over the **base field**, nothing relative.
- `P1.genus_asOver_eq_zero` (187): `genus (asOver k) = 0`, `[Field k]`.
- `LaurentChartPair.diff_surjective` (136), `subsingleton_h1Cok` (145), `subsingleton_hModule_one` (158) — all `[Field k]`.
- The header carries a compiler-checked `converse` (line 36) at a curve over a field.

**`AlgebraicJacobian/Cohomology/FinitenessP1.lean` — no cohomology statement at all.** It is `ℙ¹`-side plumbing: `Scheme.Hom.appTop_map_appLE` (49), `appLE_overAlgebraMap` (62), `P1.awayι_structureMap` (83), `structureMap_appTop_awayToSection` (100), `basicOpen_awayToSection_chartCoord` (136), `overlapSectionsEquiv_symm_T/_T_neg/_algebraMap` (166/177/187). Base ring is `[CommRing k]` in the first section, `[Field k]`-flavoured later. **No `H⁰`/`H¹` claim here.**

**`AlgebraicJacobian/Cohomology/RelativeH1BaseChange.lean` — arbitrary commutative `k`-algebras, but it is base *change*, not vanishing.**
- `relTermBaseChange` (118), `relDiffBaseChange` (192), `relDiffBaseChange_range` (257).
- **`relH1CokBaseChange` (276)** and **`relH1BaseChange` (302)**: `R' ⊗[R] H¹(C_R, 𝒪) ≃ₗ[R'] H¹(C_{R'}, 𝒪)`, binders `(R) [CommRing R] [Algebra k R]`, `(R') [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']`, `(D : C.left.AffineTwoCover)`. **Unconditional in the ring map — no flatness** (right-exactness of the two-term cokernel). This transports vanishing along a *tower*, but does not produce it at any base.
- Note `relH1BaseChange`/`relH1CokBaseChange` have **zero consumers** in the project (grepped; only a docstring mention in `H1BaseFieldInvariance.lean:39`).

**`AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean` — arbitrary commutative `k`-algebra `R` for the CBC section.** Binders `{k} [Field k] (C : Over (Spec (.of k))) (R) [CommRing R] [Algebra k R] (D : C.left.AffineTwoCover)`:
- **`curveH1BaseChange` (272): `R ⊗[k] H¹(C, 𝒪) ≃ₗ[R] H¹(C_R, 𝒪)`** — from the *absolute* curve to the relative curve, **over an arbitrary commutative `k`-algebra `R`**, no flatness.
- **`curveH0BaseChange` (302): `R ⊗[k] H⁰(C, 𝒪) ≃ₗ[R] H⁰(C_R, 𝒪)`** — same generality (needs the standing `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` of the `StandingBundle` section).
- Field-only headlines: `h1BaseFieldEquiv` (328), `h0BaseFieldEquiv` (336), `finrank_h1/h0_baseField` (344/354), `genus_baseField` (373).

**This is the pair you want for Q5.** Composing `curveH1BaseChange` at `C = P1.asOver k` with `P1.subsingleton_hModule_one k` gives `H¹(P¹_A, 𝒪) = 0` for **arbitrary commutative `k`-algebra `A`** (a tensor of a subsingleton is a subsingleton). **That composite is NOT landed** — grepped `curveH1BaseChange` consumers: zero. Likewise `curveH0BaseChange` + `Γ(P¹,𝒪)=k` gives `H⁰(P¹_A,𝒪) ≅ A`; also not landed as such.

**The `H⁰ = A` statement over a ring IS landed, twice, by a different route:**
- **`Over.universalSectionsEquiv`** — `AlgebraicJacobian/Picard/UniversalSections.lean:129`: `A ≃+* Γ((C ⊗ overSpec k A).left, ⊤)`, binders `(C : Over (Spec (.of k))) [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]`, `(A) [CommRing A] [Algebra k A]`. **Arbitrary commutative `k`-algebra `A`.** Keystone `Over.isIso_appTop_snd_overSpec` (line 82).
- **`relStructureSectionsTop`** — `AlgebraicJacobian/Cohomology/RelativeTwoCover.lean:170`: `Γ(relCurve C R, ⊤) ≃+* R`, `(R) [CommRing R] [Algebra k R]`, standing bundle `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`. `:= (Over.universalSectionsEquiv C R).symm`.

**`AlgebraicJacobian/Cohomology/RelCurveCollapse.lean`** contains **no `H¹(𝒪) = 0` statement** — it is the theta-datum/twist-sheaf collapse (see Q3). Its only vanishing is `subsingleton_datumPair_h1_thetaChartDatum` (line 382), at `B = k` and for the theta cocycle, taking `Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1` as input.

**Related, field-only:** `P1.chi_baseChange_eq_one` — `AlgebraicJacobian/Curve/P1DegreeZeroTrivial.lean:114`, `[Field K] [Algebra k K]`; `P1.eq_one_of_classDeg_eq_zero_baseChange` (140) and `classDeg_eq_zero_iff_baseChange` (147) — **a degree-zero class on `P¹_K` is trivial, for every field extension `K/k`**. This file's own "What this does NOT do" section states plainly that the *ring* case is the untouched descent step, names it as "`Pic(P¹_A) ≅ Pic(A) × ℤ`, cohomology and base change", and records that the chart-by-chart field argument does not extend (measured: `Subsingleton (CommRing.Pic (Polynomial A))` fails to synthesize for general `[CommRing A]`, even given `Subsingleton (CommRing.Pic A)`).

**Verdict Q5:**
| statement | base generality landed |
|---|---|
| `H¹(P¹_k, 𝒪) = 0` | **field only** (`P1H1Vanishing.lean:170`) |
| `H¹(C_R, 𝒪) ≅ R ⊗_k H¹(C, 𝒪)` | **arbitrary comm. `k`-algebra `R`** (`H1BaseFieldInvariance.lean:272`) — so `H¹(P¹_A,𝒪)=0` over a ring is a **one-line composite that is not landed** |
| `H⁰(C_A, 𝒪) ≅ A` | **arbitrary comm. `k`-algebra `A`**, landed (`UniversalSections.lean:129`, `RelativeTwoCover.lean:170`) |
| `H¹(P¹_A, 𝒪) = 0` over a ring, as a declaration | **absent** |
| degree-zero ⟹ trivial on `P¹` | **field only** (`P1DegreeZeroTrivial.lean:140`); the ring case is explicitly the open step |

---

## Bottom line for the seesaw

The pieces that are **usable as-is**: the datum extraction `exists_cechPicClass_eq` (any class ⟶ a cocycle datum, `[IsAffineHom π]` only); the datum engine `datumRigidEngine` + `datumH0BaseChange` + `datum_subsingleton_h1_baseChange`; the descent to a Noetherian f.g. stage `exists_fg_isNoetherianRing_baseChange_eq` (`DatumDescent.lean:514`) with `descent_cechPicClass` (525); the rank-one export `rankAtStalk_hModule_zero_eq_one`; the `hfib` discharge from a fibre witness `subsingleton_h1_residueField_tensor_of_witness` (`GluedSheafDatumFibre.lean:169`); the degree seam `degAt_of_affineEquiv_eq_unit_relPicMk`; `H⁰(C_A,𝒪)=A` over a ring.

The pieces you must **build**: (i) `H¹(P¹_A,𝒪)=0` over a ring, as a composite of `curveH1BaseChange` with the field vanishing (cheap, unlanded); (ii) `Module.Invertible` on `Sheaf.HModule D.sheaf 0` from rank-1 + finite + projective (short, unlanded); (iii) the **counit `π^*π_*L → L` and its iso-ness — entirely absent**, no declaration in the project, so the classical cohomology-and-base-change route to the seesaw has no formalized spine here; (iv) if you want the two-chart `relTwistSheaf` world rather than the m-chart datum world, the generic whole-chart datum for an arbitrary overlap unit `g` plus its class law (`thetaChartDatum`/`cechPicClass_thetaChartDatum` exist only for `t₀ᵃ`, and the latter only at `B = k`).

`#check`-verified: `relTwistRigidEngine`, `relTwistH0BaseChange`, `relTwist_subsingleton_h1_baseChange`, `relTwistH0TensorEquiv`, `BasicOpenCocycleDatum.exists_cechPicClass_eq`, `BasicOpenCocycleDatum.cechPicClass`, `BasicOpenCocycleDatum.rankAtStalk_hModule_zero_eq_one`, `BasicOpenCocycleDatum.subsingleton_h1_residueField_tensor_of_witness`, `picFromBase`. Everything else was read directly from source at the line numbers given. No files were edited; no commits made.
