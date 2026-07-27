Hygiene pass complete. Report below.

## What I found and changed

**Both roadmap warnings are now chosen ones, verified against Lean rather than summaries.**

1. **`AJC.jacobian.assembly` "every sub-item is done"** — verified: it must **not** be marked done. `AlgebraicJacobian/Jacobian.lean` carries three real `sorry` bodies of its own (`:273`, `:287`, `:308`), and two of the four upstream fields `picardJacobianWitness` is built from — `Pic0.smooth`, `Pic0.proper` — are `sorry`-bodied in `Picard/Pic0AbelianVariety.lean`. Five open obligations; proving only the three still leaves `sorryAx` in the witness. The row's summary already recorded the mismatch as deliberate, so I added the file:line evidence as a roadmap comment rather than rewriting it. **Warning survives on purpose.**

2. **"9 active items (max 8)"** — I changed nothing and left a note on `AJC.maintenance`. Five of the nine are the single nested chain `AJCR.jacobian → w4-rep → .datum → .dat-d → .ddr`; an ancestor of an active leaf must be active for the outline to render, so a deep tree pays five rows for one front. The nine rows are three fronts. `AJC.maintenance` is the one genuinely deferred row (owner `ajc-optimize`, task queued, unmoved since 07-25) — flipping it would clear the warning honestly, but it is another team's, so I left the one-command instruction on the row instead. **Warning survives on purpose.**

**Corrections you asked for**

- **`I-0381` rewritten in place** (not archived). Its headline — gate needs four statements, `IsIntegral (ℙ¹_k)` and the rank identity open — went false during your session. Now states the true frontier (one leaf, `RigidPushforwardGammaBaseChange`), points at `Picard/RigidPushforwardInstance.lean` and commit `e4a026eb7`, and keeps what survives: the pushout/retraction template, the `HomogeneousLocalization.val_injective` `isDefEq` timeout, mathlib's total absence of `Proj` integrality API, and the `lake env lean` misses-the-style-linters gotcha.
- **`I-0385` is partly fixed** — defect 2 (`FiniteMapToP1.lean:442`) is repaired; the *class* docstring in `P1BaseCase.lean` is repaired too, but the **module-header bullet at `P1BaseCase.lean:43` still says "carries no instance … is later work"**, and defect 3 (`BoundedVanishing.lean:58`, phantom `subsingleton_h1Mod_of_linearEquivalence`) is untouched. Kept open, narrowed to those two.
- **`I-0362`'s named instances are all closed** — `GlobalGeneration`/`LedgerClosure` rooted at `AlgebraicJacobian.lean:205-206`, the six `RigidPushforward*` at `:63-94`. No unrooted module in AJC. Rule kept, census retired.
- **Correction to `I-0411`**: it says (quoting protection `I-0074`) that `FGAPicRepresentability.lean` has "four real sorries". It has **one** — `instHasPicScheme` at `:263`. The other two matches are docstrings saying "the file's only sorry". I did not touch the protection.

**New issue filed:** `I-0420` — `RigidPushforwardGate.lean:289` still advertises `hasRigidPushforward_of_leaves` as "the exact remaining frontier … four named leaves". Lean source, so filed not fixed. Cross-linked with your `I-0421` and `I-0422` so one editing pass closes all three, and extended with `scripts/axiom-frontier.lean:249-253`, which lists three blind spots of an axiom check where there are now four.

**Duplicate caught:** `ajc-rr` filed the same lesson twice, six minutes apart — `I-0416` (11:31:22) and `I-0419` (11:37:29), same three binders, same theorem. Merged into `I-0416` (it carries `[persistent]`), content preserved verbatim. Also merged `I-0399` into `I-0397` — same technique, opposite direction (leaf too strong/false vs. leaf set too weak/re-indexing).

**Doc fixed directly and committed:** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md:53-62` — "Three separate things it cannot see" → four, adding the un-instantiable instance binder. Commit `143172857`, that file only. **No Lean source touched, no Lean change committed.**

## Before / after

| | before | after | note |
|---|---|---|---|
| open inbox (non-protection) | 38 | 39 | I removed 4, added 1; `ajc-gate` filed 3 during the pass |
| open `memory` | 17 | 17 | archived `I-0399`, `I-0419`; `ajc-gate` filed `I-0423` |
| open `conversation` | 8 | 8 | archived `I-0405`, `I-0409`; `I-0421`/`I-0422` arrived |
| unread for `ajc-gate` | 16 | 4 | left unread: `I-0074` (protection), `I-0417` (correction to you), `I-0423`, `I-0083` |
| roadmap active | 9 | 9 | unchanged deliberately |
| task warnings | none | none | 11 open tasks, cap 12; no stale `running` |

Net of concurrent arrivals my actions took it 39 → 36. Statuses verified intact afterwards: `AJC.jacobian.assembly` still `pending`, `AJC.maintenance` still `active`, 255 roadmap items.

## Deliberately left alone

- **`I-0386`** (`task set --status` rewrites `roadmap_refs`) — duplicated in `SKILL.md`, so archivable on a pure-dedup argument. Kept: it is an active-harm memory that has already flipped a live critical-path row to `rejected`, and it carries the current table of which tasks have `roadmap_refs`.
- **AJCR memories** (`I-0320`, `I-0354`, `I-0365`, `I-0367`) and the AJCR active chain — that lane is dormant and I can't verify consumption cheaply; `I-0386` records that a row there was accidentally flipped once already.
- **`I-0410`, `I-0418`, `I-0394`** — threads between `ajc-rr` and `ajc-truth`. `I-0410`'s rooting half is verifiably done but its axiom-audit half may not be; not my thread to close.
- **`I-0412`** (ajc-rr's global-generation memory) — core claim stands, but I cross-referenced `I-0414`/`I-0415`/`I-0417` on it so nobody reuses the retracted residue-degree-one part.
- **`I-0220`** re-verified still true (`RelCurveCollapse.lean` is 752 lines, limit 500).

## The memory cap will not come down, and that is now escalated

17 open memories against a cap of 10. I triaged all of them individually; after two genuine merges, the remainder are each live. I added the current arithmetic to **`I-0387`** (the existing human-addressed issue on this, now on its third consecutive janitor pass) with a concrete fix for whoever owns the CLI: in `archon_horizon/core/collection_health.py`, `AdvisoryHealthLimits` is a single frozen dataclass of global defaults — make it per-workspace configurable from `config.yaml`, and count only **leaf** active roadmap items against `active_roadmap`. As it stands, three passes in a row have had to write a paragraph explaining why a warning survives, which is the cost the warning existed to save.
