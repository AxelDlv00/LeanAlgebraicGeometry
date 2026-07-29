All three files are byte-identical HEAD-vs-disk — `git diff HEAD` reports them as deletions only because it consults the stale shared index; sha256 against HEAD is authoritative and passes. Nothing this lane authored is uncommitted.

## Progress

- **`Picard/PicEtSeparated.lean`** (new, rooted, 7 declarations, **zero code sorries** — all four `sorry` strings are docstring prose — every declaration axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` as a control that correctly fires `sorryAx`): claimed `AJC.picrep.etale-rep.separated` (new row) and **closed fields 2 and 3 of the seam's clause (1)**.
  - `isSeparated_of_representableBy_picEt` — `IsSeparated X.hom` from a *bare* `(picEt C).RepresentableBy X`, smooth proper curve over an **arbitrary** field, no `C(k)` hypothesis (`I-0491`), `GeometricallyIntegral` confirmed unused.
  - `seamClauseOne_of_representableBy_locallyOfFiniteType` — clause (1) as a **two-field** obligation.
  - `picEtClauseOne_of_picSharp_representableBy_locallyOfFiniteType` — the same drop on the **campaign's own endpoint**.
  - `locallyOfFiniteType_of_baseChange` — field 2 by descent, making the contrast compiler-checked.
  - Plus the three-name group-separatedness port, absent from mathlib and from AJC (both measured).
- **`Picard/FGAPicRepresentability.lean`**: item 5 of the repair scoreboard rewritten — it prescribed a port and asserted "none of those three names exists in this project", false at HEAD.

## Issues

**Which item and why.** Not a leaf beside the route but a **conjunct of the goal**: `review-ajc` measured that four rounds of costing priced clause (1)'s first field only. I took it over more G2 work because their audit (`I-1264`, which I accepted against my own r4 output) showed the gate I advanced has **zero binder sites** — it transmits nothing today, while field 3 sits inside a `sorry`-bodied statement.

**State: closed sorry-free for two fields; field 1 explicitly not witnessed.** The seam `sorry` is untouched and **no antecedent holds for any curve**. `k'`-side representability remains undischarged with a refutation route mapped out over arbitrary `k`. Only the *shape* of the deliverable changed.

**Reusable finding (`I-1321`).** Two conjuncts both "free" can be free for **opposite reasons**: field 2 *by* descent, field 3 only *because* descent is unavailable for it. A lane reading "both are free" plans a descent step carrying all three fields, and field 3 has no lemma to cite. Found only by writing field 2 as a theorem rather than leaving it the docstring sentence it had been.

**Second finding (`I-1338`).** `hasPicSchemeEt_of_picSharp_representability`'s docstring explains why separatedness *survives* the transport — which is exactly what stopped anyone asking whether it was *needed*. The campaign must deliver a `picSharp`-representing scheme locally of finite type and **nothing about separatedness**.

I reproduced the reviewer's self-correction rather than accepting it: their "exactly five flat-descent instances" is refuted by two witnesses I found myself. My file quotes no total — drafting luck, not care, hence the recorded rule: cite the absences your *proof* consumes, never the enumeration.

**Two negatives:** `Pic0SchemeEt` separatedness does **not** become gate-free, and `I-1294` still reads as an open task that would send a lane to re-port a landed file (`I-1322`).

## Why I stopped

The claimed objective is complete for the two fields; the seam is not, and I have not represented it as closer. **The audit gap is real and recorded in-tree**: the `work-reviewer` I dispatched against all 7 declarations with 6 adversarial targets produced no report before session end, so this work is **not fresh-context verified** — every claim is my own measurement with controls stated, and `I-1340` tells a reviewer to treat the duplicate-by-statement question as open. `lake build AlgebraicJacobian` EXIT=0, 8874 jobs, zero errors, no warning from my file. Eight commits, all ancestors of HEAD.

## Next

The honest next item is `I-1281`'s **invariance ⇒ compatible family** (Hilbert-90 content of G1) — a proposition, not a construction, and the first thing on this route that would *witness* rather than restate. I left it for `ajc-p2`, who holds the assembly it feeds. Field 1 remains the whole obligation. Warn any lane about to commit: the shared index reports files committed minutes ago as deletions (`I-1339`); the hazard grows with every lane's commit, so re-seed a fresh private index at current HEAD immediately before committing, and never reach for `ARCHON_HORIZON_ALLOW_DELETIONS=1`.
