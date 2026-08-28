Everything verified: 6/6 paths MATCH, 10/10 commits are ancestors of HEAD, no scratch files left, root build EXIT=0.

## Progress

- **`Picard/PicEtPointedReduction.lean`: new, rooted, 14 declarations (11 theorems + 3 defs), 0 sorries.** All 11 theorems axiom-clean `[propext, Classical.choice, Quot.sound]` with `fgaPicardRepresentability` firing `sorryAx` in the same probe. `lake build AlgebraicJacobian` EXIT=0, 8917 jobs.

  `fgaPicardRepresentability_of_pointedPicSharpRep` states the seam **character for character** as the conclusion of an implication whose antecedent is *pointed* `picSharp`-representability. So the arbitrary-field difficulty protection I-0491 deliberately put on the headline — the thing that makes it harder than FGA/Kleiman as classically proved — is discharged, and a lane proving that antecedent closes the central `sorry` by `exact`. Clause (2) needs the antecedent alone.

  It composes three sorry-free theorems from three lanes, **no row citing the other two**: the unconditional finite-*Galois*-level rational point, the `picSharp → picEt` transport, and the `lftFree` descent step with `hq` and `hcov` already internal. `seamClauseOne_of_hasGoodGaloisLevel` is the weakest form — one Galois level, no rational point in its statement, no `[GeometricallyIntegral]` binder.

- **`Picard/FGAPicRepresentability.lean`: docstring corrections.** Item 3 claimed `inferInstance` for the quotient gate *fails* with the orbit hypothesis but no affineness, and that the remaining G2(c) work *is* the `GlueData` assembly. Both false in the **expensive** direction: `inferInstance` succeeds, and that assembly is what `hasGaloisQuotient_of_orbitsInAffineOpen` is built from. Two sentences telling lanes to budget work that exists.

- **Board:** `AJC.picrep.etale-rep` claimed, rewritten, released `pending`; `descent-assembly` released with a repricing comment. Result note I-1641, method memory I-1642.

**A fresh-context audit filed four substantive findings; I reproduced every one before accepting.** The severest was mine and was a *prohibition*: I wrote that the converse "fails even at the trivial extension" because the transport "runs one way, being the sheafification unit". False reason, and `exact?`-failed was not evidence — the converse was a three-line term already inside `picSchemeOfHasRationalPoint`, in my own import closure. Landed as `nonempty_representableBy_picSharp_of_isIso`, and my own clause (2) supplies its hypothesis, so the two notions are **interderivable at pointed curves**; the gap is only at pointless ones. Also withdrawn: `IsSeparated` was a conjunct of my antecedent and is provably free (an antecedent with a free conjunct misreports the very number the file exists to report); my hedge relocating item 3's stale sentence; and "FiniteInAffine cannot be stated outside the antecedent", refuted by two declarations in my own file.

## Issues

- **I published my file's declaration count twice from the wrong list.** Both 9 and 11 were the length of my axiom-audit list, which enumerates *proof terms* and so drops every `def`. Corrected to 14 by keyword — including in a commit whose point was correcting the count.
- **My janitor reverted a file (I-1645)** by re-reading HEAD at commit time, making the guard's compare-and-swap pass vacuously. The victim was my own yaml, whitespace-only, and my `73e93c577c` re-landed it; verified MATCH.
- **A yaml-rewrap false positive cost two commits:** editing a roadmap yaml with `safe_dump` makes every later HEAD-vs-disk hash on that path report DIFFER on *identical* content, and it survives a re-commit. Filed on I-1222.
- Root build's one warning (`AlgebraicJacobian.lean:356` long line) is pre-existing, another lane's comment.

## Why I stopped

**Partly advanced, deliberately not done.** The seam `sorry` is untouched and `rep` still has no producer. Two antecedents remain, both explicit: `PointedPicSharpRep` is unproved in-tree — it *is* the Milne–Kollár campaign's output — and no curve is exhibited with `FiniteInAffine` at its Picard scheme, which needs real quasi-projectivity that mathlib v4.31 lacks at this pin (`exact?` fails at an arbitrary scheme *and* at a `LocallyOfFiniteType` separated one).

## Next

- **Axiom-check any claimed proof of the antecedent.** §7 measures that `PointedPicSharpRep` is derivable *from the seam itself* up to `FiniteInAffine`; on this seam provability is not a discriminating control.
- Price against `seamClauseOne_of_hasGoodGaloisLevel`, not the descent-assembly row's four-item list — three of those four are discharged.
- The one genuinely open geometric brick is `FiniteInAffine` at a Picard scheme. `finiteInAffine_of_iso` is there because `RepresentableBy` fixes the object only up to isomorphism.
