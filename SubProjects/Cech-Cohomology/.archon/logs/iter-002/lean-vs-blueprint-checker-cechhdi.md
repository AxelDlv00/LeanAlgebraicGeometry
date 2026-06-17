# Lean ↔ Blueprint Checker Directive

## Slug
cechhdi

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- Two `sorry`s remain by design (`CechAcyclic.affine`, `cech_computes_higherDirectImage`) —
  out-of-scope blocked targets this iter, not placeholders to flag as red flags.
- New helper declarations created this iter have NO blueprint block yet
  (`pushPullFunctor`, `coverCechNerveOver`, `coverCechNerveOverAug`, `cechNerveCosimplicial`,
  plus pre-existing push–pull helpers `rawPushPullMap`, `rawPushPullMap_comp`,
  `pushPull_pentagon`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`,
  `rawPushPullMap_self`, `rawPushPullMap_self_gen`, `pushPullMap_eq_raw`). Report them under
  blueprint-adequacy/coverage, but they are already being tracked for blueprinting — no need
  to belabor each one.
- Focus your judgement on whether `lem:push_pull_comp` (`pushPullMap_comp`) and
  `def:cech_nerve` (`CechNerve`) — the two declarations the prover landed this iter — faithfully
  match their blueprint blocks, and whether the chapter was detailed enough to guide them.
