The post-commit mutations were the four scratch probe files, all deleted — no durable change, nothing of mine pending in the ledger.

The file-mutating tools I used after commit `517c5f3d94` were:
- **`rm` of four scratch probes** (`ScratchP1/PicGProbe.lean`, `PicGProbe2.lean`, `PicGAxioms.lean`, `PicGAx2.lean`) — never committed at any point, now gone. `git status` on `ScratchP1/` is empty. This matters because of the standing `scratch-dirs-not-gitignored` lesson: leaving them would have let another lane's sweep commit sorried controls.
- **Two writes under `/home/axel/.claude-api/.../memory/`** plus the `MEMORY.md` index lines — that path is outside `$HORIZON_LEDGER_WORK_TREE`, so it is not ledger content and cannot be committed there.

All four authored ledger paths hash-match HEAD, and all five commits are ancestors of HEAD. The `D ` lines in the earlier status are index-column entries — the I-1222 staged-deletion hazard I measured and recorded (599 staged D, 32 `.lean`, all present at both HEAD and disk, at-risk 0), not unstaged work of mine.

## Progress

- **AlgebraicJacobian/Picard/DivisorFamilyDegreeZeroGeneral.lean** (new, 0 sorries): `isUnit_eqn_of_isCertified_zero` — a degree-0 colength certificate forces **every chart equation to be a unit**; then `divEq_trivEqns_of_isCertified_zero` and `instSubsingletonDivFamZeroGeneral` (`Subsingleton (DivFam C R π 0)` at every test ring).
- **AlgebraicJacobian/Picard/DivisorFamilyDegreeZeroRep.lean** (new, 0 sorries): the descent through `IsLocallyCertified`, `instSubsingletonDivFamZarZeroGeneral`, subsingleton at every *test object*, and **`divFunctorZeroRepresentableBy`** — the first inhabitant of the `rep` slot at any parameter.
- **AlgebraicJacobian/Picard/DivisorFamilyDegreeZeroUseSite.lean** (new, 0 sorries): `divFunctorObjSubsingleton_zero` makes pic-c's antecedent unconditional; `abelSigmaChartZero` is an Abel chart with **no `rep` binder**.
- **AlgebraicJacobian.lean**: three imports; full `lake build` EXIT=0 (9342 jobs), zero messages naming my files. All declarations axiom-clean `[propext, Classical.choice, Quot.sound]`, with `AlgebraicGeometry.Jacobian` firing `sorryAx` in the same probe as control.
- **Board/inbox**: `divrep.deg-zero` claimed (I-1508) then released (I-1532), owner cleared, status pending; I-1517 files a new git mechanism; I-1525/6/7 fixed and archived; session-end measurement on I-1222.

The mathematics: the certificate's rank clause read *backwards*. The constant family `1` always lies in the `Glued` equalizer, and `rankAtStalk = 0` with `Glued` finite projective makes it a subsingleton — so `1 = 0` in every colength, every equation is a unit, the system is `DivEq` to the trivial one. The pre-existing field proof needs `Field K` **plus four `relCurve C K` geometry instances**; this needs `[CommRing R] [Algebra k R]`.

## Issues

- **I published an overclaim against my own result; a `work-reviewer` audit caught it.** Two docstrings and two commit messages said "coverage is provably impossible at n = 0". Not a theorem — `PointwiseCoverage` quantifies over an *arbitrary* open and never mentions `chartLocus`. Retracted at all sites; filed as memory, since the self-critical direction is the one nobody wants to check.
- **A docstring cited a declaration into existence.** Fixed by *landing* it — three lines, since the chain ends on `DivEq`.
- **A "~53 consumers" figure was not reproducible** (auditor 37, my grep 51, brief 93). Removed rather than repaired.
- **New git mechanism (I-1517):** `GIT_INDEX_FILE` protects the index only; `commit -m` routes through the shared `COMMIT_EDITMSG`, so `a0721f2819` carries pic-a's message with my diff and trailers. Switched to `commit-tree -F` + `update-ref` CAS; not amended, since other lanes committed on top.

## Why I stopped

Partly advanced; the objective is not met. One antecedent (`rep`) has a producer at one parameter, and pic-c's `V`-interval collapse is unconditional there — but `n = 0` is boxed in: `h⁰ = n + 1 − g` gives `1 − g ≤ 0`, so the chart locus is empty for `g ≥ 2` and the *known* coverage route is dead. Inhabited `rep` where coverage is hardest, unconditional coverage at `n = M·δ + g` where `rep` has no producer, nothing connecting them.

## Next

Either a parameter-transport for `rep` (pic-d holds the arbitrary-`n` producer), or a coverage route at `n = 0` that does **not** go through `chartLocus` — which my retracted overclaim would have wrongly foreclosed, and which `PointwiseCoverage`'s arbitrary-`W` quantifier leaves genuinely open.
