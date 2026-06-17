# AlgebraicJacobian/Genus0BaseObjects/Points.lean

## Status: NO-OP this iter — file already complete

### Verification

- `mcp__archon-lean-lsp__lean_diagnostic_messages` on the file returns
  `{success: true, items: []}` — zero diagnostics, file compiles
  cleanly.
- `mcp__archon-lean-lsp__lean_verify` on `AlgebraicGeometry.gm_grpObj`
  reports axiom set `{propext, Classical.choice, Quot.sound}` —
  kernel-clean, no `sorryAx`, no project axioms.
- `grep -n "sorry" Points.lean` finds the substring only inside a
  docstring (L480: "(named substantive sorries) and naturality"),
  not in any proof body.

### Why no work

- `PROGRESS.md` L162 explicitly lists
  `Genus0BaseObjects/Points.lean — 0 (DONE iter-181)`.
- `task_pending.md` index entry for the file records "DONE iter-181
  — `gm_grpObj` kernel-clean transitively. 11-iter STUCK pattern
  fully resolved. No further work."
- Iter-182 objectives 1-7 (`PROGRESS.md` L70-152) cover lanes
  A/B/D/E/F/G/I across other files. Points.lean is not on the
  active lane list and is not listed under standing deferrals
  either — it is finished.
- Per prover-prover.md: "Never modify working proofs — if a
  declaration has no `sorry` and compiles, do not touch its body."

### Lemmas in the file (all kernel-clean per iter-181 closure)

`ProjectiveLineBar.evalIntoGlobal`, `ProjectiveLineBar.irrelevant_map_eq_top`,
`ProjectiveLineBar.pointOfVec`, `ProjectiveLineBar.zeroPt`,
`ProjectiveLineBar.onePt`, `ProjectiveLineBar.inftyPt`, `GaScheme`,
`gaScheme_canOver`, `Ga`, `ga_isAffineHom`,
`ga_locallyOfFinitePresentation`, `ga_isReduced`, `GmRing`, `GmScheme`,
`gmScheme_canOver`, `Gm`, `gm_isAffine`, `gm_locallyOfFinitePresentation`,
`gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gmHomFunctor`,
`gmHomEquiv_toFun`, `gmHomEquiv_invFun_isOver`, `gmHomEquiv_invFun`,
`gmHomEquiv_left_inv`, `gmHomEquiv_right_inv`, `gmHomEquiv_homEquiv_comp`,
`gmHomFunctor_representableBy`, `gm_grpObj`, `gm_smooth`, `Gm.onePt`.

### Next-iter pickup

None for this file. If a future iter needs to touch Points.lean,
candidates are (i) signature/structure refactors driven by downstream
consumers (e.g. if the `gmHomFunctor` units-of-global-sections shape
needs to absorb a parameter for Routes 1/3) or (ii) polish-phase
helper-name hygiene.
