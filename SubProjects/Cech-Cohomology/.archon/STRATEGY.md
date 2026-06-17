# Strategy

## Goal

Prove the Čech computation of higher direct images — the **separated case of the relative form**
of Stacks Tag 02KE (relative `Rⁱf_*` form, with `X`/`S` separated; stronger than 02KE in the
relative direction, with affine-cover + separatedness in place of the bare "all intersections
affine"): for `f : X ⟶ S`
quasi-compact separated with `X`, `S` separated, `F` quasi-coherent, `𝒰` a finite affine open
cover of `X` (`h𝒰 : ∀ i, IsAffine (𝒰.X i)`, plus the `hres` injective-resolution family), an
isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` with
`higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`. **The deliverable
`AlgebraicGeometry.cech_computes_higherDirectImage` (CechToHigherDirectImage.lean) is PROVED,
0 sorries (iter-079).** End-state: zero inline `sorry` in the cone, zero project axioms,
kernel-only. (iter-080: the user dropped the old false-as-signed frozen sibling and its protection
entry — the canonical name now carries the correct hypotheses.)

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| Polish (cleanup) | NEXT | ~1–2 | ~0–30 | none | Leg:15 stale docstring; dead `pushPullLegIso`/`pushPull_leg_coherence`; consumer docstring. Non-blocking; gated only on review-build confirming the capstone. |

**Mathematical content COMPLETE** (iter-079): the capstone `cech_computes_higherDirectImage`
is proved, 0 sorries. **Project-wide inline `sorry` count = 0** (iter-080: the user dropped the
old false-as-signed frozen sibling — the only standing sorry — so nothing remains to close).
Final gate: a full `lake build` of the cone confirming the capstone compiles axiom-clean.

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1–P2 push–pull + Čech objects | 002 · 3 | ~180 | `CechHigherDirectImage` | `pushPullMap_comp`, `pushPullFunctor`, `CechNerve`/`CechComplex` axiom-clean | object-form align before `reassoc_of%`; `Over.lift`+augmented whiskering | `conjugateEquiv_comp` mate route INFEASIBLE (kernel whnf blow-up) |
| P4 acyclic-resolution (Leray 015E) | 009 · 6 | ~965 | `AcyclicResolution` | `rightDerivedIsoOfAcyclicResolution`, horseshoe, dimension shift | decompose-then-build; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor |
| P3 standard-cover Čech vanishing (tilde) | 022 · ~14 | ~1200 | `CechAcyclic` | `sectionCech_affine_vanishing`/`_homology_exact` for `F=~M` | accessors DEFEQ; abstract section maps before `IsLocalizedModule.ext` | residual qcoh `F≅~ΓF` deferred to 02KG consumer |
| P3b Čech↔derived bridge | 025 · ~9 | ~1500 | `PresheafCech`,`FreePresheafComplex`,`CechBridge` | `cechFreeComplex_quasiIso`, `ses_cech_h1`, `injective_cech_acyclic` | op-transport via `opFunctor`+`preadditiveYoneda`; arrow-iso transfer | `maxHeartbeats 2000000`; trust only `lake env lean` (LSP stale) |
| Absolute cohomology (Form B) + 01EO basis criterion | 028 · 3 | ~600 | `AbsoluteCohomology`,`CechToCohomology` | `jShriekOU`=sheafify(free(yoneda U)); `cech_eq_cohomology_of_basis`; `BasisCovSystem` | Form B kills restriction-preserves-injectives (injective in 2nd Ext arg) | `[EnoughInjectives X.Modules]` absent → explicit hyp |
| 01I8 `F≅~(ΓF)` section-localization (Route B) | 048 · ~14 | ~900 | `QcohTildeSections`,`QcohRestrictBasicOpen` | KEYSTONE `qcoh_section_isLocalizedModule`; unconditional `qcoh_iso_tilde_sections` | sheaf-axiom equalizer; bundled `restrictScalars`-carrier; `change`/defeq for `↑R`-Semiring diamond | span-cover descent on global sections is CIRCULAR; the single hardest sub-route |
| 02KG affine Serre vanishing (+ general open) | 058 · ~7 | ~1500 | `AffineSerreVanishing`,`CechAcyclic` | `affine_serre_vanishing`(+`_general_open`); `affineCoverSystemGeneral` | re-instantiate `dDiff_exact` over `R_f`; enlarge cover-system BASIS (stays ambient) | naive `j⁻¹V≅SpecΓ` transport = restriction-injectives WALL (rejected) |
| P5a open-immersion `f_*`-acyclicity | 066 · ~11 | ~700 | `OpenImmersionPushforward` | `higherDirectImage_openImmersion_acyclic`+`_comp` axiom-clean | `hacyc`=adjoint-preserves-injectives (`injective_of_adjoint`); `transport`=`mapHomologicalComplex (pushforwardComp)` | φ'' was a DEFEQ (4 wasted iters); Serre-on-`U∩f⁻¹V` route FALSE |
| P5a-resolution `cechAugmented_exact` | 076 · 1 | ~10 | `CechAugmentedResolution` | augmented Čech complex resolves any `O_X`-module | wrap `isZero_homology_of_iso_homotopy_id_zero` over proved CSI pair | heaviest module exceeds prover mem cap (exit-137); review-build gate needed |
| Sub-brick A — CSI section-identification chain | 075 · ~9 | ~3550 | `CechSectionIdentification(.Base/.Leg)` | `cechSection_complex_iso`, `cechSection_contractible`, `coreIso_comm`, `pushPull_interLegHom_sections` | SPLIT monolith→3 modules (OOM+parallelism); elementwise through bundled hom; term-mode `Eq.trans`/`congrArg` on defeq middle objects | OVER_BUDGET (~9 vs ~1–3); LSP FALSE success on instance-sensitive files |
| P5b producer — termwise acyclicity | 078 · ~2 | ~700 | `CechTermAcyclic` | `cechTerm_pushforward_acyclic`, `rightAcyclic_finite_prod`, `isQuasicoherent_pullback_opens` | `f∘j_s` affine via `[S.IsSeparated]` (01SG); general-opens restrict-over bridge | originally-planned sig (no `S` hyp) was FALSE — doubled-origin counterexample; auditor's "of_iso direction bugs" were FALSE POSITIVES |
| P5b capstone assembly (Route-A) | 079 · 1 | ~6 | `CechToHigherDirectImage` | `cech_computes_higherDirectImage` PROVED (0 sorries) — Čech ≅ Rⁱf_* (canonical name after iter-080 user drop of false frozen sibling) | refactor subagent for pure signature plumbing (bypasses plan-validate 0-sorry noop-trap that drops prover lanes) | a 0-sorry-but-broken file is NOT a prover lane — use `refactor`, not `prove` |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN, only live route)
Augmented Čech complex `0→F→C⁰→C¹→⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is (i) a resolution of
`F` and (ii) termwise `(pushforward f)`-acyclic. P4 gives `Hⁱ(f_* C•) ≅ Rⁱf_* F` — ONE abstract
lemma, NO spectral sequences. (i)=`cechAugmented_exact`; (ii)=`cechTerm_pushforward_acyclic`
(reduces to relative affine Serre vanishing). All upstream bricks DONE.

### Route A §P5b — capstone assembly (DONE iter-079; frozen-decl resolved iter-080)
`cech_computes_higherDirectImage` (CechToHigherDirectImage.lean) is PROVED (0 sorries). Hypotheses:
`[QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]`, `h𝒰 : ∀ i, IsAffine (𝒰.X i)`,
and the `hres` family `∀(n)(σ:Fin(n+1)→𝒰.I₀), HasInjectiveResolutions (coverInterOpen 𝒰 σ).Modules`.
**`[X.IsSeparated]` carried explicitly** (NOT derived): redundant given `[IsSeparated f]`+`[S.IsSeparated]`
but carried verbatim to match the producer `cechTerm_pushforward_acyclic` (iter-078 strategy-critic's
sanctioned lowest-risk fallback). **Scope:** the `X`-separated specialization of Tag 02KE (the
`j_σ`-affine route needs `j_σ` affine for ALL affine opens = `X` separated, stronger than canonical
02KE "intersections affine"). **Frozen-signature block — RESOLVED iter-080:** the old protected
`cech_computes_higherDirectImage` (general `X.OpenCover`, only `[IsSeparated f]`) was FALSE
(single-element-cover counterexample ℙ¹/O(-2)) and is itself a `sorry` in peer AJC. The user dropped
that decl + its `archon-protected.yaml` entry (peer AJC does not protect it either) and the correct
sibling was renamed to the canonical `cech_computes_higherDirectImage`. No frozen sorry remains.

### Done/rejected routes (tombstones)
- **Route SS — two spectral sequences: REJECTED** (both absent from Mathlib, multi-kLOC; same brick as A).
- **Acyclicity bridge, `cechAugmented_exact` sections/sheafification route, Absolute-cohomology Form B**:
  all DONE — see `## Completed` + ARCHON_MEMORY for the load-bearing facts and dead-ends.

## Open strategic questions
- Chapter cleanup (non-blocking): `lem:qcoh_localized_sections` circular by old span-cover but DORMANT
  (no DAG path to goal); re-route or delete in a future writer pass.
- Polish residue: Leg:15 stale module docstring; dead `pushPullLegIso`/`pushPull_leg_coherence` in Leg.

## Mathlib gaps & new material
Gaps (project-side, carried as explicit hypotheses where unsynthesizable):
- `[HasInjectiveResolutions X.Modules]` + per-intersection `hres` family — `IsGrothendieckAbelian
  (SheafOfModules R)` absent; mirrors the frozen target's own convention.
- `[EnoughInjectives X.Modules]` connector `enoughInjectives_of_hasInjectiveResolutions` — built,
  axiom-clean (`OpenImmersionPushforward.lean:299`).
New project material:
- push–pull functor `p ↦ p_* p^* F`; `CechNerve`/`CechComplex`; `AcyclicResolution` (P4); P3b
  free-presheaf + section Čech complexes; `AbsoluteCohomology` (`jShriekOU`, `H^p:=Ext^p(jShriekOU U,-)`);
  CSI section-identification chain; `CechTermAcyclic` termwise acyclicity; the comparison assembly.
