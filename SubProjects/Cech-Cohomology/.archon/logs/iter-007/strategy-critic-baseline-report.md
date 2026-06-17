# Strategy Critic Report

## Slug
baseline

## Iteration
007

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — Leray's acyclicity lemma applied to `RF = R(pushforward f)` on the `f_*`-acyclic Čech resolution delivers `H^i(f_* C•) ≅ R^i f_* F` directly, which is exactly the protected goal `(CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F` (relative, not merely absolute). No base-change post-processing needed.
- **Mathematical soundness**: PARTIAL — the spine is the canonical Cartan–Leray argument and is correct, but one load-bearing connective lemma (Čech-to-cohomology on a basis, used to lift narrowed standard-cover acyclicity to general-affine vanishing) is named only as an unscoped open question. See Must-fix.
- **Sunk-cost reasoning detected**: no — the P4 Risks/Open-question cells recite prior-iter progress ("TARGET 1+2 closed", "horseshoe DECOMPOSED") but the *route choice* is justified on merits (Leray = one abstract lemma vs two spectral sequences), not on "we already built it." That recitation is a format issue (below), not sunk-cost.
- **Infrastructure-deferral detected**: no (borderline) — the basis lemma `lem:cech_to_cohomology_on_basis` is the only candidate; it is NOT indefinitely deferred (the strategy plans to build it project-side), but it lacks an iter/LOC estimate and is not connected to the P3-narrowing-safety argument. Treated as a CHALLENGE on scoping, not a deferral REJECT.
- **Phantom prerequisites**: none found. `InjectiveResolution.isoRightDerivedObj` (Mathlib.CategoryTheory.Abelian.RightDerived) and `ShortComplex.ShortExact.δ` + the `Mathlib.Algebra.Homology.HomologySequence` machinery (`δ_eq'`, `comp_δ`) are VERIFIED present — the P4 abstract engine rests on real infrastructure.
- **Effort honesty**: under-counted (mild) — P5 at ~3–6 iters / ~250–550 LOC bundles FOUR absent-from-Mathlib `Scheme.Modules` theorems (augmented-Čech-is-a-resolution, relative affine vanishing, `R^q(jₛ)_*=0`, base-change-to-affine-S) PLUS the basis lemma. The phase acknowledges a P5a/P5b split but has not committed to it.
- **Parallelism under-exploited**: yes — P5's vanishing inputs (P5a: "augmented Čech is a resolution" is purely stalkwise/topological and needs neither P3 nor P4; `R^q(jₛ)_*=0` is independent of P3's affine acyclicity) are routed strictly LAST behind P3,P4 though they share no dependency with them.
- **Verdict**: CHALLENGE

### Route: B — two spectral sequences (REJECTED, fallback only)

- **Verdict**: SOUND — rejection is correct. Both the Čech-to-derived and Leray spectral sequences are absent from Mathlib (each multi-thousand-LOC), and Leray degeneration additionally needs quasi-coherence of `R^q f_* F`. For the `Nonempty (… ≅ …)` existence goal, Route B is strictly heavier than A and buys nothing extra. Crucially, B's Čech-to-derived SS would itself need the *same* augmented-Čech-resolution + termwise-acyclicity facts that P5 builds — so those facts are intrinsic to any proof, not a hidden cost that makes A rival B. Keeping B as a documented fallback is fine.

## Format compliance

- **Size**: ~115 lines / ~10 KB (estimated from the verbatim paste) — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order with `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes — quotes verbatim: in the P4 Risks cell, *"The horseshoe `InjectiveResolution.ofShortExact` (absent from Mathlib) was DECOMPOSED iter-005 into 4 provable sub-goals + 2 anchors; gate-passed. TARGET 1 (horseshoe) + TARGET 2 (dimension shift) closed iter-006."*; in Open strategic questions, *"P4 (DECIDED & RE-CONFIRMED iter-003)"* and *"[Now mostly built: TARGET 1+2 done iter-006…]"*. Status cell `ACTIVE (iter-003)` also embeds an iter ref. This belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: yes — the P4 and P3 Risks cells and the Open-strategic-questions bullets have accumulated multi-sentence per-iter progress logs (TARGET 1/2/3 status, "gate-passed", bracketed "[Now mostly built…]" addenda). These are prose-history bloat in cells that should carry one short forward-looking line.
- **Table discipline**: FAIL (minor) — `Status` should be a short inline tag (`ACTIVE`), not `ACTIVE (iter-003)`; Risks cells run to several sentences with embedded history rather than one short line.
- **Format verdict**: DRIFTED

## Alternative routes (suggested)

### Alternative: affine vanishing via exactness of `Γ` on QCoh(Spec A) (for the P3 input)

- **What it looks like**: Instead of (only) the standard-cover localisation contracting homotopy, prove affine Serre vanishing `H^q(Spec A, F)=0 (q>0)` by exhibiting quasi-coherent sheaves on an affine as a `Γ`-acyclic class — leaning on the `QCoh(Spec A) ≃ Mod_A` equivalence / exactness of global sections on the project's `Scheme.Modules`.
- **Why it might be cheaper or sounder**: it could in principle bypass building the basis lemma `lem:cech_to_cohomology_on_basis` for `Scheme.Modules`.
- **What the current strategy may have rejected**: unclear — not mentioned. HOWEVER, I judge this alternative does NOT actually save work: the equivalence gives `H^0` exactness only; higher vanishing still requires showing QC sheaves are `Γ`-acyclic, which IS Serre vanishing and is canonically proved via the standard-cover Čech complex + basis lemma (Stacks 01EO→01XB). So the strategy's chosen route is the canonical one and no cheaper bypass exists. Listed only to confirm the route was not a missed shortcut.
- **Severity of the omission**: minor

## Must-fix-this-iter

- Route A (P3/P5): CHALLENGE — the decision "narrow `CechAcyclic.affine` to standard covers, downstream-safe" is sound **only because** P5 must route the general finite-affine cover `𝒰`'s intersection-vanishing through the basis lemma `lem:cech_to_cohomology_on_basis` (narrowed standard-cover acyclicity ⟶ general affine `H^q(U_σ,F)=0` via 01EO), NOT by applying `CechAcyclic.affine` to `𝒰` directly. The planner must (a) record this dependency explicitly in STRATEGY.md so "downstream-safe" is a derived claim not an assertion, and (b) scope the basis lemma (iter/LOC estimate, own phase or named P5a sub-goal) since it is the linchpin connecting narrowed P3 to the general-cover frozen goal.
- Route A (P5): CHALLENGE — commit to the P5a (vanishing inputs) / P5b (assembly) split rather than contemplating it; P5 currently hides four independent absent-from-Mathlib `Scheme.Modules` theorems + the basis lemma under one ~250–550 LOC estimate. P5a inputs (augmented-Čech-is-a-resolution; `R^q(jₛ)_*=0`) are independent of P3 and P4 and should be parallelisable, not serialised LAST.
- Format: DRIFTED — strip per-iter narrative from the P4/P3 Risks cells and Open-strategic-questions bullets (move TARGET-1/2/3 and "DECOMPOSED iter-005 / closed iter-006" history to `iter/iter-NNN/plan.md`); reduce `Status` to a bare tag; collapse Risks cells to one forward-looking line each.

## Overall verdict

CHALLENGE (specific). The core strategic choice is correct and I am not asking for a rewrite: Route A (acyclic-resolution comparison via Leray's acyclicity lemma) is genuinely cheaper than Route B for this exact `Nonempty (… ≅ …)` goal — the augmented-Čech-resolution and termwise-acyclicity facts P5 builds are intrinsic to *any* Čech-computes-`R^i f_*` proof (Route B needs them too), so there is no hidden cost that makes A rival B; B is strictly heavier (two absent spectral sequences). The P4 abstract engine rests on verified Mathlib infrastructure (`isoRightDerivedObj`, `ShortComplex.ShortExact.δ`). The P5 ingredient list is correctly identified and no phase hides a spectral-sequence-sized gap. The must-fix items are: (1) the "narrow P3 to standard covers" decision is downstream-safe *only* via the basis lemma `lem:cech_to_cohomology_on_basis`, which is currently an unscoped open question — the planner must make this bridge explicit and give it an estimate, because without it the narrowing leaves an unbridged gap to the general finite-affine `𝒰` in the protected goal; (2) commit the P5a/P5b split and exploit the available parallelism (resolution-ness and `R^q(jₛ)_*=0` do not depend on P3/P4); (3) format DRIFTED — per-iter narrative has leaked into the Phases-table Risks cells and Open-strategic-questions bullets and must move to the iter sidecar.
