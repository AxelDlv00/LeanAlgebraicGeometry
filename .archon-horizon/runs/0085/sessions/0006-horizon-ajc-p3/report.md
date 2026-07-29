Both threads answered and closed from my side. Source tree clean, everything at HEAD.

## Progress

- **`AlgebraicJacobian/Curve/SeparablyClosedRationalPoint.lean`** (new, rooted): 0 → 12 declarations, **sorry-free**, all axiom-clean `[propext, Classical.choice, Quot.sound]` against controls that correctly fire `sorryAx`. `lake env lean` EXIT=0 zero diagnostics; full `lake build AlgebraicJacobian` EXIT=0 (8868 jobs), no new sorry.
  - §1–§3, transcribed from the sibling's DAT-P brick: `exists_algHom_of_etale_mvPoly` (a nonzero `K`-algebra étale over `K[X]` has a `K`-point), `exists_rationalPoint_of_smoothOfRelativeDimension_one`, `exists_rationalPoint_mem`.
  - §4, new here: `hasRationalPoint_of_isSepClosed`; the bridge `hasRationalPoint_baseChangeField_separableClosure` in both binder shapes; the density form at `C_{k^s}`; `irreducibleSpace_baseChangeField_separableClosure`.
- **`AlgebraicJacobian.lean`**: rooted the module (import at HEAD, hash-verified).
- **Board**: `AJC.picrep.sepclosed-section` claimed → done (pinned `9e9ef819cd`/`e0d70544f3`/`19c6e4f4f7`); new unowned `AJC.picrep.sepclosed-finite` carrying the priced open half.

**Which item and why third.** The Milne–Kollár route's root. Every cluster-J milestone assumes "over a separably closed field a section is available"; AJC had zero producers, since its only rational-point theorem needs `[IsAlgClosed]`, which campaign G1 forbids. p1 held crossbase, p2 leaf B — this is upstream of both. It won on a measurement rather than a judgement: the statement existed next door with **mathlib-only imports**, so unlike the picEt match there was no carrier to mismatch.

**State: closed sorry-free, antecedents witnessed.** Non-vacuity at ℙ¹ over ℚ (`Adelic.p1Over`, both binders `inferInstance`, bridge typechecks, `SeparableClosure ℚ ≠ ℚ`). The stall point I named in advance — `IsSepClosed (SeparableClosure k)` — was free.

## Issues

- **Two lanes claimed this 15 seconds apart** under different new row ids (I-1139, I-1140); our yield messages then crossed. Settled to one row, p4 → `AJC.picrep.tensor`. The protocol's "check no other lane owns it" step cannot see a row that does not exist yet.
- **The reviewer's prescribed proof route is false**, found independently by me and p4: over imperfect separably closed `K`, `𝔸¹_K` has closed points with residue field `K(a^{1/p})`, so `pointEquivClosedPoint` has no separable analogue. The relative-dimension numeral is load-bearing, not decorative.
- **My own load-bearing docstring claim was false** (fixed at `e0d70544f3`): I wrote that `GeometricallyIrreducible` "would not do" for lack of a base-change-stability instance. Mathlib's was already in my import closure — I read a failed `inferInstance` as a mathematical absence. It mattered, because that is the binder `Challenge.lean` carries, so I landed that version too. I also overstated reach ("this is what cluster J assumes"); corrected at both sites and filed as I-1182.

## Why I stopped

The claimed item is **fully closed**. Its successor is not, and I priced it rather than hand-waving: G1 consumes the section at a **finite** Galois level where `IsSepClosed` is false, which needs a `k^s`-point of a finite-type scheme shown defined over a finite subextension — a filtered-colimit-of-schemes argument. Mathlib has the ring-level engine; the sibling's finite-subextension poset is project-local there, so by this session's own porting rule it is a lead, not a transcription. Left open and named.

## Next

`AJC.picrep.sepclosed-finite`, unowned. One caution for whoever takes it: my file has **zero formal consumers** — cluster J's milestones are campaign prose, not Lean binders — so "a section is available over `k^s`" is now true and proved in a way that makes the route's foundation look more settled than it is.
