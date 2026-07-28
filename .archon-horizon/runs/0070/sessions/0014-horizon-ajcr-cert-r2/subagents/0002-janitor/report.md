All writes verified on disk. Delta report follows.

## Summary

Your two roadmap mismatch warnings are **both intentional and both already escalated** — I fixed neither, and fixing either would have been wrong. The armed-deletion check found a live instance whose cause is **not** the I-0656 hazard and which no standard repair can clear. One item archived, four comments posted, one new issue filed.

## 1. Roadmap status mismatches — do not fix, and not mine to fix

Both rows are `AJC.*`, the **sibling project**, not AJCR. Neither is held by a live lane (only `ajc-truth`, currently *queued*, references any picrep row). I changed nothing; both remain `pending`/`done` as found.

- **`AJC.jacobian.assembly`** (`pending`, 1/1 child done) — its own summary says: *"THIS ITEM STAYS OPEN WITH ITS ONLY CHILD DONE — that status mismatch is deliberate and must not be 'fixed'. The parent is the assembly step, not a container."* It rests on five named open obligations (`fgaPicardRepresentability`, `Pic0Et.geometricallyReduced`, `Pic0Et.universallyClosed`, and the two headline leaves). Legitimate: a parent that is real work, not a rollup.
- **`AJC.picrep`** (`done`, child `.tensor` `pending`) — genuine inconsistency, but a **known and escalated** one carrying an explicit `STATUS MISMATCH, KNOWN AND ESCALATED — DO NOT RE-TRIAGE` block. Per I-0543 the `done` was never a decision: it propagated automatically from task `ajc-etale-pic`'s terminal status into all four of its `roadmap_refs` at 2026-07-28T06:04:16. Five prior passes converged on a reading that *splits* the children (`.quot`/`.serre` self-declare "OFF-PATH, retained not revived"; `.tensor` is a live input to Hilbert-function base change and is the only evidence the parent is premature). It sits with the human as **I-0605**, still `open` with **zero comments**.

I-0605 is addressed to `human`, so my CLI rejects it (`I-0605 is not addressed to this team`) — I read it from the store. Its named blocker is real: its only addressee, task `ajc-etale-pic`, is itself `done` and cannot answer. Nothing to add; the wait is on the human.

## 2. Inbox — one archive, three verdicts

- **I-0675 → ARCHIVED** (comment C-0001). Verified independently, and its distrust was vindicated: two of four modules carried real errors. Commit `30156557d` is real and an ancestor of HEAD. One qualification I kept in the record rather than smoothing over: the rooted `lake build` this item demanded **never completed**, and three of the four modules still have **no oleans** in `.lake`. Your evidence is the scratch-tree `lean -o` check — faithful for those modules, but the shared oleans stay unpopulated.
- **I-0674 → STAYS OPEN**, narrowed (C-0002). Its **body** defect is fixed: §9.1 now lists `DivRepGlobalAffLift.lean` with all four declarations, §9.4 is marked "CORRECTED IN PLACE", and the `grep -c` it cites as 0 returns **12**. But the defect raised in its own **C-0001** is untouched at all three sites — `DivisorFamilyAffFunctorCompare.lean:35`, `DivRepGlobalAffLift.lean:36`, `spec-dd-r.md:1513` still assert no converse "can exist". ADDENDUM 10 §10.2 quotes the neighbouring converse-is-FALSE prose while proving strictness but never retracts it. Non-surjectivity of `DivFamZar.toAff` refutes a **section**, not the existence of some `divFunctorAff ⟹ divFunctor`. Lean source plus binding spec, so filed not fixed.
- **I-0668 → your completion was CORRECT.** Both cited sites carry the corrected reading, and both cited lemmas exist as real declarations (`ovlColengthDiagEquiv` at `AffGlue.lean:243`, `isCertified_of_swallowedBy_of_c1` at `:318`).
- **I-0565, I-0667, all protections → untouched**, as instructed.
- **I-0676 → comment**, its rule was applied this session. **I-0641 → count delta only** per I-0556.

## 3. Ledger — a live armed deletion, and the cause is new

`scripts/partition-probe.lean` was armed (index entry absent, HEAD and worktree both at blob `5ea807c6d`). Your other four paths cross clean. **The I-0656 repair does not work here**: the file matches `*probe*.lean` at `AJCR/.gitignore:26`, so `git add` refuses it and the deletion stays armed permanently, re-arming after every foreign sweep — twice already this session. I did **not** force it; a forced add re-lands a file the project deliberately untracks.

HEAD also moved twice during my pass: `2d735cdcf` restored your `DivRepGlobalAffLift` fix (the I-0690 mechanism, confirmed — commit `30156557d`'s diff was `d126882c9..d2391464e` while HEAD carried the *pre-fix* blob), then `cd23b44d7` restored the probe after `ajc-rr`'s clobber. All six paths including `spec-dd-r.md` are now byte-identical to HEAD.

**Filed I-0692**: binding spec ADDENDUM 10 §10.3 cites a path git is configured never to track. The `.gitignore` prescribes the fix itself at lines 22-24 (move under `AlgebraicJacobian/` and root it; do not rename to dodge). Note `scripts/` is not ignored — only the `*probe*` pattern — and AJC tracks nine `scripts/*.lean` files fine. Owner's call between rooting it or amending §10.3 to quote the table so the evidence survives without the file. Also added the exception to **I-0656** (run `git check-ignore -v` before reaching for `-f`).

## 4. I-0667 measurement — added

Comment C-0001 records the declaration-level closure table (four widened endpoints at zero `FinCoverData` dependency, two controls firing) alongside the file-level count, with the neutral framing you asked for: the 49-file figures stand, the claim is only that the 33 hits do not gate the widened route. I verified all six probe endpoints exist before citing them, and the probe is sound — it has a control, and its docstring records the calibration failure (a structure field is not a constant a proof term mentions) that would otherwise have made it vacuous.

## Counts, before → after

| | before | after |
|---|---|---|
| Team-visible open non-protection | 95 | 95 |
| Global store open non-protection | 130 | 131 |
| Open memory | 65 | 65 |
| Roadmap active | 18 | 18 |
| Armed deletions over your paths | 1 | 1 (unclearable, I-0692) |

Net zero: I archived one and filed one. Worth knowing for future passes — the CLI warning reports the **team-visible** set (95) while the store holds **131**; a pass quoting one and a pass quoting the other will look like a 36-item discrepancy when nothing moved. I noted this on I-0641. All three warnings you listed still fire and all three are expected: two have standing answers (I-0509, I-0641/I-0551), and the two mismatches are documented in-row as deliberate pending I-0605.

One CLI note: `inbox comment` takes `--author`, not `--agent` (unlike `inbox add`), and caps agent comments at 1200 characters. A rejected comment prints nothing on success paths, so read back the comments directory rather than trusting the exit — I nearly logged a rejected I-0674 comment as landed.
