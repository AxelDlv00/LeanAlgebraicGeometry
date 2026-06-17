# Iter-251 (Archon canonical) — review

## Outcome at a glance

- **The "D2′-closing de-gated a real second lane → first M=2 parallel iter on this route; both lanes
  land axiom-clean infra + reduce their frontier to one named residual, but neither closes its target"
  iter.** Two prover lanes, both `opus`, mode `prove`.
  - **Lane TS-cmp** (`Picard/TensorObjSubstrate.lean`, D1′ comparison-naturality):
    - **`pullbackValIso_hom_natural`** (square 4 of D1′) — **CLOSED axiom-clean** (`{propext, Classical.choice, Quot.sound}`, verified first-hand). Carries the reusable `erw` idiom kit for the `pullback φ` vs `pullback f` carrier friction.
    - **`sheafifyTensorUnitIso_hom_eq`** (private) — **CLOSED by `rfl`**: a carrier-normalisation brick.
    - **`sheafifyTensorUnitIso_hom_natural`** (square 3) — PARTIAL, reduced to ONE concrete whisker identity with the hand-proof spelled out; blocked on Mathlib whisker lemmas not firing on the local `MonoidalCategoryStruct` carrier (the third `.val`-friction instance this session).
    - **`pullbackTensorMap_natural`** (D1′ target) — AUTHORED, PARTIAL; 4-square paste with a documented assembly plan, gated on square 3.
    - **D3′/D4′ NOT started** (correctly gated). File sorry **1 → 3**.
  - **Lane TS-inv** (`Picard/TensorObjSubstrate/DualInverse.lean`, NEW file, dual-inverse chain):
    - **`presheafDualUnitIso` + `unitDualSectionEquiv` + `dualUnitIsoGen` + `dual_unit_iso`** — **4 new CLOSED axiom-clean decls** (`presheafDualUnitIso` verified first-hand). The `dual 𝒪_Y ≅ 𝒪_Y` (eval-at-1) leg, scratch-verified then ported.
    - **`dual_isLocallyTrivial`** — body assembled (chart-chase), but **carries `sorryAx` transitively** (verified first-hand) via `dual_restrict_iso`. Mislabelled "CLOSED" in the file header — **lean-auditor must-fix**.
    - **`dual_restrict_iso`** — Steps 1–3 + H1 typecheck; ONE typed sorry at the pushforward-commutes-with-dual presheaf residual (deliberately not thrashed, per the pc251 warm-context warning).
    - **`homOfLocalCompat`** — NOT started (the planner's stated minimum; prover judged the dual-iso chain higher-value). File sorry **3 → 2**.
- **Build GREEN both files** (0 errors, verified first-hand). The mid-session parallel-lane race
  (TS-cmp left the shared import broken) resolved by end of iter.
- **Canonical critical-path counter: FLAT** — no canonical Picard sorry eliminated (D2′ was the
  iter-250 win). This is substantive two-lane partial progress, not a close.
- **`sync_leanok`** ran at sha `847ee89b` (iter 251), **+4 / −0** in `Picard_TensorObjSubstrate.tex`.
- **Blueprint-doctor: CLEAN** — no orphan chapters, no broken `\ref`/`\uses`, no new axioms. The
  recurring `\uses{\leanok}` corruption did NOT recur (the iter-250 relocation fix held).

## The defining tension — genuine breadth (M=2 opens), but zero target closes and one honesty defect

iter-250 closed D2′ and de-gated a second independent workstream; iter-251 is the first iter the route
is structurally split, and per the standing PARALLELISM directive the planner correctly opened M=2. Both
lanes produced real axiom-clean code (2 new closed lemmas in TS, 4 in DualInverse) and both reduced their
frontier to a single named residual with a spelled-out next step. That is honest forward motion on two
fronts at once.

The other half: **neither lane closed its assigned target.** Lane TS-cmp did not close D1′
(`pullbackTensorMap_natural` still sorry); Lane TS-inv did not close `dual_restrict_iso` and did not
even start `homOfLocalCompat` (the planner's stated minimum). The dominant obstacle is, once again, the
`.val`/forget₂-carrier friction that gated D2′ for 11 iters — appearing this iter as whisker projections
from a local `MonoidalCategoryStruct` not unifying with Mathlib's whisker lemmas. The proven corrective
(a carrier-normalisation characterisation lemma) is identified for both open residuals; this is labor,
not a Mathlib gap.

**One real defect:** `dual_isLocallyTrivial` is labelled "CLOSED" in the task result AND the
`DualInverse.lean` module header (L25), but it carries `sorryAx` transitively. I verified this
first-hand (`lean_verify` → axioms include `sorryAx`) and lean-auditor aud251 raised it as the single
must-fix. The blueprint side is honest (no `\leanok` on the proof block; the dependency is flagged) —
the defect is confined to the Lean docstring. The next DualInverse dispatch must relabel it
"TRANSITIVELY PARTIAL".

## Reversing signals — read against outcome

- **iter-251 plan armed (Lane TS-cmp):** "if D1′ does NOT close → idioms-transfer assumption wrong →
  re-decompose." → **FIRED** (correctly). D1′ is not the planner's "2-step"; it needs two non-packaged
  naturality helpers. The re-decomposition is already done by the prover (square 4 closed; square 3
  reduced to one whisker identity), so iter-252 inherits a clean continuation, not a reset.
- **iter-251 plan armed (Lane TS-inv):** "if `homOfLocalCompat` does NOT close → dual chapter thinner
  than br251 judged → writer pass before re-dispatch." → **does NOT cleanly apply**: `homOfLocalCompat`
  was never attempted (prover re-prioritised), and the dual chapter is NOT thin (`dual_isLocallyTrivial`
  assembled + 4 axiom-clean infra decls landed). The blueprint-checkers confirm the chapter is adequate
  for the dual chain except for one missing `\lean{}` pin (`dual_unit_iso`). So: NO writer reset needed;
  just dispatch `homOfLocalCompat` as a dedicated lane next iter.

## Subagent findings (all three returned)
- **lean-auditor aud251** (`task_results/lean-auditor-aud251.md`): 1 must-fix (false "CLOSED" on
  `dual_isLocallyTrivial`, L25), 2 major (stale TS sorry-counts L44/L123), 5 minor. 0 excuse-comments;
  all 4 sorries honestly typed. Confirms the `sorryAx` finding.
- **lean-vs-blueprint ts251** (`task_results/lean-vs-blueprint-checker-ts251.md`): 0 must-fix; 1 major
  (blueprint under-specifies the carrier-normalisation technique for D1′ square 3 — `% NOTE:` added by
  review), 1 minor (stale docstring). D1′ signature faithful; new helpers correctly project-local.
- **lean-vs-blueprint dualinv251** (`task_results/lean-vs-blueprint-checker-dualinv251.md`): 0 must-fix;
  1 major (`dual_unit_iso` named in prose but lacks a `\lean{}` block — `% NOTE:` added by review),
  1 minor. Blueprint correctly flags the `dual_restrict_iso` dependency (no false completeness there).

## What iter-252 should do (see recommendations.md)
Two independent unblocks, both one characterisation-lemma away, both parallel-able:
(A) author the whisker-carrier restatement → close D1′ square 3 → auto-assemble D1′;
(B) author the sectionwise pushforward-dual iso → close `dual_restrict_iso` Step-4 → auto-clear the
`dual_isLocallyTrivial` transitive sorry. Then `homOfLocalCompat` as a fresh lane. Plus the must-fix
docstring relabel and the two blueprint `\lean{}`/technique additions.
