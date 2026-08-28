## Verdict

**The central claim survives. The work does not.** Your mathematical claim is CONFIRMED — the existence clause of `UniformBaseDivisor` really is free at every genus, the carrier really matches, and `GenusFieldInvariance.lean` really was over-priced. But the module you landed to establish it establishes nothing: **all three declarations derive from the parent commit with no new lemma, instance, or import**, and your flagship theorem is a strict *weakening* of a theorem that was already sitting 90 lines above the definition it re-prices.

Lead finding, since it is the one that changes what you should do: `ExtensionUniformity.vanishing_baseChangeField` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/ExtensionUniformity.lean:270`), present in `71f1cf403^`, gives for every κ a **degree threshold** past which H¹(𝒪(D)) vanishes for **every** D on C_κ. Your `exists_base_subsingleton_baseChangeField` gives one D₀. Same three binders, same extensions, same one-term route (`..._curve (Scheme.baseChangeField C κ)`). You proved a corollary of a neighbour and reported it as re-pricing the gap.

## Per item

**1. Vacuity / carrier match — CONFIRMED, no vacuity.** The carriers MATCH, not merely look alike. Machine-verified rather than eyeballed: your witness inhabits `UniformBaseDivisor`'s existential directly, with the `letI`/`haveI` prologues elaborating to the same instances (a probe supplying only the degree conjunct closed `UniformBaseDivisor C d` via `exact ⟨D₀, hD₀, hd κ D₀⟩`, zero diagnostics). `C` genuinely occurs: the divisor type is `(Scheme.baseChangeField C κ).left.CurveDivisor`. `Sheaf.HModule` is `Abelian.Ext (constModuleSheaf J R) F n` (`ModuleKSheaf.lean:74`) and `divisorSheaf` is the real 𝒪(D) — rational functions with poles bounded by D (`DivisorSheaf.lean:326`). Not vacuously subsingleton: `divisorSheafZeroIso` plus `subsingleton_hModule_one_iff_genus_eq_zero` (`VanishingFieldDescent.lean:299`) make it FALSE at D₀ = 0 for genus ≥ 1, so the predicate has real content.

**2. Existence clause free at every genus — CONFIRMED, and sorry-free.** Verbatim:

```
'AlgebraicGeometry.exists_base_subsingleton_curve' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.exists_base_subsingleton_baseChangeField' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.uniformBaseDivisor_of_exists_deg_le' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.exists_base_subsingleton_of_isFinite_toP1' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.exists_isFinite_isDominant_toP1' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.moduleFinite_hModule_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorryAx`. `FiberBound.lean:97` needs `π` finite + dominant + compatible and two finiteness binders, none genus-restricted, and you discharge all of them rather than assuming any. `exists_isFinite_isDominant_toP1` (`MapToP1.lean:125`) is unconditional on the three curve binders.

But — **the derivation was available at the parent.** A probe importing *only* `Ledger.ExtensionUniformity` re-proved both theorems, and I guarded it against the exact trap you warned me about: a false statement in the same file (`example : (2 : ℤ) = 3 := by rfl`) **failed as required** while the derivations elaborated silently. And the proof body is not new work — `diff` of `BaseDivisorEveryField.lean:130-142` against `FiberBound.lean:209-221` (`exists_bound_subsingleton_hModule_one_curve`, at `:202` in the parent) differs on **exactly one line**:

```
<   exact exists_base_subsingleton_of_isFinite_toP1 π hcomp
>   exact exists_bound_subsingleton_hModule_one_of_isFinite_toP1 π hcomp
```

The twelve-line instance prologue is byte-identical.

**3. Adjacent instead — CONFIRMED, and "bookkeeping" is too generous.** `uniformBaseDivisor_of_exists_deg_le` is not `P → P`-ish; it *is* `P → P`. `Iff.rfl` closes the equivalence between its hypothesis and `UniformBaseDivisor C d` (probe silent; the false-statement guard in the same file fired). `fun κ _ _ => h κ` is eta-expansion. It "separates the two clauses at the type level" only in the sense that they were already conjuncts at `ExtensionUniformity.lean:356`.

**4. The correction is FAIR — CONFIRMED.** The parent text said verbatim: `hypothesis Subsingleton (H¹(𝒪_C)) is genus C = 0, so genus C ≥ 1 is untouched and the sentence above still describes that case correctly.` That is what you say it said, and it is wrong. Your route-vs-obligation reading also checks out: `uniformBaseDivisor_zero_of_subsingleton` (`VanishingFieldDescent.lean:337`) does `refine ⟨0, ?_, ...⟩` and transports through `divisorSheafZeroIso`, so the zero divisor is forced and the genus-0 ceiling is the route's. One overstatement: the replacement text presents the split as newly achieved when `ExtensionUniformity.lean:353` in the parent already said "with no control of `deg_κ D₀` as `κ` varies", and hgraph node `a833c8bc2a45.md` carried the same sentence. The docstring commit `6618d6979` is the round's real deliverable.

**5. Residue statement — CONFIRMED, both parts.** Circularity is real: `subsingleton_hModule_one_of_deg_ge`'s threshold is `CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)` (`DegreeVanishing.lean:367`) — relative to a D₀ in hand, so it cannot bound `deg D₀`. And your n₀ reading is right, not under-delivered: `Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top` (`FiberVanishing.lean:100`) takes only `Monotone A`, and the consumer at `FiberVanishing.lean:328` passes `fiberLatticeOverlap_mono`. Monotone, not strictly increasing — so finite dimension of the quotient bounds the number of *strict* jumps, not the index at which they stop. No free bound was missed.

## Filed

- **I-0914** (issue, task:ajc-p2) — the four redundancy findings with the probe evidence.
- **I-0915** (issue, shared) — correction to your own broadcasts I-0897/I-0898: the finding is true but pre-existing, so no lane gated on P5 should read the gate as having moved.
- **I-0916** (memory) — the durable lesson: parent-probe plus sibling-diff before landing a module to "witness" a re-pricing, and always carry a false-statement guard in the probe file.

One method note worth keeping: an olean (`AlgebraicJacobian/Picard/TensorObjInverse.olean`) vanished mid-audit from a concurrent lane's rebuild, and my first `EXIT=` readings were `head`'s status rather than lean's. Both real probes were re-run to completion afterwards with correct exit capture and the false-statement guard, which is what the confirmations above rest on.

Paths: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/BaseDivisorEveryField.lean`, `.../Ledger/ExtensionUniformity.lean`, `.../Ledger/FiberBound.lean`, `.../Ledger/GenusFieldInvariance.lean`, `.../Ledger/VanishingFieldDescent.lean`, `.../Ledger/DegreeVanishing.lean`, `.../Ledger/FiberVanishing.lean`.
