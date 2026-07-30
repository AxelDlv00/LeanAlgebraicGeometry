Everything I authored matches HEAD byte-for-byte. Ten commits landed, all ancestors of HEAD, all with clean post-commit diffs.

## Progress

Closed the **negative branch of the `abel-noninj` fork** — the question five AJCR files defer to in the words "either `n` is a degree where `h⁰ = 1`, or it is not (negative branch, and a witness exists) — neither is decided here." It was a four-link chain with exactly one link missing, and the missing link was **the converse of the keystone all five of those files cite**.

- `RiemannRoch/EffectiveNonUniqueness.lean`: new, 268L, 4 declarations, rooted, code-sorry-free. `exists_two_effective_picClass_eq_of_two_le_h0` — from `0 ≤ A` and `2 ≤ h⁰(𝒪(A))`, two *distinct* effective divisors of one class (the pair is `A` and `A + div f` for `f` a section outside the span of `1`; distinctness is where `hO : h⁰(𝒪_X) = 1` is consumed). Plus `two_le_h0_iff_exists_two_effective`, the full equivalence with `eq_of_picClass_eq_of_h0_one`, so the file is a genuine converse rather than a parallel statement.
- `Picard/Pic0ChartForkNegativeBranch.lean`: new, 296L, 4 declarations, rooted, sorry-free. Composes the brick with three landed-but-never-joined links to **refute** `RelPicSeparatesDivFamZar` — the fork's own named residue — and hence `chartValue` injectivity, at every field carrying an effective degree-`n` divisor with two sections.

Why it was absent: the keystone is cited by seven files, always in the `h⁰ = 1` direction, so its converse is invisible to any name-census. Measurable second tell — before this round `2 ≤ Sheaf.h0` appeared project-wide only in *conclusion* position, never as a hypothesis.

What it buys the headline: antecedent 1 needs `h⁰ = 1`, i.e. `n ≤ g`; the only landed unconditional coverage sits strictly above `g` and supplies the `2 ≤ h⁰` witness there. The two seam antecedents pull opposite ways along one parameter. Recorded on `AJCR.w4-rep` as a question, not a no-go, and relayed to pic-h, whose in-flight package targets that parameter.

All eight declarations axiom-clean `[propext, Classical.choice, Quot.sound]` against `AlgebraicGeometry.Jacobian` firing `sorryAx` in the same probe run.

## Issues

**I clobbered 13 paths of pic-e's and pic-a's** (`052f90443d`), restored byte-identical in `3656070a52`; pic-e verified nothing was lost. This refutes the fix I-1517 prescribes: `commit-tree` + `update-ref NEW OLD` guards the *tree* only if `OLD` is the sha your `read-tree` used — I re-read HEAD for the CAS argument, so it passed on a stale tree. pic-e accepted the correction. The corrected form held for my last six commits, zero further incidents.

A fresh-context review found **five errors in my composition file and three phantom names in my own "Main declarations"** — worst being the equivalence the file's "this is a converse" claim rests on. All confirmed and fixed; the equivalence is now proved rather than deleted. My citation-discipline paragraph named a nonexistent constant *and the proof used the same wrong spelling*, so the paragraph could never have caught it. Another lane's sweep banked that file into HEAD while it was still broken.

Root build is **red at HEAD** on another lane's uncommitted `DivisorFamilyAffThetaCech.lean` (three parse errors, written mid-build). Filed as I-1552, not mine to fix; both my modules built clean in-graph at 9346/9350 and 9347/9350.

Shared index carries **947 staged deletions** including both my files — all 47 staged-D `.lean` verified present at HEAD *and* on disk, so nothing is lost, but the next plain commit by any lane would delete them. Measured on I-1222 with the note that at this scale reading the staged stat is no longer humanly possible.

## Why I stopped

Partly advanced. **Pic⁰ representability is not closed** and no antecedent of `pic0RepresentableByOfCharts` is discharged. One of the fork's two branches is now decided, and it closes *against* the atlas above the genus rather than opening a route. Untouched: the positive branch at `n = g`, and `n = 0`, where `2 ≤ h⁰` fails because `DivFamZar` is subsingleton there.

## Next

`n = g` is the one parameter where both antecedents could coexist, and it hinges on `IsDivisorDegree C g` — pic-h holds that row. A lane taking this forward should not hunt a witness above the genus (now proved) nor read the result as refuting the atlas at `n = g` (it does not).
