# Strategy Critic Report

## Slug
iter053

## Iteration
053

## Routes audited

STRATEGY.md carries 6 route subsections. Two are inert (`Route SS` REJECTED one-liner;
`01I8` DONE retrospective) and are addressed under Format. The four substantive/live routes
are audited below.

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — `(CechComplex f 𝒰 F) = f_*` of the (non-augmented) Čech complex; Leray
  015E on an `f_*`-acyclic resolution yields exactly `Hⁱ(f_* C•) ≅ Rⁱf_* F`, the protected goal's iso.
- **Mathematical soundness**: PASS — the spine "resolution + termwise acyclicity ⟹ Leray ⟹ iso" is the
  standard Stacks 015E argument; P4 supplies the abstract lemma (done, axiom-clean), avoiding any
  spectral sequence (correctly, since Mathlib has none).
- **Verdict**: SOUND

### Route: The acyclicity bridge (torsor-free, load-bearing)

- **Goal-alignment**: PASS — supplies the affine Serre vanishing (02KG) that Route A's termwise
  acyclicity consumes.
- **Mathematical soundness**: PASS — and the non-circularity claim holds: 02KG (affine *sheaf*
  vanishing) is derived from P3 standard-cover Čech vanishing (pure localization algebra) lifted by the
  01EO bridge "without ever using affine vanishing." Since 02KG is now CLOSED *independently* of any P5a
  artifact, the P5a→P5b arc that consumes it is acyclic — no hidden regress.
- **Verdict**: SOUND

### Route: cechAugmented_exact — sections/sheafification route (P5a resolution input)

- **Goal-alignment**: PASS — produces input (i) of Route A (augmented Čech complex is a resolution of F).
- **Mathematical soundness**: PARTIAL — the *mechanism* is achievable, but the **named primary input does
  not obviously discharge the stated obligation**. The route claims the homology presheaf is "locally
  zero on the affine basis (`sectionCech_affine_vanishing`, P3)". But `sectionCech_affine_vanishing` is
  the P3 vanishing for the **basic-open standard cover** `{D(fᵢ)}` (giving `0→M→∏M_{fᵢ}→⋯` exact),
  whereas the augmented Čech complex's section complex over an affine `V` is the Čech complex of the
  **restricted cover `{Uₛ ∩ V}`** — a *different* cover. The clean, cover-agnostic discharger is the
  insert-index contracting homotopy (which the strategy lists only as *fallback*): for `V ⊆` some `U_{s₀}`,
  the restricted cover contains the whole-space member `U_{s₀}∩V = V`, so its Čech complex is acyclic.
  The same prose simultaneously warns that "section complex exact over each affine `V` is CIRCULAR
  (= Ȟᵖ(V,·), ≠0)" — true only for `V` *not* contained in a single cover member; the escape (restrict to
  a basis of affines each inside some `Uₛ`) is exactly what is left unstated. The route is not unsound —
  a sound path exists — but which lemma actually closes it, and on which basis, is ambiguous as written.
- **Phantom prerequisites**: none new; `homologyIsoSheafify` is project-built; `reflects_exact_of_faithful`,
  `LocallyBijective` are the documented mechanism (not re-verified, but not the seam here).
- **Verdict**: CHALLENGE — clarify the basis-choice that makes the local homology vanishing non-circular
  (each basis affine ⊆ some `Uₛ` ⟹ insert-index acyclicity), and either confirm `sectionCech_affine_vanishing`
  delivers it on that basis or promote the insert-index homotopy to the primary mechanism. Low-cost: a sound
  path is already in the strategy; this is a naming/argument-precision fix, not a route replacement.

### Route: Absolute cohomology realization — Ext of corepresenting object (Form B)

- **Goal-alignment**: PASS — realizes `Hᵖ(U,F)` feeding 01EO → 02KG; the corepresentability chain (H⁰≅Γ),
  injective vanishing, and covariant LES all stay inside `X.Modules`, avoiding the `j_!` functor.
- **Mathematical soundness**: PASS — Form B correctly sidesteps restriction-preserves-injectives by placing
  the injective as the *second* Ext argument; this phase is already CLOSED (iter 028, axiom-clean).
- **Verdict**: SOUND

## Format compliance

- **Size**: 121 lines / 12356 bytes — marginally OVER budget (~12 KB ceiling; 12.1 KB).
- **Headings**: PASS — exact canonical order (`Goal`, `Phases & estimations`, `Completed`, `Routes`,
  `Open strategic questions`, `Mathlib gaps & new material`).
- **Per-iter narrative detected**: no — iter numbers appear only in the `## Completed` ledger cells (allowed).
- **Accumulation detected**: yes —
  (a) the **02KG row is still in the active `## Phases & estimations` table** marked `CLOSING ~1`, but the
  directive states both `affine_serre_vanishing` and `affine_cech_vanishing_qcoh` are now CLOSED/axiom-clean;
  a completed phase must MOVE to `## Completed`.
  (b) the **`01I8 … Route B … DONE`** subsection still occupies a `## Routes` slot ("No further work")
  while its full retrospective already lives in `## Completed` — a completed route left in the active routes list.
- **Table discipline**: PASS (structure) with mild drift — several `## Phases & estimations` cells
  (`Key Mathlib needs`, `Risks`) are multi-clause sentences rather than "one short line".
- **Format verdict**: DRIFTED — moving the 02KG row to `## Completed` and deleting the DONE 01I8 route
  subsection resolves both the accumulation and the marginal size overage.

## Prerequisite verification

- `CategoryTheory.InjectiveResolution.extEquivCohomologyClass`: VERIFIED (Mathlib
  `CategoryTheory/Abelian/Injective/Ext.lean`) — backs the P5a last-mile `Hᵏ((f_*I•)(V)) = Extᵏ(jShriek(f⁻¹V),G)` bridge.
- `Ext.covariant_sequence_exact₁/₂/₃`: VERIFIED in-use (project `AbsoluteCohomology.lean`, closed axiom-clean phase).
- `Ext.eq_zero_of_injective`: VERIFIED in-use (same file).
- EnoughInjectives connector (`HasInjectiveResolutions C → EnoughInjectives C`): mathematically trivially true
  (an injective resolution begins with a mono into an injective); ~6 LOC with a concrete P5b lane and timeline —
  NOT an unresolved deferral.

## Must-fix-this-iter

- Route cechAugmented_exact: CHALLENGE — name the affine basis (each element ⊆ some `Uₛ`) on which the
  augmented Čech homology presheaf is locally zero, and state whether `sectionCech_affine_vanishing` (basic-open
  standard cover) discharges it there or whether the insert-index contracting homotopy is the actual primary
  mechanism. Resolve in the route prose or via rebuttal in plan.md.
- Format: DRIFTED — move the CLOSED 02KG row from `## Phases & estimations` to `## Completed`, and delete the
  DONE `01I8` subsection from `## Routes` (retrospective already in `## Completed`). This also clears the marginal
  size overage.

## Overall verdict

Route A remains the right and effectively the only viable spine: with Mathlib lacking spectral sequences, the
acyclic-resolution comparison (P4/Leray 015E) is the correct mechanism, and now that 02KG affine Serre vanishing
is CLOSED *independently* — derived from pure-localization P3 via the 01EO bridge, never from affine sheaf
vanishing — the P5a→P5b arc is genuinely non-circular: termwise acyclicity (`higherDirectImage_openImmersion_comp`)
consumes a finished 02KG, `cechAugmented_exact` consumes finished P3, and P5b consumes finished P4 plus those two.
The two P5a obligations (`cechAugmented_exact` exactness vs. `higherDirectImage_openImmersion_comp` termwise
acyclicity) are logically independent and should be dispatched as two parallel prover lanes rather than serialized
under one phase row; bundling them risks a 2× iter inflation, and the project's own 01I8 precedent (~14 iters vs.
est. ~2) argues the ~4–5 iter P5a estimate is optimistic. No infrastructure-deferral findings: nothing required by
the stated goal is parked as "future work" or "upstream Mathlib" — the only off-DAG items (presheaf
enough-injectives / δ-functor universality, the dormant circular `qcoh_localized_sections`) are not on the Route-A
critical path. The single substantive CHALLENGE is a precision fix on `cechAugmented_exact`'s primary input, not a
route defect; a sound fallback (insert-index homotopy) is already in the strategy. Strategy is SOUND; resolve the
one CHALLENGE and the two format accumulations this iter.
