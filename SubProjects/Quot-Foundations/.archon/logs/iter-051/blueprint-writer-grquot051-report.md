# Blueprint Writer Report: grquot051
**Status:** COMPLETE

## Changes (Picard_GrassmannianQuot.tex)
- Edit 1: Add `lem:gr_chartQuotientMap_epi` (`AlgebraicGeometry.Grassmannian.chartQuotientMap_epi`, prover-target name) + proof. Split-epi via coordinate inclusion `s_I`; `u^I∘s_I=id` reduces to `X^I_I=1` minor identity. `\uses{def:gr_chart_quotient}`.
- Edit 2: Add `def:gr_globalUnitSection` (`globalUnitSection`) + `def:gr_scalarEnd` (`scalarEnd`) infra blocks under "scalar endomorphisms" remark; both wired (`scalarEnd→globalUnitSection→lem:moduleUnit_mathlib`). Expanded `def:gr_chart_quotient` Realisation note (entry→scalarEnd of ΓSpecIso image, assembled over finite biproduct); added `def:gr_scalarEnd` to its `\uses`.
- Edit 3: `def:scheme_modules_glue` — cocycle laws now explicit HYPOTHESES (C1) `g_ii=id`, (C2) `g_jk∘g_ij=g_ik` transported through `D.t`/`D.f`; "subject to which" well-defined + unique-iso.
- Added chapter-local `\providecommand{\ShMod}`.

## Verification
- leandag: `unknown_uses=[]`; my nodes not isolated; `globalUnitSection`/`scalarEnd` matched Lean; `chartQuotientMap_epi` correctly unmatched (to be proved). Begin/end balanced.

## Notes / Strategy
- None.
