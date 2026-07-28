Build green, tree clean, all work committed. Writing the final report.

## Summary

The Albanese leg's one remaining gap was mis-sized, and I have the machine-checked correction. `SymPowData C n` for n ≥ 2 — priced at 2400–3800 lines as a scheme quotient by a finite group action, and declined by two prior sessions as a subproject — **is a colimit of the S_n-action on C^n**. Both directions are proved, so the reduction is lossless rather than a relocation.

A fresh-context review then caught the capstone I built on it being **vacuous**, which is the more important half of this report and is fixed.

## Progress

- `Albanese/SymPowColimit.lean` (new, 24 decls, 0 sorries, axiom-clean): `symPowOfColimit` — a colimit of `permDiagram C n` *is* a `SymPowData`, with the symmetry hypothesis `hproj` free as `colimit.w` at every n (it previously had only an n=1 witness). `SymPowData.isColimit` + `hasColimit_permDiagram_iff` give the converse, so nobody can supply the interface without the colimit. `symPowData_affineAlgebra` inhabits the pair at every n in `(Under k)ᵒᵖ` with nothing constructed. `permAut_swap_ne_id_of_points` / `permAut_eq_id_of_isTerminal` bound non-vacuity from both sides.
- `Albanese/AlbaneseFromColimit.lean` (new, 0 sorries, axiom-clean): Milne III.6.1 with **no `SymPowData` and no `hproj` argument** — one typeclass hypothesis in their place.
- `Albanese/{SymPowInterface,AlbaneseUP,GrpObjFoldSum}.lean`: docstring corrections. Three sites asserted the trivial datum fails `hproj` "for n ≥ 2" unqualified — false at a terminal object; and the 2400–3800 figure is now marked historical everywhere it appears.
- Roadmap `AJC.albanese.symmetric`: **blocked → active**, summary rewritten and verified on disk.

Fronts (a) codim-one and RigidityLemma were already at 0 sorries at session start — confirmed, not re-derived. AlbaneseUP's six pinned sorries are unchanged and remain deliberately unprovable against a `sorry`-bodied `SymmetricPower`.

## Issues

**I shipped a vacuous theorem and a reviewer found it, not me.** The capstone bound `HasColimitsOfShape (SingleObj (Perm (Fin g))) Scheme` — all such diagrams over all schemes — while my equivalence is about `HasColimit (permDiagram C n)`: one diagram, one curve. Strictly stronger, only `⟹` proved, and my own file argues that instance is false at this pin, so the theorem was vacuously true and its "single open obligation" undischargeable in principle. Fixed to the per-diagram binder, proof term unchanged. This is exactly the failure the converse-check was meant to prevent, one level above where I checked: **an equivalence protects only the binder it names.** Retracted on the team thread.

Second review finding: my non-vacuity witness lived in `Type` at `Bool`, so nothing exhibited `permAut ≠ 𝟙` for any *scheme*. Closed with a category-general lemma that covers the curve.

Third, from the hygiene pass: I had corrected each claim where I was *working*, not everywhere it was *asserted* — three contradictions survived in files I hadn't touched.

Two tooling defects filed: **I-0575** — `lean_minimal_hypotheses` reported all 16 binders of the capstone "removable" with empty `breaks`, a false all-clear (refuted by hand; a predecessor report cited that tool as verification). **I-0568/I-0572** — the stale shared index re-armed twice in my session (22 then 13 phantom staged deletions, all files present on disk); disarmed both times, and per-commit pathspec is the only guard.

Two background subagents died mid-flight with no report; I re-ran both synchronously and got full results.

## Why I stopped

**Partly advanced, not complete.** The leg's residue is now one *satisfiable* instance — `HasColimit (permDiagram C g)` — instead of a subproject, and it is a statement about `Scheme` with no base and no curve in it (`Over.forget` creates colimits). But the curve case is not proved, and I did not fake it. Task left non-terminal.

Verification: full `lake build` green, 8773 jobs, exit 0. My two new files 0 sorries, all declarations `[propext, Classical.choice, Quot.sound]`, measured against a control (`Pic0.albanese_universal_property` still reports `sorryAx`). Working tree clean.

## Next

Assemble a `Scheme.GlueData` from the affine quotients. Availability measured at this pin so nobody repeats the search: `HasCoproducts Scheme` **yes**, `HasCoequalizers`/`HasPushouts Scheme` **no**, `Scheme.GlueData` **yes**. So the remaining work is Milne III.3.1's overlap compatibility — bounded, with inputs that exist — not a missing mathlib theory. Also unproved and worth a short pass: that `(Under k)ᵒᵖ` *is* affine k-schemes (`Over.opEquivOpUnder` + `AffineScheme.equivCommRingCat`), and that the affine carrier is `Spec` of the invariants. Both are currently labelled expectations.
