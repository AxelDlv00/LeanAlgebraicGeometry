# Strategy Critic Report

## Slug
iter031

## Iteration
031

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — the augmented Čech complex as an `(pushforward f)`-acyclic resolution feeds the P4 Leray lemma `rightDerivedIsoOfAcyclicResolution` to land exactly `Hⁱ(CechComplex) ≅ Rⁱf_*F`, the frozen target. No gap between route end-state and goal.
- **Mathematical soundness**: PASS — resolution + termwise acyclicity ⇒ derived-functor iso is the standard 015E argument, and P4 is reported axiom-clean and complete. The only open input is acyclicity (ii), correctly reduced to affine Serre vanishing (02KG).
- **Verdict**: SOUND

### Route: B — two spectral sequences (REJECTED)

- **Verdict**: SOUND (correctly rejected; both spectral sequences absent from Mathlib, multi-kLOC, and rest on the same `injective_cech_acyclic` brick as A — no leverage).

### Route: The acyclicity bridge (torsor-free)

- **Goal-alignment**: PASS — lifts P3's standard-cover Čech vanishing to affine sheaf vanishing via the 01EO dimension-shift (`cech_eq_cohomology_of_basis`), which is what 02KG/Route A consume.
- **Mathematical soundness**: PASS — non-circularity is real and verified by inspection: P3 proves vanishing for `F = ~M`; the bridge (`injective_cech_acyclic` + `ses_cech_h1` + 01EO) never invokes affine sheaf vanishing, so it does not assume its own conclusion. All three bricks reported done.
- **Verdict**: SOUND

### Route: Absolute cohomology realization — Ext of corepresenting object (Form B)

- **Goal-alignment**: PASS — `H^p(U,F) := Ext^p(jShriekOU U, F)` keeps the SES inside `X.Modules` so injective-vanishing uses `I` as the **second** Ext argument, dodging restriction-preserves-injectives. 01EO chain (L1–L4+top) reported axiom-clean.
- **Mathematical soundness**: PASS — corepresentability `Γ(U,F)=F(U)` via `sheafify∘free∘yoneda` is sound; the reversal signal (Ext universe/smallness pain → Route γ, never `Sheaf.H`) is a sensible guardrail.
- **Verdict**: SOUND

### Route: 01I8 `F ≅ ~(ΓF)` via Route P (global generation) — NEW this iter

- **Goal-alignment**: PASS — supplies exactly what 02KG needs to apply P3's tilde-form vanishing to a general quasi-coherent `F` on an affine. Without this instance, P3's `F=~M` result does not transport to arbitrary qcoh `F`, so the instance is genuinely on the critical path and is being built, not deferred.
- **Mathematical soundness**: PASS — the P0→P4 ordering is the standard Hartshorne II.5.14–17 / Stacks 01I8 argument and is non-circular against the cohomology machinery: P1 (`Γ(D(f),F)=Γ(X,F)_f`) is a pure `H⁰`/localization-exactness fact derived from the qcoh **local-presentation** definition, not from `F≅~ΓF` and not from any higher-cohomology vanishing; P2 (global generation) and P3 (kernel-qcoh) build on P1; P4 just feeds P2+P3 to the already-done `isIso_fromTildeΓ_of_genSections`. No step consumes 02KG/02KE/Čech vanishing, so there is no regress.
- **Infrastructure-deferral detected**: no — Route P is the opposite of deferral: the previously-vague "few-hundred-LOC instance" is now decomposed into a concrete `\uses`-chain (P0 topology → P1 load-bearing localization gap → P2 → P3 → P4). The two genuine Mathlib gaps (P1 `qcoh_localized_sections` for general qcoh, P3 sub-gap `tilde_preserves_kernels` = `PreservesFiniteLimits` of `~`) are named as project-side material, not pushed upstream.
- **Phantom prerequisites**: none — Route-G rejection verified (`Module.GlueData` returns no results in current Mathlib); `tilde_preserves_kernels` is honestly self-flagged as Mathlib-absent rather than assumed present.
- **Effort honesty**: mildly under-counted — see effort note in Overall verdict. The 02KG row (`~4` iters / `~400–650` LOC) bundles the full P0–P4 chain *plus* `tilde_preserves_kernels` (a non-trivial `PreservesFiniteLimits` proof, Mathlib-absent) *plus* the `O_X`-epi local-surjectivity gap-fill *plus* the CechBridge re-param ripple. That is plausibly 5–7 iters of work, not 4.
- **Verdict**: SOUND

## Format compliance

- **Size**: ~150 lines / well under budget — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order (treating the directive-appended References index / Blueprint chapters / Focus question as directive context, not STRATEGY.md body).
- **Per-iter narrative detected**: yes — the 01I8 Open-questions bullet carries an iteration reference and a per-iter consult attribution: `"mathlib-analogist o1i8route (iter-031) decisively chose Route P ... and REJECTED Route G"`. Iteration numbers and "the analogist this iter chose X" belong in `iter/iter-NNN/plan.md`, not STRATEGY.md. Keep the *decision* (Route P over Route G, with the `Module.GlueData`-absence reason); drop the `(iter-031)`/consult-attribution framing.
- **Accumulation detected**: no — Completed table is 6 rows (within bound), no completed phase lingering in the active table, no excised route still occupying a `## Routes` subsection.
- **Table discipline**: PASS — both tables well-formed; `Status`/`LOC` cells are tags/ranges, not prose or velocity.
- **Format verdict**: DRIFTED — single per-iter-narrative phrase; strip in place, no full restructure needed.

## Prerequisite verification

- `Module.GlueData`: MISSING (confirms Route-G rejection is correct, not avoidance).
- `tilde_preserves_kernels` (`PreservesFiniteLimits` of `~`): MISSING — correctly self-flagged by the strategy as a project-side gap, so not a phantom dependency.
- `InjectiveResolution.extEquivCohomologyClass`: could not confirm via loogle name-search (no results); flagged as "CONFIRMED present" in prior iters. Not load-bearing for this iter's focus (P5a last-mile), but the plan agent should re-confirm the exact Mathlib name before the P5a consumer lane relies on it.

## Overall verdict

The strategy is **SOUND**. The iter-031 delta — recording the Route-P (global generation) decomposition for the missing `[IsQuasicoherent F] → IsIso F.fromTildeΓ` instance — is a strict improvement: it converts a vague "few-hundred-LOC gap" into a concrete, non-circular P0→P4 `\uses`-chain whose hardest prerequisite (P1 `qcoh_localized_sections`) is a low-level `H⁰`/localization fact independent of the cohomology machinery it ultimately supports, so there is no hidden regress and no infrastructure deferral. Route A's core remains sound and the acyclicity bridge remains non-circular. Two non-blocking notes for the plan agent: (1) **format DRIFTED** — strip the `(iter-031)`/analogist-consult per-iter narrative from the 01I8 Open-questions bullet while keeping the Route-P/Route-G decision and its `Module.GlueData`-absence rationale; (2) **effort mildly under-counted** — the 02KG row's `~4` iters / `~400–650` LOC absorbs the entire P0–P4 chain plus the Mathlib-absent `tilde_preserves_kernels` plus the `O_X`-epi gap-fill plus the CechBridge re-param ripple, which realistically reads as 5–7 iters; consider splitting the 01I8 sub-project into its own phase row so the estimate stays honest. Neither note blocks proceeding this iter.
