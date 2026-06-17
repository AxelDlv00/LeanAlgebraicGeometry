# Strategy-critic directive — iter-018

You are a fresh-context critic of this project's global strategy. Judge it as a
mathematician seeing it for the first time. You have NO access to iter-by-iter
history; that is by design. Render a verdict (SOUND / CHALLENGE / REJECT) on the
strategy and audit STRATEGY.md against its canonical skeleton.

## Project goal (one paragraph)

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (blueprint
`lem:cech_computes_cohomology`): for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, `𝒰` a finite affine open cover of `X`, an isomorphism (weak/`Nonempty`
form) `(CechComplex f 𝒰 F).homology i ≅ ((pushforward f).rightDerived i).obj F`. This is
the Čech computation of higher direct images of quasi-coherent sheaves. End state: zero
inline `sorry` in the cone of that protected theorem, zero project axioms.

## Specific question I most need adjudicated

A recent route decision ("Q4") re-stated the central standard-cover Čech-vanishing
lemma `lem:cech_acyclic_affine` to target the **absolute section Čech complex**
`sectionCechComplex` on `Spec R` (a `CochainComplex Ab`, intrinsic to `Spec R`, no
relative morphism `f`, no pushforward) — INSTEAD of the relative pushforward complex
`CechComplex f 𝒰 F`. The stated reason: the outer `pushforward f` is a right adjoint
that does not preserve homology, and affine-pushforward exactness is absent from Mathlib,
so the relative form is not reducible to module exactness via localisation; whereas the
Stacks 01EO/02KG comparison route that consumes this lemma is always phrased on the
absolute section complex anyway, and the relative complex's acyclicity (needed at the
final P5b assembly) is supplied separately via `affine_serre_vanishing` +
`cech_term_pushforward_acyclic` (P5a). Please scrutinise: (a) is targeting the absolute
section complex sound and non-circular; (b) does the downstream cone (01EO basis
comparison → 02KG Serre vanishing → P5b assembly) genuinely consume the absolute form,
so the re-sign does not leave a gap; (c) is the separate P5a supply of relative-complex
acyclicity the right decomposition, or is there a simpler route. Cross-check against the
Stacks tags named in the references below.

## Inputs

### STRATEGY.md (verbatim)

```
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
| P3 standard-cover Čech vanishing — **section-complex form** (`sectionCech_affine_vanishing`) | ACTIVE | ~4–6 | ~400–600 | `exact_of_isLocalized_span`, `IsLocalizedModule (.powers g) (tilde.toOpen …)`, `exactAt_iff_isZero_homology`, `moduleCat_exact_iff` (all native). L3 done. | iter-017 Q4 re-sign: target the ABSOLUTE section complex `sectionCechComplex` (NOT relative pushforward — affine-pushforward exactness absent). L1 = 2 from-scratch sub-lanes: qcoh `F≅tilde(ΓF)` globalisation (01I8, ~150) + categorical↔module homology id (~250–400). |
| P3b Čech↔derived bridge (torsor-free) → `affine_serre_vanishing` | ACTIVE | ~4–7 | ~350–650 | `PresheafOfModules.{free,evaluation,unit,sheafificationAdjunction}`, `injective_of_adjoint`, `alternating{Coface,Face}MapComplex` — all native; direct injective-acyclicity route needs NO presheaf enough-injectives. | section+free complexes DONE (iter-016); in flight: `cechFreeComplex_quasiIso` (O_𝒰 + homotopy), `cechComplex_hom_identification` (Ab). Then `injective_cech_acyclic`/`ses_cech_h1`/`cech_vanish_basis`. |
| P5a vanishing inputs (consume P3b) | NEXT | ~3–5 | ~250–500 | `R^if_*=sheafify(V↦H^i(f⁻¹V))` (01XJ) — route CONFIRMED feasible (analogist `p5a`, `analogies/p5a.md`); augmented-Čech resolution; open-immersion/affine vanishing. | All decls absent from Lean; `higher_direct_image_presheaf` (01XJ) is P3/P3b-independent — parallel lane opens next iter. |
| P5b comparison assembly | BLOCKED | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity. | Final Route-A assembly of the protected goal. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing the push–pull functoriality cone | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor` (G), `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal-object augmentation | none |
| P4 acyclic-resolution lemma (Leray, Stacks 015E) | 009 · 6 (004–009) | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution` (RⁿG ≅ Hⁿ(G K•)), `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift, cosyzygy layer — axiom-clean | decompose-then-build cadence; two-step `cokernel.mapIso` for non-syntactic homology naturality; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails beside a mapped-complex term |

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

**Direct route for (1)** (analogist `p3b-presheafcech`, iter-011): `injective_cech_acyclic` does NOT
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

- **P3 re-sign DECIDED (iter-017, Q4)**: `cech_acyclic_affine` targets the **absolute section Čech
  complex** `sectionCechComplex` on `Spec R` (NOT the relative `CechComplex f 𝒰 F`). Reason: the outer
  `pushforward f` is a right adjoint that does not preserve homology, and affine-pushforward exactness
  is absent from Mathlib (would be a 3rd from-scratch brick). The Stacks 01EO/02KG route that consumes
  `cech_acyclic_affine` is ALWAYS absolute; the relative complex's acyclicity (P5b) is supplied via
  `affine_serre_vanishing` + `cech_term_pushforward_acyclic` (P5a), never via `cech_acyclic_affine`.
  Lean re-sign refactor (strip pushforward) pending next iter. Analysis: `analogies/l1-bridge.md`.
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
- File-split for parallelism (standing directive): EXECUTING iter-011 (gate cleared). Split the one
  consolidated file into `CechAcyclic.lean` (P3, re-signed to bundle), `PresheafCech.lean` (P3b
  bridge), `HigherDirectImagePresheaf.lean` (P3-independent 01XJ leaf + P5a vanishing inputs), and
  `CechHigherDirectImage.lean` (P1/P2 push–pull + Čech machinery + frozen P5b assembly), each a
  parallel prover lane under one `% archon:covers`. `cech_computes_higherDirectImage` signature +
  path frozen.

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
- `R^if_*` = sheafification of `V↦H^i(f⁻¹V,F)` for `Scheme.Modules` (`higher_direct_image_presheaf`,
  P5a) — from-scratch (Mathlib has it only for `Sheaf J AddCommGrpCat`).
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0`, `R^i(affine)_*=0` (P5).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve` / `CechComplex` / `CechAcyclic.affine` (standard-cover bundle).
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison (P4, done).
- P3b bridge: free-presheaf complex `cechFreePresheafComplex` + section Čech complex +
  `cechComplex_hom_identification` + `cechFreeComplex_quasiIso` + `injective_cech_acyclic` +
  `ses_cech_h1` + `cech_vanish_basis` → `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.
```

### references/summary.md

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
```

### Blueprint chapters (titles + one-line topic)

- `Cohomology_HigherDirectImage.tex` — "Higher direct images $R^i f_*$ of quasi-coherent
  sheaves ($i \geq 1$)": the def of `higherDirectImage` as `(pushforward f).rightDerived i`.
- `Cohomology_AcyclicResolution.tex` — "Acyclic resolutions compute right-derived functors":
  the abstract Leray lemma (Stacks 015E) `RⁿG ≅ Hⁿ(G K•)` for a G-acyclic resolution K•
  (DONE, axiom-clean).
- `Cohomology_CechHigherDirectImage.tex` — "Čech computation of higher direct images
  $R^i f_*$ (unconditional)": the consolidated chapter — push–pull functor, Čech
  nerve/complex, the standard-cover affine Čech vanishing (P3, the Q4-re-signed lemma),
  the presheaf-level Čech↔derived bridge (P3b: free-presheaf complex resolves O_𝒰,
  Hom(K•,F)=Č•(𝒰,F), injective Čech-acyclicity, ses_cech_h1, 01EO basis comparison →
  02KG affine Serre vanishing), the P5a vanishing inputs (01XJ higher-direct-image =
  sheafification of V↦Hⁱ(f⁻¹V), open-immersion/affine relative vanishing), and the final
  P5b Route-A assembly of the protected goal.

## Output

Write your report to `task_results/strategy-critic-iter018.md`. Give the verdict
(SOUND / CHALLENGE / REJECT) up front, then the per-route reasoning, then the
STRATEGY.md skeleton-conformance audit. If you CHALLENGE or REJECT, name the specific
route and the concrete alternative.
