# spec-dd4-fieldvanishing — the decisive verdict on the G‑4 seed's last wall

**Lane:** DESIGN/feasibility. **Question:** is the field‑vanishing
`SeedUnivRDN` (`z ∉ supp(N z)`, reduced by the landed 2c bridge to the base‑fibre
`Subsingleton(chartColengthModuleBase K b s ⊗ κ(p))`) reachable from the landed
achiever (I‑0291) + the landed chart flat (I‑0302), or does it require new math /
an architecture change?

Read first: I‑0304 (the two sub‑gaps), I‑0303/I‑0302/I‑0291/I‑0288/I‑0289.
All claims below are grounded in landed Lean (file:line) — this is an analytic
verdict, no new Lean required to reach it.

---

## §0 — VERDICT + RECOMMENDATION

**VERDICT: ARCHITECTURAL (bounded). The landed κ(p)‑base‑fibre reduction chain is a
dead end; it demands a *global* fibre‑divisibility that is FALSE by degree count.
The seed's sharp support condition is nonetheless TRUE and reachable, but only via a
*different* (single‑point κ(z)) reduction that the landed 2c/germ/flat machinery does
not deliver. The fix is bounded (~L), not multi‑week — but it is a genuine pivot, not
a lemma‑patch of the current path.**

Two independent facts settle it:

1. **The achiever does NOT cut `d_p` globally — only at `z`.** `read sec z` is a
   *single* section of the base‑point‑free, `≥ 2`‑dimensional complete linear system
   `divUniversalFibreKM = H⁰(N − d_p)`. Its zero divisor `E = (N − d_p) + div(read sec z)`
   is effective of degree **`deg N − g ≥ 2 > 0`**. The achiever pins `E` **only at `z`**
   (`coeffAt_z E = baseDivisorAt`, a *per‑point* `sInf` witness). By the `≥ 2`‑dim count,
   `read sec z` MUST have a genuine extra zero `w ≠ z` where a different reading has
   strictly smaller order — so `read sec z ∤ read ψ` there. Global fibre divisibility
   `read ψ ∈ ⟨read sec z⟩` (what the 2c bridge / germ lemma / flat lemma ALL consume)
   is **false**. (§2, rigorous.)

2. **The landed reduction targets the wrong fibre.** All three landed reduction lemmas
   — the 2c annihilator bridge (`DivSchemeRedesignSeedFinish.lean:115`), the germ lemma
   (`DivSchemeRelDivisor.lean:241`), the flat lemma (`DivSchemeRelDivisor.lean:303`) —
   `comap`/`basePrime` the point down to the **base** prime `p : Spec R` and reduce to
   `Subsingleton(N ⊗ κ(p))` = readings dying over the **whole** κ(p)‑fibre chart. That is
   exactly the global condition (1) kills. The *sharp* condition `z ∉ supp_{Γ(V)}(N z)`
   is, by the SAME mathlib lemma applied at `pz` over `Γ(V)` (not comapped to `R`),
   `Subsingleton(N z ⊗_{Γ(V)} κ(z))` — a **single‑point** (κ(z)) statement the achiever
   *can* feed. The landed machinery threw away `chartColengthModule`'s already‑landed
   `Γ(V)`‑finiteness and re‑derived a weaker `R`‑finiteness precisely to comap to `R` —
   the fatal step. (§3.)

**RECOMMENDATION.** Abandon the κ(p)‑base‑fibre reduction (2c bridge / the gap‑(a) flat
pursuit / the RelDivisor:303 flat route). Re‑route RD‑N to the **sharp single‑point
κ(z) target** `Subsingleton(N z ⊗_{Γ(V)} κ(z))`, which mathlib's
`Module.mem_support_iff_nontrivial_residueField_tensorProduct` gives *iff‑equivalent* to
`z ∉ supp N z` directly over `Γ(V)` (`N z` is already `Module.Finite Γ(V)`,
`chartColengthModule_finite`, landed I‑0303). The remaining honest content is then the
**relative one‑point stalk Nakayama** I‑0289 originally scoped (size L): the achiever's
per‑point local generation at `z` + the base‑change identification of `N z`'s fibre at
`z` with the κ(p)‑fibre colength at `z` (I‑0302 §2c's flagged `isLocalization_stalk`
wiring), lifted to the stalk `O_z`. This never over‑reduces to the whole fibre, so the
degree obstruction never fires. (§3, §4.)

**ETA‑critical decision:** the seed is finishable *soon* only after this pivot. Continuing
to build κ(p) machinery (closing gap (a), proving the RelDivisor:303 hypotheses) is wasted
— that branch terminates in a false statement.

---

## §1 — Gap (a) size (the flat‑transport gap)

**Not mundane — but MOOT (it lives on the dead κ(p) branch).**

The landed chart flat (`flat_chart_colength_divUniversalSeedK`, I‑0302, commit 683de581f)
is
```
Module.Flat R (Γ(V) ⧸ LinearMap.range (chartReadMap K b))
```
where `range(chartReadMap K b)` is the **R‑span** (an `R`‑submodule) of the readings.
The flat lemma `subsingleton_tmul_residueField_of_flat_quotient`
(`DivSchemeRelDivisor.lean:303`) needs, with `M = Γ(V)/⟨read s⟩` and
`P = chartColengthModuleBase`,
```
Module.Flat R (M ⧸ P) = Module.Flat R (Γ(V) ⧸ (range(chartReadMap K b) + Γ(V)·read s)).
```
These differ by the `Γ(V)`‑ideal term `Γ(V)·read s = Ideal.span {read s}` (curve‑function
multiples), which is **not** contained in the R‑span `range(chartReadMap)`.

Why it is **not** a cheap re‑instantiation of the landed free‑codomain flat keystone
(`Module.Flat.quotient_range_of_forall_rTensor_residueField_injective_free`,
`DivSchemeRedesignFreeFlat.lean`): that keystone requires the quotient to be
`N / range(ψ)` for a linear map `ψ : M' →ₗ[R] N` with **`M'` finite over `R`**. Here the
extra submodule `range + Γ(V)·read s` is **not** a finite `R`‑submodule (`Γ(V)·read s` is
infinite‑rank over `R`, `Γ(V)` being an infinite `R`‑algebra), so the keystone does not
apply. A quotient of a flat module is not flat in general, so the landed
`Γ(V)/range`‑flat does not give the needed `Γ(V)/(range + Γ(V)·read s)`‑flat by descent
either. Genuinely **new** flat work would be required — size ≥ L.

**But gap (a) is downstream of the fatal gap (b): the flat lemma still consumes the
field‑level vanishing `read ψ ⊗ 1 = 0 in M ⊗ κ(p)` (RelDivisor:305), i.e. the same global
κ(p) divisibility gap (b) shows is false. Flatness only *lifts* that vanishing to the
module fibre; it cannot manufacture it. So gap (a) never needs to be resolved on the
current path — the path is dead upstream.** On the corrected κ(z) path (§3) the flatness
that re‑enters is a fibre→stalk lifting of a *different* module, not this ideal‑quotient
flat.

---

## §2 — Gap (b): the achiever does NOT cut `d_p` globally (rigorous degree bookkeeping)

### The setup (all landed)

* The window `T := divUniversalFibreKM C … κ(p)` **equals the complete linear system**
  `H⁰(N − d_p)`:
  `divUniversalSeedFibreDivisor_spec` (`DivSchemeSeedUnivFields.lean:152‑155`):
  `divUniversalFibreKM … = Scheme.divisorSections κ(p) (windowN − d_p) ⊤`.
* `d_p := divUniversalSeedFibreDivisor` is **effective of degree exactly `g`**:
  same spec, lines 149‑151: `0 ≤ d_p ∧ CurveDivisor.deg κ(p) d_p = (g : ℤ)`.
* `dim_{κ(p)} T + g = h⁰(𝒪(N))` (`finrank_divUniversalFibreKM_add`,
  `DivSchemeSeedUnivAssembleKappa.lean:207‑210`); with `h¹` vanishing (RR),
  `h⁰(𝒪(N)) = deg N + 1 − g`, so
  **`dim T = deg N + 1 − 2g`**.
* `deg N` is large: `deg N ≥ b + 2g + (g+2)(s+1)δ` (I‑0288, `windowM_spec`
  WindowLedger:189 + `deg_windowN` WindowFieldTransport:319), `δ ≥ 1`. Hence
  **`dim T = deg N + 1 − 2g ≥ 2`** (robustly `≫ 2`), and **`deg N − g ≥ g + 2 ≥ 2 > 0`**.

### The achiever pins order at `z` ONLY

The achiever `Scheme.exists_coeffAt_eq_baseDivisorAt` (`RiemannRoch/BaseDivisor.lean:143`)
is a **per‑point `sInf` witness**: `Nat.sInf_mem` (line 149) picks a nonzero `f ∈ T` that
attains the base multiplicity `baseDivisorAt(T, A, x)` **at the single point `x`**. At any
*other* point `w`, this same `f` satisfies only the universal lower bound
`baseDivisorAt(T, A, w) ≤ (A + div f)_w` (`baseDivisorAt_le_coeffAt`, BaseDivisor:128‑139)
— no upper control. The seed‑prime achiever (I‑0291,
`exists_relThetaWindowEquiv_…_achieves_seedPrime`) is exactly this at `A = N − d_p` and the
single `z` (`hz : z ≠ genericPoint`):
```
coeffAt hz ((N − d_p) + div(read sec z)) = baseDivisorAt(T, N − d_p, z).
```

### The degree count forcing an extra zero

Let `f := read sec z ∈ T = H⁰(N − d_p)`, `f ≠ 0`. Then
`E := (N − d_p) + div f ≥ 0` (effective, membership in `H⁰`), and
```
deg E = deg(N − d_p) + deg(div f) = (deg N − g) + 0 = deg N − g ≥ 2 > 0
```
(principal divisor has degree 0; `deg d_p = g`). So **`f` has `deg N − g ≥ 2` zeros
(with multiplicity), recorded by `E`, on the κ(p)‑fibre.** The achiever fixes only `E_z`.

**Global fibre divisibility** — the thing the 2c bridge / germ / flat lemmas all need — is
`read ψ ∈ ⟨read sec z⟩` for every `ψ`, over the whole κ(p)‑fibre chart. As sections this
is `div f ≤ div(read ψ)` for all `ψ`, i.e.
```
E = (N − d_p) + div f  ≤  (N − d_p) + div(read ψ) =: E_ψ   for every ψ,
```
i.e. `E ≤ inf_ψ E_ψ = baseDivisor(T, N − d_p) =: B` (the fixed/base part of the system).

**This is impossible for `dim T ≥ 2`.** Suppose it held; then `E ≤ B ≤ E` (as `B` is a
lower bound and `E` is one member's divisor `≥ B` too, forcing `E = B`), so the single
member `f` achieves the base divisor *at every point*. Then `B = E` has degree `deg N − g`,
the moving part `N − d_p − B` has degree `(deg N − g) − (deg N − g) = 0`, and
`T = H⁰(N − d_p) = H⁰((N − d_p − B) + B) ≅ H⁰(N − d_p − B)` has `dim = h⁰(deg‑0 divisor) = 1`
(only constants on the fibre curve). This **contradicts `dim T = deg N + 1 − 2g ≥ 2`**.

Therefore there is a zero `w ≠ z` of `f` with `E_w > B_w = min_ψ E_{ψ,w}`, i.e. the achiever
*at `w`* (a **different** section `f_w`, BaseDivisor:143 at `x = w`) has
`div(f_w)_w < div(f)_w`, so `read sec z = f` does **not** divide `read f_w` at `w`.

> **Answer to the crux question: does `read sec z` cut `d_p` GLOBALLY by degree count?
> NO.** The degree count `deg E = deg N − g ≥ 2 > 0` combined with `dim T ≥ 2` *forces*
> genuine extra zeros of `read sec z` away from `z`, at which other readings have strictly
> smaller order. `⟨read sec z⟩ ⊊` the divisor ideal over the fibre; global divisibility
> FAILS. This is exactly I‑0288's wall (facts 1 + 3), now nailed with the closed degree
> identity. The achiever cuts `d_p` at `z` and nowhere else.

Option (ii) — "does flat + carve rank‑g (`hsub_chart`, fibre‑injectivity) give it?": **no.**
`hsub_chart` is fibre *injectivity* (the reading map's rank / the quotient's flatness). It
transports/lifts *existing* fibre facts; it cannot upgrade single‑point achievement to a
whole‑fibre common divisor. The flat's advertised role (I‑0302 §2b: "lift base‑fibre
generation over κ(p) to the curve‑point fibre κ(z)") is **backwards** — it needs κ(p)
generation as *input*, which is precisely the false global statement. Flatness runs
κ(p) ⟹ (finer), never the reverse.

---

## §3 — The route (architectural alternative)

### The defect is the *choice of fibre* in the reduction, not the geometry

`z ∉ supp_{Γ(V)}(N z)` is a **Zariski‑local‑at‑`z`** condition on the total space:
`(N z)_{pz} = 0`. mathlib gives it iff‑equivalent to a **single‑point** fibre vanishing —
`Module.mem_support_iff_nontrivial_residueField_tensorProduct`, applied **at `pz` over
`Γ(V)`** (`N z` is `Module.Finite Γ(V)`, `chartColengthModule_finite`, landed I‑0303):
```
z ∉ supp_{Γ(V)}(N z)  ⟺  Subsingleton (N z ⊗_{Γ(V)} κ(z)),   κ(z) := κ(pz) = residue field at z.
```
This is the fibre of the coherent sheaf `N z` at the *point* `z` — extra zeros of
`read sec z` at other points `w ≠ z` **do not touch this stalk**. The achiever's
single‑point local generation at `z` (`read sec z` attains the base multiplicity there,
so it is a local generator of the readings at `z`) is *exactly* what makes this
Subsingleton hold.

The **landed 2c bridge** (`DivSchemeRedesignSeedFinish.lean:115‑156`) instead uses the same
mathlib lemma but at `pR = (pz).comap (algebraMap R Γ(V))` **over `R`** (line 125‑134),
reducing to `Subsingleton(chartColengthModuleBase ⊗_R κ(p))` — the readings dying over the
**whole** κ(p)‑fibre. That is the global condition §2 kills. The bridge discarded the
landed `Γ(V)`‑finiteness of `N z` and re‑derived a weaker `R`‑finiteness
(`chartColengthModuleBase_finite`, SeedFinish:92) only to enable the comap — the wrong move.
The **germ lemma** (`DivSchemeRelDivisor.lean:241`) has the same defect:
`basePrime φ = comap …(maximalIdeal O_z)` over `R` (`:224‑226`) **is** the base prime `p`,
so it needs `Subsingleton(N ⊗ κ(basePrime)) = Subsingleton(N ⊗ κ(p))`. The **flat lemma**
(`:303`) consumes `x ⊗ 1 = 0 in M ⊗ κ(p)` for `p : PrimeSpectrum R` (`:305`) — again κ(p).
**All three reduce to the whole κ(p)‑fibre. None reduces to the sharp κ(z) point.**

### The corrected route (bounded)

1. **Reduction (nearly free):** replace the 2c bridge with a direct application of
   `Module.mem_support_iff_nontrivial_residueField_tensorProduct` at `pz` over `Γ(V)`,
   using the landed `chartColengthModule_finite`. Target becomes
   `Subsingleton(N z ⊗_{Γ(V)} κ(z))`. No comap, no κ(p), no gap‑(a) flat.
2. **The one genuine remaining lemma — the relative one‑point stalk Nakayama (I‑0289's
   originally‑scoped size‑L brick, never built):** prove `Subsingleton(N z ⊗_{Γ(V)} κ(z))`
   from the achiever. Two sub‑pieces:
   (i) **base‑change identification** of `N z`'s fibre at `z` (over `Γ(V)`, residue κ(z))
       with the colength of the κ(p)‑fibre curve `relCurve C κ(p)` at the point `z` — this
       is the `isLocalization_stalk` / scheme‑residue‑field wiring I‑0302 §2c flagged as
       "NOT yet used in‑tree; fresh wiring";
   (ii) the achiever's **local generation at `z`**: `read sec z` attains
       `baseDivisorAt(T, N − d_p, z)` (I‑0291), so it generates the readings in the fibre
       DVR at `z`, killing the fibre `N z ⊗ κ(z)`.
   A fibre→stalk lift (a Nakayama at the local ring `O_z`, possibly using the *curve's*
   structural flatness over `R`, `flat_sections_relPinnedChart` — **not** the gap‑(a)
   ideal‑quotient flat) closes it. Crucially this stays **single‑point**, so the §2 degree
   obstruction never applies.

### Why not the fully carve‑direct non‑seed alternative (I‑0268 Route 3 / I‑0289 fallback)?

I‑0289 already settled this (task Q1b): a carve‑direct `CertifiedDivisorFamily` avoiding the
seed needs **three** `Γ`‑local bridges absent from mathlib+in‑tree (R‑flat+fibrewise‑invertible
⇒ invertible; rank‑1 projective ⇒ `Module.Invertible`; invertible ideal ⇒ single local
generator). All are strictly **harder** and abandon the landed R_Z‑fibrewise surface. It does
NOT dodge this wall — the same single‑point‑vs‑global tension reappears as "the invertible
sheaf's local generator." **Keep the seed; do the κ(z) pivot above.** The architecture change
is *internal* (swap the fibre of the reduction, κ(p) → κ(z)), not a construction rebuild.

---

## §4 — Sizes

| Item | Size | Notes |
|---|---|---|
| **Gap (a)** — `Flat R (Γ(V)/(range + Γ(V)·read s))` | ≥ L, but **MOOT** | quotient by a **non‑finite** R‑submodule; free‑codomain keystone (needs finite source) does not apply; quotient‑of‑flat‑not‑flat. Never needed — it sits on the dead κ(p) branch downstream of the false gap (b). |
| **Gap (b) as posed (κ(p) global divisibility)** | **IMPOSSIBLE** | false by degree: `deg E = deg N − g ≥ 2 > 0` + `dim T ≥ 2` force extra zeros. No theorem closes it because it is not true. |
| **Corrected reduction** (mem_support_iff at `pz` over `Γ(V)`) | XS | reuse landed `chartColengthModule_finite`; mathlib lemma; drops 2c bridge. |
| **Relative one‑point stalk Nakayama** (κ(z), the real remaining brick) | **L** | I‑0289's originally‑scoped lemma; needs the `isLocalization_stalk` base‑change wiring (fresh) + achiever local‑gen + a fibre→stalk flat lift (structural curve flat, not gap (a)). Single‑point ⇒ degree obstruction never fires. |
| hfib (residual wall 2, I‑0304) | M | wire the achiever's uniform fibre‑nonvanishing (`windowCompare ≠ 0`, I‑0291 component (a)) into `seedUniv.sec`; independent of the above, unblocked by the achiever wiring. |

**Net:** the seed is **not** finishable by pushing the current κ(p) path (it terminates in a
false statement). It **is** finishable by the bounded κ(z) pivot: one XS reduction swap + one
L stalk‑Nakayama brick + one M hfib wiring. Multi‑week only if the `isLocalization_stalk`
base‑change identification proves thorny; the *mathematics* is standard curve geometry
(single‑point local generation), not new theory.

---

### Evidence index (file:line)

* Achiever is per‑point (`Nat.sInf_mem`, single `x`): `RiemannRoch/BaseDivisor.lean:143‑154`;
  lower‑bound‑only at other points `:128‑139`.
* `d_p` effective, `deg = g`, window `= H⁰(N − d_p)`:
  `Picard/DivSchemeSeedUnivFields.lean:146‑161`.
* `dim T + g = h⁰(𝒪(N))` ⇒ `dim T = deg N + 1 − 2g ≥ 2`:
  `Picard/DivSchemeSeedUnivAssembleKappa.lean:207‑210`.
* `deg N ≥ b + 2g + (g+2)(s+1)δ`: I‑0288 (WindowLedger:189 + WindowFieldTransport:319).
* 2c bridge comaps to `R` (κ(p)): `Picard/DivSchemeRedesignSeedFinish.lean:115‑156`
  (esp. `:125‑134`); it re‑derives R‑finiteness `:92`.
* germ lemma `basePrime = comap over R = p`: `Picard/DivSchemeRelDivisor.lean:224‑226`,
  `:241‑248`.
* flat lemma consumes `x ⊗ 1 = 0 in M ⊗ κ(p)`, `p : PrimeSpectrum R`:
  `Picard/DivSchemeRelDivisor.lean:303‑320`.
* Sharp iff over `Γ(V)` available: `Module.mem_support_iff_nontrivial_residueField_tensorProduct`
  (mathlib, already used at SeedFinish:129) + landed `chartColengthModule_finite` (I‑0303).
* Landed chart flat is `Γ(V)/range` (R‑span), not the ideal quotient:
  `flat_chart_colength_divUniversalSeedK`, I‑0302 commit 683de581f.
