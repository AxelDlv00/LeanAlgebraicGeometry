The note landed on I-1222. Everything is committed and verified; nothing of mine is uncommitted.

## Progress

- `AlgebraicJacobian/Picard/PicEtInvariantMatch.lean`: **new, 13 declarations, zero sorries**, rooted. `lake build` EXIT=0 (8696 jobs), zero diagnostics from the file; axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` firing `sorryAx` in the same probe — re-measured independently by the auditor after an olean rebuild.

  **Campaign `G1` is off the étale-descent route.** `isInvariantMatch_canonical` proves the `IsInvariantMatch` hypothesis my r1 file introduced as `G1`'s debt, at the canonical action, for every test, with **no hypothesis beyond `rep` and the curve's own binders** — no `IsSeparable`, no `Module.Finite`, no `IsGalois`, no condition on `Gal(k'/k)`. Free because the action's γ-component *is* `twistMor γ`, defined by transporting `galoisActionPicEt` along `rep`; naturality at `φ.op` converts equivariance into invariance. `seamClauseOne_of_isGaloisQuotient_noMatch` gives clause (1) from `rep` + quotient + `hcov` + `hlft`.

- **Audit verdict: the headline survives**, with checks named — `rfl` fails on the predicate (not vacuous); canonicality is load-bearing; `hq` is syntactically unchanged so nothing migrated; the γ/γ⁻¹ reindexing is sound; all citations resolve by `#check`; no duplicates.

- **The audit refuted one of my published sentences; withdrawn in all three live copies.** I claimed the new theorem *subsumes* `isInvariantMatch_of_subsingleton`. False — that lemma quantifies over an arbitrary `ρ` while mine **pins** it, so the two are **incomparable**. Reproduced as a type mismatch before fixing. It matters materially: the old lemma is **load-bearing** at `representableBy_picEt_of_degenerate`, which takes an external `ρ`.

- Corrected prose my own commits falsified in `PicEtDescentGoal.lean`, `FGAPicRepresentability.lean` (including the `Exists.casesOn` overclaim), and `AJC.picrep`'s break analysis. Board: `invariance` → **done**; `descent-assembly` released **still-open**.

## Issues

- **My own corrections over-corrected twice.** The false "subsumed" sentence was an r2 fix of an r1 caveat, replaced by a stronger claim in the opposite direction, sitting one clause from two probes that were correct — so it read as audited by proximity.
- **The janitor never returned.** The `52 open inbox items` / `41 active roadmap items` warnings survive my session unaddressed.
- **At 1200 staged deletions, the commit-checkpoint hook and `git diff HEAD` both report my own committed files as deleted** — my two new Lean files showed as 528- and 701-line deletions while existing on disk at exactly those lengths. Verified index-independently: sha256 of `git show HEAD:<path>` equals the disk file for all seven authored paths, and a diff against a fresh index is empty. Filed, because the natural response is to "restore", and a restore from a stale blob is how this protection records real work being destroyed by a well-meant repair.
- **`FGAPicRepresentability.lean` was published mid-edit**: all three docstring edits reached HEAD inside other lanes' sweeps, so commit `351202ce0c` landed as an empty diff with a message describing a diff it does not carry. Content verified correct.
- The zero-byte `index.lock` makes `git commit` *hang*; all ten commits used `commit-tree` + `update-ref NEW OLD` with `OLD` captured once before `read-tree`.
- `AJC.picrep.etale-rep.hcov` stays `owner=pic-a` though run 0091 exited — I did not take it.

## Why I stopped

**Partly advanced.** The seam `sorry` is untouched and clause (1) field 1 is witnessed for no curve. One of four named antecedents is now a hypothesis-free theorem, leaving **two** between a `k'`-side representation and clause (1): pic-f's non-affine Galois quotient (they confirmed `GaloisQuotientRestrict` specialises directly to the pinned shape) and `hcov`. `k'`-side representability itself did not move.

## Next

- `hcov` is the cheapest-looking remaining input and nobody is running it; `hcov_of_jointlySurjective` reduces it to a statement about points, and `I-1560` maps an ideal-theoretic route.
- Re-dispatch the janitor for the unaddressed collection-health warnings.
- Do not read "two inputs instead of four" as progress on `rep` — shortening the list between `rep` and clause (1) does not move `rep`.
