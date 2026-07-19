# SPEC DD-4 SEAM — the certificate-free RELATIVE achiever / relative-divisor decision (2026-07-19, DESIGN lane)

Resolves THE crux of the representability campaign: how to build the certificate-free
**relative** achiever that unblocks the G-4 seed's `hdvd` (`IsGenerator.dvd`,
`Picard/DivSchemeSeed.lean:189-190`), and hence `divRep`. Reads I-0260, I-0264, I-0267
(the three converging analyses), I-0258 (the landed span-level bridge + the undone
naturality triangle), I-0231 (the `k[ε]` counterexample), I-0240 (SlicingFlatKernel),
I-0244 (SupportTubeFinite), w4-g4 §1.5+§3, spec-dd-r §7. All Lean citations
`file:line` are verbatim spot-checks this pass.

---

## §0. Verdict box (read this first)

> **RECOMMENDED ROUTE: Route 2 — divisor-first.** Construct the relative effective
> **Cartier** divisor `d` over `R_Z` DIRECTLY from the universal carve's flat rank-`g`
> quotient (the honest new brick, size **L**), which makes `hdvd` *automatic*; then feed
> the **LANDED** seed finale (`isGenerator_of_fibre_ne_zero` + `divFamEps_certifiedFamily`)
> and close `dvd` by the I-0267 germ closer. This is the task's "relatively-BPF section
> source by construction": the section source shifts from *lift-then-hope* to
> *read-off-a-divisor*, so `sec z` cuts the relative divisor **by construction** rather
> than merely being nonvanishing.
>
> **Route 1 (fibre-read / achiever-realization bridge) is PROVABLY INSUFFICIENT** — not
> merely hard. A single fibre-achiever, even realized pointwise as a window vector by the
> undone naturality triangle, does not pin the relative divisor. The obstruction is a
> **module-level** fact (`f = ·ε` over `k[ε]`, §2), so no amount of fibre-read naturality
> fixes it. The naturality triangle `resHom_relThetaWindowEquiv_cancelBaseChange ∘
> thetaFieldRead = germ-at-η` is therefore **NOT on the critical path** and stays undone.
>
> **Route 3 (bypass the seed, build `CertifiedDivisorFamily` directly)** is a viable
> **fallback**, but strictly more work with no benefit: it still needs the identical
> relative-divisor brick, and once `d` is divisor-first `hdvd` is free, so the reason to
> skip the seed (avoiding `dvd`) evaporates. The seed's `localEquations` /
> `divisorAdaptation` / `le_vanishingSubmodule` are landed and consume `dvd` directly —
> reuse them.
>
> **Why Route 2 wins on feasibility × size:** it reuses the maximal landed surface —
> the seed finale (`DivSchemeSeed.lean:188`, `DivSchemeEps.lean:309`), the span-level
> bridge's `hfib` (I-0258, 3 keystones), the germ closer (`DivisorStalkIdeal.lean:79`),
> SupportTubeFinite (I-0244) and SlicingFlatKernel (I-0240) — and it **dissolves both**
> blockers the three analyses raised: the `dvd`-blocker (I-0260/I-0264/I-0267) becomes a
> corollary of the construction, and the certificate-circularity (I-0267: "`colength`
> needs a `DivisorAdaptation` = `D.divisorAdaptation hD` which consumes `dvd`") vanishes
> because `dvd` now holds unconditionally.
>
> **Settled sub-questions (with evidence):**
> * **(a) Is `H⁰(N−d_p)` 1-dimensional? NO** (in general). `H⁰(N−d_p) = K_M`-fibre with
>   `dim = h⁰(N) − g` (`PFibPack.lean:380` `hKMrank : finrank KM + g = h0(N)`;
>   `:386` `KM = divisorSections K (N − D) ⊤`; fibre form `DivSchemeSeedUnivFields.lean:152-155`).
>   With `deg N ≥ 2g` (`PFibPack.lean:374` `hNdeg`), `h⁰(N) = deg N + 1 − g_C ≫ g+1`, so
>   the achiever is **NOT unique up to scalar**. P-fib's uniqueness is uniqueness of the
>   **divisor** `d_p`, not of the achiever section — which is *exactly why* fibre-achievers
>   underdetermine the relative divisor (many achievers lift to different relative sections
>   cutting different relative divisors: the `t` vs `t+ε` phenomenon).
> * **(b) Does `sec z` cut a flatly-varying divisor (constant fibre degree `g`)?** This is a
>   flatness/constant-rank question and it is **exactly** what SlicingFlatKernel delivers —
>   flat rank-`g` kernel + flat cokernels from fibrewise spanning (I-0240 keystones 2/3/4/7,
>   `SlicingFlatKernel.lean`). But flatness is a property of the **already-chosen** `sec z`;
>   it does **not by itself** produce the right `sec z` (see (a)/§2). SlicingFlatKernel is the
>   engine that certifies `d`'s flatness *once `d` is built*, and discharges the certificate
>   (c2/c3/c4); it is not a route to `dvd`.
> * **(c) The naturality square (Route 1's triangle):** NOT needed on Route 2. The
>   divisor-first section `sec z` is read off `d`, never from a pointwise
>   `thetaFieldRead ↔ divFamPhi` identification.
>
> **False/circular findings (confirmed):** DDR-8 relative window-generation is CIRCULAR for
> `dvd` (`windowGen`/`stalkIdeal_le_span_windowGerm` take a `CertifiedDivisorFamily`,
> `DivSchemeMonoBridgeRel.lean:154,:334`; `dvd` is an INPUT to the certificate, anti-circular
> banner `DivSchemeCertificateEngine.lean:34-36`). SlicingFlat's regular-cancellation engine
> (`SlicingFlat.lean:356,:79`) discharges `fibre_regular`, **not** `dvd` (I-0260/I-0264).
> Route 1 alone is FALSE (§2).

---

## §1. The chosen construction — statement pins (verbatim)

### §1.1 What `dvd` is, and the clean closer that is already landed

The seed target (`DivSchemeSeed.lean:189-190`, the `hdvd` argument of
`isGenerator_of_fibre_ne_zero`):

```
hdvd : ∀ (z : relCurve C R_Z) ⦃ψ : relThetaSections C R_Z π a⦄, ψ ∈ K →
  relThetaResSide a (D.side z) (D.piece_le z) ψ ∈ Ideal.span {D.eqn z}
```

with `D.eqn z = relThetaResSide a (D.side z) (D.piece_le z) (D.sec z)`
(`DivSchemeFamily.lean:113-114`). The **closer is landed** (I-0267, non-circular):
`Scheme.mem_span_singleton_of_forall_germ` (`DivisorStalkIdeal.lean:79`) reduces `dvd` on
the piece `D(h z)` to, at every `y ∈ D(h z)`:

```
germ_y (relThetaResSide ψ) ∈ Ideal.span { germ_y (D.eqn z) }        (I)
germ_y (D.eqn z) ∈ nonZeroDivisors (stalk y)                        (II, = fibre_regular)
```

(II) is `germ_eqn_mem_nonZeroDivisors` (`DivSchemeFamily.lean:160`), already discharged from
`fibre_regular` via the landed bridge `hfib` (I-0258). So **`dvd ⟺ (I) at every germ**, and
(I) is precisely "`D.eqn z` generates the relative divisor ideal `I_d` at each stalk". The
ONLY missing input is a relative divisor `d` whose local equation is `D.eqn z`.

### §1.2 The honest new brick — `RelDiv` (the relative effective Cartier divisor)

**RelDiv (pin, own file `Picard/DivSchemeRelDivisor.lean`).** Over
`R_Z := DivCarveChartRing k (s•F̄) (M•F̄) g r₁ r₂ b₁ b₂' i j`, with
`N := windowN C R_Z hπ g` (`= Θᴹ`), from the universal window pair
`K_univ := divUniversalSeedK …` (`DivSchemeSeedUniv.lean:186`), produce a relative
effective divisor and its local generators:

```
-- (RD1) the relative divisor as a LocalEquations system on the relative curve:
def relDivisor (i j) : (relCurve C R_Z).LocalEquations           -- cover + eqn + ratio units

-- (RD2) it cuts K_univ: K_univ ≤ its vanishing submodule (⟺ dvd; ⟹ le_vanishingSubmodule):
theorem relDivisor_le_vanishingSubmodule :
    K_univ ≤ (relDivisor i j).vanishingSubmodule R_Z              -- Θᵃ-window shape, a ∈ {M, M+s}

-- (RD3) flat of constant fibre degree g (the certificate's (c2) input), and
--       fibrewise IS the P-fib divisor:
theorem relDivisor_baseChange_residueField (p : PrimeSpectrum R_Z) :
    CechPic.map (relCurveMap C R_Z κ(p)) (relDivisor i j).picClass
      = CurveDivisor.picClass κ(p) (divUniversalSeedFibreDivisor … p)     -- d ⊗ κ(p) = d_p
```

`(relDivisor i j).vanishingSubmodule` is `Scheme.LocalEquations.vanishingSubmodule`
(`DivisorStalkIdeal.lean:215`); its membership `mem_vanishingSubmodule_iff` (`:242`) is the
germ-level `dvd`. The seed fields `(side z, h z, sec z)` are then **read off** `relDivisor`:
near `z`, on a small basic sub-open `D(h z)`, the Cartier ideal `I_d` is free rank 1
(smooth relative curve, relative dim 1) and generated by ONE element of `K_univ` (relative
local base-point-freeness — the Nakayama-neighbourhood step, §2.3); take `sec z` a generator,
`h z` the neighbourhood, `side z` the pinned chart containing `z`.

### §1.3 How it feeds the LANDED seed finale (Route 2 assembly — the interface move)

```
seedUniv i j : ThetaGeneratorSeed C R_Z π (M) K_univ :=
  { side, h, mem_basicOpen, sec, sec_mem }        -- fields = §1.2's read-off of relDivisor

isGenerator_seedUniv i j : (seedUniv i j).IsGenerator :=
  ThetaGeneratorSeed.isGenerator_of_fibre_ne_zero
    (hdvd := from RD2 + germ closer §1.1)          -- NOW AUTOMATIC (was the blocker)
    (hfib  := the landed span-level bridge, I-0258) -- unchanged

-- certificate (non-circular now, because dvd holds so divisorAdaptation hD exists):
isCertified_divisorAdaptation_univ i j :
    ((seedUniv i j).divisorAdaptation isGenerator_seedUniv).IsCertified g
  -- (c1) SupportTube: projective_colength_of_forall_tmul_residueField (SupportTube.lean:329)
  --      + finite_colength_of_forall_fibre_closure_subset (SupportTubeFinite, I-0244 keystone 4)
  -- (c3)/(c4)/(c2) SlicingFlatKernel keystones 3,4,2,7 (I-0240) on deltaLeft − deltaRight
  --      with fibre spanning from P-fib-N (existsUnique_effective_divisor_of_carve_pack)

divUniversalFamily i j : CertifiedDivisorFamily C R_Z π g :=      -- = DDR9-U's U1
  ThetaGeneratorSeed.divFamEps_certifiedFamily … (DivSchemeEps.lean:309-330)
```

**What shifts (the interface move the task asks to pin):** NOTHING in the seed struct,
`isGenerator_of_fibre_ne_zero`, or `divFamEps_certifiedFamily` changes — they are consumed
verbatim. The ONLY change vs the blocked w4-g4 §1.5 plan is the **provenance of
`(side, h, sec)`**: they are read off `relDivisor` (RD1/RD2) instead of lifted from a fibre
achiever and hoped to satisfy `dvd`. `K = K_univ` is unchanged (still `divUniversalSeedK`).
The DDR9-U interface (`w4-ddr9 §3.1`: U1 `divUniversalFamily`, U2 the ε-identity via
`le_vanishingSubmodule`, U3 derivable) is met unchanged.

---

## §2. The I-0231-safety argument (why `d` is genuinely relative/flat, not fibrewise)

### §2.1 `dvd` is a module-level equation that fibre data CANNOT supply — the sharpened counterexample

Fix `z`, write `B := Γ(D(h z), O)`, `e := D.eqn z ∈ B`, and let `f : K_univ → B/(e)` be the
`R_Z`-linear map `ψ ↦ [relThetaResSide ψ]`. Then

```
dvd  ⟺  f = 0.
```

**Claim: `f ⊗ κ(p) = 0` for every prime `p` does NOT imply `f = 0`, even with `B/(e)` flat.**
Witness (the I-0231 `t` vs `t+ε`, promoted to a module statement): `R_Z = k[ε]`,
`f = (·ε) : k[ε] → k[ε]`. Its only fibre (residue field `k`) is `(·ε) ⊗ k : k → k`, the map
`ε·(−) = 0`. So `f ⊗ κ = 0` at the unique prime, yet `f = ·ε ≠ 0`. Here `B/(e) = k[ε]` is
free, hence flat. Concretely `e = t+ε`, `K_univ`-side-components `= (t)`: `B/(t+ε) ≅ k[ε]`
via `t ↦ −ε`, and the image of `(t)` is `(ε) ≠ 0`, with `(ε) ⊗_{k[ε]} k ≅ k ≠ 0` — so even
the Nakayama fibre condition `Q ⊗ κ(p) = 0` (I-0264's S3, `Q := (J + (e))/(e)`) **fails**
for the bad section, correctly. **This is the whole of I-0231, at the module level.** It
proves:

* **Route 1 is insufficient, not merely hard.** Even a pointwise `thetaFieldRead ↔ divFamPhi`
  realization that makes `sec z` reduce to a chosen fibre-achiever `f_p` at `p` controls
  `f ⊗ κ(p)` at the ONE fibre `p`; `dvd = (f = 0)` is a relative equation the naturality
  square never touches. `t` and `t+ε` are both fibre-achievers of `(t)` over `k`.
* **The Nakayama route (I-0264 S1+S3) is honest but not a shortcut.** S3 (`Q ⊗ κ(p) = 0`,
  *module* form) is strictly stronger than "`e`-fibre is a fibre achiever at every `p`"
  (right-exactness gives only `image(J ⊗ κ) = 0`, and `Q ⊗ κ ≠ image(J ⊗ κ)` — the map
  `Q ⊗ κ → (B/(e)) ⊗ κ` is not injective). Verifying S3 therefore requires `e` to genuinely
  cut the relative divisor — the same content, relocated.

**Conclusion:** there is NO fibrewise-only or naturality-only route to `dvd`. The relative
divisor `d` must be produced as a genuine relative object. This is *why* Route 2 (build `d`
first) is not a stylistic preference but the only sound path.

### §2.2 Why divisor-first `d` is genuinely relative and flat

Build `d` so that `f = 0` **by construction**, never by a fibre argument:

* **Flatness / constant degree `g`.** The universal carve gives, over `R_Z`, the window pair
  `ker(baseChangeMkQ R_Z)` with a projective rank-`g` **quotient** (Grassmannian tautological;
  `finite_pairTautFst` `DivCarveLocus.lean:80-83`, retract kit `DivCarveKit.lean:82-85`;
  `w4-g4 §1.2` pins `K_univ` finite projective certificate-free). SlicingFlatKernel (I-0240)
  upgrades the fibrewise spanning (P-fib-N at every `κ(p)`, from
  `divUniversal_carve_residueField` `DivSchemeFamilyUniv.lean:135`) to: `ker` flat of
  constant `rankAtStalk = g` (keystones 2, 7), `M/ker` and `N/range` flat (keystones 3, 4).
  This is the relative flat family — the honest content of I-0264's S2, delivered by a
  landed engine, **no new Noetherian induction** (I-0240's "risk-2 dissolved").
* **Cartier for free on a smooth curve.** `relCurve C R_Z` is smooth of relative dimension 1
  (`SmoothOfRelativeDimension 1`, standing pack). A closed subscheme flat and finite of degree
  `g` over `R_Z`, supported in relative codimension 1, is automatically **relatively Cartier**
  (locally principal): the stalks of the relative curve are regular, and the ideal of a flat
  finite subscheme in a regular local ring of a curve-over-base is locally principal. So the
  local generator `D.eqn z` **exists** as a genuine generator of `I_d` — not a guessed section.
* **`dvd` automatic.** Because `d` is the base subscheme of `K_univ` (RD2: `K_univ =` relative
  `H⁰(N − d)`), every `ψ ∈ K_univ` has `div_N(ψ) ≥ d` relatively, so `relThetaResSide ψ ∈
  (D.eqn z)` on `D(h z)`. Formally: RD2 + germ closer (§1.1). The `k[ε]` trap is dodged because
  `e = D.eqn z` is *the* generator of `I_d` (order exactly `d`), not `t+ε`.

### §2.3 The one genuinely-new lemma inside RelDiv (the relative local BPF generator)

The residual honest step is **relative local base-point-freeness**: for each `z`, on a small
enough `D(h z)`, some `sec z ∈ K_univ` generates `I_d`. Fibrewise this is P-fib's achiever
(`exists_coeffAt_eq_baseDivisorAt`, `BaseDivisor.lean:143`, gives `f_p` of exact order `d_p`);
the RELATIVE lift is a Nakayama-neighbourhood: `K_univ ↠ K_univ ⊗ κ(p)` is surjective
(`K_univ` finite projective), lift `f_p` to `sec z`, and `sec z` generates `I_d` on a
neighbourhood because `I_d/(sec z)` is a finite `R_Z`-module (SupportTubeFinite, I-0244) whose
fibre at `p` vanishes (achiever) and which — **because `I_d` is the flat Cartier ideal (§2.2)**
— has `I_d/(sec z) ⊗ κ(p) = 0` genuinely (flat colength makes the module fibre agree with the
scheme fibre), so its support avoids `p`; shrink `D(h z)` to that support-free neighbourhood.
The flatness of `I_d` (§2.2) is exactly what upgrades "fibre achiever" to "module fibre zero",
which is what the `k[ε]` guard forbids skipping.

---

## §3. File plan (sizes / gates)

| file | contents | size | gate |
|---|---|---|---|
| `RiemannRoch/PFibPack.lean` (landed-scoped) | `existsUnique_effective_divisor_of_carve_pack` (`:368`) — fibre `d_p`, `K_M`-fibre `= H⁰(N−d_p)` | — | landed; audit BpfSpan window threading |
| `Picard/DivSchemeRelDivisor.lean` (**NEW, the crux**) | RD1 `relDivisor` (relative Cartier `LocalEquations`), RD2 `relDivisor_le_vanishingSubmodule` (⟹ `dvd`), RD3 fibre law + flat/degree-`g`; the §2.3 relative-local-BPF Nakayama lemma | **L** | SlicingFlatKernel (I-0240, landed); SupportTubeFinite (I-0244, landed); P-fib-N; `divUniversal_carve_residueField` (`FamilyUniv:135`, landed); germ closer (`DivisorStalkIdeal:79`, landed) |
| `Picard/DivSchemeSeedUniv*.lean` (extend) | read `(side, h, sec, sec_mem)` off `relDivisor`; `seedUniv`; `isGenerator_seedUniv := isGenerator_of_fibre_ne_zero hdvd hfib` | **M** | RelDiv; the landed span bridge `hfib` (I-0258); `isGenerator_of_fibre_ne_zero` (`DivSchemeSeed:188`, landed) |
| `Picard/DivSchemeCertUniv.lean` | `isCertified_divisorAdaptation_univ` (c1 via SupportTube/SupportTubeFinite; c2/c3/c4 via SlicingFlatKernel on `deltaLeft − deltaRight`) | **L** | seed file; SlicingFlatKernel; SupportTubeFinite; P-fib-N. **Non-circular** (dvd holds) |
| `Picard/DivSchemeEpsUniv.lean` | `divUniversalFamily := divFamEps_certifiedFamily …` (= DDR9-U U1); U2 ε-identity via `le_vanishingSubmodule` | **L** | all above + `DivSchemeEps.lean:309` (landed) |

**Order (binding, anti-circular):** RelDiv (`d`, flat, `le_vanishingSubmodule`) → `dvd` (germ
closer) → `seedUniv`/`isGenerator` → certificate → `divUniversalFamily` → U2. The certificate
step is now downstream of `dvd`, so `D.divisorAdaptation hD` is available and I-0267's
circularity does not arise.

**Gates that must be true (all confirmed landed or landed-scoped):** SlicingFlatKernel
keystones 2/3/4/7 (`SlicingFlatKernel.lean`, I-0240); SupportTubeFinite keystone 4
(`SupportTubeFinite.lean`, I-0244); flat/projective colength (`SupportTube.lean:313,:329`);
germ closer (`DivisorStalkIdeal.lean:79`); span bridge `hfib` (`DivSchemeSeedUnivBridge.lean`,
I-0258); seed finale (`DivSchemeSeed.lean:188`, `DivSchemeEps.lean:309`); P-fib(-N) fibre
divisor (`PFibPack.lean:368`, `DivSchemeSeedUnivFields.lean:133-159`).

---

## §4. Risks + the fallback route

1. **⚠⚠ RelDiv is the single genuine wall (size L).** The relative-divisor construction
   (`relDivisor` + §2.3 relative local BPF) is honest new mathematics: the RELATIVE lift of
   P-fib's field-level "carve ⟹ divisor". Mitigation: it is heavily scaffolded — SlicingFlatKernel
   supplies the flat rank-`g` family, SupportTubeFinite the finite colength, the smooth curve the
   Cartier structure for free, the germ closer the discharge; and the fibre target `d_p` is
   landed (`divUniversalSeedFibreDivisor`, `DivSchemeSeedUnivFields.lean:133`). Probe-first the
   §2.3 Nakayama lemma (it is the load-bearing "flat ⟹ module-fibre-zero = scheme-fibre-zero"
   step) before the full `relDivisor` build.
2. **⚠ The `k[ε]` false lemma (spec-dd-r §7 risk 5) is fatal if skipped.** Every relative
   containment in RelDiv MUST route through the flat colength / `rankAtStalk` arithmetic, never
   through "vanishes in all fibres ⟹ zero". §2.1 is the guard; keep it in front while building.
3. **Fibre-to-relative Cartier realization** (turning the flat rank-`g` **module** quotient into a
   locally-principal **ideal sheaf** on the curve) is the subtle seam inside RD1. Mitigation: use
   the seed's own `eqn z`/`localEquations` machinery as the presentation vehicle (it already
   produces ratio units and a `LocalEquations`), rather than re-deriving scheme-of-a-subscheme
   theory; RD2 then only has to certify it is `d`.

**Fallback route (if RelDiv walls after two honest sessions):** **Route 3** — build
`divUniversalFamily : CertifiedDivisorFamily C R_Z π g` directly, still using `relDivisor` for
`eqns`/`adaptation` but bypassing `ThetaGeneratorSeed`/`IsGenerator` (so `dvd` is never named;
the certificate reads off the flat colength alone). This is strictly more Lean (re-implement the
adaptation + ε-identity outside the seed) but removes the seed's `dvd`/`le_vanishingSubmodule`
dependency if that specific discharge proves brittle. Second-tier fallback: spec-dd-r §1 staged
`DD-Φ` matrix-chart AMBER — but note it repairs the field dictionary, NOT the relative
certificate, so it does not substitute for RelDiv.

---

*Deliverable of record: the route decision (Route 2, divisor-first) and its sized plan.
The ETA-critical decision is that `hdvd` is unblockable ONLY by constructing the relative
divisor `d` — no fibre-read or naturality bridge suffices (§2.1, module-level proof) — and that
once `d` is built divisor-first, the entire remaining seed→family chain is landed machinery.*
