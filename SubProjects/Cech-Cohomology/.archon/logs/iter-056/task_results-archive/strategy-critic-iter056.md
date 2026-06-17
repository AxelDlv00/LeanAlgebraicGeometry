# Strategy Critic Report

## Slug
iter056

## Iteration
056

## Routes audited

### Route A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — proving the augmented Čech complex is a resolution of `F` (P5a-resolution) and termwise `(pushforward f)`-acyclic (P5a-consumer), then feeding the done P4 Leray lemma, produces exactly `Hⁱ(f_* C•) ≅ Rⁱf_* F`, i.e. the frozen `cech_computes_higherDirectImage`. No gap between the route's end-state and the goal.
- **Mathematical soundness**: PASS — this is the standard Stacks 02KE / 015E argument; one abstract lemma in place of two spectral sequences is correct and is the cheapest sound assembly. The non-circularity story (01EO lifts standard-cover Čech vanishing of P3 to affine sheaf vanishing *without* using affine vanishing) is explicitly tracked and holds.
- **Sunk-cost reasoning detected**: no — Route A is justified on merits ("ONE abstract lemma, NO spectral sequences"), not "we already built X". The 01I8 overrun (~14 iters vs est 2) is honestly recorded in `## Completed`, not used to justify continuing.
- **Infrastructure-deferral detected**: no — the one new sheaf-infra leaf (indexed coproduct→product of module sheaves, Sub-brick A) is given a concrete file (`CechSectionIdentification.lean`), a concrete porting recipe (port binary `isProductOfDisjoint`/`coprodPresheafObjIso` via `toPresheaf` faithful/reflects-iso/preserves-limits), and an iter estimate. It is on the critical path and is planned to be built, not deferred.
- **Phantom prerequisites**: none found. `CategoryTheory.InjectiveResolution.instMonoFNatι` (EnoughInjectives connector) VERIFIED present. The cechAugmented bridge infra (`homologyIsoSheafify`, `SheafOfModules.toSheaf`, `PresheafOfModules.sheafificationCompToSheaf`) is project-internal and recorded built. No claim of phantom Mathlib infra.
- **Effort honesty**: under-counted — see the consumer and Sub-brick rows below.
- **Parallelism under-exploited**: no — P5a-resolution and P5a-consumer are correctly split as independent ACTIVE phases with P5b BLOCKED on both.
- **Verdict**: SOUND (one CHALLENGE on the consumer sub-route — see below; does not invalidate Route A itself).

### Route SS — two spectral sequences (REJECTED)

- **Verdict**: SOUND — correctly rejected: both spectral sequences are absent from Mathlib (multi-thousand LOC) and would rest on the same `injective_cech_acyclic` brick as A. The rejection reasoning is on-merits.

### Sub-route: `cechAugmented_exact` (P5a resolution input)

- **Mathematical soundness**: PASS — reflect `IsZero(Hᵖ)` through faithful additive `toSheaf`, homology sheaf = sheafification of presheaf homology, presheaf homology locally zero on the basis `{V ⊆ Uᵢ}` via the prepend-`i_fix` contracting homotopy. The enumerated DEAD ends (stalk functor, tilde/standard-cover as local discharger, naive section-complex-exact-over-V which is circular) show the circularity traps are mapped.
- **Effort honesty**: under-counted — the lone new leaf (indexed coproduct→product of module sheaves) is, by the strategy's own calibration note, "comparable to the 01I8 sheaf-infra route [that] overran ~7×" (14 iters vs est 2). Estimating ~2–3 iters / ~200–350 LOC for an obligation the strategy itself flags as 01I8-comparable is optimistic; I'd expect the real risk band to reach 4–6 iters.
- **Verdict**: SOUND — math is right; flag the estimate only.

### Sub-route: `higherDirectImage_openImmersion_comp` (P5a consumer)

- **Mathematical soundness**: PARTIAL — the route is sound *if* the general-affine-open Serre vanishing is built, but that generalization looks avoidable (see CHALLENGE below). The shared bridge (1) (cohomology-presheaf identification) + Serre-transport + sheafification site lemma are three nontrivial pieces bundled into one ~2–3 iter row.
- **Infrastructure-deferral detected**: no — the pieces are named and active, not deferred.
- **Effort honesty**: under-counted — three nontrivial sub-pieces (the `homologyAddEquiv∘jShriekOU_homEquiv∘cochainComplexXIso` bridge chain, Serre-transport-to-affine-open, and the `PresheafOfModules.sheafification` site lemma) in ~2–3 iters, given that both 01I8 and 02KG overran their estimates. Optimistic.
- **Verdict**: CHALLENGE — see Q2 in Must-fix.

### Sub-route: Absolute cohomology Form B — `Ext^p(jShriekOU U, −)`

- **Mathematical soundness**: PASS — Form B (`H^p(U,F) := Ext^p(jShriekOU U, F)`, injective in the *2nd* argument) cleanly avoids restriction-preserves-injectives and the bespoke `j_!` functor. The three facts 01EO consumes (injective vanishing, covariant LES at fixed 1st arg, H⁰≅Γ) are off-the-shelf with the SES staying in `X.Modules`. The reversal signal (fall back to Čech colimit Route γ on Ext universe pain, never `Sheaf.H`) is a sensible escape hatch.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 126 lines / ~10.6 KB — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order with `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes (minor) — `"Relative/open-immersion affine vanishing … (P5a-consumer, ACTIVE this iter)"` in `## Mathlib gaps`. "ACTIVE this iter" is a status-tag-as-prose; trim to "(P5a-consumer)" since the table already carries Status.
- **Accumulation detected**: no — no completed phase left in the active table; no excised route still occupying a `## Routes` subsection.
- **Table discipline**: FAIL — both tables violate "one short line per cell." The P5a-resolution row's `Key Mathlib needs` and `Risks` cells, and the P5a-consumer row's `Key Mathlib needs` cell, are each multi-clause paragraphs (5–7 lines rendered). Several `## Completed` cells are similarly dense multi-line prose. These belong compressed to one line each, with detail pushed to the `## Routes` prose or iter sidecars.
- **Format verdict**: DRIFTED — headings/size/accumulation are clean; the sole material issue is bloated multi-line table cells (plus the one "this iter" phrase). A short in-place cell-compression pass fixes it; not a full restructure.

## Alternative routes (suggested)

### Alternative: reduce Čech-term acyclicity through the affine morphism, not general-affine-open vanishing

- **What it looks like**: To show each Čech term `(j_σ)_*(F|_{U_σ})` is `(pushforward f)`-acyclic, use: (a) `j_σ : U_σ ↪ X` is an affine open immersion, so `H^i(W, (j_σ)_*H) = H^i(j_σ⁻¹W, H)` (the sibling active obligation `higherDirectImage_openImmersion_acyclic`, `R^q(j_σ)_* = 0`); (b) `f|_{U_σ} : U_σ → S` is an **affine morphism** by the *already-done* `isAffineHom_of_affine_separated` (affine source + separated f), so `(f|_{U_σ})⁻¹V = U_σ ×_S V` is an **affine scheme** for V a basic affine open of S; (c) therefore `H^i(f⁻¹V, (j_σ)_*H) = H^i((f|_{U_σ})⁻¹V, H) = H^i(\text{affine scheme}, \text{qcoh}) = 0` by the **already-done** `(Spec R, ⊤)`-case `affine_serre_vanishing` (02KG); sheafify over the basis (01XJ). No vanishing on a *general* affine open of an affine scheme is invoked — every cohomology computed sits on a whole affine scheme.
- **Why it might be cheaper or sounder**: it reuses two finished pieces (`isAffineHom_of_affine_separated`, `⊤`-case `affine_serre_vanishing`) plus the sibling open-immersion-acyclicity lane, and entirely skips generalizing the affine-vanishing infrastructure from `⊤` to arbitrary affine opens — exactly the new infrastructure the consumer phase is currently bottoming out on.
- **What the current strategy may have rejected**: unclear. The strategy frames the consumer as `Ext^q(jShriekOU V, H)=0` for V a general affine open realized via Form-B Ext in the ambient affine scheme. That framing arises from computing `H^q(f⁻¹V, …)` directly inside X; pushing the affineness through the affine morphism `f|_{U_σ}` first appears to collapse "general affine open" back to "whole affine scheme," which the existing `⊤` case already covers. I cannot rule out that the Form-B realization step still needs an affine-open statement for some plumbing reason, which is precisely why the planner must record the rebuttal rather than proceed silently.
- **Severity of the omission**: major.

## Must-fix-this-iter

- **Route `higherDirectImage_openImmersion_comp`: CHALLENGE (Q2)** — the strategy reduces termwise acyclicity to a *new* "change-of-scheme Serre vanishing for a general affine open V" generalizing `affine_serre_vanishing`. A fresh reading suggests this generalization is avoidable: via the done `isAffineHom_of_affine_separated`, the relevant preimages `(f|_{U_σ})⁻¹V = U_σ ×_S V` are **affine schemes** (whole-space `⊤` case), not general affine opens, so the existing `⊤`-case `affine_serre_vanishing` (02KG, done) plus the sibling open-immersion-acyclicity lane should suffice — with no new affine-vanishing infrastructure. The planner must either (a) adopt the affine-morphism reduction and drop the general-affine-open generalization, or (b) record in `iter/iter-056/plan.md` a concrete reason the Form-B realization genuinely forces vanishing on an arbitrary affine open V (and confirm that proof reuses the 01EO/02KG `_of_localizationAway` basis mechanism, NOT span-cover descent — which the project has already flagged as circular).

- **Format: DRIFTED → compress this iter** — `## Phases & estimations` and `## Completed` cells violate "one short line per cell" (P5a-resolution `Key Mathlib needs`/`Risks`, P5a-consumer `Key Mathlib needs`, and several Completed cells are multi-line paragraphs). Compress each cell to one line; move detail into the `## Routes` prose. Also trim "ACTIVE this iter" → drop the iter phrasing in `## Mathlib gaps`. In-place cell edit, not a restructure.

- **Effort estimates: optimistic** — the Sub-brick A new leaf (strategy's own note: "01I8-comparable, overran ~7×") at ~2–3 iters, and the consumer's three-piece bridge at ~2–3 iters, are both under-counted given 01I8 and 02KG each overran. Widen the `Iters left` bands or split each into its own sub-rows so progress is legible.

## Overall verdict

Route A is the correct, standard, on-merits choice and remains sound: goal-aligned, free of phantom Mathlib prerequisites (the EnoughInjectives connector `HasInjectiveResolutions → EnoughInjectives` is genuinely ~6 LOC and the cited `InjectiveResolution.instMonoFNatι` is verified present), with no sunk-cost framing and no hidden infrastructure deferral — the Sub-brick A new leaf is concretely planned, not punted. The strategy does **not** defer any construction required by the goal. The one substantive challenge is on the consumer sub-route (Q2): the planner should not build a *general-affine-open* Serre vanishing without first ruling out the cheaper affine-morphism reduction (`isAffineHom_of_affine_separated` + open-immersion acyclicity + the done `⊤`-case `affine_serre_vanishing`), which appears to keep every computed cohomology on a whole affine scheme. On Q3 there is no *new* circularity provided the general-affine-open proof (if pursued at all) routes through the 01EO basis mechanism and avoids span-cover descent, which the project already knows is circular. On Q4 the EnoughInjectives connector is sound. Secondary: table cells have drifted into multi-line prose (compress in place this iter) and the active effort estimates are optimistic against the project's own 01I8/02KG overruns.
