# Wave-4 w4-3 — the rigid two-term pushforward engine: the binding worksheet (`AJCR.w4-rep` / G-CBC-6)

*Written 2026-07-16 (Fable design agent). Route design per the (C2) lesson: decisions
first, provers only from specs derived from this worksheet. Model:
`informal/w4-flv-worksheet.md`. Inputs read in full: `informal/w4-datum-design.md`
(§§1, 2.1, 3.2, 4.1–4.2, 5), `informal/w4-cbc-recon.md` (§0.2 CBC-0..3, §2 G-CBC-6, §5
risks 4–5), `informal/session-handoff-2026-07-15.md`, the landed engine files
(`Cohomology/{TwoCover,RelativeTwoCover,QcohSections,AffineVanishingQcoh,MayerVietoris,
SectionsBaseChange,Finiteness}.lean`), the landed FLV campaign
(`RiemannRoch/{FLVClass,FLVVanishing,FiberTwist}.lean`), `Curve/MapToP1.lean`, and Kleiman
`references/kleiman-picard-src/kleiman-picard.tex` (`sb:Q` = 3.10, lines 1897–1935;
`th:LinSys` 1963–2030; `th:main` proof 2168–2366, anchor lines cited below). Mathlib
gifts verified by grep against the pinned checkout (`.lake-packages/mathlib`, v4.31.0);
names cited `file:line`. No Lean edited; no build run.*

**STATE AT WRITING.** w4-1 (the cech-port: `QcohOn` + twisted affine vanishing) is
LANDED (`QcohSections.lean`, `AffineVanishingQcoh.lean`). The FULL FLV campaign is
LANDED, including the class form and the rank anchor
(`FLVClass.exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1`,
`FLVClass.h0_eq_deg_add_chi_of_subsingleton_hModule_one`), and the dominance witness for
the constructed map (`Curve/MapToP1.exists_isFinite_isDominant_toP1`). w4-5 (fiber
twist) is LANDED (`RiemannRoch/FiberTwist.lean`). **w4-2 is NOT landed** (handoff
frontier item 1); this worksheet designs against its charter (the cocycle-glued `QcohOn`
constructor + bundled CBC-1/2) and freezes the interface w4-3 consumes from it (§4.6).

**VERDICT IN ONE LINE.** Full Mumford II.5 (the universal finite-projective Grothendieck
complex) is NOT needed and is descoped; the honest curve-lite engine is four module-level
theorems on the π-two-lattice pair — coherence (H¹ finitely generated over ANY test
ring, by a finite surjection from ℙ¹ line-bundle models; H⁰ finitely generated over
Noetherian), Nakayama vanishing-propagation with an openness export, and split/flat
rigidity (H¹ = 0 ⟹ H⁰ finite projective with base change on the nose for every ring map
AND every module coefficient) — with Noetherian carried on the H⁰-finiteness clause only
and eliminated for arbitrary test rings by a presentation-descent brick; only the final
sheaf-level assembly gates on w4-2.

---

## §1 THE STATEMENTS — the scoping decision and the pinned shapes

### 1.1 What the datum actually needs — the scoping decision (DECIDED)

The mission's question: full II.5, or (a) "H⁰ = kernel of a map of finite projectives
universally" + (b) "locally free `Q := coker` with rank χ on the vanishing locus"?

Re-reading Kleiman against the landed route settles it. The engine is consumed at
exactly three places (w4-datum §1.2):

- **(V-rel-A), chart building.** `th:LinSys` (tex 1963–1967): the chart is `ℙ(Q)` with
  `Q` THE module of `sb:Q` (tex 1897–1904): `Hom(Q, N) ≅ f_*(L ⊗ f^*N)` naturally in the
  quasi-coherent `N`, and at the crux (tex 2345–2348) *"m = 0, so H¹(X_t, L_t) = 0 for
  all t ∈ T' owing to (4.8.3). Since (v) implies (i) in Subsection 3.10, therefore Q is
  locally free."* What is consumed downstream of `Q` being locally free: `ℙ(Q)` smooth
  (tex 2350: étale-local sections via EGA IV 17.16.3(ii)), and the `Hom(Q,N)`-bookkeeping
  to convert sections into classifying maps (tex 1979–1998).
- **(V-rel-B), homEquiv surjectivity.** The same crux run over an arbitrary test ring.
- **Strata bookkeeping.** The nested opens `P^φ_m ×_{P^φ} T` (tex 2295–2306): openness
  of the fibrewise-vanishing locus, and its exhaustion (the latter is FLV's, landed).

Everywhere the engine fires, the fibrewise vanishing hypothesis is IN FORCE (the strata
normalize `m = 0` before the engine is invoked; tex 2345). So:

> **DECISION (scope).** w4-3 delivers Kleiman 3.10 (v)⟹(i)+(iii) in curve-lite form and
> nothing more: **on the fibrewise-vanishing locus**, `H¹(C_R, L) = 0`,
> `Q := H⁰(C_R, L)` is a finite projective `R`-module, and its formation commutes with
> `⊗_R N` for EVERY `R`-module `N` (in particular with every ring map `R → R'`), with
> fibre rank `deg + χ` (the landed FLV anchor). **No two-term complex of finite
> projectives is ever constructed**: (a) is dropped — `H⁰` is exhibited as the kernel of
> the HUGE free Čech complex and its finiteness comes from coherence, not from a finite
> presentation of the complex; (b) is delivered with `Q = H⁰` itself (no dual-cokernel
> construction: in curve-lite the base change is on the nose, so `Hom(Q^∨, N) ≅ Q ⊗ N ≅
> ker(δ ⊗ N)` is finite-projective duality — the `eq:Q` bookkeeping is a corollary, not
> a construction). Mumford II.5 survives as the historical anchor only; its Grothendieck
> complex (Lemma II.5.1) is descoped with a recorded re-entry path (§5.6).

Why (a)/full-II.5 would be wasted work here: the Grothendieck complex construction
PRESUPPOSES finitely generated cohomology (Mumford quotes the coherence theorem before
II.5.1; EGA III 6.10.5 likewise) — it does not produce finiteness, it packages it. Once
coherence is in hand (§2), the vanishing locus makes the packaging trivial (split/flat
exactness, §3), and no consumer on the pinned route evaluates the engine off the
vanishing locus (the strata are DEFINED fibrewise — χ-ledger + FLV — not by a relative
complex).

### 1.2 The pinned statements (binding shapes; spelling lane-owned)

The engine is stated at TWO levels, deliberately: a module-level core (no schemes — the
Fable heart, launchable now) and a sheaf-level assembly (gates on w4-2).

**Level 1 — the two-lattice pair (the core).** Standing data, over a commutative ring
`R` (Noetherian only where flagged): the curve-lite avatar of "coherent sheaf on
`ℙ¹_R`", pinned as a structure (name/spelling lane-owned; recommended carrier below):

- `R`-modules `M₀`, `M₁`, `N` with `R[t]`-module structure on `M₀` and `N`, and
  `R[s]`-module structure on `M₁` and `N` (`s` acting on `N` as the inverse of `t` —
  `t` acts invertibly on `N`);
- `ι₀ : M₀ →ₗ N` with `IsLocalizedModule (Submonoid.powers t) ι₀` (mathlib class,
  `Algebra/Module/LocalizedModule/Basic.lean:547` — its three axioms are exactly the
  landed `QcohOn` (P2) pair plus unit-action, see §2.3);
- `ι₁ : M₁ →ₗ N` with `IsLocalizedModule (Submonoid.powers s) ι₁`;
- finiteness where flagged: `Module.Finite R[t] M₀`, `Module.Finite R[s] M₁`.

Its two-term complex is `δ : M₀ × M₁ →ₗ[R] N`, `δ(m₀, m₁) = ι₀ m₀ − ι₁ m₁`;
`H⁰ := ker δ`, `H¹ := N ⧸ (range ι₀ ⊔ range ι₁)`. The four theorems:

```
-- (COH-1)  coherence in degree 1 — over ANY commutative R (no Noetherian!):
theorem finite_h1 [Module.Finite R[t] M₀] [Module.Finite R[s] M₁] :
    Module.Finite R H¹
-- (COH-0)  coherence in degree 0 — Noetherian:
theorem finite_h0 [IsNoetherianRing R] [Module.Finite R[t] M₀] [Module.Finite R[s] M₁] :
    Module.Finite R H⁰
-- (VAN)  vanishing propagation + the openness export — any R (consumes COH-1):
theorem subsingleton_h1_of_fibrewise
    (hfib : ∀ p : PrimeSpectrum R, Subsingleton (H¹ ⊗[R] κ(p)))    -- fibre form, §3.2
    : Subsingleton H¹
theorem isOpen_fibrewise_vanishing :                                -- Supp H¹ is closed
    IsOpen {p : PrimeSpectrum R | Subsingleton (H¹ ⊗[R] κ(p))}
-- (RIG)  split/flat rigidity — any R; module coefficients (consumes flatness of N):
theorem h0_baseChange [Module.Flat R N] [Subsingleton H¹] (P : Type u) [module data] :
    (H⁰ ⊗[R] P ≃ₗ[R] ker (δ ⊗ P)) ∧ Subsingleton (coker (δ ⊗ P))
theorem finite_projective_h0 [IsNoetherianRing R] [Module.Flat R M₀] [Module.Flat R M₁]
    [Module.Flat R N] [Subsingleton H¹] [Module.Finite R[t] M₀] [Module.Finite R[s] M₁] :
    Module.Finite R H⁰ ∧ Module.Projective R H⁰
```

Conclusions are `Subsingleton`/`≃ₗ`, never `finrank = 0`/`Nonempty` (house rules; the
consumers transport `Subsingleton` and need honest equivs — recon design constraints).

**Level 2 — the sheaf assembly (G-CBC-6 as the datum consumes it).** For the frozen
curve bundle `C`, a test ring `R`, the pinned base-changed two-cover `V₀ᴿ, V₁ᴿ`
(`RelativeTwoCover.relCover`, landed), and a sheaf
`F : Sheaf (Opens.grothendieckTopology (relCurve C R)) (ModuleCat R)` — presented
however w4-2 presents it, consumed here only through:
`[Scheme.QcohOn F V₀ᴿ]`, `[Scheme.QcohOn F V₁ᴿ]` (w4-1's packaging, landed), chart
finiteness (`Γ(Vᵢᴿ, F)` finite over `Γ(Vᵢᴿ, 𝒪)` — discharge in §4, RE-4b), and w4-2's
CBC-1 (base change of sections + δ-naturality):

```
theorem rigidEngine [IsNoetherianRing R] (hfib : ∀ p, Subsingleton (fibre-complex H¹ at κ(p))) :
    Subsingleton (Sheaf.HModule F 1)                                    -- H¹(C_R, F) = 0
    ∧ Module.Finite R (Sheaf.HModule F 0) ∧ Module.Projective R (Sheaf.HModule F 0)
theorem rigidEngine_baseChange (φ : R →+* R') :                          -- on the nose, ∀ φ
    Sheaf.HModule F 0 ⊗[R] R' ≃ₗ[R'] Sheaf.HModule F_{R'} 0
    ∧ Subsingleton (Sheaf.HModule F_{R'} 1)
-- rank corollary (fibre form; consumes FLV's anchor through the W6-full seam):
theorem rigidEngine_rank (p) (D_p : witness divisor of the fibre class at κ(p)) :
    finrank κ(p) (Sheaf.HModule F 0 ⊗[R] κ(p)) = deg D_p + χ(𝒪)
-- the strata export:
theorem rigidEngine_isOpen_vanishing :
    IsOpen {p : PrimeSpectrum R | Subsingleton (fibre-complex H¹ at κ(p))}
```

The `H⁰` carrier fires through a small new bridge `Sheaf.HModule F 0 ≃ₗ[R] ker δ_F`
(`linearEquiv₀` + the landed Mayer–Vietoris degree-0 exactness
`sections_ext`/`moduleDiff_restriction`/`exists_glue_of_moduleDiff_eq_zero`,
`Cohomology/MayerVietoris.lean:152,173,184` — the kernel twin of the landed cokernel bridge
`TwoCover.h1CokEquiv`); the `H¹` carrier is landed
(`Scheme.twoCoverH1LinearEquiv`, `TwoCover.lean:92`, vanishing instances from
`IsAffineOpen.subsingleton_hModule'_one_of_qcoh`, `AffineVanishingQcoh.lean:320`).

**The representing-functor bookkeeping** (Kleiman `eq:Q`, tex 1902–1904, consumed by the
`th:LinSys` step of the datum): delivered as the module-coefficient clause of (RIG) —
`ker(δ ⊗ P) ≅ H⁰ ⊗ P` for every `R`-module `P`, plus finite-projective duality
`H⁰ ⊗ P ≅ Hom(H⁰^∨, P)`. No `f_*`-functor is ever formed; the datum's `ℙ(Q)` chart takes
`Q := H⁰` directly. (Kleiman's `N ↦ f_*(L ⊗ f^*N)` at affine tests IS
`P ↦ ker(δ ⊗ P)` through CBC-1 — the identification is w4-6's, not w4-3's.)

### 1.3 What w4-3 deliberately does NOT say

- **No Grothendieck complex** (§1.1). No `R^i f_*`, no derived functors, no coherent
  sheaf theory on `ℙ¹_R` as such — the "coherent sheaf on `ℙ¹_R`" only ever appears as
  the two-lattice pair.
- **No statement off the vanishing locus** beyond COH + the openness export. In
  particular no semicontinuity theory, no jump loci, no Hilbert polynomials.
- **No fibrewise-vanishing discharge.** The hypothesis `hfib` is supplied by the
  consumer from the landed FLV class form + the W6-full seam (w4-2/datum lane, FLV
  worksheet §3.2); w4-3 consumes it in complex form precisely to stay decoupled (§4.5).
- **No degree-constancy.** The rank export is per-fibre (`deg D_p + χ`); constancy of
  `deg` across `Spec R` is the datum's degAt/G-D6 obligation (FLV worksheet's
  hypothesis-supplier note), not the engine's.

---

## §2 THE ROUTE — where the finiteness honestly comes from (DECIDED)

### 2.1 The decision, and a correction to the mission's framing

**The finiteness does NOT come from the twist.** It comes from the landed π-lattice
structure: `Γ(V₀, 𝒪)` is module-finite over `k[t]` along the finite `π : C ⟶ ℙ¹`
(`Curve/MapToP1.finite_app_chartOpen`, `:161` — the E-i shape), and this base-changes to
`Γ(V₀ᴿ) ≅ Γ(V₀) ⊗_k R` finite over `R[t]` (on the nose, `Over.sectionsBaseChange`,
`SectionsBaseChange.lean:287`). The twist buys exactly one thing: the fibrewise
vanishing hypothesis (FLV, landed) — and the engine is twist-agnostic. The three
finite-generation candidates named by the datum design resolve as:

- **the image lattice in the overlap sections** — YES, in the sharpened form of the
  two-lattice pair: the mission's "finite free `F ↠` the needed cocycles" (Mumford's
  II.5.1 trick) survives, but applied at the `R[t]`-LATTICE level, where `Module.Finite
  R[t] M₀` makes it terminate (§2.2). At the raw `R`-level the trick is impossible
  without prior coherence — a finite free `R`-approximation of the huge `C⁰` with the
  same `H⁰` IS coherence.
- **a finite generating family from quasi-compactness + `QcohOn` (P2)** — YES, but as
  the discharge of the chart-finiteness HYPOTHESIS for glued sheaves (§4, RE-4b:
  localization-local finite generation, `Module.Finite.of_localizationSpan_finite'`,
  mathlib `RingTheory/Localization/Finiteness.lean:191`), not as the engine's own
  finiteness mechanism.
- **Noetherian `R`** — carried, but ONLY on the `H⁰`-finiteness clause (COH-0); the
  discovery of this pass is that COH-1, VAN, and the `H⁰`-base-change clause are
  Noetherian-FREE (§2.2). Generality for arbitrary test rings is recovered by
  presentation descent (§2.4), not by Noetherian-free coherence (which is false-adjacent:
  §2.5's ℚ/ℤ obstruction shows what goes wrong without finiteness).

### 2.2 The coherence argument (COH) — Serre's dévissage on the two charts, module-level

This is the Fable heart (RE-1). Everything happens in the two-lattice pair; no schemes.

**The models.** For `m : ℤ`, the model pair `𝒪(m)` is `(R[t], R[s], R[t,t⁻¹])` with the
glue twisted by `t^m` — the curve-lite `𝒪_{ℙ¹}(m)`. Its cohomology is the classical
monomial-window computation, relative over any `R`:
`H⁰(𝒪(m))` free of rank `m + 1` (`m ≥ 0`, else `0`); `H¹(𝒪(m))` free of rank
`−m − 1` on the window `{t^{-1}, …, t^{m+1}}` (`m ≤ −2`, else `0`). The tree has the
field-level ancestor (`Cohomology/FinitenessP1.lean`; Hartshorne III.5.1 pages already
in the manifest as the anchor of the landed finiteness node).

**The finite surjection onto a pair.** Given the pair `M = (M₀, M₁, N)` with
`Module.Finite R[t] M₀` and `Module.Finite R[s] M₁`: choose finite generators `gᵢ` of
`M₀` and `yⱼ` of `M₁`. By `IsLocalizedModule.surj` (denominator clearing), each
`ι₀ gᵢ ∈ N` satisfies `s^{mᵢ} • ι₀ gᵢ ∈ range ι₁`-side data and symmetrically — each
generator produces a map of pairs from a model `𝒪(−mᵢ)` hitting it. Summing:
`E := ⊕ models ↠ M` — a map of pairs, surjective on both lattice components. This IS
Mumford's "finite free approximation mapping onto the needed cocycles", terminating
because it runs over `R[t]`, not `R`.

**(COH-1), any `R`.** `H¹(M)` is a quotient of `H¹(E) = ⊕ H¹(models)` = a finite free
`R`-module of monomial windows. Direct argument (no snake needed): localization is
exact/functorial (`IsLocalizedModule.map` + uniqueness `IsLocalizedModule.iso`), so
`N_E ↠ N_M`; lift a class through it; the pair map carries `range ι₀ ⊔ range ι₁` into
the same for `M`. **Hence `Module.Finite R H¹` for every commutative `R`** — with an
explicit finite window of generators. This unlocks VAN and the openness export with no
Noetherian hypothesis anywhere.

**(COH-0), Noetherian `R`.** The kernel pair `K := (ker E₀ ↠ M₀, ker E₁ ↠ M₁)` — glue
by localization-exactness — is again a finite pair: `E₀` is finite free over `R[t]`,
which is Noetherian by Hilbert's basis theorem (`Polynomial.isNoetherianRing`, mathlib
`RingTheory/Polynomial/Basic.lean:787`, an instance), so `K₀` is finite. The SES of
pairs `0 → K → E → M → 0` gives a SES of two-term complexes (localization exactness on
the `N`-column), hence the six-term sequence
`0 → H⁰K → H⁰E → H⁰M → H¹K → H¹E → H¹M → 0` (hand-rolled connecting map on two-term
complexes, or mathlib `Algebra/Homology/ShortComplex/SnakeLemma.lean`). Then `H⁰M` is an
extension of `ker(H¹K → H¹E)` — a submodule of the COH-1-finite `H¹K`, finite by
Noetherianity — by a quotient of the finite free `H⁰E`. **Hence `Module.Finite R H⁰`.**
Note the pleasant economy: COH-1 needs no induction and COH-0 needs exactly ONE
application of COH-1 (to `K`); no dimension dévissage, no twisting-through-degrees.

### 2.3 The `QcohOn ⟹` lattice-pair bridge (why w4-1's packaging is exactly enough)

The landed (P2) axioms (`QcohSections.lean:154,161` — denominator clearing + defect
annihilation on affine opens) plus invertibility of the overlap coordinate
(`isUnit_fiberCoord_res_inf`-shape, relative form via `Scheme.preimage_basicOpen` on the
pinned cover: overlap `= basicOpen t₀ᴿ`) are term-for-term the three axioms of mathlib's
`IsLocalizedModule` (`map_units` / `surj` / `exists_of_eq`) for the restriction
`Γ(V₀ᴿ, F) →ₗ Γ(V₀ᴿ ⊓ V₁ᴿ, F)` at the powers of `t₀`. So the sheaf-level engine input
IS a two-lattice pair, by construction of w4-1's packaging — no new sheaf theory. The
same bridge on the `V₁ᴿ`-side uses the other chart coordinate (`t₁`, with `t₀t₁ = 1` on
the overlap — the landed `P1.chartCoord` relation pulled back). This bridge is RE-0's
content and gates on nothing unlanded.

### 2.4 The Noetherian decision (DECIDED), and where each leg of the datum sits

- **(V-rel-A)** (chart building; `Z`, `ℙ(Q)`, `LinSys`): runs over the datum's OWN chart
  rings — finite type over the finite separable `k'` (design §4.5: Div^d/Grassmannian
  charts, Σ-opens, quasi-projective pieces), all Noetherian. The engine core applies
  directly. **No descent needed.**
- **(V-rel-B)** (homEquiv surjectivity at arbitrary `T`): the class is an arbitrary
  cocycle over an arbitrary `k`-algebra `B`. **Presentation descent (RE-5):** a cocycle
  datum is finitely many elements of section rings `Γ(W) ⊗_k B` (finite cover, unit
  witnesses, cocycle equations — finitely many equations in finitely many elements);
  since `Γ(W) ⊗_k −` commutes with the filtered colimit `B = colim B₀` over finitely
  generated `k`-subalgebras, the entire datum descends to some finitely generated
  (hence Noetherian) `B₀ ⊆ B`. Fire the engine over `B₀`; the UNIVERSAL base-change
  clause (RIG — every ring map, no flatness, no finiteness of `R'`) transports the
  output along `B₀ → B`: `H⁰(C_B, L) = Q₀ ⊗_{B₀} B` finite projective, `H¹ = 0`.
  This is the honest curve-lite replacement for EGA IV 8 Noetherian approximation — it
  approximates only the COCYCLE, never the scheme (the curve is constant over `k`),
  which is why it is bounded.
- The engine statements therefore carry `[IsNoetherianRing R]` exactly on
  COH-0/`finite_projective_h0`/`rigidEngine`, and RE-5 exports the arbitrary-`R`
  corollary. Kleiman's own Noetherian reduction (tex 2168–2173, "we may assume S is
  Noetherian") is the same move made once and for all at the base; ours must be made at
  the test object, and RE-5 is that move.

### 2.5 Routes weighed and rejected (the honest costs)

- **(a) Relativize the FLV lattice exhaustion directly over `R`** (the "obvious"
  continuation of the landed field-level route). REJECTED, for a reason worth recording:
  the exhaustion's stages base-change with the WRONG variance. The stage modules
  `H¹_n := image of t^{-n}Λ₀ in H¹` satisfy `H¹_n ⊗ κ(p) ↠ (fibre stage)`, and fibre
  vanishing kills the fibre stage — which says nothing about `H¹_n ⊗ κ(p)`. Every
  leading-term/stabilization variant tried in this pass hit the same one-way comparison.
  The classical resolution is exactly coherence-first (then Nakayama needs no stages),
  and that is the route taken.
- **(b) Fibrewise-to-relative without finiteness.** IMPOSSIBLE: `M = ℚ/ℤ` over `ℤ` has
  `M ⊗ κ(p) = 0` for every prime yet `M ≠ 0` — and `ℚ/ℤ` is even an increasing union of
  finite modules, so no colimit-of-finite-stages structure can substitute for COH. The
  engine's Nakayama step (`Module.support_eq_empty_iff` +
  `Submodule.eq_bot_of_le_smul_of_le_jacobson_bot`, mathlib `RingTheory/Support.lean`,
  `RingTheory/Nakayama.lean:118`) genuinely consumes `Module.Finite R H¹`.
- **(c) The dual-`Q` construction (EGA III 7.7.6 shape).** REJECTED: representing
  `P ↦ ker(δ ⊗ P)` by a cokernel of duals requires the FINITE complex first (infinite
  free modules break `⊕`-vs-`∏` duality); it is downstream of the descoped Grothendieck
  complex, and the split/flat route (§3) delivers its consumable content for free.
- **(d) Full relative coherent-sheaf theory on `ℙ¹_R` / `R^i f_*` port.** Off-route
  (route rule 5, keystone-funnel); the two-lattice pair is the entire footprint of
  "coherent module on `ℙ¹_R`" that the route needs.

### 2.6 Why H² never appears

Two-term complexes have no `H²`; the six-term sequence of §2.2 is the whole long exact
sequence. This is the "lite" that the curve's two-chart cover buys and the reason the
engine stays a module-algebra campaign.

---

## §3 BASE CHANGE OF THE COMPLEX — how universality is stated and proved

### 3.1 The three layers of the statement

Universality ("formation commutes with EVERY base change `R → R'`, not just flat") is
stated in three decoupled layers, each with its own proof mechanism:

1. **Terms (CBC-1, w4-2's).** `Γ(Vᵢᴿ, F) ⊗_R R' ≅ Γ(Vᵢ^{R'}, F_{R'})` naturally in
   restrictions, so `δ_F ⊗_R R'` IS `δ_{F_{R'}}` up to the pinned identifications. For
   `𝒪` this is landed (`sectionsBaseChange` + `_naturality`); for the glued `F` it is
   w4-2's charter. w4-3 CONSUMES this seam and states its own clauses against the
   abstract complex, so the engine core never waits for it.
2. **`H¹` (free).** `coker(δ ⊗ P) = (coker δ) ⊗ P` by right-exactness of `⊗` — for
   every `R`-module `P`, no hypotheses. On the vanishing locus both sides are `0`; off
   it, `H¹` still base-changes right-exactly (used by VAN at `P = κ(p)` and by the
   openness export). Nothing to design; one mathlib-level lemma.
3. **`H⁰` (THE hard content, and the honest argument).** Kernels do not commute with
   `⊗`. Honest counterexample to keep in the file docstring: `δ = (·p) : ℤ → ℤ` has
   `ker δ = 0` but `ker(δ ⊗ 𝔽_p) = 𝔽_p` — h⁰ jumps are real and universality without
   the vanishing hypothesis is FALSE. The rigidity argument, in full:

   > Assume `Subsingleton H¹`, i.e. `δ : C⁰ ↠ C¹` (`C⁰ := M₀ × M₁`, `C¹ := N`). Then
   > `0 → ker δ → C⁰ → C¹ → 0` is exact with `C¹` FLAT over `R` (in the application
   > `C¹ ≅ Γ(V₀⊓V₁) ⊗_k R`, free — a `k`-basis is an `R`-basis; mathlib
   > `LinearAlgebra/TensorProduct/Free.lean` machinery through the `sectionsBaseChange`
   > iso). For any `R`-module `P`, the `Tor` sequence
   > `Tor₁(C¹, P) → (ker δ) ⊗ P → C⁰ ⊗ P → C¹ ⊗ P → 0` has vanishing left end by
   > flatness of `C¹`, so `(ker δ) ⊗ P → ker(δ ⊗ P)` is an isomorphism and
   > `coker(δ ⊗ P) = 0`. (Equivalently: the surjection onto the free `C¹` splits and
   > split exactness is absolute — either spelling; the `Tor`-free split spelling is
   > recommended for Lean: a section `σ : C¹ → C⁰` via `Module.projective_lifting_property`,
   > then `C⁰ ≅ ker δ ⊕ C¹` and everything is direct-sum bookkeeping.)
   > Furthermore `ker δ` is flat (kernel of a surjection between flats; or: direct
   > summand of `C⁰`), and — Noetherian + COH-0 — finitely generated, hence finitely
   > presented, hence PROJECTIVE by `Module.Flat.projective_of_finitePresentation`
   > (mathlib `RingTheory/Flat/EquationalCriterion.lean:288`; over any ring — the
   > Noetherianity is spent making `f.g. ⟹ f.p.`, nowhere else).

   The quantifier is deliberately `⊗ P` for MODULE `P`, not only ring maps: the ring
   case (`P = R'`, with the `R'`-linear structure on both sides — small bookkeeping
   clause) gives base change; the module case gives Kleiman's `eq:Q` functor
   bookkeeping (§1.2). One statement serves both consumers.

### 3.2 The fibre seam (how `hfib` meets FLV)

The engine's hypothesis is pinned in COMPLEX form: `Subsingleton (H¹ ⊗ κ(p))`
(equivalently `Subsingleton (coker(δ ⊗ κ(p)))` by layer 2). The consumer's chain that
discharges it, none of it owned by w4-3:
`FLVClass.exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1` (landed;
`Subsingleton H¹(divisorSheaf witness)` at `κ(p)`) → W6-full (glued fibre sheaf ≅
divisor sheaf of a witness; w4-2/datum seam, FLV worksheet §3.2) → the fibre carrier
(`twoCoverH1LinearEquiv` at `κ(p)` + w4-2's CBC-1 at `R → κ(p)`, identifying the fibre
sheaf's `H¹` with `coker(δ ⊗ κ(p))`). Pinning the hypothesis at the complex keeps w4-3
landable before that chain is assembled and immune to its spelling.

### 3.3 The openness export (the strata gift)

With COH-1 (any `R`): `{p | Subsingleton (H¹ ⊗ κ(p))} = Spec R ∖ Supp H¹`, and
`Supp H¹ = Z(Ann H¹)` is CLOSED for finite modules (`Module.support_eq_zeroLocus`,
mathlib `RingTheory/Support.lean:25`). So the fibrewise-vanishing locus is OPEN — the
curve-lite replacement for Kleiman's Serre-theorem openness passage (tex 2298–2306),
falling out of coherence with no extra mathematics. Export it (`rigidEngine_isOpen…`):
the datum's nested strata `P^{φ}_m ×_{P^φ} T` (tex 2295–2297) are these opens, with
exhaustion by the landed FLV class form.

---

## §4 SUB-BRICKS — sizes, delegability, staged fallbacks, consumption

Sizes per recon convention (S ≤ ~150 lines, M ~150–350, L ~350–500). Kernel discipline
per the standing handoff amendments (explicit binders, opaque-insertion, one lake build
under the mutex, `lean_verify` on keystones, files ≤ 500 lines, no new axioms).

- **RE-0 [M, Opus, deps: NONE — launchable now, parallel to w4-2].** The lattice
  toolkit on the pinned relative cover. The `R[t]`-algebra structure on `Γ(V₀ᴿ)`
  (`aeval` at the pulled-back chart coordinate; both charts); relative E-i:
  `Γ(Vᵢᴿ, 𝒪)` finite over `R[t]` (field `finite_app_chartOpen` ⊗ `sectionsBaseChange`;
  `RingHom.Finite` base-change stability); overlap `= basicOpen t₀ᴿ` + `t₀ᴿ` a unit
  there (`Scheme.preimage_basicOpen` on the landed cover; unit via the basic-open
  restriction unit); **the §2.3 bridge**: for ANY `F` with `[QcohOn F Vᵢᴿ]`,
  `IsLocalizedModule (powers t₀) (secRes)` on the chart-to-overlap restriction (P2 +
  unit-action ⟹ the three axioms); `R`-flatness/freeness of the `𝒪`-section modules
  through `sectionsBaseChange`.
- **RE-1 [L, FABLE — the heart; deps: NONE].** The two-lattice pair and coherence
  (§2.2). Staged internally:
  - *RE-1a [M]*: the pair structure, `δ`, `H⁰/H¹` carriers, maps of pairs, the models
    `𝒪(m)` with their window cohomology (free, explicit bases), SES of pairs and the
    six-term sequence (snake at two-term-complex level).
  - *RE-1b [M→L]*: the finite model surjection `E ↠ M`; **COH-1 over any `R`**
    (direct lift, no snake); Noetherian kernel pair; **COH-0**.
  Delegability note: RE-1a is spec-able to Opus once this worksheet's shapes are frozen;
  RE-1b's model-surjection bookkeeping (glue-compatibility conventions) is the one place
  Fable should hold the pen.
- **RE-2 [S→M, Opus, deps: RE-1 (COH-1 only)].** VAN + openness: fibre form ⟺
  `p ∉ Supp H¹` (right-exactness + Nakayama, mathlib kit §2.5(b)); all-fibres ⟹
  `Subsingleton H¹`; `IsOpen` export. Nearly all mathlib.
- **RE-3 [M, Opus, deps: RE-1a statements only — parallel to RE-1b/RE-2].** RIG (§3.1
  layer 3): the split/section construction, `ker(δ ⊗ P) ≅ H⁰ ⊗ P` +
  `coker(δ ⊗ P) = 0` for every module `P`, flatness of `ker δ`, the ring-map corollary
  with `R'`-linear structure, finite projectivity under `[IsNoetherianRing R]` + COH-0,
  and the duality bookkeeping corollary (`Hom(H⁰^∨, P)`-form).
- **RE-4 [M→L, Opus from a tight spec, deps: w4-2 + RE-0..3].** The sheaf assembly =
  the pinned Level-2 statements (§1.2): wire `twoCoverH1LinearEquiv` +
  `subsingleton_hModule'_one_of_qcoh` (H¹ carrier), build the `H⁰`-kernel bridge
  (`linearEquiv₀` + MV degree-0 exactness — small new lemma, the kernel twin of
  `h1CokEquiv`), feed RE-0's bridge into the pair, fire RE-1/2/3, thread w4-2's CBC-1
  for the base-change clause, and export rank (via the §3.2 seam, staged) + openness.
  - *RE-4b [S→M, with w4-2 — interface item]:* chart finiteness for the constructor:
    `Γ(Vᵢᴿ, F_glued)` finite over `Γ(Vᵢᴿ, 𝒪)` by localization-local finite generation
    (trivializing pieces are `𝒪`-sections; `Module.Finite.of_localizationSpan_finite'`).
    Natural home: w4-2's constructor file; if it ships without, RE-4 carries it.
- **RE-5 [M, Opus, deps: RE-4 statement; deferrable to the datum campaign].**
  Presentation descent (§2.4): cocycle data over arbitrary `R` descend to a finitely
  generated `k`-subalgebra `R₀` (filtered-colimit bookkeeping through
  `Γ(V) ⊗_k −`; unit and cocycle equations at a finite stage); the arbitrary-`R`
  corollary of the engine via RIG's universal base change along `R₀ → R`. Consumed only
  by (V-rel-B); the chart legs never need it.

**Dependency order:** `RE-0 ∥ RE-1a → {RE-1b, RE-2, RE-3 in parallel}` — all of this
launchable NOW, in parallel with w4-2 — then `RE-4 (+RE-4b)` after w4-2, then `RE-5`
(or defer RE-5 to w4-6). The engine core never waits on the cbc lane.

**Staged fallbacks.** (i) If COH-0/RE-1b stalls: land COH-1 + VAN + RIG's base-change
clause — the datum then has `H¹ = 0` and on-the-nose `H⁰` base change, and only the
finite-projectivity of `Q` (the `ℙ(Q)`-chart finiteness) waits; that is a shippable
intermediate state. (ii) If the six-term/snake fights: COH-0 has a hands-on variant
(chase the connecting map explicitly on the two-term complexes — no homology API).
(iii) If w4-2 slips: everything except RE-4 lands anyway; RE-4's spec is frozen against
the interface below so the w4-2 prover can be handed both at once.

### 4.5 Consumption map (who cites what)

| w4-3 deliverable | Consumer |
|---|---|
| `rigidEngine` (H¹ = 0, `Q := H⁰` finite projective) | w4-6 datum: `Q` for `ℙ(Q)`/`th:LinSys` charts (V-rel-A, Kleiman tex 2343–2350); the `Z ×_P Z = ℙ(Q)` endgame (tex 2360–2365) |
| `rigidEngine_baseChange` (every ring map, on the nose) | (V-rel-B) homEquiv surjectivity at arbitrary tests (through RE-5); Speiser-descent transport of the datum |
| RIG's module-coefficient clause + duality corollary | the `eq:Q`/classifying-map bookkeeping in the `th:LinSys` step (tex 1979–1998) |
| `rigidEngine_rank` (fibre rank `deg + χ`) | `ℙ(Q)` chart dimension; consumes the landed `FLVClass.h0_eq_deg_add_chi_of_subsingleton_hModule_one` at fibres |
| `rigidEngine_isOpen_vanishing` | the datum's nested strata opens (tex 2295–2306), exhausted by the landed FLV class form |
| RE-0's `QcohOn ⟹ IsLocalizedModule` bridge | any future packaged-sheaf computation on the pinned cover (shared with the cbc lane) |
| RE-5 | (V-rel-B) only |

### 4.6 Interface freeze — what RE-4 consumes from w4-2 (addressed to the w4-2 spec)

1. The glued constructor `F` (2-chart `F_g` and/or m-chart) with instances
   `[QcohOn F V₀ᴿ]`, `[QcohOn F V₁ᴿ]` on the PINNED cover (not on the trivializing
   cover) — per w4-datum §3.2's discharge plan.
2. CBC-1 for `F`: `Γ(W, F) ⊗_R R' ≅ Γ(W_{R'}, F_{R'})` for `W ∈ {V₀ᴿ, V₁ᴿ, overlap}`,
   natural in restrictions (δ-naturality is what RE-4 uses; the "presheaf-transparency
   landmine" note from the cbc-1 report applies).
3. Chart finiteness (RE-4b) — preferred home w4-2; RE-4 carries it otherwise.
4. The fibre-sheaf comparison at `R → κ(p)` (CBC-1 at residue fields) — used with
   W6-full for the rank corollary and the `hfib` discharge; w4-3 stays in complex form
   if it slips.
5. Spelling stability: `secRes`-vocabulary (`QcohSections.lean`) for all section maps;
   `Scheme.overModule`/`Over.sectionsAlgebra` as local instances only (house rule).

### Discipline (inherited, binding)

(1) The engine core is MODULE ALGEBRA: if a proof in RE-1/2/3 mentions a scheme, it has
left the route — stop and restate (the D1 lesson). (2) The pair's carriers are named
opaque defs bridged ONCE to section modules (RE-0/RE-4); never inline the
`Submodule`-tower coercions (the FLV §5.2 hazard; `FLVVanishing.fiberLatticeH1Equiv` is
the house pattern for such carrier equivs). (3) Base change is an honest
`≃ₗ`/`Subsingleton`, never `Nonempty`; `R`-linear structure threaded through every equiv
(finrank hazard). (4) `[IsNoetherianRing R]` appears ONLY where §1.2 flags it; adding it
elsewhere to unblock a proof is a design regression — flag instead. (5) Files ≤ 500
lines; `lean_verify` (MCP) axiom checks; no new axioms; lake mutex.

---

## §5 HONEST RISKS — where this could balloon

1. **RE-1's Lean weight is the campaign risk.** The mathematics of §2.2 is elementary
   and complete (checked step-by-step this pass, including the glue-compatibility of the
   model surjection and the localization-exactness of the kernel pair), but the
   two-lattice vocabulary + snake + window bases are a real formalization surface.
   Mitigations: the internal staging (COH-1 alone unlocks RE-2 and the shippable
   fallback §4(i)); the field-level ancestors (`FinitenessP1`, the Finiteness ladder) as
   templates; the models' cohomology is explicit linear algebra. Budget: if RE-1
   exceeds two sessions, invoke fallback (i) and re-plan COH-0 as its own brick.
2. **w4-2 interface drift.** RE-4 is the only gated brick; §4.6 freezes what it needs.
   Mitigation: hand the w4-2 prover this worksheet's §4.6 with its spec; attach RE-4's
   spec to w4-2's acceptance (the FLV-2/w4-1 pattern, which worked).
3. **The `IsLocalizedModule` bridge could fight elaboration** (two module structures on
   `N` — `R[t]` and `R[s]` — plus the `Submonoid.powers` coercions). This is RE-0's
   named hazard; the recommended spelling (bare endomorphism data / `Module R[X]` via
   scalar towers, decided at spec time with a probe) is lane-owned. The axioms
   themselves are certified: (P2) ⟹ `surj`/`exists_of_eq` is a term-level match
   (`QcohSections.lean:154,161` vs mathlib `LocalizedModule/Basic.lean:547`).
4. **The `H⁰`-kernel bridge** (`HModule F 0 ≃ ker δ_F`) is believed cheap
   (`linearEquiv₀` is landed and general in `F` — exercised on `divisorSheaf` in
   FLV-4 — and MV degree-0 exactness is landed), but no kernel-form lemma exists yet;
   if the MV pieces resist assembly, it is a half-session lemma, not a wall.
5. **Rank/`hfib` discharge depends on W6-full** (w4-2/datum seam, FLV worksheet §3.2) —
   outside w4-3's control. Fully mitigated by the complex-form hypothesis (§3.2): w4-3
   lands regardless; only the datum's USE of the engine waits for the seam.
6. **The descoped II.5-full, if a future consumer demands it** (e.g. χ of a family as a
   locally constant function off the vanishing locus, or determinant-of-cohomology): the
   re-entry path is Mumford II.5.1's descending induction ON TOP of COH (which this
   campaign delivers) — an add-on M/L brick, not a redesign. Anchor debt: the Mumford AV
   II.5 pages are not yet transcribed (`references/manifest.yaml` has only pp. 54–55 =
   II.4 rigidity); if the blueprint wants the II.5 citation, queue a `page-transcriber`
   task (book pp. ≈46–53); until then anchor COH to the Hartshorne III.5 pages already
   in the manifest (the landed finiteness node's ancestor) and Kleiman `sb:Q`
   (tex 1897–1935, citing EGA III 7.7.6/7.7.9–10) for the exchange-property context.
7. **Noetherian leakage.** RE-5's descent is designed but not compile-probed; the
   filtered-colimit step is standard (`Γ(V) ⊗_k −` commutes with colimits; units and
   equations descend to finite stages) but the in-tree spelling of "cocycle datum" it
   must descend depends on w4-2's constructor and the presentation-extraction brick
   (w4-datum §5 risk 2, owned by the datum lane). If (V-rel-B)'s shape changes in the
   w4-6 design pass, RE-5 renegotiates there — it is deliberately last and deferrable.

*End of worksheet. Deliverable of record for the w4-3 design obligation (w4-datum §4.1);
binding for the RE-brick specs; §4.6 to be handed to the w4-2 spec-writer; the §1.1
scope decision and §2.4 Noetherian decision to be echoed on the roadmap's
`AJCR.w4-rep.cbc`/`.datum` subitems by the orchestrator.*
