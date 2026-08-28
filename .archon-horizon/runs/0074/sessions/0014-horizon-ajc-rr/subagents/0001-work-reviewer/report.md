Filed as I-0720, I-0721, I-0722 (issues, routed as conversations to the task) and I-0723 (memory).

## Verdict: CONVERGING, and the central claim holds — but the residue is stated one notch weaker than the project can prove

Round 6 is real throughput, not churn. After five rounds of audit-and-decompose with nothing landed against extension-uniformity, r6 landed a genuine theorem: 541 new Lean lines, sorry-free, kernel-clean (`lake env lean` on `GenusFieldInvariance.lean` exits 0 with no warnings), closing one of the two named open inputs. No helper-churn, no sorry-stall, no new axioms, no artificial disjunctions.

**The central claim survives every attack I made.** `genus_baseChangeField` really does prove `genus (baseChangeField C κ) = genus C` for every field extension with no hypothesis on κ/k. The dependency chain is what the docstring says: `sectionsBaseChangeField` (mathlib qcqs `pushoutSection`) → `sectionDiffₗ_baseChangeField` (restriction-naturality) → `quotRangeBaseChangeField` (the flatness-*free* `lTensor_exact` from `LinearAlgebra/TensorProduct/RightExactness.lean:293`, not the `[Flat R M]` one) → `Module.finrank_baseChange`. No Serre duality, no semicontinuity, no Mumford II.5. The three-way distinction is kept scrupulously — nothing claims `UniformVanishing C` is proved, and global generation is untouched.

**The axiom probe is sound.** Exit 0; 20 real declarations clean at `[propext, Classical.choice, Quot.sound]`; both controls fire `sorryAx` **and** elaborate (the only warning is the intended local sorry at line 109) — the r5 mistake is not repeated. `synth_genus`/`synth_reduction`/`synth_chi` do resolve their instance stacks by synthesis. Scope was respected: all five commits touch only `RiemannRoch/Ledger/**` and `scripts/`.

Two things it under-reported: it made **six** commits, not five (`4ce674f34` added the rootedness caveat to the probe), and my independent import-cone walk confirms its measurement exactly — 263 modules rooted, 18 outside, **both new modules outside the cone**, `CohomologyKit`/`CurveBaseChange` inside. The caveat's reasoning is correct: `lake env lean` elaborates the full closure, so the readings are sound; only a root-walking audit misses them.

### The three findings that matter

**1. The cover argument is removable (I-0720).** This is the real defect. `genus_baseChangeField` (`GenusFieldInvariance.lean:310`) takes `(S : C.left.AffineCoverMVSquare)`; AJCR's `genus_baseField` takes no cover, internalizing it via `AffineTwoCover.nonempty_of_curve`. AJC can do the same **today, with no new mathematics** — I probed it, EXIT=0, axiom-clean:

```lean
theorem test_nonempty_cover [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIntegral C.hom] : Nonempty C.left.AffineCoverMVSquare := by
  obtain ⟨π, hπ⟩ := Adelic.HasFiniteMapToP1.nonempty_finite_map (C := C)
  obtain ⟨D⟩ := Adelic.P1HasLaurentChartData.nonempty_laurentChartData (k := k)
  haveI := hπ; exact ⟨D.pullbackSquare π⟩
```

Both gates synthesise unconditionally — the same chain `GenusUnconditional.lean:414` already uses. Cover-free versions of *both* headline theorems elaborate clean. So the claim is **undersold, not vacuous**; nothing is conditional on an unsuppliable input. Relatedly, the `:375` docstring citing `Adelic.LaurentChartData.pullbackSquare` as the producer is wrong — that declaration exists but needs a `LaurentChartData` target *and* a finite π; and AJC has no "challenge curve" object at all.

**2. "Input (2) is open in AJCR too" looks overstated (I-0721).** Cited five times to justify not attempting input (2). But AJCR's `windowN` has degree `windowM_choice π hπ g * windowδ π` (`WindowFieldTransport.lean:317`) — **both factors computed at k, no K anywhere** — with `H¹` vanishing at K from a hypothesis mentioning only k, and it is consumed at *varying* residue fields with the constant held fixed (`DivSchemeSeedUnivFields.lean:116-192`). The `Nat.find` is taken **once at k**, the opposite of "re-run at each base field". The real obstruction may be the per-K instance binders (`WindowFieldTransport.lean:286-292`) — but that is a much smaller and differently-shaped obstruction than what five docstrings assert.

**3. Three phantom declaration names (I-0722)** — the error this lane has now made three times: `sectionsBaseChangeFieldₗ_res` (:57), `sectionDiff_baseChangeField` (:58), `h1_unit_baseChangeField_eq` (:33). The third is the dangerous one: `h1_unit_baseChangeField_eq_genus` *does* exist and is a different theorem. Also both `set_option backward.isDefEq.respectTransparency false` are dead — I removed each and both files still elaborate clean, with the methodology validated by a deliberate mutation that did produce the expected error.

On the absence claims: all three hold at declaration level (`AffineTwoCover` absent from AJC, no `quotRange*` besides the new one, no Serre duality/dualizing/canonical-divisor declaration in AJC, AJCR, or mathlib). The agent's own I-0717 self-audit independently reached my methodology finding — that grepping an absence claim in a tree containing the claim measures the assertion.

Relevant paths: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/GenusFieldInvariance.lean`, `.../Ledger/SectionsFieldBaseChange.lean`, `.../scripts/ajcrr-genusfieldinvariance-axioms.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean`, `.../RiemannRoch/WindowFieldTransport.lean`.
