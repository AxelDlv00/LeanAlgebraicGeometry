# Strategy Critic — iter-009

You are a fresh-context critic of the project's global strategy. Read ONLY what is
below. Judge the strategy as a fresh mathematician would, with no investment in the
project's existing momentum.

## Project goal (one paragraph)

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (blueprint
`lem:cech_computes_cohomology`), a protected frozen-signature target: for `f : X ⟶ S`
separated and quasi-compact, `F` quasi-coherent, and `𝒰` a finite affine open cover of
`X`, an isomorphism in the weak existence form
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where
`higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`. End-state: zero
inline `sorry` in the cone, zero project axioms, kernel-only axioms. The project was
extracted from a larger Algebraic-Jacobian challenge; downstream Picard/Quot machinery
is out of scope.

## STRATEGY.md (verbatim)

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
| P4 abstract acyclic-resolution lemma (Leray's acyclicity, Stacks 015E) | ACTIVE | ~1–2 | ~120–250 | `rightDerivedZeroIsoSelf`, `ShortComplex.ShortExact.homology_exact₂/₃`+`.δ`+`.δIso`, kernel/cosyzygy forks (all VERIFIED present) | Only the staircase `rightDerivedIsoOfAcyclicResolution` remains; horseshoe + object-level dimension shift built. Residual = base-case coker iso + cosyzygy-SES staircase; standard homological algebra, no new Mathlib gap anticipated. |
| P5a vanishing inputs (P3/P4-independent — parallelisable) | NEXT | ~2–4 | ~150–350 | augmented-Čech-is-a-resolution (stalkwise/topological); `R^q(jₛ)_*=0` for affine open immersions into separated `X`; basis lemma `lem:cech_to_cohomology_on_basis` (Stacks 01EO) | Three absent-from-Mathlib `Scheme.Modules` facts, each independent of P3 and P4. The basis lemma is the linchpin that lifts narrowed standard-cover affine acyclicity to general-affine `H^q(U_σ,F)=0` (see Routes). |
| P3 affine acyclicity (`CechAcyclic.affine`) | NEXT (needs statement-gap fix) | ~3–6 | ~200–500 | standard-cover Čech complex = localisations; prime-local contracting homotopy; `isZero` via localisation | Statement gap (Open Q): blueprint proves the STANDARD-cover case; Lean signature takes a general `X.OpenCover`. DECIDED: narrow the non-protected signature to standard covers (downstream-safe *via the P5a basis lemma*), then build the localisation homotopy from scratch for `Scheme.Modules`. |
| P5b comparison assembly | LAST (needs P3, P4, P5a) | ~2–4 | ~150–300 | P3 + P4 + P5a + termwise `f_*`-acyclicity of `Cᵖ` (relative affine vanishing after localising to affine `S`) | Final assembly of `cech_computes_higherDirectImage` from the resolution (P5a), termwise acyclicity (P3 + relative reduction), and the acyclic-resolution comparison (P4). Routes the general finite-affine `𝒰` through the basis lemma, NOT `CechAcyclic.affine` directly. |

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
of `R^q f_* F` (`lemma-quasi-coherence-higher-direct-images`, itself non-trivial via relative
Mayer–Vietoris). Strictly heavier than Route A for the same `Nonempty (… ≅ …)` goal. Kept on
record only as a fallback if Route A's abstract lemma proves unexpectedly hard.

### The P3-narrowing ↔ P5a-basis-lemma bridge (load-bearing)
Narrowing the non-protected `CechAcyclic.affine` signature to STANDARD covers is
downstream-safe **only** because the final assembly (P5b) does not apply `CechAcyclic.affine`
to the general finite-affine `𝒰` directly. Instead, the general-cover intersection vanishing
`H^q(U_σ, F) = 0` is obtained from narrowed standard-cover acyclicity through the basis lemma
`lem:cech_to_cohomology_on_basis` (Stacks 01EO): standard affine covers `D(f_i)` form a basis,
and 01EO lifts Čech-acyclicity on a basis to sheaf-cohomology vanishing on every affine open.
Hence the basis lemma (scoped in P5a) is the linchpin connecting narrowed P3 to the general
`𝒰` in the frozen goal; "downstream-safe" is a *derived* claim contingent on building it.

## Open strategic questions

- P5a basis lemma `lem:cech_to_cohomology_on_basis` (Stacks 01EO): confirm whether Mathlib
  provides a faithful version for `Scheme.Modules` (→ `\mathlibok` anchor) or it must be built.
  This is the linchpin of the P3-narrowing safety argument (see Routes) — scope it (own P5a
  sub-goal). Its standalone statement is in Stacks `cohomology.tex`, not yet in `references/`.
- P3 statement gap: narrow `CechAcyclic.affine` to a standard-cover hypothesis (DECIDED, option
  a — downstream-safe via the P5a basis lemma). Open sub-question: the precise "standard affine
  cover" Lean type (non-trivial design); resolve in the P3 refactor before the effort-break.
- P3: exact Mathlib names for prime-local exactness (`algebra-lemma-characterize-zero-local`
  analog, e.g. `Module.isZero` / localization-faithfulness) — verify before dispatching.
- P5b: termwise `(pushforward f)`-acyclicity reduces to affine Serre vanishing via Stacks
  `lemma-relative-affine-vanishing` after localising to affine `S` (resolved; no strategy change).
- P5a/P5b blueprint must be made Route-A-clean: the current sketches of
  `lem:cech_to_cohomology_on_basis` (Čech-to-derived SS) and `lem:open_immersion_pushforward_comp`
  (relative Leray SS) invoke spectral sequences absent from Mathlib — contradicting Route A's
  "no spectral sequences" basis. Rewrite both to the acyclic-resolution / basis-comparison argument
  before P5a can pass the gate as a parallel prover lane. First action once P4 closes.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Staircase of "`G`-acyclic resolution computes `G.rightDerived`" (Leray's acyclicity, P4) —
  base-case coker iso + cosyzygy-SES staircase (the horseshoe + SES→LES kernel are built).
- Standard-cover Čech complex as the complex of localisations + its prime-local contracting
  homotopy / positive-degree exactness (P3).
- Relative affine vanishing `R^i(affine morphism)_* = 0 (i>0)` and `R^q(jₛ)_* = 0` for affine
  open immersions into separated `X`, for `Scheme.Modules` (P5b termwise acyclicity / P5a).
- Augmented Čech complex is a resolution (stalkwise exactness) for `Scheme.Modules` (P5a).
- Čech-to-cohomology-on-a-basis (`cohomology-lemma-cech-vanish-basis`) for `Scheme.Modules` (P5a).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` (`pushPullObj`/`pushPullMap`
  + functor laws) — keep hand-rolled (no Mathlib straightening).
- `CechNerve` / `CechComplex` / `CechAcyclic.affine`.
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison.
- comparison assembly `cech_computes_higherDirectImage` via Route A.

```

## References index (references/summary.md)

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

```

## Blueprint chapter titles (one line each)

- `Cohomology_AcyclicResolution.tex` — "Acyclic resolutions compute right-derived
  functors" (abstract homological algebra; the P4 Leray-acyclicity comparison theorem;
  covers `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`).
- `Cohomology_CechHigherDirectImage.tex` — "Čech computation of higher direct images
  R^i f_* (unconditional)" (the main goal + its P3/P5 cone: push–pull functor, Čech
  nerve/complex, affine acyclicity, augmented-Čech resolution, termwise acyclicity,
  basis-comparison; covers `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`).
- `Cohomology_HigherDirectImage.tex` — "Higher direct images R^i f_* of quasi-coherent
  sheaves (i ≥ 1)" (covers `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`).

## What I specifically want challenged

1. **Route A (acyclic-resolution / Cartan–Leray) vs Route B (two spectral sequences).**
   STRATEGY.md commits to Route A and rejects Route B because the Čech-to-derived and
   relative Leray spectral sequences are absent from Mathlib. Is Route A genuinely
   self-contained for the *existence* goal `Nonempty (… ≅ …)`, or does some step
   (basis lemma `lem:cech_to_cohomology_on_basis`, termwise acyclicity
   `lem:cech_term_pushforward_acyclic`, open-immersion pushforward
   `lem:open_immersion_pushforward_comp`) secretly still need a spectral sequence?
   Note: the current P5 blueprint sketches of those three lemmas STILL invoke spectral
   sequences; STRATEGY.md flags this as an open item ("rewrite to Route-A before P5a
   passes the gate"). Is the claimed Route-A rewrite of each actually possible from
   today's Mathlib + the P4 acyclic-resolution theorem, or is one of them a hidden
   Route-B dependency that dooms Route A?
2. **The P3-narrowing ↔ P5a-basis-lemma bridge.** STRATEGY.md narrows the
   non-protected `CechAcyclic.affine` signature to STANDARD covers and claims this is
   "downstream-safe" because the general-cover vanishing is recovered via the basis
   lemma (Stacks 01EO). Is this bridge load-bearing-and-sound, or circular (does the
   basis lemma itself need the general-cover affine acyclicity it is supposed to
   supply)?
3. **Phase ordering / parallelism.** P4 is ~2 declarations from done. Is it sound to
   start P5a blueprint de-spectral-sequencing NOW (in parallel), or is there a
   dependency that makes P5a premature until P4 actually lands?

Output your verdict (SOUND / CHALLENGE / REJECT) per the descriptor, with specific
actionable findings. If you CHALLENGE, name the exact strategy line and the corrective.
