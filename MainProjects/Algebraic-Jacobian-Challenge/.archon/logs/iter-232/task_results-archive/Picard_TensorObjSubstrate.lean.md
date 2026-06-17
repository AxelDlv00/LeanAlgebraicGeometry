# Picard/TensorObjSubstrate.lean — iter-231 prover log

## Assigned objective (HARD OUTCOME GATE)
PASS = (a) project sorry 80→79 (`exists_tensorObj_inverse` closed), OR
(b) `AlgebraicGeometry.Scheme.Modules.dual_restrict_iso` lands **axiom-clean**.
Pinning a NEW sorry is FORBIDDEN this iter.

## File state verified this session
- The file COMPILES. `lean_diagnostic_messages` (severity=error) returns `[]`.
- Exactly 3 code sorries (all pre-existing):
  - **L691** `isLocallyInjective_whiskerLeft_of_W` — FORBIDDEN this iter (vestigial d.2).
  - **L2210** `exists_tensorObj_inverse` — gate target (a).
  - **L2256** `addCommGroup_via_tensorObj` — FORBIDDEN (RPF consumer).
- `dual_restrict_iso` does NOT exist as a declaration yet (gate target (b) = build it).
- Remaining diagnostics are warnings only: `declaration uses sorry` ×3, the 14 `Sheaf.val`
  deprecations (deferred polish), long-line/unused-var style lints.

## Tooling note (for the planner)
The harness exhibited **severe one-batch-behind tool-result latency** this session (the exact
"intermittent harness display fault" PROGRESS.md flagged for iter-231): the first ~16 calls
flushed together in one delayed burst, then subsequent calls' results arrived only on later
turns, in large batched flushes. All tools (Read, Bash, `lean_diagnostic_messages`, Grep)
ultimately WORK and return correct output — but the round-trip latency makes a tight
read→edit→`lean_goal`/`lean_multi_attempt`→verify loop (which a 150–300 LOC categorical build
requires) very expensive, and it consumed most of the effective budget just to read the file.

## Why the gate was not met — precise, not "it's hard"
The gate deliverable `dual_restrict_iso` mirrors the CLOSED `tensorObj_restrict_iso`
(L1941–2018): Steps 1–3 (`restrictFunctorIsoPullback`, `sheafificationCompPullback`, strip
outer sheafification) + Step-4 H1 (`pushforwardPushforwardAdj`∘`leftAdjointUniq`) transfer
verbatim (the in-file iter-230 diagnostic at L2118–2161 confirms they TYPECHECK), leaving the
residual presheaf goal:

  `(PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)
      ≅ PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)`

**Key asymmetry vs the tensor case:** for `tensorObj_restrict_iso` the analogous Step-4 residual
(`pushforward β` commutes with `⊗ₚ`) was discharged CHEAPLY by Mathlib-adjacent machinery —
`restrictScalarsMonoidalOfBijective` + `pushforward₀OfCommRingCat.Monoidal` give the tensorator
`μIso` in ~5 lines (L2012–2018). **There is NO analogous packaged "dual commutes with
pushforward".** `PresheafOfModules.dual` is the project's bespoke slice/end internal-hom
(`internalHom(-, 𝟙_)`, value over `Over W`), with no Mathlib API relating it to
`pushforward`/`pullback`. So the residual is the genuine new build the analyst/blueprint-clean
sized at ~150–300 LOC: a PRESHEAF-level, `𝒪_Y(V)`-linear slice comparison
`Hom_{Over_X (fV)}(restr (fV) A, restr (fV) 𝟙_X) ≅ Hom_{Over_Y V}(restr V (pushforward β A), restr V 𝟙_Y)`,
induced by the per-`V` slice equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)` (per-`V` shadow
of `Opens.overEquivalence`) + ring-iso transport `β = f.appIso`, with real `Over.map`
pseudofunctor-coherence risk (thinness does NOT trivialise it here — the slice presheaves carry
the module structure). This is precisely what iters 227–230 failed to close.

Under (a) the one-batch-behind tool latency and (b) the context already largely spent reading
the 2375-line frontier file, this build cannot be authored AND verified axiom-clean in one
session. Because pinning a partial `dual_restrict_iso` with a `sorry` at the residual is
explicitly FORBIDDEN this iter, the only allowed gate-pass is the fully verified build — which
is not reachable this session. I therefore did NOT edit the (currently compiling) file:
shipping unverifiable ~200 LOC into a frontier proof would risk breaking the green build with
no way to detect it under this latency.

## Summary
- Sorry count: **80 → 80** (unchanged). No code edited.
- Sorries closed: none. Sorries open: L691 (forbidden), L2210 (gate target — blocked),
  L2256 (forbidden).
- Adjacent sorries: none attempted (L691/L2256 forbidden; L2210 is the assigned one).

## Why I stopped — honest verdict
`Infrastructure missing` is NOT the right label (the Mathlib gap is real but the true blocker
this session was build-size × tool latency, not a newly-discovered missing ingredient).
Most accurate: **the gate's only legal pass is a full ~150–300 LOC verified build that has
resisted 4 prior iters, and this session's one-batch-behind tool latency + context spent on
reading made authoring+verifying it infeasible; a partial sorry pin is forbidden, so no safe
code change existed.** No comments-only "progress" is claimed.

## Recommendation to planner (matches pre-committed FAIL correctives)
Per PROGRESS.md iter-231 HARD GATE FAIL chain (no fifth re-scope):
1. **Pivot the inverse OFF the dual** — object-gluing route II for `exists_tensorObj_inverse`
   (`informal/exists_tensorObj_inverse.md`): glue the canonical local contractions
   `(L ⊗ dual L)|_{Uᵢ} ≅ 𝒪_{Uᵢ}` via the A-bridge + `isIso_of_isIso_restrict` (B, already
   axiom-clean, L2062). This still needs `dual_isLocallyTrivial` (hence `dual_restrict_iso`),
   so it does not actually dodge the C-bridge — flag this honestly.
2. **File-split** `TensorObjSubstrate.lean` (quarantine the vestigial whiskering/stalk
   apparatus L426–725 + the dead slice-site root L2264–2375) so the C-bridge build gets a small
   dedicated file and parallel provers can work — and so the next attempt is not paying the
   context cost of re-reading 2375 lines.
3. If continuing on the dual: sanction `dual_restrict_iso` as an EXPLICIT multi-iter sub-build
   with its own file, and have the first iter land ONLY the per-`V` slice equivalence
   `Over_Y V ≌ Over_X (f.opensFunctor V)` as a standalone axiom-clean def (the one piece with
   no module-coherence risk), so each iter can pass the "axiom-clean sub-lemma" bar incrementally.
