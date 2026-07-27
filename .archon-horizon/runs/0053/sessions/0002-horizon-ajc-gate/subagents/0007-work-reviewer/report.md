Audit complete. Here is my verdict.

## Verdict: **converging, not churning** — but the published frontier is wrong in one load-bearing place

This is real progress on the `locallyFree` half of the gate, machine-checked and axiom-clean. It is *not* elaborate restatement. However one of the three advertised "remaining statements" is **false as stated**, which makes the headline assembly theorem vacuous and would burn a future session's round.

### What I independently verified

- All five modules build clean via `lake build AlgebraicJacobian.Picard.<M>`. **Zero warnings attributable to them** — every warning in the output comes from pre-existing files (`QuotFunctorDef.lean:458/690`, `WeilDivisor.lean:1161`, `CodimOneExtension.lean:1691`, `FGAPicRepresentability.lean:259`).
- `#print axioms` on every headline (`p1_hfib_of_fiberH1Vanishing`, `p1CechFibrewiseBridge_proved`, `p1PushforwardLocalFreenessBridge_of_rank`, `p1Cech_h0_fg_of_isIntegral`, `hasRigidPushforward_of_leaves`, `hasRigidPushforward_of_isIntegral_of_rank_of_baseChange`): `[propext, Classical.choice, Quot.sound]`.
- All five files are in ledger HEAD **byte-identical** to the working tree, including the two swept in by `f40296e11`. Write set respected — every commit touches only `Picard/RigidPushforward*.lean`. (Your commit list omitted `e0ea4a6e5`, the one that created `RigidPushforwardGate.lean`; five commits, not four.)

### Answers to your six questions

**1. The two leaf `Prop`s are honest.** Both are true, non-vacuous (`M = O` satisfies each), and the gate assembly really does produce `Scheme.HasRigidPushforward C` — `hasRigidPushforward_of_p1Engine_of_baseChange` builds the genuine class with `locallyFree`/`baseChange` fields at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardGate.lean:283-285`. Notably `P1PushforwardLocalFreenessBridge` (`:167`) *does* carry the `hsurj/hfin/hproj/hbc` hypotheses — it is correctly stated.

**2. Leaf 2 is genuinely closed, and the shape match is real.** `p1_hfib_of_fiberH1Vanishing` (`RigidPushforwardFiberChart.lean:731-753`) has the engine's `_hfib` binder verbatim — compare `RigidPushforwardP1Constants.lean:523-528`. The `isDefEq` timeout your subagent hit was a scratch-file artefact: the *actual* end-to-end application is committed and elaborates, at `RigidPushforwardFrontier.lean:129-131`.

**3. The sharpened anchor is sound.** No step uses a hypothesis it lacks. `UniversallyClosed`/`LocallyOfFiniteType` come from `isProper_p1Over_hom` (`P1Constants.lean:173`) via `IsProper`'s parent projections; flatness inside the base change is free over a field by mathlib's `[Subsingleton Y] [IsIntegral Y] → Flat f`. `Algebra.FiniteType k A` is consumed only downstream at `P1SectionsFinite.lean:1206`, correctly placed. `IsIntegral (ℙ¹_k)` is **true for every field** (covered by two `Spec k[T]` charts with nonempty overlap) and is genuinely open — I confirmed both it and `GeometricallyIntegral` fail to synthesize.

**4. The frontier is *not* stated accurately.** `HasFiniteMapToP1 C` does synthesize for a bare AJC curve, sorry-free — your claim is right and the `P1BaseCase.lean:146` docstring is stale (already tracked as I-0385). But see below.

**5. Build and warnings: clean.** Nothing to report.

**6. The mathematical content genuinely shrank.** You did not just rename the problem. Before this session the `locallyFree` half rested on `P1RigidPushforwardStatement` quantified over all f.g. `A` and all coherent flat `M`; its two open hypotheses and its output gap all moved: `hH0` collapsed from an `A`-indexed family to one statement about one field, `hfib` was **proved outright** (the real technical win: generalising the section-ring pushout off the `f ⁻¹ᵁ V` pin, necessary because `p ⁻¹ᵁ ⊤ = ℙ¹_A` is not affine), and the output leaf reduced to a rank identity with the sheaf packaging done.

### The blocker — filed as **I-0395**

`hrank` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1Sheaf.lean:592-598`, re-exported at `RigidPushforwardFrontier.lean:120-127`) quantifies over **every** finitely presented `M` with no flatness and no fibrewise `h¹`-vanishing. That is exactly cohomology-and-base-change with its hypotheses removed, and it is false:

> `A = k[x]`, `M = O_{ℙ¹_A}/x` (finitely presented, `coker(O --x--> O)`). Then `Γ(ℙ¹_A, M) = A/(x)`, so `sectionsRankAtStalk` at `t = (x)` is `finrank` over the DVR `k[x]_(x)` of the torsion module `k`, i.e. **0**. But the fibre is `ℙ¹_k` with `M_t = O_{ℙ¹_k}`, so `fiberH0 M t = 1`.

So `p1RigidPushforwardStatement_of_isIntegral_of_rank` and `hasRigidPushforward_of_isIntegral_of_rank_of_baseChange` are **vacuously true**. The fix is one line of restatement: `hrank`'s sole use site is `RigidPushforwardP1Sheaf.lean:616`, where `hsurj`, `hfin`, `hproj` and `hbc` are all already in scope — thread them in and the proof body is unchanged, and the statement becomes true (`hbc` at `B = κ(t)` is precisely what identifies the rank with the fibre `h⁰`).

### Two secondary findings

- **A docstring implication that is mathematically false.** `RigidPushforwardP1Constants.lean:75` and `:386-389`, and `RigidPushforwardGate.lean:26-31`, assert `IsIntegral (ℙ¹_k)` is *strictly weaker than* `P1HasTrivialConstants k`. It is not — the two anchors are **logically incomparable** (`Γ(X,O) = k` does not force reducedness; a double line in `ℙ²` has `H⁰ = k`). Prose only, no Lean backing; the `GeometricallyIntegral ⇒ IsIntegral` half at `:442` is correct.
- **Leaf 4 sizing.** `RigidPushforwardBaseChange` is half the gate, got zero work this session, and has no infrastructure. Presenting it as one of three co-equal remaining items understates it; it is plausibly larger than the other two combined.

Both are recorded as a comment on the frontier memory I-0381, along with a durable memory on the leaf-factoring trap (a false leaf compiles, stays axiom-clean, and makes its assembly theorem vacuous — sorry-freeness says nothing about *provability* of the leaves).
