Investigation complete. Here is the chain.

## 1. `divFunctor` verbatim

`AlgebraicJacobian/Picard/DivisorFamilyZarFunctor.lean:45`

```lean
noncomputable def divFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u where
  obj T := divFamZar C π n T.unop
  map g := ↾divFamZar.map C π n g.unop
```
Ambient binders (file lines 38-39): `{k : Type u} [Field k] (C : Over (Spec (.of k))) (π : C.left ⟶ P1 k) [IsAffineHom π] (n : ℕ)`.

A **section** at test `T` (`DivisorFamilyZarVehicle.lean:187`) is a compatible family over the affine opens of `T.left`:
```lean
def divFamZar (T : Over (Spec (.of k))) : Type u :=
  {s : Π U : T.left.affineOpens, DivFamZar C Γ(T.left, U.1) π n //
    ∀ (U V : T.left.affineOpens) (h : U.1 ≤ V.1),
      DivFamZar.mapAlgHom (Over.resAlgHom T h) (s V) = s U}
```
and `DivFamZar C R π n` (`DivisorFamilyZar.lean:235`) is `Quotient (divFamZarSetoid …)` on `{d : (relCurve C R).LocalEquations // IsLocallyCertified C R π n d}` modulo `DivEq`. `IsLocallyCertified` (`:71`) = ∃ span-⊤ family `g : Fin m → R` with a `CertifiedDivisorFamily C (Localization.Away (g i)) π n` divisor-equal to the pullback on each piece.

## 2. Every producer of `(divFunctor _ _ _).RepresentableBy _`

Exactly **five**, all in a single linear chain, all with the same ambient instance block (`[IsFinite pi]`, `[SmoothOfRelativeDimension 1 …]`, `[IsIntegral C.left]`, `[LocallyOfFiniteType …]`, `[QuasiCompact …]`, `[IsDominant pi]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`, `[Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0/1)]`) plus explicit `(hpi) (g) (hO) (hchi) (r1 r2) (b1 b2)`, and target `DivOver := divSchemeOver k (windowS_choice … • fiberWeilDivisor pi) (windowM_choice … • fiberWeilDivisor pi) g r1 r2 b1 (b2.map (windowShiftEquiv hpi g).symm)`. **Note the index is pinned to `g` — the ledger genus — in every one; no producer exists at any other `n`.**

| # | file:line | signature (the non-ambient hypothesis) |
|---|---|---|
| P1 | `DivRepKit.lean:113` | `DivRepGlobalData.representableBy (D : DivRepGlobalData hpi g r1 r2 b1 b2) : (divFunctor C pi g).RepresentableBy DivOver` |
| P2 | `DivRepGlobalClassify.lean:306` | `DivRepAffinePullback.representableBy (D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2) : …` |
| P3 | `DivRepAffPullClause.lean:482` | `divFunctor_representableBy_of_chartClause (U : ∀ i j, DivFamZar C (ChartRing i j) pi g) (hU : DivRepChartFamily.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U) : …` |
| P4 | `DivRepAffPullClause.lean:502` | `divFunctor_representableBy_of_id (U : ∀ i j, DivFamZar C (ChartRing i j) pi g) (hid : ∀ i j, IsDivRepClassify hpi g r1 r2 b1 b2 (U i j) (ChartMap i j)) : …` |
| P5 | `DivRepChartRange.lean:220` | `divFunctor_representableBy_of_chartRange (hrange : ∀ i j, ∃ F : DivFamZar C (ChartRing i j) pi g, (divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 (ChartRing i j) F).left = ChartMap i j) : …` |

`DivRepGlobalData` (`DivRepKit.lean:68`) is a 5-field structure (`pull`, `classify`, `classify_pull`, `pull_classify`, `pull_comp`); `DivRepAffinePullback` (`DivRepAffKit.lean:175`) is a 4-field one (`pull`, `pull_classify`, `isDivRepClassify_pull`, `pull_naturality`), reduced to 3 by `ofPull` (`DivRepAffPullbackReduce.lean:140`). There is **no** `DivRepAffineData`. No producer of `divFunctorAff` (the widened R2 functor) representability exists — `DivRepGlobalAffLift.lean:36-39` states explicitly it does not claim one.

## 3. Sorry-freeness and the chain

Chain: `rep` ⟸ P5 ⟸ P3 ⟸ (`divRepAffinePullback_ofChartClause`, `:461`) ⟸ P2 ⟸ `toGlobalData` (`:288`) ⟸ P1. All sorry-free; kernel-verified with `lean_verify`: `divFunctor_representableBy_of_chartRange` and `divFunctor_representableBy_of_id` both report axioms `[propext, Classical.choice, Quot.sound]` — **no `sorryAx`**. All chain files (`DivRepChartRange`, `DivRepAffPullClause`, `DivRepGlobalClassify`, `DivRepGlobalLift`→`DivRepKit`) are rooted in `AlgebraicJacobian.lean`.

So the chain bottoms out at exactly one open obligation, in three interchangeable spellings (P5's `hrange` ⟺ P3's `IsChartClause` ⟺ P4's `hid`, the ⟺ being `isChartClause_iff_forall_classify_eq`, `DivRepChartRange.lean:183`, and `IsChartClause.of_id`, `:156`):

> for each pair chart `(i,j)` in `(glueData k g r1).J × (glueData k g r2).J`, produce a `DivFamZar C (DivCarveChartRing … i j) pi g` whose backward classifier is that chart's own map to `DivScheme`.

**Is it inhabitable? No witness exists anywhere in the project.** `DivRepChartRange.lean:222` is the *only* occurrence in the tree of `∃ F : DivFamZar C (ChartRing i j) pi g` and it is a hypothesis binder, not a conclusion. No declaration concludes `IsChartClause` (grep: every hit is a binder or a docstring). No declaration concludes `IsDivRepClassify … (U i j) (ChartMap i j)`. No `DivRepGlobalData` or `DivRepAffinePullback` term is ever constructed except from the hypothesis-bearing constructors above. And no consumer downstream ever calls any of P1–P5 — `Pic0AtlasFromDivRep.abelSigmaChart` (`:205`) and `mixedParamRepresentableBy` (`Pic0ChartAtlasParamFree.lean:125`) take `rep` as a binder, so the whole `rep` lane is currently an unused hypothesis.

## 4. U2 (`…divrep.u2`) in the Lean sources

U2's residue is the **class half**, and it is a hypothesis binder, never a `sorry`. Three files carry the ε half plus increasingly weak class demands, all sorry-free, all rooted:

- `DivRepChartClassUniv.lean:166` — `divFamEps_highWindow_eq_universal_pair (hb : 0 < windowBound pi hpi) (hc : ((univSeed …).divisorAdaptation (isGenerator_univSeed …)).IsCertified g) : divFamEps hpi g (DivFam.mk ((univSeed …).certifiedFamily g … hc)) = ((divUniversalFstWindow …).toSubmodule, (divUniversalSndWindow …).toSubmodule)`. Verified: axioms `[propext, Classical.choice, Quot.sound]`. Companion `divFamZarUniv` (`:213`) builds the class from the same `hc`.
- `DivRepChartClassUnivFree.lean:139/175/186` — same with `hb` replaced by `hg : g ≠ 0`.
- `DivRepChartClassUnivAny.lean:232` — `exists_divFamZar_divFamEps_eq_universal_pair_of_hasCertifiedAdaptation (hg : g ≠ 0) (hca : (univSeed …).HasCertifiedAdaptation g (isGenerator_univSeed …))`, i.e. `∃ A : DivisorAdaptation C R π (D.localEquations hD), A.IsCertified n` (`:155`). Its own docstring records that this hypothesis is **refuted** by `forall_not_isCertified_of_straddling` (`DivisorFamilyAffStrict.lean:127`: `∀ (A : DivisorAdaptation C R pi d) (n : ℕ), ¬ A.IsCertified n` for connected `d` meeting both pinned fibres) whenever the universal seed straddles — unmeasured either way.
- `DivRepChartClassUnivQuot.lean:319` — `divFamEps_eq_of_le` discharges the ε half **unconditionally**: the two window-quotient facts are landed on every `DivFam` (`DivSchemeFrameCover.lean`), so only the two containments remain, both landed. Sorry-free.

Two `sorry`-token hits in `DivRepChartClassUnivQuot.lean` (`:89`, `:292`) and one in `DivRepGlobalAffLift.lean:31` are docstring prose about sorry censuses, not tactics. The only real `sorry`s near the lane are `Pic0ThetaCocycle.lean:246/320` (unrooted) and `Challenge.lean` (the top-level statement file).

**Critical gap: nothing connects the U2 files to the `rep` chain.** `divFamZarUniv` / `divFamZarUnivOfNeZero` / `divFamZarUnivOfHasCertifiedAdaptation` / `exists_certifiedFamily_divFamEps_eq_universal_pair` have **zero consumers outside their defining files** (grepped). The consumer side wants `IsDivRepClassify (U i j) (ChartMap i j)`; the producer side delivers `divFamEps … = (universal pair)`. No declaration in the tree mentions both `divUniversal*` and `IsDivRepClassify` in a statement — `DivRepChartClassUniv.lean` mentions `IsDivRepClassify` only in a docstring (`:194`) asserting the shapes match. That bridge is unwritten.

## Verdict

**No sorry-free witness for `(divFunctor C π n).RepresentableBy D` exists, for any `n` and any curve `C`.** All five producers are sorry-free reductions and nothing more; each still takes an inhabitant of the same undischarged obligation, which no declaration anywhere in the tree concludes. Three further facts sharpen this:

1. The lane reaches only `n = g` (every producer's `DivOver` and `divFunctor` index is the ledger `g`), so `mixedParamRepresentableBy`'s per-index `rep i` at `nn i ≠ g` has no route at all.
2. The `b1`/`b2` basis binders are inhabitable (`moduleFinite_divisorSections_top`, `SectionSpaces.lean:396`), and `hb`/`hg` are discharged; the ε half is discharged outright by `DivRepChartClassUnivQuot.divFamEps_eq_of_le`. The residue is purely the **class over the chart ring**.
3. That class's strongest landed reduction (`HasCertifiedAdaptation`) is standing-refuted on straddling seeds by `forall_not_isCertified_of_straddling`, and whether `(univSeed …).localEquations` straddles is measured nowhere. So the remaining obligation is not merely open — it may be false in the chart-typed carrier, and no bridge from the widened R2 carrier (`AffAdaptation.IsCertified`, which *is* inhabited by `exists_isCertified_of_seed_of_swallowing_affineOpen`) back to `DivisorAdaptation.IsCertified` exists; `DivisorFamilyAffCompare.isCertified_toAff` runs the wrong way.
