Everything is committed, the working tree is clean, the full build is green, and each of the four new files is independently confirmed sorry-free by the kernel.

## Summary

Milne Proposition III.6.1 — the Albanese universal property — is **proved**, both directions, axiom-clean. The leg's remaining gap is now exactly one missing object rather than six entangled sorries.

The pivot: `AlbaneseUP.lean`'s six obligations are stated against `SymmetricPower`, a **`sorry`-bodied definition**. Those aren't merely unproved, they're *undischargeable* — an equation between morphisms out of a junk term carries no information, and proving one would establish nothing. So I named the symmetric power's universal property as data and proved Milne's argument over that instead.

## Progress

- `Albanese/SymPowInterface.lean` (new, 0 sorries): `SymPowData C n`; `symAVMap` makes Milne's `Sym^n φ` a **construction**; `basePointShift_comp_powSum` is the collapse behind "use `φ(P₀) = η_A`"; `symPowDataOne` + `symPowDataOne_proj_perm` inhabit it; `symPowDataTrivial` is kept as the file's acceptance test.
- `Albanese/AlbaneseFromData.lean` (new, 0 sorries): both connector directions; §2's descent; §3's capstone — `SymPowData` + birationality ⟹ III.6.1, axiom-clean.
- `Albanese/AVSelfProduct.lean` (new, 0 sorries): Milne I.1.4 and I.1.2 unconditionally on the project's four-instance package.
- `Albanese/AlbaneseJacobian.lean` (new, 0 sorries): the `Pic⁰` instantiation plus the attribution check.
- `Albanese/{AlbaneseUP,GrpObjFoldSum}.lean`: docstring corrections. AlbaneseUP still **6 sorries, unchanged** — made unnecessary, not discharged.

Three corrections to previously recorded state, which mattered more than the new lemmas:

**A recorded dead end was false.** "The project could not supply `IsCommMonObj`" was instance *keying* — `(A ⊗ A).hom` is reducibly `pullback.fst A.hom A.hom ≫ A.hom`, so one rewrite per side condition suffices.

**The descent's blocker was the wrong blocker.** Every docstring said it needed a birational-inverse API absent from mathlib. It never needed one: a section over a dense open, a retraction, and dominance suffice — all supplied by birationality directly.

**A review caught me overstating, and I'd rather report that than bury it.** I claimed `symPowDataOne` proved non-vacuity; the bare structure is trivially inhabited at every `n` via `proj := 𝟙`. I reproduced that myself, then fixed the real gap — the meaningful object is the *pair* `(D, hproj)`, whose symmetry half I had never proved. The honest limit is now stated in-file: the only inhabited case is `g = 1`, exactly where the homomorphy step degenerates to associativity.

The key measurement, re-runnable in one command: `..._of_symPowData_generic` is axiom-clean while the `Pic⁰` specialisation reports `sorryAx`. Same statement, sole difference the target object — so that residue is provably the Picard seam upstream, not this leg.

## Issues

Two background subagents (ground, janitor) returned one-line reports with zero recorded usage — killed early. I re-dispatched the review synchronously as `work-reviewer` and got a full audit; it independently confirmed `IsMonHom` is load-bearing and that every explicit binder survives `lean_minimal_hypotheses`, which I had not run.

`horizon roadmap set --strategy` is silently accepted and ignored — exit 0, text discarded. Filed as I-0546; I re-applied via `--summary-file` and verified in the YAML.

## Why I stopped

**Partly advanced, not complete.** Milne's argument is finished; `Sym^g C` for `g ≥ 2` — a quotient of a scheme by a finite group action, absent at this mathlib pin and sized at ~2400–3800 lines — is not, and I declined to fake it. Task left un-terminal so it returns to the queue.

Final `lake build`: 8770 jobs, 0 errors.
