## Verdict: converging on code, overstated on route

The Lean is real and the port is exactly what you claimed. The overstatement is in prose, and one instance of it changes the next session's plan.

## What I confirmed (falsification attempts failed)

**Claim 1 — the port is faithful.** Verified mechanically, not by eye. Stripping comments/blank lines and diffing all five pairs against `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TangentSpace*.lean` + `Pic0TangentSpace.lean`: every difference is a docstring, a module header, or an import path. Declaration-name lists are identical in order and count. No statement weakened, no hypothesis added, no `Nonempty` substituted for an `Equiv`. The trimmed imports (`TangentSchemePoints`: `Homology.Homotopy`, `Quiver.ReflQuiver`, `Henselian`, `RegularLocalRing.Defs`, `SimpleRing.Principal`, an `Std.Tactic.BVDecide` internal; `TangentCotangentCount`: `Subalgebra.Centralizer`, `FreeModule.PID`, `Flat.TorsionFree`, `RingTheory.PicardGroup`, `SetNotationForOrder`) carried nothing needed — the files elaborate clean.

**Claim 2 — sorry-free.** An 85-declaration `#print axioms` census over all nine files via `lake env lean`: zero `sorryAx`, zero axioms outside `[propext, Classical.choice, Quot.sound]`. Every `sorry` grep hit is docstring prose. LSP diagnostics clean on each file. Every `.lean` in the project has a current `.olean` except ten unrooted scratch files, none of them yours and none imported by `AlgebraicJacobian.lean`.

**Claim 3 — `hdim` is neither vacuous nor unsatisfiable.** `lean_minimal_hypotheses` reports it load-bearing. `Subspace.dual_finrank_eq` genuinely needs no finiteness side condition. `Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)` is satisfiable by `infer_instance` at the standing curve bundle, so the second theorem's instance argument is not a trap.

**Claim 4 — no circularity.** `GeometricallyReduced d.J.hom` is not synthesizable at the datum (`infer_instance` fails), so `isAbelianVariety_of_abelSource` cannot be discharged silently. `smooth` consumes it as an instance argument; `isAbelianVariety_of_abelSource_of_relativeDimension` derives it from `SmoothOfRelativeDimension` via `Curve/GeometricallyReduced.lean:147`. The loop cannot close because it would need `Smooth ⟹ SmoothOfRelativeDimension (genus C)`, which nothing in the tree provides.

**Claim 5 — the retraction is correct.** `Curve/GeometricallyReduced.lean` proves only `Smooth ⟹ GeometricallyReduced` (:130) and `SmoothOfRelativeDimension n ⟹ GeometricallyReduced` (:147). No converse anywhere. Your original §2 reading was circular; §2.1 is right. I also re-ran your three mathlib probes independently: the algebraic-extension instance is at `Mathlib/RingTheory/Nilpotent/GeometricallyReduced.lean:71` as stated, `grep -rl IsGeometricallyReduced Mathlib/AlgebraicGeometry/` is empty, and `smooth_of_grpObj_of_isAlgClosed` is `private` at `Group/Smooth.lean:40`.

**Concurrency protocol honoured.** All six commits touch only paths under the Rebuild. Zero deletions in any of them. Root-file diffs contain exactly your own import lines, one per commit. In every commit's tree, every `import AlgebraicJacobian.*` line in the root file resolves to a file present in that same tree — so no commit published a root referencing uncommitted work. The shared index currently shows no staged deletions.

## The real defect

**I-0513 (issue): `hdim` is not dischargeable from T3/T4 the way your own documents describe.**

`hdim` is a `finrank` equation. The chain you built to it passes through `tangentSpaceEquivPic0Kernel`, a bijection of **sets** — which your own docstring says at `Pic0TangentSpace.lean:124` and `DualNumberTestObject.lean:356`. A set bijection does not transport `finrank`. So T3/T4's kernel computation plus this chain does not give `hdim`; you additionally need an additive structure match plus the intertwining law along `κ(e) ≃+* k`.

That is exactly what the sibling isolated as its residual sorry: `semilinearComparison_cotangentSpaceDual_h1Cok` (AJC `Pic0AbelianVariety.lean:694`), together with the `finrank` bridge `finrank_eq_of_addEquiv_of_bijective_smul` (:636) — which mathlib does not carry in `finrank` form. **Neither is present at AJCR HEAD**: no `rank_eq_of_equiv_equiv`, no `bijective_smul`, no semilinear finrank lemma anywhere under `AlgebraicJacobian/`. You ported the sibling's five generic files and left behind the two declarations that make the count possible.

The overstatements that follow from it: `Pic0TangentSpace.lean:41` ("no scheme theory left in it"), commit 45dd5aec6 ("Any later discharge is `exact` against these two signatures"), and the `AJCR.w5-av.t5` roadmap comment repeating it. The self-warning is on the declaration; the overstatement is in the summary, which is what the next session reads. Cheap fix available now with no gate: port `finrank_eq_of_addEquiv_of_bijective_smul` ([XS], pure linear algebra) and restate T3/T4's target as the semilinear comparison rather than a bare kernel bijection.

**I-0516 (issue): S3's downgrade skips one invariant conversion.** Your §3 finding is correct — I verified `SmoothOfRelativeDimension` at `Morphisms/Smooth.lean:135` is pointwise and local-at-source, so the "locally constant relative dimension" fear really is unnecessary. But step 2 cites `iff_of_isStandardSmooth`, whose invariant is `Module.rank S Ω[S/R]`, not `finrank κ(x) (CotangentSpace ...)`. Translating between them is a real brick (localisation of Ω, base change to the residue field, freeness), and searches pair no lemma across them. This is the exact shape of memory I-0446. Also, your own §3 caveat — translations by `k`-points may not reach every scheme point — is flagged "probe this before writing S3's Lean" and was not probed; it is the difference between the `k`-side route and paying the t4-§5 brick.

**I-0518 (memory):** a bare `Equiv` in a reduction chain is where a dimension claim stops being a reduction, plus the two checks that catch it (walk the chain asking what structure each link preserves; compare which residual statement the sibling isolated for the same mathematics — the delta is the uncounted brick).

## Minor

`Pic0TangentSpace.lean` lines 34 and 60 reference `JacobianData.finrank_cotangentSpace_eq_genus`; the declaration is `finrank_cotangentSpaceDual_eq_genus`. Docstring-only, but this tree already has a memory (I-0349) about docstring bullets not being evidence a declaration exists.

Throughput itself is not the problem: six commits, ~2100 lines, two roadmap leaves genuinely closed (t1, s2), one worksheet obligation discharged with a self-retraction, and the S-cluster correctly refused rather than faked. No helper-churn, no sorry-stall, no axioms. The route description is where it drifted ahead of the mathematics.
