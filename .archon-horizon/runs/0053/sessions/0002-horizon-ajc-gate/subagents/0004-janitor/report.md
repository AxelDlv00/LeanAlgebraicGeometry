Hygiene pass complete. All three dispatch warnings are cleared; one new one surfaced and survives deliberately.

## Before / after

| Check | Before | After | Limit |
|---|---|---|---|
| Open tasks | 15 | **11** | 12 |
| Inbox open non-protection | 35 | **28** | 30 |
| Roadmap active | 9 | **8** | 8 |
| Open memory items | 14 | **11** | 10 (survives) |

## What I changed

**Tasks** — closed 4, each with the measurement recorded as a task comment:
- **T13 → done.** Genuinely finished: no `Genus0BaseObjects/` directory, 0 `Genus0` hits in AJC Lean/blueprint/README. Only two docstrings mention it, as *rejected* history — correct, left alone. I cleared the last residue (two stale `roadmap.md` references).
- **T14 → cancelled.** Its premise is disproved: `Ample`/`VeryAmple` appear 0 times in AJC and the ampleness abstraction was never built, yet the projective-morphism half landed by a different design — `AlgebraicJacobian/Picard/ProjectiveMorphism.lean` is sorry-free with `IsProjectiveWith` plus `isProper`/`locallyOfFiniteType`/`baseChange`. Residue (2 Serre-finiteness sorries) is already the `AJC.picrep` leaf.
- **T15 → cancelled.** One-sentence objective duplicating the already-`failed` T12 over the same files. Bookkeeping only — the target is still open at `Picard/FGAPicRepresentability.lean:263` (`instHasPicScheme`, body `⟨sorry⟩`).
- **AJCR.w4-rep → cancelled.** Task id shadowing a roadmap id, superseded by the newer `ajcr-w4-rep-free`.

**Roadmap** — `AJC.maintenance.build.imports` active → **pending**. No owner, no live run, paused since `3fbc2cace`; parent `AJC.maintenance` already active. Kept its ordering rule, added today's re-measurement (66 of 172 bare, was 86 of 164).

**Docs** — `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md`: refreshed the AJC census (26 sorries in 11 of 172 modules), removed two references to the deleted `Genus0BaseObjects`, and fixed the `deumbrella-wave.sh` path, which pointed at the workspace root instead of `MainProjects/Algebraic-Jacobian-Challenge/scripts/`.

**Layout** — resolved I-0322: deleted the two byte-identical 264-byte `RationalCurveIso` stubs and a stale generated web artifact, and moved the 33 KB draft to `/home/axel/LeanAlgebraicGeometry-Horizon/SubProjects/Albanese/informal/RiemannRoch_RationalCurveIso-retired.tex`. I did **not** delete it as the issue authorised: its Hartshorne quotes were transcribed from scanned page images that `references/hartshorne-algebraic-geometry/pages/` does not mirror. The header says harvest first, then delete.

**Inbox** — archived 12 items, each with the evidence commented before archiving. Scoped 3 rebuild-only memories to `ajcr-w4-rep-free` rather than closing them.

Committed as `e50ac3d09`.

## The P1BaseCase docstring — filed, not fixed

Confirmed stale and worse than reported. `Adelic/P1BaseCase.lean:139-152` calls `HasFiniteMapToP1` a gate that "carries no instance", but the chain is fully proved: `NonconstantToP1.lean:1067` → `:136` → `FiniteMapToP1.lean:455-468`, all sorry-free. **`FiniteMapToP1.lean:439-441` has the same bug** about `ExistsNonconstantMapToP1`.

I filed it rather than editing: these are Lean sources in `RiemannRoch/Adelic/`, and `ajc-rr` (run 0055) is committing there right now. Fixing it myself risked a conflict with a live lane for a docstring-only gain.

## Two things you should know

1. **I caused and reverted a side effect.** `horizon task set AJCR.w4-rep --status cancelled` silently rewrote the roadmap row in that task's `roadmap_refs`, flipping the rebuild's critical path from `active` to `rejected`. I caught it on the re-check and restored it. Filed as memory I-0386 and documented in the horizon skill. **`ajc-gate`, `ajc-rr`, `ajc-truth`, `ajc-optimize` and `ajcr-w4-rep-free` all carry `roadmap_refs` — this will bite whoever closes them.**
2. **`.claude/` is gitignored**, so my skill-file edit is on disk but not in the ledger. Functionally fine (every session reads it from disk), but it will not survive a fresh clone.

## What survives, and why

- **11 memory items vs a limit of 10.** I stopped rather than archive load-bearing dead-ends. Two are `[persistent]` (I-0354, I-0367) — I scoped them to their lane instead of closing them. I-0381 is your own frontier record from this session. The rest are never-do-this notes still tied to open work (I-0065 ↔ T11, I-0349, I-0362). Archiving four more would mean deleting real failure memory to satisfy a generic default.
- **Left deliberately untouched:** `AJC.picrep.rigidpushforward` and its two children, the two new modules, the two `RigidPushforward*` files under concurrent edit, both fresh DMs (still unread), `ajc-rr`/`ajc-truth`/`ajc-gate`, the protection I-0074, and all three human-addressed items (I-0333, I-0346, I-0372) — closing a request the human hasn't answered isn't hygiene.
- **T2, T9, T10, T11 left open on purpose.** Each is real remaining work I verified: T2's three FBC sorries are exactly where I-0083 says, T10 is down to 3 (its headline `tangentSpaceIso` is proved modulo one leaf), T11 has 1 at `CodimOneExtension.lean:1751`. T16 I left as the north-star task despite duplicating `AJC.jacobian` — closing the goal itself felt like the wrong call to make unilaterally.
- **The nested AJCR active chain** (`w4-rep > datum > dat-d > ddr`) is 4 of the 8 active slots. Each level carries a real distinct summary and it is a legitimate focus path, so I took the one active slot back from the unowned import campaign instead.
