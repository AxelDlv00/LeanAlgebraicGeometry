---
author: sync
content_type: definition
created: '2026-07-29T04:13:40'
decl: report
file: scripts/partition-probe.lean
generated: lean
lean_status: lean_ok
stale: true
title: report
type: lean
updated: '2026-07-29T04:41:56'
---
def report (label : Name) : CoreM Unit := do
  let env ← getEnv
  if (env.find? label).isNone then
    logInfo m!"MISSING DECLARATION {label} — probe invalid"
    return
  let cl := depClosure env label
  let hits := targets.filter cl.contains
  logInfo m!"{label}\n  closure size: {cl.size}\n  partition/cover deps: {hits}"

run_cmd do
  Elab.Command.liftCoreM do
    logInfo "===== PROBE: the WIDENED route ====="
    -- the R2 payoff, and the two widened endpoints it composes
    report ``AlgebraicGeometry.exists_affAdaptation_isCertified_of_straddling
    report ``AlgebraicGeometry.exists_isCertified_of_swallowing_affineOpen
    report ``AlgebraicGeometry.AffAdaptation.isCertified_of_swallowedBy_of_c1
    report ``AlgebraicGeometry.divFamZarAff_of_forall_prime_certified_adaptation
    logInfo "===== CONTROL: the CHART-TYPED route (these MUST show deps) ====="
    report ``AlgebraicGeometry.DivisorAdaptation.ofChartPair
    report ``AlgebraicGeometry.chartPairCoverData