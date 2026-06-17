# strategy-critic directive — iter-037

Fresh-context critique of the project strategy. The 01I8 route subsection (`### 01I8 affine F≅~(ΓF)`)
and the 01I8 phase row + Mathlib-gap line were rewritten THIS iter after a mathlib-analogist consult
established that Route B's keystone needs a base-change bridge (the earlier "Route B needs no base-change"
claim was an overclaim) but that the bridge is ONE bounded categorical lane (B3), strictly better than
the rejected Route P's two deep-math walls. Verify the corrected strategy is sound. Pay special attention
to: (a) whether the B1–B6 decomposition is a genuine route to the keystone or hides a further wall;
(b) whether dropping the `IsLocalizing` shortcut (it does not exist in Mathlib) leaves the assembly step
viable; (c) non-circularity with 02KG (the tilde right-exactness pitfall).

## STRATEGY.md (verbatim)
# Strategy

## Goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected, frozen-signature target: for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, `𝒰` a finite affine open cover of `X`, an isomorphism in the weak existence
form `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), with `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero
project axioms, kernel-only axioms.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| 02KG `affine_serre_vanishing` (cover-system + affine instantiation) | ACTIVE | ~1 | ~40–120 | Gated top theorems `affine_cech_vanishing_qcoh`/`affine_serre_vanishing` consume unconditional `qcoh_iso_tilde_sections`. | Cover-system chain COMPLETE; two tops FALSE-ready in the graph — do NOT dispatch until 01I8 closes (see Routes). |
| 01I8 `F≅~(ΓF)` via section-localization (Route B) | ACTIVE | ~2–4 | ~200–400 | Keystone `IsLocalizedModule (.powers f) (Γ(X,F)→Γ(D(f),F))` for qcoh `F` via B1–B6 chain; load-bearing lane B3 `restrict-over-compat` (engine `pushforwardPushforwardEquivalence`). | One bounded categorical bridge B3 (over↔scheme picture); `IsLocalizing`/`isIso_fromTildeΓ_iff_isLocalizing` DO NOT exist (analogist `bridge`); right-exactness pitfall (see Routes). |
| P5a vanishing inputs (consume P3b) | ACTIVE | ~3–4 | ~200–400 | `Hⁿ(f⁻¹V,G)` Ext-bridge + open-immersion/affine vanishing + augmented-Čech resolution (01XJ leaf done). | Ext-by-injective-resolution-of-2nd-arg backing present (`InjectiveResolution.extEquivCohomologyClass`). |
| P5b comparison assembly | BLOCKED | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity. | Final Route-A assembly of the protected goal. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing push–pull functoriality | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor`, `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal augmentation | none |
| P4 acyclic-resolution lemma (Leray, 015E) | 009 · 6 | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution`, `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift — axiom-clean | decompose-then-build; two-step `cokernel.mapIso`; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails by a mapped-complex term |
| P3 standard-cover Čech vanishing (section form, tilde) | 022 · ~14 | ~1200 | `CechAcyclic.lean` | `sectionCech_affine_vanishing` + `sectionCech_homology_exact` (IsZero homology p≥1) for `F=~M`; L1 tilde-bridge + L3 combinatorial core | accessors DEFEQ (`rfl`); abstract section maps (`set;clear_value`) before `IsLocalizedModule.ext`; target ABSOLUTE section complex | residual qcoh `F≅~ΓF` (01I8) deferred to 02KG consumer; old relative `affine` sorry superseded |
| P3b Čech↔derived bridge bricks | 025 · ~9 | ~1500 | `PresheafCech`,`FreePresheafComplex`,`CechBridge` | `cechFreeComplex_quasiIso` (free resolution of `O_𝒰`), `ses_cech_h1`, `injective_cech_acyclic` (pos-degree Čech vanishing for injectives) — axiom-clean | op-transport via `opFunctor`+`preadditiveYoneda`; `erw`+`.trans` for defeq-carrier mismatch; Route-B arrow-iso transfer | `maxHeartbeats 2000000` needed; LSP-staleness (trust only `lake env lean`) |
| Absolute-cohomology Form B + 01EO general basis criterion | 028 · 3 | ~600 | `AbsoluteCohomology`,`CechToCohomology` | `jShriekOU`=sheafify(free(yoneda U)); H⁰≅Γ (+naturality); 01EO chain L1–L4+top (`cech_eq_cohomology_of_basis`); `BasisCovSystem`/`HasVanishingHigherCech` cover-system encoding | Form B kills restriction-preserves-injectives (injective in 2nd Ext arg); cover-local presheaf form; `attribute [local instance] hasExtModules`; AB4* `Epi(Pi.map)` elementwise | `[EnoughInjectives X.Modules]` absent in Mathlib → carried as explicit hyp (P5a convention); 3 first-attempt iters, no churn |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is
(i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic. The P4 abstract lemma
gives `Hⁱ(f_* C•) ≅ Rⁱf_* F` directly — ONE abstract lemma, NO spectral sequences. Acyclicity
input (ii) reduces to affine Serre vanishing `H^q(affine, qcoh)=0`, supplied by the P3b bridge.

### Route B — two spectral sequences (REJECTED)
Both absent from Mathlib (multi-thousand-LOC); rests on the same `injective_cech_acyclic` brick as A.

### The acyclicity bridge (torsor-free, load-bearing)
Route A's acyclicity reduces to affine Serre vanishing `H^q(Spec A, qcoh)=0` (02KG). The honest
non-circular route is the minimal Čech↔derived bridge: (1) `injective_cech_acyclic`, (2)
`ses_cech_h1`, (3) the dimension-shift `cech_eq_cohomology_of_basis` (01EO) consuming the
standard-cover Čech vanishing of P3 as its condition (3). All three bricks of (1)+(2) are done;
01EO is the next target. This breaks the circular regress: P3 produces standard-cover Čech
vanishing; the bridge lifts it to affine sheaf vanishing without ever using affine vanishing.

### 01I8 affine `F≅~(ΓF)` — section-localization (Route B; the live route)
Selected over the global-presentation route (Route P) because P only reached the goal through TWO
genuine-mathematics walls (tilde base-change `tilde_restrict_basicOpen` + `tildePreservesFiniteLimits`
+ qcoh-closed-under-kernels). Route B converts those two walls into ONE bounded categorical bridge
(B3 below); it is strictly better, but it is NOT base-change-free (analogist `bridge`, iter-037
corrected the earlier "needs none" overclaim). Keystone — for qcoh `F`, `IsLocalizedModule (.powers f)
(Γ(X,F)→Γ(D(f),F))` — built as the explicit B1–B6 chain (NO `IsLocalizing` shortcut: `IsLocalizing`
and `isIso_fromTildeΓ_iff_isLocalizing` DO NOT exist in Mathlib — Tilde's `IsQuasicoherent` section
ends at `isIso_fromTildeΓ_of_presentation`):
- **B0 [DONE]** `exists_finite_basicOpen_subcover`, `isLocalizedModule_of_span_cover` (P1b),
  `section_isLocalizedModule_of_presentation` + 2 local-model bricks, `modulesRestrictBasicOpen`(+`Iso`).
- **B1 [small]** `QuasicoherentData F` → cover `Uᵢ` + per-`Uᵢ` `Presentation(F.over Uᵢ)`; refine to finite
  `D(gⱼ)⊆U_{φⱼ}`, `span{gⱼ}=R` via B0 subcover.
- **B2 [medium]** restrict `Presentation(F.over U_{φⱼ})` → `Presentation(F.over D(gⱼ))` via
  `Presentation.map` (over is left-adjoint + unit-iso). Pure `over`-picture, independent of B3.
- **B3 [THE BRIDGE — load-bearing lane]** `F.over D(gⱼ) ≅ modulesRestrictBasicOpen gⱼ F` (over-picture ↔
  honest `(Spec R_{gⱼ}).Modules`), engine `pushforwardPushforwardEquivalence`. Distinct from
  `lemma-widetilde-pullback`; NOT discharged by `modulesRestrictBasicOpenIso`.
- **B4 [small]** transport presentation across B3 + `modulesRestrictBasicOpenIso` (`Presentation.ofIsIso`)
  → `Presentation(modulesRestrictBasicOpen gⱼ F)`.
- **B5/B6 [DONE consumers]** `section_isLocalizedModule_of_presentation` per `gⱼ`; descend with
  `isLocalizedModule_of_span_cover` (section comparison is `restrict_obj`-`rfl`).
Then assembly: each `D(f)`-component of `fromTildeΓ` IS `IsLocalizedModule.lift` of the keystone map ⟹
`IsIso fromTildeΓ` ⟹ unconditional `qcoh_iso_tilde_sections`. **Non-circularity pitfall (load-bearing):**
the per-`D(gⱼ)` identification `F|_{D(gⱼ)}≅~Mⱼ` MUST come from tilde RIGHT-exactness (left adjoint
preserves the cokernel of the presentation), NOT a left-exact `Γ(D(gⱼ),-)` of an abstract cokernel —
the latter silently needs affine `H¹`-vanishing and reopens the 02KG circularity. `modulesRestrictBasicOpen`
(in `QcohRestrictBasicOpen`) is REUSED by B3/B4 — that file is NOT dormant. `TildeExactness` stays
dormant. Milestones: B1+B2 (over-picture) ∥ B3 (bridge) → B4 → keystone → assembly → unconditional
`qcoh_iso_tilde_sections`.

### Absolute cohomology realization — Ext of the corepresenting object (Form B)
`H^p(U, F) := Ext^p_{X.Modules}(jShriekOU U, F)` where `jShriekOU U := sheafify(free(yoneda U))`
is the corepresenting object of `F ↦ Γ(U,F) = F(U)` (`= j_!O_U` up to iso), built from the
already-shipped `freeYonedaHomEquiv` + `sheafificationAdjunction` (~50–80 LOC). The three facts
01EO consumes are then off-the-shelf with the SES staying in `X.Modules`: injective vanishing
`Ext.eq_zero_of_injective` (injective `I` as the 2nd arg — no restriction taken), covariant LES
`Ext.covariant_sequence_exact₁/₂/₃` at fixed 1st arg `jShriekOU U`, and `H⁰ ≅ Γ(U,F)` via the
corepresentability chain. The discarded alternatives: Form A `Ext(O_U, F|_U)` needs
restriction-preserves-injectives (≈ a 200–500 LOC `j_!` functor); `Functor.rightDerived` has
free injective vanishing but no packaged LES; `Sheaf.H` is absent. Reversal signal: Ext
universe/smallness pain over `SheafOfModules` → fall back to Route γ (Čech colimit), never `Sheaf.H`.

## Open strategic questions

- **EnoughInjectives connector (cone obligation).** The frozen target provides
  `[HasInjectiveResolutions X.Modules]` but the 01EO/02KG cone carries the stronger
  `[EnoughInjectives X.Modules]`. Connector `HasInjectiveResolutions C → EnoughInjectives C` is TRUE,
  ~6 LOC (deg-0 mono into `I.cocomplex.X 0` via `CategoryTheory.InjectiveResolution.instMonoFNatι`).
  Build + register at the P5b assembly lane — DISSOLVES the "EnoughInjectives absent in Mathlib" worry.
- P5a last-mile bridge `Hᵏ((f_*I^•)(V)) = Ext^k(jShriek(f⁻¹V), G)`: Ext-by-injective-resolution-of-2nd-arg
  backing CONFIRMED present (`InjectiveResolution.extEquivCohomologyClass`). Due when P5a consumers dispatch.
- 02KG `surj_of_vanishing` route: `ses_cech_h1` + `O_X`-epi local section surjectivity via
  `Presheaf.IsLocallySurjective`, gated on the `toSheaf` epi-preservation BUILD (= `PreservesFiniteColimits
  (SheafOfModules.toSheaf)`, route confirmed, `analogies/tosheaf-epi.md`); refine the lift cover to affine
  opens (`standard_cover_cofinal`, done) to land a standard cover in `Cov`.
- 01I8 section-localization route detail in Routes (`### 01I8 affine F≅~(ΓF)`). The `IsLocalizing`
  shortcut is OFF the table (analogist `bridge`: neither `IsLocalizing` nor `isIso_fromTildeΓ_iff_isLocalizing`
  exists). Assembly uses the explicit per-`D(f)`-component `IsLocalizedModule.lift` identity (Mathlib
  `Tilde.fromTildeΓ`) + `isIso_fromTildeΓ_iff` (essImage form) — confirm the iso-reflection at assembly.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex exactness `0→M→∏M_{f_i}→⋯` (P3) — done via L1+L3 around `exact_of_isLocalized_span`.
- Presheaf-level Čech machinery for `O_X`-modules (P3b free/section complexes, `injective_cech_acyclic`,
  `ses_cech_h1`) — done. Dropped as off-critical-path: presheaf enough-injectives + δ-functor universality.
- Absolute module-valued `Hⁿ(U,F)` = `Ext^p(jShriekOU U, F)` via `Abelian.Ext` (Form B); corepresenting
  object `jShriekOU = sheafify(free(yoneda U))`. NOT a bespoke `j_!` functor (that is absent, 200–500 LOC).
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0`, `R^i(affine)_*=0` (P5).
- EnoughInjectives connector `HasInjectiveResolutions C → EnoughInjectives C` (~6 LOC, instance) — see
  Open questions; makes the 01EO/02KG cone type-check against the frozen target's weaker hypothesis.
- `PreservesFiniteColimits (SheafOfModules.toSheaf)` — the missing dual of Mathlib's `PreservesFiniteLimits`
  (toSheaf right-exactness), NOT a small instance: ~80–150 LOC via the sheafification square + left-adjoint
  reflector, never through `forget` (`analogies/tosheaf-epi.md`). `toSheaf` epi-preservation is then a
  corollary, unlocking `Presheaf.IsLocallySurjective` for `surj_of_vanishing`.
- 01I8 instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ` via Route B: remaining gap is the B1–B6
  keystone chain, whose single load-bearing build is B3 `restrict-over-compat`
  (`F.over D(gⱼ) ≅ modulesRestrictBasicOpen gⱼ F`) via `pushforwardPushforwardEquivalence` at the
  open-subscheme site equivalence. NO `tildePreservesFiniteLimits`, NO `tilde_restrict_basicOpen`,
  NO `IsLocalizing`. ~150–350 LOC, fiddly site/IsContinuous plumbing, no math obstruction.
  (`analogies/bridge.md`.)

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve`/`CechComplex`; `AcyclicResolution.lean` (P4); P3b free-presheaf + section Čech complexes,
  `cechFreeComplex_quasiIso`, `injective_cech_acyclic`, `ses_cech_h1`.
- `AbsoluteCohomology.lean`: `jShriekOU`, corepresentability iso, `H^p := Ext^p(jShriekOU U, -)`, H⁰=Γ,
  injective-vanishing + LES wrappers → 01EO `cech_eq_cohomology_of_basis` → 02KG `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.

## References index (references/summary.md)
# References

<!-- archon:references-summary -->

This subproject was extracted from the Algebraic-Jacobian challenge; only the source
cited by the kept Čech-cohomology chapter is retained.

| File | Description |
| ---- | ----------- |
| [`stacks-coherent.md`](./stacks-coherent.md) → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes". The source for the entire chapter. Tags: **02KE** (`lemma-cech-cohomology-quasi-coherent` — Čech computes cohomology when all intersections are affine), `lemma-cech-cohomology-quasi-coherent-trivial` (standard-cover Čech vanishing), **02KG** (`lemma-quasi-coherent-affine-cohomology-zero` — Serre vanishing for quasi-coherent sheaves on affines), and `lemma-quasi-coherence-higher-direct-images-application` (`H^q(X,F) = H^0(S, R^q f_* F)` for affine `S`). Backs `def:cech_nerve`, `def:cech_complex`, `lem:cech_acyclic_affine`, and the comparison theorem `lem:cech_computes_cohomology`. Large file: jump to line. |
| [`homological-acyclic.md`](./homological-acyclic.md) → `homological-acyclic-derived.tex`, `homological-acyclic-homology.tex` | Stacks Project `derived.tex` + `homology.tex` — homological algebra: definition of right-F-acyclic objects (Tag **0157**, `derived.tex` lines 5253–5271), criterion via vanishing of higher derived functors (Tag **015C**, lines 5594–5617), and **Leray's acyclicity lemma** — an F-acyclic resolution computes RF (Tag **015E**, lines 5692–5783). Also Proposition **05TA** (enough acyclics, lines 5785–5876) and delta-functor background in `homology.tex` (Tags 010Q–010U). Backs `Cohomology_AcyclicResolution.tex`. `Read` with `offset`/`limit` to jump to the relevant line ranges. |
| [`stacks-cohomology.md`](./stacks-cohomology.md) → `stacks-cohomology.tex` | Stacks Project ch. "Cohomology" (`cohomology.tex`, 14535 lines) — abstract sheaf cohomology on ringed spaces and Čech cohomology. Key: **`lemma-describe-higher-direct-images`** (line 592, tag 01XJ) — $R^if_*\mathcal{F}$ is sheafification of $V\mapsto H^i(f^{-1}(V),\mathcal{F})$; **`lemma-cech-vanish-basis`** (line 1696, tag 01EO) — Čech-to-cohomology comparison on a basis (three conditions). Backs `Cohomology_CechHigherDirectImage.tex`. `Read` with `offset`/`limit` to jump to relevant lines. |
| [`stacks-schemes.md`](./stacks-schemes.md) → `stacks-schemes.tex` | Stacks Project ch. "Schemes" (`schemes.tex`, 4914 lines) — construction of $\widetilde{M}$ on $\operatorname{Spec} R$. KEY: **`lemma-spec-sheaves`** (tag **01HV**, lines 692–728) — $\Gamma(\operatorname{Spec} R, \widetilde{M}) = M$ (item 2, line 698) and $\Gamma(D(f), \widetilde{M}) = M_f$ (item 4, lines 701–702); construction prose at lines 593–603. `Read` with `offset`/`limit` to jump to line 692. |
| [`stacks-sheaves.md`](./stacks-sheaves.md) → `stacks-sheaves.tex` | Stacks Project ch. "Sheaves on Spaces" (`sheaves.tex`, 5337 lines). KEY: **`lemma-cofinal-systems-coverings-standard-case`** (tag **009L**, lines 3861–3887) — cofinal system of coverings suffices to check the sheaf condition on a basis (the cofinality lemma invoked by 02KG); in §6.30 "Bases and sheaves" (tag 009H, lines 3685–4438). Backs the cofinality field of `BasisCovSystem` in the 02KG affine-instantiation lane. `Read` with `offset: 3861, limit: 27` to jump to the lemma. |

## Blueprint chapters (titles / one-line topic)
- Cohomology_CechHigherDirectImage.tex — consolidated chapter: Čech complex of higher direct images; P3 standard-cover Čech vanishing; P3b free/section Čech bridge; absolute cohomology (Form B Ext); 01EO basis criterion; 02KG affine Serre vanishing cover-system; 01I8 affine F≅~(ΓF) Route B (section-localization keystone + B1–B6 bridge chain); P5 assembly.
- Cohomology_AcyclicResolution.tex — P4 Leray acyclic-resolution lemma (Stacks 015E): an F-acyclic resolution computes RF; dimension shift, horseshoe.
- Cohomology_HigherDirectImage.tex — push–pull functor laws, CechNerve/CechComplex construction.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for f : X ⟶ S
separated quasi-compact, F quasi-coherent, 𝒰 a finite affine open cover, an iso (weak/Nonempty form)
`(CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F` under `[HasInjectiveResolutions X.Modules]`,
with `higherDirectImage = (pushforward f).rightDerived`. Zero sorry in the cone, zero project axioms.
