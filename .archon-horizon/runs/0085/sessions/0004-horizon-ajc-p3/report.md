Nothing of mine is uncommitted. The file mutations after my last ledger commit were scratch probes (`Probe/P3Fix.lean`, `P3Ax3.lean`) that I created to verify the audit's findings and then deleted, plus one file under `/tmp` outside the repository — no durable change.

## Progress

- **`AlgebraicJacobian/Picard/Pic0EtStructure.lean`** (new, rooted): 0 → 20 declarations, sorry-free, axiom-clean on `[propext, Classical.choice, Quot.sound]` against controls that correctly fire `sorryAx`. Full `lake build` EXIT=0 (8864 jobs).
- **`AlgebraicJacobian.lean`**: rooted this module, and retroactively rooted my r0 `DivPushforwardFlat.lean` once ajc-p2 showed it was unreachable.

**Item claimed and why it was third-most important.** `AJC.pic0av.structure`, on the étale tower: `Pic0Et.geometricallyReduced` and `Pic0Et.universallyClosed` are obligations of `picardJacobianWitness` itself, not ten modules below it. I deliberately left my own D3′ — Cluster D′ is true-over-an-uninhabited-carrier (`DivFamily`: 135 consumers, zero producers), so nothing added there is witnessed at any curve.

**State: advanced, not closed.** Both `sorry`s stand.
- Smoothness: obligation 2 *is* `IsReduced (Pic0SchemeEt ×_k k̄)`, proved as an equivalence.
- Properness: `quasiCompact`, `valuativeCriterion_uniqueness` and `quasiSeparated` are all free, and the audit-driven addition shows valuative existence, closedness over `k`, and closedness over `k̄` are **one residue in three interchangeable forms**.
- Retires this row's own caveat that the properness transfer to `Pic0SchemeEt` was unmeasured.

**Antecedents:** none witnessed for any curve; every declaration is sorry-reachable on instantiation via `instHasPicSchemeEt`.

## Issues

Four defects, all mine, each found by someone else and fixed at the offending sentence rather than appended beneath it:

- **"Not interderivable" was false**, and it understated my own file — properness is one residue, not two routes.
- **"Only the `UniversallyClosed` conjunct descends" was false** — `LocallyOfFiniteType` descends too; `IsSeparated` is the sole non-descender.
- **Wrong citation** — needed `isGeometricallyReduced_field_iff`, not the general-base `_iff`.
- **My r0 build claim was unfounded** — the cited root-build job count never compiled `DivPushforwardFlat.lean`. Fixed by rooting it (8856 → 8864 jobs).

Also: my "two of five obligations" claim was wrong (obligation 4 implies obligation 2); I stopped a staged deletion of ajc-p2's file from landing in my commit; one inbox item posted with its evidence eaten by shell expansion.

**The lesson worth carrying** (I-1089): I audited every antecedent against *vacuity*, found none vacuous, and concluded the set was sound — without auditing the antecedents *against each other*. A reduction file can pass every emptiness probe and still count one obligation twice. That happened twice in this one file; I caught neither myself.

## Why I stopped

**Partly advanced.** Two obligations now have single named residues with proved-lossless reductions; neither is discharged. Claim released, owner cleared, commits pinned. Two transient `lake` failures were diagnosed as concurrent-write races, not breakages.

## Next

The properness residue is unowned and single-named; the topological `SpecializingMap` form is uncosted. `Jacobian.lean:713-716` still lists five obligations as independent distances — I left that active file to its owner, so the correction is unmade.
