# Spec G-D8 — the Abel element (degree lane, `AJCR.picard.degree`)

*Written 2026-07-16 (Fable prover-architect). Binding worksheet: `informal/deg-d5b-worksheet.md`
§4 (consumption map: G-D8 consumes SB-6's `degAff_unit`, the landed `graphPicClass` /
`pointEquations` + E-i, and reuses SB-3 for its degree-1 certificates). Consumer row:
`informal/w4-datum-worksheet.md` §1.4 — the frozen `ofCurve` (`Challenge.lean:125`) is
discharged as `rep.homEquiv.symm (abelElement P)`; `abelElement` itself gates on nothing
beyond this spec. DAT-4 (`Picard/DegreeSeam.lean`) is landed and is NOT duplicated; the
general-test unit seam below complements it.*

## The carrier (derived from Challenge.lean:125 + JacobianData §1.1)

`rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J`
gives `rep.homEquiv.symm : F.obj (op C) → (C ⟶ J)` with `F.obj (op C)` defeq to the
coercion of `CommGrpCat.of (pic0Subgroup C C)`, i.e. to **`pic0Subgroup C C`**.  Binding:

```lean
noncomputable def abelElement (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : pic0Subgroup C C
```

(the standing pack `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
[GeometricallyIrreducible C.hom]` throughout; `IsSeparated C.hom` by instance from
`IsProper`).  Any `forget₂ ⋙ forget` massage is owned by `Picard/JacobianData.lean` (w4
worksheet §1.1), not here.

## The definitional assembly (all landed vocabulary)

On the Čech level, on the test `T = C`, with `Over.graphPicClass` (`Curve/GraphDivisor.lean:245`):

```lean
abelCechClass P : (C ⊗ C).left.CechPic :=
  Over.graphPicClass C (𝟙 C) * (Over.graphPicClass C (toUnit C ≫ P))⁻¹
```

— the class of `Γ_{𝟙_C} = Δ` times the inverse of the class of the constant graph
`Γ_{toUnit C ≫ P} = P × C` (the recon's `[𝒪(Δ)]·[𝒪(fst⁻¹P)]⁻¹`, spelled uniformly through
the graph API so ONE degree certificate serves both factors).  The pic0 element is its
image under the landed unit of the étale sheafification (`Picard/PicEtUnit.lean`):

```lean
(abelElement P : picEt C C) = relPicToPicEt C C (relPicMk C C (abelCechClass P))
```

## The degree certificate (the heart)

Membership in `pic0Subgroup C C` = `degAt … t = 0` for every field point
`t : overSpec k K ⟶ C`.  Route, three new results:

1. **The unit seam at arbitrary tests** (complements the landed affine-test DAT-4):
   `degAt_relPicToPicEt : degAt (relPicToPicEt C T z) t = relPicDeg K (relPicMap C t z)`
   — by `picEtMap_relPicToPicEt` + `picEtAffineEquiv_relPicToPicEt` + `degAff_unit`.
   With `relPicMap_mk` + `relPicDeg_relPicMk` this collapses `degAt` of the Abel element
   at `t` to `classDeg K (CechPic.map (C ◁ t).left (abelCechClass P))`, and
   `graphLocalEquations_base_change` + `toUnit_unique` rewrite the fibre class as
   `graphPicClass C t * (graphPicClass C (toUnit (overSpec k K) ≫ P))⁻¹` — both factors
   graph classes of `K`-points.

2. **THE degree-1 certificate** (keystone of the campaign), `RiemannRoch/GraphDegree.lean`:

   ```lean
   theorem classDeg_graphPicClass (t : overSpec k K ⟶ C) :
       classDeg K (Over.graphPicClass C t) = 1
   ```

   Proof route (mirrors SB-5's `DegreeBaseFieldInvariance` fibre bookkeeping):
   * **(GF) graph fibre** (`Curve/GraphFibre.lean`): the graph square
     `IsPullback t.left (sectionOfPoint t).left (diagonal C).left q.left`
     (`q := lift (fst C T) (snd C T ≫ t)`, general test `T`) by paste-cancellation on the
     landed `Over.isPullback_left` squares (`IsPullback.paste_horiz/paste_vert/of_right/
     of_bot/of_vert_isIso`, all verified in mathlib); then
     `q.left.base ⁻¹' (Set.range (diagonal C).left.base) = {x_t}` via mathlib
     `AlgebraicGeometry.Scheme.Pullback.range_fst` (PullbackCarrier) and
     `Unique (PrimeSpectrum K)`, where `x_t := (sectionOfPoint t).left.base default` —
     the section point, the unique point of the graph.
   * **support**: for closed `z ≠ x_t`, `q z ∉ range Δ`, so the pulled equation is `1`
     (`diagonalEqn_of_notMem` + `map_one`) and the presentation coefficient vanishes;
     hence `presentationDivisor K (graphLocalEquations C t).presentation
     = CurveDivisor.single hx_t m` with `m = toAdd (ordZ (elem x_t))` (`ext_coeffAt`).
   * **multiplicity·residue = 1 in one shot, via SB-3**: on the affine chart
     `W := basicOpen (productChartSections (1 − eliftF))` (`eliftF` = the second-factor
     push of the frozen diagonal idempotent `data.elift p₀` along `c := t^♯`,
     `p₀ := t.left.base default`), the evaluation `ε := σ_t^♯ : Γ(X, W) → Γ(T.left, ⊤)`
     has `RingHom.ker ε = span {f_W}` (`f_W` = the transported point generator
     `u ⊗ 1 − 1 ⊗ c(u)`, which agrees with the pulled diagonal equation near `x_t` — the
     KEY overlap identity of `graph_pullback_regular`, re-derived section-level with
     `V = ⊤`), so `Γ(X, W) ⧸ (f_W) ≃ K` and
     `finrank_quotient_span_section` (ChartColength, SB-3b) reads
     `toAdd (ordZ_{x_t}) · residueDeg K x_t = 1`.  E-i (`classDeg_picClass`) +
     `deg_single'` close.
   * **the ideal input** (`Algebra/PointFiberIdeal.lean`, mirror of the landed B0
     `Algebra/DiagonalIdeal.lean` with second tensor factor `F` along `c : B →ₐ[k[X]] F`):
     (a′) `ker (B ⊗[k] F → B ⊗[k[X]] F) = span {pointGen}` (telescoping);
     (b′) `ker (ev₂ : B ⊗[k[X]] F → F) = span {e′}` for `e′` the push of the diagonal
     idempotent — by the section trick `mk ∘ includeRight ∘ ev₂ = mk`, all generators
     `x ⊗ 1 − 1 ⊗ c x` being pushes of diagonal-ideal elements (NO unramified base
     change, NO new Kähler theory);
     (c′) `ker (ev) · L = span {pointGen} · L` away from `1 − eliftF` (mirror of
     `ker_map_localization_eq`).  The chart-sections localization plugs in through the
     landed `isLocalization_away_basicOpen_productChartSections`.

3. **Membership + the pointing law** (`Picard/AbelElement.lean`):
   `abelElement P : pic0Subgroup C C` (certificate = 1 − 1 = 0), and
   `abelElement_map_point : (pic0Functor C).map P.op (abelElement P) = 1` — restriction
   along `P` makes both graph factors `graphPicClass C P` (`toUnit_unique` +
   `graphLocalEquations_base_change`), so the Čech class is already `1`.  This is the
   input the frozen `comp_ofCurve` (`Challenge.lean:130`) consumes once `rep` exists.

## Naturality / consumption notes (cheap now vs deferred)

* Cheap, stated here: the restriction description at ANY point `f : T ⟶ C`
  (`abelElement_map`, the Abel map's functor-point formula): the underlying picEt class of
  `(pic0Functor C).map f.op (abelElement P)` is
  `relPicToPicEt C T (relPicMk C T (graphPicClass C f * (graphPicClass C (toUnit T ≫ P))⁻¹))`
  — what Wave-6 (Albanese, `exists_unique_ofCurve_comp`) evaluates.
* Deferred (needs `rep` / the transition kit): `ofCurve`/`comp_ofCurve` discharge (Wave-4
  DAT-J, per §1.4 they consume `rep.homEquiv.symm (abelElement P)` verbatim);
  `abelElement_baseField` / `baseChange_ofCurve` (Wave-7; inherits deg-d5b §3's
  `isPullback_baseFieldTransition` and the planned `classDeg_map_iso` — the graph
  square above is stated at general tests `T` precisely so Wave-7 re-instantiates).

## Files and keystones

| file | keystones |
|---|---|
| `Algebra/PointFiberIdeal.lean` | `AlgebraicJacobian.Diagonal.ker_pointEv_map_localization_eq` (+ a′/b′) |
| `Curve/GraphFibre.lean` | `Over.isPullback_graphLift`, `Over.graphLift_preimage_range_diagonal` |
| `RiemannRoch/GraphDegree.lean` | `classDeg_graphPicClass` |
| `Picard/AbelElement.lean` | `degAt_relPicToPicEt`, `abelElement`, `abelElement_mem`-content, `abelElement_map_point`, `abelElement_map` |

Discipline: standing kernel rules (≤500 lines/file, `autoImplicit false`, zero sorries,
axioms exactly `[propext, Classical.choice, Quot.sound]` on keystones, lake mutex, commit
every green stage).  degAt/classDeg cross base fields only through the landed seams; no
new openness/χ machinery may accrete here.
