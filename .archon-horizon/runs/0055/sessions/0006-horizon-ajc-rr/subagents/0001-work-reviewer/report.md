Verdict: **converging, and the central claim survives adversarial checking.** The discharge is real. One factual claim about *why* the hypotheses are cheap is false, repeated in five places.

## The four claims, checked

**1. Vacuity / satisfiability — claim holds, with one correction.** The binder set is jointly satisfiable and non-vacuous. `Order.coheight P.point = 1` together with `coheight ≤ 1` on the curve is consistent, and I proved `P.point ≠ genericPoint C.left` from the set, so it does not collapse the scheme. `IsIntegral` and `IsLocallyNoetherian` synthesize on `Spec k[X]`.

The correction is the one claim I could break: **`LocallyOfFiniteType` does not synthesize from `SmoothOfRelativeDimension 1`.**

```
example {X Y : Scheme} (f : X ⟶ Y) [SmoothOfRelativeDimension 1 f] :
    LocallyOfFiniteType f := inferInstance     -- synthInstanceFailed
```

It needs an explicit `haveI := SmoothOfRelativeDimension.smooth 1 f`. What actually supplies it is `IsProper`, which at `Mathlib/AlgebraicGeometry/Morphisms/Proper.lean:42` is `class IsProper : Prop extends IsSeparated f, UniversallyClosed f, LocallyOfFiniteType f`. The session's own probe (transcript 12:28:22) passed because it listed `[IsProper C.hom]`; its inline comment asserted smoothness was doing the work. That attribution then propagated into three commit messages, `SectionBounds.lean` §4 item 1, a roadmap comment, and a DM to `ajc-truth`. Not fatal — `WeilDivisor.lean:1161` `principal_degree_zero` carries `[IsProper C.hom]`, and I verified `degK_eq_degree_of_isAlgClosed_curve` elaborates at its exact hypothesis set with nothing supplied by the caller. But properness is a real hypothesis: an affine curve is smooth of relative dimension 1 and the theorem does not reach it.

The `Module.Finite k (localStepTgt k P 1)` gate is no longer a gate. It was one at the two commits in scope; I derived it from `hasRationalResidues_of_isAlgClosed_curve` alone (approximation spans the quotient with one vector), and the session then found the same derivation independently and landed it as `finite_localStepTgt_one_of_hasRationalResidues` in 37f95374c, removing the binder from the whole API. `residueDeg_eq_one_of_isAlgClosed_curve` now carries no finiteness binder.

**2. `HasRationalResidues` is not true for the wrong reason.** No mirror-image defect. The definition uses `f - algebraMap k K c ∈ orderGe P 1`, and `orderGe` carries its `f = 0` disjunct explicitly, so it admits zero by design rather than by accident. I confirmed `orderGe P 1` is a proper subgroup (`1 ∉ orderGe P 1`), so the statement has content. The `f = 0` branch at `ResidueField.lean:273-276` picks `c = 0` and closes with `(orderGe P 1).zero_mem` — the mathematically correct witness, not a dodge. `residueDeg_eq_one_iff_hasRationalResidues` is a genuine two-way equivalence, so the predicate cannot be vacuously true.

**3. The diamond — conclusion correct, stated mechanism wrong.** This is the defect you were most worried about, and the file is clean on the thing that matters. Every `Algebra k K(C)` in all five headline declarations resolves to `Scheme.functionFieldAlgebra` — 260 occurrences under `pp.explicit`, zero `overStalkAlgebra`. Same k-action as the rest of the lane. The diamond is real (`rfl` fails between `overStalkAlgebra C (genericPoint C.left)` and `Scheme.functionFieldAlgebra C`).

But `ResidueField.lean:69-79` names the wrong protection. `overStalkAlgebra` is a scoped instance declared inside `namespace AlgebraicGeometry` (`TangentSpaceStalkAlgebra.lean:138`), and `ResidueField.lean` is itself inside that namespace (line 89) — so it is live, and I confirmed `Algebra k (C.left.presheaf.stalk x)` synthesizes to it in exactly the file's ambient context. The `letI` at lines 144/146 is redundant, not protective. The real reason nothing goes wrong is that `overStalkAlgebra`'s head does not unify with `Algebra k K(C)` without unfolding `functionField` to a generic-point stalk, which instance search will not do. A future file relying on the stated mechanism would be protected by luck.

**4. Docstrings.** Honest apart from the `LocallyOfFiniteType` sentence. §7's SUPERSEDED marking is fair: the theorem is kept, its "reformulation, not discharge" verdict is preserved for itself, and `mem_orderGe_one_iff_mem_maximalIdeal` genuinely is reused. §5's "not claimed in this section" edit is careful — it records that the ring-structure identification is still absent and still not needed, which is accurate. `SectionBounds.lean` §4's two-items-to-one is correct. And confirmed: the `sorry` at `WeilDivisor.lean:1194` is untouched, with the reason stated (substituting would make a hypothesis-free theorem depend silently on the unproved ledger) — that restraint is the opposite of the failure mode you asked about.

Build: `lake build` 8582 jobs clean, only the pre-existing WeilDivisor sorry warning. All eight declarations `#print axioms = [propext, Classical.choice, Quot.sound]` — which per I-0412 I treated as no evidence, hence the elaboration probes above.

## Why this is not the retracted claim again

The predecessor's retraction was of a theorem whose binders existed nowhere. Here the binders resolve at a real consumer's hypothesis set with nothing left to the caller, and the substantive binder was eliminated rather than assumed. The route is sound: `residueFieldIsoBase` gets integrality from `LocallyOfFiniteType` via `isFinite_iff_locallyOfFiniteType_of_jacobsonSpace` (`Mathlib/AlgebraicGeometry/AlgClosed/Basic.lean:33-43`), exactly as described, so no `Module.Finite k κ_P` is consumed.

Filed three inbox items to `task:ajc-rr` / `horizon`: the `LocallyOfFiniteType` misattribution with the five locations to fix, the diamond-mechanism correction, and a memory recording the general lesson — an instantiability probe over a hypothesis bundle proves sufficiency, not which member did the work, so delete hypotheses one at a time before claiming one is free.

Relevant files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/ResidueField.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/SectionBounds.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/GlobalGeneration.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TangentSpaceStalkAlgebra.lean`.
