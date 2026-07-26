# VERDICT

**REFUTED — with a salvage.** Confidence **high (≈0.9)** on the refutation; **medium-high (≈0.75)** on the salvage being technically realisable.

The technical half of the hypothesis is right: the ε-identity does not need the seven-field `IsCertified`, and there is a route (route 4, submodule-descent by squeeze) that needs neither a `ThetaGlued` base change nor any Zariski descent of Finite/Projective/rank. **But the load-bearing conclusion is false.** The chart-confinement no-go bites `IsLocallyCertified` exactly as hard as it bites `IsCertified` — this is already landed and recorded in the project. Re-basing U2 on `DivFamZar` buys zero progress on the blocker; it moves the same wall one file over.

# EVIDENCE

1. **The ε-identity's real inputs** — `AlgebraicJacobian/Picard/DivSchemeEps.lean:170-191`: `divisorWindow_eq_of_le` takes exactly `hsurj/hfin/hproj/hrank` and `hle`. `:204` shows the certificate enters only as three projections. Correct as stated in the brief.

2. **`ThetaGlued` is a kernel of a map between finite products** — `DivisorFamilyTheta.lean:214` `thetaGluedSubmodule := LinearMap.ker (A.deltaLeft - A.thetaDeltaRight a)`; `:232` `ThetaGlued := ↥(A.thetaGluedSubmodule a)`; `:311` `thetaGluedEval := LinearMap.codRestrict …`; `DivisorFamily.lean:384` `chartProd := ∀ j : A.index, A.colength j`.

3. **The (c3)/(c4) flat clauses exist precisely to make certificates base-change along *arbitrary* maps** — `DivisorFamily.lean:426-441`, docstring `:423-425`: "the two flat-cokernel clauses (c3)/(c4) that make certificates base-change along ARBITRARY test maps … consumed by `FlatCokernel.tensorKer_bijective_of_flat_coker`". For a **flat** target (`Localization.Away` is flat) they are unnecessary — `Module.Flat.lTensor_exact` (`Mathlib/RingTheory/Flat/CategoryTheory.lean:44`) already gives `S ⊗ ker = ker (S ⊗ ·)`. So kill-shot 5a does **not** fire.

4. **`ThetaGlued` base change is NOT landed.** Only the *untwisted* `Glued` has one: `DivisorFamilyPullbackGlued.lean:143` `gluedBaseChange : R' ⊗[R] A.Glued ≃ₗ[R'] ↥(A.pulledGluedSubmodule R')`, gated on both flat clauses. Grep for `pulledThetaGlued`/`thetaGluedBaseChange` returns nothing. The twisted case would have to be re-run.

5. **`IsLocallyCertified` certifies a *different* adaptation over a *smaller* ring for a `DivEq`-equivalent pulled system** — `DivisorFamilyZar.lean:71-80`: `∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n, DivEq G.eqns (d.pullback …)`. This is the "latter" case of kill-shot 5b — **but it is harmless**, because `divisorWindow` is defined from `d` alone (`DivisorFamilyWindow.lean:103-108`) and is `DivEq`-invariant (`:123` `divisorWindow_eq_of_divEq`). Transport to the original system is free.

6. **THE KILL SHOT.** `DivSchemeCertZarC1.lean` docstring (`:30-31`, verbatim): *"in particular a **certified** adaptation of a connected divisor forces that divisor inside a single pinned chart of `pi`. **`DivFamZar` is therefore blind to connected divisors meeting both `pi⁻¹(0)` and `pi⁻¹(∞)` — over any base, after any Zariski shrink, for any adaptation.**"* The verdict itself is `:131` `supportLocus_subset_chart_of_isCertified (hconn : IsPreconnected d.supportLocus) (hc : A.IsCertified n)`, and it is `DivEq`-stable via `DivSchemeCertZarConfine.lean:110` `DivEq.supportLocus_eq` and shrink-stable via `DivSchemeCertZarTransport.lean` `supportLocus_pullback`.

7. **The campaign has already written this down.** `informal/spec-dd-r.md` ADDENDUM 3 §1(c): *"over that member `D` is connected and meets both vertical fibres. By `supportLocus_subset_chart_of_isCertified` … it therefore has no certified adaptation there, so **`D` is not `IsLocallyCertified`**."* §2: *"shrinking the base cannot help (it re-states the condition, and does not disconnect)."* §2 (β1): the per-piece argument *"holds for any cover by opens and therefore survives every reshaping of `FinCoverData`."*

8. **Caveat on the kill shot (the one soft spot).** ADDENDUM 3's SECOND CORRIGENDUM (2026-07-26, I-0356) says the explicit witness `tX²+XY+tY²` is **genus 0, off-stratum**; the no-go is proved structurally but *"no witness has been exhibited"* at `g ≥ 2`. So the refutation rests on the structural argument (β1)+(β2), which is landed Lean, plus the absence of a stratum witness. That is why confidence is 0.9, not 1.0.

9. **Mathlib descent inventory (item 3).**
 - Submodule equality from a span-⊤ family: **`Submodule.eq_of_isLocalized'_span`** (`Mathlib/RingTheory/LocalProperties/Submodule.lean:194`), with `Submodule.le_of_isLocalized_span:177`. FOUND.
 - `Submodule.localized'_eq_span : localized' S p f M' = span S (f '' M')` (`Mathlib/Algebra/Module/LocalizedModule/Submodule.lean:74`). FOUND — this is the bridge to `windowBaseChange`.
 - `IsLocalizedModule S (TensorProduct.mk R A M 1)` instance: `Mathlib/RingTheory/Localization/BaseChange.lean:94`. FOUND.
 - `Module.Finite.of_localizationSpan'` (`Mathlib/RingTheory/Localization/Finiteness.lean:227`). FOUND.
 - `Module.Projective` from a span-⊤ family: **NOT FOUND** as such. Only `Module.projective_of_localization_maximal` (`LocalProperties/Projective.lean:131`), which requires `[Module.FinitePresentation R M]`; the file's own TODO says *"Show that being projective is Zariski-local (very hard)"*.
 - Surjectivity: `surjective_of_isLocalized_span` (`LocalProperties/Exactness.lean:160`). FOUND.
 - `Module.rankAtStalk_baseChange` (`Spectrum/Prime/FreeLocus.lean:326`). FOUND.

# ITEM 4 — THE SHORTER ROUTE (and it is strictly cheaper)

Do **not** descend the three module properties (that needs the missing projectivity descent and a twisted `ThetaGlued` base change). Descend the conclusion, and get the hard inclusion by a **squeeze**:

Over `S_i = Localization.Away (g i)`: `windowBaseChange S_i x ≤ windowBaseChange S_i (divisorWindow d) ≤ divisorWindow (d.pullback) = divisorWindow G_i.eqns = windowBaseChange S_i x`, where the middle `≤` is the *formal* landed half `windowBaseChange_divisorWindow_le` (`DivisorFamilyEpsNaturality.lean:251`), the last `=` is `divisorWindow_eq_of_le_of_isCertified` applied **over `S_i`** to `G_i.certified`, and the penultimate `=` is `divisorWindow_eq_of_divEq`. The squeeze yields the window–localization compatibility for free — no need to prove the hard half of `divisorWindow_pulledEquations_eq`, which (`DivisorFamilyEpsNaturality.lean:387`) is itself gated on a **global** `hc : A.IsCertified g` and would be circular here.

# THE BRICKS (if you build the salvage anyway)

Ordered; all in a new `Picard/DivSchemeEpsZar.lean` unless noted.

1. `instance : IsLocalizedModule.Away f (windowCompare S : (R ⊗[k] H) →ₗ[R] S ⊗[k] H)` where `windowCompare = cancelBaseChange ∘ (1 ⊗ₜ ·)`. **S**. Inputs: `tensorProduct_isLocalizedModule`, `IsLocalizedModule.of_linearEquiv`.
2. `lemma windowBaseChange_eq_localized' (N) : windowBaseChange S N = N.localized' S (.powers f) (windowCompare S)`. **S**. Inputs: `Submodule.localized'_eq_span`, `Submodule.baseChange_eq_span` (already used at `EpsNaturality.lean:104`).
3. `lemma windowBaseChange_mono : N ≤ P → windowBaseChange S N ≤ windowBaseChange S P`. **S**. `Submodule.baseChange_mono` + `Submodule.map_mono`.
4. `theorem divisorWindow_eq_of_le_of_isLocallyCertified (hloc : IsLocallyCertified C R π g d) (hO hχ ha1 hMa) (x) (hle : x.toSubmodule ≤ divisorWindow d ha1) : divisorWindow d ha1 = x.toSubmodule`. **M** (the squeeze + `Submodule.eq_of_isLocalized'_span`). Inputs: bricks 1–3, `windowBaseChangeGr` (`EpsNaturality.lean:128`), `windowBaseChange_divisorWindow_le`, `divisorWindow_eq_of_divEq`, `divisorWindow_eq_of_le_of_isCertified`, `IsCertified.thetaGluedEval_surjective` (`DivisorThetaFibreData.lean:271`).
5. `noncomputable def DivFamZar.window : DivFamZar C R π n → Submodule R (R ⊗[k] H_a)` by `Quotient.lift … divisorWindow_eq_of_divEq`. **S**.
6. `noncomputable def divFamZarEps` + `divFamZarEps_mk_eq_of_le` + `divFamZarEps_toZar = divFamEps`. **M**.
7. `ThetaGeneratorSeed.divFamZar` (already exists in embryo: `DivSchemeCertZarPointwise.lean:~183` `divFamZar_of_forall_prime_away_certified`) → `ThetaGeneratorSeed.divFamZarEps_eq`. **M**.
8. Restate the DD-R U1/U3 consumers against `DivFamZar` — the `certificate.cert-relocalize` leaf. **L**.

Bricks 1–7 are ~1–2 sessions. **Brick 8 is where the money is, and it is unblocked only if the seed's divisor is `IsLocallyCertified` — which is exactly what the no-go denies.**

# WHAT WOULD KILL IT

It is already killed, and here is the single concrete way: take any seed whose divisor is connected and has a support point off `V₀` and one off `V₁` (`not_isCertified_of_isPreconnected_of_witnesses`, `DivSchemeCertZarVerdict.lean:62`). `supportLocus` is `DivEq`-invariant and pulls back along `relCurveMap C R (Localization.Away r)`, so **every** member of **every** span-⊤ family in `IsLocallyCertified` still sees the same connected two-witness support, and `supportLocus_subset_chart_of_isCertified` refuses a certificate on each. `IsLocallyCertified` therefore fails for exactly the divisors for which `IsCertified` fails. The blocker is not the ε-identity's certificate consumption; it is the **production** of any certificate, global or local, for a chart-crossing divisor. Only moving the pinned pair (R1/`p1-aut`) or unpinning the pieces (R2/σ-charts) escapes it — with the caveat of Evidence 8: at `g ≥ 2` the no-go is structural, not witnessed, so the *single* thing that could still overturn this verdict is a proof that on-stratum (`g ≥ 2`, `hχ`-pinned) seed divisors are always chart-confinable after a base shrink. That is worth a probe; re-basing on `DivFamZar` is not.
