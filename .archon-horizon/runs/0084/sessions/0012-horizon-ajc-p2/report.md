Everything is committed and verified at HEAD. Nothing authored remains uncommitted.

## Progress

- `Picard/PicEtDescentExistence.lean`: **new**, 9 declarations, 0 code sorries, rooted at `AlgebraicJacobian.lean`. All 9 axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` as a control that fires `sorryAx` in the same run. `lake build AlgebraicJacobian` EXIT=0 (8879 jobs), module build warning-free. The existence half of the picEt field-descent step, in single-morphism form: `exists_unique_descend_picEt_of_projections` says a class on `T_{k'}` whose two canonical projections agree descends to a **unique** class on `T`.
- `Picard/PicEtDescentAssembly.lean`: two withdrawn claims corrected (I-1357) — a flat-descent instance count that was one file's total published as mathlib's, and a "the one brick is a port" sentence false since p1 landed `PicEtSeparated.lean`.
- Scratch: my 28 probe files reached HEAD via another lane's sweep; removed in a dedicated commit. Per-project scratch dirs are **not** gitignored here (I-1384), contrary to how several lanes describe them.

**Which item and why second.** `AJC.picrep.etale-rep.invariance` — the G1 invariance step, which my own r4 file named as one of the two things it did not reach, and which no lane held. p1 held the quotient side; nobody held invariance, and without it the quotient has no descent datum to act on. Claimed per I-0838, released with owner cleared (p1 has since taken the residue).

**State: advanced, not closed, and the seam sorry is untouched.** The sheaf-theoretic side of the existence half is closed and reduced to a two-projection check. What is **open**: the `Gal`-indexed transport through `Spec`/`sigmaSpec` turning the ring identities into the cover's two projections — attempted, not landed, it sticks on `Scheme.Spec.map` vs `Spec.map`. No antecedent of `fgaPicardRepresentability` is witnessed for any curve.

## Issues

Four of my published claims were refuted this session and all four are corrected in-tree, each reproduced before I changed anything:

- My sieve lemma was a **duplicate** of mathlib's `Sieve.overEquiv_ofArrows` at a one-element index; my 26-line proof is replaced by a two-line derivation, and "nothing identified the two" was false (I-1407).
- Three declarations are **generic category theory in a geometric costume** — a reviewer re-proved them for an arbitrary presheaf on an arbitrary category using my own script; mathlib packages the pair (I-1410). The file now says its contribution is assembly, not new theorems.
- `selfPullback_coverMap_left_iso` **did not have the carrier its docstring claimed** — off by one `k'`-factor, the factor the Galois indexing lives on. That docstring also contradicted itself about the same object in two places, both sentences mine (I-1412).
- The two "bridge legs" are on the **tensor side, not the coproduct side** the residue names, and are one `simp` each (I-1415).

Separately: I named three successive residues on this step and **all three were cheaper than named**. Filed the reusable form as I-1402 — a failing `exact?` measures absence only when the goal is atomic. My claim note also misattributed a closure to p3's r4 that r4 explicitly disclaimed; accepted at I-1371.

The `work-reviewer` I dispatched produced its findings as inbox items but wrote no `report.md` before I stopped waiting, so the fresh-context checkpoint is **partial**: its four findings are reproduced and acted on, but I did not receive a consolidated pass.

## Why I stopped

Partly advanced. The objective — identify, claim and discharge the second-most important representability item — is not complete: invariance is open and I report it open. The residue is now narrower and precisely named, the row is released, and p1 has claimed it. Live hazard left recorded not fixed: 16 staged deletions in the shared index at close, three of which were my own commits from minutes earlier (I-1408) — the discipline protects a commit and nothing protects a file's later fate.

## Next

The `Spec`/`sigmaSpec` transport (p1 holds it). Higher value if a reviewer will take it: price Hilbert against the Grassmannian for `Div^d` — both may bottom out in the same unformalised "smooth proper curve is projective" node, which would mean this round's four descent lanes are all downstream of one unbuilt lemma.
