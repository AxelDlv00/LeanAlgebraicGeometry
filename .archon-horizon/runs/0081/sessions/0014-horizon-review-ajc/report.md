All threads handled, all edits verified at HEAD.

## Progress

- **`Picard/FGAPicRepresentability.lean`**: the round's one substantive finding, from a question no prover lane was positioned to ask. Clause (1) of the seam `sorry` is a **three-field** existential, and the whole board priced only the `RepresentableBy` field. Measured the other two (`lake env lean` EXIT=0, axiom-clean against a control where `fgaPicardRepresentability` fires `sorryAx`): `LocallyOfFiniteType` **descends** free at the actual cover; `IsSeparated` **cannot descend at all** in Mathlib v4.31 — no instance, and the diagonal route needs `IsClosedImmersion` descent, also absent — yet is free by a *different* mechanism, since `picEt` is `CommGrpCat`-valued, so any representing scheme is a group object and a group scheme over a field is separated. Recorded as item 5; the missing brick specified as a port, with its two load-bearing declarations already compiled in-tree.
- **Handed to a prover, not taken**: `ajc-p1` claimed a new row and landed **both** fields within the hour (`Picard/PicEtSeparated.lean`, sorry-free, axiom-clean). Clause (1) is now a two-field obligation. `ajc-p3` closed `sepclosed-finite` after my note that the separatedness half must not widen their item.
- **Board**: the brief's three parent/child warnings and stale anchors were already fixed by earlier rounds of this lane — verified rather than redone. Independently re-derived the dead-consumer census, **74 / 27**, confirming the board's figure against my own first script's wrong 70.
- Seam file kernel-checks EXIT=0 with exactly the one expected `sorry`. Two commits, one file each, both hash-verified against HEAD afterwards. Five threads I initiated archived with conclusions; three addressed to me answered.

## Issues

**Two of my five published sub-claims were false, both corrected where published.** "Mathlib has exactly five such scheme instances" was *one file's* count sold as Mathlib's — it is eleven — and it sat three lines above this same file's method note warning about exactly that. And "the side conjuncts were never mentioned" was false: they were priced a day earlier as free *by transport* from the `picSharp` endpoint, on the `AJC.picrep` row and in `PicEtSubcanonical`'s docstring — **my own lane's text both times**. I checked the `etale-rep` rows, got zero hits, published an absolute. The defensible claim is narrower and is the one that matters: free on the field-descent route *too*, for a reason opposite to the transport route's. While fixing it I also cited a declaration name that did not exist, and corrected that. Both came from the fresh-context audit I asked to refute me rather than confirm me.

**Left open deliberately, and the one thing worth a human's attention:** the shared git index carries **fourteen** staged deletions of files present at HEAD *and* on disk, including `PicEtSeparated.lean` — this round's landed result. It grew from eight during the session, *while* three lanes independently derived and filed the post-commit check meant to prevent it, and a fifth reproduction landed showing that re-seeding a fresh index does not close the race either. My own commit passed every step of that discipline and was reverted anyway by a later commit. Escalated to `--to human` (I-1319) arguing the fix belongs at the harness layer — a per-lane `GIT_INDEX_FILE` — not in another protection. Not reset: twelve of the fourteen belong to live lanes.

## Why I stopped

Objective complete for a reviewer lane. I proved nothing and took no prover's work; the one result I found was specified precisely enough that a prover landed it the same hour. Nothing of mine is uncommitted.

## Next

`AJC.picrep.etale-rep.descent-assembly` is the sharpest open item — clause (1) is down to its representability field, and `k'`-side representability remains the campaign's undischarged output, so the seam has not moved. Worth watching that no lane reads "two conjuncts closed" as progress toward it.
