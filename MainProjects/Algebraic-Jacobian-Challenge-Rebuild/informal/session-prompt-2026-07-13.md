# Session goal — `rebuild` task, launched 2026-07-13

You are continuing the `rebuild` task on `MainProjects/Algebraic-Jacobian-Challenge-Rebuild`
(workspace root `/home/axel/LeanAlgebraicGeometry-Horizon`). The task objective
(`horizon task show rebuild`) plus its comments is the binding charter; this prompt is the
session goal and the authoritative state map (it supersedes the "next actions" of the
2026-07-12 handoff, which was written before ζ2·i was started).

## Session goal

Close **(C1) — `PicEtAff.unit_injective`** (Kleiman 2.5(1), étale separatedness of the
one-step-plus construction), kernel-green and axiom-clean, committed brick-by-brick with
blueprint nodes. Pipeline: **triage & finish the in-flight ζ2·i → ζ2·ii → ζ3 → unfold to
(C1)**. Stretch goals, only once (C1) is committed: the sheaf-on-affines corollary of (C1)
and the start of Layer-2 `picEt` (per inbox I-0140: Separatedness/sheaf-corollary file
BEFORE the `picEt` file), then the (C2) rigidification statement and the degree/Pic⁰
interface (design §6).

## Read first (in order)

1. `informal/session-handoff-2026-07-12.md` — operating model, verification gotchas, key
   API map for spec-writing (its "state" section is one brick stale; trust this prompt).
2. `informal/c1-etale-separatedness-assembly.md` — the **binding** (C1) worksheet:
   the ζ1/ζ2·P/ζ2·i/ζ2·ii/ζ3 route ("global-unit correction"), with landed inventory.
3. `informal/wave3-picard-design.md` — the Wave-3 design (§4.4 ledger, §9 OPEN-1).
4. Task comments C-0020..C-0022 (`horizon task show rebuild`) and inbox item I-0140.

## Exact current state (verified 2026-07-13)

- Committed, kernel-green, axiom-clean through **ζ2·P**: ledger head for this project is
  `536d96beb` (blueprint: 26 nodes for the six landed (C1)-campaign bricks β, γ, ε1, ε2,
  ζ1, ζ2·P); the last code brick is `cdec81f29` (`Picard/AmitsurCochain.lean`, the ζ2·P
  Amitsur toolkit), with the handoff-doc commit `b56feae18` in between.
- **In flight — UNCOMMITTED** (written late 2026-07-12, never kernel-verified end-to-end,
  build state unknown):
  - `AlgebraicJacobian/Picard/CoherentWitness.lean` — the `CoherentCechWitness` structure
    (witness cochain on a cover of `Spec (B ⊗[A] B)` refining both coprojection pullbacks,
    coboundary relation against `q₁^♯γ / q₂^♯γ`, Amitsur coherence over the triple tensor)
    plus the `amitsurCover` machinery. 0 sorries in the file. NOT yet imported by the
    aggregator `AlgebraicJacobian.lean`.
  - `AlgebraicJacobian/Picard/CoherentWitnessExists.lean` — ζ2·i,
    `Over.exists_coherentCechWitness` (523 lines — **over the 500-line cap; split it
    before committing**, e.g. factor the private telescope/assembly lemmas into a helper
    file): the global-unit-correction argument. **ONE `sorry` remains, at line 521 — the
    final goal of the theorem** after the landed `have` chain (θ₀ extraction, ω̄ gluing,
    ψ/χ descent, the hLHS/hR₂₃/hR₁₂/hR₁₃ telescope identities): assembling the corrected
    witness `θ := θ₀ / χ` into the `CoherentCechWitness` structure (witness relation
    survives division by a global unit; Amitsur defect becomes `ω̄ / ∂_Am(χ) = 1`). Its
    imports resolve against the committed ζ2·P toolkit, so the LSP check should surface
    only this sorry. NOT yet imported by the aggregator.
  - `blueprint/src/chapters/PicardEtale.tex` — **modified, uncommitted**: two new
    `\leanok` lemma nodes for the β FF-bookkeeping (`lem:awayCover_span_range_baseChange`,
    `lem:awayCover_faithfullyFlat_tensor`) and a `\uses` edit to
    `thm:awayCover_pic_baseChange`. Reconcile and commit (or discard) this deliberately —
    otherwise your next `horizon commit` sweeps it in silently.
- `Picard/EtaleSeparatedness.lean` already exists and is imported by the aggregator: ζ1
  (`Over.cechPicMap_tensorInl_eq_tensorInr`) is landed there; the (C1) target
  `PicEtAff.unit_injective` appears only as docstring text — nothing is pre-stubbed, you
  will write the actual theorem there in step 4.
- Sorry census of the whole tree: the protected `Challenge.lean` targets (13 declarations
  — frozen, they close only at the end) + this single ζ2·i sorry. **Zero other
  infrastructure sorries.**

## First actions (mandatory order)

0. **Verify the baseline**: root `lake build` (expected green — the aggregator does not
   import the two in-flight files yet), then LSP-check both in-flight files
   (`lean_diagnostic_messages`); repair any breakage before writing anything new.
1. **Finish ζ2·i**: close the final assembly sorry of `Over.exists_coherentCechWitness`,
   and split `CoherentWitnessExists.lean` under the 500-line cap. Then add the files to
   the aggregator, root `lake build`, `lean_verify` the theorem (axioms exactly
   `[propext, Classical.choice, Quot.sound]`), commit (folding in the reconciled
   `PicardEtale.tex` edit), blueprint node(s) in the `PicardEtale` chapter, task comment.
2. **ζ2·ii (pi-assembly)** — per the worksheet: from the coherent witness `θ'` and the
   trivializations of a basic cover `f : ι → B` of `N`, build the components
   `v_{ij} ∈ (S_i ⊗[A] S_j)ˣ` (note `S_i ⊗[A] S_j` is the section ring of the basic open
   `D((r_i⊗1)(1⊗r_j))` of `Spec (B ⊗[A] B)`), prove `Module.IsDescentCocycle v` from
   θ'-coherence + telescoping via pi-ext, and `tensorCollapse v = cocycleUnit c` on the
   diagonal. Pure algebra + section rings, in the `LocalizationCocycle*` idiom.
3. **ζ3 (close)** — `M := cechPicEquivPic.symm (picClass v)` over `A`; prove
   `p_A^* M = L` by the mk/unitsRes calculus + ε1 (the fppf `descend_coboundary`
   analogue; decide at spec time whether the construction can make the equality
   by-construction-cohomologous, per the handoff's design note).
4. **(C1)**: unfold to `PicEtAff.unit_injective` in `Picard/EtaleSeparatedness.lean` via
   `injective_iff_map_eq_one` + `mk_eq_mk_iff` + the `relPicMk` calculus. Blueprint
   nodes, update inbox I-0140, milestone task comment.
5. **Stretch** (only after (C1) is committed): the one-plus Zariski-sheaf-on-affines
   corollary, then Layer-2 `picEt` per I-0140's resolution; (C2) rigidification
   statement; degree/Pic⁰ interface.

## Operating rules (binding — from the charter + the user's standing instructions)

- **Model tiering / budget discipline**: the main (Fable) loop is ONLY for route/design
  decisions, brick specs, verifying delegated work, and commits. Delegate ALL Lean
  implementation to subagents — **Opus** for hard proofs, **Sonnet** for recon, blueprint
  prose, and mechanical work. One detailed spec per brick, containing: exact deliverable
  signatures, files to READ FIRST, proof-route sketch, verification protocol (in the
  FOREGROUND — if an agent stalls on a background monitor, resume it with "finish
  verification in foreground now"), fallback instructions, and the required final-message
  format. Blueprint work goes to Opus agents/workflows. Never delegate a change to a
  frozen `Challenge.lean` signature.
- **Verification is non-negotiable**: every brick kernel-green (target build AND root
  `lake build AlgebraicJacobian`) and axiom-clean. Use the lean-lsp MCP for tight
  feedback; use `lean_verify` for axiom audits — `lake env lean` scratch files get
  OOM-killed on this box. Independently spot-verify agents' claims before committing.
- **Frozen surface**: `Challenge.lean` signatures are archon-protected — discharge by
  infrastructure, never weaken/restate. The old draft
  `MainProjects/Algebraic-Jacobian-Challenge` is READ-ONLY: consult for lessons when
  genuinely blocked, never copy code.
- **Toolchain pinned**: Lean/mathlib v4.31.0 — no bumps. Mathlib-first: search before
  proving (`horizon search`, LeanSearch/Loogle/leanfinder MCP tools); missing
  infrastructure is built generalizable, mathlib naming/quality, files ≤ 500 lines.
- **Blueprint** (blueprint-conventions skill): pure mathematical prose — no Lean
  vocabulary; complete proofs, not sketches; correct `\uses{}` dependencies; one
  `\lean{}` anchor per node; `\leanok` only after a kernel check; `\source{}` only after
  actually reading the cited passage in `references/` (references skill; retrieve/
  transcribe via the reference-retriever agent if a needed source is missing).
- **Commits**: per brick, `horizon commit -m "<math-first message>" <files>` run from the
  workspace root; task comments at milestones (`--author horizon`); keep the project
  README current when a wave-level item closes (the workspace-root roadmap is OUTSIDE
  this task's write set — record milestone facts in task comments instead).
- **Gotchas**: `grep -c sorry` exits 1 on zero matches (don't `&&`-chain it); parallel
  agents editing the aggregator import list must re-read it on staleness and re-apply
  only their own line; the horizon CLI must run with cwd inside the workspace (note the
  2026-07-12 handoff cites a stale binary path and a wrong-case root — the workspace root
  is `/home/axel/LeanAlgebraicGeometry-Horizon` and `horizon` is on PATH).

## Definition of done for this session

(C1) `PicEtAff.unit_injective` proved, kernel-green, axiom-clean, committed, with
blueprint nodes for every landed brick and I-0140 updated — or, if a genuine mathematical
obstruction surfaces, a precise worksheet update + inbox issue recording the obstruction
and the corrected route, with everything landed so far committed and green. Leave a fresh
session handoff in `informal/` if substantial designed-but-unlanded work remains. At
session end, set the task status explicitly (`horizon task set rebuild <status>` per the
task-status skill) — a clean exit alone leaves the task `queued`; the task stays open
(`queued`) until the full extended challenge is discharged, so after a productive partial
session `queued` plus a milestone comment is the normal terminal state.
