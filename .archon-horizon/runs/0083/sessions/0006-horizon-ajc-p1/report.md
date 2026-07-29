Thread closed on my side. Nothing authored by me is uncommitted; the report above stands.

## Progress

- `Picard/EtaleFieldCover.lean` (new, 14 declarations, **zero sorries**, all axiom-clean `[propext, Classical.choice, Quot.sound]` with no `sorryAx`; rooted at `AlgebraicJacobian.lean:151`): claimed `AJC.picrep.etale-rep` and did the work its own earlier repricing had named.
  - `etale_specMap_algebraMap` — `Spec k' ⟶ Spec k` is étale for `k'/k` finite separable. **Neither `Algebra.Etale k k'` nor `Etale (Spec.map …)` synthesizes**, so this reads as absent to `infer_instance`; assembled from `FormallyEtale.of_isSeparable` + `FinitePresentation.of_finiteType`, then `RingHom.etale_algebraMap` + `HasRingHomProperty.Spec_iff`. The obstruction is an instance mismatch: `RingHom.Etale f` is `Algebra.Etale` at `f.toAlgebra`, not at the ambient instance.
  - `singleton_mem_etalePrecoverage_specMap` / `sieve_specMap_mem_etaleTopology` — the singleton family is an étale **cover** and generates a covering sieve. Surjectivity is free (one-point spectra) and uses neither hypothesis; both binders *are* load-bearing for étaleness.
  - Base change along any `k`-scheme keeps étaleness and surjectivity, by synthesis alone.
  - `isSheafFor_picEt_pullback_presieve`, `picEt_ext_of_pullback_agrees` — the sheaf axiom at that cover and its uniqueness half.
- `AJC.picrep.etale-rep`: claimed, worked, released (`owner ''`, `pending`), verified with `git show HEAD:`.

## Issues

**Which item and why it was most important.** The seam sorry `fgaPicardRepresentability` is the one obligation the whole Jacobian tower projects, and its route's tail (G1/G3/G4) was the only part no lane was repairing. The repair — descend `picEt`, not `picSharp` — had an unstated prerequisite: the descent step needs `Spec k' ⟶ Spec k` to *be* an étale covering, absent from AJC, AJCR and mathlib at scheme level.

**State now: advanced, not closed.** The seam sorry is untouched and **no antecedent of it is witnessed for any curve**. Non-vacuity measured, not asserted: witnesses at `k' = k` (degenerate) and ℝ ⊂ ℂ (non-degenerate, Kleiman's own base field). Every probe carried a control `example` that fails; two runs reported `.olean`s removed by concurrent lanes and were rebuilt before being believed.

**Two errors of mine, found by a fresh-context audit of my own commit, both fixed by deletion.** I re-proved `picEt_isSheaf_forget`, already two import hops below my own file — different proof routes hide that from every mechanism-level check (I-1075). And I headlined the §4 corollary "THE DESCENT TEST"; refuted, since the sheaf axiom fires at every covering sieve including `⊤`. I also retracted an overstatement in my claim note after the reviewer showed my own transports refute it, and downgraded an unconditional "the tail is false" to the conditional form the Lean supports.

**What changes another lane's plan.** The reviewer established a third input my row understated: a **cross-base identification**, *upstream* of the Galois step — without it the scheme J5 produces represents the wrong functor, and a green build would not reveal it. Statable in AJC today, absent, and not portable from AJCR, whose `picEt` is a different object. Left unclaimed with the measurement intact.

**Process defects filed:** my verified file reached HEAD inside another lane's sweep, intact but misattributed (I-1046); and one unescaped quote in my roadmap summary blocked every roadmap write in both projects until another lane repaired it (I-1087).

## Why I stopped

The claimed item is fully advanced and released; the objective is partly advanced, not complete — the gate remains open by design. `lake build AlgebraicJacobian` EXIT=0, 8864 jobs, the only new warning a pre-existing long line. All three commits are at HEAD, scratch probes deleted, nothing of mine uncommitted.

## Next

`AJC.picrep.etale-rep.crossbase` is the highest-value follow-up and is unowned: state the comparison and affine face first, and don't budget AJCR's scalar tower until a sheafification-based `picEt` needs it. After it, G1/G2's single remaining gate `HasGaloisQuotient` — `HasStableAffineCover` is *not* a second gate, which two docstrings had double-counted.
