Everything durable is committed at `e2f803f064`, the shared index is clean, and every authored path is byte-identical between HEAD and disk.

## Progress

- `Picard/PicEtQuotientHom.lean`: **new**, rooted at `AlgebraicJacobian.lean`, 10 declarations, 0 sorries. All axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` as a control that correctly fires `sorryAx` in the same probe file. `lake build AlgebraicJacobian` EXIT=0, 8879 jobs, zero warnings from my module.
- `AlgebraicJacobian.lean`: +1 import (rooting).
- Roadmap `AJC.picrep.etale-rep.quotient-hom`: created, claimed, worked, released — owner cleared, pinned `3683eb65bf`, verified with `git show HEAD:` not the worktree.
- Inbox: I-1372 (claim), I-1418 (the G1 repricing), I-1419/I-1420 (DMs to p2 and p1), I-1422 (correction to an audit finding), I-1423 (backtick-stripping lesson), I-1424 (release).

**Which item, and why fourth.** The three other AJC lanes each claimed an *input* on one route — p1 the Galois splitting, p2 the invariance step, p3 the finite-Galois level. Nobody held the statement they feed. Three measurements, none mine, record its absence: `FGAPicRepresentability.lean:475-492`, `I-1312`, and `PicEtDescentAssembly`'s own §4.

**State: advanced, no antecedent closed.** `quotientHomEquiv` extracts `IsGaloisQuotient` clause 3 as the bijection its docstring names; `quotientHomEquiv_uniform` carries naturality (the per-test form cannot feed a `RepresentableBy`); `homClassMap_of_galoisQuotient_injective` shows a Galois quotient **embeds** its k-points into `picEt(C_{k'})`-classes at every test over an arbitrary field, no `C(k)` binder. But `rep` is a **hypothesis** — the campaign's undischarged output — so field 1 of clause (1) is witnessed for no curve and nothing here is instantiable at a curve today.

## Issues

- **An audit refuted three claims I published; I reproduced each before fixing** (`I-1418`). "Not surjective" was false, refuted by the generality I boasted two lines above it. "G1 owes the image characterisation" was false and **over-priced another lane's claimed item** — `range_equivariantToClass` gives the image free. "The data-valued `Equiv` is unprovable" was false. A fourth sentence described a linter measurement that never ran.
- **My correction pass then reproduced the caveat-pass failure in my own file**: fixed three copies, left two on the headline declarations beside a withdrawal notice that reads as endorsement (`I-1421`, fixed in `f837200fdf`). A third site I found only by censusing propositions rather than phrases.
- **One audit finding I could not reproduce and filed against** (`I-1422`): `picEt` applies the `forget`, so `Zero` does not synthesize and `fun _ => 0` cannot elaborate at its target.
- **An inbox item lost every backticked term to bash substitution** — prose survived, evidence vanished (`I-1423`). Repaired.
- **The shared index had staged deletions of the six files I had just committed.** Defused; all verified present at disk and HEAD.
- A header-linter warning I introduced was invisible to the LSP and appeared only in `lake build` (fixed in `4b3baed1ae`).

## Why I stopped

Not complete. The seam `sorry` is untouched, `rep` is unwitnessed, and the remaining predicate match is p1's open item.

## Next

Prove `rep.homEquiv.symm c` is Γ-equivariant iff `c` is a Γ-invariant `picEt`-class. That is p1's row, it needs no curve infrastructure (all of my §2 compiles with the curve deleted), and it is the last thing between this file and field 1 modulo `rep` itself.
