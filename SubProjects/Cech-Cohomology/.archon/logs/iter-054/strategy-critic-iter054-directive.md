# Strategy-critic directive — iter-054

Fresh-eyes soundness check of the strategy below. The route (Route A acyclic-resolution
comparison) is unchanged; this iter refreshed only the two ACTIVE P5a row estimates to reflect
that both lanes collapsed to crisp residuals on their first prover pass. Confirm the route is
still sound, and specifically CHALLENGE if the two residuals (the F-valued prepend homotopy for
cechAugmented_exact; the cohomology-presheaf identification 'bridge (1)' for open-immersion
f_*-acyclicity) are mis-scoped or rest on a hidden circularity / missing hypothesis.

## STRATEGY.md (verbatim)
```
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
| P5a-resolution `cechAugmented_exact` (augmented Čech complex is a resolution of F) | ACTIVE | ~1–2 | ~150–250 | whole toSheaf→homologyIsoSheafify→site bridge WIRED axiom-clean (iter-053); ONE residual = F-valued objectwise prepend-`i_fix` homotopy on the section complex `Γ(V,·)` (`V≤coverOpen i`) + a `Homotopy(𝟙)0 ⟹ IsZero homology` Mathlib lemma. | The residual is the SAME categorical↔combinatorial (`mapHomologicalComplex`↔`depDiff`) identification that keeps `CechAcyclic.affine` open — but at the EASIER section/AddCommGrp level (no outer pushforward). Template: FreePresheafComplex objectwise homotopy. |
| P5a-consumer `higherDirectImage_openImmersion_comp` (affine open immersions are f_*-acyclic) | ACTIVE | ~2–3 | ~200–400 | presheaf description (`higher_direct_image_presheaf`, 01XJ) + `affine_serre_vanishing` (done) + P4 acyclic-resolution comparison; `f_* ∘ j_* = (f∘j)_*`. | `isAffineHom_of_affine_separated` done (iter-053). Both tops bottom out on the SHARED **bridge (1)** = cohomology-presheaf identification `(pushforwardResolutionPresheafComplex f I).homology n ≅ V↦Hⁿ(f⁻¹V,G)` (the upstream-deferred hand-off in HigherDirectImagePresheaf.lean) + Serre-transport-to-affine-open + PresheafOfModules.sheafification site lemma. `_comp` return type re-signed `Nonempty(A≅B)`→canonical `A≅B`. |
| P5b comparison assembly | BLOCKED | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity + EnoughInjectives connector. | Final Route-A assembly of the protected goal `cech_computes_higherDirectImage` (line-780 sorry). Gated on P5a. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing push–pull functoriality | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor`, `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal augmentation | none |
| P4 acyclic-resolution lemma (Leray, 015E) | 009 · 6 | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution`, `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift — axiom-clean | decompose-then-build; two-step `cokernel.mapIso`; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails by a mapped-complex term |
| P3 standard-cover Čech vanishing (section form, tilde) | 022 · ~14 | ~1200 | `CechAcyclic.lean` | `sectionCech_affine_vanishing` + `sectionCech_homology_exact` (IsZero homology p≥1) for `F=~M`; L1 tilde-bridge + L3 combinatorial core | accessors DEFEQ (`rfl`); abstract section maps (`set;clear_value`) before `IsLocalizedModule.ext`; target ABSOLUTE section complex | residual qcoh `F≅~ΓF` (01I8) deferred to 02KG consumer; old relative `affine` sorry superseded |
| P3b Čech↔derived bridge bricks | 025 · ~9 | ~1500 | `PresheafCech`,`FreePresheafComplex`,`CechBridge` | `cechFreeComplex_quasiIso` (free resolution of `O_𝒰`), `ses_cech_h1`, `injective_cech_acyclic` (pos-degree Čech vanishing for injectives) — axiom-clean | op-transport via `opFunctor`+`preadditiveYoneda`; `erw`+`.trans` for defeq-carrier mismatch; Route-B arrow-iso transfer | `maxHeartbeats 2000000` needed; LSP-staleness (trust only `lake env lean`) |
| Absolute-cohomology Form B + 01EO general basis criterion | 028 · 3 | ~600 | `AbsoluteCohomology`,`CechToCohomology` | `jShriekOU`=sheafify(free(yoneda U)); H⁰≅Γ (+naturality); 01EO chain L1–L4+top (`cech_eq_cohomology_of_basis`); `BasisCovSystem`/`HasVanishingHigherCech` cover-system encoding | Form B kills restriction-preserves-injectives (injective in 2nd Ext arg); cover-local presheaf form; `attribute [local instance] hasExtModules`; AB4* `Epi(Pi.map)` elementwise | `[EnoughInjectives X.Modules]` absent in Mathlib → carried as explicit hyp (P5a convention); 3 first-attempt iters, no churn |
| 01I8 `F≅~(ΓF)` via section-localization (Route B) | 048 · ~14 (040→048) | ~900 | `QcohTildeSections`,`QcohRestrictBasicOpen` | KEYSTONE `qcoh_section_isLocalizedModule` (ρ_f localizes Γ); Route-B assembly `isIso_fromTildeΓ_of_quasicoherent` ⟹ **unconditional `qcoh_iso_tilde_sections`**; tile chain B0–B4 + `qcoh_section_equalizer` + `isLocalizedModule_of_exact` | sheaf-axiom equalizer (NOT span-cover, which was circular); bundled `restrictScalars`-carrier for two-action tile descent; `change`/defeq for the `↑R`-Semiring diamond; basis-check via `IsCoverDense.iso_of_restrict_iso`+`specBasicOpen` | span-cover descent on global sections is CIRCULAR; tile lemma is NOT `restrict_obj`-rfl; `IsLocalizing`/`isIso_fromTildeΓ_iff_isLocalizing` absent; over-budget (~14 iters vs est ~2) — the single hardest sub-route |
| 02KG affine Serre vanishing (cover-system + tops) | 052 · ~4 (049→052) | ~1100 | `AffineSerreVanishing`,`CechAcyclic` | unconditional `affine_serre_vanishing` + `affine_cech_vanishing_qcoh`; residual `sectionCech_homology_exact_of_localizationAway` (route-B change-of-ring); `affineCoverSystem : BasisCovSystem` | the `private SectionCech*` core is `{R}[CommRing R]`-polymorphic → re-instantiate `dDiff_exact` over `R_f` at module level (no sheaf infra); discharge tops via `_of_tildeVanishing` reshaper | the residual covers a PROPER `D(f)` (cover spans `√f`, not `R`); plan-validate stop-marker/noop traps cost iters 050/051 |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is
(i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic. The P4 abstract lemma
gives `Hⁱ(f_* C•) ≅ Rⁱf_* F` directly — ONE abstract lemma, NO spectral sequences. Acyclicity
input (ii) reduces to affine Serre vanishing `H^q(affine, qcoh)=0`, supplied by the P3b bridge.

### Route SS — two spectral sequences (REJECTED)
Both absent from Mathlib (multi-thousand-LOC); rests on the same `injective_cech_acyclic` brick as A.
(Named "Route SS" to avoid collision with the 01I8-internal "Route B" section-localization route below.)

### The acyclicity bridge (torsor-free, load-bearing)
Route A's acyclicity reduces to affine Serre vanishing `H^q(Spec A, qcoh)=0` (02KG). The honest
non-circular route is the minimal Čech↔derived bridge: (1) `injective_cech_acyclic`, (2)
`ses_cech_h1`, (3) the dimension-shift `cech_eq_cohomology_of_basis` (01EO) consuming the
standard-cover Čech vanishing of P3 as its condition (3). All three bricks of (1)+(2) are done;
01EO is the next target. This breaks the circular regress: P3 produces standard-cover Čech
vanishing; the bridge lifts it to affine sheaf vanishing without ever using affine vanishing.

### `cechAugmented_exact` — sections/sheafification route (P5a resolution input)
The augmented Čech complex is a resolution of `F` (ANY `O_X`-module, ANY open cover; qcoh/affineness
are needed only by the downstream f_*-acyclicity, not by this exactness). Route: reflect `IsZero(Hᵖ)`
through the faithful additive `SheafOfModules.toSheaf` (3-line `IsZero.iff_id_eq_zero`+`map_injective`
helper — `reflects_exact_of_faithful` needs `[Abelian]`, avoid); the homology SHEAF = sheafification of
the presheaf homology (`homologyIsoSheafify`, built); the presheaf homology is **locally zero on the
basis `{V ⊆ some Uᵢ}`** because the restricted cover `{Uₛ∩V}` then has a member `=V`, giving the
cover-agnostic prepend-`i_fix` contracting homotopy (`CombinatorialCech.combHomotopy`/`combHomotopy_spec`,
F-valued objectwise analogue), so its sheafification vanishes via `sheafify_kills_locally_zero` + the
`toSheaf∘sheafify ≅ presheafToSheaf∘forget` square (`PresheafOfModules.sheafificationCompToSheaf`).
DEAD ends: stalk functor (no `SheafOfModules.stalk`); the tilde/standard-cover vanishing as the local
discharger (wrong cover — that's the 02KG tool); the naive "section complex exact over each affine V"
(CIRCULAR = `Ȟᵖ(V,·)`≠0). Analogist: `analogies/tosheaf-reflect.md`.

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
- Chapter cleanup (non-blocking): `lem:qcoh_localized_sections` is circular by the old span-cover
  mechanism but DORMANT (no DAG path to the main theorem); re-route or delete in a future writer pass.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex exactness `0→M→∏M_{f_i}→⋯` (P3) — done via L1+L3 around `exact_of_isLocalized_span`.
- Presheaf-level Čech machinery for `O_X`-modules (P3b free/section complexes, `injective_cech_acyclic`,
  `ses_cech_h1`) — done. Dropped as off-critical-path: presheaf enough-injectives + δ-functor universality.
- Absolute module-valued `Hⁿ(U,F)` = `Ext^p(jShriekOU U, F)` via `Abelian.Ext` (Form B); corepresenting
  object `jShriekOU = sheafify(free(yoneda U))`. NOT a bespoke `j_!` functor (that is absent, 200–500 LOC).
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0` (P5a-consumer, ACTIVE this iter).
- EnoughInjectives connector `HasInjectiveResolutions C → EnoughInjectives C` (~6 LOC, instance) — see
  Open questions; makes the 01EO/02KG cone type-check against the frozen target's weaker hypothesis.
- `cechAugmented_exact` (P5a resolution input): F-valued objectwise prepend-`i_fix` homotopy +
  `homologyIsoSheafify` + `sheafify_kills_locally_zero` + the `toSheaf∘sheafify` square. Detail in
  Routes `### cechAugmented_exact`. ~200–350 LOC.

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve`/`CechComplex`; `AcyclicResolution.lean` (P4); P3b free-presheaf + section Čech complexes,
  `cechFreeComplex_quasiIso`, `injective_cech_acyclic`, `ses_cech_h1`.
- `AbsoluteCohomology.lean`: `jShriekOU`, corepresentability iso, `H^p := Ext^p(jShriekOU U, -)`, H⁰=Γ,
  injective-vanishing + LES wrappers → 01EO `cech_eq_cohomology_of_basis` → 02KG `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.
```

## references/summary.md (index)
```
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
```

## Blueprint chapter titles (one line each)
- Cohomology_AcyclicResolution.tex: \chapter{Acyclic resolutions compute right-derived functors}
- Cohomology_CechHigherDirectImage.tex: \chapter{{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)}
- Cohomology_HigherDirectImage.tex: \chapter{Higher direct images $R^i f_*$ of quasi-coherent sheaves ($i \geq 1$)}

## Project goal (one paragraph)
Prove AlgebraicGeometry.cech_computes_higherDirectImage (Stacks 02KE/01XJ): for f:X→S separated
quasi-compact, F quasi-coherent, 𝒰 a finite affine open cover, the Čech complex computes the
higher direct images — Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F). Zero
inline sorry in the cone, kernel-only axioms.
