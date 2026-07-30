I have everything. Final report.

## Bottom line first

**The RR route is already built.** `classDeg K L = 0 ⟹ L = 1` on a genus-0 curve needs **zero new mathematics** — it is a 5-line composition of three landed theorems, and it closes at P¹ with all instances discharged. I verified this with `lean_run_code` (green, `#print axioms` → `[propext, Classical.choice, Quot.sound]`, no `sorry`). The general form, the arbitrary-genus-0-curve form, and the P¹ instantiation all elaborate. It also yields `Function.Injective (classDeg K)` — i.e. `Pic(P¹_k) ↪ ℤ`, pic-g's stated objective — for three more lines.

The proof, verbatim, that compiles:

```lean
theorem eq_one_of_classDeg_eq_zero (hχ : Sheaf.chi (X.moduleKSheaf K) = 1)
    (L : X.CechPic) (hL : classDeg K L = 0) : L = 1 := by
  obtain ⟨E, hEeff, hEcl, hEdeg⟩ :=
    exists_effective_deg_eq_of_classDeg_eq K 0 (by rw [hχ]; norm_num) L (by rw [hL]; norm_num)
  have hE0 : E = 0 :=
    Scheme.CurveDivisor.eq_zero_of_deg_le_zero K hEeff (by rw [hEdeg]; norm_num)
  rw [← hEcl, hE0, CurveDivisor.picClass_zero]
```

Binders: `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] [QuasiCompact (X ↘ Spec (CommRingCat.of K))] [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)] [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]`. `LocallyOfFiniteType` is the only binder beyond the standard curve pack; it comes from `residueDeg_pos` and is `inferInstanceAs (LocallyOfFiniteType C.hom)` at any bundle.

**Note the shape difference from your plan:** the route never touches h⁰/h¹ of `L`. `exists_effective_deg_eq_of_classDeg_eq` runs Riemann–Roch on a *chosen Weil divisor representative* `W` (via `CurveDivisor.exists_picClass_eq`) and hands back the effective divisor plus its degree. The answer to your critical Q6 is "no such object exists" — and it does not matter.

## 1. `classDeg` — `RiemannRoch/Degree.lean:150`

Defined **via chosen divisor representatives**, not χ and not a valuation sum:

```lean
private noncomputable def classDegFun (L : X.CechPic) : ℤ :=
  CurveDivisor.deg K (CurveDivisor.exists_picClass_eq K L).choose      -- :111

noncomputable def classDeg : Additive X.CechPic →+ ℤ where               -- :150
  toFun L := classDegFun K L
  map_zero' := classDegFun_one K
  map_add' L L' := classDegFun_mul K L L'
```

Binders (file-level `variable`, lines 65–69): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] [QuasiCompact (X ↘ Spec (CommRingCat.of K))] [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)] [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]`.

Well-definedness is `deg_eq_deg_of_picClass_eq` (:95) — equal classes differ by `div g` (`CurveDivisor.exists_divOf_of_picClass_eq`) and `deg_divOf = 0` (`ChiLedger.lean:126`).

Every lemma in the file:
- `chi_divisorSheaf_eq_of_picClass_eq` (:80) — finiteness-free
- `deg_eq_deg_of_picClass_eq` (:95)
- `classDeg_picClass (D) : classDeg K (CurveDivisor.picClass K D) = CurveDivisor.deg K D` (:157) — **this is the divisor-class-to-divisor-degree bridge you asked about; it is the definitional anchor, total in `D`, no effectivity**
- `classDeg_mul` (:164), `classDeg_one` (:170, `@[simp]`), `classDeg_inv` (:174)
- `chi_divisorSheaf_classDeg (D) : chi (divisorSheaf K D) = chi (moduleKSheaf K) + classDeg K (picClass K D)` (:185)
- `classDeg_divisorClass (D) : classDeg K (divisorClass K D) = deg K D` (:195) — same bridge for the deg-D1 map, via `divisorClass_eq_picClass` (`Picard/DivisorClassCompat.lean:145`, which proves the two class maps are *equal*)
- `chi_divisorSheaf_classDeg_curve` (:216) — curve form, `= 1 - genus C + classDeg k (picClass k D)`, no finiteness side conditions

## 2. Riemann–Roch in this project

There is **no duality**: no canonical divisor, no `K_X`, no `h⁰(L) - h⁰(K-L)`. What exists is the χ-ledger plus the Riemann *inequality*.

Strongest RR-type result — `RiemannRoch/ChiLedger.lean:109`:
```lean
theorem chi_divisorSheaf (D : X.CurveDivisor) :
    Sheaf.chi (X.divisorSheaf K D) = Sheaf.chi (X.moduleKSheaf K) + CurveDivisor.deg K D
```
Same binders as `classDeg`. This is an **equality**, for every Weil divisor, unconditionally. Proved by dévissage induction (`chi_step`, `CurveDivisor.induction_devissage`).

Curve form — `RiemannRoch/ChiCurve.lean:161`, `chi_divisorSheaf_curve : chi (divisorSheaf k D) = 1 - genus C + deg k D`, binders `[IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]` with the four instances installed in `letI`/`haveI` inside the statement.

Inequalities: `riemann_inequality` (`ChiLedger.lean:137`) `deg D + χ(𝒪_X) ≤ h⁰(𝒪(D))`; `riemann_inequality_curve` (`ChiCurve.lean:183`) `deg D + 1 - genus C ≤ h⁰(𝒪(D))`.

χ, h⁰, h¹ are defined in `RiemannRoch/Chi.lean:81,86,92` on an arbitrary small site: `h0 F = finrank R (HModule F 0)`, `chi = h0 - h1`. `HModule F n := Abelian.Ext (constModuleSheaf J R) F n` (`Cohomology/ModuleKSheaf.lean:74`). `genus C := finrank k (HModule (C.left.moduleKSheaf k) 1)` (`Challenge.lean:89`).

`genus (P1.asOver k) = 0` is landed: `Curve/P1H1Vanishing.lean:187`, `P1.genus_asOver_eq_zero`, via `Subsingleton (HModule … 1)` from Laurent-difference surjectivity. And `Curve/P1Curve.lean:390` `curvePackage_asOver` certifies all three curve-package instances for P¹ by `inferInstance`.

## 3. Sections → divisors

**`Picard/SectionsToDivisors*.lean` is not the file you want** — it is about `BasicOpenCocycleDatum` and the DAT-1 *glued sheaf* over a test ring `B`, not about divisor sheaves. Its keystone `sectionLocalEquations_picClass` (`SectionsToDivisorsClass.lean:159`) says: a germ-regular global section of the glued sheaf cuts a `LocalEquations` datum whose `picClass` is `D.cechPicClass`. Binders include `{B : Type u} [CommRing B] [Algebra k B]`, `{π : C.left ⟶ P1 k} [IsAffineHom π]`, a `PointedCover 𝒲` with subordination `σ, hσ`, and germ-regularity `hreg`. Useful for the divisor-representability lane; **not on the RR path**.

The bricks that actually do "section ⟹ effective divisor of the same class":
- `RiemannRoch/SectionBound.lean:175` — `exists_effective_of_h0_pos (A) (hA : 0 < Sheaf.h0 (X.divisorSheaf K A)) : ∃ E, 0 ≤ E ∧ CurveDivisor.picClass K E = CurveDivisor.picClass K A`. `omit`s both finiteness instances.
- `RiemannRoch/FLVClass.lean:208` — `exists_effective_of_picClass (W) (hW : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (X.moduleKSheaf K)) : ∃ E, 0 ≤ E ∧ picClass K E = picClass K W`. Enters through `riemann_inequality`.

Both extract the section via `Sheaf.HModule.linearEquiv₀` → `divisorVal` → `Units.mk0` and return `W + div u`. Neither states `deg E`.

**The one that does** — `Picard/JacobianDataAbelEffective.lean:103`:
```lean
theorem exists_effective_deg_eq_of_classDeg_eq (g : ℕ)
    (hχ : Sheaf.chi (X.moduleKSheaf K) = 1 - (g : ℤ))
    (L : X.CechPic) (hL : classDeg K L = (g : ℤ)) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧ CurveDivisor.picClass K E = L ∧
      CurveDivisor.deg K E = (g : ℤ)
```
Same binder block as `classDeg`. **At `g = 0` this is exactly the RR half of your route**, and it takes the class as input — no `Z` reference divisor, no representative to name. The `Z`-taking sibling `exists_effective_deg_eq_of_classDeg_eq_zero` (:147) carries a retraction warning that a degree-`g` divisor need not exist; **that warning does not apply at `g = 0`**, because `Z = 0` works and in fact is not needed at all.

## 4. Divisor degree and the degree-0 collapse

`Scheme.CurveDivisor` — `RiemannRoch/Divisor.lean:40`: `def CurveDivisor (X : Scheme.{u}) [IsIntegral X] : Type u := {x : X // x ≠ genericPoint X} →₀ ℤ`. `AddCommGroup` and `PartialOrder` inherited from `Finsupp` (:47, :50); `Lattice` at `SectionSpaces.lean:60`.

`CurveDivisor.deg` — `Divisor.lean:61`, binders `(K : Type u) [CommRing K] [X.Over (Spec (CommRingCat.of K))]` (only `CommRing`, not `Field`):
```lean
noncomputable def deg (D : X.CurveDivisor) : ℤ :=
  D.sum fun x n => n * (X.residueDeg K x.1 : ℤ)
```
Residue-degree weighted. Lemmas: `deg_zero`, `deg_add`, `deg_single`, `deg_neg` (:65–84); `deg_nsmul'`, `deg_sub'`, `deg_nonneg`, `deg_mono`, `deg_inf_add_deg_sup` in `SectionSpaces.lean:97–133`.

**"Effective of degree 0 is zero" exists** — `RiemannRoch/SectionSpaces.lean:174`:
```lean
lemma Scheme.CurveDivisor.eq_zero_of_deg_le_zero {E : X.CurveDivisor} (hE : 0 ≤ E)
    (hdeg : CurveDivisor.deg K E ≤ 0) : E = 0
```
Binders `(K : Type u) [Field K] [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]` plus `{X} [IsIntegral X]`. It is `≤ 0`, which is stronger than what you need. Rests on `Scheme.residueDeg_pos` (`ResidueDegree.lean:154`) — the source of the `LocallyOfFiniteType` binder. Companion: `support_card_le_deg` (:145).

Divisor-class-to-`CechPic`: **two maps, proved equal**. `CurveDivisor.picClass` (`Picard/DivisorClassMeromorphic.lean:102`) is the anchored one, with `picClass_zero`, `picClass_add`, `picClass_divOf`, `picClass_eq_iff`, `picClass_single`, `exists_picClass_eq` (surjectivity), `exists_divOf_of_picClass_eq` (extraction). `Scheme.divisorClass` is the deg-D1 map; `divisorClass_eq_picClass` (`DivisorClassCompat.lean:145`) collapses them. Degree compatibility is `classDeg_picClass` / `classDeg_divisorClass` above. No `CurveDivisor.cechPicClass` or `toCechPic` exists (grepped `cechPicClass`, `toCechPic`, `divisorClass` — `cechPicClass` is only a `BasicOpenCocycleDatum` field).

## 5. Explicit degree-1 classes — yes, two families

- **`RiemannRoch/GraphDegree.lean:445`** — `classDeg_graphPicClass : classDeg K (Over.graphPicClass C t) = 1`. Binders: `{k : Type u} [Field k] (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] {K : Type u} [Field K] [Algebra k K] (t : overSpec k K ⟶ C)`. The class of the graph divisor of a `K`-point, on `(C ⊗ overSpec k K).left`. Proved via `presentationDivisor_graphLocalEquations` + `finrank_quotient_span_section`.
- `Picard/Pic0ChartRationalGraph.lean:127` — `classDeg_graphPicClass_base (L) (p : overSpec k k ⟶ C) : classDeg L (CechPic.map … (graphPicClass C p)) = 1`, the base-changed form.
- `Pic0ChartRationalGraph.lean:142` `isDivisorDegree_one_of_point` and `isDivisorDegree_nat_of_point` — a rational point makes every natural number a divisor degree.
- `RiemannRoch/WindowLedger.lean:125,133` — `one_le_windowδ : 1 ≤ windowδ π` and `deg_fiberWeilDivisor_windowδ : deg K (fiberWeilDivisor π) = windowδ π`, with `zero_lt_deg_fiberWeilDivisor` (`FLVClass.lean:179`). Degree `δ ≥ 1`, not necessarily `= 1`.

`thetaCechClass` degree: `RiemannRoch/ThetaDegree.lean` exists; I did not open it — the graph certificate already answers the question.

**No `classDeg` surjectivity theorem exists** (grepped `classDeg.*[Ss]urjective`, `Function.Surjective.*classDeg`). But surjectivity follows in two lines from any degree-1 class via `classDeg_mul` + `classDeg_inv` (I verified the coset shift compiles). At P¹ over any `k` a rational point exists, so a degree-1 class exists, so the hypothesis of the main theorem is a full nontrivial coset — **the theorem is not vacuous, and it is not vacuously true by `CechPic` being a subsingleton either**, since `classDeg` then hits `1 ≠ 0`.

## 6. THE CRITICAL QUESTION: no, the project has no "invertible sheaf of a `CechPic` class"

Precisely:

- Cohomology is taken of `Sheaf J (ModuleCat R)` objects. The two carriers available on a curve are `Scheme.moduleKSheaf K` (structure sheaf as `K`-modules) and `Scheme.divisorSheaf K D` (`RiemannRoch/DivisorSheaf.lean:326`, rational functions with poles bounded by the **Weil divisor** `D`), plus glued-sheaf carriers from cocycle data (`Cohomology/GluedSheaf*.lean`).
- **There is no function `X.CechPic → Sheaf …`.** No `classSheaf`, `sheafOfClass`, `cechPicSheaf`, `invertibleSheafOf`, `h0OfClass`, `h1OfClass` (all grepped; only hit is the paragraph in `ClassCohomology.lean:45` explaining why they were deliberately *not* built).
- What exists instead is **witness-independence**: `RiemannRoch/ClassCohomology.lean` proves `h0_divisorSheaf_eq_of_picClass_eq` (:89), `h1_divisorSheaf_eq_of_picClass_eq` (:98), `subsingleton_hModule_one_of_picClass_eq` (:111), and the two `Module.Finite` transports (:122, :131) — all keyed on `CurveDivisor.picClass K D = CurveDivisor.picClass K D'`, all built from one private iso `picClassDivisorSheafIso` (:75) out of `mulEquivDivisorSheaf`. Its docstring records the packaging decision explicitly: the choice-based package "would add a `Classical.choice`-of-witness indirection with no current consumer".

So there is no object to take cohomology of — **and the route does not need one.** `classDeg` is itself already defined by choosing a divisor representative, so the class-level statement reduces to the divisor level by `exists_picClass_eq` before any sheaf appears. The `Subsingleton (HModule … 1)` ↔ section-existence link you asked for: `Sheaf.chi_eq_h0` (`Chi.lean:115`) converts the vanishing into `χ = h⁰`, and `peel_effective` / `peel_single` (`FLVClass.lean:260–292`) transport it along effective twists. None of it is needed here — the Riemann *inequality* alone suffices at `g = 0`, because `h¹ ≥ 0` is the right direction.

## 7. What has to be built, and the verdict

| # | Item | Status |
|---|---|---|
| 1 | `classDeg L = 0 ⟹ ∃ E, 0 ≤ E ∧ picClass E = L ∧ deg E = 0` | **Exists.** `exists_effective_deg_eq_of_classDeg_eq` at `g = 0`, `JacobianDataAbelEffective.lean:103` |
| 2 | `0 ≤ E → deg E ≤ 0 → E = 0` | **Exists.** `eq_zero_of_deg_le_zero`, `SectionSpaces.lean:174` |
| 3 | `picClass 0 = 1` | **Exists.** `CurveDivisor.picClass_zero`, `DivisorClassMeromorphic.lean:141` |
| 4 | `χ(𝒪_C) = 1` at genus 0 | **Exists.** `chi_moduleKSheaf`, `ChiCurve.lean:148`, `+ hg` |
| 5 | `genus (P1.asOver k) = 0` | **Exists.** `P1H1Vanishing.lean:187` |
| 6 | P¹ curve-package instances | **Exist.** `P1Curve.lean:390` |
| 7 | The composition | **Nothing to build.** 5 lines, verified green, axiom-clean |
| 8 | Non-vacuity (a degree-1 class at P¹) | `classDeg_graphPicClass` (`GraphDegree.lean:445`) + a P¹ rational point. ~10 lines of instantiation, and **not needed for the theorem** — only to certify it says something |

**Verdict: the RR route is dramatically cheaper. It is done.** Not "cheaper by a factor"; the mathematics is already in the tree and the assembly compiles.

The two-chart route, by contrast, still owes real substrate. pic-g's claim I-1614 states it correctly and honestly: chart triviality is free (`Subsingleton (CommRing.Pic (Polynomial k))` is `inferInstance` in mathlib, plus `cechPicEquivPic` at `CechPicSurjective.lean:283`), and `twoChartClassHom_surjOn_of_chartTrivial` (`TwoChartRepresentable.lean:301`) then fires unconditionally, and `twoChartClass_injective` (`TwoChartCechPic.lean:449`) plus `twoChartClass_mk_range` (`TwoChartNormalize.lean:257`) give the bijection — **but the Laurent unit classification does not exist in mathlib** (pic-g measured this by loogle and by grepping `Mathlib/Algebra/Polynomial/Laurent.lean`; only `isUnit_T`). That is a genuine build. Then the quotient by the two chart-unit images has to be computed and matched to ℤ.

Two things worth flagging to whoever acts on this:

**The two routes prove different-strength statements, and RR's is stronger where it counts.** Two-chart gives `Pic(P¹_k) ≅ ℤ` — the group, with a generator. RR gives `classDeg` *injective* (verified above, 3 lines on top of the main theorem), for **every** genus-0 curve over every field, no charts and no rational point. pic-g's own claim says injectivity is what the objective needs: *"once the group is ℤ, ANY single class of nonzero degree makes `classDeg` injective — no generator degree needed."* RR reaches injectivity without ever computing the group, so the generator question is moot. The two-chart route reaches injectivity only after the Laurent classification lands.

**Two-chart is scoped to P¹; RR is not.** The RR statement holds at any bundle with `genus C = 0` — which is the shape the `hvan`/`pic0Subgroup` consumers want at fibre curves `relCurve C L`, where a two-chart cover is not handed to you. RR also needs no `sel`/`hmem`/`hsel` cover plumbing.

The honest limit, same for both: this is the **field**-point case. A general test ring needs fibrewise degree zero over an arbitrary `k`-algebra — cohomology-and-base-change — which neither route touches. pic-g flags this too.

If pic-g's lane is the one holding `p1-witness`, the useful message is that items 1–7 are closed and the Laurent work is optional for the *injectivity* objective, though still required for the group *computation*.
