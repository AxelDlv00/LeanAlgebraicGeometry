Survey complete. Cross-checking against the landed widening (I read `DivisorFamilyAffCover.lean` etc.) — your `AffCoverData` shape matches what my independent read said the certificate lane actually needs, and the migration lemma `FinCoverData.toAffCoverData` is exactly where the old (d)+(e)+(f) content gets confined.

## WHAT BREAKS UNDER WIDENING (independent read)

Needs (d) chart-wise cover `cover₀`/`cover₁`:
- `DivSchemeCertZarChartTrace.lean:80` `supportLocus_inter_chart₀_eq_iUnion` / `:91` `…_chart₁_…` — the root. `⊆` is `A.toFinCoverData.cover₀ hxV` (:85 / :96), `⊇` is `basicOpen_le (A.h₀ j)` (:88 / :99). Both directions die.
- `DivSchemeCertZarChartTrace.lean:106, 115, 129, 157, 167` — all downstream, also (f).
- `DivSchemeCertZarSwallow.lean:156` `subset_chart₀_or_disjoint_chart₀` / `:171` `…chart₁…`.
- `DivSchemeCertZarSep.lean:201` `supportLocus_disjoint_chart_inter_of_separated` (`cover₀ hz₀` / `cover₁ hz₁` at :208-209) and `:257` `not_exists_unique_support_piece`. This one is subtler than the others: the two chart covers are what make the two pieces containing `z` **distinct**. With a joint cover there is no reason a support point of `V₀ ⊓ V₁` sits in two different pieces, so `not_exists_unique_support_piece` is not merely unproved — it becomes false, and `isCertified_of_separated` (:277, which itself needs nothing) regains the one-swallowing-piece configuration. Your `ofSwallowingPiece` / `subsingleton_colength_of_ne_swallowing` in `AffSwallow.lean:123,140` is exactly that recovered configuration.
- `DivisorFamilyPullbackMap.lean:82` `exists_mem_pieces` — proof breaks, statement *is* the new `cover` field.
- Verdict chain, transitively: `DivSchemeCertZarConn.lean:149,173`; `DivSchemeCertZarC1.lean:131`; `DivSchemeCertZarVerdict.lean:62`; `DivSchemeCertZarConfine.lean:191,202,215`.

Needs (e) basic-open-ness:
- `DivSchemeCertZarSwallow.lean:164,179` — `(relCurve C R).basicOpen_le (A.h₀ j)`, i.e. `piece ≤ V₀`. Not a proof repair: "some piece swallows the support ⟹ support ⊆ V₀" is false for an untyped piece. This is the load-bearing use of (e) in the whole lane.
- `SupportTube.lean:226` `flat_sections_pieces` — localizes a *free* pinned-chart ring. Your `flat_sections_isAffineOpen` (AffCover.lean:122) via `instFlatRelCurveHom` is the right replacement and drops the freeness entirely.
- `DivisorFamilyPullbackMap.lean:105,122` `pieceTermBaseChange` / `_one_tmul` — `pieceTermBaseChangeAlg` (`DivisorFamilyPullback.lean:204-206`) is stated for `basicOpen h` of a chart and proved through `IsLocalization.Away`. Replacement already exists at the right generality: `Over.sectionsBaseChangeOfIsAffineOpen` (`Cohomology/SectionsBaseChange.lean:295`). Consumers `pulledEqn_mem_nonZeroDivisors` :165 and `germ_pullbackEqn_mem_nonZeroDivisors` :185. **Flag: I did not find an `AffCoverData` analogue of `pieceTermBaseChange` in the seven new files** — grep for `TermBaseChange|sectionsBaseChange|baseChange` across `DivisorFamilyAff*.lean` returns nothing. If the widened lane needs base change of a piece section ring along `R → R'` (it does, for `pulledEqn` regularity and hence for `IsLocallyCertified`'s pullback clause), that port is still open.
- `DivSchemeCertZarChartPair.lean:76,87,94,116,130` — `chartPairCoverData` needs `basicOpen_one`; post-widening it gets *simpler* (feed V₀/V₁ directly as affine opens).

Needs (f) `Sum` index: `ChartTrace.lean:82,93,107,116,142-144`; `Confine.lean:196,198`; `Sep.lean:210-211,221`; `Swallow.lean:162,168,177,183`; `ChartPair.lean:87-106`; `PullbackMap.lean:82,97,105,122`; `SupportTube.lean:226`. Note `thetaOvlUnit` (`DivisorFamilyTheta.lean:149`, four-case `Sum` match) is (f)-critical but **no `DivSchemeCertZar*` file mentions it** — the theta layer is cleanly separated from the certificate layer, consistent with your `ChartTyping` being carried apart.

Untouched, needs no repair: all of `Pointwise.lean`, `Seed.lean`, `KerSpan.lean`, `Transport.lean`, `FibreAvoid.lean`; `Sep.lean` except :201/:257; `Conn.lean:98,128`; `C1.lean:75,105,123`; `Swallow.lean:83,100,115,134`; `ChartPair.lean:154,170,187` (deliberately stated against the *shape* `pieces j = V₀ ∨ V₁`, so they survive verbatim); all `SupportTubeFinite.lean` adaptation corollaries; `Confine.lean:84-167`.

## (2) Affine open containing a closed subset finite over R — DOES NOT EXIST

Nothing in AJCR, AJC, or mathlib. Searched by name (`exists_isAffineOpen*`, `IsAffineOpen`+`Finite`, `0B8B`, avoidance) and semantically via four Lean-Finder queries. Adjacent items, none sufficient:
- mathlib `exists_isAffineOpen_mem_and_subset` — one point, not a set.
- `AlgebraicJacobian.GaloisDescent.exists_basicOpen_le_of_finite` — **AJC only**, `Picard/StableAffineCover.lean`. Given `hU : IsAffineOpen U`, finitely many points all in `U` and all in `V`, produces `s : Γ(X,U)` with every `y i ∈ basicOpen s` and `basicOpen s ≤ V`. Needs the finite set already inside one affine open; does not create it. Not ported to AJCR — worth a cross-project note on I-0495 if the widened lane ever wants it.
- mathlib `Scheme.IsQuasiAffine.isBasis_basicOpen` / `IsQuasiAffine.of_forall_exists_mem_basicOpen` (`AlgebraicGeometry/QuasiAffine.lean`) — the only mathlib machinery pointing this way.
- `P1.exists_matrix_finite_subset_chartInter` (`Curve/P1Aut.lean:460`) — the R1 route, closed by I-0492.

Consequence for the landed R2: since no such lemma exists, existence of a swallowing affine open cannot be *derived*; it has to be data or a hypothesis. That is what `ofSwallowingPiece (W) (hW : IsAffineOpen W)` (`AffSwallow.lean:140`) and `SwallowedBy` (:75) do, and it looks like the right call. The useful residue of `FibreAvoid.lean` for whoever eventually builds the avoidance lemma is `supportLocus_finite_on_curve` (:46), `supportLocus_ncard_le_deg` (:153), `fibre_supportLocus_finite_of_forall_self` (:247) — a finite support fibre, certificate-free, which is exactly its input.

## (3) `isAffineOpen_pieces` survives

Currently proved from basic-open-ness: `DivisorFamilyPullbackMap.lean:97-100`, `cases j; (relCover_isAffineOpen₀ C R (fiberTwoCover π)).basicOpen _`. It survives an arbitrary-affine-open field trivially, as a projection — which is exactly what you landed (`AffCover.lean:172`, `isAffineOpen_pieces j := D.isAffineOpen j`). No consumer notices: `C1.lean:110`, `SupportTubeFinite.lean:291`, `PullbackMap.lean:209`, `DivSchemeMonoBridge.lean:303,317`, `CertOverlapFinite.lean:185` all take it as an opaque `IsAffineOpen`. The genuinely basic-open-dependent siblings are `flat_sections_pieces` and `pieceTermBaseChange`, not this one.

One thing I could not verify: I did not run a build (read-only task), so the above is a source-level read against the pre-widening files plus a skim of the seven new ones.
