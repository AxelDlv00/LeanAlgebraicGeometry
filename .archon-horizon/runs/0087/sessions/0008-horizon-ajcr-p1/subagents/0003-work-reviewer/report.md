Audit complete. Verdict below.

## Verdict: CONVERGING, with one refuted framing claim and one binder defect

Real theorems, real discharge, verified sorry-free and axiom-clean (`[propext, Classical.choice, Quot.sound]`). No self-projection, no artificial disjunction, no placeholder. But one of your headline route arguments is refuted by your own file, and claim (b) is false on the letter.

Verification discipline: oleans confirmed newer than sources before every probe (04:28 build vs 04:26/04:27 sources); all probes run via `lake env lean` on scratch files in `/tmp`, no `lake build`, no edits. Note that file 1 grew from 392 to 442 lines *during* the audit (uncommitted `picEtAffineEquiv_abelDivAff'` extraction plus a new non-vacuity witness); I re-verified the live disk state compiles, EXIT=0.

## (a) hdegAff DISCHARGED — CONFIRMED

`degAt_abelDivAff'` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffClassDegree.lean:347`) quantifies over an arbitrary `{T : Over (Spec (.of k))}` and an arbitrary `(s : divFamZarAff C n T)` with no `π`, no `IsAffineHom`, and no chart-typed preimage hypothesis. Compare `degAt_abelDivAff'_toAff` (`DivisorFamilyAffAbel.lean:362`), which binds `{π : C.left ⟶ P1 k} [IsAffineHom π]` and `(s : divFamZar C π n T)`. The generalisation is genuine.

## (b) "hdegAff binder removed and nothing else weakened or added" — REFUTED

`chartValueAff_mem_pic0Subgroup'` carries `[GeometricallyReduced C.hom]`; the original does not — it sits under `omit [GeometricallyReduced C.hom] in` at `DivisorFamilyAffAbel.lean:302`. So one instance binder was added, not merely one hypothesis removed.

It is not synthesizable from the other three (`infer_instance` fails against a passing control), and it is not load-bearing: I re-elaborated `degAt_abelDivAff'` verbatim with the binder deleted from the `variable` line and it compiles unchanged. It leaks in from the section `variable` at `:327`, whose own comment justifies only `GeometricallyIrreducible` and `SmoothOfRelativeDimension 1`.

Harm is bounded — I verified both the primed theorem and the raw `fun t => degAt_abelDivAff' s t` discharge apply in the original's exact instance context, so no consumer is blocked. Fix is `omit [GeometricallyReduced C.hom] in` above `:347` and `:380`. Note the freshly extracted `picEtAffineEquiv_abelDivAff'` applies exactly this discipline, and the two theorems above it do not.

## (c) abelSigmaChartAff has the type the seam consumes — CONFIRMED

Two independent checks: the def elaborates at the ascribed type `yoneda.obj D.left ⟶ (pic0SigmaSheaf C).1`, and `pic0RepresentableByOfCharts C (fun _ : ι => abelSigmaChartAff C n rep m Z hdeg) hf` elaborates and returns `(pic0TypeFunctor C).RepresentableBy (Over.mk (...).fst)`. Instance binders match `abelSigmaChart` exactly modulo the `π`/`IsAffineHom π` pair the widened carrier legitimately drops.

## (d) No antecedent discharged — CONFIRMED

`(divFunctorAff C n).RepresentableBy` has zero producers; every occurrence in the tree is a hypothesis binder or a docstring noting the absence. `IsChartUniv` (`Pic0ChartPair.lean:173`) is defined only for the chart-typed `divFunctor` and has no widened form. Surjectivity of `Sigma.desc` is untouched.

## Priority findings

**1. Vacuity — statements are fine; the witness set is the residue.** No `HasDivFunctor`-shaped defect: every new statement names the relative curve, the widened class and the degree. But `Nonempty (DivFamZarAff C K n)` and `Nonempty (divFamZarAff C n T)` both fail `exact?`, and no `Inhabited`/`Nonempty` instance exists for either carrier. The new `exists_divFamZarAff_classDeg_eq` (`:341`) genuinely beats I-1109 — arbitrary `n`, non-empty support, first non-degenerate inhabitation in the tree — but its signature carries `{π : C.left ⟶ P1 k} [IsAffineHom π]` and routes through `DivFamZar.toAff`, so it inhabits only chart-typed classes. The widened stack is verified over exactly the classes the widening was not built for. Your docstring states this correctly.

**2. Item 5 — REFUTED, and it takes the header's central argument with it.** `exists_certifiedAff_divEq` (`:155`) and `DivFamZarAff.exists_toZarAff_eq` (`:265`) are inter-derivable in three lines each via `DivFamZarAff.mk_eq_mk_iff`; both directions elaborate. So neither is stronger, the "deliberately weaker, and that is what makes this cheap" framing at `:149-154` is wrong, and the header's argument at `:46-55` — "the quotient level is never re-entered, so the missing naturality lemma is never called" — buys nothing, because `mk_eq_mk_iff` crosses levels for free.

Worse, `:54` reads "the lemma is avoidable rather than cheap — recorded because the two are different findings", but `CertifiedDivisorFamilyAff.toZarAff_mapAlg` is built at `:248` in one line and consumed at `:309` in the same file. The file takes the cheap branch. And `:265-318` duplicates ~50 lines of `exists_certifiedAff_divEq` verbatim to prove a 3-line corollary, with its own `maxHeartbeats 1600000`.

**3. Item 2 — clean.** No `choose_spec` projection of an assumed binder, no `sorry`, no axiom, no `admit`. Every discharge traces to a real prior theorem.

**4. Item 4 — docstring citations all pass.** Every backticked name in both files resolves under `#check` inside each file's own import closure. The four names claimed absent (`DivFamZarAff.toZarAff_mapAlgHom`, `DivFamZarAff.mapAlg_toZarAff`, `toZarAff_mapAlgHom`, `mapAlg_toZarAff`) are genuinely unknown constants. The "widened twin of `DivFam.toZar_mapAlg`" claim is accurate — I read both proofs and they are the same one-liner (`mk_eq_mk_iff.mpr (divEq_refl _)`). Only the "avoidable rather than cheap" claim fails, per finding 2.

**5. Item 6 — narrower, not stronger.** Only difference from the `hdegAff` binder is the extra `[GeometricallyReduced C.hom]`, per (b). Everything else — `{K}`, `[Field K]`, `[Algebra k K]`, `(t : overSpec k K ⟶ T)`, conclusion — matches binder for binder.

## Filed

- I-1229 (issue, task:ajcr-p1) — the inter-derivability refutation and the self-contradicting "avoidable rather than cheap" sentence.
- I-1230 (issue, task:ajcr-p1) — the non-load-bearing `GeometricallyReduced` binder, with the one-line fix.
- I-1231 (memory, horizon) — probe both directions of a quotient/representative pair before ranking them; `mk_eq_mk_iff` always exists.
- I-1232 (issue, task:ajcr-p1) — the inhabitation residue, and the load it puts on the route given I-1216.

One process note: the shared-index hazard in protection I-1222 lists these files. `Pic0AtlasFromDivRepAff.lean` matches HEAD, but `DivisorFamilyAffClassDegree.lean` has 41 lines of verified, uncommitted work on disk right now.
