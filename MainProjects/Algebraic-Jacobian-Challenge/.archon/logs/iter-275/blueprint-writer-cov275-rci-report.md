# Blueprint Writer Report

## Slug
cov275-rci

## Status
COMPLETE — all nine missing Lean declarations now carry a faithful 1-to-1
blueprint block; leandag reports no unknown_uses, no unmatched_lean among them,
and zero isolated nodes in the chapter.

## Target chapter
blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex

## Changes Made
Two additive subsections were inserted (no existing block was edited, moved, or
restructured).

### Subsection "The pole divisor \(\varphi^*[\infty]\) and its degree (Lean substrate)"
inserted at the end of §2, before the degree-1 `\section`:
- **Added definition** `\definition`/`\label{def:localParameterAtInfty}`/`\lean{AlgebraicGeometry.Scheme.localParameterAtInfty}`
  — the local parameter \(t_\infty = X_0/X_1 \in K(\mathbb P^1)\) (private Lean def). Proof note "Proved directly in Lean."
- **Added lemma** `\lemma`/`\label{lem:localParameterAtInfty_uniformiser_witness}`/`\lean{...localParameterAtInfty_uniformiser_witness}`
  — \(\ord_{[\infty]}(t_\infty)=1\), unique positive-order prime divisor. **Carries a `sorry` in Lean** → honest two-line sketch (DVR stalk on the Proj chart; substrate-gated), explicitly flagged as an open hole.
- **Added definition** `\definition`/`\label{def:hom_poleDivisor}`/`\lean{AlgebraicGeometry.Scheme.Hom.poleDivisor}`
  — \(\varphi^*[\infty] = \operatorname{positivePart}(\operatorname{div}(\varphi^\# t_\infty))\). Proof note "Proved directly in Lean."
- **Added theorem** `\theorem`/`\label{thm:poleDivisor_degree_eq_finrank}`/`\lean{...Hom.poleDivisor_degree_eq_finrank}`
  — \(\deg(\varphi^*[\infty]) = [K(C):K(\mathbb P^1)]\). Proof note: reduces to the II.6.9 pin + uniformiser witness (no own `sorry`).

### Subsection "The normalization factorisation helpers (Lean substrate)"
inserted at the end of §3, before the headline `\section`:
- **Added lemma** `\label{lem:algebraMap_bijective_of_finrank_one}`/`\lean{...algebraMap_bijective_of_finrank_one}` — degree-one algebra map over a field is bijective. "Proved directly in Lean."
- **Added definition** `\label{def:phi_left_functionField_algEquiv_of_finrank_one}`/`\lean{...phi_left_functionField_algEquiv_of_finrank_one}` — induced function-field iso \(K(C')\cong K(C)\). "Proved directly in Lean."
- **Added lemma** `\label{lem:phi_left_locallyQuasiFinite_of_finrank_one}`/`\lean{...phi_left_locallyQuasiFinite_of_finrank_one}` — local quasi-finiteness. **Carries a `sorry`** → honest sketch (fibre-set finiteness; closed-point/smooth-dim-1 gap), flagged as open hole.
- **Added lemma** `\label{lem:phi_left_toNormalization_isIso_of_isIntegralHom}`/`\lean{...phi_left_toNormalization_isIso_of_isIntegralHom}` — dominant normalization factor is iso. "Proved directly in Lean" (Mathlib instance, 0AVX dominant half).
- **Added lemma** `\label{lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one}`/`\lean{...phi_left_fromNormalization_isIso_of_smoothProper_finrank_one}` — integral normalization factor is iso over smooth target. **Carries a `sorry`** → honest sketch (smooth ⇒ normal ⇒ Dedekind sections; normality-substrate gap), flagged as open hole.

## Cross-references introduced (all statement-level for DAG edges)
- `def:localParameterAtInfty` → `\uses{def:functionFieldIso}` (germ-to-function-field embedding); receives in-edges from `def:hom_poleDivisor`, `lem:localParameterAtInfty_uniformiser_witness`.
- `lem:localParameterAtInfty_uniformiser_witness` → `\uses{def:localParameterAtInfty}`.
- `def:hom_poleDivisor` → `\uses{def:localParameterAtInfty, def:WeilDivisor_positivePart, def:principal_divisor}`.
- `thm:poleDivisor_degree_eq_finrank` → `\uses{def:hom_poleDivisor, lem:localParameterAtInfty_uniformiser_witness, lem:degree_positivePart_principal_eq_finrank, def:divisor_degree}`.
- `def:phi_left_functionField_algEquiv_of_finrank_one` → `\uses{lem:algebraMap_bijective_of_finrank_one}`.
- `lem:phi_left_locallyQuasiFinite_of_finrank_one` → `\uses{def:phi_left_functionField_algEquiv_of_finrank_one}`.
- `lem:phi_left_toNormalization_isIso_of_isIntegralHom` → `\uses{lem:phi_left_locallyQuasiFinite_of_finrank_one}`.
- `lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` → `\uses{def:phi_left_functionField_algEquiv_of_finrank_one}`.
- `lem:algebraMap_bijective_of_finrank_one` is a pure-algebra leaf; non-isolated via its in-edge from `def:phi_left_functionField_algEquiv_of_finrank_one`.

All `\uses{}` targets verified to exist (`def:functionFieldIso`, `def:WeilDivisor_positivePart`,
`lem:degree_positivePart_principal_eq_finrank`, `def:principal_divisor`, `def:divisor_degree`
in `RiemannRoch_WeilDivisor.tex`; the rest are the sibling blocks in this chapter).

## leandag verification
- `leandag build --json`: no `unknown_uses` and no `unmatched_lean` entry naming any of the nine new `\lean{}` targets (the private Lean decls all resolve).
- `leandag query --isolated --chapter RiemannRoch_RationalCurveIso`: **0 results**.
- `archon dag-query unmatched`: the previously-unmatched `Hom.poleDivisor` and
  `Hom.poleDivisor_degree_eq_finrank` (and the seven private helpers) are no
  longer reported unmatched.
- LaTeX balance: definition 3/3, lemma 8/8, theorem 2/2, proof 13/13; zero `REF` placeholders.

## References consulted
No new external reference files were opened: per the directive these helpers are
project-internal plumbing and the chapter's existing Hartshorne IV.2 / II.6.9 /
I.6.12 verbatim citations (on `lem:degree_via_pole_divisor` and
`lem:degree_one_morphism_iso`) already ground them. No `% SOURCE:` /
`% SOURCE QUOTE:` lines were added to the new blocks (none fabricated).

## Macros needed
None — all new prose uses macros already exercised by the existing chapter
(`\Div`, `\deg`, `\ord`, `\operatorname{...}`, `\mathbb P^1`, `\mathcal O`).

## Reference-retriever dispatches
None.

## Notes for Plan Agent
- The three `sorry`-bodied helpers (`localParameterAtInfty_uniformiser_witness`,
  `phi_left_locallyQuasiFinite_of_finrank_one`,
  `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`) are now finite-
  effort blueprint nodes with honest sketches; the deterministic `sync_leanok`
  will (correctly) leave their proof blocks without `\leanok`.
- `thm:poleDivisor_degree_eq_finrank` has no own `sorry` but transitively depends
  on the still-open `lem:localParameterAtInfty_uniformiser_witness` and on the
  WeilDivisor pin `lem:degree_positivePart_principal_eq_finrank`; its `\leanok`
  status is for `sync_leanok` to determine.

## Strategy-modifying findings
None.
