I have enough evidence for a verdict. Here is the report.

## THE STRADDLING PROBE — verdict (C), narrowed to a single cheap measurement, with (B)'s escape route provably NOT available

### 1. `supportLocus` unfolded

`AlgebraicJacobian/Picard/SupportTube.lean:101,131,133`:
```lean
def unitLocus : X.Opens := ⨆ x, X.basicOpen (d.eqn x)
def supportLocus : Set X := (d.unitLocus : Set X)ᶜ
lemma isClosed_supportLocus : IsClosed d.supportLocus
```
So it is the **complement of a union over the whole point set** of the pointed cover — closed, cover-independent up to `DivEq` (`DivSchemeCertZarConfine.lean:110 DivEq.supportLocus_eq`), and germ-characterised by `mem_supportLocus_iff_not_isUnit_germ` (`SupportTube.lean:136`), which reads on **any** member containing the point. Per-member trace: `supportLocus ∩ cover.opens x = cover.opens x \ basicOpen (eqn x)` (`:143`).

### 2. Construction path for the universal `d`

`ThetaGeneratorSeed.localEquations` = `DivSchemeFamily.lean:349`, `cover := {opens := D.piece, mem_opens := D.mem_piece}` — a **pointed cover indexed by every point of `relCurve C R_Z`**, with `piece z = basicOpen (D.h z)` (`:93`) and crucially `piece_le z : D.piece z ≤ relPinnedChart C R π (D.side z)` (`:98`). The seed is `pointwiseGeneratorSeed = productCutter pointwiseBaseSeed …` (`DivSchemeSeedUnivPointwiseGenerator.lean:258`, `:199`), whose `side := pointwiseSide` = `(exists_mem_relPinnedChart z).choose` (`DivSchemeSeedUnivPointwise.lean:88`) — a **`Classical.choose` per point**, so `side` is not constant and not computable.

**Nothing in the tree states anything about this `d`'s total `supportLocus`.** I crossed every file mentioning `univSeed`/`pointwiseGeneratorSeed` against `supportLocus`: exactly one hit, `DivSchemeCertZarFibreAvoid.lean:355/408`, and both are **fibrewise** (`residueFibreLocalEquations … p`), giving `supportLocus.ncard ≤ g` per residue prime and a per-prime `GL₂`-twisted confinement. There is no total-space statement, no connectedness statement (`grep IsPreconnected` returns 12 hits, all *hypotheses*), no `Nonempty supportLocus`, and no `IsIrreducible … supportLocus` anywhere in the tree.

### 3. Applicability

**(b) is settled, and it kills the escape route.** `V₀ ⊔ V₁ = ⊤` (`RelativeTwoCover.lean:139 relCover_sup`), and `relPinnedChart` *is* `V₀`/`V₁` (`DivSchemeFamilySide.lean:115`). So `x ∉ V₀` and `y ∉ V₁` are **individually obtainable** — they just mean `x ∈ V₁ \ V₀`, `y ∈ V₀ \ V₁`. And the hoped-for `supportLocus_subset_chart_*` rescue does **not** exist: the only such lemmas are `DivSchemeCertZarConn.lean:149` and `DivSchemeCertZarC1.lean:131`, both of which take `IsPreconnected` as a **hypothesis and produce** the containment — they are the no-go's own machinery, not a counter to it. `AffPerPiece` mentions them only in prose (`:41`). `piece_le` confines each *piece* to one chart but says nothing about the support, since the pieces range over all points on both sides.

**(c) The §7.6 vacuity argument does NOT transfer to R_Z.** Its content is `supportLocus_finite_on_curve` (`DivSchemeCertZarFibreAvoid.lean:46`), whose hypotheses are `[Field K]`, `IsIntegral X`, `SmoothOfRelativeDimension 1 (X ↘ Spec K)`. R_Z = `PairChartRing ⧸ divCarveIdeal` (`DivSchemeFamilyUniv.lean:55`) is a finite-type `k`-algebra, and `relCurve C R_Z` is a curve *over Spec R_Z*, not over a field — none of those three instances hold, and the file's only R_Z-side use is at `p.asIdeal.ResidueField`. Finiteness of every *fibre* (≤ g points) is fully compatible with a connected horizontal total support sweeping `π⁻¹(0)` to `π⁻¹(∞)`; that is exactly the `V(tx²+xy+ty²)` model in `DivSchemeCertZarConn.lean`'s docstring.

### 4. VERDICT: (C), with the cheap measurement named

Not (B): I found no hypothesis that provably fails. Not (A): nothing establishes `IsPreconnected`. Both no-go hypotheses are **satisfiable in principle over R_Z** and **unmeasured for this `d`**. Two independent reasons the honest answer is (C) rather than "probably fine":

- Adversarially against dismissal: the no-go has a **connectivity-free** strengthening, `not_isCertified_of_not_isClosed_inter_chart₀` (`DivSchemeCertZarConfine.lean:202`), from `isClosed_supportLocus_inter_chart_of_isCertified` (`:191`). So even if `IsPreconnected` fails, U2 can still be false — the threat does not depend on the conjunct my search couldn't settle.
- Adversarially against panic: `side = Classical.choose` means the support could sit anywhere; `productCutter` shrinks pieces by an *arbitrary* chosen cutter, so `unitLocus` is a union over uncountably many chosen basic opens whose shape nothing pins down.

**Cheapest single measurement**, in this order: (i) is R_Z even nontrivial? I found **no** `Nontrivial (DivCarveChartRing …)`, no `divCarveIdeal ≠ ⊤`, and no nonemptiness of `divCarveLocus` in the tree — if R_Z = 0 then `relCurve C R_Z` is empty, `supportLocus = ∅`, `IsPreconnected` holds vacuously but `hx : x ∈ supportLocus` is **unobtainable**, and the no-go is vacuous while U2 is also vacuously reachable. That is a one-`#check`-scale question on `Ideal.Quotient` and it gates everything else. (ii) If R_Z ≠ 0: state `(univSeed …).localEquations hD |>.supportLocus = ∅` as a target and try `simp [Scheme.LocalEquations.supportLocus, ThetaGeneratorSeed.localEquations]` — the seed's cover contains `piece z ∋ z` for **every** `z`, so `unitLocus = ⨆_z basicOpen (eqn z)`, and if some `eqn z` were a unit near each point the support would be empty and `exists_isCertified_of_seed_of_supportLocus_empty` (`DivisorFamilyAffSeedEndpoint.lean:148`) already applies — but note that endpoint only yields `IsCertified 0`, not degree `g`, and the fibrewise degree is `g` (`DivSchemeSeedUnivPulledDegree.lean:370`), which for `g ≠ 0` **forbids** empty support. That tension is itself worth checking: it suggests support is nonempty for `g ≠ 0`, leaving only `IsPreconnected` unmeasured.

Files: `/home/axel/.../AlgebraicJacobian/Picard/SupportTube.lean`, `DivSchemeFamily.lean`, `DivSchemeSeedUnivPointwise.lean`, `DivSchemeSeedUnivPointwiseGenerator.lean`, `DivSchemeCertZarConn.lean`, `DivSchemeCertZarC1.lean`, `DivSchemeCertZarConfine.lean`, `DivSchemeCertZarFibreAvoid.lean`, `DivSchemeFamilyUniv.lean`, `DivRepChartClassUnivAny.lean`.
