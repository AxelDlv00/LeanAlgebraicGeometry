# deg-D4b (`diagonalLocalEquations`) — design worksheet

*Written 2026-07-15 (Fable design agent). The hard core of the graph-divisor campaign
(`informal/deg-d4-recon.md` §4 step 2): the diagonal of the smooth relative curve as an
effective divisor in local equations. House model: `informal/c2-effectivity-assembly.md`
and `informal/deg-d2-meromorphic-worksheet.md` — this document MAKES the route decisions;
they are binding for the sub-brick specs. Inputs: the D4 recon; the landed deg-D4a
(`Picard/LocalEquationsPullback.lean`, ledger `704176f08d`); `Picard/DivisorClass.lean`
(the target structure); `Curve/StalksDVR.lean` + `Curve/DedekindSections.lean` (the chart
extraction pattern); Mathlib re-read at the pinned snapshot (all `file:line` below verified
this session under `.lake-packages/mathlib/Mathlib/`).*

## Target

```lean
noncomputable def Over.diagonalLocalEquations (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsSeparated C.hom] :
    ((C ⊗ C).left).LocalEquations
```

presenting the diagonal `Δ := range (Over.sectionOfPoint (𝟙 C)).left` — the graph of the
identity (`Picard/Rigidification.lean:85`), so that deg-D4c can realize `Γ_t` as
`diagonalLocalEquations.pullback (lift (fst C T) (snd C T ≫ t)).left hreg` via the landed
`LocalEquations.pullback`/`picClass_pullback` (`LocalEquationsPullback.lean:118,172`) and
`sectionOfPoint_naturality` (`Rigidification.lean:99`).

**Instance discipline.** The minimal hypotheses are as above: smoothness of relative
dimension 1 (charts + étale coordinate + flatness) and separatedness (Δ closed, affine
overlaps). `IsProper` supplies `IsSeparated` for the challenge curve;
`GeometricallyIrreducible`/`GeometricallyReduced` are **NOT on the route** (see D2 — no
integrality of `C ⊗ C` is used anywhere). State bricks with the minimal pair.

Deliverable includes the D4c-facing regularity API (D6) — the campaign is not closed by
the `LocalEquations` value alone.

## What changed since the recon (read this first)

1. **Mathlib now has a scheme-level kernel ideal sheaf.** The recon's premise "no
   scheme-level API at all" is superseded at this snapshot:
   `AlgebraicGeometry/IdealSheaf/Basic.lean` defines `Scheme.IdealSheafData` (`:65` — an
   ideal per affine open + basic-open localization compatibility + support), with
   - `Scheme.Hom.ker : X.Hom Y → IdealSheafData Y` (`:692`),
   - `Hom.ker_apply [QuasiCompact f] : f.ker.ideal U = RingHom.ker (f.app U).hom` (`:702`)
     — on EVERY affine open,
   - `IdealSheafData.map_ideal (h : U ≤ V) : (I.ideal V).map (res) = I.ideal U` (`:221`)
     — restriction compatibility between arbitrary affine opens, not just basic opens,
   - `Hom.support_ker [QuasiCompact f] : f.ker.support = closure (Set.range f)` (`:843`),
   plus `IdealSheaf/Functorial.lean` (`comap`/`map`, `map_ker`). This is the cross-chart
   invariant (D3) as a **gift, not a build**. There is still no
   `EffectiveCartierDivisor`/`RegularImmersion` (grep re-verified empty) — the recon's
   campaign verdict stands — but the hardest plumbing item (a quasi-coherent "ideal of Δ"
   restrictable across charts) is landed upstream.
2. **Generation does not need Nakayama or `basisCotangent`.** The recon's route (I/I²
   free rank 1 + Nakayama + spreading out) is demoted to fallback. The binding route (D1)
   uses the étale factorization `k[u] → B` of a standard-smooth chart
   (`Algebra.IsStandardSmoothOfRelativeDimension.exists_etale_mvPolynomial`,
   `RingTheory/RingHom/StandardSmooth.lean:200`, already consumed in-tree at
   `Curve/DedekindSections.lean:120`): the diagonal ideal is EXACTLY principal, generated
   by `u⊗1 − 1⊗u`, on an explicit basic open containing all of `Δ ∩ chart`.
3. **Regularity does not need integrality of `C ⊗ C`, nor a flatness slicing
   criterion.** The recon's G-D4.b ("no section-of-flat regularity lemma; fresh
   regular-sequence argument") dissolves into monic + flat base change (D2), which works
   over an ARBITRARY second factor — the same engine discharges D4b's `regular` field and
   D4c's `hreg` (where `C ⊗ T` is not integral and integrality arguments would die).
4. Sizes: honest total is ~1200–1600 lines over six bricks, not the recon's "~400+".

## Decisions (made now, binding)

**D1 — Generation: the étale-coordinate localization route.** Fix an affine
standard-smooth chart `U ⊆ C.left`, `B := Γ(C.left, U)`, extracted per the
`StalksDVR.lean:153-171` pattern (base open collapses to `⊤` over the one-point
`Spec k`; `algebraize` on `(C.hom.appLE ⊤ U e).hom`). By `exists_etale_mvPolynomial`
there is `g : MvPolynomial (Fin 1) k →ₐ[k] B` with `g.Etale`; write `u := g (X 0)`,
`P := MvPolynomial (Fin 1) k`. Then, ring level:

- (a) `ker (π : B ⊗[k] B →ₐ B ⊗[P] B) = Ideal.span {u ⊗ₜ 1 - 1 ⊗ₜ u}` — the base-change
  kernel of a singly-generated base; universal-property argument (new,
  `KaehlerDifferential.span_range_eq_ideal` at `RingTheory/Kaehler/Basic.lean:133` is the
  model and handles the polynomial-ring case).
- (b) `J := ker (mul : B ⊗[P] B → B)` is generated by an idempotent `e`:
  étale ⇒ `FormallyUnramified` ⇒ `Subsingleton Ω[B⁄P]`
  (`Unramified/Basic.lean:59`, `iff_subsingleton_kaehlerDifferential` per
  `Kaehler/Basic.lean:246`) ⇒ `J = J²` (`Ideal.cotangent_subsingleton_iff`,
  used at `Unramified/Basic.lean:340`); `J` f.g. (`KaehlerDifferential.ideal_fg`
  under `EssFiniteType`, `Kaehler/Basic.lean:408`, or Noetherianity of the f.g.
  `k`-algebra); conclude by `Ideal.isIdempotentElem_iff_of_fg`
  (`RingTheory/Ideal/IdempotentFG.lean:22`).
- (c) Lift `e` to `ẽ ∈ B ⊗[k] B` along the surjection `π`. Since
  `ẽ(1-ẽ) ∈ ker π` and `mul_k = mul_P ∘ π`, localizing away from `s := 1 - ẽ` kills `ẽ`:
  `I := ker (mul_k : B ⊗[k] B → B) = ker π + (ẽ)`, hence
  **`I · (B⊗B)[s⁻¹] = Ideal.span {u⊗1 − 1⊗u}`** — exact principality with the explicit
  generator, on the basic open `D(1-ẽ)`, which contains all of `Δ ∩ chart`
  (`π(ẽ) = e ∈ J` ⇒ `mul_k ẽ = 0` ⇒ `1-ẽ ↦ 1` on Δ).

The diagonal member at `z ∈ Δ` is `𝔇(U) := (C⊗C).left.basicOpen γ` where `γ ∈ Γ(𝔚 U)`
transports `1-ẽ` through the product-chart iso (D5) — ONE member per chart of `C`,
covering `Δ ∩ 𝔚 U` in one piece. NO per-point spreading out, NO Nakayama, NO cotangent
basis. *Fallback (only if (a) fights):* the recon's Nakayama route — `Ω[B⁄k] = I/I²` free
rank 1 on `du` (`SubmersivePresentation.basisKaehler_apply`,
`Smooth/StandardSmoothCotangent.lean:232`), Nakayama at each `p ⊇ I` + spread to `D(g_p)`
— per-point members, everything downstream unchanged.

**D2 — Regularity: monic + flat, uniformly in the second factor.** The engine lemma
(exported, D4c consumes it verbatim):

> for `k[X] →ₐ B` **flat** and ANY `k`-algebra `A`, any `b : A`:
> `u ⊗ₜ 1 - 1 ⊗ₜ b ∈ nonZeroDivisors (B ⊗[k] A)`.

Proof chain, all mathlib: `X - C b` is monic hence `∈ A[X]⁰`
(`Polynomial.Monic.mem_nonZeroDivisors`, `Algebra/Polynomial/RingDivision.lean:126` — no
nontriviality needed); `A[X] ≃ₐ A ⊗[k] k[X]` (`polyEquivTensor`,
`RingTheory/PolynomialAlgebra.lean:169`, plus the `comm` swap); `B ⊗[k] A` is flat over
`k[X] ⊗[k] A` (base change of the flat `k[X] → B`, `Module.Flat.baseChange`,
`RingTheory/Flat/Stability.lean:100`); a flat algebra maps nonzerodivisors to
nonzerodivisors (`Module.Flat.isSMulRegular_of_nonZeroDivisors`,
`RingTheory/Flat/TorsionFree.lean:79`, + a 3-line `IsSMulRegular → algebraMap _ ∈ _⁰`
bridge, new). Flatness of `k[X] → B` comes free from étale (`Algebra.Smooth.flat`,
`RingTheory/Smooth/Flat.lean:58`), and — crucially for D4c — is inherited by any affine
sub-open `U' ⊆ U` (composite with the flat `B → Γ(U')`), so the engine runs at every
point of `C ⊗ T` after shrinking. Instantiations: D4b's `regular` field is `A = B`,
`b = u`; D4c's `hreg` is `A =` chart of `T.left`, `b = t^♯u`. Germ-level regularity from
section-level: stalks on affines are localizations (`IsAffineOpen.isLocalization_stalk`,
in-tree pattern `StalksDVR.lean:55`), localizations are flat (`IsLocalization.flat`,
`RingTheory/Flat/Localization.lean:36`), same bridge — package as the second exported
helper (`germ regular of section regular on an affine open`). **Deliberately NOT built:**
a "section of flat + fibrewise regular ⇒ regular" slicing criterion, integrality of
`C ⊗ C` (`Rigidity.lean:160` stays unused here), transcendence of `u`.

**D3 — Cross-chart ratio invariant: `(δ C).left.ker`, Mathlib's kernel ideal sheaf.**
Write `δ C := Over.sectionOfPoint (𝟙 C) : C ⟶ C ⊗ C`. The per-chart deliverable of the
kernel computation (B4) is stated against the intrinsic invariant:

```lean
((δ C).left.ker).ideal ⟨𝔇(U), h𝔇⟩ = Ideal.span {diagEqn U}
```

(`Hom.ker_apply` applies: closed immersions are affine hence quasi-compact,
`Morphisms/ClosedImmersion.lean:149`). Then `ratio_isUnit` between two diagonal members
`𝔇(U₁), 𝔇(U₂)`: the overlap `W = 𝔇(U₁) ⊓ 𝔇(U₂)` is AFFINE — `(C⊗C).left` is a separated
scheme (`Scheme.IsSeparated`, `Morphisms/Separated.lean:330`; instance glue: composite of
the separated `(C⊗C).hom` with the affine base, `IsSeparated` stable under composition
`Separated.lean:69`; closed-immersion diagonal ⇒ affine diagonal) — so `IsAffineOpen.inf`
(`Morphisms/Affine.lean:327`) applies; `map_ideal` + `Ideal.map_span` transfer both
generations to `W`; two **regular** generators of the same ideal differ by a unit (tiny
new ring lemma: `I = (a) = (b)`, `a,b` regular ⇒ `∃! u : unit, a = u b`; the germwise
`regular` field restricts to section-level nonzerodivisibility by the
`eqn_restrict_mem_nonZeroDivisors` proof pattern, `DivisorClass.lean:137-149`, factored
standalone). NO germ-by-germ unit gluing, NO sheaf gluing.

**D4 — Cover indexing (the `PointedCover` per-point discipline,
`UnitsCocycle.lean:94`).** For `z : (C ⊗ C).left`:
- `z ∈ Δ`: set `p := (fst C C).left.base z` (then `(δ C).left.base p = z` from
  `δ ≫ fst = 𝟙`); member `:= 𝔇(chartAt p)` where `chartAt` is a `Classical.choice`
  selection of a standard-smooth chart with étale coordinate, packaged once in an opaque
  per-curve structure (`DiagonalChartData`, B5); `z ∈ 𝔇` since `Δ ∩ 𝔚 ⊆ D(1-ẽ)` (D1(c),
  via `Scheme.preimage_basicOpen` along `δ`); eqn `:= diagEqn (chartAt p)`.
- `z ∉ Δ`: member `:= Δᶜ` — open because `(δ C).left` is a **closed immersion**:
  `δ C ≫ snd C C = 𝟙` (`sectionOfPoint_snd`, `Rigidification.lean:93`), `𝟙` is a closed
  immersion, `(snd C C).left` is separated (base change of `C.hom` along `C.hom`, via the
  landed bridge `Over.isPullback_left`, `Cohomology/SectionsBaseChange.lean`, +
  `IsSeparated` base-change stability), and `IsClosedImmersion.of_comp`
  (`Morphisms/Separated.lean:229`) cancels. Eqn `:= 1`.
Ratio cases: diag–diag = D3; diag–off: `𝔇(U) ⊓ Δᶜ = basicOpen (diagEqn U)` **as opens**
(set-level `V(diagEqn) ∩ 𝔇 = Δ ∩ 𝔇` from the ideal-level D3 statement +
`Hom.support_ker`), so the restricted equation is a unit
(`RingedSpace.isUnit_res_basicOpen`, `Geometry/RingedSpace/Basic.lean:161`) and the ratio
against `1` is that unit; off–off: identical member `Δᶜ`, ratio `1`. `regular` for the off
member: germs of `1` are units (`IsUnit.mem_nonZeroDivisors`, pattern
`DivisorClass.lean:419`).

**D5 — Product charts are built in TWO-FACTOR generality, once.** For `X T : Over
(Spec (.of k))` and affine opens `U ⊆ X.left`, `V ⊆ T.left`, define
`𝔚 U V := (fst X T).left ⁻¹ᵁ U ⊓ (snd X T).left ⁻¹ᵁ V` and provide:
(i) `IsAffineOpen (𝔚 U V)` — via `pullback.map` of the open immersions being an open
immersion with range `fst⁻¹U ∩ snd⁻¹V` (`Scheme.Pullback.range_map`,
`PullbackCarrier.lean:350`), source affine
(`isAffine_of_isAffine_isAffine_isAffine`, `Pullbacks.lean:483`), and
`isAffineOpen_opensRange`;
(ii) the sections iso `Γ(U) ⊗[k] Γ(V) ≅ Γ(𝔚 U V)` with `tmul ↦ fst^♯·snd^♯`
computation rules and restriction naturality — engine:
`isIso_pushoutSection_of_isAffineOpen` (`Morphisms/Flat.lean:238`), template: the landed
`Over.sectionsBaseChange` (`Cohomology/SectionsBaseChange.lean`, whose one-open case
already massaged the same pushout API);
(iii) the **lift-app rule**: for `q : Z ⟶ X ⊗ T` in `Over` with `q ≫ fst = a`,
`q ≫ snd = b`, the map `(q.left).appLE (𝔚 U V) W' _` composed with the iso sends
`s ⊗ₜ t ↦ (a-pullback of s) · (b-pullback of t)` — proved once by ring-hom extensionality
through the pushout. This subsumes BOTH `δ C = lift (𝟙 C) (𝟙 C)` (D4b: app = `mul`) and
D4c's `lift (fst C T) (snd C T ≫ t)` (app sends `u⊗1−1⊗u ↦ fst^♯u − snd^♯t^♯u`).
D4c consumes (i)–(iii) verbatim with `X = C`, `T` the test object; D4b instantiates
`X = T = C`, `U = V`.

**D6 — the D4c interface (exported verbatim, part of the campaign's definition of
done).**
1. `diagonalLocalEquations` + simp lemmas for its `cover`/`eqn` fields (member and
   equation shapes as in D4, incl. `eqn = 1` off Δ).
2. The kernel presentation (D3 display) and the support/complement lemmas
   (`𝔇 ⊓ Δᶜ = basicOpen eqn`, `Δ = range (δ C).left` closed, the `p ↦ z` membership
   API of D4).
3. The regularity engine + germ helper of D2 (stated for arbitrary `A`, `b`).
4. The two-factor product-chart kit of D5 with the lift-app rule.
5. A ledger note in B5's commit spelling the intended `hreg` discharge: for
   `z ∈ g⁻¹ᵁ 𝔇(U)` with `g := (lift (fst C T) (snd C T ≫ t)).left`, pick an affine
   `V ∋ (snd _ _).left z` inside `t⁻¹(U)`-side data, shrink to `𝔚 U' V ∩ g⁻¹ᵁ 𝔇(U)`,
   rewrite the pulled equation by the lift-app rule to (the restriction of)
   `u ⊗ₜ 1 - 1 ⊗ₜ t^♯u`, apply the engine and the germ helper.

## Sub-bricks (dependency order; spec per brick, house format)

- **B0 [RING, Opus] — the diagonal-ideal ring core (~250 lines).** Pure
  `RingTheory`-imports file. Deliverables (a)–(c) of D1, exactly as stated there, plus
  `mul_k (u⊗1−1⊗u) = 0`, `mul_k ẽ = 0`. Decision left to the spec: work with
  `MvPolynomial (Fin 1) k` throughout vs. transport to `Polynomial k` early
  (`pUnitAlgEquiv`/`renameEquiv`); recommend transporting ONCE, in this brick, and
  exporting only `Polynomial`-shaped statements. No scheme imports. Independently
  verifiable.
- **B1 [RING, Opus] — the regularity engine (~150 lines).** D2's engine lemma + the
  `IsSMulRegular` bridge + the affine germ helper (this last needs scheme imports; if the
  spec prefers purity, split the germ helper into B4). Independent of B0.
- **B2 [GEO, FABLE] — two-factor product charts (~300–350 lines).** D5 (i)–(iii). The
  campaign's plumbing heart and its largest elaboration risk (the `⊗`/`Over`/`appLE`
  bookkeeping the recon flagged; `SectionsBaseChange`/`UniversalSections` are the scar
  tissue and the templates). Kernel discipline: opaque `def` for the chart, the iso, and
  the transported sections; named `tmul`-computation and restriction lemmas; never unfold
  the iso downstream.
- **B3 [GEO, Opus] — Δ is a closed subscheme; complement; membership API (~150
  lines).** D4's closed-immersion chain, the `Scheme.IsSeparated (C⊗C).left` instance
  glue, `Δᶜ` open, `p ↦ z` bookkeeping, `δ`-preimages of product charts and basic opens
  (`Scheme.preimage_basicOpen`).
- **B4 [MIX, FABLE] — the per-chart kernel computation (~250–300 lines).** Splice B0
  through B2 against `Hom.ker`: `ker_apply` on `𝔇(U)`; sections of the basic open as
  localization (`IsAffineOpen.isLocalization_basicOpen`, `AffineScheme.lean:659`); kernel
  of the localized `mul` via `IsLocalization.ker_map`
  (`RingTheory/Localization/Algebra.lean:52`); conclude the D3 display + the set-level
  support/complement lemmas (via `Hom.support_ker`). This brick owns "`app` of `δ` on the
  chart = `mul`" (one instance of B2(iii)).
- **B5 [MIX, Opus from a Fable-written spec] — assembly (~250–350 lines).**
  `DiagonalChartData` (the packaged choice: per point of `C.left` an affine
  standard-smooth chart + étale coordinate + `ẽ`-data, built from
  `exists_isStandardSmoothOfRelativeDimension` + `exists_etale_mvPolynomial` by the
  `StalksDVR` collapse pattern); the `PointedCover`; the four `LocalEquations` fields per
  D2/D3/D4 (incl. the regular-generators-unit-ratio mini-lemma); the D6 simp lemmas.
  Escalate to Fable only if B4's experience report flags kernel friction on the
  overlap calculus.

Dependencies: B0 ⟂ B1 ⟂ (B2, B3); B4 ← B0, B2, B3; B5 ← all. Launch order
B0 → B1 → B2 → B3 → B4 → B5 (cheapest de-risk first; B2 before B3 so the plumbing risk
surfaces early). One prover at a time.

**Staged fallbacks.** B0(a) fights ⇒ swap to the Nakayama fallback of D1 (B0 is then
"cotangent generator + Nakayama spreading", per-point members; B4/B5 adjust member
shapes, nothing else changes). B2(ii) balloons ⇒ acceptable staged landing: `U = V`
single-factor-pair version only (unblocks D4b; D4c's mixed version becomes a follow-up
brick, and the campaign is honest about D4c being blocked on it). B4's
`IsLocalization.ker_map` splice fights the `Γ(basicOpen)`-vs-`Localization.Away`
identification ⇒ restate the D3 display over `Localization.Away` and add a transport
lemma; the ratio argument (D3) survives verbatim since it only cites `map_ideal` +
`Ideal.map_span`.

## Discipline (inherited, binding)

The standing kernel rules (opaque defs + named restriction/≤-lemmas; no `rw`/`simp only
... at` over hypotheses mentioning concrete curve/Spec towers; abstract small-type lemmas
instantiated once; files ≤ 500 lines; `(kernel) deterministic timeout` ⇒ restructure;
lean_verify per keystone). Campaign-specific:
- ALL cross-chart comparisons go through `(δ C).left.ker` + `map_ideal` (D3). If a proof
  is comparing two charts' rings directly, it has left the designed route — stop and
  restate.
- Regularity is discharged ONLY by the B1 engine + germ helper (D2). If a proof reaches
  for integrality, stalk domains, or fibers, it has left the route.
- The `.left`-of-`⊗` vs `pullback` defeq is bridged ONLY by `Over.isPullback_left` and
  `inferInstanceAs` (the `Rigidity.lean:166` pattern); never unfold `tensorObj`.
- `Hom.ker_apply` produces `f.app U`-normal forms; the in-tree calculus is
  `appLE`-normal — fix one bridging lemma in B4 and rewrite in one direction only.
- Mathlib's `IdealSheaf` files are new (`module`-system, 2025): pin exact names in each
  spec at spec-writing time; expect line drift, not name drift.

## Acceptance

Per brick: kernel-green (target + root `lake build` by the prover holding the lock),
axiom-clean `[propext, Classical.choice, Quot.sound]` via lean_verify, no sorry,
committed with math-first message, blueprint node per the house LaTeX conventions.
Blueprint anchors: read-before-cite; candidates are the Stacks excerpts
(`\source{stacks-project}` — étale/unramified diagonal-idempotent and standard-smooth
material; mathlib's own `@[stacks 00T7]` tags on the cotangent lemmas are a lead) and
Hartshorne for the effective-Cartier framing — cite only on a verified match, else leave
unanchored. Campaign close = `diagonalLocalEquations` + the full D6 interface landed →
deg-D4c unblocked → roadmap `AJCR.picard.degree` advances. The rank-1 certificate
(recon G-D4.e) stays deferred; nothing here consumes it.

## Honest risks

1. **B2 is the balloon center.** `isIso_pushoutSection_of_isAffineOpen` was verified to
   exist with affine hypotheses on all three opens, but I could NOT verify by reading how
   its `pushout`-in-`CommRingCat` corner is most cheaply transported to a
   `TensorProduct`-shaped ring iso with usable `tmul` rules for TWO nontrivial opens
   (the landed `sectionsBaseChange` did it for one open + affine second factor, ~600
   lines of care). Budget B2 as the largest brick; its spec gets the full ζ2·i
   treatment.
2. **Unverified-by-reading seams** (each small, each a potential half-day): the exact
   `hUY`-shape `pushoutSection` expects for the open `𝔚 U V`; whether `pullback.map` of
   open immersions carries an `IsOpenImmersion` instance or needs assembly from
   `range_map` + composition; the `IsLocalization.ker_map` ↔ `Γ(basicOpen)` splice
   (fallback staged above); the `Scheme.IsSeparated (C⊗C).left` instance chain (all
   ingredients verified present, the composite instance is glue); `MvPolynomial (Fin 1)`
   ↔ `Polynomial` transport friction in B0.
3. **The étale-coordinate data is per-chart, chosen, and must be FROZEN in one opaque
   structure** (B5's `DiagonalChartData`). If specs let each brick re-extract charts, the
   eqn/member/kernel lemmas will not be about the same objects — the classic assembly
   failure mode. B0–B4 must be stated over an ABSTRACT `(B, g, ẽ)` package; only B5
   instantiates it on the curve.
4. **What I could not verify at all by reading:** that no hidden universe/instance
   friction arises from `IdealSheafData` being keyed on `X.affineOpens` subtypes while
   the in-tree covers use raw `X.Opens` with separate `IsAffineOpen` proofs — the
   coercion bookkeeping is untested in-tree. First contact is B4; its spec should start
   with a 20-line smoke test (state `ker_apply` for one concrete affine open of a Spec).
5. Scheme-level `SmoothOfRelativeDimension` remains chart-existential only
   (`Morphisms/Smooth.lean`, class at `:135`; `HasRingHomProperty ... (Locally
   IsStandardSmoothOfRelativeDimension)` exists) — fine for this route, which only ever
   consumes one chart per point; no scheme-level differentials are needed anywhere.
