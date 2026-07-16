# G-D5(b) (base-field shuffle) + E-iv — design worksheet

*Written 2026-07-16 (Fable design pass, read-only). The degAt well-definedness core: the
Pic⁰ leg's gate and the degree recon's second flagged (C2)-style risk
(`informal/degree-pic0-recon.md` §3 G-D5/G-D6, §5 risk 2). House model:
`informal/deg-d2-meromorphic-worksheet.md`. Inputs re-verified against the tree this
session: the recon is stale in the lane's favour — `classDeg` + E-i..E-iii
(`RiemannRoch/Degree.lean`), the meromorphic bridge (S)+(X)
(`Picard/DivisorClassMeromorphic.lean`), `Curve/BaseChangeInstances.lean` (G-D5(a),
with the `classDeg K` smoke test), `Picard/LocalEquationsPullback.lean`
(`picClass_pullback`), `Picard/PointPresentation.lean` (tracked point uniformizer),
`Curve/GraphDivisor.lean` (deg-D4), and the **(C2) close**
(`Picard/EffectivityClose.lean`: `PicEtAff.unit_surjective_of_section`,
`unitEquiv_of_section`) are ALL landed. Roadmap leaf: `AJCR.picard.degree`.*

## §1 What degAt minimally needs — the sizing decision

**D1 — degAt needs NO geometric shuffle iso `(C_K) ⊗_K K' ≅ C_{K'}`, at any level.**
Not as a scheme isomorphism, not as a `CechPic`/`relPic` transport. The campaign is the
ALGEBRAIC transport (landed `relPicAlgMap`/`descentMap`/`mk_eq_mk_iff`) plus **one new
invariance equality** (E-iv-alg, §2) along the *k-indexed transition morphism*

`π := (C ◁ Over.overSpecMap φ).left : (C ⊗ overSpec k K₂).left ⟶ (C ⊗ overSpec k K₁).left`

for a k-algebra map `φ : K₁ →ₐ[k] K₂` of field extensions of `k`. Both ends carry the
full landed degree stack by `Curve/BaseChangeInstances.lean` (its smoke test
`classDegBaseChangeSmoke` is literally the application). No new object is transported
across any isomorphism; `π` already exists in the landed vocabulary.

**Why this suffices — the recipe.** For `λ : picEt C T` and a field point
`t : overSpec k K ⟶ T`:
1. restrict: `(picEtFunctor C).map t.op λ ∈ picEt C (overSpec k K)`; collapse by the
   landed `picEtAffineEquiv C K` to `q : PicEtAff C K`.
2. `q` is *definitionally* a plus class `mk C E x` (landed `PicEtAff.ind`); refine the
   cover to a single finite separable field `K'` (landed
   `EtaleCover.exists_finiteSeparableField_algHom` + `ofField`/`ofFieldEquiv` — exactly
   the first step of the landed `unit_surjective_of_section` proof, reuse its idiom);
   the representative is `y ∈ descentClasses C (ofField K') ⊆ relPic C (overSpec k K')`.
3. `relPic C (overSpec k K')` is `(C_{K'}).left.CechPic ⧸ picFromBase`; `classDeg K'`
   (landed) kills `picFromBase` because `CechPic (Spec K')` is trivial (§4 SB-5), so it
   descends to `relPicDeg K' : relPic C (overSpec k K') → ℤ`. Value: `relPicDeg K' y`.
   **No division/normalization** — E-iv-alg is precisely the statement that the degree
   over `K'` of a class already defined over `K` equals its degree over `K`
   (residue degrees shrink exactly as points split), so the single-field-factor value
   is the honest degree; the recon's "divide/normalize" phrase is dead.

**Well-definedness, both axes, is ONE lemma.**
- *(ii) enlargement `K' ↪ K''`*: `descentMap` is `relPicAlgMap ∘ (·.restrictScalars k)`
  (PicEtAff.lean:127/133) and `relPicAlgMap` is `relPicMap (overSpecMap ·)`, which on
  `CechPic` representatives is `CechPic.map π` (landed `relPicMap_mk`). So enlargement
  invariance IS E-iv-alg, verbatim.
- *(i) choice of representing cover/`K'`*: the landed plus setoid is *definitionally*
  "equal after transport to a common refinement" (`picEtAffSetoid`, `mk_eq_mk_iff`),
  with transport-map choice immaterial by the landed keystone `descentMap_congr`. Given
  two field representatives `(K'₁,y₁)`, `(K'₂,y₂)` of the same class: `mk_eq_mk_iff`
  gives a common cover `G` and maps with `descentMap f y₁ = descentMap g y₂`; refine
  `G` to a field `K'₃` (cofinality) and apply E-iv-alg on each leg. **No Galois descent
  appears**: the recon §5.2's feared "Galois-invariance argument on the degree" is
  dissolved because Galois twisting of the transport is a special case of the landed
  `relPicAlgMap_congr`/`descentMap_congr` (any two K-algebra maps out of a cover
  carrier transport a *descent* class identically), and the value along any one leg is
  E-iv-alg. This is the zigzag lemma (WD), §4 SB-6.

**The (C2) close does not change the design (and is not consumed).**
`unitEquiv_of_section` needs a curve point `σ : Spec K ⟶ C`; a general field point of a
general test object supplies none. degAt uses only the plus *presentation* (mk/ind/
mk_eq_mk_iff + cofinality), all landed before (C2) closed. The recon's disjointness
claim (§1.2) survives the close; do not import the Effectivity* chain into the degree
files (keep the dependency cone lean; `PicEtAff.lean` + `EtaleCover.lean` suffice).

**Sizing verdict: NOT a campaign.** Seven bricks (§4), one genuine heart (the chart
colength dictionary, SB-3), everything else S/M plumbing on landed API. The binding
guard stands: `degAt` is a total function whose representative-independence is the
proved equality (WD) — `Classical.choice` may pick representatives (as landed
`classDeg` does), but the *value* is pinned by an equality lemma, never by
`Nonempty`/choice of the answer.

## §2 E-iv — the honest statement and the pinned proof route

**The interface statement (shape binding; instances via `BaseChangeInstances` at both
`K₁` and `K₂`):**

```lean
theorem classDeg_cechPicMap_baseFieldTransition
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    {K₁ K₂ : Type u} [Field K₁] [Algebra k K₁] [Field K₂] [Algebra k K₂]
    (φ : K₁ →ₐ[k] K₂) (L : (C ⊗ overSpec k K₁).left.CechPic) :
    classDeg K₂ (Scheme.CechPic.map ((C ◁ Over.overSpecMap φ).left) L) = classDeg K₁ L
```

Stated for **k-algebra maps of arbitrary field extensions** (no finiteness/separability
— none is needed: integrality of `C_{K₂}` comes from geometric irreducibility for every
`K₂`, landed `instIsIntegralBaseChange`); the degAt consumer instantiates it at
K-algebra maps of finite separable extensions via `restrictScalars k`.

**D2 — route pinned: divisor-level via residueDeg and flat colength, by single-point
reduction. The χ-route is REJECTED.** Reasons: (a) the two-cover χ carrier
(`relTwoCoverH1`) computes only structure-sheaf cohomology, and the transport of
affine vanishing to twisted/divisor sheaves is the explicitly flagged dead frontier
(`Cohomology/RelativeTwoCover.lean` module docstring); (b) a dévissage-induction proof
of "χ(𝒪(D)) base-changes" reduces at each step to *the same* per-point identity (†)
below — the χ detour adds machinery and removes nothing. Consequently the χ half of
the recon's G11 (`h1_baseChange`, genus invariance) is **out of scope of this
campaign**: it is a Wave-5/ζ concern, consumed nowhere by degAt/pic0Functor/
abelElement. Do not let it accrete here.

**The reduction ladder (each rung landed unless marked NEW):**
1. Both sides of E-iv-alg are homs in `L` (`classDeg` is an `AddMonoidHom`;
   `CechPic.map` is a `MonoidHom`); `CurveDivisor.picClass K₁` is surjective (landed
   (S) `exists_picClass_eq`) and additive (`picClass_add`), and `CurveDivisor` is free
   on singles — so it suffices to prove it for `L = picClass K₁ (single hx' 1)`.
2. `picClass_single` (landed) rewrites `L` as the class of the tracked point equations
   `pointEquations K₁ hx' (pointUniformizerData K₁ hx')` — chart `V'`, section `t`
   regular, germ-η `= uniformizer`, **unit away from `x'`**.
3. `LocalEquations.picClass_pullback` (landed) gives
   `CechPic.map π L = (pointEquations.pullback π hreg).picClass`, with `hreg`
   discharged from flatness of `π` (NEW, small: `π` is a base change of the flat
   `Spec.map φ` via the pasted square SB-1, and `AlgebraicGeometry.Flat.stalkMap`
   [mathlib, verified] gives flat stalk maps; a flat local hom sends nonzerodivisors to
   nonzerodivisors — multiplication by `φ(a)` on the target is the flat base change of
   multiplication by `a`).
4. The pulled system's meromorphic presentation (landed
   `LocalEquations.presentation`/`presentation_picClass`) has divisor computed by
   `ordZ` of germ-η of the pulled equations (`coeffAt_presentationDivisor`, landed):
   coefficient `ordZ_{x''}(π^♯t)` for `x'' ∈ π⁻¹(x') ∩ π⁻¹V'`, `0` elsewhere (unit
   germs pull back to unit germs along `π^♯`; the second piece's equation is `1`) —
   NEW plumbing, SB-5.
5. `classDeg K₂ (picClass K₂ D'') = deg K₂ D''` (landed E-i `classDeg_picClass`), and
   `deg K₂ D''` is the finite fiber sum. What remains is:

**(†) the fiber-degree identity — the quantitative heart of E-iv:**

```
∑_{x'' ∈ π⁻¹(x')}  ordZ_{x''}(π^♯ t) · residueDeg K₂ x''  =  residueDeg K₁ x'
```

for `x'` closed in `C_{K₁}`, `t` the tracked uniformizer on a Dedekind chart `V' ∋ x'`
that is a unit on `V' \ {x'}`. Pinned proof (all commutative algebra on ONE affine
chart, no sheaf gluing — the D1-style discipline of the deg-d2 worksheet):
- `B₁ := Γ(C_{K₁}, V')` is Dedekind (chart chosen by landed
  `exists_isDedekindDomain_section` — or by SB-3a's general lemma);
  `B₂ := Γ(C_{K₂}, π⁻¹V')`, with `π⁻¹V'` affine (`π` is affine: base change of the
  affine `Spec.map φ`).
- **Sections base change** (SB-2): `B₁ ⊗[K₁] K₂ ≃+* B₂` from mathlib's
  `pushoutSection` engine applied to the pasted `IsPullback` square (affine case —
  `isIso_pushoutSection_of_isAffineOpen` — no flatness even needed).
- `B₂` is Dedekind (SB-3a: domain from integrality of `C_{K₂}`, Noetherian from finite
  type over `K₂`, DVR localizations from the landed stalk theory + stalk ≅
  localization-at-`primeIdealOf` — the `IsAffineOpen.primeIdealOf`/`AtPrime` pattern
  already exercised in `StalksDVR.lean:55` and `ClosedPoint.lean:48`).
- `dim_{K₁}(B₁/(t)) = residueDeg K₁ x'` and
  `dim_{K₂}(B₂/(π^♯t)) = ∑ ordZ·residueDeg` — both by the **chart colength
  dictionary** (SB-3b), since `t` (resp. `π^♯t`) vanishes on the chart exactly at
  `{x'}` (resp. `π⁻¹(x')`).
- `(B₁/(t)) ⊗[K₁] K₂ ≅ B₂/(π^♯t)` (right-exactness of ⊗ + the sections iso) and
  `finrank_{K₂}(M ⊗[K₁] K₂) = finrank_{K₁} M` (mathlib `Module.finrank_baseChange`,
  verified). Chain the four displays; done.

**No public divisor-pullback map.** `CurveDivisor` pullback is NOT introduced as
interface; the only pulled objects are local-equation systems (landed constructor) and
their presentation divisors (internal to SB-5). Keeps the surface at exactly E-iv-alg.

## §3 The shuffle itself — shuffle-as-square, not shuffle-as-iso

**D3 — for this campaign the "base-field shuffle" is a pullback SQUARE, never an
isomorphism.** The scheme-level content is:

```lean
theorem isPullback_baseFieldTransition (φ : K₁ →ₐ[k] K₂) :
    IsPullback ((C ◁ Over.overSpecMap φ).left) ((snd C (overSpec k K₂)).left)
      ((snd C (overSpec k K₁)).left) (Spec.map (CommRingCat.ofHom φ.toRingHom))
```

proved by pasting-cancellation: the two landed squares `Over.isPullback_left C
(overSpec k Kᵢ)` compose along `π ≫ (fst K₁) = fst K₂` (whisker-fst naturality) and
`CategoryTheory.IsPullback.of_right` [mathlib, verified] cancels. Everything downstream
(SB-2's sections base change, flatness/affineness/surjectivity of `π` by
`MorphismProperty.of_isPullback`) consumes this datum — mirroring how the landed
`SectionsBaseChange.lean` consumes `Over.isPullback_left`. Do **not** instantiate the
landed `Over.sectionsBaseChange` at base `K₁` (its statement is keyed to the
`X ⊗ overSpec K₁ K₂` pattern in `Over (Spec K₁)`, whose left object is *not* our
`(C ⊗ overSpec k K₂).left`) and then transport along a scheme iso — that would
manufacture exactly the shuffle iso D1 avoids. Re-run the (short) proof against the
pasted square instead; the corner bookkeeping differs only in that the `K₁`-algebra
structure on `Γ(C_{K₁}, V)` comes from the *second* projection (the
`BaseChangeInstances` Over-structure), not from `X.hom`.

**How much of the shuffle is already landed?** The algebra face, fully: the (C1)
campaign's `Descent/UnitDescentBaseChange.lean` + `Algebra/LocalizationCocycleBaseChange.lean`
push descent/cover cocycles along `A → A'` with `CommRing.Pic.mapAlgebra` naturality —
that is the ring-Pic shuffle for *affine* covers, and it is precedent (statement
discipline, keystone-per-file) but not a direct input here. The scheme face: the
k-anchored sections base change and `relPicAlgMap`/`overSpecMap` functoriality are
landed; NOTHING CechPic-level crosses base fields yet (recon §2.8, re-verified). The
gap is exactly SB-1 + SB-2 (S + M), not a campaign.

**The iso form is deferred to Wave-7, and designed here so Wave-7 inherits.** Wave-7's
`baseChangeIso` (`pic0Functor (C_L) ≅ pic0Functor C` shuffled, design §6.3 — NOT via
identity components) genuinely needs, for each test `T ∈ Over (Spec L)`, the iso
`(C_L ⊗_L T).left ≅ (C ⊗_k T).left`. Pinned route for Wave-7: both sides are pullbacks
of `C.hom` against `T`-over-composed-bases (SB-1-style pasted squares with `overSpec k
K₂` replaced by a general `T`); take `IsPullback.isoIsPullback` (uniqueness gives
naturality in `T`); transport `CechPic` along the iso (a `MulEquiv` from
`CechPic.map_comp/map_id` — cheap), check `picFromBase`/`descentClasses` compatibility
(étale covers live on the test *algebra*, identical on both sides), and for degree-0
stability combine E-iv-alg with ONE new Wave-7 lemma: **`classDeg_map_iso`** —
`classDeg K'` is invariant under `CechPic.map` of a `K'`-scheme isomorphism of curve
bundles (lighter sibling of E-iv-alg: ord/residueDeg transport along stalk isos, no
colength). SB-1/SB-2 should therefore state their `IsPullback` inputs as hypotheses
where this costs nothing, so Wave-7 re-instantiates instead of re-proving. Every
k-field-point of an L-test object is canonically an L-field-point (the composite
`Spec K → T → Spec L` puts the L-algebra structure on K), so the two `pic0` degree
conditions quantify over matching data — record this as the reason `baseChangeIso`
needs no new degAt theory beyond `classDeg_map_iso`.

## §4 Sub-bricks (dependency order; sizes S < M < L; one prover each)

- **SB-1 [GEO, S] — the transition toolkit** (`Curve/BaseFieldTransition.lean`).
  `isPullback_baseFieldTransition` (above); `π` flat, affine, surjective
  (`MorphismProperty.of_isPullback` from `Spec.map φ`'s properties); `π` maps generic
  point to generic point (surjective + irreducible — check mathlib dominant-morphism
  support first, else 5 lines of topology); the function-field map
  `π^♯ : K(C_{K₁}) →+* K(C_{K₂})` as `stalkMap` at η with germ-naturality lemmas
  (`Scheme.stalkMap_germ`) and units. Delegable (Opus). *Fallback:* none needed —
  every ingredient verified present.
- **SB-2 [GEO, M] — sections base change along the transition**
  (`Cohomology/TransitionSectionsBaseChange.lean`).
  `Γ(C_{K₁}, V) ⊗[K₁] K₂ ≃+* Γ(C_{K₂}, π⁻¹V)` for **affine** `V` (affine suffices for
  the whole campaign — pin this descope), template = the landed
  `SectionsBaseChange.lean` with the pasted square as `IsPullback` input; the
  `K₁`-algebra corner via the `BaseChangeInstances` structure morphism (= `snd`).
  Delegable-with-template. *Fallback:* if corner bookkeeping fights, state only the
  `IsPushout` of `CommRingCat` (the colength assembly can consume the pushout square
  directly through `CommRingCat.isPushout_tensorProduct`).
- **SB-3 [MIX, M–L, THE HEART — Fable spec] — the chart colength dictionary**, single
  curve over a single field, NO base change (`RiemannRoch/ChartColength.lean`):
  - **SB-3a**: `IsDedekindDomain Γ(X, V)` for *every* affine open `V` of a curve bundle
    (upgrade of the existential `exists_isDedekindDomain_section`): domain (integral
    scheme), Noetherian (finite type over `K`), localizations at nonzero primes are
    the DVR stalks via `primeIdealOf`/`IsLocalization.AtPrime` (the landed
    StalksDVR/ClosedPoint pattern), then the `IsDedekindDomainDvr → IsDedekindDomain`
    bridge.
  - **SB-3b**: for `f ∈ B := Γ(X,V)` regular whose germ is a unit outside a finite set:
    `finrank K (B ⧸ span{f}) = ∑_{x ∈ V closed} ordZ_x(germ_η f) · residueDeg K x`.
    **Pinned assembly: `finrank_quotient_eq_sum_factors_pow` (CRT, landed) + per-factor
    localization `B⧸P^e ≅ B_P⧸(PB_P)^e` + landed `finrank_quotient_span_pow` on the DVR
    `B_P` — NOT `finrank_quotient_span_eq_sum_ord`, whose principal-prime hypothesis
    `hprin` FAILS on general Dedekind charts.** Dictionary legs: factors of `(f)` ↔
    closed points of `V` where `f` vanishes (`primeIdealOf`/`fromSpec_primeIdealOf`);
    multiplicity-in-factors ↔ `ordZ` (via the stalk = `AtPrime` localization and the
    `stalkHeightOne` valuation); `B⧸P` ↔ `residueField x`. Reusable: this is also the
    engine for the deferred E-i pushforward-rank node (`Degree.lean` docstring) and for
    G-D8's graph-degree certificate. *Staged fallback:* land SB-3a + the two easy
    dictionary legs even if the multiplicity↔ordZ leg stalls; that leg is its own
    deliverable.
- **SB-4 [LA, S] — (†) assembly** (same file or `RiemannRoch/DegreeBaseChange.lean`):
  `(B₁⧸(t)) ⊗[K₁] K₂ ≅ B₂⧸(π^♯t)` (tensor-quotient + SB-2), `Module.finrank_baseChange`,
  chain the four displays of §2. Delegable.
- **SB-5 [MIX, M] — E-iv-alg** (`RiemannRoch/DegreeBaseChange.lean`):
  the §2 ladder — generator reduction, `hreg` from flatness, support/coefficients of
  the pulled point presentation (the fiber bookkeeping: unit germs pull to units;
  `coeffAt` calculus), fiber sum = (†). Plus the two descent gadgets:
  `CechPic (Spec K')` is trivial (one-point space, base-point trick on the cocycle —
  or `cechPicEquivPic` + Pic of a field) and
  `relPicDeg K' : Additive (relPic C (overSpec k K')) →+ ℤ` by `QuotientGroup.lift`
  of `classDeg K'`, with `relPicDeg_relPicAlgMap` (E-iv-alg descended). Fable-spec'd,
  Opus-provable after SB-1..4.
- **SB-6 [MIX, S–M] — the PicEtAff degree + (WD)** (`Picard/DegreeZero.lean`, first
  half): `PicEtAff.degAff : PicEtAff C K → ℤ` by representative-choice mirroring the
  landed `classDeg` pattern (choose + equality lemma), anchor
  `degAff_mk_ofField : degAff (mk C (ofField L) y) = relPicDeg L y`, well-definedness
  (WD) by the §1 zigzag (`mk_eq_mk_iff` + cofinality + `descentMap_congr` +
  `relPicDeg_relPicAlgMap`), additivity (`mk_mul_mk` on the product cover, refine to a
  field, `relPicDeg` hom), and `degAff_unit : degAff (PicEtAff.unit C K z) = relPicDeg K z`
  (the trivial cover is refined by `ofField K` itself; needed by G-D8's certificates).
  Delegable after SB-5.
- **SB-7 [MIX, S] — degAt + pic0Functor** (G-D6/G-D7 endpoints, `Picard/DegreeZero.lean`):
  `degAt λ t := degAff (picEtAffineEquiv C K ((picEtFunctor C).map t.op λ))`;
  functoriality `degAt ((picEtFunctor C).map f.op λ) t' = degAt λ (t' ≫ f)`
  (pure `picEtMap_comp` rewriting — subfunctor stability definitional, design §6.2);
  `pic0Functor C : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}` as the subgroup subfunctor
  `{λ | ∀ (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T), degAt λ t = 0}`
  — the §2.7 binding carrier for Wave-4's `RepresentableBy`. Delegable.

**Launch order:** SB-1 ∥ SB-3a now; then SB-2 ∥ SB-3b; SB-4; SB-5; SB-6; SB-7.
**Consumption map:** degAt (G-D6) = SB-5+6+7; pic0Functor (G-D7) = SB-7; abelElement
(G-D8, next campaign) consumes SB-6's `degAff_unit`, landed `graphPicClass`/
`pointEquations` + E-i, and reuses SB-3 for its degree-1 certificates; Wave-7's
`baseChangeIso` inherits SB-1 (state `IsPullback` inputs generally), SB-2's engine,
SB-5's E-iv-alg and CechPic-of-field-triviality, and owns the iso family +
`classDeg_map_iso` + picEt transport (§3).

## §5 Honest risks

1. **SB-3b's dictionary is where a balloon would live** (the analogue of deg-d2's W3).
   Three independent legs (points↔primes, multiplicity↔ordZ, residue fields); each is
   established *pattern* (StalksDVR/ClosedPoint use `primeIdealOf`+`AtPrime` today) but
   the multiplicity↔ordZ leg crosses from ideal factorization to the
   `stalkHeightOne` valuation — the least-trodden bridge in the tree. Mitigations
   pinned: the CRT+localization assembly (never `sum_ord`'s false `hprin`), staging,
   and the leg's standalone value (E-i pushforward-rank, G-D8). If it stalls, the
   campaign stalls — there is no χ detour (§2's circularity note); flag early.
2. **Fiber/support plumbing in SB-5** (step 4): "unit germs pull back to unit germs,
   so the pulled divisor is supported in the fiber" is germ-naturality noise across
   `appLE`/stalkMap spellings; bounded by the landed `coeffAt` calculus +
   `pointEqn_of_ne`/`isUnit_germ`, but budget real time. Kernel discipline: opaque
   defs for pulled systems, named simp lemmas, never unfold covers into `dite` towers.
3. **Spelling seams.** (a) SB-2's corners: the `K₁`-algebra structure on sections is
   the `BaseChangeInstances` Over-structure (second projection), not `X.hom` — state
   lemmas against `(C ⊗ overSpec k K₁).left ↘ Spec K₁` and use
   `baseChange_over_eq_snd_left` (rfl) to cross. (b) Instance-diamond watch:
   `instOverBaseChange` vs `relCurve.instOver` install the same structure keyed on
   different spellings; degree files must import `BaseChangeInstances` and avoid
   `relCurve` to keep one instance path. (c) `descentMap` vs `relPicAlgMap`
   `restrictScalars` nests — reuse the `AlgHom.ext fun _ => rfl` idiom of
   `EffectivityClose.lean:168`.
4. **Unverified mathlib premises** (all names spot-checked this session:
   `CategoryTheory.IsPullback.of_right`, `AlgebraicGeometry.Flat.stalkMap`,
   `Module.finrank_baseChange` exist; NOT yet checked: the
   `IsDedekindDomainDvr → IsDedekindDomain` bridge's exact name, dominant-morphism
   generic-point lemmas, affine-morphism preimage-affine). Spec-writers must
   `lean_local_search`/loogle each before pinning proofs; each has a ≤10-line fallback.
5. **What this worksheet deliberately does not decide:** the `degAff` vehicle
   (`Quotient.lift` with (WD) as compat vs choose+equality — prover's choice inside the
   guard); whether SB-3b states the vanishing-set hypothesis via `basicOpen` or via
   germ-units (prover's choice, but the point-presentation consumer speaks germ-units);
   Wave-7's `classDeg_map_iso` spelling (Wave-7-owned; only its *existence* is planned
   for here).

## Discipline (inherited, binding)

Standing kernel/elaboration rules; ≤500 lines/file; `set_option autoImplicit false`;
no sorry; axioms exactly `[propext, Classical.choice, Quot.sound]` (`lean_verify`, live
LSP); K-explicit-first per the RiemannRoch convention; `CurveDivisor.single`/`coeffAt`
calculus, never raw `Finsupp` in +/−/• positions; all cochain comparisons in `K(X)ˣ`
(deg-d2 D1) — if a proof does sheaf gluing, it has left the route; `[QuasiCompact]`
enters only through the landed presentation-divisor API. Foreground builds, one at a
time; blueprint nodes per brick (E-iv is Kleiman's "cohomology commutes with flat base
change" specialized to degree — anchor `kleiman-picard` only on a genuine match, else
state as-is).

## Acceptance

Per brick: kernel-green (target + root), axiom-clean, committed, blueprinted. Campaign
close = E-iv-alg + degAt + pic0Functor landed with the §2.7 carrier shape → G-D8
(abelElement) unblocked → roadmap `AJCR.picard.degree` advances; Wave-7 inherits per
§3/§4 consumption map.
