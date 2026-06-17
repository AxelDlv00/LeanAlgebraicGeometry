# lean-auditor iter-195 directive

## Files modified this iter

The following `.lean` files received prover edits this iter — pay extra
attention to them, but audit the WHOLE project:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
  (Lane G: structural carving — new private helper `auslander_buchsbaum_formula_succ_pd` at L1106-1124 with typed sorry at L1115; main `auslander_buchsbaum_formula` n=k+1 branch delegates via `exact auslander_buchsbaum_formula_succ_pd k _hpd`)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
  (Lane H: new project-local `instance sheafCompose_preservesFiniteLimits` ~L340; `Scheme.IsFlasque.shortExact_app_surjective` body closed via `Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono`; 1 sorry closed)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuotScheme.lean`
  (Lane F: Stage 1 `have stage1 := _step2_apply x` landed inside `pullback_app_isoTensor_baseMap_sectionLinearEquiv` body L999-1080; (N1)-(N4) substrate gaps documented; net sorry count 12)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean`
  (Lane A: 6 axiom-clean substeps inside `exists_nonconstant_rational_from_dim_eq_two` body at L1323 — `htF_zero`, `htF_smul`, `htF_add`, `hs₁_ne`, finite Module instance, `hN`, extraction of `s` via `Submodule.exists_of_finrank_lt`)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
  (Lane RCI: NEW file-private typed-sorry helper `localParameterAtInfty_uniformiser_witness` at L463 with 3-step closure path docstring; consumer `Hom.poleDivisor_degree_eq_finrank` body now delegates via `exact ... kbar`)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
  (Lane I: new generic Finsupp helper `Finsupp.sum_max_zero_eq_sum_filter_pos` at L684-709 (kernel-clean); `degree_positivePart_principal_eq_finrank` body now closes 3 sub-steps (Y₀ destructure → sum-max → filter-pos → principal_apply rewrites) before residual sorry; `instIsRegularInCodimOneProjectiveLineBar` body opened with `refine ⟨fun Y => ?_⟩`)

## Focus areas

- Outdated comments that no longer reflect the current proof body (especially
  the iter-194-iter-195 narrative comments inside `degree_positivePart_principal_eq_finrank`
  and `auslander_buchsbaum_formula`).
- Excuse-style comments ("will fix later", "temporary wrong def", "iter-196+")
  that should be treated as red flags.
- Dead-end private helpers from prior iters that are no longer referenced.
- `:= sorry` carriers that propagate `sorryAx` silently through typeclass synthesis.
- Unused-hypothesis linter warnings (several in AuslanderBuchsbaum.lean for
  `[DecidableEq ι]`, `[Fintype ι]` on the pi-const helpers — see lake build output).
- Deprecation warnings (`CategoryTheory.Sheaf.val` deprecated in favor of
  `ObjectProperty.obj` — currently triggers in H1Vanishing.lean L102, L638-648
  and OCofP.lean L953).

## Project tree

Read whatever you need under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`.

Use whole-project breadth. Your output is a per-file checklist plus a flagged-issues block.
