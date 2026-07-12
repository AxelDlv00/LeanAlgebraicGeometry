# (C1) étale separatedness — assembly worksheet

*2026-07-12, Fable-5 session (post run-0030 crash recovery). Working notes toward design
§4.4 item 5; supplements `wave3-picard-design.md`, does not supersede it.*

## Target

`(C1)`: injectivity of the one-step-plus unit — Lean phrasing (per PicEtAff.lean docstring):

```
theorem PicEtAff.unit_injective : Function.Injective (PicEtAff.unit C A)
```

equivalently the kernel-triviality form: for every presented étale cover `E : Algebra.EtaleCover A`,
`relPicAlgMap C (Algebra.ofId A E.Carrier) x = 1 → x = 1`.

## Landed inventory (verified 2026-07-12, tree green at 8613 jobs)

- **Dictionary (complete, both directions)**: `AlgebraicGeometry.cechPicEquivPic (X) [IsAffine X] :
  X.CechPic ≃* CommRing.Pic Γ(X, ⊤)` (`Picard/CechPicSurjective.lean:283`), from
  `CechPic.toPic` (`CechPicToPic.lean:82`) + `toPic_injective` + `toPic_surjective`.
  Underneath: `BasicRefinement.pic` = `Module.IsDescentCocycle.picClass` of the associated
  `cocycleUnit` (`PicAffineCover.lean:290`, `pic_eq_picClass`).
- **Brick 3**: `Over.prPullback_injective` (`Separatedness.lean:269`) — arbitrary `T`.
- **Brick 4**: `Module.DescentDatum.invertible_descended`, `IsDescentCocycle.picClass`.
- **Algebra face of dictionary naturality** (run 0030): `Module.tensorSqBaseChange`,
  `IsDescentCocycle.baseChange`, `descendedBaseChangeEquiv`,
  `IsDescentCocycle.picClass_baseChange : (hu.baseChange).picClass = CommRing.Pic.mapAlgebra A A' hu.picClass`
  (`Descent/UnitDescentBaseChange.lean`).
- **Curve-side affine 2-covers** (run 0030): `Scheme.AffineTwoCover`, `nonempty_of_curve`,
  `pullbackProd` (`Picard/AffineTwoCover.lean`).
- **Plus-construction scaffold**: `descentClasses` (= `MonoidHom.eqLocus` of the two
  `relPicAlgMap`s along `doubleInl/doubleInr`), keystone `relPicAlgMap_congr`,
  `PicEtAff.unit`, naturality `map_unit`/`mapAlg_unit` (`PicEtAff.lean`, `PicEtAffMap.lean`).
- Refinement invariance at algebra level: `picClass_map_refine`, `picClass_eq_of_coboundary`
  (`Algebra/LocalizationCocycleRefine.lean`).

## In flight

- **Brick β** (`Algebra/LocalizationCocycleBaseChange.lean`, agent running 2026-07-12):
  `mapAway/mapOverlap`, `IsCoverCocycle.baseChange`, keystone `cocycleUnit_baseChange`
  (cover cocycle pushed along `A → A'` matches `tensorSqBaseChange` on descent units),
  FF bookkeeping (`span_range_algebraMap_eq_top`, FF of `A' ⊗[A] (∏ S i)`), composite
  `pic_baseChange : picClass (base-changed cover cocycle) = Pic.mapAlgebra A A' (picClass γ)`.

## Missing (the gap list, from read-only recon 2026-07-12)

(γ) **Scheme face of dictionary naturality**: for `g : X ⟶ Y` between affine schemes, the square

```
CechPic Y  --toPic Y-->  Pic Γ(Y,⊤)
   | CechPic.map g            | Pic.mapRingHom (g.appTop / mapAlgebra)
CechPic X  --toPic X-->  Pic Γ(X,⊤)
```

commutes. Route: instantiate brick β's abstract primed models with section rings
`Γ(X, X.basicOpen (g.appTop (P.r i)))` (preimage of a basic open is the basic open of the
pulled-back section; these are `IsLocalization.Away` models over `Γ(X,⊤)` for the pushed
family) and use `pic_baseChange` + `pic_congr` choice-independence. This is why β keeps
models abstract.

(ε) **Cocycle-coherence extraction** — the design's "one genuinely delicate step": from the
*lift data* (a unit cocycle on `(C ⊗ Spec B).left` which is `pr^*` of `n' : CechPic (Spec B)`
after refinement, both of whose `B ⊗[A] B`-restrictions agree as pullbacks of the SAME lift),
produce an honest `Module.IsDescentCocycle` / `Module.DescentDatum` over `A` with cover `B`
(then a composite cover `A → B → ∏ S_i`). Class equality in `Pic (B ⊗[A] B)` is NOT enough —
coassociativity over `B⊗B⊗B` must come from the cocycle-level lift. No Lean declaration
exists for any of this yet.

(ζ) **Assembly (d)**: `PicEtAff.unit_injective` from brick 3 (twice) + (γ) + (ε) + brick 4,
per design §4.4 item 5's paragraph. Statement shape:
`∀ x : relPic C (overSpec k A), relPicAlgMap C (Algebra.ofId A E.Carrier) x = 1 → x = 1`,
then `unit_injective` via `injective_iff_map_eq_one` + `mk_eq_mk_iff` calculus.

### (ε) refined route — the "cocycle splice" (identified 2026-07-12)

The delicate step decomposes into one pure-algebra brick plus scheme-side unit descent:

1. **Splice brick (pure algebra, new file candidate `Descent/CompositeCocycle.lean`)**:
   let `A → B` be faithfully flat, `f : ι → B` a finite covering family with models
   `S i` (so `B → ∏ S i` is the Zariski cover of `Spec B`). Given (i) a cover cocycle
   `γ'` over `B` (Zariski datum: `u' := cocycleUnit γ' ∈ ((∏S) ⊗[B] (∏S))ˣ`, a descent
   cocycle over `B`), and (ii) a comparison unit over `B ⊗[A] B` relating the two
   base-change structures, satisfying a triple-product coherence, produce a descent
   cocycle `u ∈ ((∏S) ⊗[A] (∏S))ˣ` for the COMPOSITE faithfully flat map `A → ∏ S i`,
   with `picClass u ∈ Pic A` mapping to `picClass u'` under `Pic.mapAlgebra A B`.
   (Classical: splicing a Zariski cocycle on the cover with an fppf gluing datum into a
   single cocycle for the composite cover.)
2. **Scheme-side supply of (ii)**: the comparison unit and its coherence are NOT assumed —
   they are extracted from the lift `L` on `(C ⊗ Spec (B ⊗[A] B)).left`:
   `unitsAppLE_snd_bijective` descends units of `C ⊗ Spec R` to units of `Spec R` opens
   (any `R`), and `appLE_snd_injective` lets every identity between descended units be
   verified after pullback, where it is a coboundary-comparison computation for the SAME
   cocycle `L` over the triple product. So coherence comes from checking upstairs, not
   from class equalities.

## Sequencing

β (in flight) → γ (spec ready as soon as β's names are final; opus-delegable) →
ε (needs a real design pass; the only Fable-grade step) → ζ (assembly, likely one session).

(C2) rigidification (`Picard/Rigidification.lean`) still does not exist — untouched by this
lane; OPEN-2 unchanged.
