# Wave-4 datum design pass — the twist-normalization decision (`AJCR.w4-rep.datum`)

*Read-only design pass, 2026-07-15. Settles the question the cbc-1 probe left open
(ledger `c0c29a3d61`; roadmap comments on `AJCR.w4-rep.cbc` / `AJCR.cech-port`): can the
`RepresentableBy` datum's universal twist be normalized two-cover-trivial, so the landed
`congrCoeff` transport closes the twisted vanishing — or does Wave 4 honestly need the
general twisted affine Serre vanishing, firing `AJCR.cech-port`? No Lean edited; no build
run. Sources read in full: `informal/w4-cbc-recon.md`; `Cohomology/RelativeTwoCover.lean`
+ its ledger message; design §§4.5–4.6, 5, 6.1–6.2; `informal/degree-pic0-recon.md` §3 +
`informal/deg-d2-meromorphic-worksheet.md`; landed `Picard/PointDivisor.lean`,
`Cohomology/Finiteness.lean`, `Curve/MapToP1.lean`, `Cohomology/AffineVanishing.lean`,
`Cohomology/AffineCech.lean`; Kleiman
`references/Kleiman_The_Picard_Scheme_Theorem-4.8.tex` (whole excerpt); port source
`SubProjects/Cech-Cohomology/AlgebraicJacobian/Cohomology/{AffineSerreVanishing,
CechAcyclic,QcohTildeSections,QcohRestrictBasicOpen}.lean`.*

**VERDICT IN ONE LINE.** The *twist* normalizes perfectly (fiber divisors of the landed
`π : C ⟶ ℙ¹` are two-cover-trivial by construction) — but the *class being twisted*
cannot be normalized: two-cover-triviality on the pinned cover is an invariant
obstruction, nonzero in general, and the datum's `homEquiv`-surjectivity leg computes
pushforwards of **arbitrary** functor-point classes. **Fire `AJCR.cech-port`, scoped to
exactly G-CBC-3(ii)** — a bounded in-tree re-derivation of the quasi-coherent affine
H¹-vanishing along the rebuild's own landed Serre engine, with the Čech subproject's
green `affine_serre_vanishing_general_open` as the feasibility certificate. No plan-B/C
signal; the Kleiman/Div^d route survives unchanged.

---

## §1 What Wave 4 must twist by — the datum's cohomological requirements, quantified

### 1.1 The twist in Kleiman's argument, recast

Reading the 4.8 excerpt: the **only** twist in the entire proof is the fixed one —
the automorphism `ε : L ↦ L(m)` of `Pic_{X/S}` carrying the stratum `P^φ_m` onto
`P^{φ₀}_0` (excerpt line 92: *"define an endomorphism ε of Pic_{X/S} by sending an
invertible sheaf L on an X_T to L(m). Plainly ε is an automorphism."*). `O(1)` there is
the polarization; on this tree's route the polarization **is** the landed finite map to
the line: pin

> **Θ_n := (π_R)^* O_{ℙ¹}(n)** — the divisor class of `n · (fiber of π)`,
> `π` from `exists_isFinite_toP1` (`Curve/MapToP1.lean:102`), `deg Θ_n = n · deg π`
> (finrank via `finite_app_chartOpen`, `MapToP1.lean:136` — the E-i pushforward-rank
> shape), with `n` chosen so `n · deg π` clears the h¹-vanishing threshold.

The route's shift `pic0 ≅ pic^d` (`d := n·deg π`) is Kleiman's `ε⁺` verbatim.

### 1.2 Where cohomology-after-twisting is load-bearing (the complete list)

Kleiman's proof pins exactly three cohomological duties; recast on the pinned route
(design §4.5: Div^d/Grassmannian charts over `k'`, Σ-opens + 01JJ glue, Speiser descent):

- **(V-fib) — fibrewise vanishing, field-level.** `H¹(X_t, L_t(n)) = 0` for `n ≥ m`, all
  `t` (eq. 4.8.3, excerpt lines 71–73), base-change-stable because *"cohomology commutes
  with flat base change"* (lines 82–86 — over field points this is the χ-ledger's E-iv
  world, not cbc's). Quantifier: **for the fixed twist `Θ_n`, over every field `K/k'`,
  for every degree-0 class `λ_K`: `h¹(λ_K · Θ_n) = 0`** — either for one uniform `n`
  (sharp classical bound `deg > 2g−2`), or per-class with Kleiman's increasing strata
  `P^φ_m` (lines 64–90) absorbing the non-uniformity. NOT LANDED in any form
  (grep-verified: the ledger has `riemann_inequality` = the `h¹ ≥ 0` direction only).
  This gap — call it **FLV** — exists on every branch of today's decision (it was
  cbc-recon risk 3; sharpened in §4/§5 below).

- **(V-rel-A) — relative engine on *divisor-presented* classes (scheme-building side).**
  Kleiman line 104: *"the map α : Z → P^{φ₀}_0 is defined by the invertible sheaf
  associated to the universal relative effective divisor on X_Z/Z"*, and the final step
  (`T := Z`) needs `Z ×_P Z = ℙ(Q)` for that sheaf. Curve-lite: over Div^d-type base
  rings, `Q := H⁰(C_R, O(𝒟_univ) · Θ-shifts)` must be finite locally free of rank
  `d + 1 − g` with base change on the nose (3.10 (v)⟹(i), line 100). The input sheaf
  here always comes **with local equations by construction** (the relative
  `LocalEquations`/`divisorClass` world; `Picard/LocalEquationsPullback.lean` is the
  landed pullback half).

- **(V-rel-B) — relative engine on *arbitrary* functor-point classes (homEquiv
  surjectivity).** Kleiman lines 98–102: given `T` and `λ ∈ P^{φ₀}_0(T)`, represented by
  `L'` on `X_{T'}`, the product `T' ×_P Z = ℙ(Q)` with `Q` locally free (since
  `H¹(X_t, L_t) = 0` by 4.8.3 and 3.10 (v)⟹(i)), and smoothness of `ℙ(Q)` supplies the
  étale-local section `T₁ → ℙ(Q)` — i.e. the effective divisor étale-locally
  representing `λ`. In this tree the quantifier is honest and maximal: by Layer 1
  (design §4.3), a point of `pic0` over affine `T = Spec A` is a `CechPic` class on
  `C_B` for a presented étale `A`-algebra `B` — **an arbitrary cocycle class on an
  arbitrary pointed cover of `C_B`, over an arbitrary (étale-over-affine) test ring,
  with no presentation control whatsoever.**

Nothing else in 4.8 twists: the strata definitions are (V-fib) + degAt (landed
approach, design §6.2); openness of strata is replaced by the curve degree strata; the
disjoint/increasing unions are EGA 0-gluing (01JJ side).

### 1.3 Why (V-rel-B) cannot be dodged — the steelman audit

Three attempted reorganizations, each checked and rejected:

1. *Fibrewise divisor lifting instead of ℙ(Q)-sections.* Lift a G-D2 divisor
   representative of `λ_κ(p)` from the fiber (sections of the smooth `C_R → Spec R`
   through separable points exist étale-locally). The lifted divisor's class agrees with
   `λ·Θ_n` **only on the fiber**; upgrading "agree at `p`" to "agree étale-locally near
   `p`" is exactly semicontinuity/H⁰-base-change **of the arbitrary difference class**
   — circular.
2. *Grassmannian classifying maps instead of Abel-fiber sections.* The map
   `T → J` from a class is built from the module `Q(λ)` itself (subbundle of the fixed
   `H⁰(O(A)) ⊗ R`) — the same engine on the same arbitrary class.
3. *Reduce affine tests to field tests.* Field-extension covers are cofinal only over
   `Spec K` (design §4.3 Layer 1, last bullet); a general affine test has honest étale
   covers, and `RepresentableBy` demands the equivalence at **every** `T`. The
   separatedness/injectivity half is landed lane; the surjectivity half is (V-rel-B).

**Conclusion of §1.** The datum must run its pushforward engine on the pinned relative
two-cover for sheaves in two families: (A) divisor-presented classes (with equations),
and (B) arbitrary cocycle classes. Both families, restricted to the pinned charts
`Vᵢᴿ`, are general invertible modules on affines — the vanishing instances
`Subsingleton (Sheaf.HModule' F Vᵢᴿ 1)` demanded by `twoCoverH1LinearEquiv`
(`TwoCover.lean:92`) are the general twisted affine vanishing for both.

---

## §2 The normalization candidates

### 2.1 (a) Fiber-divisor twists — YES, two-cover-trivial by construction (verified)

Reading against the landed code confirms the recon's hoped-for reading, exactly:

- `V₀, V₁ = π ⁻¹ᵁ P1.chartOpen k i` are affine and cover `C`
  (`MapToP1.lean:119,124`); the base-changed `Vᵢᴿ` retain both properties
  (`RelativeTwoCover.lean:131–140` via `AffineTwoCover.pullbackProd`).
- The overlap **is the basic open of the pulled-back chart coordinate** inside each
  chart: `V₀ ⊓ V₁ = C.basicOpen t₀` with
  `t₀ = (π.app (P1.chartOpen k 0)).hom ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord k 0 1))`
  (`Finiteness.lean:174–184`, symmetrically `:187–197` — **note: `private`**; one-line
  re-derivation from the public `Scheme.preimage_basicOpen` +
  `P1.basicOpen_awayToSection_chartCoord` + `P1.chartOpen_inf` is part of the twist
  brick, §4 w4-5). Hence `t₀` restricts to a **unit** on the overlap, and
  `g_n := (t₀|_{V₀⊓V₁})^n` is a two-cover unit cocycle.
- `Θ_n = F_{g_n}` in the design-§6.1 equalizer presentation: trivial on each `Vᵢᴿ` **by
  construction**, so its vanishing instances transport by the landed
  `HModule'.congrCoeff`-style mechanism once the sheaf is built, and its sections
  base-change by `sectionsBaseChange` on each trivializing piece. This is the cheap
  probe route G-CBC-3(i)/G-CBC-4 firing on the nose — for the twist.
- Degree bookkeeping: the fiber over `∞ = V(X₀)` is a `LocalEquations` datum **on the
  pinned cover itself** (equation `t₁` on `V₁ ⊇ π⁻¹(∞)`, equation `1` on `V₀`), so
  `Θ_1 = divisorClass` of the fiber divisor, and `deg Θ_1 = deg π` by the E-i
  finrank shape (`finite_app_chartOpen`). All bounded, S-sized.

Contrast: the **point twist `d·P`** is *not* two-cover-trivial in general — the ideal of
`P` in the Dedekind chart ring `Γ(V₀)` can be non-principal, i.e. `pointDivisor`'s class
(`PointDivisor.lean:167,279`) restricts nontrivially to a pinned chart. **Pin the fiber
twist, not the point twist, as the datum's `Θ`.** (The rational point `P` is still needed
for rigidification/`abelElement` — a different role.)

### 2.2 (b) Classes presented with a two-cover trivialization — a proper subgroup; no normalization exists

Two-cover-triviality of a class `λ` on the pinned cover is equivalent to the vanishing
of its restriction images in `Pic(V₀ᴿ) × Pic(V₁ᴿ)`. That image is:

- **an invariant of the class** — unchanged by choice of cocycle representative, by
  refinement, and by multiplication with any two-cover-trivial class (in particular by
  any `Θ_n`-twist, and by the `H_R`-coset noise: classes pulled back from `Spec R`
  restrict to pullback classes on each chart, but do not cancel a given chart class);
- **nonzero in general** — `Pic` of an affine Dedekind chart is a nontrivial class
  group for `g ≥ 1` (design §6.1's audited *rejected pin* and its counterexample;
  recon lesson 1), and over a general test ring `R` the chart `Pic(Γ(Vᵢ) ⊗ₖ R)` is
  wilder still. Restriction `Pic(C_K) → Pic(V₀ᴷ)` is onto (extend divisors), so
  functor points realizing the obstruction exist.

So "normalize the universal class to be two-cover-trivial on the **pinned** cover" is
**mathematically impossible** — not a formalization gap, an invariant obstruction. This
kills the GREEN branch's blanket hope recorded in the probe verdict. Also note: route
item 8's old wording ("modeled by transition data on the pinned 2-cover after
affine-local refinement of `T`") is the same false pin — affine-locality in the *test*
direction does not trivialize chart class groups in the *curve* direction; the landed
Wave-3 `CechPic` (arbitrary pointed covers, refinement colimit) is the honest model and
already reflects this.

### 2.3 (c) Reduction via the degree lane's meromorphic bridge — real, but field-level only

Over a field `K` the moving lemma is available and gives something genuinely useful,
worth recording precisely (it is *not* in the worksheets yet):

> **Adapted-cover trivialization (field-level).** For integral `C_K` and any class
> `λ`, G-D2(S) gives `λ = divisorClass K D`, `S := supp D`. The semilocalization of the
> Dedekind charts at the finite set `S` is a PID, so approximation yields
> `f ∈ K(C)ˣ` with `ord_x f = D_x` for all `x ∈ S`; then `div f = D + E` with
> `supp E ∩ S = ∅`. The affine two-cover `U₀ := C ∖ S` (equation `1`),
> `U₁ := C ∖ supp E` (equation `f`) trivializes `𝒪(D)`: the ratio `f` is a unit
> section on `U₀ ⊓ U₁` (no zeros or poles there — the landed `ordZ` bookkeeping,
> W2-style).

So **every** field-level class is `F_g`-presented on a *class-adapted* affine two-cover
— "moving the divisor off the relevant locus" works, at field level, and the two-cover
carrier (which takes any two-chart affine cover) fires there. Costs and limits:

- New geometric brick hiding inside: *the complement of a finite nonempty set of closed
  points of the curve is affine* — not landed (`pointDivisor` uses `{x}ᶜ` as an open,
  never as an affine). Real but classical (or route around: adapted covers via
  preimages of ℙ¹-charts of a second map miss prescribed points — still new work).
- Even for adapted `F_g`, the probe showed the vanishing does **not** transport with
  the landed lemmas: `congrCoeff` is global-iso transport
  (`RelativeTwoCover.lean:87–102`), while `F_g|Vᵢ ≅ 𝒪|Vᵢ` is a *local* trivialization,
  and "`HModule' F U n` depends only on `F|U`" (slice-site/open-restriction
  Ext-invariance) is absent (module docstring `RelativeTwoCover.lean:35–46`).
- Decisive: the argument is function-field arithmetic — **it does not exist over a
  general test ring**, and "adapted at a fiber ⟹ adapted nearby" is again an
  H⁰-base-change statement (§1.3.1). So (c) can anchor **(V-fib)** and field fibers,
  never **(V-rel-B)**.

### 2.4 Sum

| Requirement | Normalizable? | Mechanism |
|---|---|---|
| the twist `Θ_n` | **yes** | fiber divisor = `F_{t₀ⁿ}` on the pinned cover, by construction (§2.1) |
| (V-fib), field fibers | yes (two routes) | χ-ledger + G-D2 divisor sheaves; or adapted covers (§2.3) |
| (V-rel-A), divisor-presented | partially | equations exist, but on divisor-adapted covers, not the pinned one; chart restrictions still nontrivial in general |
| (V-rel-B), arbitrary classes | **no** | invariant obstruction (§2.2); every dodge is circular (§1.3) |

---

## §3 THE DECISION

**The datum cannot be built entirely with two-cover-trivial twists. Fire
`AJCR.cech-port`, for exactly G-CBC-3(ii)** — the gap the probe named, now confirmed
load-bearing by the datum-design analysis above. The trigger condition recorded in the
roadmap comment on `AJCR.cech-port` ("only if the w4-rep.datum design pass cannot
normalize the universal twist to two-cover-trivial") is hereby met: the twist
normalizes, the universal class does not, and the class is what the engine eats.

### 3.1 Port scope (binding for the port brick's spec)

- **Target statement (in-tree shape).** For the rebuild's carrier
  `F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)`:

  ```
  theorem IsAffineOpen.subsingleton_hModule'_one_of_qcoh
      (hU : IsAffineOpen U) (F : …) [/- qcoh packaging on F, §3.2 -/] :
      Subsingleton (Sheaf.HModule' F U 1)
  ```

  Degree 1 only, small Zariski site only, `HModule'` only — **not** the higher-direct-
  image comparison, **not** `R^i f_*`, per the keystone-funnel rule.

- **Source of truth (known-green, read this session).**
  `SubProjects/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean:883`
  — `affine_serre_vanishing_general_open`: for quasi-coherent `F : (Spec R).Modules`
  and any affine open `V`, `Ext^p(jShriekOU V, F) = 0` for `p > 0` (Stacks 02KG,
  generalized to arbitrary affine opens). Its mathematical seed is
  `CechAcyclic.lean:1970` (`sectionCech_homology_exact_of_localizationAway`) and
  `:2070` (`…_of_affineOpen`), with quasi-coherence packaged via
  `QcohTildeSections.lean:66` (`qcoh_iso_tilde_sections`) and
  `QcohRestrictBasicOpen.lean`.

- **Adaptation (the actual work — this is a port of a *statement*, not of code).** The
  subproject lives in a different carrier (`SheafOfModules`, `jShriekOU`,
  `BasisCovSystem`, `EnoughInjectives`, tilde functor); transplanting that stack would
  be the "full engine" the charter and the roadmap comment both forbid. The bounded
  route is to **generalize the rebuild's own landed Serre engine**, whose
  structure-sheaf hardwiring is precisely located:
  1. `Cohomology/AffineCech.lean` — `exists_cech_cobounding` (`:150`; partition-of-unity
     cobounding) with its two helpers `exists_res_eq_pow_mul` (`:100`) and
     `exists_pow_mul_eq_zero_of_res_eq_zero` (`:121`), which are exactly the
     `IsLocalization.Away` property of `𝒪`-sections on basic opens. Generalize the
     cocycle values from `Γ(𝒪)` to `F`-sections: the helpers become the **axioms of the
     packaging** (§3.2), and the partition-of-unity assembly is verbatim once
     `𝒪`-sections can multiply `F`-sections.
  2. `Cohomology/AffineVanishing.lean` — `cokernel_app_surjective` (`:180`): steps
     (a)–(e),(g) are already sheaf-agnostic (the mono `ι`, local lifts, finite basic
     subcover, gluing); the `moduleKSheaf`-specific stones are the value sheaf of the
     defect cocycle `a i j` (step (d)–(f)) and the `secRes_moduleKSheaf` cosmetics.
     Restate with `ι : F ⟶ G` and `a i j` valued in `F`.
  3. `subsingleton_moduleKSheaf_hModule'_one` (`:310`) — the 3-term-Ext argument via
     `Injective.ι` and `freeModuleSheafHomEquiv` is textually reusable for `F`.

  The subproject's green top certifies the mathematics; the rebuild's own engine bounds
  the Lean shape. Estimated M→L (one campaign brick, worksheet optional).

### 3.2 The quasi-coherence packaging (the [NEW-MATH] residue, pinned here)

`Sheaf (ModuleCat k)` carries no `𝒪`-action, so the port statement needs a packaging;
pin it as a structure/class `QcohOn F U` (name lane-owned) providing:

- **(P1) action:** an `𝒪(W)`-module action on `F(W)` for `W ≤ U`, natural under
  restriction (an "`𝒪`-module data" mixin — sections-level, no monoidal sheaf
  categories, per route rule 5);
- **(P2) localization:** for affine `U' ≤ U` and `g ∈ Γ(X, U')`, the two helper
  properties of `AffineCech.lean` for `F`-sections over `U' ⊓ D(g)` (denominator
  clearing and defect annihilation — the two-lemma form of
  `IsLocalization.Away`).

Dischargeability for the datum's two sheaf families — **by construction**:

- *Cocycle-glued sheaves* (finite affine trivializing cover + unit cocycle; the
  `twistSheaf` equalizer generalized from 2 to m charts): (P1) componentwise, (P2)
  because kernels of maps between localizing section modules localize (flatness of
  `Away`-localization). This covers `Θ_n`, family (A)'s equation-presented classes,
  and family (B) **after** the presentation-extraction step (§5 risk 2).
- *Field-level `divisorSheaf`* (`RiemannRoch/DivisorSheaf.lean`): sections are
  `K(X)`-submodules with literal multiplication; (P2) is `ord` bookkeeping. Needed for
  the fibrewise anchor (§4, FLV).

### 3.3 What the cbc-lite statements now say (revision of recon §0.2)

CBC-0/1/2/3 keep their shapes with the hypothesis "`F_g` presented on the pinned
two-cover" **replaced by** "`[QcohOn F Vᵢᴿ]` (i = 0,1)": the carrier fires from the
ported vanishing; CBC-1's term base change follows from (P2) + `sectionsBaseChange`
(for a quasi-coherent presentation, `Γ(Vᵢᴿ, F) ⊗_R R' ≅ Γ(Vᵢ^{R'}, F_{R'})` is module
bookkeeping over the affine charts once pullback is defined at presentation level —
`CechPic.map` is landed); CBC-3 unchanged (its `H¹ = 0` hypothesis supplied by
FLV + CBC-2). G-CBC-3(i) — the local-restriction Ext-transport — is **retired**: the
ported general vanishing subsumes the `F_g` case, so no slice-site comparison lemma is
needed on the critical path.

---

## §4 Consequences — the revised Wave-4 sequence

### 4.1 Bricks, in order (engine lane first; sizes per recon convention)

- **w4-0 (LANDED).** cbc-1 probe: relative scaffold + CBC-0 for `𝒪` + `congrCoeff`
  (`Cohomology/RelativeTwoCover.lean`, `c0c29a3d61`).
- **w4-5 [S, delegable NOW, independent] — the pinned twist.** Re-expose
  overlap-=-basicOpen publicly; `fiberTwist n` as the `F_{t₀ⁿ}` class; `= divisorClass`
  of `n·(fiber over ∞)` (LocalEquations on the pinned cover); `deg = n · deg π` (E-i
  shape); two-cover triviality lemma. Numbered out of order deliberately: it is the one
  brick with zero dependencies. (Ordering vs. G-D3: the *degree* of the twist can land
  as a raw finrank statement first and be wired to `classDeg` when W5 lands.)
- **w4-1 [M→L, the fired port — G-CBC-3(ii)']** `Cohomology/QcohSections.lean`
  (packaging (P1)/(P2) + the cocycle-glued constructor + discharge lemmas) and
  `Cohomology/AffineVanishingQcoh.lean` (cobounding, `cokernel_app_surjective`,
  `subsingleton_hModule'_one_of_qcoh` — per §3.1). Fable-grade heart (the cobounding
  generalization), Opus assembly. Update roadmap: `AJCR.cech-port` → in-progress with
  this scope; it is *the* Wave-4 keystone risk retirement.
- **w4-2 [M, delegable after w4-1] — cbc-lite completion (G-CBC-4/5).** Section base
  change for packaged `F`; CBC-1/2 assembly including the deprioritized 𝒪-bundle
  leftovers from the probe's follow-up list.
- **w4-3 [L, Fable, after w4-2] — G-CBC-6, the rigid engine.** Mumford AV II.5
  two-term finite projective replacement over arbitrary `R`: fibrewise `h¹ = 0` ⟹
  `H⁰` finite projective of rank `χ = d + 1 − g`, base change on the nose. The
  non-Noetherian packaging risk (recon risk 4) lives here and is now on the critical
  path — spec must budget it.
- **w4-4 [M→L, WORKSHEET-FIRST, parallel to w4-2/3] — FLV, the fibrewise vanishing.**
  `h¹(λ_K · Θ_n) = 0` at field fibers. Route choice deliberately deferred to its
  worksheet; the candidates, with the default pinned: **(default) Kleiman's strata
  trick** — per-class `m` with `P^φ_m`-style increasing opens (excerpt lines 64–90),
  which needs only *per-class eventual vanishing* (monotone `h¹` under adding points —
  the ChiSlice six-term + skyscraper `h¹ = 0` gives the surjection
  `H¹(D) ↠ H¹(D + x)` — plus χ-growth), and recovers `QuasiCompact J.hom` a posteriori
  from qc of the Abel source (image of a qc scheme); **(sharp)** uniform `deg > 2g−2`
  needs Serre duality — a mountain, off-route; **(crude-uniform)** Riemann's `n₀(C)`
  via the two-lattice — possible but unproven here. FLV also fixes how the engine's
  fibre cohomology meets the χ-ledger: through `divisorSheaf` of a G-D2 witness — see
  gating below.
- **w4-6+ [campaign, own design pass] — the datum proper.** Div^d via the Grassmannian
  embedding into the fixed `H⁰(O(A)) ⊗ R` (h⁰-bounds of Wave 2b), the relative
  divisorClass/Abel map, ℙ(Q)-charts + étale-local sections, Σ-opens + 01JJ glue over
  `k'`, Speiser descent, lft/qc certificates, `jacobianData` assembly. Scoped only by
  §1's requirement map here; it gets its own pass once w4-1..w4-5 and the degree-lane
  gates (below) are green.

### 4.2 Degree-lane gating (precise, per the mission's question)

- **The engine bricks w4-1, w4-2, w4-3, w4-5 gate on NOTHING in the degree lane** —
  launchable now, in parallel with the G-D2 campaign (W1–W4) already queued.
- **w4-4 (FLV)** consumes the χ-ledger (landed) + **G-D2(S)/(X)** (to range over all
  field-level classes as divisor classes) + **a sharpened form of the parked
  G-D2(i)**: the worksheet's decision T1 parked "divisorSheaf K D *is* the sheaf of
  class divisorClass K D" as consumed-nowhere — **the datum resurrects it**: the
  fibrewise anchor must identify the engine's fibre cohomology (cocycle-glued sheaf of
  `λ_K`) with the ledger's `h⁰/h¹` (of `divisorSheaf` of a witness), and
  `chi_congr`/`congrCoeff` transport along exactly such a sheaf iso. **Flag to the
  G-D2 owner: schedule (i) as a real sub-brick (W6), not an optional node.**
- **w4-6+ (the datum assembly) gates on the full chain to `pic0Functor`**: G-D2
  (W1–W4) → G-D3 (=W5) → G-D5 → G-D6 (degAt) → **G-D7 (pic0Functor)** — the functor in
  `JacobianData.rep`'s type (design §5) must exist before the datum can even be
  *stated*. It does **NOT** gate on deg-D4b (graph/diagonal — that feeds
  `abelElement`/G-D8, consumed by the frozen `ofCurve`/`comp_ofCurve` targets, not by
  `jacobianData`), and not on G-D8.
- Sequencing consequence: the two lanes stay parallel — degree lane: W1→W4, W5, (new)
  W6, G-D5/G-D6/G-D7; Wave-4 engine lane: w4-5, w4-1, w4-2/w4-4, w4-3 — converging at
  the w4-6 design pass.

---

## §5 Honest risks — what this pass could not settle by reading

1. **FLV's route is the remaining mathematical open.** No large-degree `h¹`-vanishing
   exists in-tree in any form; the sharp bound needs duality (off-route); the strata
   default avoids new uniformity mathematics but complicates the datum's gluing
   bookkeeping (increasing unions of opens) and moves `QuasiCompact J.hom` to an
   image-of-qc argument whose scheme-level form I did not verify. This is the one place
   the datum could still balloon; its worksheet must come before the w4-6 pass.
2. **Presentation extraction for family (B).** The engine consumes classes presented on
   a *finite affine* trivializing cover; landed `CechPic` classes live on arbitrary
   pointed covers. Refinement-to-affine + quasi-compactness makes finite presentations
   plausible-by-construction, and the `CoherentWitness*` machinery is adjacent prior
   art — but I did not verify a landed "finite affine presentation extraction" lemma.
   If absent it is a bounded [PLUMB/M] brick inside w4-1's constructor file, not a
   wall.
3. **The packaging (P1) could fight the carrier.** Threading a sections-level
   `𝒪`-action through `Sheaf (ModuleCat k)` without monoidal sheaf categories is
   designed above to be a mixin on concrete constructors; if elaboration friction
   proves heavy, the fallback is to state the ported vanishing *only for the
   cocycle-glued constructor* (narrower, still sufficient for the datum by risk-2's
   extraction). Decide inside w4-1's session, not by escalation.
4. **Mumford replacement over non-Noetherian `R`** (recon risk 4, unchanged, now
   critical-path in w4-3): the finite-projective packaging
   (`Module.FinitePresentation`/`Flat`+`Finite` gifts) is plausible but unverified.
5. **Smooth ⟹ étale-local sections (EGA IV 17.16.3(ii))** — needed by w4-6's chart
   step (and by any fibrewise-lifting variant); mathlib availability unverified this
   pass. Budget a recon question in the w4-6 design pass.
6. **The adapted-cover observation (§2.3) is recorded, not consumed.** If G-D2(i)/W6
   stalls, the fibrewise anchor has this alternative (cost: the "finite complement is
   affine" brick + per-class covers); it is strictly field-level and changes nothing
   about the port decision.

*End of design pass. Deliverable of record for the `AJCR.w4-rep.datum` design
obligation; the port trigger condition of `AJCR.cech-port` C-0001 is met and the port
is scoped in §3.1–3.2.*
