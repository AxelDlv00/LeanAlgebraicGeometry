# Strategy Critic Report

## Slug
iter030

## Iteration
030

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — `Hⁱ(f_*C•) ≅ Rⁱf_*F` via the P4 abstract Leray lemma is exactly the protected target's RHS; the augmented Čech complex `Cᵖ = ∏(j_s)_*(F|_{U_s})` is the right object.
- **Mathematical soundness**: PASS — reduction of acyclicity input (ii) to affine Serre vanishing `H^q(affine,qcoh)=0` is the standard 02KE/02KG decomposition; P4 (`rightDerivedIsoOfAcyclicResolution`) is already axiom-clean.
- **Verdict**: SOUND

### Route: B — two spectral sequences (REJECTED)

- **Mathematical soundness**: PASS — rejection is correct. Both Grothendieck/Čech spectral sequences are absent from Mathlib (multi-thousand-LOC), and the strategy correctly notes B *still* rests on the same `injective_cech_acyclic` brick as A, so it is strictly more expensive with no soundness gain.
- **Verdict**: SOUND (rejection upheld)

### Route: the acyclicity bridge (torsor-free, load-bearing)

- **Goal-alignment**: PASS — the (1) `injective_cech_acyclic` + (2) `ses_cech_h1` + (3) 01EO dimension-shift chain lifts P3's standard-cover tilde Čech vanishing to affine sheaf vanishing without ever invoking affine vanishing. The non-circularity argument is explicit and correct: P3's base case is proven by pure localization algebra (`exact_of_isLocalized_span`), not by sheaf cohomology.
- **Mathematical soundness**: PASS — bricks (1) and (2) are done and axiom-clean; 01EO is complete (iter-028). The circular-regress break is real.
- **Verdict**: SOUND

### Route: absolute cohomology realization — Ext of the corepresenting object (Form B)

- **Goal-alignment**: PASS — `H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)` with the SES staying in `X.Modules` supplies exactly the three facts 01EO consumes (injective vanishing in the 2nd arg, covariant LES at fixed 1st arg, `H⁰≅Γ`).
- **Mathematical soundness**: PASS — Form B's decisive advantage is real: putting the injective in the **2nd** Ext argument means injective-vanishing is off-the-shelf (`Ext.eq_zero_of_injective`) and **no restriction-preserves-injectives lemma is ever needed**. This is the design invariant the whole project is organized around, and the iter-030 fork resolution preserves it (see below).
- **Verdict**: SOUND

## Format compliance

- **Size**: 113 lines / 11194 bytes — within budget (≤250 lines / ≤12 KB), though bytes are within ~7% of the ceiling; watch growth.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order, with `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes — the `## Open strategic questions` prose carries iter-stamps that are creeping per-iter history: `"DESIGN-FORK RESOLUTION (iter-030): …"`, `"01EO general basis criterion: COMPLETE (iter-028, 7 decls …)"`, `"CONDITIONAL form … landed (iter-029, QcohTildeSections.lean)"`, `"(strategy-critic iter-029)"`. The Completed-table iter cells are fine; these prose stamps are not.
- **Accumulation detected**: no — completed phases are in `## Completed`, no excised routes linger.
- **Table discipline**: PARTIAL — several `## Phases & estimations` cells run 3–4 sentences (the 02KG row's `Risks` cell especially). The canonical form is "one short line per cell." Not fatal, but trending toward prose-in-table.
- **Format verdict**: DRIFTED

## Prerequisite verification

- `CategoryTheory.Abelian.Ext`: VERIFIED — exists (`Mathlib.CategoryTheory.Abelian.Ext`).
- Ext computed by injective resolution of the **2nd** argument: VERIFIED — `CategoryTheory.InjectiveResolution.extMk` and `InjectiveResolution.extEquivCohomologyClass` (module `Mathlib.CategoryTheory.Abelian.Injective.Ext`) give `Ext X Y n ≃ CohomologyClass (single X) R.cochainComplex` for `R : InjectiveResolution Y`. **This directly discharges the strategy's open worry** ("Ext-by-injective-resolution-of-2nd-arg backing UNVERIFIED in Mathlib" in P5a + Open questions). The planner should flip that flag to confirmed-present and remove the UNVERIFIED hedge.
- `j_! ⊣ restriction` exactness underpinning `Hom((j_S)_!O_{U_S}, I) = I(U_S)`: project-side (already shipped via `cechFreeComplex_quasiIso` / `injective_cech_acyclic`), not a Mathlib dependency.

## Design-fork resolution — the load-bearing iter-030 decision (verdict: SOUND)

The directive's central question: *is positive-degree Čech cohomology of an injective `O_X`-module zero over an arbitrary finite family of opens, or does the vanishing secretly need the family to cover its sup?*

**It is true cover-agnostically, and there is no hidden covering hypothesis.** Proof sketch (stalkwise exactness of the augmented free Čech resolution):

- The augmented free complex is `⋯ → ⊕_{|S|=p+1}(j_S)_!O_{U_S} → ⋯ → ⊕_i(j_i)_!O_{U_i} → O_𝒰 → 0`, where `O_𝒰 := image(cechFreeAug)`.
- `(j_S)_!O_{U_S}` has stalk `O_{X,x}` when `x ∈ U_S` and `0` otherwise. So at `x` the complex is the augmented simplicial chain complex of the **full simplex on the vertex set `V_x := {i : x ∈ U_i}`**, with coefficients `O_{X,x}`.
- If `V_x ≠ ∅`: the augmented chain complex of a simplex is contractible ⇒ exact, and the augmentation target stalk `(O_𝒰)_x = O_{X,x}`.
- If `V_x = ∅`: every term is `0` and `(O_𝒰)_x = 0` (the image presheaf has no sections reaching `x`) ⇒ trivially exact.
- Exactness holds at **every** stalk with no `⋃U_i = ⊤` requirement. The covering hypothesis only changes *what `O_𝒰` is* (`= O_X` when covering, `= j_!O_{⋃U_i}` otherwise) — it never enters exactness.
- Then `Hom_{O_X}((j_S)_!O_{U_S}, I) = I(U_S)` by `j_! ⊣ restriction`, so `Hom(resolution, I)` IS the presheaf Čech complex of `I`, and injectivity of `I` makes it exact in positive degrees ⇒ `Ȟ^p(𝒰, I) = 0` for `p ≥ 1`.

The planner's structural justification matches this: `𝒰.f` enters ONLY through `coverOpen 𝒰 i := (𝒰.f i).opensRange`, and `coverStructurePresheaf := image(cechFreeAug)` references no `⊤`/`iSup`/covering hypothesis. The re-parameterization from `X.OpenCover` to `{ι}[Finite ι](U : ι → Opens X)` is therefore faithful, not a weakening. **The re-parameterized `injective_cech_acyclic` is neither vacuous nor false, and re-adds no covering hypothesis.** This is precisely the statement 02KG needs over standard covers of an arbitrary `D(f)` (a family covering `D(f)`, not `⊤`).

**Rejection of the `D(f) ≅ Spec R_f` + restrict alternative is correct.** Note: restriction to an open *does* preserve injectives mathematically (`j_!` is exact for open immersions ⇒ its right adjoint preserves injectives), so the alternative is not false. But it is rejected on the correct grounds: formalizing it resurrects exactly the `j_!`-functor + exactness apparatus (200–500 LOC) that Form B was chosen to avoid. The cover-agnostic re-parameterization is the cheaper route that keeps the whole edifice consistent. Rejection upheld.

**One caveat to verify during execution (not a soundness flaw):** the re-parameterization touches `FreePresheafComplex.lean` and ripples into `CechBridge.lean` (where `injective_cech_acyclic` lives). The project's own memory records repeated defeq-carrier / instance-resolution pain in exactly these files (`erw`-everywhere, `maxHeartbeats 2000000`, LSP-staleness). "Mechanical" re-parameterization of a foundational complex in Lean rarely stays mechanical. Budget realistically (see effort note).

## Effort honesty (02KG row)

- **Effort honesty**: under-counted (mildly). The 02KG row is `~3–4 iters / ~300–500 LOC` for: (a) re-parameterize the free-Čech machinery, (b) the 01I8 `IsIso F.fromTildeΓ` instance ("~few-hundred LOC" by the strategy's own estimate), (c) `surj_of_vanishing`. Item (b) alone nearly exhausts the LOC band; (a)'s ripple through `CechBridge` (with this file family's documented defeq friction) and (c)'s sheaf-gluing are not free. `300–500` LOC is plausible only if (a) really is mechanical. Recommend widening to `~400–650` LOC and treating 4 iters as the expected case, not the ceiling.

## Must-fix-this-iter

- Format: DRIFTED — strip the iter-stamps from `## Open strategic questions` prose (`(iter-030)`, `(iter-028)`, `(iter-029)`, `(strategy-critic iter-029)`); state the resolved facts in the present tense and let the iter sidecar hold the "when." Tighten the multi-sentence `## Phases & estimations` cells (esp. 02KG `Risks`) toward one line. This is a DRIFTED (not NON-COMPLIANT) verdict — fix in-place this iter or record a one-line rebuttal in `plan.md`.
- P5a prerequisite: the "Ext-by-injective-resolution-of-2nd-arg UNVERIFIED" hedge is now resolved — `InjectiveResolution.extEquivCohomologyClass` exists. Update STRATEGY.md to mark it confirmed so the P5a lane does not re-litigate it.

## Overall verdict

The strategy is sound. The load-bearing iter-030 decision — re-parameterizing the free-Čech resolution machinery from `X.OpenCover` to a raw finite family of opens to make `injective_cech_acyclic` cover-agnostic — is mathematically correct: positive-degree Čech cohomology of an injective `O_X`-module vanishes over *any* finite family of opens because the augmented free Čech resolution is exact stalkwise (augmented simplex chain complex on `{i : x ∈ U_i}`), with the covering hypothesis affecting only the identity of `O_𝒰`, never exactness. The re-parameterized statement is neither vacuous nor false and re-introduces no covering hypothesis. The rejection of the `D(f) ≅ Spec R_f` + restrict alternative is correct — it would resurrect the `j_!`/restriction-of-injectives apparatus that Form B exists to avoid. No infrastructure-deferral findings: every construction the goal requires (the bridge bricks, 01EO, the EnoughInjectives connector, 01I8) has a concrete project-side plan with an iter estimate, and the previously-UNVERIFIED Ext backing is in fact present in Mathlib. The only items to address this iter are format drift (iter-stamps in prose, fat table cells), a mild upward correction to the 02KG effort estimate, and flipping the now-confirmed Ext prerequisite. The 01I8 3-step route is acceptable; if Mathlib's `IsQuasicoherent` exposes the `F(D(f)) ≅ Γ(F)_f` localization property, checking `fromTildeΓ` iso directly on the `D(f)`-basis is a cleaner path worth a look, but the presentation route is honest and non-circular (its exactness inputs are tilde/free, P3's domain, never general qcoh Serre vanishing).
