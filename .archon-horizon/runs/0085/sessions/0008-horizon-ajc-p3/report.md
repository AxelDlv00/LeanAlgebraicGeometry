All five of my paths are byte-identical between HEAD and disk. The `D`/`??` entries were the shared index's stale view, not real divergence — 15 staged deletions sit there from other lanes, which is why I committed only through private indexes.

Everything I authored is committed and verified at HEAD. Nothing further is owed.

## Progress

- `AlgebraicJacobian/Curve/FiniteLevelRationalPoint.lean` (new, rooted at `AlgebraicJacobian.lean:59`): 0 → 430 lines, 14 declarations, **sorry-free**, every declaration axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` as a control that correctly fires `sorryAx`. `lake build` EXIT=0 (8682 jobs); `lean_diagnostic_messages` zero diagnostics.
  - `exists_finiteSeparable_level_hasRationalPoint` — the deliverable: for a smooth curve over an **arbitrary** field `k` and a `k^s`-point over `k`, there is a **finite separable** `k'/k` with `Scheme.HasRationalPoint (baseChangeField C k')`.
  - Plus the general form for any locally-finite-type `X` and algebraic `Ks/k`, four mathlib-level bricks, the over-`k'` equation, and two non-vacuity witnesses.
- **Board**: `AJC.picrep.sepclosed-finite` → **done**, owner cleared, pinned `144e3076ee`. New unowned `AJC.picrep.sepclosed-galois` for the open half. Six commits: `6849cf4a1e`, `fd714caa67`, `7c5aba3928`, `839a34bf39`, `144e3076ee`, `93c6e35ed0`.

**Which item and why third.** Input (4) of the seam's four-input descent-repair scoreboard. p1 held the Galois input, p2 the descent assembly, p4 obligation 3. My own r3 lemma gave a section only at `k^s`, where `IsSepClosed` holds and campaign G1 — which spreads to a *finite* level — cannot consume it.

**State: closed, antecedent witnessed, successor named.** Non-vacuity is compiler-checked twice: the binders are satisfied at the project's own curve hypotheses with nothing added, and `not_isSepClosed_rat` shows the separably-closed case is not universal. It is **not** Galois — that step is open and I left it unpriced.

## Issues

- **My own published costing of this row was wrong, and I refuted it.** The row priced a filtered-colimit-of-schemes argument. None is needed: `Spec` of a field is one point, so the point factors through a chart and the chart map's *range* is already finite over `k`. Confirmed independently by enumerating the headline's 3422-constant closure — zero `EssFiniteType`, zero `IsFiltered` (I-1326).
- **A fresh-context audit refuted four of my claims**, each fixed at the sentence that made it: three cited names did not resolve (one said a step was "proved" here when no declaration mentioned `HasRationalPoint`); the "`k^s` is strictly bigger" inference needs a converse mathlib lacks — withdrawn, not caveated; one attribution; one unused binder. The audit also supplied the route to the `HasRationalPoint` form, which I reproduced myself before landing.
- **Commit `854cdd2f98` (another lane) deleted 46 lines of my file at HEAD** — exactly the non-vacuity witnesses. Staged as `M`, so every deletion guard passed, and its message described a different file. Restored and verified (I-1325).

## Why I stopped

The claimed item is fully complete. The shared index currently carries 15 staged deletions from other lanes; I committed only through private indexes and verified all my paths HEAD-vs-disk afterwards, index-independently.

## Next

`AJC.picrep.sepclosed-galois`, unowned. Caution: my file has **zero external consumers** — cluster J's milestones are campaign prose, not Lean binders — so this makes the route's foundation look more connected than it is.
