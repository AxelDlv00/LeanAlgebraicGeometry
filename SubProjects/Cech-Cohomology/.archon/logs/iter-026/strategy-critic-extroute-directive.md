# Directive: fresh-context strategy audit (iter-026)

Render an unbiased verdict on whether the strategy below is sound and well-formatted against its
canonical skeleton. Focus this iter on ONE freshly-sharpened question (see end), but audit the whole.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for
`f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover of `X`,
an isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` where
`higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`. End-state: zero `sorry` in the
cone, zero project axioms. Extracted from the Algebraic-Jacobian challenge.

## Current STRATEGY.md (verbatim)
```markdown
# Strategy

## Goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected, frozen-signature target: for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, and `𝒰` a finite affine open cover of `X`, an isomorphism in the weak
existence form `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero
project axioms, kernel-only axioms. Extraction from the Algebraic-Jacobian challenge; the
downstream Picard/Quot machinery is out of scope and was carved away.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3b Čech↔derived bridge (torsor-free) → `affine_serre_vanishing` | ACTIVE | ~3–5 | ~200–450 | `Abelian.Ext` (LES + injective vanishing off-the-shelf); `Scheme.Modules.restrictFunctor` (sections over `U`); **restriction-preserves-injectives** (NEW gap, j_! absent). | **All 3 bridge bricks DONE** (`cechFreeComplex_quasiIso` iter-024, `ses_cech_h1` iter-024, `injective_cech_acyclic` iter-025 axiom-clean). Next = scaffold `def:absolute_cohomology` (**Ext-Form-A** `Ext^p_{O_U}(O_U,F\|_U)`, decided iter-026 — Form B `Ext(j_!O_U,F)` UNBUILDABLE, `j_!` verified absent from Mathlib) + H⁰=Γ; then 01EO (`cech_eq_cohomology_of_basis`, effort ~3.5k, dim-shift via Ext LES) → `affine_serre_vanishing` (02KG). Form A's price: the 01EO injective-vanishing step needs `I\|_U` injective (restriction-preserves-injectives) — a NEW obligation under analogist investigation. |
| P5a vanishing inputs (consume P3b) | ACTIVE | ~3–4 | ~200–400 | 01XJ LEAF done in **resolution form** (`homologyIsoSheafify` engine + `higherDirectImage_iso_sheafify_presheafHomology`, iter-018, axiom-clean); remaining = the absolute-`Hⁿ(f⁻¹V,G)` bridge (now Ext-realized) + open-immersion/affine vanishing (consume `affine_serre_vanishing`) + augmented-Čech resolution. | Absolute `Hⁿ(open,G)` realization DECIDED iter-025 = `Abelian.Ext` (Route β `Sheaf.H` REFUTED — absent from Mathlib; `Functor.rightDerived` has no LES). `analogies/absolute-cohomology.md`. |
| P5b comparison assembly | BLOCKED | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity. | Final Route-A assembly of the protected goal. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing the push–pull functoriality cone | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor` (G), `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal-object augmentation | none |
| P4 acyclic-resolution lemma (Leray, Stacks 015E) | 009 · 6 (004–009) | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution` (RⁿG ≅ Hⁿ(G K•)), `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift, cosyzygy layer — axiom-clean | decompose-then-build cadence; two-step `cokernel.mapIso` for non-syntactic homology naturality; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails beside a mapped-complex term |
| P3 standard-cover Čech vanishing — **section-complex form** (tilde case) | 022 · ~14 | ~1200 | `CechAcyclic.lean` | `sectionCech_affine_vanishing` + `sectionCech_homology_exact` (IsZero homology, p≥1) for `F=~M`; L1 tilde-bridge (`phiL`/`phi`=`IsLocalizedModule.iso`, ladder `of_ladder_addEquiv_of_exact`) + L3 combinatorial core | accessor-1(`toPresheafOfModules`-Ab)↔accessor-2(`tilde.toOpen`) are DEFEQ (`rfl`) — build φ_σ directly; abstract heavy section maps (`set;clear_value`) before `IsLocalizedModule.ext` to dodge `whnf` timeout; target ABSOLUTE section complex not relative pushforward | residual general-qcoh `F≅~(ΓF)` (01I8) globalisation deferred to the 02KG consumer, NOT a P3 blocker; the old relative-form `CechAcyclic.affine` sorry is superseded/authorized |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is
(i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic. The P4 abstract lemma
"a `G`-acyclic resolution computes `G.rightDerived`" then gives `Hⁱ(f_* C•) ≅ Rⁱf_* F`
directly — ONE abstract lemma, NO spectral sequences. The standard Cartan–Leray acyclic-cover
existence proof. Its acyclicity input (ii) reduces to affine Serre vanishing
`H^q(affine, qcoh)=0`, which is NOT free: see the bridge below.

### Route B — two spectral sequences (REJECTED, fallback only)
Čech-to-derived + Leray spectral sequences for `Scheme.Modules`. Rejected: both absent from
Mathlib (multi-thousand-LOC), and Leray needs quasi-coherence of `R^q f_* F`. Strictly heavier
than Route A for the same `Nonempty (…≅…)` goal. NOTE: Route B rests on the SAME irreducible
brick `injective_cech_acyclic` as Route A — rejecting B does not escape it. Fallback only.

### The acyclicity bridge (load-bearing, CORRECTED)
Route A's term-/relative-acyclicity inputs and the general-cover intersection vanishing all
reduce to affine Serre vanishing `H^q(Spec A, qcoh)=0` (Stacks 02KG). This is NOT obtainable
from the P3 contracting homotopy alone: the homotopy proves the Čech *complex* is exact (a
resolution), but term `G`-acyclicity is itself affine vanishing on a smaller affine — a circular
regress with no inductive base. The honest route (Stacks, torsor-free) is the minimal
Čech↔derived bridge P3b: (1) injective `O_X`-modules are Čech-acyclic
(`injective_cech_acyclic`); (2) `ses_cech_h1`; (3) the dimension-shift `cech_vanish_basis` (01EO)
consuming the standard-cover Čech vanishing of P3 as its condition (3). This yields
`affine_serre_vanishing` legitimately, breaking the cycle: P3 produces standard-cover Čech
vanishing; P3b lifts it to affine sheaf vanishing without ever using affine vanishing as an input.

**Direct route for (1)**: `injective_cech_acyclic` does NOT
need presheaf enough-injectives or the δ-functor universality. Two aligned parts: (a) injective
sheaf ⟹ injective presheaf via `Injective.injective_of_adjoint` applied to the
`Mod ↪ PMod` right adjoint (`sheafificationAdjunction`); (b) the free-presheaf complex
`K(𝒰)_• = ⨁ free(yoneda U_…)` resolves `O_𝒰` (objectwise contracting homotopy) and
`Hom(K_•,F) = Č•(𝒰,F)` (section complex) via `freeAdjunction`+Yoneda — so for injective `I`,
`Hom(-,I)` exact gives positive Čech vanishing. This BYPASSES the two expensive bricks
(`presheafModules_enoughInjectives`, `cech_delta_functor_presheaves` — both off the critical path,
dropped from the blueprint). The free-presheaf complex uses Mathlib's `PresheafOfModules.free`, NOT
a bespoke `j_!`. The FULL Stacks-01EO bootstrap (torsor `lemma-cech-h1`, `lemma-kill-cohomology-class`)
remains avoidable; only the injective-acyclicity brick is irreducible.

## Open strategic questions

- **P5a re-sign (DECIDED; the LEAF node only)**: `lem:higher_direct_image_presheaf` is re-signed to the
  **resolution form** already proved (`higherDirectImage_iso_sheafify_presheafHomology`:
  `Rⁿf_*G ≅ sheafify(V↦Hⁿ((f_*I^•)(V)))` for an injective resolution `I`), backed by the reusable 01XJ
  engine `PresheafOfModules.homologyIsoSheafify`. This is the correct Lean target for the LEAF.
  **It does NOT eliminate the absolute-cohomology obligation — it relocates it** (strategy-critic
  iter-019): the downstream consumers `open_immersion_pushforward_comp` and `cech_term_pushforward_acyclic`
  feed `affine_serre_vanishing`, which is *stated* with the absolute `Hᵏ(f⁻¹V,G)`, so they still need the
  last-mile bridge `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V,G)` (restricted injective resolution computes absolute
  cohomology of `f⁻¹V`). That bridge is a deferred obligation, due when those consumers are dispatched
  (gated on `affine_serre_vanishing`), NOT a thing the leaf supplies.
- **DECIDED (iter-025): absolute `Hⁿ(U,F) := Ext^p(𝒪_U, F|_U)` via Mathlib `CategoryTheory.Abelian.Ext`.**
  The mathlib-analogist (`analogies/absolute-cohomology.md`) REFUTED the suspected `CategoryTheory.Sheaf.H`
  route — no AddCommGrp-valued sheaf cohomology exists in Mathlib. Plain `Functor.rightDerived` has
  injective vanishing but NO LES. `Abelian.Ext` is the ONLY route with the load-bearing 01EO LES
  off-the-shelf: `Ext.covariant_sequence_exact₁/₂/₃` (covariant LES at fixed first arg `𝒪_U`),
  `Ext.eq_zero_of_injective` (`Hⁿ(U,I)=0`, needs only the 2nd arg injective), `Ext.homEquiv₀` (`H⁰=Γ`),
  `HasExt.standard` (unconditional). Blueprint `def:absolute_cohomology` + 6 `\mathlibok` anchors added
  iter-025. Reversal signal: Ext universe/smallness bookkeeping over `SheafOfModules` proves painful →
  fall back to Route γ (Čech colimit `Hᵖ := colim_𝒰 Ȟᵖ`), NEVER Route β.
- **DECIDED (iter-026): the Ext form is Form A `Ext^p_{Mod(O_U)}(O_U, F|_U)` via `restrictFunctor`.**
  `j_!` (extension-by-zero, left adjoint to `restrictFunctor`) is **verified ABSENT from Mathlib**
  (loogle `_ ⊣ restrictFunctor _` empty), so Form B `Ext^p_{Mod(O_X)}(j_!O_U, F)` is unbuildable
  off-the-shelf. Consequence: the 01EO injective-vanishing step `H^n(U,I)=0` becomes
  `Ext^n_{O_U}(O_U, I|_U)=0`, which needs `I|_U` injective — i.e. **restriction along an open
  immersion preserves injectives** (NEW obligation; the iter-025 analogist's "open_immersion_pushforward_comp
  provides it" was incorrect — that lemma is relative affine vanishing R^q j_*=0). Cheapest route under
  analogist investigation iter-026; def + H⁰=Γ scaffold is independent of this and proceeds first.
- **P3 re-sign (DECIDED, strategy-critic-confirmed)**: `cech_acyclic_affine` targets the **absolute
  section Čech complex** `sectionCechComplex` on `Spec R` (not the relative `CechComplex f 𝒰 F`). The
  outer `pushforward f` is a right adjoint that does not preserve homology, and affine-pushforward
  exactness is absent from Mathlib (a 3rd from-scratch brick). The Stacks 01EO/02KG route that consumes
  `cech_acyclic_affine` is always absolute; the relative complex's acyclicity (P5b) is supplied via
  `affine_serre_vanishing` + `cech_term_pushforward_acyclic` (P5a), never via `cech_acyclic_affine`.
  Analysis: `analogies/l1-bridge.md`.
- P3 exactness: `exact_of_isLocalized_span` (`Mathlib.RingTheory.LocalProperties.Exactness`) — localise
  at spanning elements `Away (s_r)`, node-by-node `Function.Exact`, close with the done
  `CombinatorialCech.Dependent.depDiff_exact`. L1 now decomposed into two sub-lanes:
  `def:qcoh_sections_localized` (`F(D(g))=M_g` via qcoh `F≅tilde(ΓF)` globalisation, Stacks 01I8) +
  `lem:section_cech_homology_exact` (`IsZero homology ↔ Function.Exact` via
  `exactAt_iff_isZero_homology`+`moduleCat_exact_iff` + the categorical↔module term/differential id).
- P3b statement shape: prove the genuine basis criterion (`cech_vanish_basis`, 01EO) via the
  bridge, NOT the circular acyclic-resolution shortcut. Its `\uses` is
  `{injective_cech_acyclic, ses_cech_h1, cech_acyclic_affine}` and explicitly NOT
  `affine_serre_vanishing` (which depends on it). Decide whether to keep the general ringed-space
  statement or narrow to the affine/standard-cover instance — either is acceptable if non-circular.
- P3b scope guard: build the MINIMAL torsor-free bridge only. Do NOT formalize `lemma-cech-h1`
  (torsor H¹) or `lemma-kill-cohomology-class`; the dimension-shift route (`cech_vanish` /
  `cech_vanish_basis`) needs only `injective_cech_acyclic` + `ses_cech_h1`.
- File-split for parallelism (standing directive): the consolidated source is split into
  `CechAcyclic.lean` (P3), `PresheafCech.lean` (P3b section side), `FreePresheafComplex.lean` (P3b
  free side), `CechBridge.lean` (P3b assembly), `HigherDirectImagePresheaf.lean` (P3-independent 01XJ
  leaf + P5a vanishing inputs), and `CechHigherDirectImage.lean` (P1/P2 push–pull + Čech machinery +
  frozen P5b assembly), each a parallel prover lane under one `% archon:covers`.
  `cech_computes_higherDirectImage` signature + path frozen.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex exactness `0→M→∏M_{f_i}→⋯` (P3) — Mathlib has only the H⁰/H¹
  equalizer (`IsSheafEqualizerProducts`); assemble L1+L3 around `exact_of_isLocalized_span`.
- Presheaf-level Čech machinery for `O_X`-modules (P3b): the free-presheaf complex
  `K(𝒰)_• = ⨁ free(yoneda U_…)` (via Mathlib `PresheafOfModules.free`+`yoneda`, NOT a bespoke `j_!`),
  its `Hom(K_•,F)=Č•(𝒰,F)` identification (section Čech complex, distinct from the relative
  `CechComplex`), the objectwise contracting homotopy, `injective_cech_acyclic` (via
  `Injective.injective_of_adjoint`), `ses_cech_h1`, `cech_vanish_basis`. Mathlib has the building
  blocks (`PresheafOfModules`, `free`/`freeAdjunction`, `evaluation`, `sheafificationAdjunction`,
  `injective_of_adjoint`) but NOT the assembled Čech complex/exactness. DROPPED as off-critical-path:
  presheaf enough-injectives + δ-functor universality (no `IsGrothendieckAbelian (PresheafOfModules)`,
  no functor-category transfer, no AB5 — all expensive and unnecessary for `injective_cech_acyclic`).
- `R^if_*` = sheafify of objectwise presheaf-homology for `Scheme.Modules` (P5a) — BUILT iter-018 in
  resolution form (`homologyIsoSheafify` engine + `higherDirectImage_iso_sheafify_presheafHomology`,
  axiom-clean). Absolute module-valued `Hⁿ(U,F)` — realize as `Ext^p(𝒪_U, F|_U)` via Mathlib
  `Abelian.Ext` (DECIDED iter-025; LES + injective-vanishing off-the-shelf). NOT a bespoke build.
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0`, `R^i(affine)_*=0` (P5).
- **Restriction-preserves-injectives** for an open immersion `j` on `Scheme.Modules` (`I` injective ⟹
  `restrictFunctor j (I)` injective). Needed for 01EO injective-vanishing under Ext-Form-A. Mathlib has
  `restrictAdjunction : restrictFunctor ⊣ pushforward` (wrong direction for injectives) but NOT `j_!`.
  Route TBD (build `j_!` exact, or a bespoke Hom-exactness argument); analogist iter-026.

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve` / `CechComplex` / `CechAcyclic.affine` (standard-cover bundle).
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison (P4, done).
- P3b bridge: free-presheaf complex `cechFreePresheafComplex` + section Čech complex +
  `cechComplex_hom_identification` + `cechFreeComplex_quasiIso` + `injective_cech_acyclic` +
  `ses_cech_h1` + `cech_vanish_basis` → `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.
```

## references/summary.md (reference index)
```markdown
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
```

## Blueprint chapters (title + one-line topic)
- `Cohomology_AcyclicResolution.tex` — Acyclic resolutions compute right-derived functors (Leray, Stacks 015E; P4, done).
- `Cohomology_HigherDirectImage.tex` — Higher direct images R^i f_* of quasi-coherent sheaves, i>=1 (definitions; done).
- `Cohomology_CechHigherDirectImage.tex` — Čech computation of R^i f_* (the main consolidated chapter: Čech nerve/complex,
  affine acyclicity, the P3b Čech<->derived bridge injective_cech_acyclic/ses_cech_h1/free-presheaf resolution, the
  Ext-based absolute cohomology def:absolute_cohomology, 01EO basis-comparison, 02KG Serre vanishing, and the frozen
  P5b comparison assembly).

## The sharpened question for this iter
The strategy commits to realizing absolute sheaf cohomology H^p(U,F) as Abelian.Ext (Ext route),
and now (iter-026) pins **Form A** Ext^p_{Mod(O_U)}(O_U, F|_U) because j_! (extension-by-zero) is
verified ABSENT from Mathlib, making Form B unbuildable. BUT Form A pushes a NEW obligation:
"restriction along an open immersion preserves injectives" (I|_U injective when I injective), whose
standard proof ALSO uses j_!. So the route chosen to AVOID building infrastructure may still
force building j_! (or an equivalent). The two non-Ext alternatives: Functor.rightDerived
(injective vanishing free, but NO long-exact-sequence in Mathlib — the 01EO dimension shift NEEDS the LES)
and a Čech-colimit H^p := colim_𝒰 Ȟ^p (Route γ, reuses project Čech infra but reproves 01EO by hand).

Challenge specifically: given j_! may be unavoidable under Ext-Form-A, is the Ext route still the
soundest choice for the remaining ~3–5 iters, or does the new constraint tip the balance toward Route γ
(Čech-colimit, which never needs j_! or restriction-preserves-injectives — the LES comes from a SES of
Čech complexes + colimit exactness, and ses_cech_h1/injective_cech_acyclic are already in hand)?
Weigh: under Ext-Form-A remaining bricks = {build j_! OR restriction-preserves-injectives directly,
H⁰=Γ plumbing, instantiate off-the-shelf Ext LES + injective vanishing, 01EO, 02KG}; under Route γ
= {SES-of-Čech-complexes LES via ShortComplex/HomologicalComplex homology sequence + filtered-colimit
exactness, restate 01EO/02KG in colim-Čech form}. Render SOUND / CHALLENGE / REJECT with reasoning.
Also audit STRATEGY.md formatting against the canonical skeleton (bounded tables, no per-iter narrative).
