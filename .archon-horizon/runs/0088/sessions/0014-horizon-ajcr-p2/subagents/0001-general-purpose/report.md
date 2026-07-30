Confirmed identical variable blocks (same carrier `C`, `pi`, `hpi`, `g`, `hO`, `hchi`, `r1 r2 b1 b2`) across all 5 producer files — one uniform seam. Now compiling the final report.

## Census: producers of `(divFunctor _ _ _).RepresentableBy _`

**5 producers found**, all in namespace `AlgebraicGeometry`, all `noncomputable def` with identical `variable` block (same `k`, `C : Over (Spec (.of k))`, `pi : C.left ⟶ P1 k`, `g r1 r2 : ℕ`, `hO`, `hchi`, `hpi`, `b1 b2`). **Zero producers of `(divFunctorAff C n).RepresentableBy _`** — confirmed by grep for the conclusion shape (`:=`/`where` after the type) across the whole tree; only mentions are prose stating "zero producers" (`Pic0ChartHonestAff.lean:41,179`, `DivisorFamilyAffClassDegree.lean:91,391`, `Pic0AtlasFromDivRepAff.lean:34,44`, `DivisorFamilyAffFieldMono.lean:86`).

### Shared explicit hypotheses (all 5 producers, via the section `variable`s)

Ambient instances (not named `(h...)` binders, but required and worth flagging): `[Field k]`, `[IsFinite pi]`, `[SmoothOfRelativeDimension 1 (C.left ↘ Spec)]`, `[IsIntegral C.left]`, `[LocallyOfFiniteType (C.left ↘ Spec)]`, `[QuasiCompact (C.left ↘ Spec)]`, `[IsDominant pi]`, `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`, `[Module.Finite k H⁰]`, `[Module.Finite k H¹]`.

Named explicit hypotheses shared by all 5:
- `hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (.of k)` — demands a concrete finite dominant map to ℙ¹ compatible with the structure map.
- `hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1` — demands h⁰(𝒪_C) = 1.
- `hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g:ℤ)` — pins the Euler characteristic to genus `g`.
- `b1`, `b2` : explicit bases (window sections) — data, not really a mathematical obstruction, always constructible once the windows are finite-dimensional.

**Discharge status of these shared hypotheses** (verified at a concrete curve satisfying `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, i.e. every object this project's challenge-curve package supplies):
- `[IsFinite pi]`, `[IsDominant pi]`, `hpi` jointly discharged by `AlgebraicGeometry.exists_isFinite_isDominant_toP1` — `AlgebraicJacobian/Curve/MapToP1.lean:126`, sorry-free (0 sorries in file), built from `Curve/RationalToP1.lean` (0 sorries).
- `[Module.Finite k H¹]` discharged by instance `AlgebraicGeometry.moduleFinite_hModule_one` — `AlgebraicJacobian/Cohomology/Finiteness.lean:388`, sorry-free, itself built on `exists_isFinite_toP1` (same file, `Curve/MapToP1.lean:108`).
- `[Module.Finite k H⁰]` discharged by instance `AlgebraicGeometry.moduleFinite_hModule_zero` — `AlgebraicJacobian/RiemannRoch/ChiCurve.lean:122`, sorry-free.
- `hO` discharged by `AlgebraicGeometry.h0_moduleKSheaf` — `AlgebraicJacobian/RiemannRoch/ChiCurve.lean:135`, sorry-free (concludes `Sheaf.h0 (C.left.moduleKSheaf k) = 1` at exactly this instantiation, given `[IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]` — matches).
- `hchi` (for `g := genus C`) discharged by `AlgebraicGeometry.chi_moduleKSheaf` — `ChiCurve.lean:148`, sorry-free, same instantiation, concludes `Sheaf.chi (...) = 1 - genus C`. So `hchi` is free **only at `g = genus C`**, not at an arbitrary named `g`.
- `[SmoothOfRelativeDimension 1 (C.left ↘ Spec)]`, `[IsIntegral C.left]`, `[LocallyOfFiniteType (C.left ↘ Spec)]`, `[QuasiCompact (C.left ↘ Spec)]`: not separately audited in this pass beyond noting they are standard consequences of `IsProper`+`Smooth`+irreducibility elsewhere in the tree (e.g. `BaseChangeInstances.lean` derives analogous instances for base-changed bundles); **not independently verified as producer targets in this census** — flag as unverified for the un-base-changed `C.left` itself.

### Per-declaration report

**1. `AlgebraicJacobian/Picard/DivRepKit.lean:113`, `AlgebraicGeometry.DivRepGlobalData.representableBy`**
Extra explicit hypothesis beyond the shared block: `(D : DivRepGlobalData hpi g r1 r2 b1 b2)` — the four-field categorical package (pull, classify, two inverse laws, naturality) for `divFunctor` at *arbitrary* test objects `T`.
- Discharge: **NO producer of `DivRepGlobalData` exists anywhere in the tree** (grepped conclusion shape `: DivRepGlobalData ... :=`/`where` — zero hits besides the constructor's own use-site). One *conditional* producer exists: `AlgebraicGeometry.DivRepAffinePullback.toGlobalData` (`DivRepGlobalClassify.lean:288`), which itself requires `D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2` (see #2's hypothesis, same undischarged debt).
- Sorry-free: yes. File reachable: `DivRepKit.lean` is **NOT** imported by `AlgebraicJacobian.lean` directly by name, but the BFS import closure from the root (907 total closure incl. non-AJC files, 771 of 788 AJC `.lean` files reachable) shows it IS reachable transitively — confirmed programmatically.

**2. `AlgebraicJacobian/Picard/DivRepGlobalClassify.lean:306`, `AlgebraicGeometry.DivRepAffinePullback.representableBy`**
Extra hypothesis: `(D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)` — a 4-field affine-pullback package (`pull`, `pull_classify`, `isDivRepClassify_pull`, `pull_naturality`) over the same curve/genus data.
- Discharge: no unconditional producer of `DivRepAffinePullback` exists. Two *conditional* producers exist (see #3, #4 below): `divRepAffinePullback_ofChartClause` (needs `IsChartClause`) and `DivRepAffinePullback.ofPull` (needs `pull`+clause+naturality, `DivRepAffPullbackReduce.lean:140`, itself unconstructed).
- Sorry-free: yes. Reachable from root: yes (import chain via `DivRepGlobalLift.lean` ← ... ← root; confirmed in BFS).

**3. `AlgebraicJacobian/Picard/DivRepAffPullClause.lean:490`, `AlgebraicGeometry.divFunctor_representableBy_of_chartClause`**
Extra hypotheses:
- `U : ∀ i j, DivFamZar C (ChartRing i j) pi g` — a chart-indexed family of Zariski-locally-certified divisor classes (data, not really a prop, but nobody supplies a concrete `U`).
- `hU : DivRepChartFamily.IsChartClause (hpi:=hpi) g r1 r2 b1 b2 U` — the per-chart identity that each supplied chart class is classified by that chart's own map to `DivScheme` (this is "**U2**" of the worksheet).
- Discharge: **no producer of `IsChartClause` for a concrete `U` exists anywhere in the tree.** The one grep hit outside the defining files (`DivRepChartClassUniv.lean:67`) is a docstring stating explicitly: *"It produces no certificate, hence no `DivFamZar` over `R_Z` and no `IsChartClause` ... U2 remains unproved."* This is confirmed by the same file's own conditional theorem `exists_certifiedFamily_divFamEps_eq_universal_pair` (`DivRepChartClassUniv.lean:200`) which itself needs `hc : (...).IsCertified g` — traced further to `exists_isCertified_of_swallowing_affineOpen` (`DivisorFamilyAffStraddle.lean:247`), which needs three named hypotheses `hfib`, `hrank`, and a chosen affine open `W` with containment `hsub`/`hWle` — none of these are discharged unconditionally anywhere; per the file's own doc header, the discharge is gated on the "G-4 certificate" (`I-0565`), which is an open obligation.
- Sorry-free: file itself, yes (0 sorries). Reachable from root: yes.

**4. `AlgebraicJacobian/Picard/DivRepAffPullClause.lean:510`, `AlgebraicGeometry.divFunctor_representableBy_of_id`**
Extra hypotheses:
- `U` as above.
- `hid : ∀ i j, IsDivRepClassify hpi g r1 r2 b1 b2 (U i j) (ChartMap i j)` — U2 stated pointwise at the identity, equivalent by `IsChartClause.of_id` to #3's `hU`.
- Discharge: same as #3 — reduces to `IsChartClause`, undischarged. Not a genuinely separate route; it is a repackaging (`divFunctor_representableBy_of_id` just calls `divFunctor_representableBy_of_chartClause` after `IsChartClause.of_id`).
- Sorry-free/reachable: same as #3.

**5. `AlgebraicJacobian/Picard/DivRepChartRange.lean:220`, `AlgebraicGeometry.divFunctor_representableBy_of_chartRange`**
Extra hypothesis: `hrange : ∀ i j, ∃ F : DivFamZar C (ChartRing i j) pi g, (divRepClassifyZar ... F).left = ChartMap i j` — surjectivity of the affine classifier restricted to just the chart rings (weaker-looking than U2, but per the file's own docstring: *"Nothing here produces such a class; per roadmap `…divrep.u2` that is the G-4 obligation"* — i.e. it collapses to the same U2/certificate debt as #3, just phrased as an existential surjectivity statement instead of a supplied `U`).
- Discharge: no producer of `hrange` exists; same G-4/certificate root cause as #3.
- Sorry-free: yes. Reachable from root: yes.

### Answer to the crisp question

**No.** There is no producer of `(divFunctor C π n).RepresentableBy D` anywhere in the tree with every hypothesis discharged — not at any genus `g`, not at any curve `C`. All five producers funnel into exactly **one** ultimate undischarged obligation: a `DivRepAffinePullback` (or equivalently `DivRepGlobalData`), which in turn every concrete construction route reduces to **U2** — the per-chart ε-identity `IsChartClause`/`hid`/`hrange`, all three being restatements of the same fact. U2 itself reduces (per `DivRepChartClassUniv.lean`) to a single scalar-free obligation: existence of an `IsCertified g` witness for the universal seed at the chart ring — which the file's own docstring calls "the standing G-4 obligation," gated on `exists_isCertified_of_swallowing_affineOpen`'s three hypotheses `hfib`, `hrank`, and a choice of swallowing affine open `(W, hsub, hWle)` — none of which have an unconditional producer in the tree for the universal seed's concrete data.

All other named hypotheses on the seam (`hpi`, `hO`, `[Module.Finite k H⁰/H¹]`, and `hchi` at `g = genus C`) **are** freely discharged for any curve satisfying the project's standard challenge-curve package (`[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`) — cited above. So the seam has exactly one live antecedent left, not several independent ones.

**Routes ranked by residual undischarged debt** (all reduce to the same G-4 certificate, so "fewest" is a tie at 1 undischarged hypothesis each — U2/IsChartClause):
1. `divFunctor_representableBy_of_chartClause` / `_of_id` (`DivRepAffPullClause.lean:490,510`) — most direct, single hypothesis `IsChartClause`/`hid`.
2. `divFunctor_representableBy_of_chartRange` (`DivRepChartRange.lean:220`) — same debt, phrased as `hrange`.
3. `DivRepAffinePullback.representableBy` (`DivRepGlobalClassify.lean:306`) / `DivRepGlobalData.representableBy` (`DivRepKit.lean:113`) — require the full 4-field package, strictly more to supply than routes 1–2 even though the underlying mathematical debt (G-4 certificate) is identical.

Everything is sorry-free and reachable from the root aggregator (confirmed by BFS import closure from `AlgebraicJacobian.lean`: 771/788 `.lean` files under `AlgebraicJacobian/` reachable, 17 unreachable — listed above — none of which are on this seam's route). **Not independently verified in this pass**: the four "ambient" instance binders `[SmoothOfRelativeDimension 1 (C.left ↘ Spec)]`, `[IsIntegral C.left]`, `[LocallyOfFiniteType (C.left ↘ Spec)]`, `[QuasiCompact (C.left ↘ Spec)]` — plausible standard consequences but not traced to a specific producer declaration.
