# Strategy Critic Directive

## Slug
baseline

You are the fresh-context strategy critic. Read ONLY what is below. Do not read
PROGRESS.md, iter sidecars, task results, or recent prover/review narrative. Judge
the strategy as a fresh mathematician would.

## Project goal (the final theorem to formalize)

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (blueprint
`lem:cech_computes_cohomology`), a protected, frozen-signature target: for
`f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, and `𝒰` a finite
affine open cover of `X`, there is an isomorphism in the weak existence form
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the
cone of this declaration, zero project axioms, kernel-only axioms. This is an
extraction from the Algebraic-Jacobian challenge; downstream Picard/Quot
machinery is out of scope and was carved away.

## STRATEGY.md (verbatim)

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
| P4 abstract acyclic-resolution lemma (Leray's acyclicity, Stacks 015E) | ACTIVE (iter-003) | ~2–4 | ~250–450 | `InjectiveResolution.isoRightDerivedObj`, `isZero_rightDerived_obj_injective_succ`, `rightDerivedZeroIsoSelf`, `ShortComplex.ShortExact.homology_exact₁/₂/₃`+`.δ`+`.δIso`, `Injective.instBiprod`, `ShortComplex.Splitting.ofHasBinaryBiproduct` (all VERIFIED present) | new file `AcyclicResolution.lean`. All horseshoe *consumers* built + axiom-clean iter-004. The horseshoe `InjectiveResolution.ofShortExact` (absent from Mathlib) was DECOMPOSED iter-005 into 4 provable sub-goals + 2 anchors; gate-passed. TARGET 1 (horseshoe) + TARGET 2 (dimension shift) closed iter-006. Sole remaining: TARGET 3 staircase `rightDerivedIsoOfAcyclicResolution`. |
| P3 affine acyclicity (`CechAcyclic.affine`) | NEXT (needs statement-gap fix) | ~3–6 | ~200–500 | standard-cover Čech complex = localisations; prime-local contracting homotopy; `isZero` via localisation | **STATEMENT GAP (open Q below): blueprint proves the STANDARD-cover case; Lean signature takes a general `X.OpenCover`.** Resolve (narrow the non-protected signature to standard covers — downstream-safe per reviewer — OR upgrade the blueprint via cofinality) BEFORE the effort-breaker. Then: build the explicit localisation description + module homotopy from scratch for `Scheme.Modules`. |
| P5 comparison assembly | LAST (needs P3,P4) | ~3–6 | ~250–550 | P3+P4 + termwise `f_*`-acyclicity of `Cᵖ` | **bundles three real `Scheme.Modules` theorems**: augmented Čech complex is a resolution; relative affine vanishing `R^i(affine)_*=0 (i>0)`; `R^q(jₛ)_*=0` for affine open immersions into separated `X`; plus the base-change-to-affine-`S` reduction. Each absent from Mathlib. May split into P5a (vanishing inputs) + P5b (assembly). |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` (composition law) closing the push–pull functoriality cone | object-form alignment `simp only [Functor.comp_obj]` BEFORE `reassoc_of%`; `rawPushPullMap` + `subst`-the-over-triangles + pentagon, sidestepping `conjugateEquiv` | the `conjugateEquiv_comp` mate route is INFEASIBLE (kernel `whnf` blow-up); do not retry it |
| P2 `CechNerve`/`CechComplex` | 002 · 1 (stretch) | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor` (G), `coverCechNerveOver(Aug)`, `CechNerve`, `CechComplex` all axiom-clean | once `G` is a functor: `Over.lift` + `.rightOp` + `CosimplicialObject.Augmented.whiskeringObj`; terminal-object augmentation (`Over.mkIdTerminal`) makes coherence automatic | none — clean off-the-shelf transport |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})` over
`(p+1)`-fold intersections) is (i) a resolution of `F` and (ii) termwise `(pushforward f)`-
acyclic, because each intersection is affine (relative Serre vanishing, P3). The abstract
homological-algebra theorem "a `G`-acyclic resolution computes `G.rightDerived`" (P4, built
by dimension-shifting from Mathlib's `InjectiveResolution.isoRightDerivedObj`) then gives
`Hⁱ(f_* C•) = Hⁱ(CechComplex) ≅ (pushforward f).rightDerived i F` directly — ONE abstract
lemma, NO spectral sequences. This is the standard Cartan–Leray acyclic-cover proof of the
existence statement; it folds P3 in as its acyclicity input.

### Route B — two spectral sequences (REJECTED, fallback only)
The literal Stacks 02KE route: a Čech-to-derived spectral sequence plus the Leray spectral
sequence for `Scheme.Modules`. Rejected: both spectral sequences are absent from Mathlib
(multi-thousand-LOC to build), and the Leray degeneration additionally needs quasi-coherence
of `R^q f_* F`. Strictly heavier than Route A for the same `Nonempty (… ≅ …)` goal.

## Open strategic questions

- P4 (DECIDED & RE-CONFIRMED iter-003): the SES→LES of `rightDerived` is built via the
  horseshoe `InjectiveResolution.ofShortExact`. mathlib-analogist confirmed the horseshoe is
  the CHEAPEST gap (Ext LES is Hom-specific; derived-category route needs an open Mathlib TODO
  bridge; a snake on a single resolution only handles injective-middle SESs). [Now mostly built:
  TARGET 1+2 done iter-006; only the TARGET 3 staircase remains.]
- P3 (NEW — must resolve before P3 prover work): standard-cover-vs-general-cover STATEMENT GAP.
  The blueprint `lem:cech_acyclic_affine` proof is the standard-cover localisation homotopy; the
  Lean `CechAcyclic.affine` signature takes a general `X.OpenCover`. `CechAcyclic.affine` is NOT
  protected. Reviewer confirms downstream only uses it on standard covers ⇒ narrowing the Lean
  signature is downstream-safe. Decision pending: (a) narrow the signature, or (b) upgrade the
  blueprint via cofinality.
- P3: exact Mathlib names for prime-local exactness — verify before dispatching.
- P5: `lem:cech_to_cohomology_on_basis` — confirm whether Mathlib provides a faithful version
  for `Scheme.Modules` (→ `\mathlibok` anchor) or it must be built.
- P5 (resolved): termwise `(pushforward f)`-acyclicity reduces to affine Serre vanishing via
  Stacks `lemma-relative-affine-vanishing` after localising to affine `S`.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- General "`G`-acyclic resolution computes `G.rightDerived`" (Leray's acyclicity, P4). [Hard
  kernel — the horseshoe + SES→LES — now built; only the staircase assembly remains.]
- Standard-cover Čech complex as the complex of localisations + its prime-local contracting
  homotopy / positive-degree exactness (P3).
- Relative affine vanishing `R^i(affine morphism)_* = 0 (i>0)` and `R^q(jₛ)_* = 0` for affine
  open immersions into separated `X`, for `Scheme.Modules` (P5).
- Čech-to-cohomology-on-a-basis for `Scheme.Modules` (P3/P5).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — keep hand-rolled.
- `CechNerve` / `CechComplex` / `CechAcyclic.affine`.
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison.
- comparison assembly `cech_computes_higherDirectImage` via Route A.
```

## Reference index (`references/summary.md`)

| File | Description |
| ---- | ----------- |
| `stacks-coherent.md` → `.tex` | Stacks ch.30 "Cohomology of Schemes". Tags 02KE (Čech computes cohomology when intersections affine), 02KG (Serre vanishing for QC on affines), and the affine-base higher-direct-image application. Backs `def:cech_nerve`, `def:cech_complex`, `lem:cech_acyclic_affine`, `lem:cech_computes_cohomology`. |
| `homological-acyclic.md` → `homological-acyclic-derived.tex`, `homological-acyclic-homology.tex` | Stacks `derived.tex` + `homology.tex`: right-F-acyclic objects (Tag 0157), criterion via vanishing higher derived functors (015C), **Leray's acyclicity lemma** — an F-acyclic resolution computes RF (015E), Prop 05TA (enough acyclics), delta-functor background. Tag 015D (`lemma-F-acyclic-ses`, the dimension-shift LES). Backs `Cohomology_AcyclicResolution.tex`. |
| `stacks-cohomology.md` → `.tex` | Stacks "Cohomology" ch.: abstract sheaf cohomology + Čech. `lemma-describe-higher-direct-images` (01XJ, R^i f_* is sheafification of V↦H^i(f^{-1}V,F)); `lemma-cech-vanish-basis` (01EO, Čech-to-cohomology on a basis). Backs `Cohomology_CechHigherDirectImage.tex`. |

## Blueprint chapters (titles + one-line topic)

- `Cohomology_HigherDirectImage.tex` — "Higher direct images $R^i f_*$ of quasi-coherent
  sheaves ($i \geq 1$)" — defines `higherDirectImage`, the derived-functor target; foundational.
- `Cohomology_AcyclicResolution.tex` — "Acyclic resolutions compute right-derived functors" —
  the abstract homological-algebra engine (P4): right-acyclic objects, the horseshoe lift, the
  dimension-shift lemma, and the acyclic-resolution comparison theorem (Stacks 015D/015E).
- `Cohomology_CechHigherDirectImage.tex` — "Čech computation of higher direct images $R^i f_*$
  (unconditional)" — the geometric chapters: push–pull functor, Čech nerve/complex, affine
  acyclicity (P3), and the final comparison assembly `lem:cech_computes_cohomology` (P5).

## What I want from you

Judge whether the strategy (Route A acyclic-resolution comparison, the P4/P3/P5
phasing, the rejection of Route B, the open strategic questions, and the
estimations) is the soundest route to the goal. In particular:
- Is Route A genuinely cheaper than Route B for this exact `Nonempty (… ≅ …)`
  goal, or is there a hidden cost (e.g. building the augmented-Čech resolution +
  termwise acyclicity in P5 that rivals a spectral sequence)?
- Is the P3 standard-cover-vs-general-cover statement gap a real risk, and is
  "narrow the Lean signature to standard covers" actually downstream-safe given
  the final theorem takes a general finite affine `𝒰`?
- Are the P5 ingredients (augmented Čech is a resolution; relative affine
  vanishing; `R^q(jₛ)_*=0`; base-change to affine S) correctly identified and is
  the bundling/decomposition reasonable, or is a phase hiding a much larger gap?
- Any canonical-skeleton deviation from the standard Cartan–Leray acyclic-cover
  proof of `H^i(X,F) = H^0(S, R^i f_* F)` / `R^i f_*` via Čech.

Verdict: SOUND / CHALLENGE (specific) / REJECT (with alternative). This strategy
critic has not run before on this project — establish a baseline.
