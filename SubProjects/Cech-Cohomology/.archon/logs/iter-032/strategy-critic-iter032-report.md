# Strategy Critic Report

## Slug
iter032

## Iteration
032

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — the Leray/015E lemma (P4, done) plus a termwise `f_*`-acyclic resolution of `F` produces `Hⁱ(f_*C•) ≅ Rⁱf_*F` directly, which is exactly the frozen target's content.
- **Mathematical soundness**: PASS — the reduction "acyclicity input (ii) ⇒ affine Serre vanishing 02KG" is the standard argument; no spectral sequences needed.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (the affine-vanishing dependency is named, owned, and routed, not deferred).
- **Phantom prerequisites**: none — `InjectiveResolution.extEquivCohomologyClass` (P5a last-mile backing) VERIFIED present.
- **Effort honesty**: reasonable for the P5a/P5b rows in isolation; see the 02KG route below for the under-count.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND

### Route: The acyclicity bridge (torsor-free, load-bearing) — incl. 02KG affine instantiation

- **Goal-alignment**: PASS — the (1)`injective_cech_acyclic` + (2)`ses_cech_h1` + (3)`cech_eq_cohomology_of_basis` (01EO) chain lifts P3 standard-cover Čech vanishing to affine sheaf vanishing without using affine vanishing; the non-circular regress is correctly broken.
- **Mathematical soundness**: PASS — no circularity. 02KG depends on {01EO bridge (consuming P3's tilde-form standard-cover vanishing) AND 01I8 `qcoh_iso_tilde_sections` (Route P, pure global-generation/geometry, uses NO cohomology vanishing)}. Both branches bottom out in pure algebra (`exact_of_isLocalized_span`) — confirmed acyclic dependency graph.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no, but see effort-honesty — a load-bearing multi-iter sub-development is hidden in prose, which is adjacent to a deferral smell.
- **Phantom prerequisites**: `IsLocalizedModule.mk` VERIFIED, `IsLocalizedModule.ext` VERIFIED, `Module.Presentation` VERIFIED. `tilde_preserves_kernels` (= `PreservesFiniteLimits` of `~`) is correctly self-flagged as absent-from-Mathlib, project-to-build.
- **Effort honesty**: UNDER-COUNTED — see below.
- **Parallelism under-exploited**: no — P1a (geometry) / P1b (pure algebra, dispatch-ready) / surj_of_vanishing / P5a inputs are correctly identified as independent lanes.
- **Verdict**: CHALLENGE — the 02KG row's `~4–5 iters / ~350–600 LOC` estimate silently absorbs the ENTIRE 01I8 Route-P globalisation (P1a affine-restriction geometry `D(f)≅Spec R_f` for `SheafOfModules` + `Presentation` from `IsQuasicoherent`; P1b pure-algebra patching; P2 global generation; P3 `qcoh_kernel_qcoh` + the `tilde_preserves_kernels` left-exactness construction that is itself missing from Mathlib; P4 assembly) PLUS `surj_of_vanishing`. That 01I8 chain is a Hartshorne II.5.14–17-scale development comparable to completed rows P3 (~1200 LOC/~14 iters) and P3b (~1500 LOC/~9 iters), yet it has NO phase row of its own — it lives entirely in `## Open strategic questions` prose. Promote 01I8 globalisation to its own row in `## Phases & estimations` with an honest Iters/LOC, or rebut why ~4–5/~350–600 covers all of it.

### Route: Absolute cohomology realization — Form B (Ext of corepresenting object)

- **Goal-alignment**: PASS — `H^p(U,F) := Ext^p(jShriekOU U, F)` with `jShriekOU = sheafify(free(yoneda U))` corepresents `F ↦ F(U)`, and 01EO consumes exactly injective-vanishing + covariant LES + H⁰≅Γ, all at fixed 1st argument so the SES stays in `X.Modules`.
- **Mathematical soundness**: PASS — Form B's whole point (no restriction-of-injectives) is the correct move; the discarded Form A `Ext(O_U,F|_U)` genuinely needs the 200–500 LOC `j_!`.
- **Sunk-cost reasoning detected**: no.
- **Verdict**: SOUND

### Route: B — two spectral sequences (REJECTED)

- **Verdict**: SOUND (correctly rejected; both spectral sequences absent from Mathlib and B still rests on the same `injective_cech_acyclic` brick, so rejection loses nothing).

## Format compliance

- **Size**: 124 lines / ~10 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — `## Open strategic questions` carries iter-tagged events in prose: "**P1 `qcoh_localized_sections` SPLIT (iter-032)**", "P0 `exists_finite_basicOpen_subcover` DONE (iter-031)", "family bridge done iter-031". These are per-iter narrative; move the iter attributions to the iter sidecar and keep STRATEGY.md iter-agnostic.
- **Accumulation detected**: yes (mild) — the 01I8 Route-P workstream (P0–P4 + `tilde_preserves_kernels`) is a substantial load-bearing development described only as open-question prose rather than as a `## Phases & estimations` row; this both bloats the open-questions section and hides effort from the phase table.
- **Table discipline**: PASS — both tables have the canonical columns and short cells (Status tags are inline; LOC are ranges).
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Route "acyclicity bridge / 02KG": CHALLENGE — effort under-count. Either give the 01I8 `F≅~(ΓF)` globalisation (P1a+P1b+P2+P3+`tilde_preserves_kernels`+P4) its own phase row with an honest Iters/LOC estimate, or record an explicit rebuttal in `iter/iter-032/plan.md` justifying that the 02KG `~4–5 / ~350–600` already covers it.
- Format: DRIFTED — strip the `(iter-031)`/`(iter-032)`/"SPLIT (iter-032)" iter tags from `## Open strategic questions` (relocate the timeline to the iter sidecar), and represent the 01I8 Route-P workstream in the phase table rather than as open-question prose.

## Overall verdict

The strategic skeleton is sound and the four directive questions resolve cleanly in the strategy's favor: (Q1) the P1a/P1b split is sound and non-circular — P1b (`IsLocalizedModule` local on a finite spanning cover, via `IsLocalizedModule.mk`, both verified present) is a genuinely self-contained pure-commutative-algebra fact in `Mathlib.Algebra.Module.LocalizedModule`, independent of the cohomology machinery it serves, so building it first introduces no regress (the prover must still pin the exact span-cover patching statement that actually feeds P1, since the one-line phrasing admits several formalizations); (Q2) nothing is mis-stated against 01HV (`Γ(D(f),~M)=M_f`), 01I8 (affine `~`/Γ equivalence), 02KG (affine Serre vanishing), or 009L (cofinal coverings on a basis); (Q3) `affine_serre_vanishing` is correctly gated on BOTH the now-unblocked cover-system infra AND the unconditional `qcoh_iso_tilde_sections`, and there is no hidden circularity because Route P proves 01I8 by pure global generation without ever invoking cohomology vanishing; (Q4) carrying `[EnoughInjectives X.Modules]` with the `HasInjectiveResolutions → EnoughInjectives` connector deferred to P5b is an acceptable dependency, not a deferral red flag — the connector is genuinely ~6 LOC and direction-correct (extract the degree-0 mono-into-injective from any `InjectiveResolution`), with a concrete timeline and plan. The one substantive issue is effort honesty: the strategy understates remaining work by folding the entire Hartshorne-II.5-scale 01I8 globalisation (including the missing-from-Mathlib `tilde_preserves_kernels` left-exactness construction) into the 02KG row's `~4–5 iter / ~350–600 LOC` estimate while keeping it out of the phase table — a comparable completed phase ran ~1200–1500 LOC over 9–14 iters. This is a CHALLENGE to resolve by promoting 01I8 to its own honest phase row (or an explicit rebuttal), plus a DRIFTED format fix to strip per-iter tags from the open-questions prose.
