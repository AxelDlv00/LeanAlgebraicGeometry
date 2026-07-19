# SPEC DD-4 REDESIGN — the relative-achiever / relative-BPF feasibility verdict (2026-07-20, DESIGN lane)

Settles THE decisive feasibility question of the representability campaign: can the
DD-4 relative-achiever / relative-BPF seam be built, so that the G-4 seed's `hdvd`
(hence `divRep`) closes? Reads I-0288 (the current-construction inadequacy proof — the
"read first" note), I-0287/0284/0281 (the seed-close reductions), I-0272 (why Route-2
routed through the seed), I-0268/0264/0260/0258 (the achiever-lift history), I-0247
(the fibre-divisor keystone), I-0240 (SlicingFlatKernel), I-0244/0285 (SupportTube /
no-leak). Supersedes `informal/spec-dd4-seam.md` (I-0268): that worksheet's Route 2
was correct in spirit but its `relDivisor := seedUniv.localEquations` realization routed
through the seed's `dvd` (I-0272), so it did not dissolve the wall. This note carries the
construction the whole way. All `file:line` are verbatim spot-checks this pass.

---

## §0. Verdict box (read this first)

> **VERDICT: HARD-BUT-BUILDABLE.** The seam is SOUND and unblockable; there is NO
> impossibility. The recurring achiever-lift obstruction (I-0258) is **dissolved** — not by
> skipping the seed, but by lifting through a **surjection** instead of a rigid reduction.
> The essential content is one honest brick — **relative-local base-point-freeness by
> stalk-Nakayama** — sitting on the (landed-scoped) carve flat-rank-`g` engine. Realistic
> cost: **multi-week, ≈ 2 XL + 3 L + 2 M bricks** (§3). Not a bounded single-session win;
> not blocked.
>
> **RECOMMENDED ROUTE — keep the seed; redesign `(sec z, h z)` by surjection-lift +
> Nakayama-neighbourhood.** Consume the LANDED seed finale
> (`isGenerator_of_fibre_ne_zero`, `DivSchemeSeed.lean:188`; `divFamEps_certifiedFamily`,
> `DivSchemeEps.lean:312`) VERBATIM. The two pointwise fields I-0288 condemned become:
> * **(A) `sec z` — a relative achiever AT `z`**, built by lifting a κ(p)-fibre achiever
>   through the **surjection** `read ⊗ κ(p) : K_univ ⊗ κ(p) ↠ H⁰(N − d_p)`
>   (`divUniversalFibreKM_eq_span`, `DivSchemeSeedUnivRes.lean:376`) — NOT by reducing a
>   window vector to a chosen `f_p`. I-0258's "single window vector need not reduce to a
>   chosen κ(p)-combination" is TRUE but IRRELEVANT: we need SOME achiever at `z`, and the
>   surjection hits every element of `H⁰(N − d_p)`, achievers included. This is a clean
>   lift, not the "non-liftable" step the history feared.
> * **(B) `h z` — a genuine fibre-cutter `h z ∈ ann(N z)`**, `N z := J / (read sec z)`
>   (`J` = the base ideal `⟨K_univ readings⟩`), produced by `SupportTubeFinite` (`N z`
>   finite over `R_Z`, I-0244) at the point `z ∉ supp(N z)`. `ann(N z)` elements are
>   HONEST fibre-cutting sections — the missing "cut in the fibre, not the base" that
>   `algebraMap f` (`DivSchemeSeedUnivGen.lean:289`) could never provide (I-0288 fact 2).
>   `D(h z)` shrinks in the fibre to exactly the locus where `read sec z` achieves `d`, so
>   I-0288's razor `hle` (`DivSchemeUnivFibreHdiv.lean:203`) holds on all of `D(h z)`.
>
> **THE decisive question — does a carve-direct NON-SEED `relDivisor`/U1 dissolve the
> achiever-lift? Answer: the achiever-lift dissolves EITHER WAY (via the surjection, §1.2),
> so skipping the seed buys nothing and costs more.** A fully non-seed
> `CertifiedDivisorFamily` (build the base ideal `J` as a `Module.Invertible` line bundle
> over `Γ(relCurve)`, extract `LocalEquations.eqn` directly) IS possible in principle, but
> requires THREE bridges that are **absent** in mathlib and in-tree — "`Γ`-flat + fibrewise
> invertible ⟹ invertible", "rank-1 projective ⟹ `Module.Invertible`", "invertible ideal
> ⟹ single local generator `J·Γ_f = span{eqn}`" — and these are **Γ-local** (curve-local)
> reasoning that the landed engines (which are all **R_Z-fibrewise**) do NOT cover. The
> stalk-Nakayama route (§1.3) reaches the SAME local generator using only R_Z-fibrewise
> flatness + a one-point stalk Nakayama, reusing the maximal landed surface. **So: the
> carve does NOT hand you a relative divisor object; it hands you flatness. The divisor is
> always extracted as `J`'s local generator, and the cheapest extraction keeps the seed.**
>
> **What the carve does and does NOT give (settles task Q1a).** `divUniversal_carve` /
> `_residueField` (`DivSchemeFamilyUniv.lean:106/135`) produce **linear-algebra** data — a
> Grassmannian window pair `(K_M, K')` of submodules satisfying `carvePairArrow = 0` after
> every base change. This is NOT a relative section, NOT a relative subscheme, NOT an ideal
> sheaf. It pins `d` **fibrewise** (`d_p = divUniversalSeedFibreDivisor`,
> `DivSchemeSeedUnivFields.lean:133`; `_spec:146`) and, via `SlicingFlatKernel`, delivers
> the **relative flatness** of `Γ/J`. It does NOT yield a per-`z` relative section without
> the Nakayama-neighbourhood step (§1.3). There is no free lunch, but no wall either.

---

## §1. The construction — statement pins

Throughout: `R_Z := DivCarveChartRing …` (Noetherian, `isNoetherianRing_divCarveChartRing`,
`DivSchemeFamilyUniv.lean:60`); `K_univ := divUniversalSeedK …` (finite projective,
`finite_divUniversalSeedK`, `DivSchemeSeedUniv.lean:315`); `N := windowN` (`= Θᴹ`);
`d_p := divUniversalSeedFibreDivisor` the fibre base divisor of degree `g`; the fibre
window `divUniversalFibreKM p = H⁰(N − d_p)` (`_spec`, `DivSchemeSeedUnivFields.lean:146`).
`read := relThetaResSide a b …` the side-component reading; `J z :=` the base ideal
`⟨read ψ : ψ ∈ K_univ⟩ ⊆ Γ(relCurve C R_Z, chart)` (the ideal implicit in `hdvd`).

### §1.1 What `hdvd` is, and the razor it was reduced to (LANDED)

The seed's `hdvd` (`DivSchemeSeed.lean:189–190`): `∀ z, ∀ ψ ∈ K_univ,
read ψ ∈ Ideal.span {read (sec z)}` on the piece `D(h z)`. I-0287 reduced this, over the
fibre field `K = κ(p)`, to a single pointwise order inequality via
`relThetaResSide_mem_span_of_forall_ord_le` (`DivSchemeUnivFibreHdiv.lean:203`) +
`germ_relThetaResSide_dvd_iff_ord_le` (`:170`):

```
hle : ∀ w ≠ η closed in D(h'),  ord (read ψ)_w  ≤  ord (read (sec z))_w        (RAZOR)
```

`hle ⟺ read(sec z)` **achieves the ceiling** `ord = divisorBound(N − d_p)_w` at every
`w ∈ D(h')` (I-0288 fact 3). With the OLD `h z = algebraMap f`, `D(h') =` the whole fibre
chart (`relPinnedSectionsMap_algebraMap_eq`, `DivSchemeSeedUnivFacts.lean:212`; I-0288
fact 2), so `hle` demanded achievement on the WHOLE chart — impossible for a merely
non-vanishing `sec z` with its `deg N − g > 0` extra zeros (I-0288). **The redesign makes
`D(h')` a fibre-neighbourhood that EXCLUDES those extra zeros — then `hle` holds.**

### §1.2 (A) `sec z` = a relative achiever at `z` — the surjection lift (dissolves I-0258)

```
-- the achiever exists at z's fibre point (LANDED field infra):
v_p ∈ H⁰(N − d_p),  ord (v_p)_z = 0        -- Scheme.exists_coeffAt_eq_baseDivisorAt
                                            --   (BaseDivisor.lean:143); bd(H⁰(N−d_p)) = 0
                                            --   by the normalization le_divisorSections_sub_baseDivisor (:160)
-- read ⊗ κ(p) is SURJECTIVE onto the fibre window (LANDED span law):
read ⊗ κ(p) : K_univ ⊗ κ(p) ↠ H⁰(N − d_p)   -- image = span = window (divUniversalFibreKM_eq_span, Res:376)
-- lift a preimage of v_p through K_univ ↠ K_univ ⊗ κ(p) (projective; cheap):
sec z ∈ K_univ  with  (read (sec z)) ⊗ κ(p) = v_p     -- ⟹ read(sec z) generates J̄_p at z
```

**Why this is NOT the I-0258 wall.** I-0258/0260 flag that a single window vector's fibre
image need not equal a *chosen* `f_p` (`windowCompare` is only semilinear, its κ(p)-SPAN is
the window). Correct — but we do not need `read(sec z)` to equal a *particular* `f_p`; we
need it to be *some* achiever at `z`. The span law makes `read ⊗ κ(p)` **surjective**, so
every window element — every achiever — has a preimage. We choose the preimage. This is the
step every prior lane treated as "generally non-liftable"; it is liftable because the target
is the whole window, not a point.

### §1.3 (B) `h z` = a fibre-cutter from `ann(N z)` + the ONE genuine wall (`hdvd` on `D(h z)`)

```
N z := J z / (read (sec z))      -- Γ(chart)-module; finite over R_Z (SupportTubeFinite, I-0244)
```

**The relative-local-BPF Nakayama lemma (RD-N, the single genuine new brick).**

```
theorem read_sec_generates_stalk :
    -- INPUT (all landed-scoped):
    --  (i)  read(sec z) ∈ J z                                    [sec z ∈ K_univ]
    --  (ii) read(sec z) generates J̄_p := (J z + p·Γ)/p·Γ at z    [§1.2 achiever]
    --  (iii) J z is R_Z-FLAT                                      [§1.4, carve rank-g]
    Ideal.span {read (sec z)}  =  (J z) localized at the stalk 𝒪_z
```

Proof shape: `J z` flat over `R_Z` ⟹ `J z ∩ pΓ = p·(J z)` (no `Tor₁`), so
`J̄_p = J z / p·J z` (**not just a quotient of it**); hence (ii) gives `read(sec z)`
generating `J z / p·J z`, which surjects onto the residue fibre `J z / m_z·J z`;
Nakayama over the Noetherian local `𝒪_z` closes it. **Flatness (iii) is load-bearing and
non-negotiable** — without it `J̄_p` is a strict quotient of `J z / pJ z` and the k[ε] trap
(`t` vs `t+ε`, I-0231/I-0264) fires: fibre generation would NOT lift. This is exactly why
the carve flat-rank-`g` engine (§1.4) is a hard prerequisite, and exactly the guard I-0231
demands (route through flat colength, never "vanishes fibrewise ⟹ zero").

Then, since `N z` is a finite `R_Z`-module and `z ∉ supp(N z)` (RD-N), pick

```
h z ∈ ann(N z) ⊆ Γ(chart),   h z (z) ≠ 0        -- z ∉ V(ann N z); genuine fibre-cutter
⟹  h z · J z ⊆ (read (sec z))  on  D(h z)        ⟺  hdvd on D(h z)   [DIRECT — no per-fibre hfield]
```

`hdvd` is now DIRECT (no `hspan`/`hfield`/Nakayama-over-the-whole-piece decomposition of
I-0281 is needed), so feed the SIMPLER finale `isGenerator_of_fibre_ne_zero`
(`DivSchemeSeed.lean:188`) with `hfib` = the landed span bridge (`sec z ≠ 0` fibrewise,
I-0258 keystones) — NOT `isGenerator_of_fibrewise_ker_span_of_field_vanishing`.

### §1.4 Prerequisite: `J z` is `R_Z`-flat (the carve rank-`g` brick, XL, landed-scoped)

`Γ/J z` flat of constant fibre degree `g` over `R_Z`, then `J z` flat as `ker(Γ ↠ Γ/J z)`
with `Γ` flat (relCurve smooth ⟹ flat over `R_Z`) and `Γ/J z` flat. The `Γ/J z` flatness is
`SlicingFlatKernel` keystone (c4) `Module.Flat.quotient_range_of_forall_ker_rTensor_residueField_le`
(`SlicingFlatKernel.lean:296`) applied to `read : K_univ → Γ(chart)` (`range = J z`), fed by
the fibrewise spanning `hspan` = `divUniversal_carve_residueField`
(`DivSchemeFamilyUniv.lean:135`) transported by `pieceQuotBaseChangeAlg` +
`ker_baseChangeMkQ` (I-0284's XL residual, but here applied to `read` directly, NO chosen
`eqn z` — cleaner than the seed's `f_z`). Degree `g` from
`Module.rankAtStalk_ker_eq_of_forall_finrank_eq` (`SlicingFlatKernel.lean:448`).

### §1.5 The no-leak (`hcolFin`) and the finale — LANDED consumers

`V(read sec z) ∩ D(h z) = supp(d) ∩ D(h z)` is finite flat of degree `g` over `R_Z`
(from §1.4), hence PROPER over `R_Z`, hence closed with closure inside `D(h z)` (§1.3
excludes the other branches). Feed `seedUniv_hcolFin_of_forall_closure_subset`
(`DivSchemeSeedUnivColFin`, I-0285) — the landed reduction of `hcolFin` to this no-leak.
Then:

```
seedUniv i j := ThetaGeneratorSeed.mk { side, h := §1.3, sec := §1.2, sec_mem, mem_basicOpen }
isGenerator_seedUniv := isGenerator_of_fibre_ne_zero  (hdvd §1.3)  (hfib I-0258)
isCertified := (c1) SupportTube/SupportTubeFinite  (c2/c3/c4) SlicingFlatKernel on §1.4   -- non-circular: dvd holds
divUniversalFamily := divFamEps_certifiedFamily …  (DivSchemeEps.lean:312)   -- = DDR9-U's U1
```

Nothing in the seed struct or the finale changes; only the PROVENANCE of `(sec z, h z)`.

---

## §2. Feasibility evidence (file:line)

**LANDED — consumed verbatim:**
* Seed finale: `isGenerator_of_fibre_ne_zero` (`DivSchemeSeed.lean:188`);
  `divFamEps_certifiedFamily` (`DivSchemeEps.lean:312`); `finite_divUniversalSeedK`
  (`DivSchemeSeedUniv.lean:315`).
* The razor reduction: `relThetaResSide_mem_span_of_forall_ord_le`
  (`DivSchemeUnivFibreHdiv.lean:203`) + `germ_relThetaResSide_dvd_iff_ord_le` (`:170`),
  reducing `hdvd|κ(p)` to `hle`; the germ closer `mem_span_singleton_of_forall_germ`
  (`DivisorStalkIdeal.lean:79`).
* The surjection (A): `divUniversalFibreKM_eq_span` (`DivSchemeSeedUnivRes.lean:376`);
  field achiever `exists_coeffAt_eq_baseDivisorAt` (`BaseDivisor.lean:143`) with
  `bd = 0` from `le_divisorSections_sub_baseDivisor` (`BaseDivisor.lean:160`); fibre
  divisor `divUniversalSeedFibreDivisor(_spec)` (`DivSchemeSeedUnivFields.lean:133/146`).
* The fibre-cutter (B): `N z` finite via `SupportTubeFinite`
  (`finite_colength_of_forall_fibre_closure_subset`, I-0244); no-leak reduction
  `seedUniv_hcolFin_of_forall_closure_subset` (`DivSchemeSeedUnivColFin`, I-0285).
* The flat engine (§1.4): `SlicingFlatKernel.lean:284/296/331/381/448` (c3/c4/c2);
  `SlicingFlat.lean:317` (colength flat); the carve `divUniversal_carve_residueField`
  (`DivSchemeFamilyUniv.lean:135`).

**ABSENT — must be built (the honest walls):**
* **RD-N** (`read_sec_generates_stalk`, §1.3) — the relative-local-BPF stalk Nakayama.
  Size **L**. Pure module algebra: flat ⟹ `J∩pΓ = pJ` ⟹ residue-fibre generation ⟹
  Nakayama over `𝒪_z`. No mathlib primitive states it; the ingredients
  (`Module.Flat`, `IsNoetherianRing`, Nakayama) are all present.
* **The §1.4 wiring** — `J z` flat over `R_Z` from the carve, at the reading map `read`.
  Size **XL** (I-0284's `hspan` content, applied to `read` not `f_z`).
* **(B) production** — `h z ∈ ann(N z)`, `h z(z) ≠ 0`, as a `Γ(chart)` section with the
  DivisorAdaptation/no-leak plumbing. Size **M–L**. NOTE (探索 this pass): NO fibre-cutter
  over general `R` exists in-tree — the only genuine point-in-fibre cutter is
  `PointDivisor.pointSec`/`pointDivisor` over a FIELD base (`PointDivisor.lean:190/278`);
  every relative cutter is `algebraMap f` (base-only, `DivSchemeSeedUnivGen.lean:289`).
  `ann(N z)` is the in-tree route to a genuine relative fibre-cutter.

**Carve-direct (non-seed) infra — why NOT recommended (task Q1b).** Building `J` as a
`Module.Invertible` line bundle over `Γ(relCurve)` and reading off `LocalEquations.eqn`
(`DivisorClass.lean:112`, where `eqn` is INPUT DATA) needs three bridges that探索 confirmed
**absent**: (1) "R-flat + fibrewise-invertible ⟹ invertible"; (2) "finite projective +
`rankAtStalk = 1` ⟹ `Module.Invertible`" (mathlib has NO such converse — only
`.left`/`.right`/`.congr` from an explicit `N⊗M ≃ R`, or `Submodule.instInvertible` from an
exhibited `J·J⁻¹ = 1`); (3) "invertible ideal ⟹ `J·Γ_f = span{eqn}` on a basic open".
Nearby but insufficient: `EffectivityInvertibleAvoid.free_of_span_singleton_eq_top` (`:92`)
/ `exists_notMem_isUnit_free` (`:161`) (cyclic-invertible ⟹ free, module not ideal);
`LocalGenerators.exists_fibrewise_tmul_ne_zero_of_projective` (`:87`) (fibrewise-nonzero
section, no `span = J`); `InvertibleModuleTransfer.rankAtStalk_eq_of_module_finite` (`:266`)
(forward transfer, wrong direction); mathlib `free_of_flat_of_isLocalRing`,
`split_injective_iff_lTensor_residueField_injective`. All three absent bridges are
**Γ-local** (over the curve), whereas every landed engine is **R_Z-fibrewise** — the
mismatch is why carve-direct is strictly harder, not easier. **It reaches the identical
local generator by a longer road.**

---

## §3. File plan + sizes (order is anti-circular; dvd BEFORE certificate)

| # | file (new/extend) | contents | size | gate |
|---|---|---|---|---|
| 1 | `Picard/DivSchemeRelDivisorFlat.lean` (extend `DivSchemeRelDivisor`) | §1.4 — `J z` (base ideal of `read`) is `R_Z`-flat of fibre degree `g`; via SlicingFlatKernel c4/c2 on `read`, fed by the carve | **XL** | `SlicingFlatKernel` (I-0240); `divUniversal_carve_residueField` (`FamilyUniv:135`); `pieceQuotBaseChangeAlg`/`ker_baseChangeMkQ` |
| 2 | `Picard/DivSchemeUnivAchiever.lean` (NEW) | §1.2 — `sec z` via `read⊗κ(p)` surjection-lift of `exists_coeffAt_eq_baseDivisorAt` | **M** | `divUniversalFibreKM_eq_span` (`Res:376`); `BaseDivisor:143/160`; projective lift |
| 3 | `Picard/DivSchemeRelBPF.lean` (NEW — THE crux) | RD-N `read_sec_generates_stalk` (§1.3 stalk Nakayama); `h z ∈ ann(N z)`; `hdvd` on `D(h z)` | **L** | #1 (flat); §1.2; `SupportTubeFinite` (I-0244); Nakayama over `𝒪_z` |
| 4 | `Picard/DivSchemeSeedUnivGen.lean` (rewrite `sec`/`h`) | `seedUniv` with `(sec,h)` from #2/#3; `isGenerator_seedUniv := isGenerator_of_fibre_ne_zero hdvd hfib` | **M** | #2/#3; `isGenerator_of_fibre_ne_zero` (`Seed:188`); span bridge `hfib` (I-0258) |
| 5 | `Picard/DivSchemeSeedUnivColFin.lean` (extend) | `hnoleak_seedUniv` (§1.5 proper support ⟹ closure ⊆ piece) → the landed `hcolFin` reduction | **L** | #3; `seedUniv_hcolFin_of_forall_closure_subset` (I-0285) |
| 6 | `Picard/DivSchemeCertUniv.lean` (NEW) | `isCertified` (c1 SupportTube; c2/c3/c4 SlicingFlatKernel on `deltaLeft−deltaRight`) — non-circular (dvd holds) | **L** | #4/#5; SlicingFlatKernel; SupportTubeFinite |
| 7 | `Picard/DivSchemeEpsUniv.lean` (NEW) | `divUniversalFamily := divFamEps_certifiedFamily …` (= DDR9-U U1); U2 ε-identity via `le_vanishingSubmodule` | **L** | all above + `DivSchemeEps:312` |

**Order (binding):** #1 flat → #2 achiever → #3 `hdvd` → #4 seed/isGenerator → #5 no-leak
→ #6 certificate → #7 U1. `hdvd` precedes the certificate, so `divisorAdaptation hD` exists
and I-0267's circularity never arises. Total honest ETA: multi-week; #1 and #3 are the
load-bearing lanes, #1 is the largest.

---

## §4. Risks + the fallback route

1. **⚠⚠ #1 (`J z` flat) is the biggest single wall (XL).** It is I-0284's `hspan` content,
   re-pointed at `read` (cleaner: no chosen `eqn z`). Mitigation: the carve
   (`divUniversal_carve_residueField`) + SlicingFlatKernel c4 are landed; the residual is
   the base-change plumbing (`pieceQuotBaseChangeAlg`, `ker_baseChangeMkQ`). **Probe-first**
   the "`ker(read⊗κ(p)) ≤ range((ker read)⊗κ(p))`" fibre-spanning at ONE prime before the
   full family — it is the exact c4 hypothesis and settles whether the carve threads.
2. **⚠ #3 (RD-N) must route through flatness (the k[ε] guard, I-0231/0264).** The proof MUST
   use `J∩pΓ = pJ` (flatness), never "fibre generates ⟹ stalk generates" bare. Keep §2.1 of
   I-0231 in front. RD-N is where the guard lives; it is a clean ~L module lemma once #1 lands.
3. **⚠ (B) plumbing.** `ann(N z)` gives the section, but wiring it as a DivisorAdaptation
   piece with the no-leak containment is fiddly (SupportTube support-locus bookkeeping).
   Mitigation: I-0285's reduction already isolates the topological obligation; #3 hands it
   `V(eqn z) ∩ D(h z) = supp(d)` proper.

**Fallback if #1 or #3 wall after two honest lanes: the fully carve-direct non-seed
`CertifiedDivisorFamily`.** Build `J` as `Module.Invertible` over `Γ(relCurve)` and read off
`LocalEquations.eqn`, skipping `ThetaGeneratorSeed` entirely. This REMOVES the seed's `dvd`
naming but COSTS the three absent Γ-local bridges (§2). It is strictly more Lean with no
feasibility gain — recommended ONLY if the R_Z-fibrewise stalk-Nakayama proves brittle
against the chart-ring types. Second-tier: a `Sym^g` / Hilbert-scheme relative divisor
(spec plan-B) — a different U1 construction, largest of all, not scoped here.

---

*Deliverable of record: the verdict is **HARD-BUT-BUILDABLE**. The achiever-lift (I-0258)
is dissolved by the surjection lift (§1.2) — it was never truly non-liftable. The one honest
brick is the relative-local-BPF stalk-Nakayama (RD-N, §1.3), gated on the carve flat-rank-`g`
engine (§1.4). A carve-direct non-seed U1 exists but is strictly harder (Γ-local vs
R_Z-fibrewise) and dissolves nothing extra. Keep the seed; redesign `(sec z, h z)`.*
