# W4-G4 WORKSHEET — the universal-family slice (2026-07-18, Fable design lane)

*Brick G-4 of `informal/spec-w4-gates.md` Addendum 1: over each `Z(♦)`-chart ring
`R_Z := DivCarveChartRing k A B g r₁ r₂ b₁ b₂ i j` (`Picard/DivSchemeFamilyUniv.lean:55`,
Noetherian by `:60-63`), build the universal certified divisor family and its
ε-projection identity. Every citation below is a `file:line` from a direct read this
pass. Campaign instantiation throughout: `A := windowS_choice π hπ g • fiberWeilDivisor π`,
`B := windowM_choice π hπ g • fiberWeilDivisor π` (`Picard/DivCarveLocus.lean:43-44`),
so `A + B = (M+s)·F`; `r₁ = dim_k H⁰(𝒪(M·F))`, `r₂ = dim_k H⁰(𝒪((M+s)·F))` through the
boundary bases `b₁ : Basis (Fin r₁) k ↥(divisorSections k B ⊤)`,
`b₂ : Basis (Fin r₂) k ↥(divisorSections k (A+B) ⊤)` (`DivSchemeFamilyUniv.lean:49-50`).*

## §0. Verdict box (read this first)

1. **P-fib does NOT match the universal pair as stated — three-fold shape gap, one of
   them structural.** (a) ambient: P-fib's `K_M, K'` are submodules of the fibre curve's
   `functionField` (`RiemannRoch/PFib.lean:244,:248`); the universal fibres are kernels
   in the coordinate ambients `κ(q) ⊗[k] (Fin rᵢ → k)` (`DivSchemeFamilyUniv.lean:141-144`).
   (b) corank spelling: P-fib wants `finrank K_M + g = h⁰(...)` (`PFib.lean:246-247`);
   the kernels carry corank `g` as Grassmannian structure. Both (a),(b) are the expected
   DD-4 transport seam. (c) **structural**: P-fib is pinned to the fibre field's OWN
   ledger constants `windowM_choice π hπ g` (`PFib.lean:245,:250`), and per the I-0204
   binding finding the ledger constants do NOT transport across `k → κ(p)`
   (`RiemannRoch/WindowFieldTransport.lean:19-21`). The transported window is the honest
   divisor `N` of the N-pack, with facts `hNwin/hNdeg/hNnorm/hNrank`
   (`WindowFieldTransport.lean:37-45,:307-397`), NOT the fibre-ledger window. **A
   pack-parametrized restatement of P-fib (`P-fib-N`, §1.4) is a required new brick.**
2. **G-0 as an H¹-comparison is ALREADY LANDED — the `GluedSheafFibre.lean:28-31`
   "not yet landed" docstring is STALE.** The fibre-restriction seam is closed:
   `BasicOpenCocycleDatum.subsingleton_h1_residueField_tensor_of_witness`
   (`Cohomology/GluedSheafDatumFibre.lean:169`) and its theta-ideal instantiation
   `thetaIdealDatum_hfib_of_witness` (`Picard/DivisorThetaFibre.lean:67`) already turn a
   per-fibre witness divisor with vanishing `H¹` into exactly the engine's `hfib`. What
   G-0 actually still needs (shared with G-1) is the **witness production**: the
   class-degree law of the theta-ideal datum + the seed-built fibre-divisor
   identification (§2.3) — named residual at `DivisorThetaFibre.lean:33-34`.
3. **The certificate is genuinely unproduced.** No producer of `IsCertified` from
   scratch exists (only the pullback transport, `Picard/DivisorFamilyMapAlg.lean:245`).
   Landed per-clause substrate covers (c1)-projectivity and the (c2)-(c4) *transports*;
   the open production hearts are (c1)-finiteness (support-tube algebraic half) and
   (c3)/(c4) (the spec-dd-r §7 risk-1 flattening residue) — §3.
4. **`hle₂` has a clean anti-circular route** (mulSpan + fibrewise bpf-span + f.g.
   Nakayama, §4.2) that never uses the false "fibrewise ⟹ relative" lemma (risk 5);
   the spec's colon-Tor hint is kept as fallback. `hsurj₁/hsurj₂` fall out of the
   landed `thetaGluedEval_surjective` (`Picard/DivisorThetaSurjectivity.lean:487`) once
   §2's certificate-free `hfib` stands — no G-1 dependence.
5. Biggest risks, in order: the P-fib-N restatement (new proof-shaped work on the
   RiemannRoch layer), (c3)/(c4) production, the fibre dictionary Φ_κ (G-3's ambient
   form consumed at every residue field), (c1) finiteness. §5.

---

## §1. The seed construction (`DivSchemeSeedUniv`)

### §1.1 What `ThetaGeneratorSeed` is, verbatim

`ThetaGeneratorSeed C R π a K` (`Picard/DivSchemeFamily.lean:74-86`) is a structure over
a fixed submodule parameter `K : Submodule R (relThetaSections C R π a)` with fields:

```
side : relCurve C R → Bool                                            -- :78
h    : ∀ z, Γ(relCurve C R, relPinnedChart C R π (side z))            -- :80
mem_basicOpen : ∀ z, z ∈ (relCurve C R).basicOpen (h z)               -- :82
sec  : relCurve C R → relThetaSections C R π a                        -- :84
sec_mem : ∀ z, sec z ∈ K                                              -- :86
```

with `relThetaSections C R π a = ↥(twistSubmodule R V₀ V₁ (relThetaCocycle C R π a) ⊤)`
(`Picard/DivisorFamilyTheta.lean:59-61`). The two `lm:ctn` clauses are
`IsGenerator` (`DivSchemeFamily.lean:129-137`): `dvd` (side component of every `ψ ∈ K`
lies in `Ideal.span {D.eqn z}` on the piece) and `fibre_regular` (the equation's pure
tensor is a nonzerodivisor in `Γ(basicOpen f) ⊗[R] κ(p)` for every `p` and every basic
sub-open). From a seed with `IsGenerator`: `localEquations` (`:349`), `divisorAdaptation`
(`:367`, via `exists_divisorAdaptation`, `Picard/DivisorFamilyExtraction.lean:54`),
`le_vanishingSubmodule` (`:397` — the `hle₁` half of DDR-5), and `certifiedFamily`
(`Picard/DivSchemeEps.lean:234`) once a certificate stands.

### §1.2 What `K` is at the universal point (the exact composite)

The ε-identity consumes a seed at
`K = Submodule.map (relThetaWindowEquiv C R π M hH1).toLinearMap x₁.toSubmodule`
(`DivSchemeEps.lean:315-318`, `M := windowM_choice π hπ g`,
`hH1 := relThetaPairH1_windowM C π hπ g`, `Picard/DivisorFamilyWindow.lean:236-241`).
The universal `x₁` must be manufactured from
`divUniversalFst = Module.Grassmannian.map (divCarveChartMk …) (pairTautFst k g r₁ r₂ i j)`
(`DivSchemeFamilyUniv.lean:72-75`), whose submodule is
`LinearMap.ker (Module.Grassmannian.baseChangeMkQ R_Z (pairTautFst …).toSubmodule)`
(the span description `ker_baseChangeMkQ_eq_map_baseChange`,
`Picard/DivCarveKit.lean:168-183`; used exactly so at `Picard/DivCarveLocus.lean:206-217`).
Its ambient is `R_Z ⊗[k] (Fin r₁ → k)`; the window ambient is `R_Z ⊗[k] H_M`,
`H_M := ↥(divisorSections k (M • fiberWeilDivisor π) ⊤)`. **Pin the composite:**

```
K_univ := Submodule.map
    ((relThetaWindowEquiv C R_Z π (windowM_choice π hπ g) hH1).toLinearMap
      ∘ₗ (LinearMap.baseChange R_Z b₁.equivFun.symm.toLinearMap))
    (LinearMap.ker (Module.Grassmannian.baseChangeMkQ R_Z
      (pairTautFst k g r₁ r₂ i j).toSubmodule))
```

(`relThetaWindowEquiv` at `DivisorFamilyWindow.lean:89-94`; `b₁.equivFun.symm` is the
same basis leg as `divCarveMul = b₂.equivFun ∘ₗ sectionMulBilin k A B a ∘ₗ
b₁.equivFun.symm` (`DivCarveLocus.lean:268-270`) — one recorded seam, reuse the same
spelling). Mirror `K'_univ` with `b₂`, `M+s`, `pairTautSnd`. **Needed helper (small,
new):** `grPointCongr` — transport of a `grFunctorAff` point along a `k`-linear equiv of
the ambient (`grFunctorAff k H d R = Module.Grassmannian R (R ⊗[k] H) d`,
`Picard/GrassmannianFunctor.lean:53-55`); `x₁ := grPointCongr b₁.equivFun.symm
(divUniversalFst …)` — finite/projective/rank clauses transport along the quotient
equivalence. I did not find such a congr in the project; pin it in `DivSchemeSeedUniv`.

`K_univ` is finite projective over `R_Z` certificate-free: its ambient quotient is the
Grassmannian point's projective rank-`g` quotient (`finite_pairTautFst`,
`DivCarveLocus.lean:80-83`, and the retract kit `finite_submodule_of_projective_quotient`
/ `quotRetract`, `DivCarveKit.lean:82-85`). This is what makes the achiever lift (§1.5)
anti-circular.

### §1.3 The fibrewise input, verbatim, and the shape check

`divUniversal_carve_residueField` (`DivSchemeFamilyUniv.lean:135-147`): for every prime
`q` of the PAIR chart ring with `divCarveIdeal … ≤ q.asIdeal` and every
`s : ↥(divisorSections k A ⊤)`,

```
carvePairArrow (divCarveMul k A B r₁ r₂ b₁ b₂ s)
  (LinearMap.ker (baseChangeMkQ κ(q) (pairTautFst …).toSubmodule))
  (LinearMap.ker (baseChangeMkQ κ(q) (pairTautSnd …).toSubmodule)) = 0
```

with `carvePairArrow μ Km K' = K'.mkQ ∘ₗ LinearMap.baseChange R μ ∘ₗ Km.subtype`
(`DivCarveKit.lean:120-123`) and the elementwise unfolding
`carvePairArrow_eq_zero_iff : … = 0 ↔ ∀ x ∈ Km, baseChange R μ x ∈ K'`
(`DivCarveKit.lean:126-128`).

P-fib `existsUnique_effective_divisor_of_carve` (`PFib.lean:241-259`), hypotheses
verbatim: over a field `K` with curve `Y`, `hO : h0 = 1`, `hχ : chi = 1 − g`,

```
KM : Submodule K Y.functionField
hKM : KM ≤ divisorSections K (windowM_choice π hπ g • fiberWeilDivisor π) ⊤
hKMrank : finrank K KM + g = h⁰(𝒪(M·F))
K' : … ≤ divisorSections K ((M+s)·F) ⊤,  hK'rank : finrank K' + g = h⁰(𝒪((M+s)·F))
hcarve : ∀ h ∈ divisorSections K (s·F) ⊤, ∀ f ∈ KM, h * f ∈ K'
```

conclusion: `∃! D, 0 ≤ D ∧ deg D = g ∧ KM = H⁰(M·F − D) ∧ K' = H⁰((M+s)·F − D)`.

**The shape check (the finding).** A "carve pair of corank exactly g" in P-fib means:
function-field submodules under the FIBRE-LEDGER windows with the finrank+g=h⁰ corank
spelling and elementwise multiplication. The universal fibre is the kernel pair of the
tautological quotients in coordinates, with corank `g` as Grassmannian data, carve as
`carvePairArrow (divCarveMul …) = 0`, and — decisively — under the **transported**
window class (deg `M_k · δ`), not the fibre-ledger window (`M_{κ(q)} · δ`). Bridging
(a)+(b) is the intended DD-4 seam (bases + `relThetaWindowEquiv` at `κ(q)` + the Φ
dictionary); bridging (c) is impossible by transport (I-0204): **P-fib must be
restated.**

### §1.4 P-fib-N (required new brick, `RiemannRoch/PFibPack.lean`)

Statement pin (same conclusion, pack-parametrized windows; `Y/K` as in PFib.lean:54-62):

```
theorem existsUnique_effective_divisor_of_carve_pack
    (g : ℕ) (hO : Sheaf.h0 (Y.moduleKSheaf K) = 1) (hχ : Sheaf.chi … = 1 - (g:ℤ))
    (N Ns S : Y.CurveDivisor)                    -- N ~ Θᴹ, Ns ~ Θᴹ⁺ˢ, S ~ Θˢ, Ns = N + S
    (hNS : Ns = N + S)
    (hNwin : Subsingleton (H¹(𝒪(N))))  (hSwin : Subsingleton (H¹(𝒪(S))))
    (hNdeg : 2*(g:ℤ) ≤ deg K N)
    (hNnorm : ∀ D', deg K D' ≤ 2*(g:ℤ) → Subsingleton (H¹(𝒪(N − D'))))
    (hNsnorm : ∀ D', deg K D' ≤ 2*(g:ℤ) → Subsingleton (H¹(𝒪(Ns − D'))))
    (KM …≤ divisorSections K N ⊤) (hKMrank : finrank KM + g = h⁰(𝒪(N)))
    (K' …≤ divisorSections K Ns ⊤) (hK'rank : finrank K' + g = h⁰(𝒪(Ns)))
    (hcarve : ∀ h ∈ divisorSections K S ⊤, ∀ f ∈ KM, h*f ∈ K') :
    ∃! D, 0 ≤ D ∧ deg K D = g ∧ KM = divisorSections K (N − D) ⊤
      ∧ K' = divisorSections K (Ns − D) ⊤
```

Feasibility check against the landed proof: PFib's internals consume the ledger only
through `rank_embedding_of_genus`/`rank_normalization(_shift)`
(`PFib.lean:267-276,:304-307,:344-348`), `two_mul_genus_le_M_mul_windowδ` (`:265`),
`h0_le_deg_add_one_of_pos` (`:301`), the strict-drop/`baseDivisorAt` lemmas
(`:71,:127`) and the bpf-span core `mulSpan_eq_divisorSections_of_basepointFree`
(`:326-330`, home `RiemannRoch/BpfSpan.lean:70`). The rank identities are recoverable
from the pack via `h0_eq_deg_add_chi_of_subsingleton_hModule_one` (the pattern already
demonstrated at `WindowFieldTransport.lean:342-345`); the drop/base-divisor layer
(`RiemannRoch/BaseDivisor.lean:143,:160,:178`) is window-free already. The bpf-span
lemma's own window threading must be audited the same way (not read line-by-line this
pass — first task of the P-fib-N lane). Size M→L. This brick is the gate of everything
fibrewise below. The N-pack instances at `κ(p)`:
`windowN`/`subsingleton_h1_windowN`/`deg_windowN`/`two_mul_genus_le_deg_windowN`/
`h0_windowN`/`subsingleton_h1_windowN_sub` (`WindowFieldTransport.lean:307-397`) plus
the `s`-window `relThetaPairH1_windowS` (`:298-303`); an `Ns`-analogue of `hNnorm` is
the same peeling engine (`subsingleton_hModule_one_of_witness`, `:87-107`). The `hO/hχ`
inputs at `κ(p)` discharge through the base-change instance pack
(`Cohomology/GluedSheafDatumFibre.lean:180-187` shows the firing pattern) +
`h0_moduleKSheaf`/`chi_moduleKSheaf` (`RiemannRoch/ChiCurve.lean:135,:148`) +
`genus_baseField` (`Cohomology/H1BaseFieldInvariance.lean:373`).

### §1.5 How each seed field is produced (the choice pipeline)

Fix `z : relCurve C R_Z`, let `p := image of z in Spec R_Z` and `q` its pair-chart-ring
prime (`hq : divCarveIdeal ≤ q.asIdeal`).

* **Fibre divisor**: transport the kernel pair at `κ(q)` through
  `b₁/b₂ ⊗ κ` and the fibre dictionary Φ_κ (§1.6) into function-field windows under
  `(N, Ns)`; corank `g` from the split fibre SES (`ker_baseChange_mkQ`,
  `DivCarveKit.lean:91-106`, over a field) + `hNrank` (`h0_windowN`); carve from
  `divUniversal_carve_residueField` + `carvePairArrow_eq_zero_iff` + the Φ-compatibility
  of `sectionMulBilin` with function-field multiplication (a G-3 interface clause,
  §1.6). Fire P-fib-N: get `d_p` effective of degree `g` with both window equalities.
* **`side z`, `h z`, `mem_basicOpen`**: the fibre achiever
  `Scheme.exists_coeffAt_eq_baseDivisorAt` (`RiemannRoch/BaseDivisor.lean:143-154`) at
  the image point of `z` gives `f_p ∈ K_M-fibre` of exact order; pick the pinned chart
  side containing `z` (`side z`); the neighbourhood generator `h z` comes from the
  Nakayama-neighbourhood step below (a chart section whose basic open both contains `z`
  and keeps the fibre nonvanishing).
* **`sec z`, `sec_mem`**: lift `f_p` along the surjection `K_univ ↠ K_univ ⊗ κ(p)`
  (`K_univ` finite projective certificate-free, §1.2 — surjectivity of `M → M ⊗ κ(p)`
  is `mkQ`-composition, no engine needed). `sec_mem` is by construction.
* **Nakayama neighbourhood / `dvd`**: the AMBIENT image of `sec z` in the free window
  `R_Z ⊗[k] H_M` keeps its fibre nonvanishing on a coordinate basic open —
  `Module.exists_forall_tmul_residueField_ne_zero` (`Picard/DivSchemeSeed.lean:264-278`,
  the element-keeping free-module form; the projective generators corollary
  `Module.exists_fibrewise_tmul_ne_zero_of_projective`, `Picard/LocalGenerators.lean:87-118`,
  is the fallback when only *some* section is needed). The `dvd` clause itself
  (side component of every `ψ ∈ K_univ` divisible by `eqn z` on the piece) is the
  relative upgrade of the fibre exactness `K_M-fibre = H⁰(N − d_p)`: at each fibre the
  cofactor exists (fibre curve, exact orders); the relative divisibility engine is
  `Algebra.TensorProduct.includeRight_mem_nonZeroDivisors_of_forall_tmul_residueField`
  (`Picard/SlicingFlat.lean:356-366`, "the relative-divisibility engine of the seed
  `dvd` brick" per `SlicingFlat.lean:52-56`) + the ideal-division engine
  `Module.Flat.mem_smul_top_of_apply_mem_smul_top` (`SlicingFlat.lean:79`). This is
  design-level M work; the k[ε] guard (risk 5) is respected because divisibility is
  routed through regular-element cancellation, never through fibrewise vanishing.
* **`IsGenerator` discharge**: `ThetaGeneratorSeed.isGenerator_of_fibre_ne_zero`
  (`Picard/DivSchemeSeed.lean:188-197`) takes exactly `hdvd` + `hfib` (fibrewise
  nonvanishing of the compared chart component,
  `relPinnedSectionsMap C R κ(p) π (side z) (relThetaResSide a (side z) le_rfl (sec z)) ≠ 0`
  whenever the fibre piece is nonempty) — the latter is §1.5's Nakayama clause
  transported through the fibre comparison (`relPinnedSectionsMap`,
  `DivSchemeSeed.lean:61-65`) and integrality of the fibre curve
  (`relPinned_tmul_one_mem_nonZeroDivisors`, `:85-109`, already does the
  nonzero-section ⟹ regular step).

### §1.6 The Φ_κ interface consumed from G-3 (pin, do not build here)

Every fibrewise step above needs, at an arbitrary field extension `K/k` (used at
`K = κ(p)`): an injective `K`-linear `Φ : K ⊗[k] H_a →ₗ[K] (relCurve C K).functionField`
with (i) image dictionary `Submodule.map Φ (window submodule) = divisorSections K
(windowTransportDivisor C K π a − D) ⊤`-shaped identifications, and (ii)
multiplicativity against `sectionMulBilin` (so `divCarveMul`-carves become elementwise
`h*f` carves). G-3's pinned keystones (`spec-w4-gates.md` §G-3: `divFamPhi`,
`divFamPhi_injective`, `map_divFamPhi_eps_fst`) are exactly this shape; the CarveDegree
seam name for (i) is `hdict` ("the sections dictionary at the field point, DD-4 Task 5
field content — still open", `WindowFieldTransport.lean:47-49`,
`RiemannRoch/CarveDegree.lean:43-47`). **G-4 must state its fibre steps against a named
Φ-pack hypothesis so the G-3 landing slots in without restating** (spec-dd-r §7 risk 2
discipline).

---

## §2. G-0 — the fibre H¹ story (shared with G-1)

### §2.1 What exists TODAY (all landed; the recon's gap is stale)

* `subsingleton_datumPair_h1_iff` (`Cohomology/GluedSheafFibre.lean:109-111`):
  `H¹(pair) = 0 ↔ H¹(datum sheaf) = 0` (the flagged iff — it is step (b), not the seam).
* `datum_subsingleton_h1_residueField_tensor_iff` (`GluedSheafFibre.lean:119-125`):
  `Subsingleton (H¹(pair D) ⊗[B] κ(p)) ↔` cokernel of the base-changed Čech
  differential vanishes (right-exactness, `TwoLatticePair.h1BaseChangeEquiv` `:68-73`).
* **The seam, closed** (the `GluedSheafFibre.lean:26-31` "not yet landed" note is
  superseded): `BasicOpenCocycleDatum.subsingleton_h1_tensor_of_baseChange`
  (`Cohomology/GluedSheafDatumFibre.lean:78-100`; via the δ-naturality square
  `datumDiffBaseChange`) gives `H¹(pair (D.baseChange B')) = 0 ⟹
  Subsingleton (H¹(pair D) ⊗[B] B')`; composed with the presentation bridge
  (`presentationSheafIso`, `:126-135`) and the W6-full export
  (`subsingleton_sheaf_h1_of_picClass_eq`, `:142-153`) it closes as
  `subsingleton_h1_residueField_tensor_of_witness` (`:169-190`).
* On the theta-ideal datum (`thetaIdealDatum`, definition read at
  `Picard/DivisorThetaDatum.lean:362-398`: the adaptation's cover data with the
  `thetaIdealUnit = eqnRatio · thetaOvlUnit` cocycle): `thetaIdealDatum_hfib_of_witness`
  (`Picard/DivisorThetaFibre.lean:67-79`) and
  `thetaGluedEval_surjective_of_fibre_witness` (`:87-97`).
* The RigidEngine4 base-change kit (`Cohomology/RigidEngine4BaseChange.lean:9-38`:
  `relTwistPairDiffBaseChange:412`, `relTwist_subsingleton_h1_baseChange:445`,
  `relTwistH0BaseChange:471`) is the TWIST-pair mirror of the same square — relevant to
  G-1's arbitrary-certified-family route, not needed for G-4's datum route.

So the direction G-4 (and G-1) needs — fibre datum H¹ vanishing ⟹ engine `hfib` —
exists on the nose. **No new H¹-comparison lemma is required.**

### §2.2 What "P-fib's windows exact" buys, precisely

P-fib(-N) at `κ(p)` gives `deg d_p = g` and the window equalities. The `hfib` witness
route then needs `H¹(C_κ, 𝒪(W)) = 0` for a witness `W` in the FIBRE DATUM's class. Take
`W := windowTransportDivisor C κ(p) π a − d_p` (`a ∈ {M, M+s}`): its `H¹` vanishes by
the transported normalization `subsingleton_h1_windowN_sub`
(`WindowFieldTransport.lean:362-396`) at `deg d_p = g ≤ 2g` (and the `M+s` analogue via
the same peeling `subsingleton_hModule_one_of_witness:87`). So the "windows exact"
output enters only through `deg d_p = g`; the H¹ input is the N-pack normalization, not
window exactness per se.

### §2.3 The genuinely missing statement (THE G-0 brick, own file)

The witness must lie in the fibre datum's class:
`CurveDivisor.picClass κ(p) W = ((A.thetaIdealDatum a).baseChange κ(p)).cechPicClass`
(the hypothesis shape at `DivisorThetaFibre.lean:70-71`). Landed halves:
`cechPicClass_baseChange` (`Cohomology/GluedSheafClass.lean:358`) reduces the RHS to
`CechPic.map (relCurveMap C R κ(p)) (thetaIdealDatum a).cechPicClass`, and the
LocalEquations class transports (`Picard/LocalEquationsPullback.lean:173`,
`picClass_mapAlg` `Picard/DivisorFamilyMapAlg.lean:288-290`). Missing (named residual,
`DivisorThetaFibre.lean:33-34`), pin as two lemmas:

```
-- (G-0a) the class law of the theta-ideal datum, relative form:
theorem cechPicClass_thetaIdealDatum (A : DivisorAdaptation C R π d) (a : ℕ) :
    (A.thetaIdealDatum a).cechPicClass
      = (thetaChartDatum C R π a).cechPicClass * (d.picClass)⁻¹
-- vocabulary: LocalEquations.picClass (Picard/DivisorFamily.lean:136-138 laws),
-- cechPicClass_thetaChartDatum (Cohomology/RelCurveCollapse.lean:641) computes the Θ leg.

-- (G-0b) the fibre divisor of the seed-built system IS the P-fib divisor:
theorem picClass_baseChange_localEquations_eq_picClass_pfibDivisor … :
    CechPic.map (relCurveMap C R_Z κ(p)) (D.localEquations hD).picClass
      = CurveDivisor.picClass κ(p) d_p
-- route: the base-changed seed equations cut d_p on the fibre curve — the fibre of
-- eqn z has exact order coeffAt d_p (P-fib-N uniqueness leg, baseDivisorAt_normalization
-- PFib.lean:127); field-level home: divFamDivisor / presentationDivisor
-- (Picard/DivisorFamilyField.lean:126-135, coeffAt_divFamDivisor :137-143).
```

Together with §2.2 these discharge, certificate-free:

```
-- (G-0 keystone) hfib at the universal adaptation:
theorem thetaIdealDatum_hfib_univ … :
    ∀ p : PrimeSpectrum R_Z,
      Subsingleton ((datumPair ((D.divisorAdaptation hD).thetaIdealDatum a)).H1
        ⊗[R_Z] p.asIdeal.ResidueField)      -- a ∈ {M, M+s}
```

which is verbatim the `hfib` slot of `thetaGluedEval_surjective`
(`DivisorThetaSurjectivity.lean:487-495`), of
`subsingleton_hModule_thetaIdealDatum_one` / `finite_vanishingSubmodule` /
`projective_vanishingSubmodule` (`Picard/DivSchemeCertificateEngine.lean:306,:318,:330`),
of `finite/projective_divisorWindow` (`:373,:387`) and of `finite_thetaGlued` (`:406`).
Distinction from G-1 confirmed: G-1 derives the same `hfib` FROM a certificate for
arbitrary families; here it is produced certificate-free from P-fib — the anti-circular
order is the binding banner at `DivSchemeCertificateEngine.lean:34-36`.

---

## §3. The certificate discharge (`DivSchemeCertUniv`)

`IsCertified` fields, verbatim (`Picard/DivisorFamily.lean:426-441`):
(c1) `finite_colength`/`projective_colength : ∀ j, Module.Finite/Projective R (A.colength j)`;
(c2) `finite_glued`/`projective_glued`/`rankAtStalk_glued : ∀ p, rankAtStalk A.Glued p = n`
on `Glued = ↥(gluedSubmodule) = ker (deltaLeft − deltaRight)` (`:399-416`);
(c3) `flat_coker_incl : Flat R (chartProd ⧸ gluedSubmodule)`;
(c4) `flat_coker_diff : Flat R (ovlProd ⧸ range (deltaLeft − deltaRight))`.

Per-field ledger (engine lemma + exact remaining hypotheses):

| clause | landed engine lemma | remaining hypotheses / gaps |
|---|---|---|
| (c1) projective | `projective_colength_of_forall_tmul_residueField` (`Picard/SupportTube.lean:329-341`) | (i) fibrewise regularity of `A.eqn j` — the seed's `fibre_regular` transported through `eqn_rel` ("the I-0203 open transport item", `SupportTube.lean:305-312`); (ii) `[Module.Finite R (A.colength j)]` from (c1)-finite |
| (c1) flat (stepping stone) | `flat_colength_of_forall_tmul_residueField` (`SupportTube.lean:313-324`), core `Module.Flat.quotient_span_singleton_of_forall_tmul_residueField` (`SlicingFlat.lean:317`) | same (i) |
| (c1) finite | **NONE — open production brick.** Topological kit landed: `exists_supportTube` (`SupportTube.lean:166`), `supportLocus_inter_pieces` (`:284`), properness licence `instIsProperRelCurveHom` (`SupportTube.lean:40-43` docstring) | the algebraic half: colength `Γ(D(h_j))⧸(f_j)` finite over `R_Z` from proper support + fibrewise finiteness (fibre colengths are artinian of total dim `g` by P-fib-N). Honest size M→L; Kleiman's finiteness-of-the-divisor-subscheme step |
| (c2) finite | free over Noetherian: `gluedSubmodule ≤ chartProd`, `chartProd` finite by (c1) ⟹ submodule finite (`IsNoetherian`) | (c1)-finite |
| (c2) projective | SES `0 → Glued → chartProd → chartProd⧸Glued → 0` with (c3)-flat quotient ⟹ `Glued` flat; flat+finite ⟹ f.p. ⟹ projective (the pattern at `SlicingFlat.lean:346-348`) | (c3) |
| (c2) rank = g | fibre computation via `gluedBaseChange` (`Picard/DivisorFamilyPullbackGlued.lean:145`, "the (c2) keystone", needs (c3)/(c4)) at `κ(p)`: `Glued ⊗ κ(p) ≅ fibre-Glued`; then `dim_κ(fibre-Glued) = g` | the fibre count: via fibre `windowQuotEquiv` (`DivisorFamilyWindow.lean:179`) corank `g` (P-fib-N + Φ_κ) + a twisted↔untwisted FIELD rank comparison — `IsThetaPaired` holds at the fibre from finite chart-1 colengths (`isThetaPaired_of_finite_colength`, `Picard/DivisorThetaPairing.lean:310`), and an invertible module over the artinian fibre algebra `A_D` has `dim = dim A_D` (extract from `InvertibleModuleTransfer`; small new lemma). Alternative: the field CRT colength↔degree identity — flagged open at `DivisorFamilyField.lean:147-151` — avoid it |
| (c3)/(c4) | **NONE — the risk-1 heart.** Substrate: the Noetherian ideal-division engine `Module.Flat.mem_smul_top_of_apply_mem_smul_top` (`SlicingFlat.lean:79`) and `Module.Flat.of_surjective_exact_of_forall_rTensor_residueField_injective` (`SlicingFlat.lean:268-275`) — but both are ENDOMORPHISM-shaped; `δ' := deltaLeft − deltaRight : chartProd → ovlProd` is not | pin the abstract brick (working name `Module.Flat.coker_flat_of_forall_rankAtStalk_ker_eq`): over Noetherian `R`, for `δ' : M → N` of finite projective modules with `dim_κ ker(δ' ⊗ κ(p))` constant `= g`, both `M ⧸ ker δ'` and `N ⧸ range δ'` are flat and `ker δ'` is finite projective of rank `g`. Fibre input from P-fib-N (all fibre kernels are the `g`-dimensional fibre glued modules). Generalizing the SlicingFlat Noetherian induction from `φ : M → M` to `δ' : M → N` is the honest new mathematics; size L |

**Order (binding, anti-circular):** fibrewise inputs from P-fib-N on the carve pair
(§1-§2, certificate-free) → (c1) → (c3)/(c4) → (c2) → assemble

```
theorem isCertified_divisorAdaptation_univ … :
    ((seed …).divisorAdaptation hD).IsCertified g
```

The engine consumes `hfib` (§2), never a certificate; `IsCertified` is OUTPUT
(`DivSchemeCertificateEngine.lean:34-36`). Note the engine's own products
(`finite/projective_vanishingSubmodule`, `finite/projective_divisorWindow`,
`finite_thetaGlued`) are about the WINDOW/H⁰ carriers, not the (c1)-(c4) clauses — they
feed §4 and the DDR-5 rank argument, not this table.

---

## §4. `hle₂`, `hsurj₁/hsurj₂`, and the ε-identity (`DivSchemeEpsUniv`)

### §4.1 What the landed ε-theorem demands, verbatim

`ThetaGeneratorSeed.divFamEps_certifiedFamily` (`Picard/DivSchemeEps.lean:309-330`)
takes, at Grassmannian points `x₁` (exponent `M`) and `x₂` (exponent `M+s`), a seed `D`
at `K = map (relThetaWindowEquiv …).toLinearMap x₁.toSubmodule`, `hD : IsGenerator`,
`hc : IsCertified g`, and:

```
hsurj₁ : Function.Surjective ((D.divisorAdaptation hD).thetaGluedEval (windowM_choice π hπ g))
hsurj₂ : Function.Surjective (… .thetaGluedEval (windowM_choice + windowS_choice))
hle₂   : x₂.toSubmodule ≤ divisorWindow (D.localEquations hD) (relThetaPairH1_windowMS C π hπ g)
```

concluding `divFamEps hπ g (DivFam.mk (D.certifiedFamily g hD hc)) = (x₁.toSubmodule,
x₂.toSubmodule)`. The first-window containment is automatic
(`le_vanishingSubmodule`, threaded at `:330`); the equality halves are the rank engine
`divisorWindow_eq_of_le_of_isCertified` (`:193-202`) over
`Submodule.eq_of_le_of_rankAtStalk_quotient_eq` (`:112`). `divisorWindow` unfolds
through `mem_divisorWindow_iff` (`Picard/DivisorFamilyWindow.lean:111-118`) to
germ-vanishing of the transported theta section along `d` (`vanishingSubmodule`).

### §4.2 Discharging `hle₂` at the universal pair (primary route: mulSpan + Nakayama)

At `x₂ := K'_univ`-point (§1.2). Define the relative product span
`P := span of {σ_s · ξ : s ∈ H⁰(𝒪(sF)), ξ ∈ x₁}` inside the `M+s` window ambient
(the multiplication is `sectionMulBilin` conjugated exactly as `divCarveMul`,
`DivCarveLocus.lean:268-270`; its compatibility with `relThetaWindowEquiv` is one
Φ-pack clause, §1.6). Then:

1. `P ≤ x₂`: the universal carve at `S := R_Z` itself — `divUniversal_carve`
   (`DivSchemeFamilyUniv.lean:106-120`) + `carvePairArrow_eq_zero_iff`
   (`DivCarveKit.lean:126`), transported through the §1.2 ambient legs.
2. `P ≤ divisorWindow (M+s)`: multiplication stability of the vanishing submodule —
   a germwise `Ideal.mul_mem_left` chase against `mem_vanishingSubmodule_iff`
   (the `le_vanishingSubmodule` proof at `DivSchemeFamily.lean:397-499` is the
   template). Small new lemma (`vanishingSubmodule_mul_le`).
3. Fibrewise equality: `x₂ ⊗ κ(p) ↪` ambient fibre is exact (split projective-quotient
   SES, `ker_baseChange_mkQ`, `DivCarveKit.lean:91-106`), and the fibre image of `P`
   spans the full fibre second window — P-fib-N's F3-core
   (`mulSpan_eq_divisorSections_of_basepointFree` fired inside
   `existsUnique_effective_divisor_of_carve` at `PFib.lean:326-335`) + Φ_κ.
4. So `x₂ ⧸ P` is a finitely generated `R_Z`-module (quotient of the finite projective
   `x₂`) with ALL residue-field fibres zero ⟹ `x₂ = P` by Nakayama
   (f.g. + `M ⊗ κ(p) = 0 ∀p` ⟹ `M_p = 0 ∀p` ⟹ `M = 0` — the legitimate
   nonreduced-safe form; risk-5 compliant because finiteness is genuine here).
5. Chain: `x₂ = P ≤ divisorWindow`. Done.

Spec's hinted fallback (colon-Tor divisibility): upgrade the fibrewise cofactor of each
`ψ ∈ x₂` over `eqn z` to a relative cofactor via the colon lemma
`Module.Flat.mem_colon_smul_top_of_smul_mem_smul_top`
(`Picard/FibrewiseRegular.lean:106`) + the ring form
`mem_nonZeroDivisors_of_forall_tmul_residueField` (`:315`) + the flat-cokernel pair
`tensorKer_bijective_of_flat_coker` (`Picard/FlatCokernel.lean:117`) /
`includeRight_mem_nonZeroDivisors_of_flat_coker` (`:176`). Keep as fallback: it needs
(c1)-flatness standing and more bookkeeping per element; route 4.2 needs only the
finite-projectivity of `x₂` (certificate-free) and P-fib-N.

### §4.3 `hsurj₁/hsurj₂` (from §2, NOT from G-1)

`thetaGluedEval_surjective (hπ) (hfib)` (`DivisorThetaSurjectivity.lean:487-495`,
Noetherian-free via `datum_subsingleton_pairH1`, `Cohomology/GluedSheafEngine.lean:258-270`)
applied at `a = M` and `a = M+s` with §2.3's `thetaIdealDatum_hfib_univ`. Nothing else.

### §4.4 The G-4 keystones (pin)

```
noncomputable def divUniversalFamily … :
    CertifiedDivisorFamily C (DivCarveChartRing k A B g r₁ r₂ b₁ b₂ i j) π g :=
  (seedUniv …).certifiedFamily g (isGenerator_seedUniv …) (isCertified_divisorAdaptation_univ …)

theorem divFamEps_divUniversalFamily … :
    divFamEps hπ g (DivFam.mk (divUniversalFamily …))
      = ((grPointCongr b₁.equivFun.symm (divUniversalFst …)).toSubmodule,
         (grPointCongr b₂.equivFun.symm (divUniversalSnd …)).toSubmodule)
```

(the ε-projection identity at the universal point; the RHS pair is DDR-9 Law 1's
"pulled-back tautological pair" once composed with `Grassmannian.map` functoriality
along chart points — `DivFam.mapAlg`/`picClass_mapAlg` are landed,
`Picard/DivisorFamilyMapAlg.lean:266,:275,:288`.)

---

## §5. File plan (≤500 L each) and honest risks

| file | keystones | size | gates |
|---|---|---|---|
| `RiemannRoch/PFibPack.lean` (NEW vs task's four — forced by §0.1) | `existsUnique_effective_divisor_of_carve_pack` (§1.4); pack-audited `mulSpan_eq_divisorSections_of_basepointfree` variant if its ledger threading demands it | M→L | none (pure RiemannRoch relayering; N-pack landed) |
| `Picard/DivSchemeFibreH1.lean` (G-0) | `cechPicClass_thetaIdealDatum` (G-0a), the fibre-divisor law (G-0b), `thetaIdealDatum_hfib_univ` (§2.3) | M | G-0b's degree leg needs P-fib-N; G-0a is independent — start here |
| `Picard/DivSchemeSeedUniv.lean` | `grPointCongr`; `K_univ/K'_univ` (§1.2); the fibre instantiation + achiever lift; `seedUniv`, `isGenerator_seedUniv` (§1.5) | L | P-fib-N; Φ_κ pack (G-3, §1.6); N-pack (landed) |
| `Picard/SlicingFlatKernel.lean` (split out of CertUniv if 500L forces) | the constant-fibre-rank flattening brick (§3 (c3)/(c4) row) | L | none (pure algebra; generalizes `SlicingFlat`) |
| `Picard/DivSchemeCertUniv.lean` | (c1)-finiteness production; the (c1)-(c4) assembly `isCertified_divisorAdaptation_univ` (§3) | L→XL | seed file; SlicingFlatKernel; support-tube licence (landed) |
| `Picard/DivSchemeEpsUniv.lean` | `vanishingSubmodule_mul_le`; `hle₂_univ` (§4.2); `divUniversalFamily`, `divFamEps_divUniversalFamily` (§4.4) | L | all of the above + `DivSchemeEps` (landed) |

Suggested lane order: G-0a ∥ SlicingFlatKernel (both ungated) → PFibPack → SeedUniv →
CertUniv → EpsUniv. One heavy elaboration at a time (`LEAN_NUM_THREADS=1`, the
spec-w4-gates memory discipline).

### Honest risks

1. **P-fib-N restatement (found this pass; supersedes the spec's "DD-4 transport seam
   moves one boundary" optimism for this brick).** The seam does not merely transport a
   hypothesis — the theorem's window parameters must be abstracted. Mitigation: the
   N-pack was built to exactly this interface (`WindowFieldTransport.lean:37-45`), and
   PFib's proof consumes the ledger only through four rank facts (§1.4). Fallback: none
   short of re-running the ledger at every `κ(p)` (impossible per I-0204).
2. **(c3)/(c4) — spec-dd-r §7 risk 1's flattening residue, still the riskiest.** The
   endomorphism-shaped Noetherian induction (`SlicingFlat.lean:79,:268`) must be
   generalized to `δ' : M → N`. Fallback: Kleiman's finite-flat divisor-subscheme route
   (prove the colength SCHEME finite flat of degree `g`, then read (c2)-(c4) off its
   pushforward) — heavier geometry, same fibrewise inputs; probe-first per spec-dd-r §4
   before committing a lane.
3. **Φ_κ (G-3) is a hard gate for everything fibrewise** (§1.5-§1.6, §4.2 step 3): the
   `hdict` seam is open on record (`WindowFieldTransport.lean:47-49`). Mitigation: G-3
   is ahead of G-4 in the lane order (`spec-w4-gates.md` §"The corrected full map");
   G-4 states each fibre step against the named Φ-pack so only one boundary moves.
4. **(c1)-finiteness** (support-tube algebraic half) is unbudgeted in the spec's table.
   It is classical (proper + affine + finite fibres) but has no cheap project
   vocabulary; may deserve its own probe.
5. **Elaboration weight**: `DivSchemeFamilyUniv` already needs
   `synthInstance.maxHeartbeats 800000`/`maxSynthPendingDepth 8` for a single
   residue-field tower (`DivSchemeFamilyUniv.lean:122-126`); the seed file stacks such
   towers under `MvPolynomial` quotients at every prime, and `DivSchemeSeed.lean:170-176`
   records the same hatches. Expect heartbeat escalation; keep statements on the pair
   chart ring (the `divUniversal_carve_residueField` spelling trick,
   `DivSchemeFamilyUniv.lean:127-134`) wherever possible.
6. **Stale docstrings to fix in passing** (they will mislead the next lane):
   `GluedSheafFibre.lean:26-31` (seam closed by `GluedSheafDatumFibre`), and the
   `DivSchemeEps.lean:41-43` pointer to `Picard/DivSchemeEpsUniv` (file does not exist
   yet — this worksheet is its design).
