# Degree / `Pic⁰` interface reconnaissance (`AJCR.picard.degree`)

*Read-only recon, 2026-07-14. Produced for the orchestrator to write the degree-lane brick specs
directly. Every project signature below is verbatim from the tree with `file:line` (or cited from
the machine-extracted API dumps `api-chi-divisors.md` / `api-chi-devissage.md`, which were verified
this session against source line numbers). Nothing in the Lean tree was edited; `lake`/LSP were not
run (a prover holds the build lock). Scope: the last Wave-3 interface item — the degree map
`deg : Pic(C_K) → ℤ` (design §6.1 interface E-i..E-iv), `degAt`, `pic0Functor`, `abelElement`
(design §6.2), and the Wave-5 fence (§6.3). Binding design: `wave3-picard-design.md` §6 + §2.6.*

---

## 0. Headline

- **Nothing of the degree / `Pic⁰` interface is implemented.** No `RiemannRoch/Degree.lean`, no
  `Picard/DegreeZero.lean`, no `Picard/GraphDivisor.lean`, no `Picard/MeromorphicTrivialization.lean`,
  no `Picard/AbelElement.lean`, no `Picard/Witness.lean` exists. None of `divisorClass`, `classDeg`,
  `deg_divisorClass`, `degAt`, `pic0Functor`, `abelElement`, `graphLocalEquations`, `pointDivisor`,
  `toDivisor` occurs anywhere under `AlgebraicJacobian/` (grep-verified). The `Witness*.lean` files
  are (C1) coherent-witness descent, **unrelated** to the design's `JacobianData`/`Witness.lean`.
- **The two substrates the interface sits on have diverged in maturity since the design was written,
  in the lane's favour:**
  - The **`LocalEquations → CechPic` (a)-constructor is LANDED verbatim** (`Picard/DivisorClass.lean`,
    466 lines, all of `picClass`/`restrict`/`mul`/`rescale` invariance) — but the **(b) geometric
    instances** (point divisor, graph divisor) and **(c) the meromorphic bridge** are **absent**.
  - The **RiemannRoch/χ-ledger substrate is far more complete than the design assumed.** The entire
    Weil-divisor layer (`CurveDivisor`, `deg`, `divOf`, `ord`, `residueDeg`), the divisor sheaf
    `divisorSheaf K D`, the dévissage SES `devissageSES_shortExact`, `finrank_jumpModule`, and the
    multiplication iso `mulEquivDivisorSheaf` are **landed axiom-clean** (§2.3–2.4). The χ keystones
    the interface actually consumes — `chi_divisorSheaf`, `deg_divOf`, `chi_structureSheaf`,
    `riemann_inequality`, the finiteness instances — are the **G8/G9 brick landing in parallel**
    (`spec-chi-g8-g9.md`); treat them as **AVAILABLE-by-contract** (§2.4, §3).
- **The shared prerequisite `picEtUnit` has LANDED** (`Picard/PicEtUnit.lean:231`), closing gap G4 of
  the (C2) recon. **Field-extension covers are cofinal is LANDED**
  (`Algebra.EtaleCover.exists_finiteSeparableField_algHom`, `EtaleCover.lean:287`). These are the two
  machinery pieces `degAt` needs from the Picard lane; both are present (§2.5–2.6). The degree lane
  is therefore **genuinely unblocked** — its only unbuilt geometric core is the divisor↔class bridge.
- **The lane's hard core is one thing: `divisorClass : CurveDivisor → CechPic` and the meromorphic
  ∃-bridge** (design §2.6(b,c), §6.1 "honest ledger"). This is where the lane could go the way of
  (C2) — see §5.

---

## 1. Staleness audit of design §6 (+ §2.6) against today's tree

### 1.1 `wave3-picard-design.md` §6 (Degree and `Pic⁰`) — **STRUCTURALLY SOUND, 0 % implemented; two assumptions changed in the lane's favour, one sequencing note now moot**

Route summary of §6: degree is anchored on divisors, not on a fixed 2-cover (the "audited false pin"
of §6.1 is rejected); the **honest ledger** is "every class over a field is a divisor class"
(`MeromorphicTrivialization.lean`), and degree normalization is the B4 pushforward-rank shape (E-i);
`degAt` restricts a `picEt` class to a `Spec K`-point, represents it over a finite separable `K'/K`
by field-cover cofinality, and takes the degree over `K'` (E-ii), well-defined by base change (E-iv);
`pic0Functor` is the degree-0 subfunctor of `picEtFunctor`; `abelElement` = `[𝒪(Δ)]·[𝒪(fst⁻¹P)]⁻¹`.

**What still holds (re-verified this session):**

| Design §6/§2.6 claim | Status in tree (this session) |
|---|---|
| `LocalEquations → picClass` (a)-constructor, with mult./refinement/rescale invariance | **LANDED verbatim**, `DivisorClass.lean:112,238,260,333,413` (§2.2). |
| degree consumes χ on divisors: `deg L := χ(L) − χ(𝒪)`, χ anchored on `divisorSheaf K D` | substrate **LANDED** (`divisorSheaf`, `divisorSheafZeroIso`, dévissage SES); χ keystones landing in parallel (G8/G9 brick), §2.4. |
| `chi_divisorClass : χ(divisorClass D) = χ_𝒪 + deg(divisorClass D)` (E-iii) rests on `chi_divisorSheaf` | `chi_divisorSheaf : chi(divisorSheaf K D) = chi(𝒪) + deg K D` is spec'd (spec-chi-g8-g9 item 5), **not yet landed**. |
| well-definedness of E-ii = "principal divisors have degree 0" | delivered by the **χ-ledger** as `deg_divOf : deg K (divOf g) = 0` (spec-chi-g8-g9 item 6), not degree-lane work. |
| `degAt` needs field-extension-cover cofinality (§4.3) | **LANDED**: `Algebra.EtaleCover.exists_finiteSeparableField_algHom`, `ofField` (`EtaleCover.lean:287,311`), §2.6. |
| `degAt`/`pic0Functor` need the `picEt` unit and functor | **LANDED**: `picEtUnit` (`PicEtUnit.lean:231`), `picEtFunctor`/`picEtMap`/`picEtAffineEquiv` (§2.5). |
| point-local-ring is a DVR, uniformizer spreads to a local equation (§2.6(b) point divisor) | DVR + uniformizer infra **LANDED** (`StalksDVR`, `ClosedPoint.isDiscreteValuationRing_stalk`, `stalkHeightOne`), §2.3 — but the point-divisor `LocalEquations` **not built**. |
| `Δ ⊂ (C ⊗ C).left` is a relative effective divisor over the 2nd factor, rank 1 (§2.6(b) graph) | `graphLocalEquations` **absent** (no `Picard/GraphDivisor.lean`). |
| `pic0Functor` typing must feed `GrpObj.ofRepresentableBy` (§5 `JacobianData.rep`) | frozen `instGrpObj` shape unchanged (`Challenge.lean:107`); `pic0Functor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}` is the required carrier; L9 dry-run PASSED (§5 of design), §2.7. |
| `abelElement (P : 𝟙_ ⟶ C)`, `abelElement_map_point`, `comp_ofCurve` reduction | frozen `ofCurve`/`comp_ofCurve` shape unchanged (`Challenge.lean:125,130`), §2.7. |

**Corrections / staleness (all in the lane's favour or cosmetic):**

1. **`degAt` does NOT need the (C2) surjectivity/effectivity.** Design §6.2's prose "λ|_{Spec K} is
   represented over some finite separable K′/K" reads as if it needs `PicEtAff.unit` bijective over a
   field. It does not: `PicEtAff C (Spec K)` is *definitionally* the plus = quotient of
   `Σ E, descentClasses C E`, so a `picEt` class over `Spec K` is *already presented* by an honest
   descent class `x ∈ descentClasses C E ⊆ relPic C (overSpec K K')` for a finite étale `K`-algebra
   `K'` (a product of finite separable field extensions, by the landed field cofinality). One takes
   the degree of that **relPic/CechPic class over the field `K'`** directly (E-ii over `K'`); no
   descent back to `K` is required. This is the disjointness §3.1 of the (C2) recon asserts — **it
   verifies against the current tree**: (C2)'s hard content (fppf effectivity along `cg`, §1.2 below)
   and the degree's hard content (`divisorClass` + meromorphic bridge) share only `picEtUnit` (landed)
   and touch no common unbuilt lemma.
2. **The §6.1 coordination note "feed the equalizer-presented twisted sheaf `F_g` to
   `twoCoverH1LinearEquiv` … no new affine-vanishing engine is needed" is MOOT** — exactly as the
   χ-ledger recon (`zeta-w2b-chi-recon.md` §1.3) already established: the vanishing does *not*
   transport to a twisted sheaf for free (`OverOpen.lean:269`, `AffineVanishing.lean:180` are
   structure-sheaf-only). The χ-ledger took the **divisor-first** route instead, and the degree lane
   inherits χ from `divisorSheaf` via `chi_divisorSheaf`, never from a twisted 2-cover complex. Drop
   the §6.1 twisted-`F_g` paragraph when writing the degree brick; it is dead.
3. **The §6.1/§6.3 "χ" that E-iii/E-iv talk about is now a concrete landed object.** `χ(L)` for a
   line bundle `L` is `chi (divisorSheaf K D)` for the `D` with `divisorClass D = L` (via the
   meromorphic bridge). E-iv "invariance under `K ↪ K′`" is `chi`/`deg` base change, which needs the
   §2.3-landed `Over.sectionsBaseChange` plus base-change **instances** that do not yet exist
   (`Curve/BaseChangeInstances.lean` absent — G10/G11 of the χ-recon, §3 gap G-D5).
4. **Line-number drift in §2.6/§6 code blocks.** The design's inline `LocalEquations`/`picClass`
   sketch matches the landed `DivisorClass.lean` up to the extra landed field
   `regular : ∀ x y (hy …), … ∈ nonZeroDivisors …` (design wrote it as an informal comment). Use §2.2
   below, not the design's sketch.

**Verdict — design §6 + §2.6: NOT STALE as a design.** The division of labour with the χ-ledger is
sound and the χ substrate landed *better* than assumed; the two machinery prerequisites (`picEtUnit`,
field cofinality) are now landed; the only false-friend is the §6.2 prose that makes `degAt` look
(C2)-dependent (correction 1) and the dead §6.1 twisted-`F_g` note (correction 2). Keep §6/§2.6 as
binding; re-anchor from §2 below; treat E-i..E-iv's χ inputs as AVAILABLE-by-contract from G8/G9.

### 1.2 How the (C2) effectivity correction affects the degree lane — **it does not gate it**

The 2026-07-14 handoff records a **design correction**: the (C2) *finish*
(`PicEtAff.unit_surjective_of_section`) is not the one-shot delicate step the (C2) recon §3 sketched;
it is **fppf effectivity along `cg` on the curve product — campaign-scale (a mirror of ζ2/ζ3)**, and
is **still open** (`Picard/Rigidification.lean` landed only G0–G2: `sectionOfPoint`, `IsRigidified`,
`exists_isRigidified_rep`, the `lm:aut` ring heart; **no** `unit_surjective_of_section`). Per
correction 1 above, the degree lane consumes **only** `picEtUnit` (landed) and never the (C2)
surjectivity, so the open (C2) effectivity campaign **does not gate any degree-lane gap**. The two
lanes can proceed fully in parallel. (This is the §3.1-of-(C2)-recon "disjoint cores" claim, now
re-verified against the corrected (C2) scope.) The relevance of (C2) to the degree lane is a
*cautionary* one only — the degree lane has its own campaign-risk candidate (§5).

### 1.3 `zeta-c2-rigidification-recon.md` §2.7 / §3.1 — **still accurate on the degree adjacency**

§2.7's inventory holds verbatim: `DivisorClass.lean` has the (a)-constructor only (no
graph/point/pullback-compat); `RiemannRoch/Divisor.lean` has `CurveDivisor`/`deg` **not wired to
`CechPic`**; no `divisorClass`, `deg_divisorClass`, `pic0Functor`, `degAt`, `graphLocalEquations`,
`abelElement`, `JacobianData`. §3.1's sequencing ("build G4 `picEtUnit` first; then the degree brick
consumes G4 + the independent `divisorClass`/`deg` wiring; do NOT merge (C2) and degree") is now
**executed on the G4 side** (`picEtUnit` landed) and remains the correct plan for the degree side.

---

## 2. Exact API map (verbatim signatures + `file:line`; landed only)

Paths under `…/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/`. Tree is sorry-clean across
`Picard/` and `RiemannRoch/` (grep-verified this session). Where a signature is quoted from a
machine-extracted dump it is marked `[api-chi-divisors]` / `[api-chi-devissage]`; those dumps were
line-checked against source this session.

### 2.1 The degree map's target type — `Picard/Pic.lean` (CechPic) + `CechPicToPic.lean`

```lean
-- Pic.lean
def CechPic (X : Scheme.{u}) : Type u := Quotient (cechPicSetoid X)                          -- :60
   -- = Quotient of  Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰   (:43)
def CechPic.mk (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : X.CechPic                            -- :66
instance : CommGroup X.CechPic                                                                -- :117
theorem CechPic.mk_eq_mk_iff … ; mk_unitsRes … ; mk_mul_mk_inf … ; mk_one …                   -- :75,:84,:161,:167
def CechPic.map (f : X ⟶ Y) : Y.CechPic →* X.CechPic                                          -- :198
theorem CechPic.map_id … ; map_comp (f) (g) : map (f ≫ g) = (map f).comp (map g)             -- :223,:237
-- CechPicToPic.lean
noncomputable def CechPic.toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤)                           -- :82
-- CechPicSurjective.lean
noncomputable def Scheme.cechPicEquivPic (X) [IsAffine X] : X.CechPic ≃* CommRing.Pic Γ(X,⊤)  -- :283 [c2-recon §2.6]
```

The degree homomorphism the interface must build lives on `(C_K).left.CechPic` (`C_K := C ⊗ Spec K`
over `K`), a `CommGroup`. `CechPic.map` gives the pullback the meromorphic bridge and base change use.

### 2.2 The (a)-constructor, LANDED — `Picard/DivisorClass.lean` (466 lines)

```lean
structure Scheme.LocalEquations (X : Scheme.{u}) : Type u where                               -- :112
  cover : X.PointedCover
  eqn : ∀ x, Γ(X, cover.opens x)
  regular : ∀ (x y : X) (hy : y ∈ cover.opens x),
    (X.presheaf.germ (cover.opens x) y hy).hom (eqn x) ∈ nonZeroDivisors (X.presheaf.stalk y)
  ratio_isUnit : ∀ x y, ∃ u : Γ(X, cover.opens x ⊓ cover.opens y)ˣ,
    (X.presheaf.map (homOfLE inf_le_left).op).hom (eqn x)
      = (u : …) * (X.presheaf.map (homOfLE inf_le_right).op).hom (eqn y)
noncomputable def LocalEquations.ratioUnit (x y) : Γ(X, cover.opens x ⊓ cover.opens y)ˣ        -- :155
lemma  LocalEquations.ratioUnit_unique … ; ratioUnit_trans …                                  -- :169,:183
noncomputable def LocalEquations.unitsCocycle : X.unitsCocycle d.cover                         -- :225
noncomputable def LocalEquations.picClass : X.CechPic := CechPic.mk d.cover d.unitsCocycle.class -- :238
def  LocalEquations.restrict (𝒱) (h : 𝒱 ≤ d.cover) : X.LocalEquations                          -- :260
@[simp] lemma picClass_restrict …                                                             -- :278
def  LocalEquations.mul  (d d') : X.LocalEquations ; @[simp] lemma picClass_mul (d d') :
      (d.mul d').picClass = d.picClass * d'.picClass                                          -- :333,:358
def  LocalEquations.rescale (d) (v) : X.LocalEquations ; @[simp] lemma picClass_rescale :
      (d.rescale v).picClass = d.picClass                                                     -- :413,:450
```

This is **exactly** design §2.6(a). What is **missing** on top of it (design §2.6(b,c)): a
constructor from a **closed point** (`pointDivisor`), from the **graph/diagonal**
(`graphLocalEquations`), the **pullback compatibility** `(d.pullback f).picClass = CechPic.map f d.picClass`,
and the total map `divisorClass : CurveDivisor → CechPic`. The `regular`/`ratio_isUnit` fields are
precisely the data a `pointDivisor` (uniformizer `t` on a Dedekind chart, `1` away from the point)
must supply.

### 2.3 The Weil-divisor + DVR substrate, LANDED — `RiemannRoch/{Divisor,ClosedPoint,PrincipalDivisor,ResidueDegree}.lean`

All `[api-chi-divisors]`, line-checked. Base field named `K` (`[Field K]` for order/DVR, `[CommRing K]`
for `deg`/`residueDeg`); `X : Scheme.{u}` with `[IsIntegral X]`, `[X.Over (Spec (CommRingCat.of K))]`,
`[SmoothOfRelativeDimension 1 (X ↘ …)]`; K-module structures are sealed `attribute [local instance]`
(`residueFieldOverModule`, `functionFieldOverModule`, `overModule`).

```lean
def Scheme.CurveDivisor (X) [IsIntegral X] : Type u := {x : X // x ≠ genericPoint X} →₀ ℤ      -- Divisor.lean:40
noncomputable def CurveDivisor.deg (K) [CommRing K] (D) : ℤ := D.sum (fun x n => n * (X.residueDeg K x.1 : ℤ)) -- :61
   -- deg_zero:65, deg_add:70, deg_single:77, deg_neg:84  (an AddCommGroup + PartialOrder on CurveDivisor)
noncomputable def Scheme.residueDeg (K) [CommRing K] (X) (x) : ℕ := Module.finrank K (X.residueField x) -- ClosedPoint.lean:128
theorem Scheme.residueDeg_finite [LFT] {x} (hx : x ≠ genericPoint X) : Module.Finite K (X.residueField x) -- ResidueDegree.lean:71
theorem Scheme.residueDeg_pos   [LFT] {x} (hx) : 0 < X.residueDeg K x                          -- ResidueDegree.lean:154
theorem isDiscreteValuationRing_stalk (f : X ⟶ Spec (CommRingCat.of K)) [Smooth1][IsIntegral X]
    {x} (hx : x ≠ genericPoint X) : IsDiscreteValuationRing (X.presheaf.stalk x)               -- ClosedPoint.lean:63
theorem isClosed_singleton_of_ne_genericPoint (f) … {x} (hx) : IsClosed ({x} : Set X)          -- ClosedPoint.lean:80
noncomputable def stalkHeightOne (X) [IsIntegral X] (x) [IsDiscreteValuationRing (stalk x)] :
    IsDedekindDomain.HeightOneSpectrum (X.presheaf.stalk x)                                     -- PrincipalDivisor.lean:71
noncomputable def Scheme.ord (f) [Smooth1][IsIntegral X] {x} (hx) :
    Valuation X.functionField (WithZero (Multiplicative ℤ))                                     -- ClosedPoint.lean:95
noncomputable def Scheme.divOf (f) [Smooth1][IsIntegral X][LFT][QuasiCompact] (g : X.functionFieldˣ)
    : X.CurveDivisor                                                                           -- PrincipalDivisor.lean:150
   -- divOf_mul:171 (div(g·g')=div g + div g'), divOf_one:182
theorem SmoothOfRelativeDimension.exists_isDedekindDomain_section [Smooth1][IsIntegral X] (x) :
    ∃ V, IsAffineOpen V ∧ x ∈ V ∧ IsDedekindDomain Γ(X, V)                                      -- StalksDVR.lean:153
```

`deg K D = Σ_x D_x·[κ(x):K]` is exactly the "`dim_K Γ(𝒪_D)`" of E-i for **effective** `D` (the
Dedekind colength). The uniformizer for `pointDivisor` comes from `stalkHeightOne`/the DVR of
`isDiscreteValuationRing_stalk` on the chart `exists_isDedekindDomain_section`.

### 2.4 The χ-ledger divisor sheaf + dévissage, LANDED; χ keystones AVAILABLE-by-contract

Landed (`[api-chi-devissage]`, line-checked):

```lean
noncomputable def Scheme.divisorSheaf (K) [Field K] (D : X.CurveDivisor) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K)                          -- DivisorSheaf.lean:326
   -- sections over U = { g : K(X) | ∀ closed x∈U, ord_x g ≤ ofAdd(D x) };  divisorSheaf_obj:330
noncomputable def Scheme.divisorSheafZeroIso : divisorSheaf K 0 ≅ X.moduleKSheaf K             -- DivisorSheafZero.lean:285
noncomputable def Scheme.divisorSheafLE {D D'} (h : D ≤ D') : divisorSheaf K D ⟶ divisorSheaf K D' -- :358 (Mono:362)
noncomputable def devissageSES {x} (hx) (D) : ShortComplex (Sheaf … (ModuleCat.{u} K))
   := ShortComplex.mk (divisorSheafLE …) (devissageπ …)   -- 0 → 𝒪(D−x) → 𝒪(D) → sky_x J → 0   -- Devissage.lean:362
theorem devissageSES_shortExact [QuasiCompact] : (devissageSES K hx D).ShortExact              -- DevissageExact.lean:316
theorem finrank_jumpModule [LFT] : Module.finrank K (jumpModule K hx D) = X.residueDeg K x     -- JumpDimension.lean:274
noncomputable def Scheme.mulEquivDivisorSheaf [LFT][QuasiCompact] (g : X.functionFieldˣ) (D) :
    divisorSheaf K D ≅ divisorSheaf K (D - Scheme.divOf (X ↘ …) g)                              -- MulEquiv.lean:268
def skyModule (x) (M : ModuleCat.{u} K) : Sheaf … (ModuleCat.{u} K)                             -- Skyscraper.lean:64
instance skyModule_subsingleton_hModule_one (x) (M) : Subsingleton (Sheaf.HModule (skyModule x M) 1) -- Skyscraper.lean
```

**AVAILABLE-by-contract (the G8/G9 brick `spec-chi-g8-g9.md`, landing in parallel; NOT yet in tree):**
`h0`/`h1`/`chi F` (Layer A), `chi_congr`, the finiteness instances
`Module.Finite K (Sheaf.HModule (divisorSheaf K D) i)`, and the keystones —
`chi_divisorSheaf : chi (divisorSheaf K D) = chi (X.moduleKSheaf K) + deg K D`;
`deg_divOf : deg K (divOf (X ↘ …) g) = 0`;
`chi_structureSheaf : chi (C.left.moduleKSheaf k) = 1 − genus C` (Layer B);
`riemann_inequality : deg K D + chi (moduleKSheaf) ≤ (h0 (divisorSheaf K D) : ℤ)`;
`h0_nsmul_point_unbounded`. **Cite these by contract in every degree-brick spec** and gate the degree
brick's launch on their landing (they are the ledger frontier; handoff commit `7fe83d9bf8` left G8+G9
as the only remaining ledger work).

### 2.5 The Picard-lane consumers — `RelPic`, `PicEtAff`, `PicEt`, `PicEtUnit`

Standing header (every file): `variable {k : Type u} [Field k] (C : Over (Spec (.of k)))`;
`overSpec k A : Over (Spec (.of k))` = `Spec A → Spec k`. `[api from c2-recon §2.1–2.5, line-checked]`.

```lean
-- RelPic.lean
def relPic (T) : Type u := (C ⊗ T).left.CechPic ⧸ picFromBase C T                              -- :63
noncomputable def relPicMk (T) : (C ⊗ T).left.CechPic →* relPic C T                            -- :70
noncomputable def relPicMap (g : T' ⟶ T) : relPic C T →* relPic C T'                           -- :106
noncomputable def relPicFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}                     -- :133
-- PicEtAff.lean
def descentClasses (E : Algebra.EtaleCover A) : Subgroup (relPic C (overSpec k E.Carrier))     -- :76
def PicEtAff (A) : Type u  (CommGroup)  ;  PicEtAff.mk (E) (x)                                  -- :218,:224
def PicEtAff.unit (A) : relPic C (overSpec k A) →* PicEtAff C A                                 -- :377  ★ the unit
theorem PicEtAff.unit_injective [IsProper][GI][GR] (A) : Function.Injective (PicEtAff.unit C A) -- CechKernelLemma.lean:361 (C1)
-- PicEt.lean
def picEt (T) : Type u  (CommGroup)                                                             -- :105,:108
def picEt.eval (U : T.left.affineOpens) : picEt C T →* PicEtAff C Γ(T.left, U.1)                -- :126
def picEtAffineEquiv (A) : picEt C (overSpec k A) ≃* PicEtAff C A                               -- :235  ★ affine collapse
-- PicEtMap.lean
noncomputable def picEtMap (f : T' ⟶ T) : picEt C T →* picEt C T'                              -- :234
noncomputable def picEtFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}                      -- :314
lemma picEtMapVal_spec … (the ∃!-API to consume section values)                                -- :216
```

**`picEtUnit` HAS LANDED** (gap G4 of the (C2) recon, closed after that recon was written):

```lean
-- PicEtUnit.lean, under [IsProper C.hom][GeometricallyIrreducible C.hom][GeometricallyReduced C.hom]
def picEtUnit : relPicFunctor C ⟶ picEtFunctor C                                               -- :231
def relPicToPicEt (T) : relPic C T →* picEt C T                                                 -- :126  (its component)
theorem picEtAffineEquiv_picEtUnit_app (A) (z) :
    picEtAffineEquiv C A ((picEtUnit C).app (op (overSpec k A)) z) = PicEtAff.unit C A z         -- :243  ★ affine consistency
```

**The exact type a degree homomorphism must land on.** A `pic0`/degree datum ultimately reads a
`Spec K`-valued point of `T` into a `picEt C (Spec K)` class, collapses it via `picEtAffineEquiv` to
`PicEtAff C K`, which is *presented* (definitionally, the plus) by a descent class
`x ∈ descentClasses C E ⊆ relPic C (overSpec K K')` for `K' = E.Carrier` a finite étale `K`-algebra;
`relPicMk⁻¹` of a representative is an honest class in `(C ⊗ Spec K').left.CechPic = (C_{K'}).left.CechPic`.
**The degree is a homomorphism `classDeg : (C_{K'}).left.CechPic →* ℤ` (over the field `K'`).** No
descent back to `K` is needed; `degAt` is `classDeg` composed with the presentation + a
well-definedness (E-iv) across the choice of `K'`. **`picEtUnit` enters** as the natural trans
`relPicFunctor ⟶ picEtFunctor` that identifies `pic0Functor` as a subfunctor of `picEtFunctor` and
lets `abelElement` (a `relPic` class) be pushed into `picEt`.

### 2.6 Field-extension covers are cofinal, LANDED — `Algebra/EtaleCover.lean`

```lean
theorem Algebra.EtaleCover.exists_finiteSeparableField_algHom (E : EtaleCover K) : …            -- :287
   -- over a field K every cover is refined by a finite separable field extension (single-factor)
noncomputable def Algebra.EtaleCover.ofField (L …) : EtaleCover K                               -- :311
noncomputable def Algebra.EtaleCover.ofFieldEquiv : (ofField L).Carrier ≃ₐ[K] L                 -- :315
```

This is the exact machinery design §4.3/§6.2 names for `degAt` ("field-extension covers are cofinal
… take deg over `K′`"). **Present.** The Galois-invariance / well-definedness-across-`K'` step that
sits on top of it is *not* landed (part of G-D6).

### 2.7 Frozen consumers (READ-ONLY) — `Challenge.lean` + the `JacobianData` shape

```lean
-- Challenge.lean (frozen; the degree lane must produce a pic0Functor these can consume via Wave 4)
noncomputable def Jacobian.ofCurve (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : C ⟶ Jacobian C := sorry -- :125
theorem Jacobian.comp_ofCurve (…) (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    P ≫ ofCurve P = η[Jacobian C] := sorry                                                      -- :130
noncomputable instance instGrpObj : GrpObj (Jacobian C) := sorry                                -- :107
```

`abelElement` (design §6.2) is keyed to the **same** point type `P : 𝟙_ (Over (Spec (.of k))) ⟶ C`.
The `pic0Functor` the degree lane delivers must be
`pic0Functor C : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}` so that (design §5, L9 dry-run PASSED)
`rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J` typechecks
and `GrpObj.ofRepresentableBy` applies verbatim — this is the **binding carrier constraint** on
`pic0Functor`: contravariant, `CommGrpCat.{u}`-valued, on `(Over (Spec (.of k)))ᵒᵖ`, a subfunctor of
`picEtFunctor C`. `abelElement P : pic0 C C` (test scheme `T := C`) with
`abelElement_map_point : (pic0Functor C).map P.op (abelElement P) = 1` drives `comp_ofCurve` (design
§4.6). Wave 4 owns `JacobianData`/`Witness.lean`; the degree lane owns everything up to `pic0Functor`
+ `abelElement`.

### 2.8 NOT PRESENT (all new work; grep-verified this session)

`divisorClass : CurveDivisor → CechPic`, `pointDivisor`, `graphLocalEquations`,
`LocalEquations.pullback` / `picClass_pullback`, `Picard/MeromorphicTrivialization.lean` (the ∃-bridge
"every class over integral `C_K` is a divisor class"), `classDeg : CechPic →* ℤ`, `deg_divisorClass`
(E-i), `classDeg_mul` (E-ii), `chi_divisorClass` (E-iii), `Curve/BaseChangeInstances.lean` (G10:
`C_K` a curve bundle over `K`), the `deg`/`h1` base-change (E-iv), any `relPic`/`picEt`/`CechPic`
**base-field shuffle** (grep `baseField`/`shuffle` empty), `degAt`, `pic0Functor`, `abelElement`(+`_map_point`,`_baseField`),
`Picard/DegreeZero.lean`, `RiemannRoch/Degree.lean`, `Picard/AbelElement.lean`, `Picard/Witness.lean`/`JacobianData`.

---

## 3. Gap list (dependency order) + interface-item ledger

Legend: **[LA-k]** pure linear/commutative algebra over `K` → delegable to an algebra agent;
**[GEO]** genuinely geometric (schemes/sheaves/stalks/site); **[MIX]** mostly LA wired onto geometric
objects; **[BLOCKED-on-χ]** needs the G8/G9 χ keystones (§2.4, landing in parallel). "Serves" =
which design-§6 interface item (E-i..E-iv / degAt / pic0Functor / abelElement) the gap feeds.
Delegable? = can a sub-agent own it end-to-end from landed infra.

The interface item **E-i..E-iv** need **G-D1, G-D2, G-D3** (+ χ-contract), with **G-D5** for E-iv;
**degAt** needs **G-D3 + G-D6**; **pic0Functor** needs **degAt**; **abelElement** needs **G-D1(point)
+ G-D4(graph) + pic0Functor**.

**G-D1 [GEO] — `pointDivisor` and `divisorClass : CurveDivisor → CechPic` (design §2.6(a,b), (c)-differences).**
Serves: **E-i** (its subject), abelElement (point term), and every downstream item. Two pieces:
(a) `pointDivisor {x} (hx : x ≠ genericPoint X) : X.LocalEquations` — a uniformizer `t` of the DVR
`stalk x` (landed `isDiscreteValuationRing_stalk`/`stalkHeightOne`) spread to a section on a Dedekind
chart `V` (landed `exists_isDedekindDomain_section`), and `1` away from `x`; `regular`/`ratio_isUnit`
discharged from DVR regularity. (b) `divisorClass K D : (C_K).left.CechPic` for a general
`D : CurveDivisor` = product of `pointDivisor`-classes over the finite support (effective part) times
inverse (anti-effective part), i.e. `picClass`-of-effective `·` `(picClass-of-effective)⁻¹` (design
§2.6(c) differences). `divisorClass_add : divisorClass (D+D') = divisorClass D · divisorClass D'`
from `picClass_mul`. **Delegable-with-care** (geometric, but all inputs landed: `DivisorClass` +
`StalksDVR`/`ClosedPoint`). **Independent of the χ-ledger.** — *This is the first-brick candidate, §4.*

**G-D2 [GEO] — the meromorphic ∃-bridge (design §2.6(c), §6.1 "honest ledger"), `Picard/MeromorphicTrivialization.lean`.**
Serves: **E-i/E-ii** totality + well-definedness (makes `classDeg` **total** on `CechPic` and a hom).
Two sub-claims for **integral** `C_K`: (i) `picClass (localEquations of divisorSheaf K D) = ` the
Čech class of the invertible sheaf `divisorSheaf K D` — i.e. `divisorSheaf K D` **is** the sheaf of
class `divisorClass K D` (locally free rank 1, local generator = a local equation); (ii) surjectivity:
`∀ L : (C_K).left.CechPic, ∃ D, divisorClass K D = L` (Hartshorne II.6.15 / Kleiman `th:qpp&p`
quote). Cocycle proof shape (design §2.6(c)): every nonempty open contains the generic point; fix a
base index `x₀`, localize cocycle values `g x x₀` into the function field → meromorphic local
equations. **[GEO], NOT delegable-as-algebra** — the hard geometric core; **this is the (C2)-style
ballooning risk (§5).** Consumes G-D1. **Independent of the χ-ledger** (but its payoff — computing χ
of a class — needs G-D3's χ-contract).

**G-D3 [MIX, BLOCKED-on-χ] — `classDeg : (C_K).left.CechPic →* ℤ` + E-i/E-ii/E-iii, `RiemannRoch/Degree.lean`.**
Serves: **E-i, E-ii, E-iii** directly; the substrate `classDeg` for degAt. Define
`classDeg L := chi (divisorSheaf K D) − chi (X.moduleKSheaf K)` where `D` is a G-D2 witness for `L`
(well-defined by G-D2 + `deg_divOf`); equivalently `deg K D` via `chi_divisorSheaf`. Then:
E-i `deg_divisorClass : classDeg (divisorClass K D) = deg K D` (for effective `D`, `= dim_K Γ(𝒪_D)`;
one line from `chi_divisorSheaf` + G-D2(i)); E-ii `classDeg_mul` (hom; from `chi_divisorSheaf`
additivity + `deg_add` + G-D2 multiplicativity); E-iii `chi_divisorClass` (definitional restatement).
**[MIX]** — LA once G-D2 + the χ-contract are in place; each statement is on geometric sheaves.
**BLOCKED-on-χ** (`chi_divisorSheaf`, `deg_divOf`, finiteness instances — §2.4). **Delegable once
G-D2 lands and G8/G9 is green.**

**G-D4 [GEO] — `graphLocalEquations` (design §2.6(b) graph divisor) + rank-1 certificate + base change, `Picard/GraphDivisor.lean`.**
Serves: **abelElement** (the `[𝒪(Δ)]` term, deg 1). `graphLocalEquations (t : T ⟶ C) : ((C ⊗ T).left).LocalEquations`
for `Γ_t` = pullback of the diagonal `Δ`; rank-1 certificate `𝒪_{Γ_t} ≅ 𝒪_T` (`deg = 1` via E-i);
`graphLocalEquations_base_change` (Γ_{t∘g} = pullback of Γ_t, from §2.6(a) pullback-compat). **[GEO]**
— needs the diagonal-as-relative-divisor geometry (Kleiman `ex:DivC`/`rmk:Jac`); **not delegable-as-algebra**.
Consumes G-D1's pullback-compat. **Independent of the χ-ledger.**

**G-D5 [GEO] — base-change instances + E-iv, `Curve/BaseChangeInstances.lean` + the base-field shuffle (G10/G11 of the χ-recon).**
Serves: **E-iv**, and degAt/pic0Functor well-definedness across `K'`. (a) instances: `C_K := C ⊗ Spec K`
over `K` (2nd projection `Over`, `IsStableUnderBaseChange` gifts) is `IsIntegral` + smooth-of-rel-dim-1
+ LFT + QuasiCompact over `K` — so all of §2.3/§2.4 applies to `C_K`. (b) E-iv:
`deg`/`chi` invariance under `K ↪ K′` via landed `Over.sectionsBaseChange` + flat `⊗_K K′`; plus a
`CechPic`/`relPic` **base-field shuffle** `(C_{K}) ⊗_K K' ≅ C_{K'}` at the class level (absent, grep-empty).
**[GEO]** — instance transport + one flat-base-change colength argument. **Delegable-with-care.**
Partly **BLOCKED-on-χ** for the `chi` half.

**G-D6 [MIX, BLOCKED-on-G-D3] — `degAt` (design §6.2), `Picard/DegreeZero.lean`.**
Serves: **degAt** (its subject), pic0Functor. `degAt (λ : picEt C T) {K}[Field K][Algebra k K] (t : Spec K-point) : ℤ`
= restrict `λ` along `t` to `picEt C (overSpec k K)`, collapse via `picEtAffineEquiv` to `PicEtAff C K`,
represent by a descent class in `relPic C (overSpec k K')` (landed field cofinality
`exists_finiteSeparableField_algHom`), lift to `(C_{K'}).left.CechPic`, apply `classDeg` over `K'`
(G-D3), divide/normalize; well-defined across `K'` by E-iv (G-D5) + a Galois/refinement-invariance
argument. **[MIX]**, **BLOCKED-on-G-D3, G-D5**. **The well-definedness step is the second
(C2)-style risk (§5)** — it must be a genuine equality lemma, never a `Nonempty`/choice. Not
cleanly delegable until G-D3/G-D5 land.

**G-D7 [MIX, BLOCKED-on-G-D6] — `pic0Functor` (design §6.2), `Picard/DegreeZero.lean`.**
Serves: **pic0Functor** (its subject); the Wave-4 `RepresentableBy` datum carrier (§2.7). `pic0Functor C`
= subfunctor of `picEtFunctor C` with `T ↦ {λ | ∀ K t, degAt λ t = 0}` (a subgroup; restriction maps
restrict because a field point of `T'` composes to a field point of `T` — subfunctor stability is
**definitional**, design §6.2). Must be `(Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}` (§2.7 binding
carrier). **[MIX]** subgroup-subfunctor bookkeeping on `degAt`. **BLOCKED-on-G-D6.**

**G-D8 [GEO/MIX, BLOCKED-on-G-D7] — `abelElement` + `abelElement_map_point` + `abelElement_baseField`, `Picard/AbelElement.lean`.**
Serves: **abelElement** (its subject); frozen `ofCurve`/`comp_ofCurve` (§2.7). `abelElement (P : 𝟙_ ⟶ C) : pic0 C C`
= `picEtUnit`-image of `[𝒪(Δ)]·[𝒪(fst⁻¹P)]⁻¹` on `(C ⊗ C).left`; degree-0 certificate `deg 𝒪(Γ_t)=1`
(graph, G-D4 + E-i) and `deg 𝒪(P_K)=1` (point, G-D1 + E-i). `abelElement_map_point : (pic0Functor C).map P.op (abelElement P) = 1`
(the `comp_ofCurve` reduction, design §4.6). **[GEO/MIX]**, **BLOCKED-on** G-D4, G-D1, G-D7.

**Headline gap count: 8 (G-D1..G-D8).** Independent-of-χ and delegable-with-care now: **G-D1, G-D4**
(2, pure geometry on landed infra). Geometric hard core (the ballooning risk): **G-D2** (1). Blocked
on the χ-contract (G8/G9, landing in parallel): **G-D3, G-D5(partly)** (2). Blocked on earlier
degree gaps: **G-D6, G-D7, G-D8** (3). Interface ledger: E-i..E-iii = G-D1+G-D2+G-D3; E-iv = G-D5;
degАt = G-D6; pic0Functor = G-D7; abelElement = G-D8.

**Launch order.** (1) **G-D1** and **G-D4** in parallel now (χ-independent, landed infra). (2) **G-D2**
immediately after G-D1 (the risk probe — spec it as a design-worksheet-first campaign candidate, per
the (C2) lesson, §5). (3) **G-D3** + **G-D5** once G8/G9 lands green. (4) **G-D6 → G-D7 → G-D8** in
sequence. Do **not** merge G-D2 with G-D3 (unrelated hard cores; the 500-line rule). Do **not** gate
anything on the open (C2) effectivity campaign (§1.2).

---

## 4. Draft brick spec (house format) — **BRICK deg-D1: the point-divisor constructor and `divisorClass : CurveDivisor → CechPic` (gap G-D1)**

*One page, ready for the orchestrator to edit and launch. Chosen as the first brick for maximal
de-risking: it is (i) **χ-ledger-independent** (does not wait on G8/G9), (ii) **(C2)-independent**,
(iii) **landed-stack-only** (`DivisorClass.LocalEquations` + `StalksDVR`/`ClosedPoint` DVR infra),
(iv) the **foundation every interface item consumes** (E-i's subject, abelElement's point term,
G-D2/G-D4's pullback input), and (v) it settles the central structural question the whole lane rests
on — **can the cocycle model turn a Weil divisor into a Čech class cleanly?** — before any χ or
meromorphic-bridge work is committed. It is the degree lane's analogue of the χ-lane's skyscraper
first brick.*

---

**MISSION / CONTRACT.** Deliver `AlgebraicJacobian/Picard/GraphDivisor.lean` (point-divisor half; the
graph half is a later brick) — or extend `Picard/DivisorClass.lean` — providing, for the curve bundle
`{K : Type u} [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
[SmoothOfRelativeDimension 1 (X ↘ …)] [IsIntegral X] [LocallyOfFiniteType (X ↘ …)] [QuasiCompact (X ↘ …)]`:

```lean
/-- Local equations of the effective divisor `1·x` at a closed point `x`: a uniformizer on a
Dedekind chart through `x`, and `1` away from `x`. -/
noncomputable def Scheme.pointDivisor {x : X} (hx : x ≠ genericPoint X) : X.LocalEquations
/-- The Picard class of a Weil divisor. -/
noncomputable def Scheme.divisorClass (K) (D : X.CurveDivisor) : X.CechPic
theorem Scheme.divisorClass_add (D D') :
    divisorClass K (D + D') = divisorClass K D * divisorClass K D'
theorem Scheme.divisorClass_single_eq_pointDivisor {x} (hx) :
    divisorClass K (Finsupp.single ⟨x, hx⟩ 1) = (pointDivisor hx).picClass   -- normalization anchor
```

Binding in shape (carriers, data-vs-Prop, the `CurveDivisor`→`CechPic` typing, `divisorClass_add`
being a genuine `MonoidHom`-style additivity); spelling and the exact effective/anti-effective
factorization are lane-owned. `divisorClass` must be **total** on `CurveDivisor` (all of ℤ-coeffs,
via effective `·` inverse-of-effective). No `sorry`; axioms exactly `[propext, Classical.choice, Quot.sound]`.

**READ FIRST (in order).**
1. `informal/degree-pic0-recon.md` §2.2 (the landed `LocalEquations`/`picClass`/`mul`/`rescale` API),
   §2.3 (DVR/uniformizer/`CurveDivisor` infra), §2.8 (what is absent) — this file.
2. `AlgebraicJacobian/Picard/DivisorClass.lean` in full — especially `LocalEquations` (:112),
   `picClass` (:238), `mul`/`picClass_mul` (:333/:358), `rescale`/`picClass_rescale` (:413/:450). The
   `regular`/`ratio_isUnit` fields are what `pointDivisor` must construct.
3. `AlgebraicJacobian/RiemannRoch/ClosedPoint.lean` — `isDiscreteValuationRing_stalk` (:63),
   `stalkHeightOne` (PrincipalDivisor.lean:71), `isClosed_singleton_of_ne_genericPoint` (:80).
4. `AlgebraicJacobian/Curve/StalksDVR.lean:153` — `exists_isDedekindDomain_section` (the chart `V`
   with `x ∈ V`, `IsDedekindDomain Γ(X,V)`); and `RiemannRoch/Divisor.lean:40` — `CurveDivisor` is a
   **`def`** wrapper over `{x // x ≠ genericPoint X} →₀ ℤ` (go through `toFinsupp`/`Finsupp.single`).
5. `wave3-picard-design.md` §2.6(a,b) (the constructor spec) + §4.4's **choice-discipline note**
   (the uniformizer is data *inside* the construction; `picClass`-level independence via
   `picClass_rescale` — a different uniformizer differs by a unit, so the class is well-defined).

**PROOF ROUTE (pinned).**
- `pointDivisor hx`: cover = the pointed cover `{V, U}` with `V` = the Dedekind chart of
  `exists_isDedekindDomain_section x` (affine, `x ∈ V`, Dedekind sections) and `U` = the open
  complement of `{x}` (open by `isClosed_singleton_of_ne_genericPoint`). `eqn` = a uniformizer of the
  DVR `stalk x` spread to `Γ(X, V)` (a generator of the height-one prime `stalkHeightOne`), and `1`
  on `U`. `regular`: the uniformizer is a nonzerodivisor in every stalk over `V` (DVR is a domain);
  `1` is trivially regular. `ratio_isUnit`: on `V ⊓ U = V \ {x}` the uniformizer is a **unit**
  (invertible away from its zero locus `{x}`, `Scheme.ord_eq_one_of_mem_basicOpen`-style), and `1/1`
  is a unit.
- `divisorClass K D`: split `D = D⁺ − D⁻` (effective/anti-effective parts of the `Finsupp`), let
  `divisorClass K D⁺ := (∏ over supp of pointDivisor-classes to their multiplicities)` built via
  iterated `LocalEquations.mul` + `picClass_mul` (or directly on `CechPic` via the `CommGroup` power),
  and `divisorClass K D := divisorClass K D⁺ * (divisorClass K D⁻)⁻¹`. Prefer defining `divisorClass`
  **directly on `CechPic`** as `Finsupp.prod D (fun x n => (pointDivisor x.2).picClass ^ n)` (ℤ-power
  in the `CommGroup X.CechPic`), which makes `divisorClass_add` immediate from `Finsupp.prod_add_index`
  + the group law and sidesteps effective/anti-effective bookkeeping. Report which vehicle you used.
- `divisorClass_add`: `Finsupp.prod_add_index'` (or `map_add` if you package `divisorClass` as an
  `AddMonoidHom X.CurveDivisor (Additive X.CechPic)`); `divisorClass_single_eq_pointDivisor`:
  `Finsupp.prod_single_index` + `pow_one`.

**DESIGN CONSTRAINTS (kernel discipline — binding).**
- **Opaque defs** for `pointDivisor` and any chosen cover/cochain; never let the kernel unfold the
  cover into a `dite`/`if` tower during later `rw` (the recurring kernel-timeout failure mode — see
  the handoff's kernel discipline). Expose behaviour through named `@[simp]` lemmas.
- **`CurveDivisor` is a `def`** — read coefficients through `toFinsupp`/`Finsupp.single`/`Finsupp.prod`;
  `letI D' : {x // …} →₀ ℤ := D` where needed (as `divisorBound` does).
- **Uniformizer choice discipline (design §4.4):** the uniformizer is chosen *inside* `pointDivisor`;
  its class-independence is `picClass_rescale` (a second uniformizer differs by a unit on the chart).
  Prove `pointDivisor`'s class does not depend on the choice **only if a later brick needs it** — for
  deg-D1 the `def` may fix a choice; flag if you defer independence.
- Activate `Scheme.residueFieldOverModule`/`overModule` as `attribute [local instance]` **only if**
  you touch residue fields; `pointDivisor` itself needs none of the K-module instances.
- **No new axioms**; `set_option autoImplicit false`; file ≤ 500 lines; doc-comments after
  `set_option … in`; no binders with local-notation types in `variable`.

**VERIFICATION PROTOCOL (foreground, blocking — non-negotiable).**
1. `lake build AlgebraicJacobian.Picard.GraphDivisor` — kernel-green (one build at a time; never race
   the LSP).
2. Add the import to `AlgebraicJacobian.lean` (re-read on staleness, re-apply only your line), then
   `lake build AlgebraicJacobian` — root green.
3. `lean_verify AlgebraicGeometry.Scheme.divisorClass`, `…divisorClass_add`,
   `…divisorClass_single_eq_pointDivisor`, `…pointDivisor` — axioms exactly
   `[propext, Classical.choice, Quot.sound]` (use the live LSP `lean_verify`, NOT `lake env lean
   #print axioms` scratch files — they OOM on this box).
4. `grep -n -w sorry` on the touched file (exits 1 on zero matches). Do all steps in the FOREGROUND
   and block on them.

**REPORT FORMAT (final message).** 6–8 lines: (a) the four delivered signatures verbatim as compiled;
(b) which `divisorClass` vehicle (direct `Finsupp.prod` power vs effective/anti-effective) and why;
(c) whether uniformizer-choice independence was proved or deferred; (d) root-build job count +
green/red; (e) the exact `lean_verify` axiom lists; (f) file length. No prose beyond this.

---

## 5. Honest risk — where this lane could go the way of (C2), and what I could not verify from reading alone

The cautionary precedent is real and recent: the (C2) recon (§3) sketched the surjectivity finish as
**one delicate step**; the implementing session found it is actually **fppf effectivity along `cg` — a
ζ2/ζ3-scale campaign**, and it is still open. The degree lane has **two** structurally analogous
ballooning candidates, and I could not rule either out by reading:

1. **G-D2, the meromorphic ∃-bridge ("every class over integral `C_K` is a divisor class").** The
   design cites it as a one-line Hartshorne quote (II.6.15) and a "cocycle proof shape" (localize
   `g x x₀` into the function field). In the cocycle model over a *general* integral curve this is a
   genuine theorem: it needs that a Čech unit cocycle, localized at the generic point, produces a
   *global* meromorphic section whose divisor is finite-support and whose local equations are
   regular — the honest content of "invertible sheaf on an integral scheme ⇒ divisor class." The
   landed `divisorSheaf`/`ord` infra makes the *forward* direction (G-D2(i): `divisorSheaf K D` is
   invertible of class `divisorClass K D`) plausible-to-cheap, but the **surjectivity** (ii) — every
   cocycle is *some* `divisorClass K D` — is exactly the kind of statement that reads as one lemma and
   lands as a campaign (finiteness of the meromorphic divisor, regularity on overlaps, the sheaf
   condition to glue the local trivializations). **I could not verify from reading that this is not a
   multi-brick effort.** Mitigation: spec G-D2 with a **design worksheet first** (as the handoff
   mandates for the (C2) effectivity campaign), and note that E-i/E-ii for **effective, explicitly
   presented** divisors (G-D1 + G-D3 without G-D2's surjectivity) already suffice for `abelElement`
   (whose classes are *given* as graph/point divisors) — so `abelElement`, `comp_ofCurve`, and hence
   the *frozen* Abel–Jacobi statements may not need the full bridge, only its forward direction. The
   bridge's *totality* is needed to make `classDeg` a hom on **all** of `CechPic`, i.e. for the clean
   `pic0Functor` — that is where it becomes load-bearing.

2. **G-D6, `degAt` well-definedness across the representing field extension `K'`.** The design says
   "take deg over `K′` … well-defined by (E-iv)." Field cofinality is landed, but the actual
   well-definedness is: two different finite-separable `K'`, `K''` representing the *same* `picEt`
   class must give the *same* `degAt`. This is a base-change/Galois-invariance equality (E-iv +
   compatibility along a common refinement `K'⊗K''`). I could not verify from reading that the landed
   `Over.sectionsBaseChange` + the (absent) base-field shuffle close it in a bounded way rather than
   forcing a Galois-descent argument on the degree — the same *shape* of hazard that made (C2) balloon
   (a "compatible across the cover" condition that turns out to need genuine descent). The **binding
   guard** (from the (C2)/old-draft lessons, §2.8 of the (C2) recon): `degAt` must be a genuine
   function with a proved well-definedness *equality*, **never** `Nonempty`/`Classical.choice` over
   the representing `K'`.

3. **The χ-contract handoff seam.** E-i/E-iii rest on `chi_divisorSheaf`/`deg_divOf` from the G8/G9
   brick, which was **not yet in the tree** at recon time (handoff commit `7fe83d9bf8` left G8+G9 as
   the open ledger frontier; `spec-chi-g8-g9.md` is written but unlanded). If G8/G9's `chi_divisorSheaf`
   lands with a *different* spelling of `deg` or a stronger hypothesis budget (e.g. an extra
   `QuasiCompact`/`LocallyOfFiniteType` than the degree brick assumes), G-D3 inherits it. I could not
   verify the final landed shape — only the contract in the spec. Gate G-D3's launch on G8/G9 green
   and re-extract its exact signatures first.

Lower-order unknowns I could not settle by reading: whether `C_K = C ⊗ Spec K` acquires `IsIntegral`
as an *instance* (geometric integrality of `C/k` should give it, but the base-change instance file is
absent — G-D5); whether the diagonal `Δ ⊂ (C⊗C).left` being a relative effective divisor is a
short mathlib-gift or a build (G-D4); and whether the `Finsupp.prod` power vehicle for `divisorClass`
(§4) interacts cleanly with the `CommGroup X.CechPic` `zpow` (a kernel-unfold risk on the quotient).

**Net:** the lane is genuinely unblocked and its foundation (G-D1) and χ substrate are solid, but its
*honest-ledger* keystone (G-D2) and its *degAt well-definedness* (G-D6) are the two places a
"one-shot finish" assumption could be wrong the way (C2)'s was. Spec both worksheet-first; lead with
the safe, foundational, χ-independent G-D1 (§4) to bank the structural win before probing the risk.

---

*End of recon. §1.2 records the (C2) correction's (non-)effect; §3 headline = 8 gaps (G-D1..G-D8);
§4 is a launch-ready first brick that is safe under the χ-ledger landing in parallel and independent
of the open (C2) campaign; §5 flags G-D2 (meromorphic bridge) and G-D6 (degAt well-definedness) as
the two campaign-risk candidates.*
