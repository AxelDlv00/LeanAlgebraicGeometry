# Blueprint Reviewer Directive

## Slug
iter104

## Strategy snapshot

Project formalizes the Jacobian of a smooth proper geometrically irreducible
curve over a field, following Christian Merten's challenge
(`references/challenge.lean`). The nine protected declarations in
`archon-protected.yaml` are the deliverables. Status:

- **Phase A (Čech acyclicity, `BasicOpenCech.lean`)**: 6 sorries, file
  compiles. Active target = `cechCofaceMap_pi_smul` trailing sorry (L1147,
  was L988 in iter-104 numbering). Iter-104 closed `cechCofaceMap_summand_family_R_linear`
  body; iter-105 added wrapper `cechCofaceMap_summand_family' :
  ... → Fin (n+1) → ...` + R-linearity transport theorem, both proved;
  partial structured proof at L1147 isolates the residual to a clean
  morphism-level eqToHom-vs-Pi.π transport identification at
  coordinate j'. **Iter-106 (project narrative) plan: close L1147 via
  Route 1 (Pi.lift_ext + per-coord match) OR Route 3 (`convert h_wrap_pt
  using 3` + eqToHom subgoals).**
- **Phase B (`Differentials.lean`)**: 5 sorries; L636 `case h_exact` of
  `cotangentExactSeq_structure` DEFERRED parallel to `instIsMonoidal_W`
  (both Mathlib-gap blocked). Other Phase B downstream sorries (L122,
  L957, L974, L1116) dormant.
- **Phase C0 (`Modules/Monoidal.lean` `instIsMonoidal_W`)**: 1 sorry,
  DEFERRED indefinitely (Mathlib `stalk_tensorObj` gap). Not gating.
- **Phase C1–C3 (`Picard/LineBundle.lean`, `Picard/Functor.lean`,
  `Jacobian.lean`)**: scheduled iter-106+; LineBundle refactor first,
  then PicardFunctor re-derivation, then representability/JacobianWitness
  via FGA-Hilbert OR Sym^g/S_g.

Active blueprint chapter for this iter's target: `Cohomology_MayerVietoris.tex`
covers `cechCofaceMap_pi_smul` and supporting helpers.

## Routes

The strategy is **single-route** at the top level (one Jacobian construction
target). Phase A's L1147 closure has two TACTICAL routes (Route 1 vs Route 3)
but both close the same theorem — these are tactic choices, not strategic routes.

Phase C3 has two routes (FGA-Hilbert vs Sym^g/S_g) but is gated on C0–C2;
**not** in scope this iter for blueprint readiness.

## References
- `references/challenge.lean`: original AI challenge file by Christian
  Merten. Authoritative for the nine protected declarations'
  signatures. Blueprint chapters `Genus.tex`, `Jacobian.tex`,
  `AbelJacobi.tex`, `Picard_Functor.tex`, `Differentials.tex` reflect
  these.

## Focus areas (optional)

- `Cohomology_MayerVietoris.tex`: this iter's prover target. Verify
  that `cechCofaceMap_pi_smul`, the iter-104 named family helpers, the
  iter-105 wrapper helpers, and `alternating_*` helpers are documented
  and the proof sketch reflects the current decomposition (Route B
  via wrapper). Pay extra attention.
- `Differentials.tex`: confirm `h_exact` deferral is captured; flag if
  the chapter implies an unblockable Mathlib path.
- `Picard_LineBundle.tex` + `Picard_Functor.tex`: forward-looking
  Phase C1/C2 — flag if the chapters bake in the OLD `CommRing.Pic`
  proxy without acknowledging the iter-106+ refactor.

## Known issues
- `cechCofaceMap_summand_family'` (iter-105 NEW), `cechCofaceMap_summand_family'_R_linear`
  (iter-105 NEW), `cechCofaceMap_summand_family` (iter-104), and
  `cechCofaceMap_summand_family_R_linear` (iter-104, body closed) may
  lack `\lean{...}` entries in `Cohomology_MayerVietoris.tex` — flag if
  missing, do NOT propose fixes (plan agent will dispatch a
  blueprint-writer next iter if needed).
- Pure-Lean project-local helpers without `\lean{...}` entries are
  acceptable; only the protected/headline theorems need them.
