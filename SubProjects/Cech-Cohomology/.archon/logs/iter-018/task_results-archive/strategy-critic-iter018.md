# Strategy Critic Report

## Slug
iter018

## Iteration
018

## Summary verdict

**SOUND** on all strategic content — the Q4 re-sign to the absolute section Čech
complex is the textbook-correct decomposition and is confirmed line-for-line by the
Stacks references. **Format = DRIFTED**: per-iter narrative has colonised the prose
of the Phases table and the Open-questions section, and several table cells have
grown into multi-clause paragraphs. Must-fix this iter via an in-place cleanup; no
strategic rewrite required.

## Adjudication of the specific Q4 question

The directive asks three sub-questions about re-stating `lem:cech_acyclic_affine`
on the **absolute** `sectionCechComplex` (a `CochainComplex Ab` on `Spec R`, no `f`,
no pushforward) instead of the relative `CechComplex f 𝒰 F`. All three resolve in the
strategy's favour, and the resolution is not a judgement call — it is exactly how
Stacks structures the chapter.

**(a) Is targeting the absolute section complex sound and non-circular? — YES.**
The standard-cover Čech-vanishing lemma in Stacks (`lemma-cech-cohomology-quasi-coherent-trivial`,
`references/stacks-coherent.tex:44–135`) is itself stated and proved on the **absolute**
complex: it writes `F|_U = M~`, identifies `Č•(𝒰,F)` with
`0 → M → ∏ M_{f_i} → ∏ M_{f_i f_j} → ⋯`, and proves exactness by localising at each
prime and exhibiting a contracting homotopy. There is no morphism `f` and no pushforward
anywhere in that proof. The strategy's plan — close it via `exact_of_isLocalized_span`
(localise at `Away (s_r)`, node-by-node `Function.Exact`) plus the done combinatorial
homotopy `Dependent.depDiff_exact` — is a faithful Lean transcription of this exact
argument. The strategy's stated reason for *not* targeting the relative complex is also
correct: `pushforward f` is a right adjoint that does not preserve homology, so
`(CechComplex f 𝒰 F)` (which already lives in `X.Modules` after pushforward) is **not**
reducible to module exactness by localisation. Re-signing onto the absolute complex is
what makes the localisation argument available at all. Non-circular: the absolute lemma
depends only on `M~`-localisation theory, nothing downstream.

**(b) Does the downstream cone genuinely consume the absolute form? — YES.** The
consuming lemma `lemma-quasi-coherent-affine-cohomology-zero` (02KG Serre vanishing,
`stacks-coherent.tex:145–174`) is proved by feeding the standard-cover Čech vanishing as
**condition (3)** of `lemma-cech-vanish-basis` (01EO, `stacks-cohomology.tex:1695–1776`).
That entire 01EO machine — `lemma-injective-trivial-cech`, `lemma-ses-cech-h1`,
`lemma-cech-vanish-basis` — is phrased exclusively on the absolute `Č•(𝒰,F)` over an
`O_X`-module with absolute sections `Γ(U,-)` and absolute cohomology `H^p(U,F)`. There is
no relative morphism in the 01EO cone. So the re-sign hands 01EO precisely the object it
expects; it leaves no gap. The strategy's note that `cech_vanish_basis`'s `\uses` is
`{injective_cech_acyclic, ses_cech_h1, cech_acyclic_affine}` and explicitly **not**
`affine_serre_vanishing` is correct: 02KG is the *output* of the 01EO machine, never an
input, so there is no cycle.

**(c) Is the separate P5a supply of relative-complex acyclicity the right decomposition,
or is there a simpler route? — It is the right (and the simplest) decomposition.** Stacks
relativises in exactly two separately-supplied ways, both downstream of the absolute 02KG,
neither via the standard-cover Čech lemma:
  - `lemma-relative-affine-vanishing` (`R^i f_* F = 0` for affine `f`,
    `stacks-coherent.tex:180–199`) is proved through `lemma-describe-higher-direct-images`
    (01XJ, `stacks-cohomology.tex:591–627`: `R^i f_* F` = sheafification of
    `V ↦ H^i(f^{-1}V, F)`) **plus** the absolute affine vanishing 02KG on each affine
    `f^{-1}(V)`. This is precisely the strategy's P5a route
    (`higher_direct_image_presheaf` + `affine_serre_vanishing`).
  - `lemma-pushforward-injective` (`stacks-cohomology.tex:1778–1812`) reduces the *relative*
    Čech complex `Č•(𝒱, f_*I)` to the *absolute* `Č•(U, I)` on `X` via the elementary
    identity `f_*I(V_{j…}) = I(f^{-1}(V_{j…}))`, then applies the absolute injective
    lemma — again no re-proof of relative acyclicity.
The candidate "simpler" alternative — proving affine-pushforward exactness
`H^i(X,F)=H^i(S,f_*F)` directly and reducing the relative complex to modules — is a
mirage: in Stacks that statement (`lemma-relative-affine-cohomology`, `:201–212`) is itself
*derived from* relative-affine-vanishing + Leray, i.e. it sits **downstream** of 02KG, not
upstream of it. So it cannot serve as a shortcut to the brick; it would be a third
from-scratch construction (as the strategy already says) that buys nothing. The strategy's
decomposition is the standard route and there is no cheaper one.

## Routes audited

### Route A — acyclic-resolution comparison (CHOSEN)

- **Verdict**: SOUND

The augmented Čech resolution `0 → F → C⁰ → ⋯` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) being a
resolution + termwise `(pushforward f)`-acyclic, fed to the done P4 Leray lemma
`rightDerivedIsoOfAcyclicResolution`, yields `Hⁱ(f_* C•) ≅ Rⁱf_* F` — the relative goal.
The load-bearing acyclicity input (ii) is `R^q f_*` of the term sheaves, which is exactly
`lemma-relative-affine-vanishing` = 01XJ + 02KG. The connection from the absolute P3 brick
to the relative protected goal closes here and matches Stacks. The P4 engine is already
axiom-clean (per `## Completed`), de-risking the assembly.

### Route B — two spectral sequences (REJECTED, fallback only)

- **Verdict**: SOUND (correctly rejected)

The rejection is honest and, crucially, the strategy flags that Route B rests on the
**same** irreducible brick `injective_cech_acyclic` as Route A — so it does not pretend
the fallback escapes the hard problem. Multi-thousand-LOC absent infrastructure (Čech-to-
derived + Leray SS for `Scheme.Modules`) makes it strictly heavier for the same
`Nonempty (… ≅ …)` goal. Keeping it as a documented fallback rather than excising it is
acceptable; it carries genuine decision content (the shared-brick warning), not dead prose.

### The acyclicity bridge (P3b, load-bearing)

- **Goal-alignment**: PASS — produces `affine_serre_vanishing` (02KG), the exact input
  Route A's term-acyclicity needs.
- **Mathematical soundness**: PASS — the "direct route for (1)" (injective sheaf ⟹ injective
  presheaf via the sheafification right adjoint; free-presheaf complex resolves `O_𝒰`;
  `Hom(K•,F)=Č•(𝒰,F)`) is a verbatim match to `lemma-injective-trivial-cech`'s proof
  (`stacks-cohomology.tex:1424–1431`), which likewise gets injective-presheaf-ness from
  "sheafification is an exact left adjoint" and does **not** use presheaf enough-injectives.
- **Infrastructure-deferral detected**: no. The strategy drops `presheafModules_enoughInjectives`
  and `cech_delta_functor_presheaves` as off-critical-path — and this is legitimate, not a
  goal weakening, because the *irreducible* brick `injective_cech_acyclic` is kept on the
  critical path and the strategy commits to building it via the adjoint route. Stacks confirms
  the dropped items are genuinely unnecessary for this brick.
- **Verdict**: SOUND

## Format compliance

- **Size**: 126 lines / 11,312 bytes — within budget (~250 lines / ~12 KB), though the
  byte count is close to the ceiling; the cleanup below will also relieve this.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`,
  `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order,
  with `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes — multiple, in prose:
  - `:18` "iter-017 Q4 re-sign: target the ABSOLUTE section complex …" (Risks cell)
  - `:19` "section+free complexes DONE (iter-016); in flight: …" (Risks cell)
  - `:20` "parallel lane opens next iter" (Risks cell)
  - `:59` "(analogist `p3b-presheafcech`, iter-011)"
  - `:73` "P3 re-sign DECIDED (iter-017, Q4)"
  - `:79` "Lean re-sign refactor (strip pushforward) pending next iter"
  - `:94` "EXECUTING iter-011 (gate cleared)"
  These belong in `iter/iter-NNN/plan.md`, not STRATEGY.md. (The `## Completed` table's
  `Iters` cells — `002 · 2`, `009 · 6 (004–009)` — are the ledger and are fine.)
- **Accumulation detected**: no completed phase left in the active table (P1/P2/P4 are in
  `## Completed`); no excised route occupying a `## Routes` slot (Route B is a deliberate,
  content-bearing fallback).
- **Table discipline**: FAIL (mild) — the Phases-table cells at `:18–:20` are multi-clause
  paragraphs (Key-Mathlib and Risks columns), exceeding "one short line per cell". The
  `## Completed` cells are also dense but borderline.
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Format: DRIFTED — strip the seven per-iter-narrative phrases (`:18, :19, :20, :59, :73,
  :79, :94`) from STRATEGY.md prose; relocate any live per-iter status to
  `iter/iter-018/plan.md`. Restate the surviving content tenselessly (e.g. "Risk: …" not
  "DONE (iter-016)"; "P3 targets the absolute section complex" not "DECIDED (iter-017, Q4)").
  Compress the `:18–:20` Phases cells to one short line each. This is an in-place cleanup,
  not a restructure.

## Overall verdict

The strategy is mathematically SOUND and the iter-017 Q4 re-sign is not merely acceptable
but is the canonical decomposition: the standard-cover Čech-vanishing lemma is absolute in
Stacks (`lemma-cech-cohomology-quasi-coherent-trivial`), its consumer 02KG runs entirely
through the absolute 01EO machine, and relative-complex acyclicity is supplied separately
and downstream via 01XJ + 02KG (`lemma-relative-affine-vanishing`, `lemma-pushforward-injective`)
— exactly the P3 → P3b → P5a → P5b chain the strategy lays out, with no circularity and no
gap left by the re-sign. There is no simpler route for the relative side; the apparent
shortcut (affine-pushforward exactness) is itself downstream of the brick it would
replace. All spot-checked Mathlib prerequisites resolve: `exact_of_isLocalized_span`
(VERIFIED, exact signature), `PresheafOfModules.free`/`freeAdjunction`/`freeYonedaEquiv`
(VERIFIED), and injective-preservation under the sheafification adjoint via
`Functor.injective_obj_of_injective` + `PreservesInjectiveObjects` (mechanism present;
the strategy's `injective_of_adjoint`/`Injective.injective_of_adjoint` is a paraphrase,
not a phantom). No infrastructure-deferral findings. The only required action this iter is
the format cleanup: per-iter narrative has leaked into STRATEGY.md prose and several table
cells have outgrown the one-line bound — DRIFTED, fix in place.

## Prerequisite verification

- `exact_of_isLocalized_span` (`Mathlib.RingTheory.LocalProperties.Exactness`): VERIFIED
- `PresheafOfModules.free` / `freeAdjunction` / `freeYonedaEquiv`
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.{Free,Generator}`): VERIFIED
- `injective_of_adjoint` / `Injective.injective_of_adjoint`: RENAMED — the mechanism is
  `CategoryTheory.Functor.injective_obj_of_injective` with a `PreservesInjectiveObjects`
  instance (`Mathlib.CategoryTheory.Preadditive.Injective.Preserves`); strategy should
  update the cited name when wiring P3b, but the route is not blocked.
