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

(γ) **LANDED 2026-07-12** (`Picard/CechPicToPicNaturality.lean`, kernel-green, axiom-clean):
`Scheme.CechPic.toPic_map : toPic X (CechPic.map g L) = CommRing.Pic.mapRingHom g.appTop.hom (toPic Y L)`
for `g : X ⟶ Y` between affine schemes, plus the `toPic_mapAlgebra` form under
`g.appTop.hom.toAlgebra`. Original spec follows; the square

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

### Refined design after full API recon (2026-07-12, second pass — supersedes the ε sketch above)

Unfolding the target with the actual API: `unit C A x = 1` reduces via `mk_eq_mk_iff` +
essential-uniqueness of maps out of `(.self A).Carrier` to: ∃ étale cover `B := E.Carrier`
with `relPicAlgMap C (ofId A B) x = 1`. Writing `x = relPicMk L`, `X_R := (C ⊗ overSpec k R).left`,
`p_R := (snd …).left`, this is (by `relPicMap_mk` + `mem_picFromBase_iff`, all on-the-nose
equations): ∃ `N : CechPic (Spec B)` with `p_B^* N = (C ◁ g)^* L` in `CechPic X_B`.
Goal: ∃ `M : CechPic (Spec A)` with `p_A^* M = L`.

Brick list (each independently landable):

**(ε1) Projection-units API** (`Picard/ProjectionUnits.lean`): package
`unitsAppLE_snd_bijective` as `Over.unitsSndEquiv : Γ(T.left, V)ˣ ≃* Γ((C⊗T).left, pr⁻¹V)ˣ`
(affine `V`) with naturality in `V` (restriction) and in `T` (pullback along `g : T' ⟶ T`
with `IsAffineOpen (g.left ⁻¹ᵁ V)` hypothesis). Q8 recon: nothing packaged exists; every
coherence check in ε3/ζ pushes identities through this equiv, `descend_coboundary`-style.

**(ε2) Descent in stages / the splice, pure algebra** (`Descent/UnitDescentComposite.lean`):
tower `A → B → P` (`[Algebra A B] [Algebra B P] [IsScalarTower A B P]`),
`π : P ⊗[A] P →ₐ[A] P ⊗[B] P` the canonical collapse. Given `v : (P ⊗[A] P)ˣ` an
`A`-descent cocycle and `u := Units.map π v` (automatically a `B`-descent cocycle — small
lemma), with `[Module.FaithfullyFlat A B] [Module.FaithfullyFlat B P]`:
`descended(v) ⊆ descended(u)` on the nose, and
`B ⊗[A] descended(v) ≃ₗ[B] descended(u)` via `b ⊗ m ↦ b • m` (equivDescended idiom, exactly
the `descendedMapEquiv`/`descendedBaseChangeEquiv` skeleton), hence
`Pic.mapAlgebra A B (picClass v) = picClass u`. This replaces the earlier "cover cocycle +
comparison datum" splice: the two-layer data is carried by the single unit `v`, and all
coherence is subsumed in `IsDescentCocycle v`.

**ε1 LANDED 2026-07-12** (`Picard/ProjectionUnits.lean`): `Over.unitsSndEquiv (hV : IsAffineOpen V) :
Γ(T.left, V)ˣ ≃* Γ((C ⊗ T).left, (snd C T).left ⁻¹ᵁ V)ˣ` with round-trips, restriction
naturality (`unitsSndEquiv_unitsRestrict` + symm form), test-object naturality in FULL
generality (`unitsSndEquiv_naturality`, via `snd_left_naturality : (C ◁ g).left ≫ (snd C T).left
= (snd C T').left ≫ g.left`), and the uniqueness lemma `unitsSndEquiv_symm_eq_of_unitsAppLE`.

**ε2 LANDED 2026-07-12** (`Descent/UnitDescentComposite.lean`): `tensorCollapse`,
`IsDescentCocycle.collapse`, `descended_le_descended_collapse` (with `.restrictScalars A`),
`descendedCollapseEquiv : B ⊗[A] descended v ≃ₗ[B] descended (collapse v)` (instances:
FF A B, FF B P, FF A P — discharge the third via `Module.FaithfullyFlat.trans A B P`),
`picClass_collapse : (collapse v).picClass = Pic.mapAlgebra A B v.picClass`.

**(ε3/ζ) Scheme-side assembly** (the remaining hard step, needs ε1+ε2+γ+brick 3).
Sub-brick decomposition:

- **ζ1 (class-level coherence seed, well-specified)**: for k-algebras `A → B`,
  `L : CechPic X_A`, `N : CechPic (Spec B)` with
  `p_B^* N = (C ◁ overSpecMap (ofId A B))^* L`, the two base changes agree:
  `CechPic.map (Spec of inl) N = CechPic.map (Spec of inr) N` over `Spec (B ⊗[A] B)`,
  where inl/inr : B →ₐ[A] B ⊗[A] B. Proof: both sides `p_{B⊗B}`-pull back to
  `(C ◁ …)^* L` (CechPic.map_comp + snd_left_naturality + overSpecMap_comp), then
  `prPullback_injective` over `overSpec k (B ⊗[A] B)`.
- **ζ2 (construct the composite descent unit)** — REDESIGNED 2026-07-12 late (the
  "global-unit correction" route; supersedes the family-descent sketch). KEY INSIGHT:
  never descend cover-indexed unit families along `p` — only GLOBAL units cross `p`
  (ε1 at `V = ⊤`, i.e. `Γ(X_R)ˣ ≅ Rˣ`, both `Spec R` sides affine so `⊤` is affine).
  Steps:
  - **ζ2·P (Amitsur toolkit, prerequisite brick)**: (P1) a unit 0-cochain on a pointed
    cover with trivial coboundary glues to a global unit (𝒪ˣ sheaf gluing in the
    `unitsCocycle` vocabulary); (P2) the three coface maps `R₂ := B⊗[A]B ⥤ R₃ := B⊗[A]B⊗[A]B`
    (`m₁₂, m₁₃, m₂₃` as →ₐ[k], mirroring `tensorInl/tensorInr` idiom) with the simplicial
    identities against `tensorInl/tensorInr`, and `unitsSndEquiv` specialized at `⊤`
    (global-units descent + injectivity of `p^#` on global units).
  - **ζ2·i (coherent witness)**: from ζ1, ANY Čech witness `θ` on a basic cover of
    `Spec R₂` for `q₁^#ν / q₂^#ν = ∂θ` exists (affine mk-calculus / `class_eq_one_of_pic_eq_one`).
    Its Amitsur failure `ω := m₂₃^#θ · m₁₂^#θ / m₁₃^#θ` has trivial Čech coboundary
    (telescope of the three pulled-back defining equations), hence glues to a global unit
    `ω ∈ R₃ˣ` (P1). Upstairs: the lift's witness `α` (from `h` via mk-calculus on `X_B`)
    gives the canonical comparison `β := u₁^#α / u₂^#α` whose telescope over `X_{R₃}` is
    EXACTLY 1 (pairwise cancellation); `p^#θ` and `β` cobound the same cocycle, so differ
    by a ∂-trivial cochain ⟹ a global `ψ ∈ Γ(X_{R₂})ˣ` (P1 upstairs); `χ := ε1-descent of ψ`;
    then `p^#(ω / δ_Am(χ)) = 1` and `p^#` is injective on global units (P2) ⟹
    `ω = δ_Am(χ)` ⟹ `θ' := θ/χ` is an Amitsur-COHERENT witness. All Čech work on affine
    schemes; only global units cross `p`.
  - **ζ2·ii (pi-assembly)**: components `v_{ij} ∈ (S_i ⊗[𝔄] S_j)ˣ` from `θ'` and the
    trivializations (note `S_i ⊗[𝔄] S_j` is the section ring of the basic open
    `D((r_i⊗1)(1⊗r_j))` of `Spec R₂` — the pi-double decomposition over `𝔄` lands on basic
    opens of the double), cocycle identity for `v` from θ'-coherence + c-telescoping via
    pi-ext; `collapse v = cocycleUnit c` on the diagonal. Pure algebra + section rings.
- **ζ3 (close)**: `M := cechPicEquivPic.symm (picClass v)` over `A`; `p_A^* M = L` via the
  mk/unitsRes calculus + ε1 (the fppf `descend_coboundary` analogue); then unfold to
  `PicEtAff.unit_injective` via `mk_eq_mk_iff` + `relPicMk` calculus (Q1/Q4 recon shapes).

Original prose route:
from `p_B^* N = (C◁g)^* L`, at cocycle level (mk-calculus, refinement injectivity):
1. `q₁^* N = q₂^* N` over `Spec (B ⊗[A] B)` — brick 3 over `overSpec k (B⊗[A]B)` since both
   sides pull back to the same `(C◁…)^* L` on `X_{B⊗B}` (CechPic.map_comp + square commutes).
2. Construct the composite descent unit `v ∈ ((∏S) ⊗[A] (∏S))ˣ` for a basic cover `f : ι → B`
   trivializing `N` (dictionary machinery, `TrivializingFamily`): its `⊗[B]`-collapse is the
   Zariski cover cocycle of `N` (u_B), and its cross terms come from the comparison of the two
   pullbacks in step 1, descended through ε1; `IsDescentCocycle v` is checked after `p`-pullback
   (ε1 injectivity), where all terms become coboundary comparisons of the SAME cocycle rep of L.
3. `M := cechPicEquivPic.symm (picClass v)` over `A`; the final on-the-nose equality
   `p_A^* M = L` is checked by the `unitsRes`/`mk_eq_one_iff` calculus: `L / p_A^* M` is
   trivialized on `X_B` with descent-unit data matching `v` by construction, and a class
   trivialized on `X_B` whose `B⊗B`-descent unit descends (ε1) to a coboundary datum is 1 —
   this last sub-step is the fppf analogue of `descend_coboundary` and is where ε1's
   naturality does the work. (Alternatively organize 3 as: ker(CechPic X_A → CechPic X_B)
   ⊆ range(p_A^*) as a standalone lemma with the same tools.)

## Sequencing

β (in flight) → γ (spec ready as soon as β's names are final; opus-delegable) →
ε (needs a real design pass; the only Fable-grade step) → ζ (assembly, likely one session).

(C2) rigidification (`Picard/Rigidification.lean`) still does not exist — untouched by this
lane; OPEN-2 unchanged.
