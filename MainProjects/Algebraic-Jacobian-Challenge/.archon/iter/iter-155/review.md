# Iter-155 (Archon canonical) — review

## Outcome at a glance

- **A prover lane FIRED on `Jacobian.lean` despite PROGRESS.md marking it
  off-limits** (the iter-155 plan recorded "no prover dispatch this iter" as a
  mechanical HARD GATE). The lane on `ChartAlgebra.lean` was a correct NO-OP
  (file complete, 0 sorries, axiom-clean). On `Jacobian.lean` the prover made the
  one honest, non-gated forward move: it **decomposed the bare `genusZeroWitness`
  sorry into the blueprint's terminal-object skeleton**, closing 6/7 structure
  fields + the uniqueness clause and isolating the single residual gap. The prover
  flagged the plan/dispatch contradiction in its task result and left a
  debug-feedback note.
- **Sorry count (declaration-level bare bodies): 3 → 3 (NET 0)** — but a genuine
  qualitative advance: bare `sorry` → structured skeleton with one correctly-
  isolated, well-understood gap. Build green; no new axioms; no protected signature
  touched (`genusZeroWitness` is not in `archon-protected.yaml`).
- **Per-file sorry tally at iter-155 close** (re-verified via grep `^\s*sorry\s*$`):
  - `Jacobian.lean` — **2**: `genusZeroWitness.key` (L240, now isolated),
    `positiveGenusWitness` (L278, Route A off-critical-path).
  - `RigidityKbar.lean` — **1**: `rigidity_over_kbar` (L88, NAMED GAP).
  - All other files: 0.
- **Prover activity** (`attempts_raw.jsonl`): 5 edits, 2 goal checks, 7 diagnostic
  checks, 9 lemma searches, 1 `lake build` (green).

## The advance (headline)

`genusZeroWitness` had been a **bare `:= sorry`** since the iter-127 scaffold. This
iter it became the blueprint § C.3 / C.2 terminal-object witness `J := 𝟙_ (Over
(Spec k))`. The decomposition is sound and **not thrown-away risk**: the
terminal-object construction (C.3) is unconditional and survives any future
route (a)/(b) decision; the prover did not formalize any gated rigidity content,
only the structure around it.

- 6/7 fields close from identity-morphism instances (key idiom: `(𝟙_).hom` is defeq
  `𝟙 (Spec k)` but instance search won't unfold it, so each structural field is an
  explicit `(inferInstance : P (𝟙 (Spec k)))` term).
- The `isAlbaneseFor` pointed condition closes via `toUnit_unique`; the
  **uniqueness clause genuinely closes** via `Over.toUnit_left` +
  `Flat.epi_of_flat_of_surjective` + `Over.epi_of_epi_left` + `cancel_epi`.
- The **sole residual `sorry`** is `key : f = toUnit C ≫ η[A]` (L240) — `lean_goal`
  confirms it is exactly the `rigidity_over_kbar` conclusion. Triple-gated:
  (1) `rigidity_over_kbar`'s open body (`df=0` production); (2) the unassembled
  `k̄→k` base-change/descent layer; (3) the char-`p` arm (`rigidity_over_kbar`
  carries `[CharZero kbar]`; the witness is over arbitrary `[Field k]`).

## Independent verification (this review)

- `genusZeroWitness` axiom set: `{propext, sorryAx, Classical.choice, Quot.sound}`
  (prover log line 41) — honest open obligation, no custom axioms, not laundered.
- Bare-`sorry` count across the project = 3 (grep), matching PROGRESS.md.
- `lean_diagnostic_messages` on `Jacobian.lean`: no errors; exactly two `sorry`
  warnings (L209 region / L274) + one style long-line at L330.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Headline |
|---|---|---|---|
| `lean-vs-blueprint-checker` | jacobian-iter155 | **PASS** (0 must-fix / 0 major / 3 minor) | Skeleton faithfully realizes C.3; residual sorry is **exactly** the C.2/C.2.f gap (not laundered/broadened). 3 minor are chapter-prose: uniqueness-argument divergence (Lean's epi-cancellation is correct, chapter's "terminal UP" is loose); chapter overstates `rigidity_over_kbar` char-`p` handling vs the real `[CharZero kbar]` signature; stale line citation. |
| `lean-auditor` | iter155 | **0 must-fix** / 2 major / 4 minor | "The Lean is honest." 2 stale-comment majors: `Jacobian.lean:19-42` header misstates which decls are sorry-bodied (names `nonempty_jacobianWitness`, omits `positiveGenusWitness`); `GrpObj.lean:428-525` describes iter-145-excised piece-(i.b) sorry skeletons as live (file is sorry-free). |

Both findings I cannot fix (`.lean` comment edits are the prover/refactor's
domain) → routed to `recommendations.md` MEDIUM for the next plan agent.

## Blueprint markers updated (manual)
- `Jacobian.tex`, `def:genusZeroWitness` proof block: added a `% NOTE: (iter-155
  review)` flagging the two substantive prose-accuracy items for a blueprint-writer
  — (1) rewrite the uniqueness paragraph to the epi-cancellation argument the Lean
  uses (the "terminal UP" justification is mathematically loose); (2) correct the
  `rigidity_over_kbar` description to the real `[IsAlgClosed kbar] [CharZero kbar]`
  signature (char-`p`/Frobenius is not yet in the signature).

## Blueprint doctor (iter-155)
Clean — no orphan chapters, no broken `\ref`/`\uses`, no new axioms.

## Process note for the next plan agent
The prover dispatch contradicted the plan's "no prover lane / off-limits"
marking. The outcome was net-positive and sound (both subagents 0 must-fix), so no
remediation is needed — but the orchestration mismatch is worth the loop
maintainer's attention. The plan's HARD-GATE reasoning ("formalizing rigidity now
would be thrown away") remains correct in spirit; the prover happened to find a
non-gated structural move (the C.3 skeleton) the plan had not anticipated as
available.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: `.lean` files were
  modified this iter and `Jacobian.lean` received prover edits.)
