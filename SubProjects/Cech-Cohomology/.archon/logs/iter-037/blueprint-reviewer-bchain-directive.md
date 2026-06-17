# blueprint-reviewer directive — iter-037 (scoped fast-path re-review)

Whole-blueprint audit (you always read the whole blueprint). The iteration's focus: the Route B keystone
chain in `Cohomology_CechHigherDirectImage.tex` was rewritten this iter — 3 local-model brick blocks now
have `\lean{}` pins, 4 to-build bridge blocks B1–B4 (`lem:qcoh_finite_presentation_cover`,
`lem:presentation_over_basicOpen`, `lem:restrict_over_compat`, `lem:presentation_modulesRestrictBasicOpen`)
were added, 6 `\mathlibok` anchors added, the keystone proof + `\uses` rewritten, the Route B intro
corrected.

## HARD GATE decision I need
Report, in your per-chapter checklist, whether `Cohomology_CechHigherDirectImage.tex` is
`complete:true` AND `correct:true` with NO must-fix-this-iter finding, SPECIFICALLY for the two files I
intend to send provers to THIS iter:
- `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` (targets: B2 `lem:presentation_over_basicOpen`,
  B3 `lem:restrict_over_compat`, B4 `lem:presentation_modulesRestrictBasicOpen`)
- `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` (target: B1 `lem:qcoh_finite_presentation_cover`)

Specifically verify: (a) each B1–B4 block has a faithful statement, a `\lean{}` pin, an informal proof of
finite (non-∞) effort, and an accurate `\uses{}`; (b) the keystone's `\uses` now correctly reflects the
B-chain (and that dropping `lem:cech_acyclic_affine`/`lem:free_isQuasicoherent` from it is correct — the
analogist's route uses neither); (c) the 3 brick blocks' pins resolve; (d) no broken `\uses`/`\ref`.
Flag anything that would make a prover formalize a broken statement.
