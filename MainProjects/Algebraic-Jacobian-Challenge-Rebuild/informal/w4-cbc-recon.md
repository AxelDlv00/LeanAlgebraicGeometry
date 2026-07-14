# Wave-4 early-warning recon — cohomology-and-base-change-lite (`AJCR.w4-rep.cbc`)

*Read-only reconnaissance, 2026-07-14. Recon agent for the first probe of the representability
wall `AJCR.w4-rep` (the rebuild's one open risk). No Lean edited; `lake`/LSP not run (a prover
holds the build lock). Scope: size the `cbc-lite` brick — the curve-specialized
cohomology-and-base-change statements every Wave-4 route needs — so the orchestrator learns
cheaply whether the pushforward engine is tractable in this tree. Binding design:
`wave3-picard-design.md` §4.5/§4.6, §5, §6.2–6.3; roadmap `AJCR.w4-rep{,.cbc,.datum}`,
`AJCR.cech-port`; Kleiman `references/Kleiman_The_Picard_Scheme_Theorem-4.8.tex` (Thm 4.8 proof,
read in full). Every landed signature below is cited `file:line` or `file` from the rebuild tree.*

---

## Roadmap summary fields (verbatim, for the record)

- **`AJCR.w4-rep`** — *"J := the scheme representing Pic^0, by the curve-specialised Kleiman
  route pinned in informal/route-decision.md — no Quot schemes, no FGA generality: totalize over
  a fixed large-degree twist using the h^0 bounds of Wave 2b, with a pinned RepresentableBy datum
  for the H_T-coset relative functor (wave3-picard-design sections 7-8)."* Status `pending`,
  parent `AJCR.jacobian`.
- **`AJCR.w4-rep.cbc`** (this brick) — *"The relative two-cover Cech carrier over an affine test
  ring: formation of H^0/H^1 of a line bundle on C x Spec R commutes with base change in the range
  the datum needs. The second and last planned extension of the rebuild's Cech lane — relative in
  the test ring, still no higher direct images."* Status `pending`, parent `AJCR.w4-rep`.
- **`AJCR.w4-rep.datum`** — *"Assemble the representing scheme from the large-degree twist charts
  and glue; produce RepresentableBy picEt and pin the universal object."* Status `pending`,
  parent `AJCR.w4-rep`.
- **`AJCR.cech-port`** (blocked contingency) — *"NOT on the critical path, by the route decision.
  The rebuild's Cech cohomology is deliberately curve-level (two-cover carrier; extended to line
  bundles in Wave 2b and made relative-lite in Wave 4). The full higher-direct-image comparison
  engine exists green and sorry-free in the standalone Cech-Cohomology project (merged into the
  old AJC) and would be PORTED, not rebuilt, only if Wave 4's base-change-lite turns out too weak.
  Blocked-on: a concrete Wave-4 gap naming it."* Status `blocked`, priority `low`.

---

## §0. What cbc-lite must state, precisely, in this tree's types

### 0.1 Why Wave 4 needs it — the exact obligation it serves

Wave 4's deliverable is the pinned `RepresentableBy` datum `jacobianData C` (design §4.5, §5).
The route (design §4.5, roadmap `w4-rep`) produces it by the **curve-specialized Kleiman 4.8
skeleton**: representability of the degree-0 functor over a finite separable `k'` via the
**Div^g / Grassmannian chart**, then Speiser/Galois descent of the scheme and the datum.
Reading Kleiman 4.8's proof (the excerpt, read in full) pins the two — and only two — places
cohomology-and-base-change is load-bearing in that skeleton:

1. **Strata are cut out by fibrewise cohomology conditions "for all `t ∈ T`" that must be
   base-change stable.** The subsheaf `P^φ` is `{L on X_T | χ(X_t, L_t^{-1}(n)) = φ(n) ∀t}`
   (eq. 4.8.1), and `P^φ_m` adds `H^i(X_t, L_t(n)) = 0, i≥1, n≥m, ∀t` (eq. 4.8.3). Kleiman:
   *"this presheaf is well defined, because [the condition] remains valid after any base change
   `p : T' → T` … because cohomology commutes with flat base change"* (eq. 4.8.1/4.8.3 wellded).
2. **The chart itself is `ℙ(Q)`, `Q := f_{T'*}L'` locally free.** At the crux step Kleiman writes
   *"`m=0`, so `H¹(X_t, L_t) = 0` for all `t ∈ T'` owing to (4.8.3). Since (v) implies (i) in
   Subsection 3.10 therefore `Q` is locally free. Hence `ℙ(Q)` is smooth over `T'`"* — the
   locally-free pushforward gives the étale-local section `T_1 → ℙ(Q)`, i.e. the chart.

cbc-lite is the **curve-lite** form of *both*: replace the general `R^i f_*` / Serre / EGA III.7
machinery Kleiman invokes by the **explicit two-term Čech complex on `C`'s landed affine
two-cover**, base-changed into the test ring. `Pic⁰`-as-degree-kernel (design §6.2) also needs a
cohomology-base-change fact, but that one is **field-level** (χ invariance under `K ↪ K′`,
interface E-iv, design §6.1) and is already the χ-ledger's job — *not* cbc-lite's.

### 0.2 The minimal honest statements (pin these; this tree's types)

Fix the frozen curve bundle `C : Over (Spec (.of k))` with the standing instances, and let its
landed affine two-cover be `V₀, V₁ : C.left.Opens` with `IsAffineOpen Vᵢ`, `V₀ ⊔ V₁ = ⊤`
(the `π⁻¹ᵁ D₊(Xᵢ)` cover of `Cohomology/Finiteness.lean`, itself from `Curve/MapToP1`). Let
`R` be a commutative `k`-algebra (the **affine test ring**), `C_R := (C ⊗ overSpec k R).left`
the base change over `Spec R`, and `V₀ᴿ, V₁ᴿ` the preimages of `V₀, V₁` under the projection
`C_R ⟶ C.left` (affine, since `Vᵢ ×_k Spec R = Spec(Γ(Vᵢ) ⊗ₖ R)`; still covering). Let
`L` be a **line bundle on `C_R`**, presented as a `Sheaf (Opens.grothendieckTopology C_R) (ModuleCat.{u} R)`
(see 0.3 on the carrier). Let `R → R'` be a `k`-algebra map (base change of the test ring).
The four statements, in the general-coefficients form the landed carrier already supports:

- **CBC-0 (relative carrier).** The degree-one cohomology of `L` over `Spec R` is the cokernel of
  the two-cover difference map on `R`-module sections:
  `Sheaf.HModule L 1 ≃ₗ[R] Γ(C_R, V₀ᴿ⊓V₁ᴿ; L) ⧸ range δ_L`, `δ_L (s₀,s₁) = s₀|∩ − s₁|∩`; and
  `Sheaf.HModule L 0 ≃ₗ[R] ker δ_L`. This is `Scheme.twoCoverH1LinearEquiv` (`TwoCover.lean:92`)
  instantiated at `k := R`, `X := C_R`, `F := L`, **once the two affine-vanishing instances
  `Subsingleton (Sheaf.HModule' L Vᵢᴿ 1)` are discharged** (the crux — see §2, G-CBC-3).

- **CBC-1 (base change of the complex).** Each term commutes with base change:
  `Γ(C_R, W; L) ⊗_R R' ≅ Γ(C_{R'}, W_{R'}; L_{R'})` for `W ∈ {V₀ᴿ, V₁ᴿ, V₀ᴿ⊓V₁ᴿ}`, naturally in
  the restriction maps, so `δ_L ⊗_R R' = δ_{L_{R'}}`. Hence the whole two-term complex base-changes:
  `K(L) ⊗_R R' ≅ K(L_{R'})`. For `L = 𝒪` this **is** `Over.sectionsBaseChange`
  (`SectionsBaseChange.lean`); the line-bundle case is the generalization (§2, G-CBC-4).

- **CBC-2 (H⁰/H¹ base change).** The induced comparison maps
  `Sheaf.HModule L i ⊗_R R' → Sheaf.HModule L_{R'} i` (`i = 0,1`), got by right-exactness of `⊗`
  on `coker` and by naturality on `ker`. They are **isomorphisms in the range the datum needs**:
  for `i = 0` when `R → R'` is flat, and unconditionally when `H¹(C_R, L) = 0` (the large-twist
  range). This is the curve-lite reading of Kleiman's *"cohomology commutes with flat base
  change"* (eq. 4.8.1/4.8.3).

- **CBC-3 (locally-free / rank, the chart datum).** `H¹(C_R, L) = 0 ⟹ H⁰(C_R, L)` is a
  **finite projective (locally free) `R`-module of rank `χ = deg L − g + 1`**, and its formation
  commutes with arbitrary base change `R → R'` on the nose:
  `H⁰(C_R, L) ⊗_R R' ≅ H⁰(C_{R'}, L_{R'})`. This is exactly Kleiman's `Q` (3.10 (v)⟹(i),
  line 100 of the excerpt) — the `O_{T'}`-module whose `ℙ(Q)` is the Grassmannian/projective
  chart the datum brick glues. The rank value `deg L − g + 1` is the Wave-2b `h⁰` bound
  (`riemann_inequality` with equality once `h¹ = 0`).

**"The range the datum needs" = CBC-3's hypothesis `H¹(C_R, L) = 0`**, supplied fibrewise by the
field-level "`h¹(L_t) = 0` for `deg L_t > 2g−2`" (a Wave-2b/χ-ledger or datum-brick input, §5)
plus CBC-2's H¹-base-change. Nothing above uses `R^i f_*` for `i ≥ 1`, no derived pushforward, no
Hilbert polynomial — the two-term complex is the whole engine. That is the "lite" in cbc-lite.

### 0.3 The line-bundle carrier — the pin that decides the brick

`twoCoverH1LinearEquiv` takes **any** `F : Sheaf … (ModuleCat R)` with the two affine-vanishing
instances; the carrier is already general (design §6.1's plan). The load-bearing choice is *how
`L` is presented*, because that decides whether the two affine-vanishing instances are cheap:

- **(i) Presented twisted sheaf `F_g`** (design §6.1): for a two-cover unit cocycle
  `g ∈ Γ(V₀ᴿ⊓V₁ᴿ; 𝒪)ˣ`, `F_g(W) := {(s₀,s₁) ∈ 𝒪(W⊓V₀ᴿ) × 𝒪(W⊓V₁ᴿ) | s₀ = g·s₁ on W⊓V₀ᴿ⊓V₁ᴿ}`.
  Then `F_g|Vᵢᴿ ≅ 𝒪|Vᵢᴿ` **by construction**, so `Subsingleton (HModule' F_g Vᵢᴿ 1)`
  **transports** from the landed structure-sheaf vanishing, and each `Γ(Vᵢᴿ; F_g) ≅ Γ(Vᵢᴿ; 𝒪)`
  base-changes by `sectionsBaseChange`. *Cheap, but only reaches bundles trivial on the pinned
  two-cover.*
- **(ii) General invertible sheaf of `R`-modules.** Reaches all line bundles (incl. those
  nontrivial on `Vᵢᴿ` — recall Pic of a Dedekind chart ≠ 0), but the two affine-vanishing
  instances become the **general quasi-coherent affine Serre vanishing**, which is *not* landed in
  the rebuild (landed vanishing is structure-sheaf-only, §1).

The datum's large-degree twist of the *universal* degree-0 class over `C_R` **need not be trivial
on the pinned two-cover**, so (i) is a probe of the machinery, not necessarily the final engine;
(ii) is the honest requirement. **Which of (i)/(ii) the datum actually needs, and whether (ii) is
bounded in-tree or forces the port, is the early-warning question (§3).**

---

## §1. Landed inventory usable for cbc-lite

### 1.1 Rebuild — LANDED, directly reusable (kernel-green, axiom-clean)

| Decl | File | What it gives cbc-lite |
|---|---|---|
| `Scheme.twoCoverH1LinearEquiv` | `Cohomology/TwoCover.lean:92` | **The carrier.** `HModule F 1 ≃ₗ[R] F(V₀⊓V₁) ⧸ range(moduleDiff)` for **any** sheaf `F` of `R`-modules with the two vanishing instances. Stated over `[CommRing k]` — so **relative-ready**: instantiate `k := R`. General coefficients = exactly design §6.1's plan. |
| `TwoCover.{diff,H1Cok,delta,h1CokEquiv,…}` | `Cohomology/TwoCover.lean` | The explicit two-term complex `Γ(V₀)×Γ(V₁) → Γ(V₀⊓V₁)`, its cokernel carrier, the connecting map, and the `≃ₗ` bridge — all as plain quotients of section modules (`finrank`/base-change friendly). Structure-sheaf `delta`/`h1CokEquiv` shown; the `LinearEquiv` shape reused verbatim for `L`. |
| `IsAffineOpen.subsingleton_moduleKSheaf_hModule'_one` | `Cohomology/AffineVanishing.lean:310` | Affine H¹-vanishing — **structure sheaf only**. Its engine `cokernel_app_surjective` (`:180`) + `exists_cech_cobounding` (Serre's argument) is **sheaf-agnostic in spirit** — the generalization to `L` reuses it (§2, G-CBC-3). |
| `Over.sectionsBaseChange` / `…Iso` / `_tmul` / `_naturality` | `Cohomology/SectionsBaseChange.lean` | **H⁰ base change for 𝒪, relative:** `Γ(C.left,V) ⊗_k A ≅ Γ((C⊗Spec A).left, V_A)`, any `k`-algebra `A`, qcqs `V`, natural in restriction. This **is** CBC-1 for `L = 𝒪`. Built on mathlib `pushoutSection` (`isIso_pushoutSection_of_isQuasiSeparated_of_flat_right`), flat-over-field free. |
| `Over.{isPushout_sections, isPushout_algebraMap_sections, resAlgHom, sectionsAlgebra, isPullback_left, overSpec}` | `Cohomology/SectionsBaseChange.lean` | The Over↔pullback bridge, the master pushout squares, `Spec A` as `overSpec k A` with `Flat (overSpec k A).hom` — the entire **relative scaffold** cbc-lite plugs into. |
| `Over.universalSections{,Equiv,_self}`, `isIso_appTop_snd_overSpec` | `Picard/UniversalSections.lean` | `Γ(C_A) = A` (H⁰(𝒪) = A) for every `k`-algebra `A`; `Over.isIso_appLE_snd` generalizes it to any affine `V ⊆ T.left`. The H⁰(𝒪)=base-ring anchor. |
| `Sheaf.HModule` / `HModule'` / `linearEquiv₀` / `moduleKSheaf` | `Cohomology/{ModuleKSheaf,OverOpen}.lean` (`HModule'` at `OverOpen.lean:269`) | The `Ext`-based cohomology carrier over any site/coefficient ring (`HModule' F U n = Ext^n(R[U],F)`), the Mayer–Vietoris substrate, `HModule F 0 ≃ₗ F(⊤)`. General in `F` — the twist/line-bundle instance is a lawful input. |
| χ-ledger: `chi_divisorSheaf`, `deg_divOf`, `chi_structureSheaf = 1 − genus`, `riemann_inequality`, `h0_nsmul_point_unbounded`, finiteness instances | `RiemannRoch/Chi{,Ledger,Finiteness,Curve,Slice}.lean` | **h⁰/h¹/χ, RR-lite, finiteness dévissage — FIELD-LEVEL** (over `K`; grep-confirmed no `overSpec`/`⊗[k]`/base-change in these files). Gives the fibrewise `h⁰ = deg − g + 1` bound (`riemann_inequality`, equality when `h¹ = 0`) that CBC-3's rank uses, and E-iv's field-extension χ-invariance. **Does not give relative-over-`R` cohomology** — that is the cbc-lite gap. |
| `Cohomology/Finiteness.lean` | — | The affine two-cover `Vᵢ = π⁻¹ᵁ D₊(Xᵢ)` of `C` (`isAffineOpen_preimage_chartOpen`, `preimage_chartOpen_sup`) and field-level `Module.Finite k H¹(C,𝒪)`. The cover cbc-lite base-changes. |

**Net (rebuild):** the *carrier* (general-coefficient two-cover `≃ₗ`), the *relative scaffold*
(`overSpec`, pullback bridge, pushout squares), and *H⁰ base change for `𝒪`*
(`sectionsBaseChange`) are all landed. What is missing is precisely the **line-bundle** upgrade of
two of them (affine vanishing, section base change) plus the **relative assembly** and the
**rank/locally-free** conclusion (§2).

### 1.2 Old-draft LESSONS (READ-ONLY prior art — `MainProjects/Algebraic-Jacobian-Challenge`)

What their *existence* proves about feasibility, and what route each needed:

- **`Picard/FlatteningStratification.lean`** (~1446 lines, Merten, **sorry-free**, axiom-clean).
  Nitsure §4 flattening stratification (Stacks 051R generic freeness + the flat-locus strata):
  turns absolute-Quot representability on a projective `π : X → S` with coherent input into finite
  locally-closed strata over which `𝓕` becomes flat. **Route:** the FGA/Quot machinery. **Lesson:**
  Nitsure flattening *is* formalizable to sorry-free — but it is the **heavy off-route** engine
  (route rule 5; Quot lane ~12k lines, explicitly rejected). Relevant to cbc-lite only as the thing
  the two-cover route exists to *avoid*.
- **`Picard/GradedHilbertSerre.lean`** (~1287 lines, Merten, sorry-free). Hilbert–Serre rationality
  (Stacks 00K1): the Hilbert-polynomial machinery. **Route:** degree via Hilbert polynomials.
  **Lesson:** landed, but **off-route** (recon lesson 6: degree via pushforward rank, *never*
  Hilbert polynomials). cbc-lite's rank is `χ = deg − g + 1` from the χ-ledger, not a Hilbert poly.
- **`Picard/IdentityComponent.lean`** (~1533 lines). §1 group-scheme identity-component substrate
  **sorry-free and reusable** (Wave-5 lesson, design §6.3); but **`PicScheme.degree` (`:1455`) stayed
  a bare `sorry` the whole campaign — blocked on Hilbert-polynomial machinery that never landed**,
  and the abelian-variety identification inherited the typed-sorry FGA foundation.
- **`Picard/FGAPicRepresentability.lean`** — the single real representability sorry
  `instHasPicScheme [HasRationalPoint C] := ⟨sorry⟩`, **never discharged**; all downstream
  representability sorryAx-tainted (old-draft-picard-recon §4).
- **Old-draft campaign milestone B3 — "rigid pushforward, the hardest single lemma"**
  (old-draft-picard-recon §4). This **was** cohomology-and-base-change in the old draft, and it
  **never landed**. cbc-lite is the rebuild's bet that the *curve-two-cover* form of B3 is tractable
  where the general form was not.

**Feasibility verdict from the lessons.** The auxiliary engines (flattening, Hilbert–Serre,
identity-component substrate, generic freeness) are all *provably formalizable* — Merten closed
them. The two things that **never landed in either the old FGA route or the campaign** are exactly
**(a) cohomology-and-base-change / rigid pushforward (B3)** and **(b) degree** (blocked on
Hilbert polys). So the representability wall is real and **precisely located at the pushforward /
base-change engine** — which is what cbc-lite probes. The old draft's degree block is *already
routed around* in the rebuild (χ-ledger, landed field-level); the pushforward block is the one
cbc-lite must clear.

### 1.3 The cech-port contingency source (`SubProjects/Cech-Cohomology`, done, green)

`AJCR.cech-port`'s source is real and inspected. `CECH.main` (status **done**):
`cech_computes_higherDirectImage : H^i(Čech^•(𝔘,F)) ≅ R^i f_* F` for separated quasi-compact `f`
and a finite affine cover, **unconditional**. The project also carries
`Cohomology/AffineSerreVanishing.lean` — **the general quasi-coherent affine Serre vanishing**,
i.e. exactly cbc-lite's crux gap (§0.3(ii), §2 G-CBC-3) — plus `HigherDirectImage.lean`,
`CechToHigherDirectImage.lean`, `QcohTildeSections.lean`. **The rebuild charter forbids importing
it** (from-scratch); it is a *lesson* and the *escalation target*. The salient fact for the
decision criterion: **the exact lemma cbc-lite's hardest gap needs already exists green** — so the
escalation, if triggered, is a bounded port of a *known-provable* statement, not open research.

---

## §2. Gap list (dependency order, tags, sizes)

Tags: **[PLUMB]** relative scaffolding on landed infra · **[GEN]** generalize a landed
structure-sheaf lemma to a line bundle · **[ASSEMBLE]** wire landed pieces · **[NEW-MATH]** genuine
new content. Sizes: **S** ≤ ~150 lines / <1 session · **M** ~150–350 / 1 session · **L** ~350–500 /
≥1 session, campaign risk. "Reuses" names the landed decl it leans on.

- **G-CBC-1 [PLUMB, S] — the relative curve `C_R` + base-changed affine two-cover.**
  `C_R := (C ⊗ overSpec k R).left`; `Vᵢᴿ := (projection)⁻¹ᵁ Vᵢ`; instances `IsAffineOpen Vᵢᴿ`
  (`Vᵢ ×_k Spec R` affine), `V₀ᴿ ⊔ V₁ᴿ = ⊤` (preimage of a cover). **Reuses:** `overSpec`,
  `Over.isPullback_left`, `Finiteness.lean`'s cover. Pure plumbing; the only friction is the known
  `Over.pullback` opacity (design §1). *Independent, first.*

- **G-CBC-2 [PLUMB/ASSEMBLE, S] — relative two-cover CBC for the STRUCTURE SHEAF.**
  Instantiate `twoCoverH1LinearEquiv` at `(R, C_R, Vᵢᴿ, 𝒪)` (vanishing instances **already land**
  via `subsingleton_moduleKSheaf_hModule'_one`), and prove the complex base-changes along `R → R'`
  from `sectionsBaseChange` + `δ`-naturality (`sectionsBaseChange_naturality`). Yields CBC-0/1/2
  for `L = 𝒪`. **Reuses:** everything in §1.1. *The bankable, all-landed-inputs win — and the
  scaffold every later brick reuses. If even this is hard, that itself is an early red flag.*

- **G-CBC-3 [GEN, M→L — THE CRUX] — affine H¹-vanishing for a line bundle:
  `Subsingleton (Sheaf.HModule' L Vᵢᴿ 1)`.** Two sub-routes:
  - **(i) transport (M):** for the presented `F_g` (§0.3(i)), prove a general transport lemma
    "`F|U ≅ G|U ⟹ HModule' F U n ≅ HModule' G U n`" (Ext functoriality; `HModule' _ U _` depends
    only on the restriction to `U`), then transport from `subsingleton_moduleKSheaf_hModule'_one`.
    Bounded — but only covers two-cover-trivial `L`.
  - **(ii) general (L, campaign risk):** generalize `AffineVanishing.cokernel_app_surjective`
    (`:180`) + `exists_cech_cobounding` from `moduleKSheaf` to a quasi-coherent sheaf of
    `R`-modules — the general affine Serre vanishing. The inner Serre argument is already
    sheaf-agnostic, **but quasi-coherence of `L` on `C_R` as a `Sheaf (ModuleCat R)` must be a
    usable hypothesis**, and that packaging is not in-tree. *This is where the wall is, if
    anywhere; the exact statement exists green as `AffineSerreVanishing.lean` in the cech-port
    source (§1.3).* **[NEW-MATH]** for the quasi-coherence packaging.

- **G-CBC-4 [GEN, M] — section base change for a line bundle:
  `Γ(Vᵢᴿ; L) ⊗_R R' ≅ Γ(Vᵢ^{R'}; L_{R'})`.** For `F_g` (§0.3(i)) this reduces to
  `sectionsBaseChange` on each trivializing piece plus the cocycle-gluing being base-change
  natural; for general `L` it is the invertible-sheaf generalization of `sectionsBaseChange`
  (mathlib `pushoutSection` is stated for the structure sheaf — a genuine generalization). Feeds
  CBC-1/2 for `L`. **Reuses:** `sectionsBaseChange`, `isPushout_sections`.

- **G-CBC-5 [ASSEMBLE, M] — CBC-0/1/2 for a line bundle `L`.** Combine G-CBC-3 (vanishing ⟹ the
  `≃ₗ` fires) + G-CBC-4 (complex base-changes) into the H⁰/H¹ base-change comparison maps and their
  iso range. Bookkeeping once the two `GEN` bricks land.

- **G-CBC-6 [ASSEMBLE/NEW-MATH, M] — CBC-3 rank/locally-free.** `H¹(C_R,L) = 0 ⟹ coker δ_L = 0
  ⟹ δ_L surjective ⟹ H⁰ = ker δ_L`; identify it as a finite projective `R`-module of rank
  `χ = deg L − g + 1` (Wave-2b `riemann_inequality` fibrewise, equality when `h¹=0`) with on-the-nose
  base change (CBC-2 at `i=0` needs no flatness once `H¹` and its base change vanish — Kleiman's
  3.10 (v)⟹(i)). **[NEW-MATH]:** "finite over `R` + fibrewise constant rank + flat ⟹ locally free"
  packaging over a not-necessarily-Noetherian `R`; check mathlib `Module.FinitePresentation` /
  `Flat` + `Finite` ⟹ projective gifts. This is the datum brick's direct input.

**Dependency order:** G-CBC-1 → G-CBC-2 (bankable) → {G-CBC-3, G-CBC-4 in parallel} → G-CBC-5 →
G-CBC-6. **Also needed but NOT cbc-lite's (field-level, flagged for §5):** fibrewise
`h¹(L_t) = 0 for deg L_t > 2g−2` (a Wave-2b/χ-ledger or datum-brick lemma) — CBC-3's hypothesis
supplier. Gap count owned by cbc-lite: **6** (2 plumb/assemble + 2 generalize + 2 assemble), of
which **exactly one (G-CBC-3(ii)) carries campaign risk**.

---

## §3. Early-warning DECISION CRITERION (for the orchestrator)

cbc-lite exists to answer one question cheaply: **can the two-term Čech complex compute H⁰/H¹ of a
line bundle on `C_R` with base-change compatibility, without reintroducing `R^i f_*` / derived
pushforward / Hilbert–Serre?** The measurable signal is the outcome of **G-CBC-3** (the affine
line-bundle vanishing) and **G-CBC-4** (line-bundle section base change). Read the outcome as:

- **GREEN — wall passable at "lite" level.** G-CBC-2 lands (expected: all inputs landed), and
  **either** the `F_g`-transport route G-CBC-3(i)/G-CBC-4-via-trivialization closes cheaply
  **and the datum's large-twist bundle can be arranged/normalized to be two-cover-trivial**,
  **or** the general G-CBC-3(ii)/G-CBC-4 close in bounded in-tree work (the Serre argument
  generalizes, quasi-coherence packaging is a few hundred lines). → **Proceed cbc-lite → datum
  (`AJCR.w4-rep.datum`), no fallback.** The Div^g/Grassmannian chart is fed by CBC-3.

- **AMBER — bounded pushforward gap → `AJCR.cech-port`.** If the general affine vanishing
  (G-CBC-3(ii)) or the general section base change (G-CBC-4) turn out to *need* the quasi-coherent
  `R^i f_*` comparison — but that comparison is the one **already green** as
  `cech_computes_higherDirectImage` / `AffineSerreVanishing` in the standalone Čech project (§1.3)
  — then **trigger `AJCR.cech-port`** (currently `blocked` "on a concrete Wave-4 gap naming it";
  this recon's G-CBC-3(ii)/G-CBC-4 **are** that concrete gap). The Kleiman/Div^g route survives;
  only the cohomology engine is upgraded by a port of a *known-provable* statement. **This is the
  first escalation, not plan-B/C.**

- **RED — wall impassable, curve-lite insufficient → plan-B / plan-C.** If clearing G-CBC-3/4/6
  is found to require the **general-generality** machinery the route was built to avoid — flattening
  stratification, Hilbert–Serre strata, or a genuine `B3`-scale rigid-pushforward campaign (the
  old draft's never-landed lemma, §1.2) — i.e. the two-cover specialization does **not** actually
  buy tractability over the general case, then:
  - **plan-B (Weil symmetric-power).** Build `Pic⁰` via `C^{(g)} = Sym^g C ↠ Pic⁰` (Abel–Jacobi
    image; design §6.3 route (a)). Cheapest if the Albanese lane lands `Sym^g` anyway; sidesteps
    the pushforward engine by constructing the representing scheme as a quotient of a symmetric
    power rather than from cohomology charts.
  - **plan-C (old-tree FGA route).** Rewrite the FlatteningStratification / GradedHilbertSerre /
    IdentityComponent stack (§1.2) — full Kleiman 4.8 with Hilbert-poly strata / Quot. Highest
    cost; the route the rebuild explicitly rejected (route rule 5).

**Concrete go/no-go the first brick must return** (so the orchestrator can act without re-reading):
after G-CBC-2 + the G-CBC-3(i)/G-CBC-4 probe on `F_g`, report **(1)** did the general-coefficient
carrier fire relatively over `R` with a clean `R`-module structure on `HModule L i`? **(2)** did the
affine-vanishing transport `HModule' F_g Vᵢᴿ 1` close from the landed 𝒪-vanishing, or did it demand
quasi-coherence machinery? **(3)** did `Γ(Vᵢᴿ; F_g) ⊗_R R'` base-change from `sectionsBaseChange`,
or did the cocycle-glue break naturality? **All three clean ⇒ GREEN.** (2) or (3) demanding the
`R^i f_*` comparison ⇒ **AMBER (cech-port)**. Any of them dragging in Hilbert-poly / flattening /
a descent-scale sub-campaign ⇒ **RED (plan-B/C)**, and name which sub-lemma forced it.

---

## §4. Draft first-brick spec (house format) — **BRICK cbc-1: relative two-cover CBC, structure
sheaf + `F_g` line-bundle probe**

*Chosen as first brick for maximal de-risking with a genuine early-warning payload: (i) the
structure-sheaf half (G-CBC-1/G-CBC-2) is **all-landed-inputs**, banks the relative scaffold every
later brick reuses, and curve-specializes Kleiman 4.8.1/4.8.3 "cohomology commutes with flat base
change" where every input exists; (ii) the `F_g` half (G-CBC-3(i)/G-CBC-4) is the **cheapest honest
touch of a non-structure line bundle**, so it surfaces the two real risks — affine vanishing and
section base change for a twisted sheaf — before any datum work is committed. It deliberately does
**not** attempt the general (non-`F_g`) vanishing G-CBC-3(ii): that is the wall probe, spec'd
worksheet-first as a follow-up once this brick reports.*

**MISSION / CONTRACT.** Deliver `AlgebraicJacobian/Cohomology/RelativeTwoCover.lean` (≤ 500 lines),
providing, for `{k : Type u} [Field k] (C : Over (Spec (.of k)))` with the standing bundle
`[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, a commutative
`k`-algebra `R`, and its base change `R → R'`:

```lean
-- The relative curve and its base-changed affine two-cover (G-CBC-1)
noncomputable def relCurve (R) : Scheme.{u}                 -- := (C ⊗ overSpec k R).left, over Spec R
def relCoverAffine₀/₁ : IsAffineOpen (Vᵢᴿ) ; relCover_sup : V₀ᴿ ⊔ V₁ᴿ = ⊤

-- CBC-0/1/2 for the structure sheaf (G-CBC-2)
noncomputable def relTwoCoverH1 (R) :
    Sheaf.HModule ((relCurve C R).moduleKSheaf R) 1 ≃ₗ[R]
      Γ(relCurve C R, V₀ᴿ⊓V₁ᴿ) ⧸ LinearMap.range (TwoCover.diff R …)
theorem relTwoCover_baseChange (φ : R →+* R') :        -- the complex base-changes
    (K over R) ⊗_R R' ≅ (K over R')          -- via Over.sectionsBaseChange + δ-naturality
theorem relH1_baseChange (φ : R →+* R') :   -- CBC-2 for 𝒪, i = 1 (flat case: iso)
    Sheaf.HModule (…R) 1 ⊗_R R' ≅ Sheaf.HModule (…R') 1

-- The F_g line-bundle probe (G-CBC-3(i), G-CBC-4) — the early-warning payload
noncomputable def twistSheaf (g : Γ(relCurve C R, V₀ᴿ⊓V₁ᴿ)ˣ) :
    Sheaf (Opens.grothendieckTopology (relCurve C R)) (ModuleCat.{u} R)
def twistSheaf_triv_left/right : twistSheaf g |Vᵢᴿ ≅ (moduleKSheaf R)|Vᵢᴿ
instance : Subsingleton (Sheaf.HModule' (twistSheaf g) Vᵢᴿ 1)   -- transport (G-CBC-3(i))
noncomputable def twistTwoCoverH1 (g) :                          -- CBC-0 for F_g
    Sheaf.HModule (twistSheaf g) 1 ≃ₗ[R] Γ(…, V₀ᴿ⊓V₁ᴿ; twistSheaf g) ⧸ range δ_{F_g}
theorem twist_baseChange (g) (φ : R →+* R') : …                  -- CBC-1/2 for F_g (G-CBC-4)
```

Binding in **shape** (carriers, the `≃ₗ[R]`/`⊗_R` typing, the general-coefficient `twoCoverH1LinearEquiv`
as the carrier, base change as an honest **iso/equality** never `Nonempty`); spelling lane-owned.
No `sorry`; axioms exactly `[propext, Classical.choice, Quot.sound]`.

**READ FIRST (in order).** 1. this recon §0 (statements), §1.1 (landed API), §2 (G-CBC-1..4).
2. `Cohomology/TwoCover.lean` in full — `twoCoverH1LinearEquiv` (`:92`), `diff`/`H1Cok`/`delta`/
`h1CokEquiv` and the `Subsingleton (HModule' …)` hypothesis discipline. 3. `Cohomology/
SectionsBaseChange.lean` — `sectionsBaseChange{,Iso,_tmul,_naturality}`, `overSpec`,
`isPullback_left`, `isPushout_sections`. 4. `Cohomology/AffineVanishing.lean` — the
`subsingleton_moduleKSheaf_hModule'_one` (`:310`) to transport from, and its engine
`cokernel_app_surjective` (`:180`). 5. `Cohomology/Finiteness.lean` — the affine two-cover of `C`
to base-change. 6. design §6.1 (the `F_g` construction and the "feed the equalizer-presented
twisted sheaf" plan) — **but note** `degree-pic0-recon.md` §1.1 correction 2: the χ-ledger dropped
`F_g` because it needed χ of *arbitrary* classes; here `F_g` is exactly right because we want the
*presented* case as the cheap probe.

**PROOF ROUTE (pinned).** `relCurve`/cover: `overSpec` + `isPullback_left`, preimage of the
`Finiteness.lean` cover; affineness of `Vᵢᴿ` from `Vᵢ` affine ⊗ `Spec R` over the field.
`relTwoCoverH1`: `twoCoverH1LinearEquiv` at `k := R`, vanishing from
`subsingleton_moduleKSheaf_hModule'_one`. `relTwoCover_baseChange`: term-wise
`sectionsBaseChange` on `V₀ᴿ, V₁ᴿ, V₀ᴿ⊓V₁ᴿ` (all qcqs over the field), `δ` naturality from
`sectionsBaseChange_naturality`; then base change of a cokernel is right-exact.
`twistSheaf g`: the equalizer sheaf `{(s₀,s₁) | s₀ = g·s₁ on ∩}` (design §6.1); trivializations
`(s₀,s₁) ↦ s₀` on `V₀ᴿ`, `↦ s₁` on `V₁ᴿ`. Vanishing instance: general transport lemma
`HModule' F U 1 ≃ HModule' G U 1` from `F|U ≅ G|U` (Ext postcomposition), applied to the
trivialization. `twist_baseChange`: `sectionsBaseChange` on each trivializing piece + the cocycle
`g` base-changing to `g ⊗ 1` (unit maps to unit).

**DESIGN CONSTRAINTS (kernel discipline — binding).** `set_option autoImplicit false`; file
≤ 500 lines; opaque defs for `relCurve`/`twistSheaf`/cover (never let the kernel unfold the
pullback tower during later `rw` — the recurring timeout mode); expose behaviour through named
`@[simp]` lemmas. Carry `R`-**linear** structure through every equiv (the old-draft finrank hazard,
recon lesson: a bare `Equiv` does not determine rank). Base change is an **iso/`LinearEquiv`**,
never `Nonempty`/`Classical.choice` (route rule 4). Activate `Scheme.overModule`/
`Over.sectionsAlgebra` as `attribute [local instance]` per the house discipline; do NOT globalize.
No new axioms; wire into `AlgebraicJacobian.lean` (on staleness re-read and re-apply just your line).

**VERIFICATION PROTOCOL (foreground, blocking — non-negotiable).** 1. `lake build
AlgebraicJacobian.Cohomology.RelativeTwoCover` — kernel-green (one build at a time; never race the
LSP; `sleep`/foreground-block, do not stop on a background monitor). 2. add the import, `lake build
AlgebraicJacobian` — root green (paste the tail). 3. `lean_verify` (live LSP MCP, **not** `lake env
lean` scratch — OOMs on this box) on `relTwoCoverH1`, `relTwoCover_baseChange`, `relH1_baseChange`,
`twistSheaf`, the `Subsingleton (HModule' (twistSheaf …) …)` instance, `twist_baseChange` — axioms
exactly `[propext, Classical.choice, Quot.sound]`. 4. `grep -n -w sorry` on the touched file (exits
1 on zero matches; no `&&`-chaining). Do NOT run git; do NOT commit.

**REPORT FORMAT (final message, the early-warning payload).** (a) each delivered signature verbatim
as compiled; (b) **the three go/no-go answers of §3** (relative carrier fired cleanly? vanishing
transport closed from the 𝒪-vanishing or demanded quasi-coherence? section base change closed from
`sectionsBaseChange` or broke on the cocycle glue?); (c) **GREEN/AMBER/RED verdict** with the
sub-lemma that forced any non-green; (d) whether the general (non-`F_g`) vanishing G-CBC-3(ii) looks
bounded-in-tree or port-bound, from what you saw; (e) root-build job count + green/red; (f)
`lean_verify` axiom lists verbatim; (g) file length.

---

## §5. Honest risks

1. **G-CBC-3(ii) — the general affine vanishing — is the one campaign-risk gap, and it may be the
   wall.** The `F_g` probe (first brick) only reaches line bundles *trivial on the pinned
   two-cover*; the datum's large-degree twist of the universal degree-0 class **need not be** (Pic
   of a Dedekind chart ≠ 0, recon lesson 1). So a GREEN first brick clears the *machinery* but not
   necessarily the *generality*. The honest requirement is the general quasi-coherent affine Serre
   vanishing. **I could not verify from reading that generalizing `AffineVanishing` (whose Serre
   argument is sheaf-agnostic) to a quasi-coherent `Sheaf (ModuleCat R)` is bounded** rather than
   dragging in a `tilde`/quasi-coherence packaging that the rebuild lacks. Mitigating fact: the
   exact statement is **green in the cech-port source** (`AffineSerreVanishing.lean`, §1.3), so the
   AMBER escalation is a bounded port of a known theorem, not open research — but the charter's
   from-scratch rule means "bounded port" still means re-deriving it in-tree.

2. **Whether the datum even needs G-CBC-3(ii), or can normalize onto the two-cover.** If the datum
   brick can always arrange its large-twist bundle to be two-cover-trivial (e.g. by twisting by a
   divisor supported off `V₀⊓V₁`, or presenting the universal family on a *refined* cover), the
   cheap `F_g` route suffices and the wall is illusory. I could not settle this from reading; it is
   a datum-brick design question that the first brick's report should sharpen. **Flag for the datum
   spec:** decide the carrier (i)/(ii) question *before* committing G-CBC-5/6.

3. **CBC-3's fibrewise `h¹ = 0` input is field-level and not obviously landed.** `riemann_inequality`
   gives `deg + 1 − g ≤ h⁰` and `h0_nsmul_point_unbounded` gives unboundedness, but **explicit
   `h¹(L_t) = 0` for `deg L_t > 2g−2`** (Serre duality / RR at large degree) is a *separate*
   field-level statement I did not find in the χ-ledger (Chi files confirmed field-level, no
   base change). It belongs to Wave-2b closure or the datum brick, not cbc-lite — but cbc-lite's
   CBC-3 is vacuous without it. **Flag:** confirm/spec the fibrewise vanishing alongside the datum.

4. **The rank/locally-free packaging (G-CBC-6) over a general `R`.** Kleiman works over Noetherian
   `S`; the rebuild's test rings are arbitrary commutative `k`-algebras. "Finite + flat + fibrewise
   constant rank ⇒ locally free/finite projective" over a non-Noetherian base needs the right
   mathlib gift (`Module.Flat` + `Finite` ⇒ projective for finitely presented; finite presentation
   of `H⁰` from the two-term complex). Plausible but unverified; a possible hidden `M`→`L`.

5. **Universe / `R`-module-structure friction on `HModule L i`.** `twoCoverH1LinearEquiv` is over
   `[CommRing k]` (good) but the design's universe discipline (`Type u` throughout,
   `GrpObj.ofRepresentableBy` coupling) means the `R`-module structure on `Sheaf.HModule L i` and
   its base change must stay in `Type u` with no `ULift`. The two-cover carrier is `ModuleCat.{u} R`
   (checked), so this should hold — but it is exactly the kind of defeq/universe landmine (design
   §1, §5 "forget-defeq") that only shows under `lake build`. The first brick's clean-carrier
   go/no-go (§3 answer (1)) is precisely there to catch it while cheap.

**Net.** The base-change *machinery* (carrier general-in-coefficients, relative scaffold, H⁰ base
change for 𝒪) is **landed**; cbc-lite's 6 gaps are mostly plumbing/assembly with **one** genuine
campaign-risk gap (general affine vanishing, G-CBC-3(ii)) whose target is **known-provable** (green
in the port source). The first brick banks the scaffold and probes the machinery on a twisted
bundle at minimal cost, returning a GREEN/AMBER/RED verdict the orchestrator can act on without
re-deriving this analysis. The wall, if real, is narrow and named — not the old draft's diffuse
B3/Hilbert-poly block.

*End of recon.*
