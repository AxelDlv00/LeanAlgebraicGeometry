# Strategy Critic Report

## Slug
keystone

## Iteration
041

## Routes audited

### Route: Route A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — the augmented Čech resolution + P4 Leray lemma (015E) yields `Hⁱ(f_*C•) ≅ Rⁱf_*F` directly, which is exactly the protected `cech_computes_higherDirectImage` weak-iso target.
- **Mathematical soundness**: PASS — reduces acyclicity input (ii) to affine Serre vanishing (02KG), the canonical Stacks reduction. No spectral sequences, single abstract lemma.
- **Verdict**: SOUND

### Route: Route SS — two spectral sequences (REJECTED)

- **Verdict**: SOUND (correctly rejected; both spectral sequences absent from Mathlib and it rests on the same `injective_cech_acyclic` brick as A — no advantage).

### Route: The acyclicity bridge (Čech↔derived, 01EO)

- **Mathematical soundness**: PASS — the non-circularity argument is correct: P3 produces *standard-cover* Čech vanishing; the bridge (`injective_cech_acyclic` + `ses_cech_h1` + `cech_eq_cohomology_of_basis`/01EO) lifts it to *affine sheaf* vanishing (02KG) without ever consuming affine vanishing. The regress is genuinely broken.
- **Verdict**: SOUND

### Route: 01I8 affine `F≅~(ΓF)` — section-localization (Route B; the live route)

- **Goal-alignment**: PASS — `IsIso fromTildeΓ` ⟹ unconditional `qcoh_iso_tilde_sections`, which is exactly what the two 02KG tops consume.
- **Mathematical soundness**: PARTIAL — the local tile structure (B0–B4) is sound and non-circular (tilde RIGHT-exactness for `F|_{D(gⱼ)}≅~Mⱼ`, correctly flagged as the load-bearing pitfall). The *last-mile descent* carries a genuine circularity (see below) that the strategy has correctly surfaced but not yet resolved.
- **Sunk-cost reasoning detected**: no — the route was selected on merits (Route B converts Route P's two genuine-math walls into one bounded categorical bridge), not on "we already built it." See minor lock-in note in the alternatives section.
- **Infrastructure-deferral detected**: no — every B-leaf is built project-side with a concrete chain; nothing is punted to "Mathlib upstream."
- **Phantom prerequisites**: the strategy is disciplined here — it explicitly records that `IsLocalizing` and `isIso_fromTildeΓ_iff_isLocalizing` do NOT exist and routes around them. (I could not independently re-verify `Tilde.fromTildeΓ`, `isIso_fromTildeΓ_of_presentation`, `isIso_fromTildeΓ_iff` this iter — loogle/local-search were down with timeouts/502 — but these are the standard Mathlib `Modules.Tilde` qcoh API and the strategy's track record on name-existence is good.)
- **Effort honesty**: reasonable — `~120–250` LOC / `~2–3` iters for keystone+assembly is consistent with the realized P3 (`~1200`) and B-chain scope; the remaining piece is genuinely the last brick, not a sprawl.
- **Verdict**: CHALLENGE — the keystone descent circularity is real and must be resolved (route confirmed) before the keystone closes; details below.

### Route: Absolute cohomology realization — Ext of the corepresenting object (Form B)

- **Mathematical soundness**: PASS — `H^p(U,F):=Ext^p(jShriekOU U, F)` with `jShriekOU = sheafify(free(yoneda U))` keeps the SES in `X.Modules`, giving off-the-shelf injective-vanishing (`Ext.eq_zero_of_injective`) + covariant LES at fixed first arg. Cleanly sidesteps the restriction-preserves-injectives `j_!` wall that Form A would need.
- **Verdict**: SOUND

## Format compliance

- **Size**: 156 lines / 15400 bytes — **over budget** (~12 KB ceiling; 15.4 KB is ~28% over). Line count is within the 250 budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes (borderline) — the `## Routes` and `## Open strategic questions` prose carries inline iter stamps: `"DONE iter-037"`, `"iter-038"`, `"iter-040"`, `"the iter-037 bridge.md B6 over-claimed"`, `"NEW, iter-041"`. Bare iter stamps in the `## Completed` *table* are fine, but `"the iter-037 bridge.md B6 over-claimed"` in Routes/Open-questions prose is per-iter narrative that belongs in an iter sidecar.
- **Accumulation detected**: yes (mild) — the `## Routes` "01I8 section-localization" subsection has grown a fully-itemized B0–B6 changelog with per-leaf DONE stamps; this is drifting from a route description toward a build-log. The B-leaf status detail (which leaf done when) is sidecar material; `## Routes` should describe the *route*, not its per-iter completion ledger.
- **Table discipline**: PASS — both tables well-formed, short cells.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

(none — every required construction is built project-side with a concrete chain; no goal-required item is parked at "Mathlib upstream" without a project plan.)

## Alternative routes (suggested)

### Alternative: close the keystone via the sheaf-basis criterion `isIso_fromTildeΓ_iff` instead of the module-descent lemma

- **What it looks like**: Rather than proving `IsLocalizedModule (powers f) ρ_f` by descending through `isLocalizedModule_of_span_cover` over `{gⱼ}`, check `IsIso F.fromTildeΓ` directly on the basis `{D(gⱼ)}` via the essImage/basis form `isIso_fromTildeΓ_iff`. On each `D(gⱼ)` the tile is tilde-structured (B4: `F|_{D(gⱼ)}≅~Mⱼ`), so `fromTildeΓ` is locally the Mathlib tilde iso; the *global* glue is supplied by F's H⁰ sheaf condition on the affine cover — which is **free** (F is a sheaf by definition), not gated on any affine H¹ / 02KG.
- **Why it might be cheaper or sounder**: the diagnosed circularity arises *specifically from the shape of `isLocalizedModule_of_span_cover`'s hypothesis* — it demands the abstract `LocalizedModule(powers gⱼ)Γ(X,F)`, i.e. keystone-at-`gⱼ`, to prove keystone-at-`f`. That lemma cannot bootstrap itself: keystone-at-`gⱼ` is the same statement as keystone-at-`f`. The sheaf-basis route never asks for an abstract module localization as a *hypothesis*; it asks for (a) local tilde structure (have it, B4) and (b) the H⁰ equalizer for F on the cover (free, sheaf axiom). That is the honest Stacks 01HV/01I8 proof and it side-steps the circular hypothesis rather than trying to feed it.
- **What the current strategy may have rejected**: not clearly rejected — the directive itself raises this route, and the strategy's "Resolution candidate" (reuse P3 `exact_of_isLocalized_span`/`sectionCech` H⁰) is *adjacent* to it. The open question is whether P3's H⁰ machinery, built for `~M` sheaves, applies to the *abstract* global F (whose global sections are NOT yet known to be tilde). The sheaf-basis criterion is cleaner precisely because it only needs F's sheaf condition, which holds for abstract F. **Note this is NOT a return to Route P**: it uses neither `tilde_restrict_basicOpen` nor `tildePreservesFiniteLimits` nor `IsLocalizing`.
- **Severity of the omission**: major — the strategy should explicitly weigh `isIso_fromTildeΓ_iff` (basis) against `isLocalizedModule_of_span_cover` (module descent) before committing the keystone-closing lane, because the circularity it just discovered is a property of the *latter tool's hypothesis shape*, and the former may dissolve it rather than patch it.

## Must-fix-this-iter

- Route B (01I8 keystone): CHALLENGE — the descent circularity is real and correctly diagnosed: `isLocalizedModule_of_span_cover` demands keystone-at-`gⱼ` (the abstract `LocalizedModule(powers gⱼ)Γ(X,F)`) as the per-element hypothesis, which is the same statement it is trying to prove, so it cannot bootstrap. The planner must, this iter, either (a) confirm the P3-reuse resolution genuinely supplies the H⁰ glue for the *abstract* global F (not just for `~M` tiles) and record why that is non-circular, or (b) pivot the keystone-closing lane to the sheaf-basis criterion `isIso_fromTildeΓ_iff` where the H⁰ glue is free from F's sheaf condition. A bare "analogist will resolve" is not a resolution — the route must be named and its non-circularity argument written down before any keystone prover dispatch.
- Format: DRIFTED — STRATEGY.md is ~28% over the 12 KB byte budget (15.4 KB) and the `## Routes` "01I8 section-localization" subsection plus `## Open strategic questions` carry per-iter build-log prose (`"DONE iter-037/038/040"`, `"the iter-037 bridge.md B6 over-claimed"`). Move the B-leaf completion ledger and iter-stamped narrative to an iter sidecar; keep `## Routes` describing the route, not its per-iter status. This will also bring the byte count back under budget.

## Overall verdict

The overall Route A → 02KG → 01I8 → Route B decomposition is **sound** and faithfully matches the canonical Stacks skeleton (01HV/01I8/02KG/02KE/01EO): Route A's Leray reduction, the non-circular Čech↔derived acyclicity bridge (01EO), and Form-B absolute cohomology are all in good shape, and there are no infrastructure-deferral findings — every goal-required construction is built project-side. The single live issue is the **keystone last-mile descent**, and the strategy's own diagnosis of it is correct: `isLocalizedModule_of_span_cover` cannot prove keystone-at-`f` because its per-`gⱼ` hypothesis *is* keystone-at-`gⱼ`, the identical statement — the module-descent tool's hypothesis shape creates the circularity. The strategy has surfaced this honestly and flagged it open, which is the right reflex, but "analogist resolving" is not yet a resolution. The cleaner strategic response is to close the keystone through the sheaf-basis criterion `isIso_fromTildeΓ_iff` (basis `{D(gⱼ)}` + B4 tile tilde-structure + the *free* H⁰ sheaf condition on the global F), which dissolves the circularity at the source rather than trying to satisfy a self-referential hypothesis — and crucially this does NOT resurrect the deliberately-avoided Route P tilde-base-change wall. Sunk-cost lock-in is minor: B0–B4 (local tilde structure) is reusable under either keystone-closing route, so only the final descent tool is in question, not the chain. Verdict: **CHALLENGE** on Route B's keystone-closing lane (resolve route + write the non-circularity argument before dispatch), with a format DRIFTED flag to trim the over-budget iter-stamped build-log prose back into a sidecar.
