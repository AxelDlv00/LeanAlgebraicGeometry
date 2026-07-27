## 1. Task `ajc-gate`

- **Status:** `running` (note: every comment says "task stays QUEUED" — the YAML says `running`, i.e. currently-live session, not done)
- **Priority:** high · **Project:** Algebraic-Jacobian-Challenge
- **Title:** "Close the HasRigidPushforward representability gate"
- **roadmap_refs:** `["AJC.picrep.rigidpushforward"]` · **inbox_refs:** `[]` (empty)
- **Objective (key clause):** *"Done means a genuine non-sorry instance producer exists, the relevant direct consumers synthesize it without an explicit HasRigidPushforward binder... If a mathematically deeper prerequisite remains, factor it as an honestly named theorem with an exact statement, document the remaining frontier, and keep the task queued rather than claiming completion."*
- **write_set:** `RigidPushforward*.lean`, `P1SectionsFinite`, `ChartSectionsFinite`, `SemicontinuityH0`, `ScalarEndFaithful`, `SectionBaseChange` (all under `AlgebraicJacobian/Picard/`)

### Last 6 comments (all 6 that exist), `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/tasks/comments/ajc-gate/`

| id | when (UTC) | session | gist |
|---|---|---|---|
| C-0001 | 07-27 07:10 | 0053/0002 | Recon: roadmap text already contradicted; **"grep finds ZERO consumers of HasRigidPushforward outside its own declaring file, so the 'seven downstream obligations' in the task objective are prospective, not present."** |
| C-0002 | 07-27 07:53 | 0053/0002 | Gate FACTORED into 4 leaves. **"Keeping the task queued, not done: four leaves remain unproved, and leaf 4 (the baseChange gate field) has zero infrastructure."** |
| C-0003 | 07-27 08:40 | 0053/0002 | Leaf 2 closed, leaf 3 sheaf-half closed → 3 statements. **"NOT claiming done: the gate has no instance and three statements remain unproved. Task stays queued."** Plus attribution warning: *"RigidPushforwardFiberChart.lean and RigidPushforwardP1Sheaf.lean were swept into HEAD by run 0054's integrate commit f40296e11, not by one of mine -- the known attribution hazard."* |
| C-0004 | 07-27 09:04 | 0053/0002 | Fresh-context audit found a REAL DEFECT: **"the rank leaf was FALSE as first stated"**; *"A false leaf compiles, reports clean axioms, and silently makes every consumer vacuously true -- which is exactly what had happened to my two headline assembly theorems."* Repaired in `1c12efcaf`. |
| C-0005 | 07-27 09:19 | 0053/0004 | Strategy: P¹ chart-ring **freeness** is the shared unlock; missing injectivity half located in sibling Rebuild project. Re-states: *"HasRigidPushforward still has ZERO consumers outside RigidPushforward.lean's own three extraction theorems."* |
| C-0006 | 07-27 11:37 | 0053/0004 | **Outcome comment.** *"gate reduced from FOUR open leaves to ONE. Task stays QUEUED."* PROVED: `instIsIntegralP1OverLeft`, `p1RankIdentity_proved`; unconditional consequence `rigidPushforwardLocallyFree_proved`. **REDUCED, not closed:** `hasRigidPushforward_of_gammaBaseChange`. *"WHY NOT DONE. The done-criterion requires a genuine non-sorry INSTANCE producer. There is none: RigidPushforwardGammaBaseChange has no producer, so I deliberately did not write instance : HasRigidPushforward. Writing one would have been the exact failure mode this task's own history warns about."* |

**Verdict on the comment stream: it is internally consistent with "still open, one statement remains." No comment claims the gate is closed.**

## 2. Roadmap items referenced

`AJC.picrep.rigidpushforward` — status `active`, owner `ajc-gate`, subtree 2/3 done.
> "Rigidified pushforward engine -- the gate now costs ONE statement, not four... **Deliberately NO instance : HasRigidPushforward, because RigidPushforwardGammaBaseChange has no producer -- so the task stays queued.**"

Children:
- `AJC.picrep.rigidpushforward.basechange` — `active`, "**THE ONLY REMAINING GATE LEAF**", names `Adelic.RigidPushforwardGammaBaseChange` in `Picard/RigidPushforwardAffineDescent.lean`.
- `AJC.picrep.rigidpushforward.p1integral` — `done` ("CLOSED (run 0053 s0004)... Axiom-clean; the instance fires by synthesis").
- `AJC.picrep.rigidpushforward.rank` — `done` ("CLOSED (run 0053 s0004)... Adversarially re-verified: no broken brick, no vacuity... Axiom-clean").

Parent `AJC.picrep` (status `pending`) still lists "the rigidified pushforward gate (AJC.picrep.rigidpushforward, held by task ajc-gate)" among **open** inputs.

**Disagreements flagged:**
1. **Stale title vs. summary in the same node:** `AJC.picrep.rigidpushforward` is titled *"gate reduced to **three** statements"* while its summary says *"the gate now costs **ONE** statement, not four."* Cosmetic but misleading.
2. No roadmap item anywhere claims the gate is proved/closed. **Roadmap AGREES with "still open, one statement remains."**

## 3. Inbox

**I-0375** — kind `conversation`, **status `closed`**, author horizon. Full body:
> Axiom audit: 'axiom-clean' needs qualifying — synthesis leak measured
>
> From ajc-truth (run 0054). A reproducible probe now lives at MainProjects/Algebraic-Jacobian-Challenge/scripts/axiom-frontier.lean; run it with 'lake env lean scripts/axiom-frontier.lean' (~12s warm, 51 declarations).
>
> The finding that affects your done-criterion. Your task says '#print axioms for the new producer contains only accepted foundational axioms'. That check passes trivially for any theorem that *quantifies over* a gate: the hypothesis is discharged by the caller, so the sorry never appears. Measured examples: Pic0.geometricallyIrreducible, Pic0.isSeparated and Pic0.locallyOfFiniteType all report [propext, Classical.choice, Quot.sound] as stated. But instantiate them at a curve with a rational point, where Lean must SYNTHESISE HasPicScheme C, and all three pick up sorryAx, because instHasPicScheme (FGAPicRepresentability.lean:259) is the sole producer and its body is sorry. The probe has three leakProbe_* declarations that force exactly that synthesis.
>
> So for HasRigidPushforward: when you land a genuine instance producer, please check axioms at a CALL SITE where the instance is synthesised, not only on the producer and not only on gate-quantified theorems. If your producer's proof consumes anything from the Cohomology flat-base-change lane, note that AlgebraicGeometry.pullback_preservesFiniteLimits (CechHigherDirectImageUnconditional.lean:163) is sorry-bodied and taints PreservesFiniteLimits for flat pullback even along an identity morphism — measured, not inferred.
>
> Root roll-up: I own AlgebraicJacobian.lean. Send me the module names when your new files are ready to be registered and I will add them.

*(Note: your prompt describes I-0375 as the "clean axiom check on an ASSEMBLY theorem" caveat — that matches this body. The closely related persistent memory is **I-0380** "Gate-quantified theorems always look axiom-clean; measure at the synthesis site".)*

**I-0416** — kind `memory`, **status `open`**. Full body:
> [persistent] 'DISCHARGED' MUST MEAN THE INSTANCES SYNTHESIZE, NOT MERELY THAT THE PROOF TERM COMPILES
>
> Established by fresh-context review of ajc-rr run 0055 (GlobalGeneration.lean §7). Complements I-0397 (leaves must keep their enabling hypotheses) with the instance-argument version of the same trap.
>
> A theorem whose remaining obligations sit in SQUARE BRACKETS reads as unconditional at the call site and shows up axiom-clean under #print axioms, exactly like one with no obligations at all. hasRationalResidues_of_isAlgClosed replaced the informal claim '[κ(P):k̄] = 1' by three instance arguments — a k-algebra on the stalk, a k/stalk/K scalar tower, and Module.Finite k of the STALK residue field. Each occurs exactly once in the whole project: in that binder. None is constructed. The docstring named GateInstances.lean as the builder of the first two; it builds the analogous tower through GLOBAL SECTIONS, not through the stalk.
>
> THE CHECK, one grep per instance binder, before writing 'discharged':
>   grep -rn '<the instance head>' <project> — if the only hit is the binder you just wrote, you relocated the gap.
> Then additionally: if the binder mentions a type the project cannot identify with its own substrate (here IsLocalRing.ResidueField of the stalk vs. the lane's localStepTgt k P 1 quotient), it is a NEW gate even when it looks like an existing keystone spelled differently.
>
> Wording that survives review: 'reduced to instance data D1..D3, none yet available' — never 'no longer an assumption'.

**I-0385** — kind `issue`, **status `open`**. Body (abridged only where noted; opening verbatim):
> STALE DOCSTRING: HasFiniteMapToP1 and ExistsNonconstantMapToP1 both say 'carries no instance'; both have had proved instances for some time.
>
> Found and verified 2026-07-27 (janitor, run 0053). Documentation defect only -- no proof is wrong, nothing is broken. Filed rather than fixed because these are Lean sources under RiemannRoch/Adelic/, which the live task ajc-rr (run 0055) is writing in right now; whoever owns that lane should make the edit.

It documents two defects (`P1BaseCase.lean:139-152` and `FiniteMapToP1.lean:439-441`) and warns: *"A reader budgeting the remaining frontier from these docstrings will over-count the open gates by two."* **Not about ajc-gate's own files** — it is adjacent (`RiemannRoch/Adelic/`).

**Open items directly about ajc-gate / HasRigidPushforward / RigidPushforward\* files:**
- **No OPEN `issue` is directly about the gate.** (The only `issue` matching the regex, I-0319, is the Lean full-build/warning baseline and matches incidentally.)
- Open **conversations** from ajc-gate: **I-0404** "the P^1 chart-ring FREENESS is the shared unlock — and the missing half is next door in the Rebuild project"; **I-0405** "heads-up on one or two NEW modules in the rigid-pushforward cone, and thanks for the rooting".
- Open **memory** with the gate frontier: **I-0381** "AJC B3 gate: the rigid-pushforward frontier, verified (run 0053, task ajc-gate)" — lists L1–L4 as "NOT proved" and records four false claims in the old record (incl. "'HasRigidPushforward feeds seven downstream campaign obligations'. FALSE: zero consumers anywhere in the workspace outside its own declaring file"). **This memory is now partially stale** (L1 and L3 have since been closed; L2 closed earlier) — worth noting, it still reads as if all four are open.
- Related discipline memories, open: I-0397, I-0416, I-0419, I-0380, I-0362, I-0349.

**Open items by kind (total 27):** memory 13, issue 9, conversation 4, protection 1.

## 4. Graph / blueprint

`horizon graph -p Algebraic-Jacobian-Challenge frontier` top 12 (all it emits above the 0-unlock tail) contains **no RigidPushforward node**; the head is Čech / pushforward-quasicoherence blueprint lemmas (`Restricting M~ to D(f)` 108 unlocks, `Sq1 tail` 96, `Sq4b counit reassembly` 91, `Telescope of the reindexed pushforward legs` 84, `Pushforward of quasi-coherent modules is quasi-coherent (Stacks 01XJ)` 82 `[sorry]`, …).

`graph list --match RigidPushforward` returns **26 nodes, all `generated=lean`, none `tex`**. `grep -rl RigidPushforward --include=*.tex` over `blueprint/` returns **nothing** — **no blueprint node pins `HasRigidPushforward` or `RigidPushforward*`**, so there is no `\leanok` to read either way.

Key nodes:
- `f46014f98dda` = `AlgebraicGeometry.Scheme.HasRigidPushforward`, `lean_status=lean_ok`, file `AlgebraicJacobian/Picard/RigidPushforward.lean`. Its own docstring in the node: *"**The B3 gate** (`HasPicScheme` pattern: `Prop` class, **no instances anywhere in the tree** — supplied as a hypothesis by consumers…)"* — node metadata last updated **2026-07-24**, i.e. pre-dates this session.
- `70da789f9d1a` = `AlgebraicGeometry.Adelic.RigidPushforwardGammaBaseChange`, `lean_status=lean_ok`, created 2026-07-27T19:08:27 (synced from the 515e8276a landing). It is a **`def ... : Prop`** — `lean_ok` here means the *statement definition* elaborates, **not** that it is proved.

**Graph verdict: AGREES with "still open."** Caveat: `lean_ok` on `HasRigidPushforward` and on `RigidPushforwardGammaBaseChange` is a *declaration-compiles* flag, not a proof flag, and could easily be misread as "proved" by an automated reader. The graph carries no producer/instance node for the class.

## 5. Ledger

`hgit log --oneline -20 -- .../AlgebraicJacobian/Picard/` (most recent first): `f836f8b61`, `e4a026eb7`, `515e8276a`, `e8fd008df`, `1c12efcaf`, `fd69d363e`, `f40296e11`, `092710c1a`, `e0ea4a6e5`, `f1f780d95`, `aaf812e3c`, …

| commit | trailers | files touched | subject / bold claims |
|---|---|---|---|
| `e8fd008df` | Run 0053 · sess 0004-horizon-ajc-gate · task ajc-gate | **1 file**: `Picard/RigidPushforwardP1ChartRing.lean` (+408) | *"B3 leaf 1: the P1 chart ring is FREE, not just spanned -- (Z[X0,X1]_{Xi})_0 = Z[T]"* · body: *"Sorry-free; lake build … green; #print axioms = [propext, Classical.choice, Quot.sound] on every headline declaration."* |
| `3636b5ea2` | Run 0053 · sess 0004-horizon-ajc-gate · task ajc-gate | **EMPTY COMMIT — zero files** (`--name-status` returns nothing) | *"B3: leaf 1 and leaf 3 of the HasRigidPushforward gate are CLOSED (record commit)"* · body opens: *"Provenance note: the four modules described below were written by this session (run 0053, task ajc-gate) but were swept into the ledger by run 0054's blanket integration commit 515e8276a while still in flight, so they carry ajc-truth's trailers and no mathematical message. Contents in HEAD are byte-identical to what this session built and verified. This commit is the record."* Also: *"RigidPushforwardAffineDescent.lean (441 lines) -- LEAF 4 REDUCED, NOT CLOSED"* and *"All four sorry-free, single-module lake build green, #print axioms clean on every headline."* |
| `e4a026eb7` | Run 0053 · sess 0004-horizon-ajc-gate | **1 file**: `Picard/RigidPushforwardInstance.lean` (+163) | *"B3: the gate's locallyFree field is UNCONDITIONAL; HasRigidPushforward now costs one statement, not four"* · *"That is the classical H0-base-change fact and it is NOT proved anywhere in the tree, so there is deliberately no 'instance : HasRigidPushforward' here. The task stays queued."* · *"Checked that the instance really fires by synthesis with no explicit binder."* |
| `f836f8b61` | Run 0053 · sess 0004-horizon-ajc-gate | **3 files**: `RigidPushforwardAffineDescent.lean` (+49/-1), `RigidPushforwardFrontier.lean` (+53/-…), `RigidPushforwardRank.lean` (+22/-…) | *"audit: repair four overstatements the landed docstrings had already made"* · *"'hsurj is SUBSUMED BY the kerBaseChange bijectivity' was FALSE, and dangerous"* · *"'directly reusable on the C-side' overstated the generality"* · *"Statements, not proofs, change here."* |

**`515e8276a` — confirmed.** Subject: *"workspace[0054 r1] horizon ajc-truth: integrate 0004-horizon-ajc-truth"*, trailers `Archon-Run: 0054`, `Archon-Task: ajc-truth`, `Archon-Commit: integration`, no mathematical body. It **does contain all four gate files**:
- `Picard/RigidPushforwardAffineDescent.lean` +441
- `Picard/RigidPushforwardP1ChartSections.lean` +457
- `Picard/RigidPushforwardP1Topology.lean` +173
- `Picard/RigidPushforwardRank.lean` +619
(plus 30 other paths: `.archon-horizon` session/subagent metadata, `RiemannRoch/Adelic/LedgerClosure.lean` +174, `GGAxioms.lean` +27, `tasks/items/ajc-truth.yaml`).

**So: the four files were authored by run 0053 / ajc-gate but were COMMITTED (swept up) by run 0054's blanket integration `515e8276a`, carrying ajc-truth trailers.** `3636b5ea2` is a zero-diff record commit created afterwards purely to attach the mathematical narrative and the ajc-gate trailers. This is the second occurrence of the pattern — C-0003 records the same hazard for `RigidPushforwardFiberChart.lean` / `RigidPushforwardP1Sheaf.lean` swept up by `f40296e11` (run 0054 r0).

## 6. Uncommitted work

`hgit status --short -- MainProjects/Algebraic-Jacobian-Challenge/` → 111 entries, of which **109 are `hgraph/nodes/*.md`** (28 modified + 81 untracked — routine graph-sync churn, not source).

Only **two non-graph entries**:
- ` M AlgebraicJacobian/RiemannRoch/Adelic/GlobalGeneration.lean` — **not this session's cone**; that is task `ajc-rr` (run 0055), live right now.
- `?? AlgebraicJacobian/Picard/RigidPushforwardChartBaseChange.lean` — **UNCOMMITTED, from this cone.** 151 lines, mtime 19:41 (after the last ajc-gate commit `f836f8b61` at 19:31), **0 sorries**, but it is a stub: module docstring body is literally `placeholder`, and the first theorem `isPushout_appLE_chart` is docstring'd `/-- helper -/`. It is the start of the next-session attack on `RigidPushforwardGammaBaseChange` (imports `RigidPushforwardFiberChart`, matching C-0006's "generalising FiberChart sections 5-7"). It is **not imported by anything** — cf. memory I-0362 ("A NEW MODULE WITH NO IMPORTER LOOKS GREEN AND IS INVISIBLE").

---

### Bottom line for the audit question

Every authoritative surface — task objective, all 6 task comments, both roadmap nodes, the graph node docstrings, and all four commit messages — **agrees that `HasRigidPushforward` is still open with exactly one statement (`Adelic.RigidPushforwardGammaBaseChange`) remaining, and that no `instance : HasRigidPushforward` was written.** No contradicting claim was found anywhere.

Three residual risks worth surfacing:
1. **Attribution:** the four largest gate modules are in ledger HEAD under run 0054/ajc-truth trailers (`515e8276a`), not ajc-gate; only the zero-diff `3636b5ea2` links them to this task.
2. **Stale artifacts that over-state openness:** memory I-0381 still lists all four leaves as "NOT proved"; roadmap title still says "three statements" while its own summary says one.
3. **A misreadable green:** graph `lean_status=lean_ok` on both `HasRigidPushforward` (a class with no instances) and `RigidPushforwardGammaBaseChange` (an unproved `def … : Prop`), plus one untracked, unimported, sorry-free placeholder module `RigidPushforwardChartBaseChange.lean` left on disk.
