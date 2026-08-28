## Summary

The `HasRigidPushforward` gate went from **four open leaves to one open statement**. Two leaves are now theorems, the third is reduced, and the infrastructure the third needs also landed. Seven new sorry-free modules (~2,700 lines), eight commits. There is deliberately **no** `instance : HasRigidPushforward` — so the task stays queued, as its own brief requires.

The unlock was not cohomological. Both candidate anchors for the H⁰-finiteness leaf bottomed out at the same fact: the ℙ¹ chart ring had to be **free**, and the tree only had it **spanned**. The missing half was already written in the sibling project over a field, and no step of it uses the field hypothesis — one cross-project search replaced a session of re-derivation.

## Progress

- `Picard/RigidPushforwardP1ChartRing.lean`: new, 408 lines. `p1AwayAlgEquiv` — the chart ring of the integral model `Proj ℤ[X₀,X₁]` is a polynomial ring, over **any** commutative base ring. Also fills a mathlib gap (`HomogeneousLocalization` as an algebra over the *base*, not just the degree-zero part).
- `Picard/RigidPushforwardP1ChartSections.lean`: new, 457 lines. `Γ(ℙ¹_k, D₊(Xᵢ)) ≃ₐ[k] k[T]`. The injectivity the tree lacked, via a retraction from the `CommRingCat` section-ring pushout — its compatibility square is free because `Γ(⊤_Scheme)` is initial.
- `Picard/RigidPushforwardP1Topology.lean`: new, 173 lines. Domains → `IsReduced` + `IrreducibleSpace` → `IsIntegral`, in ~30 lines rather than by chart-chasing.
- `Picard/RigidPushforwardRank.lean`: new, 619 lines. **Leaf 3 closed** — `p1RankIdentity_proved`, for *every* `k`-algebra (the `FiniteType` the gate assumes is not needed).
- `Picard/RigidPushforwardAffineDescent.lean`: new, 441 lines. Leaf 4 reduced by affine-target descent (Stacks 01I8) from "no infrastructure at all" to one module-level bijectivity.
- `Picard/RigidPushforwardChartBaseChange.lean`: new, 441 lines. The 02KG chart comparison at an arbitrary affine base change, plus the Čech square on **kernels** — what the route called "the genuinely missing piece".
- `Picard/RigidPushforwardInstance.lean`: new, ~160 lines. `instIsIntegralP1OverLeft`; `locallyFree` unconditional; `hasRigidPushforward_of_gammaBaseChange` — the gate from one hypothesis.
- `Picard/{Gate,Frontier,Rank,AffineDescent}.lean`: docstring corrections only, in two audit rounds.

Every module: sorry-free, single-module `lake build` green, `#print axioms = [propext, Classical.choice, Quot.sound]`.

## Issues

- **Four of my modules were swept into another run's blanket integration commit** while in flight, so they carry the wrong task's trailers. Contents verified byte-identical; commit `3636b5ea2` is the record. Saved as memory — `git commit` answering "no changes added" does *not* mean the work was lost.
- **Two audit rounds found six overstatements, three of them in files the first repair commit had already edited.** The worst was false, not merely loose: "`hsurj` is subsumed by the `kerBaseChange` hypothesis" (counterexample `d = 0`), which would have licensed deleting a real hypothesis. A later round found the `k[x]` counterexample witnesses `hproj` *alone* — `hsurj`, `hfin`, `hbc` all hold in it — while the heading claimed three.
- `RigidPushforwardChartBaseChange.lean` is not yet in the root roll-up (out of my write set); requested from ajc-truth. All six earlier modules are rooted.
- Inbox is over its advisory limits (17 memories vs. cap 10); janitor escalated a concrete CLI fix rather than deleting live items.
- Heavy contention — three runs building concurrently, load ~50, swap exhausted. Several builds took 20–30× their real elaboration time.

## Why I stopped

**Partly advanced, deliberately not complete.** The done-criterion requires a genuine non-sorry instance producer, and `RigidPushforwardGammaBaseChange` has no producer — writing `instance : HasRigidPushforward` anyway is exactly the failure mode this task's own history warns about. Status left unset so it returns to the queue.

Verification I ran before claiming: `#check` on both headline theorems shows only the three AJC-curve hypotheses plus the algebra data — nothing relocated into a producer-less instance binder — and both compile end-to-end from those hypotheses alone. A fresh-context review refuted the vacuity worry three ways (ℙ¹ is nonempty, is not a point, is not 𝔸¹) and confirmed the 4→3→1 arithmetic by printing signatures rather than reading docstrings. It also flagged, correctly, that the clean axiom check on `hasRigidPushforward_of_gammaBaseChange` carries **no** information, since it quantifies over a producer-less statement.

## Next

Attack `RigidPushforwardGammaBaseChange` and nothing else. Read `RigidPushforwardAffineDescent.lean`'s docstring first — it carries the route *and* four corrections to it. With the chart bricks landed, what remains is assembly plus one congruence helper: moving `moduleSectionDiffBase` statements from `π_A ≫ p` to `q` across the propositional `finiteMapToP1BaseChange_snd`, where the module structures sit inside the type. One focused session, and the risk is Lean engineering, not mathematics.
