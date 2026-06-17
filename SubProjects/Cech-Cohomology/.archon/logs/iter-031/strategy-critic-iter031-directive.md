# strategy-critic directive — iter-031

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (Stacks lemma "Čech computes higher direct
images"): for `f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open
cover of `X`, an isomorphism `Hⁱ(CechComplex f 𝒰 F) ≅ Rⁱf_* F`. Zero inline sorry in the cone of this
protected/frozen target, zero project axioms, kernel-only axioms.

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
| 02KG `affine_serre_vanishing` (affine instantiation) | ACTIVE | ~4 | ~400–650 | family-form free Čech resolution; `SheafOfModules.toSheaf.PreservesEpimorphisms` + `Presheaf.IsLocallySurjective`; 01I8 `F≅~(ΓF)` global generation. | Design fork RESOLVED (cover-agnostic re-param). Residual = `O_X`-epi local surjectivity + 01I8 global generation; re-param ripples into CechBridge (defeq friction). |
| P5a vanishing inputs (consume P3b) | ACTIVE | ~3–4 | ~200–400 | 01XJ leaf done; `Hⁿ(f⁻¹V,G)` Ext-bridge + open-immersion/affine vanishing + augmented-Čech resolution. | Ext-by-injective-resolution-of-2nd-arg backing CONFIRMED present (`InjectiveResolution.extEquivCohomologyClass`). |
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
- 02KG design fork (⊤-vs-`D(f)`) RESOLVED: re-parameterize the free Čech machinery (FreePresheafComplex)
  from `X.OpenCover` to a raw finite family `{ι}[Finite ι](U : ι → Opens X)`, making `injective_cech_acyclic`
  cover-agnostic. Sound: the augmented free resolution is exact stalkwise (simplex chain complex on
  `{i : x∈U_i}`), covering only fixes the identity of `O_𝒰`, never exactness; Mathlib indexes Čech the same
  way (`cechComplexFunctor`). Keep bespoke `cechFreeSimplicial` + `X.OpenCover` wrappers. Rejected
  `D(f)≅Spec R_f`+restrict (re-introduces restriction-of-injectives that Form B exists to avoid).
- 02KG `surj_of_vanishing` route: `ses_cech_h1` + `O_X`-epi local section surjectivity via
  `Presheaf.IsLocallySurjective` (`isLocallySurjective_iff`), gated on one gap-fill
  `SheafOfModules.toSheaf.PreservesEpimorphisms`; refine the lift cover to affine opens
  (`Scheme.isBasis_affineOpens`) to land a standard cover in `Cov`.
- General-qcoh `F≅~(ΓF)` (01I8) globalisation: CONDITIONAL + presentation forms landed; steps (2)–(3)
  formalised (`isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`,
  `free_isQuasicoherent`). Residual = the instance `[IsQuasicoherent F]→IsIso F.fromTildeΓ`. mathlib-analogist
  `o1i8route` (iter-031) decisively chose **Route P (global generation, Hartshorne II.5.14–17 / Stacks 01I8)**
  and REJECTED Route G (module gluing: no `Module.GlueData` in Mathlib, effective FF descent is a Mathlib TODO).
  Decomposed into the `\uses`-chain P0–P4 (`rem:o1i8_decomposition`): P0 `exists_finite_basicOpen_subcover`
  (pure topology, axiom-clean-able now) → P1 `qcoh_localized_sections` (`Γ(D(f),F)=Γ(X,F)_f`, GAP, load-bearing)
  → P2 `qcoh_global_generation` → P3 `qcoh_kernel_qcoh` (needs sub-gap `tilde_preserves_kernels`) → P4
  `isIso_fromTildeΓ_of_quasicoherent` (= feed P2+P3 to the done `isIso_fromTildeΓ_of_genSections`).
  ~few-hundred LOC; no Mathlib shortcut (analogist confirmed essImage/global-presentation both dead-end at P1).

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
- `SheafOfModules.toSheaf.PreservesEpimorphisms` (epi of `O_X`-modules ⇒ epi of underlying abelian sheaf) —
  small project-local instance unlocking `Presheaf.IsLocallySurjective` for `surj_of_vanishing`.
- 01I8 instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ` via Route P (global generation): P1
  `qcoh_localized_sections` (`Γ(D(f),F)=Γ(X,F)_f`), P3 sub-gap `tilde_preserves_kernels`
  (`PreservesFiniteLimits` of `~`, absent in Mathlib). ~few-hundred LOC.

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

## Blueprint chapters (titles + one-line topic)
- `Cohomology_CechHigherDirectImage.tex` — CONSOLIDATED chapter covering all 10 Cohomology files: P3/P3b
  Čech machinery (free + section complexes, `injective_cech_acyclic`, `ses_cech_h1`), absolute cohomology
  Form B (`Ext^p(jShriekOU U, -)`), 01EO basis comparison (`cech_eq_cohomology_of_basis`), 02KG affine
  Serre vanishing, and the Route-P 01I8 decomposition `F≅~(ΓF)` (P0–P4 chain).
- `Cohomology_AcyclicResolution.tex` — P4 Leray acyclic-resolution lemma (Stacks 015E).
- `Cohomology_HigherDirectImage.tex` — push–pull functor, CechNerve/CechComplex (P1/P2).

## Focus question for this dispatch
STRATEGY.md changed since iter-030 ONLY in the 01I8 open-question bullet + the Mathlib-gaps bullet: it now
records the **Route P (global generation)** decomposition (P0–P4 chain) for the missing instance
`[IsQuasicoherent F] → IsIso F.fromTildeΓ`, selected by a mathlib-analogist consult that REJECTED Route G
(module gluing — no `Module.GlueData` in Mathlib, FF descent is a Mathlib TODO). Confirm: (a) Route A
(acyclic-resolution comparison) core is still sound; (b) the Route-P decomposition for 01I8 is a sound,
non-circular path that actually discharges what 02KG/02KE consume; (c) no missing prerequisite or hidden
circularity in the P0→P1→P2→P3→P4 ordering. Iter-030 verdict was SOUND with no live challenge.
