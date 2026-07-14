# Wave-2b χ-ledger / RR-lite reconnaissance (`AJCR.w2-chi.*`)

*Read-only recon, 2026-07-14. Produced for the orchestrator to write the ledger/RR brick specs
directly. Every project signature below is verbatim from the tree with `file:line`; every mathlib
API was re-grepped in `.lake-packages/mathlib` (v4.31.0) this session. Nothing in the Lean tree
was edited; `lake`/LSP were not run. Scope: the two roadmap leaves `AJCR.w2-chi.ledger`
(χ(L) − χ(L(-x)) = 1) and `AJCR.w2-chi.rr` (χ(L(D)) = 1 − g + deg D, h⁰ bounds); `AJCR.w2-chi.carrier`
is marked done — see §1 for the audit of that claim.*

---

## 0. Headline

- **Nothing of the χ-ledger / RR-lite is implemented.** No `RiemannRoch/` directory exists; none of
  `divisorSheaf`, `CurveDivisor`, `residueDeg`, `ord`, skyscraper transport, `devissageSES`,
  `chi_divisorSheaf`, `classDeg`, `DedekindColength`, `toDivisor` occurs anywhere in
  `AlgebraicJacobian/`. The 2026-07-13/14 sessions were the **(C1) étale-separatedness campaign**
  (`CoherentWitness*`, `EtaleSeparatedness`), orthogonal to Wave-2b.
- **The binding design `chi-ledger-design.md` (divisor-first) and the roadmap item text
  (twisted-two-cover) describe two mutually-exclusive routes for the carrier of `𝒪(D)`/`L`.** This
  is the central thing the orchestrator must resolve before launching. See §1.3.
- The **cohomology substrate the divisor-first design assumes is fully landed and verbatim-intact**
  (HModule/HModule', affine vanishing, MayerVietoris, TwoCover, Finiteness base case,
  SectionsBaseChange). The **point/divisor substrate is only partially present** (DVR stalk facts
  landed; the valuation-order / `residueDeg` / function-field layer is absent). The **L2 junction
  infra** the class-level (E-i)–(E-iv) need (`toDivisor`, meromorphic ∃-bridge, graph rank-1
  certificate) does **not** exist.

---

## 1. Staleness audit

### 1.1 `chi-ledger-design.md` (2026-07-11, 780 lines) — **STRUCTURALLY SOUND, 0 % IMPLEMENTED, cohomology assumptions intact, divisor/L2 assumptions partly unmet**

Route summary of the doc: `𝒪(D)` = subsheaf of the constant function-field sheaf cut by stalkwise
valuation bounds (decision X1); divisor = `Finsupp` on closed points, residue-degree-weighted `deg`
(X2); dévissage by **skyscraper SES in whole-site Ext**, twisted-two-cover declared MOOT (X3);
`deg(div f)=0` via the multiplication iso (X4); 11 files R1–R11 in 4 parallel lanes (§7).

**What still holds (re-verified this session):**

| Design claim | Status in tree / mathlib (this session) |
|---|---|
| `Sheaf.HModule F n = Abelian.Ext (constModuleSheaf) F n` is the cohomology carrier | HOLDS verbatim, `ModuleKSheaf.lean:74`. |
| `Sheaf.HModule'` is whole-site Ext from the free sheaf on `U` (restricted isos don't act on it) | HOLDS, `OverOpen.lean:269`. |
| affine vanishing is **structure-sheaf-only** (`cokernel_app_surjective` manipulates Γ of `moduleKSheaf`) | HOLDS, `AffineVanishing.lean:180,310`. This is the fact that makes the twisted route expensive. |
| `twoCoverH1LinearEquiv` is general-coefficients "reusable for twisted sheaves" | HOLDS, `TwoCover.lean:92`; but requires `Subsingleton (HModule' F Vᵢ 1)` which is landed only for `F = moduleKSheaf`. |
| covariant Ext LES available | HOLDS: `covariant_sequence_exact₁'/₂'/₃'`, `ExactSequences.lean:63,84,103` (used at `AffineVanishing.lean:71`). |
| skyscraper injective-sheaf route: `stalkSkyscraperSheafAdjunction` + `Injective.injective_of_adjoint` + landed `subsingleton_one_of_injective_of_surjective` | HOLDS: `Skyscraper.lean:400`, `Injective/Basic.lean:195`, `AffineVanishing.lean:62`. |
| Dedekind colength engine: CRT + DVR filtration | HOLDS: `IsDedekindDomain.quotientEquivPiOfProdEq` (`DedekindDomain/Ideal/Lemmas.lean:920`), `quotientRangePowQuotSuccInclusionEquiv` (`RamificationInertia/Basic.lean:410`), `sum_ramification_inertia` (`:596`). |
| order vocabulary `HeightOneSpectrum.valuation/intValuation : Valuation … ℤᵐ⁰` | HOLDS: `AdicValuation.lean:327,169`. |
| `χ(𝒪) = 1 − g`: landed `Γ(C,𝒪) ≅ k` + `genus` spelling + landed `Module.Finite k H¹` | HOLDS: `Sections.lean:161`, `Challenge.lean:89`, `Finiteness.lean:388`. |
| OPEN-4 (`SectionsBaseChange` for affine `V`) would land concurrently | **RESOLVED**: landed as `Over.sectionsBaseChange`/`…OfIsAffineOpen`, `SectionsBaseChange.lean:287,295`. |

**Corrections to the doc (staleness, all cosmetic-to-moderate):**

1. **Line references are 1–70 off** (the tree moved since 2026-07-11), e.g. the doc cites
   `HModule.linearEquiv₀` at `ModuleKSheaf.lean:151` (actual `:152`),
   `subsingleton_one_of_injective_of_surjective` at `AffineVanishing.lean:61` (actual `:62`),
   `HModule'` at `OverOpen.lean:268` (actual `:269`), `Γ(C,𝒪)≅k` at `Curve/Sections.lean:94`
   (actual: the iso *instance* `isIso_hom_appTop_of_geometricallyReduced` is at `:161`, the
   bijectivity theorem at `:95`), `twoCoverH1LinearEquiv` at `TwoCover.lean:91` (actual `:92`),
   `moduleFinite_hModule_one` at `Finiteness.lean:387` (actual `:388`). Use §2's table, not the
   doc's numbers.
2. **The doc's L2 asks (§3.3) are UNMET.** It requests from L2: (i) `MeromorphicTrivialization`
   ∃-form bridge, (ii) `GraphDivisor` rank-1 certificate, (iii) consume `DivisorClass`. Only (iii)
   partially exists: `Picard/DivisorClass.lean` has `LocalEquations`/`picClass`/`mul`/`rescale`
   (§2.5). There is **no** `MeromorphicTrivialization.lean`, no `GraphDivisor`, no `toDivisor`. So
   R11 (the class-level (E-i)–(E-iv) junction) is blocked on L2 infra that has not been built.
3. **The point layer the doc's R2/R3 build on is only half-present.** `Curve/StalksDVR.lean` gives
   `ValuationRing`/DVR stalk facts and `specializes_eq_genericPoint_or_eq`, but there is no
   `isDiscreteValuationRing_stalk` exported for closed points, no `stalkHeightOne`, no `ord`,
   `ordUnits`, `residueDeg`. These are genuine new work (§3 gaps G-B1).
4. **(C1)-campaign landings changed no assumption of this doc.** The 07-13/07-14 work is disjoint;
   `DivisorClass.lean` is now imported by the aggregator, and the tree is sorry-clean outside the
   13 protected `Challenge.lean` targets, so the design lands against a green base.

**Verdict — `chi-ledger-design.md`: NOT STALE as a design; STALE only in line-numbers and in the
optimistic assumption that L2 junction infra would be there. The divisor-first route it pins is
internally coherent, its cohomology substrate is landed verbatim, and its mathlib gifts all still
verify. It should remain the binding design for the ledger/RR — modulo the roadmap conflict in
§1.3.** Keep; re-anchor line numbers from §2; treat R11/(E-i)–(E-iv) as L2-blocked.

### 1.2 `chi-ledger-notes.md` (2026-07-11, 53 lines) — **SUPERSEDED (subsumed by the design doc, still factually correct)**

Pre-design scouting note. Its three "honest options" (slice-Ext comparison / re-run Serre cobounding
/ divisor-first) and its "recommended shape" were **adopted and confirmed** by `chi-ledger-design.md`
(which cites it as "option 3 confirmed, with two corrections"). Its ground-truth facts still verify
(HModule' = whole-site Ext; affine vanishing structure-sheaf-only; `twoCoverH1LinearEquiv` general-
coefficients). **Verdict: redundant with the design doc; read it only for the "why not twisted"
rationale. Its one now-overturned suggestion — the `π : C → ℙ¹` order-sum route for
`deg(div f)=0` — was explicitly replaced by the design's multiplication-iso argument.** No action
beyond noting it is subsumed.

### 1.3 ⚠ Roadmap ↔ design conflict (**the decision the orchestrator must make first**)

The roadmap items (authored **2026-07-14**, i.e. *after* the design) describe the **twisted-two-cover
route**, which the binding design **explicitly rejected and declared MOOT**:

- `AJCR.w2-chi` summary: "the two-cover Čech carrier … where the curve-level Čech cohomology of
  Wave 1 is EXTENDED from `O_C` to **all line bundles** … the **twisted two-cover carrier is already
  landed as input**."
- `AJCR.w2-chi.carrier` (status **done**): "The two-affine-cover H⁰/H¹ carrier for a **line bundle
  presented by a transition unit**; landed with Wave 1 as the input to the ledger."
- `AJCR.w2-chi.ledger` (pending): "the long-exact six-term (0,1)-slice for `0 → L(-x) → L →
  skyscraper → 0` **on the two-cover carrier**, giving χ(L) − χ(L(-x)) = 1."
- `AJCR.w2-chi.rr` (pending): "χ(L(D)) = 1 − g + deg D; … h⁰ bounds."

Against this, `chi-ledger-design.md` decision **X3** and §10 deviation 3: *"No twisted affine
vanishing, no slice-Ext comparison, no Mayer–Vietoris for any sheaf other than 𝒪 — anywhere in the
lane. The wave3 §6.1 coordination note about equalizer-presented twisted sheaves `F_g` is MOOT."*
And §2.2(a) rejects the twisted route as needing a mathlib-PR-grade prerequisite on the critical
path of every χ statement.

Where the roadmap text comes from: `wave3-picard-design.md §6.1` (lines 715–721) pins exactly the
twisted framing — feed the equalizer sheaf `F_g(W) := {(s₀,s₁) | s₀ = g·s₁ on W ⊓ V₀ ⊓ V₁}` to
`twoCoverH1LinearEquiv`, claiming the vanishing `Subsingleton (HModule' F_g Vᵢ 1)` "transports along
`F_g|Vᵢ ≅ 𝒪|Vᵢ` … by construction, so no new affine-vanishing engine is needed." **The design doc's
whole §2 argues this transport is false** (a restricted iso does not act on whole-site Ext, so the
vanishing does *not* transport for free; `HModule'` is Ext from the *free sheaf on `U`*, not slice
cohomology — `OverOpen.lean:269`).

**Assessment of "carrier done".** The only thing actually landed that the carrier item can point to
is `Scheme.twoCoverH1LinearEquiv` (`TwoCover.lean:92`), which *is* general-coefficient. But it takes
the two `Subsingleton (HModule' F Vᵢ 1)` **as instance hypotheses**, and for a genuinely twisted `F`
those instances **do not exist in the tree** — only the structure-sheaf affine vanishing
(`subsingleton_moduleKSheaf_hModule'_one`, `AffineVanishing.lean:310`) is proved. So "twisted two-cover
carrier landed as input" is **half-true**: the *general-coefficient equiv* is landed; the *twist-
specific vanishing input it needs* is not, and the binding design argues it is not cheap.

> **ORCHESTRATOR ACTION.** Pick one and re-word the other:
> - **(Recommended) divisor-first** per `chi-ledger-design.md`: `L = 𝒪(D)` is a function-field
>   subsheaf; the `0 → 𝒪(D) → 𝒪(D+x) → sky → 0` SES lives in whole-site Ext (not "on the two-cover
>   carrier"); `H¹(sky)=0` via the skyscraper-injective route (no twisted vanishing). Re-word the
>   roadmap summaries to drop "on the two-cover carrier" / "presented by a transition unit". The
>   two-cover is used **only** for `H¹(𝒪)` finiteness/base-change (already landed).
> - **Twisted-two-cover** per the roadmap text: then an extra hard gap must be added first — either
>   the slice-Ext comparison `Ext^n_{Sh(X)}(j_! A, F) ≃ Ext^n_{Sh(U)}(A, F|_U)` (mathlib-PR grade)
>   or a re-run of Serre cobounding generalized beyond `moduleKSheaf`. The design rejected both as
>   off-critical-path. Not recommended.

The gap list (§3) and the draft brick (§4) are written for the **divisor-first** route.

---

## 2. Exact API map (verbatim signatures + `file:line`)

Paths are under `…/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/`. All files are imported
by the aggregator `AlgebraicJacobian.lean` (Cohomology block lines 14–22; `Picard/DivisorClass`
line 33). Tree is sorry-clean outside the 13 protected `Challenge.lean` targets.

### 2.1 Cohomology carrier — `Cohomology/ModuleKSheaf.lean` (285 lines)

```lean
-- :66  the constant sheaf of R-modules (Ext out of it = sheaf cohomology)
noncomputable def constModuleSheaf : Sheaf J (ModuleCat.{u} R) :=
  (constantSheaf J (ModuleCat.{u} R)).obj (ModuleCat.of R R)

-- :74  THE cohomology carrier
noncomputable abbrev HModule (F : Sheaf J (ModuleCat.{u} R)) (n : ℕ) : Type u :=
  Abelian.Ext (constModuleSheaf J R) F n

-- :82  functoriality (this is `chi_congr` for free, via map_id/map_comp)
noncomputable def HModule.map (f : F ⟶ G) (n : ℕ) : HModule F n →ₗ[R] HModule G n
lemma HModule.map_id_apply {n : ℕ} (x : HModule F n) : map (𝟙 F) n x = x           -- :89
lemma HModule.map_comp_apply (f : F ⟶ G) (g : G ⟶ G') {n} (x) :                     -- :92
    map (f ≫ g) n x = map g n (map f n x)

-- :96  injective ⇒ higher cohomology vanishes  (the skyscraper route's engine)
instance [Injective F] (n : ℕ) : Subsingleton (HModule F (n + 1))

-- :137 morphisms out of the constant sheaf = sections at a terminal object
noncomputable def constModuleSheafHomEquiv (F : Sheaf J (ModuleCat.{u} R)) :
    (constModuleSheaf J R ⟶ F) ≃ₗ[R] F.obj.obj (op T)

-- :152 H⁰ = global sections, R-linearly
noncomputable def HModule.linearEquiv₀ (F : Sheaf J (ModuleCat.{u} R)) :
    HModule F 0 ≃ₗ[R] F.obj.obj (op T)

-- :193 k →+* Γ(X,U) via the structure morphism ; :215 the (local, @[reducible]) k-module
noncomputable def Scheme.overAlgebraMap (U : X.Opens) : k →+* Γ(X, U)
@[reducible] noncomputable def Scheme.overModule (U : X.Opens) : Module k Γ(X, U)  -- :215

-- :265 the structure sheaf as a sheaf of k-modules on the small Zariski site
noncomputable def Scheme.moduleKSheaf :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k)
@[simp] lemma Scheme.moduleKSheaf_obj (U) : (X.moduleKSheaf k).obj.obj (op U)
                                              = ModuleCat.of k Γ(X, U) := rfl        -- :270
noncomputable def Scheme.moduleKSheafHZero :
    Sheaf.HModule (X.moduleKSheaf k) 0 ≃ₗ[k] Γ(X, ⊤)                                 -- :279
```
Variables: `(J : GrothendieckTopology C) (R) [CommRing R] [HasSheafify J (ModuleCat.{u} R)]`;
AG section `(k) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]`. `overModule` is a **local**
instance (`attribute [local instance] Scheme.overModule`) — must be activated per file.

### 2.2 Cohomology of an object of the site — `Cohomology/OverOpen.lean` (371 lines)

```lean
-- :269 H'ⁿ(U,F): Ext from the FREE sheaf on U (NOT slice cohomology; restricted isos don't act)
noncomputable abbrev HModule' (F : Sheaf J (ModuleCat.{u} R)) (U : C) (n : ℕ) : Type u :=
  Abelian.Ext (freeModuleSheaf J R U) F n
noncomputable def HModule'.linearEquiv₀ (F) (U) : HModule' F U 0 ≃ₗ[R] F.obj.obj (op U)   -- :273
noncomputable def HModule'.res {U V} (i : U ⟶ V) (F) (n) :
    HModule' F V n →ₗ[R] HModule' F U n                                                     -- :286
-- :325 free sheaf on a terminal object = constant sheaf
noncomputable def freeModuleSheafIsoConstModuleSheaf : freeModuleSheaf J R T ≅ constModuleSheaf J R
-- :346 HModule (site) ≃ HModule' at a terminal object, every degree
noncomputable def HModule.linearEquivHModule' (n : ℕ) : HModule F n ≃ₗ[R] HModule' F T n
```

### 2.3 Affine vanishing + the Ext¹ criterion — `Cohomology/AffineVanishing.lean` (354 lines)

```lean
-- :62  THE Ext¹-vanishing criterion the skyscraper brick reuses (uses covariant_sequence_exact₁)
theorem Abelian.Ext.subsingleton_one_of_injective_of_surjective
    {A I : C} (ι : A ⟶ I) [Mono ι] [Injective I] (L : C)
    (hsurj : ∀ φ : L ⟶ cokernel ι, ∃ ψ : L ⟶ I, ψ ≫ cokernel.π ι = φ) :
    Subsingleton (Abelian.Ext L A 1)

-- :92  evaluation of a sheaf-mono is left-exact at the middle (used to lift sections)
theorem Sheaf.exists_app_eq_of_cokernelπ_app_eq_zero {F G} (ι : F ⟶ G) [Mono ι] (U) (c) (hc) :
    ∃ a : F.obj.obj U, (ι.hom.app U).hom a = c
theorem Sheaf.app_injective_of_mono {F G} (ι : F ⟶ G) [Mono ι] (U) :
    Function.Injective (ι.hom.app U).hom                                              -- :117

-- :180 STRUCTURE-SHEAF-ONLY Serre cobounding (Γ of moduleKSheaf over basic opens)
theorem IsAffineOpen.cokernel_app_surjective (hU : IsAffineOpen U)
    {G} (ι : X.moduleKSheaf k ⟶ G) [Mono ι] (q : (cokernel ι).obj.obj (op U)) :
    ∃ s : G.obj.obj (op U), ((cokernel.π ι).hom.app (op U)).hom s = q

-- :310 H¹'(U,𝒪)=0 for affine U   ;   :329 H¹(𝒪)=0 for affine X (instance)
theorem IsAffineOpen.subsingleton_moduleKSheaf_hModule'_one (hU : IsAffineOpen U) :
    Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) U 1)
instance Scheme.subsingleton_moduleKSheaf_hModule_one (X) [X.Over (Spec (.of k))] [IsAffine X] :
    Subsingleton (Sheaf.HModule (X.moduleKSheaf k) 1)
```
**Key fact for §1.3:** `cokernel_app_surjective` is proved *only* for a mono into a target of the
structure sheaf `X.moduleKSheaf k` (it uses `secRes_moduleKSheaf` + `exists_cech_cobounding`), so the
affine vanishing does **not** transport to a twisted sheaf.

### 2.4 Mayer–Vietoris + two-cover — `Cohomology/MayerVietoris.lean` (381), `Cohomology/TwoCover.lean` (279)

```lean
-- MayerVietoris.lean, on S : (…).MayerVietorisSquare
lemma  MayerVietorisSquare.moduleShortComplex_shortExact : (S.moduleShortComplex R).ShortExact  -- :137
noncomputable def moduleDiff : (F(X₂) × F(X₃)) →ₗ[R] F(X₁)                                       -- :161
theorem sections_ext (x y : F(X₄)) (h₂ …) (h₃ …) : x = y                                         -- :152
theorem exists_glue_of_moduleDiff_eq_zero …                                                       -- :184
noncomputable def moduleDelta : F(X₁) →ₗ[R] Sheaf.HModule' F S.X₄ 1                               -- :207
theorem moduleDelta_surjective [Subsingleton (HModule' F X₂ 1)] [Subsingleton (HModule' F X₃ 1)] :
    Function.Surjective (S.moduleDelta F)                                                          -- :319
noncomputable def h1LinearEquiv [Subsingleton (HModule' F X₂ 1)] [Subsingleton (HModule' F X₃ 1)] :
    (F(X₁) ⧸ range (moduleDiff)) ≃ₗ[R] Sheaf.HModule' F S.X₄ 1                                    -- :352
-- NOTE MayerVietoris uses the CONTRAVARIANT Ext LES (fixes F, varies free sheaf):
--   Abelian.Ext.contravariant_sequence_exact₁ / ₃   (:246, :311)

-- TwoCover.lean, X over Spec k, U₀ U₁ : X.Opens
noncomputable def Scheme.twoCoverSquare (hcov : U₀ ⊔ U₁ = ⊤) : (…).MayerVietorisSquare            -- :68
-- ★ GENERAL-COEFFICIENTS carrier "reusable for twisted sheaves" (roadmap's "carrier"):
noncomputable def Scheme.twoCoverH1LinearEquiv
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)) (hcov : U₀ ⊔ U₁ = ⊤)
    [Subsingleton (Sheaf.HModule' F U₀ 1)] [Subsingleton (Sheaf.HModule' F U₁ 1)] :
    Sheaf.HModule F 1 ≃ₗ[k] (F.obj.obj (op (U₀ ⊓ U₁)) ⧸ range ((twoCoverSquare …).moduleDiff F))  -- :92
noncomputable def TwoCover.diff : (Γ(X,U₀) × Γ(X,U₁)) →ₗ[k] Γ(X,U₀ ⊓ U₁)                          -- :118
noncomputable abbrev TwoCover.H1Cok : Type u := Γ(X,U₀ ⊓ U₁) ⧸ range (diff k X U₀ U₁)             -- :138
noncomputable def TwoCover.delta : Γ(X,U₀ ⊓ U₁) →ₗ[k] Sheaf.HModule (X.moduleKSheaf k) 1          -- :161
lemma TwoCover.delta_surjective (hU₀ hU₁ : IsAffineOpen …) : Surjective (delta …)                 -- :201
noncomputable def TwoCover.h1CokEquiv (hcov) (hU₀ hU₁ : IsAffineOpen …) :
    Sheaf.HModule (X.moduleKSheaf k) 1 ≃ₗ[k] H1Cok k X U₀ U₁                                       -- :226
```
The `[Subsingleton (HModule' F Uᵢ 1)]` instances in `twoCoverH1LinearEquiv` are the twist obstruction
of §1.3.

### 2.5 Finiteness base case + P¹ engine — `Cohomology/Finiteness.lean` (399), `SectionsBaseChange.lean` (360)

```lean
-- Finiteness.lean
theorem moduleFinite_hModule_one_of_isFinite_toP1 {X} [X.Over (Spec (.of k))]
    (π : X ⟶ P1 k) [IsFinite π] (hπ : π ≫ P1.structureMap k = X ↘ Spec (.of k)) :
    Module.Finite k (Sheaf.HModule (X.moduleKSheaf k) 1)                                           -- :374
-- ★ the curve-bundle finiteness instance (χ-ledger's H¹ finiteness base case)
instance moduleFinite_hModule_one (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
    Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)                                      -- :388

-- SectionsBaseChange.lean  (X : Over (Spec (.of k)), A : k-algebra; overSpec k A := Spec A over k)
instance flat_overSpec_hom (A) [CommRing A] [Algebra k A] : Flat (overSpec k A).hom               -- :113
theorem Over.isPushout_sections [Flat T.hom] (hT : IsAffineOpen ⊤) (hV : IsCompact V)
    (hV' : IsQuasiSeparated V) : IsPushout … (fst/snd appLE …)                                     -- :168
-- ★ affine section base change (design OPEN-4, RESOLVED):
noncomputable def Over.sectionsBaseChange {V} (hV : IsCompact V) (hV' : IsQuasiSeparated V) :
    Γ(X.left, V) ⊗[k] A ≃+* Γ((X ⊗ overSpec k A).left, (fst X (overSpec k A)).left ⁻¹ᵁ V)          -- :287
noncomputable def Over.sectionsBaseChangeOfIsAffineOpen {V} (hV : IsAffineOpen V) :
    Γ(X.left, V) ⊗[k] A ≃+* Γ((X ⊗ overSpec k A).left, (fst X (overSpec k A)).left ⁻¹ᵁ V)          -- :295
```

### 2.6 Point / DVR / divisor substrate

`Curve/StalksDVR.lean` (254):
```lean
theorem IsAffineOpen.valuationRing_stalk [IsIntegral X] {V} (hV : IsAffineOpen V)
    (hD : IsDedekindDomain Γ(X, V)) {x} (hx : x ∈ V) : ValuationRing (X.presheaf.stalk x)          -- :51
theorem IsAffineOpen.specializes_eq_genericPoint_or_eq [IrreducibleSpace X] {V} (hV) (hD)
    {x y} (hx : x ∈ V) (h : y ⤳ x) : y = genericPoint X ∨ y = x                                    -- :76
theorem Scheme.isClosed_singleton_of_forall_specializes [IrreducibleSpace X]
    (hgen : ∀ x y, y ⤳ x → y = genericPoint X ∨ y = x) {x} (hx : x ≠ genericPoint X) :
    IsClosed ({x} : Set X)                                                                         -- :109
theorem Scheme.finite_of_isClosed_of_notMem_genericPoint [IrreducibleSpace X]
    [NoetherianSpace X] (hgen …) {Z} (hZ : IsClosed Z) (hξ : genericPoint X ∉ Z) : Z.Finite        -- :124
theorem SmoothOfRelativeDimension.exists_isDedekindDomain_section [SmoothOfRelativeDimension 1 f]
    [IsIntegral X] (x) : ∃ V, IsAffineOpen V ∧ x ∈ V ∧ IsDedekindDomain Γ(X, V)                    -- :153
theorem SmoothOfRelativeDimension.valuationRing_stalk [SmoothOfRelativeDimension 1 f]
    [IsIntegral X] (x) : ValuationRing (X.presheaf.stalk x)                                        -- :175
theorem SmoothOfRelativeDimension.specializes_eq_genericPoint_or_eq …                              -- :184
theorem SmoothOfRelativeDimension.exists_transcendental_functionField … :
    ∃ f₀ : X.functionField, ∀ P : Polynomial K, P ≠ 0 → eval₂ … f₀ P ≠ 0                            -- :198
```
`Curve/DedekindSections.lean` (157): `MvPolynomial.isDedekindDomain_fin_one` (:108),
`Algebra.IsStandardSmoothOfRelativeDimension.isDedekindDomain` (:118), `.exists_transcendental` (:130),
`IsDedekindDomain.of_formallyUnramified_of_finiteType` (:86).
`Curve/Basic.lean` (115): `isIntegral_left_of_geometricallyReduced` (:69), and the *examples*
`Field C.left.functionField := inferInstance` (:109), `Algebra (stalk x) C.left.functionField :=
inferInstance` (:111) — confirming mathlib's `Scheme.functionField` API applies to `C.left`.
`Curve/Sections.lean` (180): `bijective_appTop_of_isProper_of_geometricallyIntegral` (:95),
`isIso_appTop_of_isProper_of_geometricallyIntegral` (:147), and the **`Γ(C,𝒪)≅k` instance**
`isIso_hom_appTop_of_geometricallyReduced` (:161).

**NOT PRESENT (all new work):** `IsDiscreteValuationRing (stalk x)` as an exported closed-point fact,
`stalkHeightOne`, `ord`/`ordUnits` (valuation of a function at a closed point), `residueDeg`,
`CurveDivisor`, `deg`, `divOf`, `divisorSheaf`, `divisorSheafZeroIso`, `mulEquivDivisorSheaf`,
skyscraper transport to `ModuleCat k`, `devissageSES`, `h0/h1/chi`, `chi_step`, `chi_divisorSheaf`,
the Dedekind colength wrapper, the finrank-alternating-sum brick.

### 2.7 L2 divisor-class carrier — `Picard/DivisorClass.lean` (466); `Picard/Pic.lean` (CechPic)

```lean
-- Pic.lean
def CechPic (X : Scheme.{u}) : Type u := Quotient (cechPicSetoid X)                                -- :60
def CechPic.mk (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : X.CechPic                                  -- :66
def CechPic.map (f : X ⟶ Y) : Y.CechPic →* X.CechPic                                               -- :198
-- CechPicToPic.lean: toPic : X.CechPic →* CommRing.Pic Γ(X,⊤) (:82); cechPicEquivPic exists.

-- DivisorClass.lean : the Cartier-style datum + its class (the ONLY landed divisor infra)
structure LocalEquations (X : Scheme.{u}) : Type u where                                           -- :112
  cover : X.PointedCover
  eqn   : ∀ x, Γ(X, cover.opens x)
  regular : ∀ x y (hy : y ∈ cover.opens x),
            (X.presheaf.germ (cover.opens x) y hy).hom (eqn x) ∈ nonZeroDivisors (X.presheaf.stalk y)
  ratio_isUnit : ∀ x y, ∃ u : Γ(X, cover.opens x ⊓ cover.opens y)ˣ, eqn x |∩ = u * eqn y |∩
noncomputable def LocalEquations.ratioUnit (x y : X) : Γ(X, cover.opens x ⊓ cover.opens y)ˣ         -- :155
noncomputable def LocalEquations.unitsCocycle : X.unitsCocycle d.cover                              -- :225
noncomputable def LocalEquations.picClass : X.CechPic := CechPic.mk d.cover d.unitsCocycle.class    -- :238
def LocalEquations.restrict (𝒱) (h : 𝒱 ≤ d.cover) : X.LocalEquations                                -- :260
def LocalEquations.mul (d d') : X.LocalEquations   ;  lemma picClass_mul                            -- :333, :358
def LocalEquations.rescale (d) (v) : X.LocalEquations ; lemma picClass_rescale                       -- :413, :450
```
`LocalEquations` is the Cartier datum; there is **no** `toDivisor`, no `MeromorphicTrivialization`,
no `GraphDivisor`, no `classDeg`. The `regular`/`ratio_isUnit` fields are exactly the data a
`toDivisor` would read stalkwise orders off of.

### 2.8 `genus` (frozen) — `Challenge.lean:89`

```lean
noncomputable def genus (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] : ℕ :=
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)
```
`χ(𝒪) = 1 − g` must land against **this** `letI := .ofHom C.hom` keying (matches `Finiteness.lean:388`).

### 2.9 Mathlib v4.31 gifts (re-grepped this session in `.lake-packages/mathlib`)

| Purpose | Declaration | `file:line` |
|---|---|---|
| skyscraper sheaf | `skyscraperSheaf : Sheaf C X` | `Topology/Sheaves/Skyscraper.lean:250` |
| stalk ⊣ skyscraper (sheaf) | `stalkSkyscraperSheafAdjunction [HasColimits C]` | `Skyscraper.lean:400` |
| stalk ⊣ skyscraper (presheaf) | `skyscraperPresheafStalkAdjunction [HasColimits C]` | `Skyscraper.lean:361` |
| right adjoint of an adjunction preserves injectives | `Injective.injective_of_adjoint (adj : L ⊣ R) (J) [Injective J] : Injective (R.obj J)` | `CategoryTheory/Preadditive/Injective/Basic.lean:195` |
| covariant Ext LES (from SES in 2nd arg) | `covariant_sequence_exact₁'/₂'/₃'` | `…/Ext/ExactSequences.lean:103, 63, 84` |
| contravariant Ext LES (from SES in 1st arg) | `contravariant_sequence_exact₁/₃` | used at `MayerVietoris.lean:246, 311` |
| sheaf epi ⇔ locally surjective (Type) | `epi_of_isLocallySurjective`, `isLocallySurjective_iff_epi` | `CategoryTheory/Sites/LocallySurjective.lean:375, 378` |
| Module-cat version used in-tree | `Sheaf.isLocallySurjective_iff_epi'` | `AffineVanishing.lean:190` |
| exact-from-kernel | `ShortComplex.exact_of_g_is_cokernel` (used `AffineVanishing.lean:69`); `exact_of_f_is_kernel` exists in `ShortComplex/Exact.lean` | — |
| Dedekind CRT | `IsDedekindDomain.quotientEquivPiOfProdEq`; `HeightOneSpectrum.quotientEquivPiOfProdEq` | `DedekindDomain/Ideal/Lemmas.lean:920, 909` |
| DVR filtration `q^i/q^{i+1} ≅ B/q` | `quotientRangePowQuotSuccInclusionEquiv [IsDedekindDomain S]` | `NumberTheory/RamificationInertia/Basic.lean:410` |
| Σ ramification·inertia | `sum_ramification_inertia {p} [p.IsMaximal] (hp0 : p ≠ ⊥)` | `RamificationInertia/Basic.lean:596` |
| height-one valuation | `HeightOneSpectrum.valuation : Valuation K ℤᵐ⁰`; `intValuation : Valuation R ℤᵐ⁰` | `DedekindDomain/AdicValuation.lean:327, 169` |
| scheme residue field | `AlgebraicGeometry.Scheme.residueField (x) : CommRingCat` | `AlgebraicGeometry/ResidueField.lean:45` |
| function field / stalk-fraction-ring | `Scheme.functionField`, `IsFractionRing (stalk x) functionField` (integral) | `AlgebraicGeometry/FunctionField.lean` (see `Curve/Basic.lean:109,111` witnesses) |
| rank-nullity | `Submodule.finrank_quotient_add_finrank [Module.Finite R M] (N)`; `LinearMap.finrank_range_add_finrank_ker` | `LinearAlgebra/Dimension/RankNullity.lean:247`; (used `BilinearForm/Orthogonal.lean:266`) |
| Jacobson/Zariski (residueDeg finite) | `finite_of_finite_type_of_isJacobsonRing` | `RingTheory/Jacobson/Ring.lean` (design cite :675) |
| ★ left-adjoint-preserves-mono for the skyscraper route | `TopCat.Presheaf.stalkFunctor_preserves_mono (x) : PreservesMonomorphisms (Sheaf.forget C X ⋙ stalkFunctor C x)` — **exists**, discharges the `[PreservesMonomorphisms L]` hypothesis of `injective_of_adjoint` for `L = stalkSkyscraperSheafAdjunction`'s left adjoint | `Topology/Sheaves/Stalks.lean:543` |
| skyscraper hypotheses | `skyscraperSheaf` needs `[HasTerminal C]` (all) + `[HasColimits C]` (stalks/adjunction); sections use **`terminal C`, not a zero object** | `Skyscraper.lean:53,133,265` |
| skyscraper sections lemma | `skyscraperPresheaf_obj : … = if p₀ ∈ unop U then A else terminal C` (`@[simps]`); `isTerminalSkyscraperSheafObjObjOfNotMem` (sheaf, `p₀ ∉ U`) | `Skyscraper.lean:59, 432` |
| stalk isos | `skyscraperPresheafStalkOfSpecializes` / `…OfNotSpecializes` (names `skyscraperSheaf_stalk` **do not exist**) | `Skyscraper.lean:176, 223` |
| ★ length additivity in a SES | `Module.length_eq_add_of_exact (f inj) (g surj) (H : Exact f g) : length M = length N + length P` | `RingTheory/Length.lean:171` |
| ★ finrank Euler-characteristic API for `ModuleCat R` | `GradedObject.eulerChar`, `HomologicalComplex.homologyEulerChar`, alternating signs `Int.negOnePow` via `ComplexShape.EulerCharSigns` | `Algebra/Homology/EulerCharacteristic.lean:118, 153` |
| `ShortComplex.ShortExact` (struct) | `structure ShortExact : Prop (exact / mono_f / epi_g)` | `Algebra/Homology/ShortComplex/ShortExact.lean:34` |
| `Presheaf.IsLocallySurjective` / sheaf epi | `IsLocallySurjective` (class), `Sheaf.epi_of_isLocallySurjective [IsLocallySurjective φ] : Epi φ` (needs `ConcreteCategory` coeff + `HasSheafCompose`) | `CategoryTheory/Sites/LocallySurjective.lean:94, 375` |

**Absent in v4.31 (grep-verified this session):** no `HeightOneSpectrum.ord`; no lemma literally
named `finrank_alternating`; no `skyscraperSheaf_obj`/`skyscraperSheaf_stalk`/
`stalkSkyscraper*AdjunctionUnit`. **Correction to the design doc's §5.3 claim** that "no n-term
alternating-finrank lemma exists in v4.31 — grep-verified": that is now **partly STALE** —
`Module.length_eq_add_of_exact` (`Length.lean:171`) gives SES length-additivity and
`Algebra/Homology/EulerCharacteristic.lean` (`GradedObject.eulerChar`, `HomologicalComplex.
homologyEulerChar`) is a full finrank-Euler-characteristic API for `ModuleCat R`. G1 should consider
reusing these rather than hand-rolling a 5-term brick (see §3-G1).

---

## 3. Gap list (dependency order; divisor-first route)

Legend: **[LA-k]** = pure linear algebra / commutative algebra over the field `k`, no scheme
geometry → **delegable to a Sonnet/Opus algebra agent**; **[GEO]** = genuinely geometric (schemes,
sheaves, stalks, the site); **[MIX]** = mostly LA but wired onto geometric objects; **[L2]** =
blocked on Picard-lane (L2) infra that does not exist yet.

Ledger leaf (`AJCR.w2-chi.ledger`, χ(L) − χ(L(-x)) = 1) needs **G1–G3, G5–G8**. RR leaf
(`AJCR.w2-chi.rr`, χ(L(D)) = 1 − g + deg D, h⁰ bounds) needs **G8, G9** plus, for the class-level
statements, **G10–G12**.

**G1 [LA-k] — finrank alternating-sum brick.** For a 5-term (or image-factorised chain) exact
sequence of finite `k`-modules, alternating Σ finrank = 0. **Design update:** the doc's "no n-term
lemma exists" is stale — mathlib now has `Module.length_eq_add_of_exact` (`Length.lean:171`, SES
length-additivity) and the `ModuleCat R` Euler-characteristic API `GradedObject.eulerChar` /
`HomologicalComplex.homologyEulerChar` (`EulerCharacteristic.lean:118,153`). First **assess reuse**
of these; fall back to the hand-rolled chain from the rank-nullity pieces (`RankNullity.lean:247`;
`finrank_range_add_finrank_ker`, `FiniteDimensional/Lemmas.lean:173`) only if the SES here doesn't fit
their shape. *Shape:* `theorem finrank_alt_sum_eq_zero_of_exact₅ …`. **Fully delegable, no geometry.**

**G2 [LA-k] — Dedekind colength formula.** `finrank_K (B ⧸ (f)) = Σ_q ord_q(f) · finrank_K (B ⧸ q)`
for `B` Dedekind, `f ≠ 0`, all residue fields finite over `k`. Route: CRT
`quotientEquivPiOfProdEq` on the factorisation of `(f)`, then DVR filtration
`quotientRangePowQuotSuccInclusionEquiv`. Stalk corollary
`finrank_K (𝒪_x ⧸ (g)) = ord_x(g) · residueDeg K x`. *Shape:*
`theorem IsDedekindDomain.finrank_quotient_span_eq_sum_ord …`. **Delegable (commutative algebra);
smoke test `B = k[t], f = tⁿ ↦ n`.**

**G3 [GEO] — closed-point order/residue layer.** On the curve bundle: `x ≠ genericPoint`,
`IsDiscreteValuationRing (stalk x)` / `stalkHeightOne x : HeightOneSpectrum (stalk x)` (from
`StalksDVR.valuationRing_stalk` + the DVR branch), `ord x : X.functionFieldˣ →* Multiplicative ℤ`
via `IsFractionRing (stalk x) X.functionField`, and `residueDeg K x := finrank K (residueField x)`
with `residueDeg_pos`/`residueDeg_finite` (Jacobson/Zariski). **Geometric** (builds on `StalksDVR`,
`FunctionField`, `ResidueField`).

**G4 [MIX] — `CurveDivisor`, `deg`, `divOf`.** `CurveDivisor := {x // x ≠ genericPoint} →₀ ℤ`;
`deg K D := Σ n_x · residueDeg K x`; `divOf (f : functionFieldˣ)` with finite support (via landed
`finite_of_isClosed_of_notMem_genericPoint`); `deg_add`, `deg_single`, `divOf_mul`. Finsupp
bookkeeping (LA) sitting on the geometric `ord`/`residueDeg`; **the finiteness-of-support step is
geometric.**

**G5 [GEO] — `divisorSheaf` + anchor iso.** `divisorSheaf K D : Sheaf (…) (ModuleCat k)` as the
subsheaf of the constant function-field sheaf cut by `ord_x g ≤ D_x`; sheaf condition via
`isSheaf_iff_isSheaf_forget` on integral `X` (as `isSheaf_moduleKPresheaf` did); `divisorSheafZeroIso
: divisorSheaf K 0 ≅ X.moduleKSheaf K` (sections = ⋂ stalks in `K(X)`, anchor `stacks-algebra`
`normal-domain-intersection-localizations-height-1`); monotone monos `D ≤ D' ⇒ divisorSheaf K D ⟶
divisorSheaf K D'` (Mono); `mulEquivDivisorSheaf f : divisorSheaf K D ≅ divisorSheaf K (D − divOf f)`.
**Geometric** (sheaf on the site; sections = intersection of stalks).

**G6 [MIX/GEO] — skyscraper cohomology (route-independent; the ledger's `sky` term).** Transport
mathlib `skyscraperSheaf x M` into our `Sheaf (…) (ModuleCat k)` (defeq via `TopCat.Sheaf`);
`skyscraperGammaEquiv : Sheaf.HModule (sky x M) 0 ≃ₗ[K] M`; and the new brick
`instance : Subsingleton (Sheaf.HModule (sky x M) 1)` via `Injective.injective_of_adjoint
(stalkSkyscraperSheafAdjunction …)` + landed `subsingleton_one_of_injective_of_surjective`.
Category-theory/cohomology, **not curve-geometric — delegable with care** (risk = the
`ite`/terminal-object plumbing in `ModuleCat`, design OPEN-1). **This is the first brick spec'd in §4.**

**G7 [GEO] — dévissage SES.** `devissageSES D x : ShortComplex (Sheaf …)` for
`0 → 𝒪(D) → 𝒪(D+x) → sky_x M(D,x) → 0` with `ShortExact`: mono (sectionwise injective), exact at
middle (`exact_of_f_is_kernel`), epi (`Sheaf.epi_of_isLocallySurjective` — *local* surjectivity, not
global). Jump module `M(D,x)` 1-dimensional over `κ(x)` (finrank_K = residueDeg K x, from G2's DVR
filtration). **Geometric** (sheaf-level, local DVR).

**G8 [MIX] — `h0/h1/chi`, finiteness dévissage, ★ ledger keystones.** `h0 F := finrank K (HModule F
0)`, `h1 F := finrank K (HModule F 1)`, `chi F := h0 − h1`; `chi_congr` from landed `HModule.map`
(map_id/map_comp); finiteness by dévissage from landed `moduleFinite_hModule_one` (base `D=0` via
`divisorSheafZeroIso`); then the ledger/RR keystones:
`chi_step : chi (divisorSheaf K (D + single x 1)) = chi (divisorSheaf K D) + residueDeg K x`
(**this is `χ(L) − χ(L(-x)) = 1` at `residueDeg = 1`, the ledger leaf**),
`chi_divisorSheaf : chi (divisorSheaf K D) = chi (X.moduleKSheaf K) + deg K D`,
`chi_structureSheaf : chi (X.moduleKSheaf K) = 1 − h1(𝒪)` (= 1 − genus C at `K = k`),
`deg_divOf : deg K (divOf f) = 0` (via `mulEquivDivisorSheaf` + `chi_congr`). Uses G1 (alt-sum),
G6 (`H¹(sky)=0`), G7 (SES), landed covariant Ext LES. **[MIX] — LA once the SES is in place, but
each χ statement is stated on geometric sheaves.**

**G9 [LA-k/MIX] — RR-lite inequality / h⁰ growth (RR leaf).**
`riemann_inequality : deg K D + 1 − h1(𝒪) ≤ h0 (divisorSheaf K D)` (one line from G8) and
`h0_nsmul_point_unbounded : ∀ N, ∃ n, N ≤ h0 (divisorSheaf K (n • single x 1))` (no rational point
needed — `residueDeg ≥ 1`). **Mostly LA on top of G8.**

**G10 [GEO] — base-change instances (R9).** `Curve/BaseChangeInstances.lean`: `X ×_{Spec K} Spec K'`
is a curve bundle over `K'` (the `IsStableUnderBaseChange` gifts + second-projection `Over`).
**Geometric (instance transport).**

**G11 [GEO] — (E-iv) base change.** `deg_toDivisor_pullback` (colength route via landed
`Over.sectionsBaseChange` + flat `⊗_K K'` + G2) and `h1_baseChange : h1 (X'.moduleKSheaf K') =
h1 (X.moduleKSheaf K)` (two-cover carrier both sides, structure-sheaf only). **Geometric.**

**G12 [L2] — class-level junction (E-i)–(E-iii) — BLOCKED on L2.** `toDivisor : LocalEquations →
CurveDivisor`, `sectionsModule`, `classDeg : CechPic →* ℤ`, the extraction lemma
(picClass-equality ⇒ principal difference), and the pinned interface theorems
`deg_toDivisor_eq_finrank_sectionsModule` (E-i), `classDeg_mul` (E-ii),
`chi_divisorClass : chi (divisorSheaf K d.toDivisor) = chi(𝒪) + classDeg d.picClass` (E-iii). These
need L2's **meromorphic ∃-bridge** and **graph rank-1 certificate**, which are not in the tree
(§2.7). **Do not spec until L2 supplies those, or spec them as part of an L2-coordinated brick.**

**Headline gap count: 12 (G1–G12).** Delegable-as-pure-algebra: **G1, G2** fully, **G6, G9**
with care (4). Geometric: **G3, G5, G7, G10, G11** (5). Mixed: **G4, G8** (2). L2-blocked: **G12** (1).
Ledger leaf = G1–G8; RR leaf = G8–G9 (+ G10–G12 for class-level base-change/normalisation).

---

## 4. Draft brick spec (house format) — **BRICK χ-C1: skyscraper cohomology (gap G6)**

*One page, ready for the orchestrator to edit and launch. Chosen as the first brick because it is
route-independent (both the divisor-first and the twisted framings need `H¹(sky)=0`), landed-stack-
only (no L2, no unbuilt point layer), and a clean category-theory task — a good Opus-agent unit that
also settles design OPEN-1.*

---

**MISSION / CONTRACT.** Deliver `AlgebraicJacobian/RiemannRoch/Skyscraper.lean` (≤ 350 lines,
namespace `AlgebraicGeometry`, `set_option autoImplicit false`), providing, for
`{K : Type u} [CommRing K] {X : Scheme.{u}} [X.Over (Spec (.of K))]`, a point `x : X` and
`M : ModuleCat.{u} K`, a skyscraper sheaf of `K`-modules on the small Zariski site with its
degree-0 and degree-1 cohomology computed:

```lean
noncomputable def skyModule (x : X) (M : ModuleCat.{u} K) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K)
noncomputable def skyModuleGammaEquiv (x) (M) : Sheaf.HModule (skyModule x M) 0 ≃ₗ[K] M
instance skyModule_subsingleton_hModule_one (x) (M) :
    Subsingleton (Sheaf.HModule (skyModule x M) 1)          -- ★ the new brick
```

Binding in shape (carriers, data-vs-Prop, quantifier structure); spelling lane-owned. `H⁰` must be
`M` on the nose `K`-linearly; the `Subsingleton` instance must be a genuine proof (no `sorry`,
axioms exactly `propext, Classical.choice, Quot.sound`).

**READ FIRST (in order).**
1. `informal/zeta-w2b-chi-recon.md` §2.1–2.3, §2.9, §3-G6 (this file) — the landed carrier + mathlib
   gifts, verbatim.
2. `AlgebraicJacobian/Cohomology/ModuleKSheaf.lean` — `HModule` (:74), `HModule.linearEquiv₀` (:152),
   the `[Injective F] ⇒ Subsingleton (HModule F (n+1))` instance (:96), `constModuleSheafHomEquiv`
   (:137), `moduleKSheaf_obj` (:270).
3. `AlgebraicJacobian/Cohomology/AffineVanishing.lean:62` — `Abelian.Ext.subsingleton_one_of_
   injective_of_surjective` (the criterion to reuse), and its use at `:310, :329` as the template.
4. `AlgebraicJacobian/Cohomology/OverOpen.lean:325,346` — `freeModuleSheafIsoConstModuleSheaf`,
   `HModule.linearEquivHModule'` (how the constant sheaf `k_X` mediates).
5. mathlib `Topology/Sheaves/Skyscraper.lean` (`skyscraperSheaf` :250 — needs `[HasTerminal C]
   [HasColimits C]`; `skyscraperPresheaf_obj` :59 = `if p₀∈U then A else terminal C`;
   `stalkSkyscraperSheafAdjunction` :400; `isTerminalSkyscraperSheafObjObjOfNotMem` :432);
   `CategoryTheory/Preadditive/Injective/Basic.lean:195` (`injective_of_adjoint`, needs
   `[PreservesMonomorphisms L]`); and `Topology/Sheaves/Stalks.lean:543`
   (`stalkFunctor_preserves_mono`, which supplies that instance).

**PROOF ROUTE (pinned).**
- `skyModule x M`: **default** = transport mathlib's `skyscraperSheaf x M : TopCat.Sheaf (ModuleCat K)
  X`, which is defeq to `Sheaf (Opens.grothendieckTopology X) (ModuleCat K)`. Sections:
  `skyscraperPresheaf_obj` gives `M` on `U ∋ x` and the terminal/zero object else.
- `skyModuleGammaEquiv`: `HModule.linearEquiv₀` at the terminal `⊤` (`isTerminalTop`), then extract
  the `if ⊤ ∋ x then M else 0` = `M` (`x ∈ ⊤` trivially).
- `skyModule_subsingleton_hModule_one`: embed `M ↪ I⁰` injective in `ModuleCat K`; `skyModule x I⁰`
  is an **injective sheaf** by `Injective.injective_of_adjoint (stalkSkyscraperSheafAdjunction …)`
  (skyscraper `skyscraperSheafFunctor` is the right adjoint `R`; the left adjoint is
  `Sheaf.forget ⋙ stalkFunctor x`, whose `[PreservesMonomorphisms]` obligation is discharged by the
  mathlib instance `TopCat.Presheaf.stalkFunctor_preserves_mono x` — `Stalks.lean:543`, verified this
  session). Then EITHER (a) conclude directly from the landed
  `ModuleKSheaf`-instance `[Injective F] ⇒ Subsingleton (HModule F 1)` with `F := skyModule x I⁰`
  after reducing along the cokernel `sky(I⁰/M)` — OR (b) apply
  `subsingleton_one_of_injective_of_surjective` with `ι := sky(M ↪ I⁰)`, `L := constModuleSheaf`,
  the surjectivity `Hom(k_X, sky I⁰) → Hom(k_X, sky (I⁰/M))` being `I⁰ → I⁰/M` at the section over
  `⊤ ∋ x` (via `constModuleSheafHomEquiv`), which is surjective. Prefer (a) if the injective-sheaf
  step type-checks cleanly; keep (b) as fallback.

**DESIGN CONSTRAINTS (kernel discipline — binding).**
- **Opaque defs.** Make `skyModule` (and any helper skyscraper functor) an opaque `def`, not an
  `abbrev`; never let the kernel unfold it into the `skyscraperPresheaf` `if`-tower during later
  `rw`. Expose behaviour through `@[simp]` section lemmas (`skyModule_obj_of_mem`,
  `skyModule_obj_of_not_mem`) proved once.
- **Abstract lemmas instantiated once.** Use `injective_of_adjoint` / the landed `Ext¹` criterion as
  black boxes applied a single time; do not re-derive adjunction internals. Do not `rw` *at* the
  concrete `skyscraperPresheaf`/`ite`/`eqToHom` tower — convert to the abstract statement first, then
  reason there (this is the OPEN-1 failure mode).
- **No `Scheme.overModule` global instance** — activate it `letI`/`attribute [local instance]` as
  `ModuleKSheaf.lean` does; the `K`-module structure on `M` is the ambient `ModuleCat K` one, keep it
  separate from `overModule`.
- **OPEN-1 fallback (pinned budget; risk CONFIRMED real).** mathlib's `skyscraperPresheaf.obj U` is
  `if p₀ ∈ U then A else terminal C` — the else-branch is the **categorical terminal `terminal C`,
  not the zero object** (`Skyscraper.lean:59`), so extracting `H⁰ = M` and `sky(coker)=coker(sky)`
  requires terminal-vs-zero `eqToHom`/`dite` plumbing in `ModuleCat K` (in `ModuleCat K` the terminal
  is `0`, but not definitionally through the `if`). If that surgery exceeds ~150 lines, **hand-roll**
  the functor (`obj U := if x ∈ U then M else 0` with `ModuleCat`'s honest zero object, restriction by
  `dite`) and reuse mathlib's adjunction *proof* as the template, keeping the same three public
  signatures. Report which vehicle you used.

**VERIFICATION PROTOCOL (foreground, blocking — non-negotiable).**
1. `lake build AlgebraicJacobian.RiemannRoch.Skyscraper` — kernel-green.
2. Add the import line to `AlgebraicJacobian.lean` (re-read on staleness, re-apply only your line),
   then `lake build AlgebraicJacobian` — root green.
3. `lean_verify AlgebraicGeometry.skyModule_subsingleton_hModule_one` and `…skyModuleGammaEquiv` —
   axioms exactly `[propext, Classical.choice, Quot.sound]`. (Do NOT use `lake env lean #print axioms`
   scratch files — they OOM on this box; use the live LSP `lean_verify`.)
4. Do all of steps 1–3 in the FOREGROUND and block on them; if you find yourself waiting on a
   background monitor, stop and finish verification in the foreground before reporting.

**REPORT FORMAT (final message).** 6–8 lines: (a) the three delivered signatures verbatim as they
compiled; (b) which OPEN-1 vehicle (mathlib skyscraper vs hand-rolled) and why; (c) root-build job
count + green/red; (d) the exact `lean_verify` axiom list for both keystones; (e) any deviation from
the pinned route and its justification; (f) file length. No prose beyond this.

---

*End of recon. §1.3 is the blocking decision; §3 headline = 12 gaps (G1–G12); §4 is a launch-ready
first brick that is safe under either route choice.*
