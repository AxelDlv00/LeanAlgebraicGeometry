Reconnaissance complete. Read-only; nothing edited.

## Answer to the question

**Yes — but not in the AJC adelic development. The usable route is in the sibling project AJCR, where the closed χ-ledger `χ(𝒪(D)) = χ(𝒪_X) + deg D` and its curve form `χ(𝒪(D)) = 1 − g + deg D` are landed, unconditional on the curve, and machine-verified axiom-clean.** The AJC adelic lane, by contrast, has no usable route: its ledger is a hypothesis a caller must supply, and the lane's own files prove that hypothesis is **false** on any genuine two-chart cover with chart-level finiteness.

---

## A. The usable route (AJCR — `MainProjects/Algebraic-Jacobian-Challenge-Rebuild`)

### A1. `chi_divisorSheaf_curve` — Riemann–Roch-lite on the curve. THE ONE TO USE.
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ChiCurve.lean:161`

```lean
theorem chi_divisorSheaf_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Sheaf.chi (C.left.divisorSheaf k D) = 1 - genus C + CurveDivisor.deg k D
```
- **Proof complete, no `sorry`.** `lean_verify` on this declaration: axioms `propext, Classical.choice, Quot.sound` only.
- **Explicit arguments a caller must discharge: exactly ONE — the divisor `D : C.left.CurveDivisor`.** Everything else is instance-implicit (`[IsProper]`, `[SmoothOfRelativeDimension 1]`, `[GeometricallyIrreducible]` on `C.hom` — the standard curve pack) or discharged inside the proof (`QuasiCompact`, and both `Module.Finite k (HModule (moduleKSheaf k) i)` finiteness instances, which come from `moduleFinite_hModule_zero` / `moduleFinite_hModule_one`). **No ledger hypothesis, no peel datum, no cover, no approximation input, no rational point, no algebraically-closed base.**
- `genus C` here is `Challenge.lean:89` = `finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)` — AJCR's own genus, defined identically in shape to AJC's `AlgebraicJacobian/Genus.lean:41` but on `moduleKSheaf`, not `toModuleKSheaf`.

### A2. The abstract engine behind it
`.../AlgebraicJacobian/RiemannRoch/ChiLedger.lean:109`
```lean
theorem chi_divisorSheaf (D : X.CurveDivisor) :
    Sheaf.chi (X.divisorSheaf K D) =
      Sheaf.chi (X.moduleKSheaf K) + CurveDivisor.deg K D
```
Verified sorry-free (axioms as above). Section variables at `ChiLedger.lean:65-69`: `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (.of K))] [IsIntegral X] [QuasiCompact (X ↘ Spec (.of K))] [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)] [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]`. Explicit args: `K` and `D` only; all conditions are instances, and the two finiteness ones are the "conditional" part — discharged on the curve in A1. Keystone step at `ChiLedger.lean:76` (`chi_step`, dévissage `0 → 𝒪(D−x) → 𝒪(D) → sky_x J → 0`), base case `𝒪(0) ≅ 𝒪_X`.

### A3. Companions, all sorry-free
| decl | path:line | explicit args |
|---|---|---|
| `deg_divOf` (principal ⇒ deg 0) | `RiemannRoch/ChiLedger.lean:126` | `K`, `g : X.functionFieldˣ` |
| `riemann_inequality` (`deg D + χ(𝒪_X) ≤ h⁰`) | `RiemannRoch/ChiLedger.lean:137` | `K`, `D` |
| `riemann_inequality_curve` (`deg D + 1 − g ≤ h⁰`) | `RiemannRoch/ChiCurve.lean:183` | `C`, `D` |
| `chi_moduleKSheaf` (`χ(𝒪_C) = 1 − g`) | `RiemannRoch/ChiCurve.lean:148` | `C` |
| `h0_moduleKSheaf` (`h⁰(𝒪_C) = 1`) | `RiemannRoch/ChiCurve.lean:135` | `C` |
| `classDeg : Additive X.CechPic →+ ℤ` | `RiemannRoch/Degree.lean:150` | `K` |
| `chi_divisorSheaf_classDeg` (**`χ(L) = χ(𝒪_X) + deg L` on a Picard class**) | `RiemannRoch/Degree.lean:185` | `K`, `D` |
| `chi_divisorSheaf_classDeg_curve` (**`χ(L) = 1 − g + deg L`**) | `RiemannRoch/Degree.lean:216` | `C`, `D` — verified axiom-clean |
| `h0_gluedSheaf_eq_classDeg_add_chi` (Kleiman `rank = d + 1 − g`) | `RiemannRoch/W6Full.lean:114` | `P : MeromorphicPresentation`, `hsub : Subsingleton (HModule (P.gluedSheaf K) 1)` |

Definitions: `Sheaf.chi = h0 − h1` at `RiemannRoch/Chi.lean:92` (site-generic, `Ext`-based `HModule`); `CurveDivisor.deg K D = Σ D(x)·[κ(x):K]` at `RiemannRoch/Divisor.lean:61`; `divisorSheaf` at `RiemannRoch/DivisorSheaf.lean:326`.

**Import-closure hygiene:** `ChiLedger`'s transitive AJC closure (22 modules) is entirely sorry-free. `ChiCurve`/`Degree` pull in `Challenge.lean`, whose 15 `sorry`s are the protected statement-file Jacobian targets — none is used by these proofs, as the axiom check confirms.

### A4. The scheme-theoretic bridge in AJCR — partial, and worth knowing
`deg`/`χ` are on `CurveDivisor` and `divisorSheaf` (a `Sheaf (Opens.grothendieckTopology X) (ModuleCat k)`), not directly on a `SheafOfModules`/invertible sheaf. The bridge that exists:
- `CurveDivisor.picClass : X.CurveDivisor → X.CechPic` (`Picard/DivisorClassMeromorphic.lean:102`), **surjective** (`exists_picClass_eq`, `:118`) with fibres the principal divisors (`exists_divOf_of_picClass_eq`, `:130`) — all sorry-free. So every Čech Picard class has a divisor, and `classDeg` is well defined on classes.
- `MeromorphicPresentation.gluedDivisorSheafIso` (`RiemannRoch/GluedDivisorSheaf.lean:467`, sorry-free): the cocycle-**glued** sheaf of a presentation ≅ `𝒪(presentationDivisor P)`. This is the closest thing to "line bundle given by a cocycle = divisor sheaf".
- What is **absent**: no declaration takes an `AlgebraicGeometry.SheafOfModules`/`X.Modules` object with an invertibility predicate and produces its degree or χ. The route to a line bundle goes through a Čech cocycle (`CechPic`) or a meromorphic presentation, not through `SheafOfModules`. `X.Modules` barely appears in AJCR at all.

---

## B. The AJC adelic development — no usable route (clear negative)

### B1. The adelic χ and degree
- `Adelic.chi` — `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean:956`: `noncomputable def chi (D : X.WeilDivisor) : ℤ := (ell k D : ℤ) - h1dim k U₀ U₁ D`. It is **cover-relative** (`U₀ U₁ : X.Opens` are parameters), with `ell` at `:950`, `h1dim` at `:953`.
- `Adelic.degK` — `Adelic/SectionBounds.lean:114` (weighted `Σ D(P)·[κ(P):k]`, hom at `:109`); geometric `Scheme.WeilDivisor.degree` at `RiemannRoch/WeilDivisor.lean:973`.
- `residueDeg` at `Adelic/ChiLedger.lean:638`.

### B2. Every route to `χ(D) = χ(0) + deg D` is a hypothesis, and the hypothesis is refuted
The lane has three layered conditional forms, all with **complete proofs** (only `WeilDivisor.lean:1194` carries a real `sorry` in the whole of `RiemannRoch/`):

1. `Adelic.chi_add` (`Adelic/ChiLedger.lean:988`) — χ-additivity. A caller must supply, as **explicit arguments**: `hDD'` (monotonicity), and the four-term ledger sequence as raw data — `window`, `connect`, `twist` (three `LinearMap`s the lane never constructs) plus `hwin`, `hexactB`, `hexactC`, `htwist`. Plus four `Module.Finite` instances.
2. `chi_add_eq_residueDeg` (`Adelic/ChiLedger.lean:1055`) — the one-point equality. Same seven ledger args **plus** `hPV : P.point ∈ U₀ ⊓ U₁` and a strong-approximation surjectivity `hsurj`.
3. `LedgerClosure.chi_eq_of_bump` (`Adelic/LedgerClosure.lean:224`) — the closed ledger from one explicit argument `hbump : ∀ (P) (E), chi k U₀ U₁ (pointDivisor P + E) = chi k U₀ U₁ E + residueDeg k P`. Then everything downstream (`SectionBounds.degK_add_chi_zero_le_ell:381`, `degK_principal_eq_zero:441`, `degK_eq_of_linearEquivalence:453`, `BoundedVanishing.*`, `GlobalGeneration.*`) takes as an explicit argument `hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D`.

**The lane refutes both `hbump` and `hledger` in Lean, unconditionally:**
- `Adelic.not_bump_of_notMem_left` — `Adelic/ChiUnconditional.lean:398`
- `Adelic.ledger_refuted_of_notMem_left` — `Adelic/ChiUnconditional.lean:559`:
```lean
theorem ledger_refuted_of_notMem_left (hcov : U₀ ⊔ U₁ = ⊤)
    {P : X.PrimeDivisor} (hP : P.point ∉ U₀)
    [∀ D : X.WeilDivisor, Module.Finite k (sectionSub k U₀ D)]
    [∀ D : X.WeilDivisor, Module.Finite k (sectionSub k U₁ D)]
    [∀ D : X.WeilDivisor, Module.Finite k (sectionSub k (U₀ ⊓ U₁) D)]
    [Module.Finite k (localStepTgt k P 1)] :
    ¬ (∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
```
Mechanism (`chi_le_finrank_chart_along_tower:317`): along `n·P` two of three Čech terms freeze and the third is trapped, so χ is bounded while `deg_k` grows. So on a genuine cover with chart-finiteness and a prime off a chart, `hledger` is unsatisfiable and every `hledger`-taking theorem in the lane is vacuous. The file's own header says so; the roadmap line at `roadmap.md:190` (the "Weil-divisor rider", ×1) is the residual leaf.

There are no `structure`/`class` hypothesis packages for the ledger or the peel — they are bare `∀`-propositions passed as explicit arguments. `Peel` (`Adelic/BoundedVanishing.lean:207`) is a `def … : Prop`, not a structure; the gate classes that do exist are `Adelic.IsConstantField` (`ChiLedger.lean:473`, discharged for curves by `GateInstances.lean:131`), `HasDedekindChart` (`Substrate.lean:300`), `HasFiniteMapToP1` (`P1BaseCase.lean:164`), `P1HasLaurentChartData` (`FinitenessP1.lean:731`).

### B3. What AJC does have unconditionally
- `AffineCoverMVSquare.chi_unit_eq_one_sub_genus` — `RiemannRoch/CohomologyKit.lean:532`: `S.chi C (SheafOfModules.unit …) = 1 - (genus C : ℤ)`. Sorry-free, explicit arg `S` (a 2-affine cover) only. **But this is only `χ(𝒪_C)`.** `CohomologyKit.lean` mentions no divisor and no degree; there is no `χ(L)` for a nontrivial `L` and no `deg` anywhere in it.
- `Adelic.chi_eq_charts_sub_overlap` (`ChiUnconditional.lean:140`) — the gate-free inclusion–exclusion χ formula. Real, but it computes χ from chart dimensions; it does not relate χ to `deg`.
- `Adelic.riemann_inequality` (`ChiLedger.lean:1094`) — takes explicit `htel : chi k U₀ U₁ D = chi k U₀ U₁ 0 + degD`, i.e. the ledger at `D` handed in.

### B4. Scheme-theoretic bridge in AJC: **none**
The adelic lane is purely valuation-theoretic — `AddSubgroup X.functionField` / `Submodule k X.functionField` cut out by `order P` conditions (`sectionSub`, `Adelic/ChiLedger.lean:487`). There is no declaration anywhere in AJC connecting `Adelic.chi`/`Adelic.ell`/`degK` to `AffineCoverMVSquare.chi`, to `Scheme.HModule`, to a `SheafOfModules`, or to `Picard/`'s `IsInvertible` (`Picard/TensorObjSubstrate.lean:119`). Grep for cross-references returns nothing; `CohomologyKit.lean` is imported by exactly one module (`Picard/RigidPushforwardP1Engine.lean`) and not for χ. AJC has no `divisorSheaf` at all — `Adelic/BoundedVanishing.lean:92` states this in-tree ("neither the FLV machinery nor `divisorSheaf` exists in AJC").

---

## C. Bottom line for a caller

If you want `deg L = χ(L) − χ(𝒪_C)` for a curve `C : Over (Spec (.of k))`:
- **Use AJCR `chi_divisorSheaf_classDeg_curve` (`RiemannRoch/Degree.lean:216`) or `chi_divisorSheaf_curve` (`RiemannRoch/ChiCurve.lean:161`).** Cost: supply a `CurveDivisor` (or a `CechPic` class, then `exists_picClass_eq` gives you the divisor). Nothing else.
- **Do not route through AJC's adelic lane.** Its RR statements are conditional on a hypothesis its own `ChiUnconditional.lean` refutes on genuine covers, and there is no bridge from a scheme-theoretic invertible sheaf into the adelic setup.
- Caveat if you need an actual `SheafOfModules`-level invertible sheaf on both sides: neither project has that bridge. AJCR gets as far as cocycle-presented line bundles (`gluedDivisorSheafIso`, `RiemannRoch/GluedDivisorSheaf.lean:467`); `SheafOfModules`-flavoured invertibility is untouched by the χ/degree machinery in either tree.
