# Strategy Critic Report

## Slug
iter059

## Iteration
059

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — the augmented Čech complex as an acyclic resolution + the P4 Leray lemma yields `Hⁱ(f_*C•) ≅ Rⁱf_*F`, which is exactly the protected `Nonempty (homology i ≅ higherDirectImage f i F)`.
- **Mathematical soundness**: PARTIAL — the decomposition (resolution input (i) + termwise acyclicity input (ii) → P4) is correct, but the discharge of input (ii) via Need#1 (scheme-iso Spec transport) is not justified against the now-closed Need#2. See the CHALLENGE below.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — both acyclicity sub-needs (Need#1, Need#2) are on the critical path and actively worked; nothing is parked as "future work".
- **Phantom prerequisites**: none — `CategoryTheory.Abelian.Ext.mapExactFunctor` confirmed present in Mathlib (`Mathlib.Algebra.Homology.DerivedCategory.Ext.Map`), and the Need#1 core `modulesIsoSpecExtTransport` is reported built. P4 engine + horseshoe done.
- **Effort honesty**: reasonable — P5a-consumer `~2–4` iters / `~150–280` LOC is plausible now that Need#2 is closed and only the 5 decomposed sub-lemmas remain; consistent with the realized cost of comparable completed rows.
- **Parallelism under-exploited**: no — P5a-resolution and P5a-consumer are correctly both ACTIVE and can run concurrently; P5b correctly BLOCKED behind them.
- **Verdict**: CHALLENGE

**The CHALLENGE (directive Q1).** With Need#2 (`affine_serre_vanishing_general_open`) now closed for *arbitrary affine opens*, the strategy does not establish why the open-immersion acyclicity leaf still needs the scheme-iso transport Need#1 (`U ≅ SpecΓU`, `Ext.mapExactFunctor`). A fresh reader sees a strictly simpler candidate discharge:

- The leaf reduces (per the strategy's own framing) to *Serre vanishing on the affine scheme* appearing in `(pushforwardSectionsFunctor j W).rightDerived q`. Call that affine scheme `U` (a cover member / `j⁻¹W`, which is affine).
- If `affine_serre_vanishing_general_open` is **polymorphic over the ambient scheme**, then instantiating it at *ambient = `U`*, `V = ⊤_U` (an affine open of the affine scheme `U`) gives `Ext^p_{U.Modules}(jShriekOU ⊤, F|_U) = 0` directly — i.e. the standalone cohomology of `U` — with **no `Spec Γ(U)` transport at all**.

The strategy must resolve which world we are in, *in STRATEGY.md*:

1. **If Need#2 is polymorphic over the scheme** → Need#1's Spec transport is redundant; pivot the P5a-consumer discharge to a direct re-instantiation of Need#2 on the source scheme `U`, and drop the `Ext.mapExactFunctor` transport. This removes the "dominant remaining wall" outright.
2. **If `affine_serre_vanishing_general_open`'s ambient scheme is fixed to the main `X`** (or specifically to `Spec R`) → Need#1 is the necessary bridge, but the strategy must say so explicitly: name *why* the leaf's cohomology is the standalone `Ext_{U.Modules}` rather than an `X.Modules` computation entangled with restriction (and thus why the genuine module-category equivalence `U.Modules ≌ (SpecΓU).Modules` is the right and only available transport).

This is the one substantive gap in the Route-A decomposition. The "open-subscheme `j⁻¹V ≅ SpecΓ` REJECTED (restriction-injectives wall)" note rules out the *wrong* transport but does not show that Need#1 (the *standalone* transport) is necessary rather than replaceable by direct re-instantiation of the now-general Need#2.

### Route: SS — two spectral sequences (REJECTED)

- **Verdict**: SOUND — correctly rejected (both SSs absent from Mathlib, multi-kLOC, rests on the same brick as A). No action.

### Route: The acyclicity bridge (torsor-free)

- **Verdict**: SOUND — the regress-breaking chain (P3 standard-cover Čech vanishing → 01EO dimension-shift lift → affine sheaf vanishing, *never* using affine vanishing to prove itself) is explicit and non-circular; the three feeding bricks are done.

### Route: `cechAugmented_exact` — sections/sheafification route (P5a resolution input)

- **Goal-alignment**: PASS — produces resolution input (i) for Route A, for any `O_X`-module/cover (qcoh/affineness only needed downstream).
- **Mathematical soundness**: PASS — local-on-basis `{V ⊆ Uᵢ}` discharge via the prepend-`i_fix` contracting homotopy + sheafification-kills-locally-zero is sound; the DEAD-ends list (stalk functor, tilde/standard-cover discharge, naive "exact over each affine V") correctly flags the circular trap.
- **Verdict**: SOUND — only the Sub-brick A assembly glue (`widePullback_coproduct_iso` induction + `cechBackbone_left_sigma`, then Stubs 2/4/5/6) remains; bricks exist. The `Type 0` universe trap is documented.

### Route: Absolute cohomology — Ext of the corepresenting object (Form B)

- **Goal-alignment**: PASS — `H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)` keeps the SES inside `X.Modules`, deliberately avoiding the Form-A restriction-preserves-injectives obligation. Feeds 01EO / 02KG / Need#2.
- **Mathematical soundness**: PASS — injective vanishing in the 2nd arg, covariant LES at fixed 1st arg, and `H⁰ ≅ Γ` via corepresentability are all off-the-shelf and present.
- **Verdict**: SOUND — the reversal signal (Ext universe/smallness pain → Route γ Čech colimit) is a sensible documented fallback.

## Format compliance

- **Size**: 134 lines / 16281 bytes — **over budget** on bytes (~16.3 KB vs ~12 KB ceiling); line count within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order; `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes — the *active* `## Phases & estimations` table and the `## Mathlib gaps` prose carry iter tags that are narrative, not ledger: e.g. `"UNIVERSE TRAP (iter-059):"`, `"BUILT axiom-clean (iter-058)"`, `"core DONE (iter-057: modulesIsoSpecExtTransport)"`, and `"REJECTED (... analogist iter-056)"`. The "bare iter number in the Completed Iters cell" exemption does NOT cover these (they are in the active table's Risks/Needs cells and in free prose).
- **Accumulation detected**: yes (mild) — table cells in both `## Phases & estimations` and `## Completed` have grown into long multi-clause paragraphs (the 01I8 and 02KG Completed rows, the P5a-resolution Risks cell), violating "one short line per cell". No completed phase is stranded in the active table; no excised route lingers.
- **Table discipline**: PARTIAL — column structure is correct; cell length is not.
- **Format verdict**: DRIFTED

## Sunk-cost flags

(none — the strategy consistently argues routes on merits, and explicitly records REJECTED alternatives by mathematical reason, not by "we already invested".)

## Prerequisite verification

- `CategoryTheory.Abelian.Ext.mapExactFunctor`: VERIFIED (`Mathlib.Algebra.Homology.DerivedCategory.Ext.Map`; requires `[F.Additive] [PreservesFiniteLimits F] [PreservesFiniteColimits F]` — the equivalence `U.Modules ≌ (SpecΓU).Modules` supplies all three).
- `modulesIsoSpecExtTransport` / `mapExt_bijective_of_preservesInjectiveObjects`: not LSP-checkable here (project path unset; loogle timed out), but reported built axiom-clean in the Need#1 core — treat as verified-by-construction.

## Must-fix-this-iter

- Route A: CHALLENGE — justify or eliminate Need#1. State in STRATEGY.md whether `affine_serre_vanishing_general_open` is polymorphic over the ambient scheme. If yes, pivot the open-immersion acyclicity discharge to direct re-instantiation at *ambient = the leaf's affine scheme, V = ⊤*, and drop the `Spec Γ(U)` transport. If no (ambient fixed to `X`/`Spec R`), state explicitly why the leaf's cohomology is the standalone `Ext_{U.Modules}` (not an `X.Modules` restriction-entangled computation), making the equivalence transport the necessary and only available bridge.
- Format: DRIFTED — (1) trim STRATEGY.md below the ~12 KB ceiling; (2) strip iter-NNN narrative tags from the active `## Phases & estimations` table and the `## Mathlib gaps` prose (move "done in iter-NNN" facts to the `## Completed` Iters cell or to iter sidecars); (3) shorten the overgrown multi-clause table cells to one short line.

## Overall verdict

Route A and all its sub-routes are mathematically sound and the decomposition is honest — there is no circularity (the regress-breaking bridge is explicit), no sunk-cost reasoning, no phantom Mathlib prerequisite, no infrastructure deferral, and the two ACTIVE phases (resolution input + acyclicity input) are genuinely independent, both necessary, and correctly parallelizable. The single live issue is the directive's central question: now that Need#2 (general-affine-open Serre vanishing) is closed for arbitrary affine opens, the strategy has not shown that Need#1's whole-scheme `U ≅ SpecΓU` Ext transport is *necessary* rather than replaceable by directly re-instantiating Need#2 on the leaf's affine source scheme — if `affine_serre_vanishing_general_open` is polymorphic over the ambient scheme, the scheme-iso transport is redundant and the "dominant remaining wall" dissolves. The planner must resolve this in STRATEGY.md (pivot to direct instantiation, or explicitly state the obstruction that forces the transport) before dispatching the P5a-consumer provers. Format is DRIFTED (over the byte ceiling + per-iter narrative tags in the active table + overgrown cells) and should be restructured in place this iter.
