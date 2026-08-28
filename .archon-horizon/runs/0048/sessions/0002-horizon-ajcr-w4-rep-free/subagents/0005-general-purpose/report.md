## SUMMARY

`divFunctor` is **not** pinned to any honest relative-effective-divisor functor. It is *defined* as the `DivFamZar` vehicle, and unfolds (definitionally, in four steps) into `IsCertified` — so it represents exactly what the certificate clauses allow. There is no `divRep` theorem in the Lean at all: both representability packagings are conditional structures with no producer. The blueprint contains no node for any of this.

---

## QUESTION A

### A1. Locations and verbatim definitions

All paths under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`.

**`divFunctor`** — `AlgebraicJacobian/Picard/DivisorFamilyZarFunctor.lean:45-54` (the only definition; the name occurs nowhere else except `DivSchemeAbel.lean:302`, `DivRepKit.lean:115`, and comments):

```lean
noncomputable def divFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u where
  obj T := divFamZar C π n T.unop
  map g := ↾divFamZar.map C π n g.unop
  map_id T := by
    ext s U
    exact congrArg (fun z : divFamZar C π n T.unop => z.1 U) (divFamZar.map_id C π n s)
  map_comp {T T' T''} g h := by
    ext s U
    exact congrArg (fun z : divFamZar C π n T''.unop => z.1 U)
      (divFamZar.map_comp C π n g.unop h.unop s)
```

**`divRep` — DOES NOT EXIST as a Lean declaration.** The full set of `divRep*` identifiers in `AlgebraicJacobian/` is: `divRepPullAt`, `divRepPullAt_id/_comp`, `divRepPullAtZar`, `divRepPullAtZar_id/_comp/_toZar`, `divRepClassifyZar`, `divRepClassifyZar_isDivRepClassify`, `divRepClassifyZar_eq_of_isDivRepClassify`. The bare `divRep` appears only inside doc comments. The only `RepresentableBy` statement against `divFunctor` is **conditional**, at `AlgebraicJacobian/Picard/DivRepKit.lean:68-120`:

```lean
structure DivRepGlobalData where
  pull : ∀ {T : Over (Spec (CommRingCat.of k))},
    (T ⟶ DivOver) → divFamZar C pi g T
  classify : ∀ {T : Over (Spec (CommRingCat.of k))},
    divFamZar C pi g T → (T ⟶ DivOver)
  classify_pull : ∀ {T : Over (Spec (CommRingCat.of k))} (v : T ⟶ DivOver),
    classify (pull v) = v
  pull_classify : ∀ {T : Over (Spec (CommRingCat.of k))} (F : divFamZar C pi g T),
    pull (classify F) = F
  pull_comp : ∀ {T T' : Over (Spec (CommRingCat.of k))} (f : T' ⟶ T)
    (v : T ⟶ DivOver),
    pull (f ≫ v) = divFamZar.map C pi g f (pull v)
...
noncomputable def representableBy
    (D : DivRepGlobalData hpi g r1 r2 b1 b2) :
    (divFunctor C pi g).RepresentableBy DivOver where
```

with `local notation "DivOver" => divSchemeOver k (windowS_choice pi hpi g • fiberWeilDivisor pi) …` (line 60-63). The file header says so explicitly (`DivRepKit.lean:18-19`): *"The affine-to-general lift is intentionally not assumed to exist implicitly: a caller must provide every field of `DivRepGlobalData`."* **`DivRepGlobalData` is never instantiated anywhere in the project** (grep: only its own definition site). The affine-level analogue `DivRepAffinePullback` (`AlgebraicJacobian/Picard/DivRepAffKit.lean:167-178`) is likewise a hypothesis-bundle with no producer.

**`DivScheme`** — `AlgebraicJacobian/Picard/DivScheme.lean:144-145` (plus `divSchemeOver` at 156-157):

```lean
noncomputable def DivScheme : Scheme :=
  carveScheme k g r₁ r₂ (divCarveMul k A B r₁ r₂ b₁ b₂)
...
noncomputable def divSchemeOver : Over (Spec (CommRingCat.of k)) :=
  carveSchemeOver k g r₁ r₂ (divCarveMul k A B r₁ r₂ b₁ b₂)
```
i.e. the closed subscheme of a Grassmannian pair cut by `carveIdealSheaf` (`DivScheme.lean:54-65`). Nothing about divisors enters its definition.

**`DivFamZar`** — `AlgebraicJacobian/Picard/DivisorFamilyZar.lean:224-235`:

```lean
def divFamZarSetoid : Setoid {d : (relCurve C R).LocalEquations //
    IsLocallyCertified C R π n d} where
  r d₁ d₂ := Scheme.LocalEquations.DivEq d₁.1 d₂.1
  ...
def DivFamZar : Type u := Quotient (divFamZarSetoid C R π n)
```

**`IsLocallyCertified`** — `AlgebraicJacobian/Picard/DivisorFamilyZar.lean:71-80`:

```lean
def IsLocallyCertified (n : ℕ) (d : (relCurve C R).LocalEquations) : Prop :=
  ∃ (m : ℕ) (g : Fin m → R), Ideal.span (Set.range g) = ⊤ ∧
    ∀ i : Fin m,
      haveI : IsOpenImmersion (relCurveMap C R (Localization.Away (g i))) := …
      ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n,
        Scheme.LocalEquations.DivEq G.eqns
          (d.pullback (relCurveMap C R (Localization.Away (g i))) …)
```

**`IsCertified`** — `AlgebraicJacobian/Picard/DivisorFamily.lean:426-441`:

```lean
structure IsCertified (n : ℕ) : Prop where
  finite_colength : ∀ j, Module.Finite R (A.colength j)
  projective_colength : ∀ j, Module.Projective R (A.colength j)
  finite_glued : Module.Finite R A.Glued
  projective_glued : Module.Projective R A.Glued
  rankAtStalk_glued : ∀ p : PrimeSpectrum R, Module.rankAtStalk A.Glued p = n
  flat_coker_incl : Module.Flat R (A.chartProd ⧸ A.gluedSubmodule)
  flat_coker_diff :
    Module.Flat R (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight))
```

and `CertifiedDivisorFamily` (`DivisorFamily.lean:452-458`):

```lean
structure CertifiedDivisorFamily [IsAffineHom π] : Type u where
  eqns : (relCurve C R).LocalEquations
  adaptation : DivisorAdaptation C R π eqns
  certified : adaptation.IsCertified n
```

### A2. The definitional chain — `divFunctor` **does** unfold to `IsCertified`

```
divFunctor.obj T                                    [DivisorFamilyZarFunctor.lean:46]
  ≡ divFamZar C π n T.unop
  ≡ {s : Π U : T.left.affineOpens, DivFamZar C Γ(T.left,U.1) π n // compat}
                                                    [DivisorFamilyZarVehicle.lean:187-190]
  DivFamZar C R π n
  ≡ Quotient (divFamZarSetoid …) over {d : LocalEquations // IsLocallyCertified C R π n d}
                                                    [DivisorFamilyZar.lean:224-235]
  IsLocallyCertified n d
  ≡ ∃ span-⊤ (g : Fin m → R), ∀ i, ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n,
        DivEq G.eqns (pulled d)                     [DivisorFamilyZar.lean:71-80]
  CertifiedDivisorFamily.certified : DivisorAdaptation.IsCertified n
                                                    [DivisorFamily.lean:452-458 → 426-441]
```

So membership in `divFunctor.obj T` **requires**, for each affine open of `T` and each member of some span-⊤ cover of its section ring, a `DivisorAdaptation` whose colength modules satisfy (c1)–(c4). It is `DivFamZar`-like certified families by definition. `divFamZarAffineEquiv` (`DivisorFamilyZarVehicle.lean:300-304`) confirms the value on affine tests is `DivFamZar C R π n` on the nose.

The only "honest" ingredient in the chain is the underlying `d : LocalEquations` (`AlgebraicJacobian/Picard/DivisorClass.lean:112-127`), which *is* the standard datum of an effective Cartier divisor (pointed cover, germwise-regular local equations, unit overlap ratios), documented as such at `DivisorClass.lean:107`. Everything above `d` is certificate data.

### A3. Bridges to a mathematically standard notion

**Field-valued tests: yes, a full bridge exists.**

- `AlgebraicJacobian/Picard/DivisorFamilyFieldSurj.lean:162-167`:
```lean
noncomputable def divFamFieldEquiv :
    DivFam C K π n ≃
      {D : (relCurve C K).CurveDivisor //
        0 ≤ D ∧ Scheme.CurveDivisor.deg K D = (n : ℤ)} :=
  divFamFieldEquivOfDegOfSurj (fun F => deg_divFamDivisor F)
    (fun D hD hdeg => exists_divFam_divFamDivisor_eq D hD hdeg)
```
  Its two halves: `deg_divFamDivisor` (`DivisorFamilyFieldCRT.lean:376`, certified ⇒ degree `n`) and `exists_divFam_divFamDivisor_eq` (`DivisorFamilyFieldSurj.lean:147-149`, every effective degree-`n` Weil divisor is certified), which rests on `DivisorAdaptation.isCertified_of_deg` (`DivisorFamilyFieldSurj.lean:104`, over a field *any* adaptation of a degree-`n` system is certified — every module is free).
- Transfer to the `DivFamZar` layer: `DivFam.toZar_injective` (`AlgebraicJacobian/Picard/DivRepClassifyZarKit.lean:66-72`) and `DivFam.exists_toZar_eq` (`AlgebraicJacobian/Picard/DivSchemeAbel.lean:77-78`, "over a field `toZar` is surjective"). So **at field-valued tests** `DivFamZar C K π n ≅ DivFam C K π n ≅ {effective degree-n Weil divisors}` — the certified functor is provably the honest one there.
- A genuine colength↔geometry identity, also field-only: `DivisorAdaptation.deg_presentationDivisor` / `IsCertified.deg_presentationDivisor` (`DivisorFamilyFieldCRT.lean:365`), `deg K (div d) = finrank K W(d)`.

**General base: no bridge whatsoever.** I searched for `EffectiveCartier`, `IsEffective`, `relative effective`, `finite flat`, `IdealSheafData` applied to a divisor family, identifications of `A.Glued`/`gluedSubmodule` with `Γ(𝒪_{C_R}/I_d)`, and iff-characterizations of `IsCertified`. Findings:
- No `EffectiveCartierDivisor`/mathlib divisor structure is ever used on the relative curve; the only hits for "effective Cartier" are the prose docstrings of `LocalEquations` (`DivisorClass.lean:9,11,107`) and a header remark in `DivSchemeRelDivisor.lean:21` (that file contains only the module lemmas `Module.exists_subsingleton_away_of_residueField_tmul` etc. — no divisor object).
- There is **no theorem** identifying `A.Glued` (= `W(d)`, the Čech equalizer of chart colengths) with the sections of `𝒪_{C_R}/I_d`, and none saying `IsCertified n` ⟺ "the subscheme cut by `d` is finite flat of rank `n` over `R`". `IsCertified` is a module-theoretic surrogate that has never been reconciled with the scheme-theoretic notion outside the field case.
- No producer of a certified/locally-certified family from any honest geometric input over a general base. In particular the graph/diagonal divisor exists as an honest object — `Over.graphLocalEquations` (`AlgebraicJacobian/Curve/GraphDivisor.lean:236`) — and is **never** shown to be (locally) certified; it is precisely I-0213's counterexample.
- What *is* proved, in the negative direction, are two obstruction theorems showing the certificate route is geometrically restrictive:
  - `DivisorAdaptation.isClosed_supportLocus_inter_chart_of_forall_noLeak` and its contrapositive `not_forall_noLeak_of_not_isClosed_chart₀/₁` (`AlgebraicJacobian/Picard/DivSchemeCertZarChartTrace.lean:126,154,164`) — the assembler's per-piece no-leak clause **forces** `supportLocus ∩ V₀` and `supportLocus ∩ V₁` to be closed, a property of the system and the two pinned charts alone.
  - `DivisorAdaptation.supportLocus_disjoint_chart_inter_of_separated` (`AlgebraicJacobian/Picard/DivSchemeCertZarSep.lean:201`) — support-separated adaptations force the support out of `V₀ ∩ V₁`.
  These bound the known *routes* to certification; **neither is a Lean proof that `IsLocallyCertified` is strictly weaker than honest relative effectivity.** That claim exists only as inbox prose (I-0213's diagonal counterexample, I-0327's `V(t x² + xy + t y²)` counter-model). I could not find it formalized.

**Verdict for A:** the certified functor is free-floating over a general base. It is anchored to standard mathematics only at field-valued points.

### A4. Blueprint

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/` contains `AbelianVariety, Albanese, Algebra, BaseChange, Challenge, Cohomology, Curves, Jacobian, PicardEtale, RiemannRoch, Tangent`. Grepping all of `blueprint/src` and `blueprint/lean_decls` for `divFunctor`, `divRep`, `DivFamZar`, `DivFam`, `IsCertified`, `DivScheme`, `carve`, `Grassmann`, `certified` returns **zero hits**. The blueprint's representability material is entirely about `pic0Functor` (`chapters/Jacobian.tex:17` "The representability datum", `def:jacobian_data`; `chapters/PicardEtale.tex:10677` `def:pic0RepresentableByOfCharts`), and its `LocalEquations` nodes are the field-level Riemann–Roch ones (`chapters/RiemannRoch.tex`). So the blueprint **does not state divisor-functor representability at all** — it neither pins it to the honest functor nor overclaims relative to the Lean; the whole DAT-D/DD-R divisor layer is undocumented in the blueprint.

The mathematical statement lives only in the informal spec, `informal/spec-dd-r.md:272`:
> `divRep : (divFunctor g).RepresentableBy (divSchemeOver g)` — homEquiv forward = pullback of the universal family (`DivFam.mapAlg` + vehicle), backward = `ε` + `divClassifyAff` glued over `T.left.affineOpens`…

restated at `informal/spec-dd-r.md:375-381` (Addendum 1) against `DivFamZar`. That spec is where the overclaim risk sits, not the blueprint.

---

## QUESTION B — inbox

`horizon inbox show` is not a subcommand; used `horizon inbox list --json` (327 items) and selected by id.

### I-0213 (kind `issue`, **status `closed`**, created 2026-07-17, updated 2026-07-24)

**Does it concede the certified functor is a proper subfunctor of the honest divisor functor? — Yes, explicitly, for the *globally* certified functor `DivFam`. For the *locally* certified repair `DivFamZar` it asserts faithfulness rather than proving it.**

Title line, verbatim:
> ADJUDICATION — the DAT-D functor pin's global certificate is WRONG: currently-pinned divFunctor is representable by NO scheme; the locally-certified repair is frozen (spec-dd-2 Addendum 2). DD-R lane: DDR-9 must restate divRep against DivFamZar.

The counterexample and the concession, verbatim:
> THE COUNTEREXAMPLE (campaign-central): R = Γ(C minus a point off the 0/infinity fibers); d = the DIAGONAL section of C_R (the campaign's own graph-divisor, AJCR.picard.degree.graph), a degree-1 relative effective divisor. Every piece P inside one pinned chart has Z-trace = Delta(U_P) with U_P a PROPER open of the CONNECTED Spec R, and (c1) forces U_P clopen, hence empty — **NO globally certified adaptation of d exists**, while d IS certifiable over each member of a small basic-open cover of Spec R (the diagonal locally stays in one chart). Therefore: (1) certified families over a base cover can glue to a non-certifiable family — the S5 conditional keystone's hcert is UNSATISFIABLE in general and the W-idempotent brick cannot fix it (here W = R, no idempotents); (2) **DivFam (globally certified) satisfies separation but NOT gluing — it is not a Zariski sheaf, so no scheme represents the pinned divFunctor, and DDR-9's divRep as currently stated is unprovable.** Independently, the divRep forward map 'pull the universal family' is ill-defined for test maps not landing in one chart member — same phenomenon from the other side.

Note the phrase "a degree-1 relative **effective divisor**" for an object with no global certificate: that is the concession that global certification is strictly stronger than honest relative effectivity.

The repair, and the (unproved-in-Lean) faithfulness claim:
> THE REPAIR (faithful to Kleiman df:red/lm:ctn, where divisor-flatness is Zariski-LOCAL on the base): the functor value is the LOCALLY-certified quotient DivFamZar n R := {d : LocalEquations // IsLocallyCertified n d}/DivEq, with IsLocallyCertified = exists finite span-top (g : Fin m -> R) and per-i a CertifiedDivisorFamily over Localization.Away (g i) whose eqns are DivEq to the pulled d … CertifiedDivisorFamily/DivFam remain THE building block; over a field the two notions agree (trivial cover), so ALL DD-4 (epsilon/windows/mono), DD-1c field dictionary, DAT-B field-level material is UNAFFECTED.

Comment C-0002 (horizon, run 0045, 2026-07-23), the closing note:
> Resolved: the divisor-family functor now uses the locally certified quotient `DivFamZar`, so the diagonal counterexample no longer invalidates the pinned functor; `divFunctor` is packaged on arbitrary tests with affine values `DivFamZar`. The repair landed in `DivisorFamilyZar.lean`, `DivisorFamilyZarGlue.lean`, `DivisorFamilyZarVehicle.lean`, and `DivisorFamilyZarFunctor.lean` (commit `4ba24d834` for S6b; full root build reported green at 8959 jobs, these sources contain no `sorry`). **Global `divRep` remains downstream and is not claimed complete here.**

Comment C-0001 (human, 2026-07-17): DD-R lane ACK, "DDR-9 restated against DivFamZar in spec-dd-r Addendum 1 (commit c5368c82a) … we consume IsLocallyCertified/DivFamZar/toZar/mapAlgZar/exists_glue_of_away_compat/eq_of_away_eq verbatim and will sign off on the S6 divFunctor spelling before your freeze".

### I-0209 (kind `memory`, open) — the Z-clopen certificate principle

> A DivisorAdaptation piece carries an R-finite-projective colength — clause (c1) of IsCertified — IFF the piece's trace on the divisor scheme Z = V(D) (finite flat over Spec R) is CLOPEN in Z. Any construction that slices Z along the base … produces section rings like R_u that are NOT finite over R, and the certificate is unrecoverable — the localization-span descent lemmas' hypotheses are FALSE, not merely hard. Canonical counterexample: R = k[u], zero-section divisor, cleared piece D(u-tilde): colength = R_u.

Comment C-0001 (2026-07-25, run 0047) — the scope amendment:
> No longer true: the operational reading that this leaves the certificate unreachable and therefore **blocks** DD-R. … The escape is a different predicate, not a different piece decomposition: **localize the BASE, not the pieces.** Over `Localization.Away r` the system is certified in the ordinary global sense for that ring, and `IsLocallyCertified` (`DivisorFamilyZar.lean:71`) — the only thing the consumers `divRepPullAt`, `DivRepAffinePullback.pull`, `divRepClassifyZar` ever take — is exactly a span-top family of such base localizations.

Comment C-0002 (2026-07-25, run 0048) ties it to `DivisorAdaptation.isClosed_supportLocus_inter_chart_of_forall_noLeak`.

### I-0320 (memory, open) — "THE DD-R CERTIFICATE GATE WAS OVER-STRONG FOR ~7 SESSIONS"

> NO CONSUMER EVER NEEDED THAT. Every DD-R consumer goes through `DivFamZar` (DivisorFamilyZar.lean:242), whose membership predicate is `IsLocallyCertified` (DivisorFamilyZar.lean:71) … Check the chain: divRepPullAt (DivRepAffKit.lean:90), DivRepAffinePullback.pull (:168), divRepClassifyZar (DivRepClassifyZar.lean:244) — all take DivFamZar, never IsCertified over R.
> RULE: … The project has both a global (IsCertified) and a Zariski-local (IsLocallyCertified) notion, and the downstream interfaces were built on the local one.

### I-0323 (memory, open) — separated adaptations cannot certify

> WHY IT DOES NOT CLOSE THE LANE. The premise is essentially always FALSE. Proved as DivisorAdaptation.supportLocus_disjoint_chart_inter_of_separated (same file) … Hence separation holds only if supp d avoids V0 cap V1, i.e. the divisor is confined to the two vertical fibres of pi. Refining the cover cannot help; the pointwise gate cannot help either (shrinking the base deletes fibres, it does not move a support point out of the overlap); and supportLocus is DivEq-invariant, so re-spelling d cannot help.
> ALREADY KNOWN FOR THE FIELD CASE … That escape is unavailable over a nonreduced base, which is exactly why the flat-cokernel content stands.

### I-0327 (memory, open) — the no-leak clause is a chart-design condition

> the assembler's hnoLeak at every piece ==> supportLocus cap V_0 and supportLocus cap V_1 are CLOSED in the relative curve. `DivisorAdaptation.isClosed_supportLocus_inter_chart_of_forall_noLeak` … The conclusion mentions neither the adaptation nor its pieces — only the system and the two pinned charts.
> 3. THE OBLIGATION IS: the chart's divisors avoid both vertical fibres of pi, i.e. supportLocus subset V_0 cap V_1. **It is FALSE for a general degree-g divisor** — model: V(t x^2 + x y + t y^2) in P^1 over k[t] has a DOMAIN section ring (no nontrivial idempotent after any base shrink) and fibre {0, infinity} at t = 0, **so no adaptation of it can ever be certified.** The DD-R atlas must arrange the avoidance.
> 2. SHRINKING THE BASE CANNOT HELP EITHER, except by restating the same condition over the smaller base.

That last item is the sharpest statement bearing on your question: it asserts (in prose; the Lean theorem proves only the necessity of closed chart traces for the assembler's clause) that an honest degree-`g` relative divisor exists which **no** adaptation can certify, and that base-shrinking — i.e. passing from `IsCertified` to `IsLocallyCertified` — does not evade it.

---

## WHAT I COULD NOT FIND

- No Lean declaration named `divRep`; no unconditional `RepresentableBy` for `divFunctor`; no instantiation of `DivRepGlobalData` or `DivRepAffinePullback`.
- No Lean theorem relating `IsCertified`/`IsLocallyCertified` to an effective relative Cartier divisor, a finite flat closed subscheme, or `𝒪_{C_R}/I_d`, over any base other than a field.
- No Lean formalization of the I-0213 diagonal counterexample or the I-0327 `V(tx²+xy+ty²)` counter-model — both are inbox prose only.
- No blueprint node mentioning `divFunctor`, `DivFamZar`, `DivScheme`, `IsCertified`, or the carve locus.
