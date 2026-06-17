# Iter-037 plan — 01I8 Route B keystone decomposed into the B1–B6 bridge chain (CHURNING corrective)

## Entering state (verified)
iter-036's single lane processed: `QcohTildeSections.lean` +3 axiom-clean local-model bricks
(`tilde_section_isLocalizedModule`, `section_isLocalizedModule_of_isIso_fromTildeΓ`,
`section_isLocalizedModule_of_presentation`). Keystone `qcoh_section_isLocalizedModule` left ABSENT,
blocked on an `.over`→affine base-change bridge. Project sorry = 2 (frozen/superseded). Build green.

## The headline finding
Route B was adopted iter-036 on the premise it AVOIDS the absent-Mathlib base-change walls that killed
Route P. The iter-036 prover + the lean-vs-blueprint-checker `qcohtilde` both surfaced that the
unconditional keystone STILL needs the SAME geometric base-change bridge (`.over`→affine,
`D(g)≅Spec R_g`) that blocked Route P L2 at iter-035. So the pivot's central claim ("Route B needs no
base-change") was an overclaim. This is a strategy-level correctness issue, not just a prover stall.

## Decisions made

### D1 — KEEP Route B; the corrective is to BUILD the bridge (Mathlib-gradient), not pivot again.
progress-critic `iter037` returned **CHURNING** (named keystone absent ×5 iters, 24 helpers accumulated,
0 named-target closures). CHURNING obliges a concrete structural corrective THIS iter, NOT another helper
round. The corrective taken:
- **mathlib-analogist `bridge`** (api-alignment) — the design consult the dispatcher_notes prescribe for a
  design-suspected churn. It (a) confirmed Route B PROCEEDS and is strictly better than Route P (two
  deep-math walls → ONE bounded categorical bridge B3, engine `pushforwardPushforwardEquivalence`, every
  primitive present); (b) decomposed the keystone into a `\uses`-linked chain B0[done]–B6 with B3
  `restrict-over-compat` as the single load-bearing build; (c) found section-comparison is `restrict_obj`-
  `rfl` (free) and presentation-transport rides on `Presentation.map`/`ofIsIso`; (d) **disproved** the
  STRATEGY's hoped `IsLocalizing` shortcut — neither `IsLocalizing` nor `isIso_fromTildeΓ_iff_isLocalizing`
  exists in Mathlib. `analogies/bridge.md`.
- **blueprint-writer `bchain`** rewrote the keystone chapter to specify B1–B4 (to-build blocks), pin the 3
  bricks, add 6 `\mathlibok` anchors, rewrite the keystone proof/`\uses`, and correct the false Route B
  intro ("bypasses base-change … dormant fallback"). **blueprint-clean** + **blueprint-reviewer `bchain`
  → HARD GATE PASS** (fast path), both prover files clear.
- **refactor `wire-import`** wired `QcohRestrictBasicOpen` into the root barrel (its
  `modulesRestrictBasicOpen` is REUSED by B3/B4 — no longer dormant/orphan). Build EXIT 0.

Why not pivot: the base-change bridge is intrinsic to affine-locality of quasi-coherence; EVERY honest
01I8 route hits it. Route P needed it AND two further deep-math walls; Route B needs ONLY it, and its
heavy half (`modulesRestrictBasicOpen`, the geometric module transport) is already DONE. Pivoting would
discard that and re-incur the harder walls. This is the textbook Mathlib-gradient response: build the
absent ingredient project-side, axiom-clean, one bounded lane.

### D2 — This iter's two prover lanes: B2/B3/B4 (`QcohRestrictBasicOpen`) ∥ B1 (`QcohTildeSections`).
The chain splits with NO cross-lane dependency this iter (B1 over-picture extraction ⟂ B2/B3/B4 bridge;
the keystone assembly that joins them lands next iter). Honors the standing parallelism-via-file-splitting
directive. Both mathlib-build, scaffold keyword on each path line (noop-trap guard).

### D3 — Rebuttal to the progress-critic's "iter-038 must escalate to user" forward-constraint.
The critic set: if the keystone does not close THIS iter, iter-038 must escalate to the user rather than
pivot. **I partially reject this.** The standing user directive (2026-05-31, AUTONOMOUS OPERATION) is
explicit: "There is no reason for Archon to escalate to the user. It should always find the best path …
make the correct decision." And the analogist established B3 is bounded (~150–350 LOC, fiddly plumbing,
NO math obstruction) — likely >1 iter on its own. So: if B3 partials at iter-037, the correct iter-038
action is to CONTINUE building B3 (it is a single well-localized lane with a named Mathlib engine), NOT
escalate and NOT pivot. The critic's "escalate" was premised on "no path forward"; the analogist supplies
a concrete path. I keep the critic's real intent — "do not relabel-and-rerun the same wall" — which is
satisfied: B3 is a sharply different, named target, not the keystone-retry. Reversal signal: if B3 reveals
a genuinely-absent Mathlib primitive (no `pushforwardPushforwardEquivalence` instantiation possible),
THEN re-open the route question.

## Soundness check (before spending bridge budget)
Did a cheap disprove pass on the keystone statement: it is exactly Stacks 01HV(4) generalized from `~M`
to qcoh `F` (sections over `D(f)` = localization), TRUE for any qcoh sheaf; the brick
`tilde_section_isLocalizedModule` already proves the `~M` case axiom-clean. No counterexample. The
non-circularity pitfall (per-piece identification via tilde RIGHT-exactness, not left-exact `Γ` of a
cokernel) is preserved in the rewritten sketch and reinforced by Mathlib's own
`isIso_fromTildeΓ_of_presentation` (strategy-critic confirmed). Budget justified.

## Subagent dispatches this iter
- progress-critic `iter037` → CHURNING (acted on, see D1/D3).
- mathlib-analogist `bridge` (api-alignment) → PROCEED + B0–B6 decomposition (`analogies/bridge.md`).
- blueprint-writer `bchain` → keystone chapter rewritten (B1–B4 + 3 brick pins + 6 `\mathlibok`).
- blueprint-clean `bchain` → Route B section clean + 7 pre-existing drift fixes.
- blueprint-reviewer `bchain` → HARD GATE PASS (both prover files clear; 3 soon-fixes deferred to iter-038).
- strategy-critic `iter037` → SOUND (fixed 2 format-DRIFT must-fix: per-iter narrative + "Route B" name
  collision → renamed rejected spectral route to "Route SS").
- refactor `wire-import` → root-barrel import of QcohRestrictBasicOpen; build EXIT 0.

## STRATEGY edits
01I8 phase row (iters ~2–4, B3 load-bearing lane named); `### 01I8` route subsection fully rewritten to
the B0–B6 chain (corrected "needs none" overclaim; removed false `IsLocalizing` leverage; noted
`modulesRestrictBasicOpen` reused / QcohRestrictBasicOpen NOT dormant); Open-questions + Mathlib-gaps 01I8
lines updated; "Route B" spectral-sequence collision renamed "Route SS".

## Subagent skips
- lean-vs-blueprint-checker: review-phase subagent, not a plan-phase dispatch (its iter-036 report was
  consumed this phase to drive the blueprint fixes).
