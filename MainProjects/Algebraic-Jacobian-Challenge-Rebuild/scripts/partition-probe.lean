import AlgebraicJacobian.Picard.DivisorFamilyAffStrict
import AlgebraicJacobian.Picard.DivisorFamilyAffAssemble

/-!
Does the WIDENED certificate route depend on a chart-wise partition of unity?

Protection I-0492 clause 3 says the chart-wise partitions "have to go". The 33 textual
`partition₀`/`partition₁` hits are a FILE-level measurement and cannot answer this: a module can
sit in the import cone without a single declaration of the widened route referencing it (memory
I-0678: price a port by DECLARATION REFERENCE, not by import closure).

So walk the transitive constant-dependency closure of the widened endpoints and ask whether
`FinCoverData.partition₀` / `.partition₁` — or the two lemmas they exist to prove, `cover₀` /
`cover₁` — occur in it. A CONTROL walks the chart-typed side, where they must occur; a probe that
reports "absent" on both sides is measuring nothing.
-/

open Lean

def depClosure (env : Environment) (start : Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut stack := [start]
  while !stack.isEmpty do
    let n := stack.head!
    stack := stack.tail!
    if seen.contains n then continue
    seen := seen.insert n
    if let some ci := env.find? n then
      -- a theorem's proof term lives in `value?`; its TYPE also carries constants
      let mut cs : NameSet := ci.type.getUsedConstants.foldl (·.insert ·) {}
      if let some v := ci.value? then
        cs := v.getUsedConstants.foldl (·.insert ·) cs
      for c in cs.toList do
        if !seen.contains c then stack := c :: stack
  return seen

/-- What to look for.  NOTE ON CALIBRATION, learned the hard way in this session: probing for
the FIELD names `partition₀`/`partition₁` reports EMPTY EVEN ON THE CHART-TYPED CONTROL, because
a producer builds the structure with `FinCoverData.mk` and the field name never occurs in the
term.  A structure field is not a constant a proof term mentions.  So probe for the CARRIER and
its constructor — that is what a dependency on the partitioned datum actually looks like — plus
the two lemmas the partitions exist to prove, which ARE ordinary constants. -/
def targets : List Name :=
  [``AlgebraicGeometry.FinCoverData,
   ``AlgebraicGeometry.FinCoverData.mk,
   ``AlgebraicGeometry.FinCoverData.cover₀,
   ``AlgebraicGeometry.FinCoverData.cover₁,
   ``AlgebraicGeometry.FinCoverData.pieces]

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
